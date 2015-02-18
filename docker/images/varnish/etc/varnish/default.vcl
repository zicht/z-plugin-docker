# Built at Tue, 23 Dec 2014 09:31:55 +0100: 
# ENV='development'
# CACHE=false
# PORT82=false

import std;

#
# detectdevice.vcl - regex based device detection for Varnish
# http://github.com/lkarsten/varnish-devicedetect/
#
# Author: Lasse Karstensen <lasse@varnish-software.com>

sub devicedetect {
    unset req.http.X-UA-Device;
    set req.http.X-UA-Device = "pc";

    # handle overrides
    if (req.http.Cookie ~ "(i?)X-UA-Device-force") {
        set req.http.X-UA-Device = regsub(req.http.Cookie, "(?i).*X-UA-Device-force=([^;]+).*", "\1");
    } else {
        if    (req.http.User-Agent ~ "(?i)(iphone|ipod)") { set req.http.X-UA-Device = "mobile-iphone"; }
        elsif (req.http.User-Agent ~ "(?i)ipad")        { set req.http.X-UA-Device = "tablet-ipad"; }
        # how do we differ between an android phone and an android tablet?
        # http://stackoverflow.com/questions/5341637/how-do-detect-android-tablets-in-general-useragent
        elsif (req.http.User-Agent ~ "(?i)android.*(mobile|mini)") { set req.http.X-UA-Device = "mobile-android"; }
        # android 3/honeycomb was just about tablet-only, and any phones will probably handle a bigger page layout.
        elsif (req.http.User-Agent ~ "(?i)android 3")              { set req.http.X-UA-Device = "tablet-android"; }
        # may very well give false positives towards android tablets. Suggestions welcome.
        elsif (req.http.User-Agent ~ "(?i)android")         { set req.http.X-UA-Device = "tablet-android"; }

        elsif (req.http.User-Agent ~ "^HTC" ||
            req.http.User-Agent ~ "Fennec" ||
            req.http.User-Agent ~ "IEMobile" ||
            req.http.User-Agent ~ "BlackBerry" ||
            req.http.User-Agent ~ "SymbianOS.*AppleWebKit" ||
            req.http.User-Agent ~ "Opera Mobi") {
            set req.http.X-UA-Device = "mobile-smartphone";
        }
        elsif (req.http.User-Agent ~ "(?i)symbian" ||
            req.http.User-Agent ~ "(?i)^sonyericsson" ||
            req.http.User-Agent ~ "(?i)^nokia" ||
            req.http.User-Agent ~ "(?i)^samsung" ||
            req.http.User-Agent ~ "(?i)^lg" ||
            req.http.User-Agent ~ "(?i)bada" ||
            req.http.User-Agent ~ "(?i)blazer" ||
            req.http.User-Agent ~ "(?i)cellphone" ||
            req.http.User-Agent ~ "(?i)iemobile" ||
            req.http.User-Agent ~ "(?i)midp-2.0" ||
            req.http.User-Agent ~ "(?i)u990" ||
            req.http.User-Agent ~ "(?i)netfront" ||
            req.http.User-Agent ~ "(?i)opera mini" ||
            req.http.User-Agent ~ "(?i)palm" ||
            req.http.User-Agent ~ "(?i)nintendo wii" ||
            req.http.User-Agent ~ "(?i)playstation portable" ||
            req.http.User-Agent ~ "(?i)portalmmm" ||
            req.http.User-Agent ~ "(?i)proxinet" ||
            req.http.User-Agent ~ "(?i)sonyericsson" ||
            req.http.User-Agent ~ "(?i)symbian" ||
            req.http.User-Agent ~ "(?i)windows\ ?ce" ||
            req.http.User-Agent ~ "(?i)winwap" ||
            req.http.User-Agent ~ "(?i)eudoraweb" ||
            req.http.User-Agent ~ "(?i)htc" ||
            req.http.User-Agent ~ "(?i)240x320" ||
            req.http.User-Agent ~ "(?i)avantgo" ||
            req.http.User-Agent ~ "(?i)iris" ||
            req.http.User-Agent ~ "(?i)3g_t" ||
            req.http.User-Agent ~ "(?i)mini 9.5|vx1000|lge |m800|e860|u940|ux840|compal|wireless| mobi|ahong|lg380|lgku|lgu900|lg210|lg47|lg920|lg840|lg370|sam-r|mg50|s55|g83|t66|vx400|mk99|d615|d763|el370|sl900|mp500|samu3|samu4|vx10|xda_|samu5|samu6|samu7|samu9|a615|b832|m881|s920|n210|s700|c-810|_h797|mob-x|sk16d|848b|mowser|s580|r800|471x|v120|rim8|c500foma:|160x|x160|480x|x640|t503|w839|i250|sprint|w398samr810|m5252|c7100|mt126|x225|s5330|s820|htil-g1|fly v71|s302|-x113|novarra|k610i|-three|8325rc|8352rc|sanyo|vx54|c888|nx250|n120|mtk |c5588|s710|t880|c5005|i;458x|p404i|s210|c5100|teleca|s940|c500|s590|foma|samsu|vx8|vx9|a1000|_mms|myx|a700|gu1100|bc831|e300|ems100|me701|me702m-three|sd588|s800|8325rc|ac831|mw200|brew |d88|htc\/|htc_touch|355x|m50|km100|d736|p-9521|telco|sl74|ktouch|m4u\/|me702|8325rc|kddi|phone|lg |sonyericsson|samsung|240x|x320|vx10|nokia|sony cmd|motorola|up.browser|up.link|mmp|symbian|smartphone|midp|wap|vodafone|o2|pocket|kindle|mobile|psp|treo"
            ) {
            set req.http.X-UA-Device = "mobile-generic";
        }

    }
}
// ----------------------------------------------------------------------------------------
// Optimize cookie; remove unused values and and empty cookies
// ----------------------------------------------------------------------------------------
sub normalize_cookie {
    // Don't use cookies for static content
    if (req.url ~ "(?i)\.(jpg|png|gif|gz|tgz|bz2|tbz|mp3|ogg|css|js|doc|pdf)$") {
        unset req.http.Cookie;
    } elseif (req.http.Cookie ~ "SESS[A-Za-z0-9]+" || req.http.Cookie ~ "zCookiePermission") {
        set req.http.X-Cookie = "";

        if (req.http.Cookie ~ "SESS[A-Za-z0-9]+") {
            set req.http.X-Cookie = req.http.X-Cookie + regsuball(req.http.Cookie, ".*(SESS[A-Za-z0-9]+=[^;]+).*", "\1");
        }
        if (req.http.Cookie ~ "zCookiePermission") {
            if (req.http.X-Cookie ~ ".+") {
                set req.http.X-Cookie = req.http.X-Cookie + "; ";
            }
            set req.http.X-Cookie = req.http.X-Cookie + regsuball(req.http.Cookie, ".*(zCookiePermission=[^;]+).*", "\1");
        }

        // remove unwanted whitespace
        set req.http.X-Cookie = regsub(req.http.X-Cookie, "^;\s*", "");
        set req.http.X-Cookie = regsub(req.http.X-Cookie, "^\s+$", "");
        set req.http.Cookie = req.http.X-Cookie;

        unset req.http.X-Cookie;
    } else {
        set req.http.Cookie = "";
    }

    if (req.http.Cookie ~ "^\s*$") {
        unset req.http.Cookie;
    }
}


// ----------------------------------------------------------------------------------------
// Normalize the Accept-Encoding header (see http://varnish-cache.org/wiki/FAQ/Compression)
// ----------------------------------------------------------------------------------------
sub normalize_accept_encoding {
    if (req.http.Accept-Encoding) {
        if (req.http.Accept-Encoding ~ "gzip") {
            set req.http.Accept-Encoding = "gzip";
        } else {
            remove req.http.Accept-Encoding;
        }
    }
}
backend default {
    .host = "nginx";
    .port = "80";
    .connect_timeout = 600s;
    .first_byte_timeout = 600s;
    .between_bytes_timeout = 600s;
}


sub vcl_recv {
    if (req.restarts == 0) {
        if (req.http.x-forwarded-for) {
            set req.http.X-Forwarded-For =
                req.http.X-Forwarded-For + ", " + client.ip;
        } else {
            set req.http.X-Forwarded-For = client.ip;
        }
        set req.http.X-Forwarded-Port = 81;
    }

    // ----------------------------------------------------------------------------------------
    // Check request type
    if (req.request != "GET" && req.request != "HEAD" && req.request != "PUT" && req.request != "POST" &&
        req.request != "TRACE" && req.request != "OPTIONS" && req.request != "DELETE") {
        /* Non-RFC2616 or CONNECT which is weird. */
        return (pipe);
    }


    if ( req.http.Host !~ "concertgebouw.nl.dev|concertvrienden.nl.dev" ) {
        return (pass);
    }
    call devicedetect;

            /* This just makes sure the cookie is not normalized in development environment when debugging is off.
           Varnish will otherwise complain about an used sub. */
        if (req.http.X-Is-Bogus ~ "yes") {
            call normalize_cookie;
        }
    
    if (req.url ~ "^/(event-snippet|snippet-)") {
        unset req.http.Cookie;
        unset req.http.Authorization;
        unset req.http.User-Agent;
    }

            set req.http.Host = regsuball(req.http.Host, ":81", "");
    
    
    call normalize_accept_encoding;

    // Bypass varnish either when cookie is set, or when url is in /tickets/online for server-to-server communication
    if (req.url ~ "^/tickets/" && (req.http.Cookie ~ "SESS" || req.url ~ "^/tickets/online")) {
        return (pass);
    }
    if (req.request != "GET" && req.request != "HEAD") {
        /* We only deal with GET and HEAD by default */
        return (pass);
    }

    
    if (req.http.User-Agent) {
        if ( req.http.Host ~ "concertgebouw.nl.dev") {
    // ----------------------------------------------------------------------------------------
    // Mobile detection
    // see vcl_error to redirect to mobile version of page
    if (
        (req.http.X-UA-Device ~ "^mobile")
        && req.url !~ "^/(event-snippet|snippet-)"
        && req.url !~ "^/tickets"
        && req.url !~ "(?i)\.(jpg|png|gif|gz|tgz|bz2|tbz|mp3|m4a|m4R|ogg|css|js|doc|pdf|eot|woff|ttf|otf|svg)(\?[^/]*)?$"
        && req.url !~ "^/(unsubscribe|x/|live|kaarten|postcode/ajax-getaddress\.php)"
        ) {
        if (!(req.url ~ "^/m/" || req.url ~ "^/m\?" || req.url ~ "^/m$")) {
                            error 752 "http://" + req.http.Host + ":81/m" + req.url;
                    }
    }
    else {
        if (req.url ~ "^/m/" || req.url ~ "^/m\?" || req.url ~ "^/m$") {
                            error 752 "http://" + req.http.Host + ":81" + regsuball(req.url, "^/m(.*)", "\1");
                    }
    }
    set req.grace = 5s;
}
    }

    return (lookup);
}

sub vcl_hash {
    hash_data(req.url);
    if (req.http.host) {
        hash_data(req.http.host);
    } else {
        hash_data(server.ip);
    }

    if (req.http.Cookie) {
        hash_data(req.http.Cookie);
    }
    if (req.http.Authorization) {
        hash_data(req.http.Authorization);
    }

    if (req.url !~ "(?i)\.(jpg|png|gif|gz|tgz|bz2|tbz|mp3|m4a|m4R|ogg|css|js|doc|pdf|eot|woff|ttf|otf|svg)(\?[^/]*)?$") {
        if (req.http.X-Ssl) {
            // the SSL response may contain "https:" references in stead of "http:" so it needs to
            // be cached separately

            hash_data(req.http.X-Ssl);
        }
        if (req.http.Host ~ "concertgebouw.nl.dev" && req.http.X-UA-Device) {
            hash_data(req.http.X-UA-Device);
        }
    }
    return (hash);
}

sub vcl_fetch {
    if (req.url ~ "(?i)\.(jpg|png|gif|gz|tgz|bz2|tbz|mp3|m4a|m4R|ogg|css|js|doc|pdf|eot|woff|ttf|otf|svg)(\?[^/]*)?$" || req.url ~ "^/(event-snippet|snippet-)") {
        remove beresp.http.Set-Cookie;
    } elseif (
        beresp.http.Content-Type ~ "text/html"

        # excluded from esi processing
        && !(
           req.url ~ "(?i)\.(jpg|png|gif|gz|tgz|bz2|tbz|mp3|m4a|m4R|ogg|css|js|doc|pdf|eot|woff|ttf|otf|svg)(\?[^/]*)?$"
        || req.url ~ "\.json$"
        || req.url ~ "^/livesearch.php"
                || req.url ~ "^/(event-snippet|snippet-).*.php"
        || req.url ~ "^/tickets/((nl|en)/)?basket/status"
        || req.url ~ "^/tickets/((nl|en)/)?topnav"
        || req.url ~ "^/tickets/((nl|en)/)?user/login"
        || req.url ~ "^/tickets/((nl|en)/)?user/details"
        || req.url ~ "^/tickets/((nl|en)/)?user/update"
        || req.url ~ "^/tickets/((nl|en)/)?event/price-matrix"
        )
    ) {
        std.log("Performing esi on url: " + req.url);
        set beresp.do_esi = true;
    }

    if (req.http.X-Is-ProxyPass) {
        set beresp.ttl = 0s;
    } elseif (req.http.Cookie !~ "SESS" && beresp.ttl < 900s) {
        if (req.http.url ~ "(?i)\.(jpg|png|gif|gz|tgz|bz2|tbz|mp3|m4a|m4R|ogg|css|js|doc|pdf|eot|woff|ttf|otf|svg)(\?[^/]*)?$") {
            set beresp.ttl = 1d;
        } elseif (req.http.url ~ "^/(event-snippet|snippet-)") {
            set beresp.ttl = 4h;
        } else {
            set beresp.ttl = 900s;
        }
    }

    if (beresp.status >= 500 && beresp.status <= 510) {
        // allow for a TTL if the request could not be processed.
        set beresp.ttl = 2s;
    } elseif(beresp.status >= 300 && beresp.status <= 400) {
        set beresp.ttl = 0s;
    }

    if (req.url ~ "^/live" && beresp.ttl > 60s) {
        set beresp.ttl = 60s;
    }

    if ( (req.http.Cookie || req.http.Authorization) && req.url ~ "^/((node/[^/]+/(edit|webform))|admin|install\.php|update\.php|user(/|$))|tickets/admin") {
        set beresp.ttl = 0s;
    }

    if (beresp.status == 401) {
        set beresp.ttl = 0s;
    }

    std.log(req.url + " has TTL: " + beresp.ttl + "; cookie=" + req.http.Cookie);

    // if SSL, the gzipping is done at the encryption level
    if (req.http.X-Ssl != "on" && beresp.http.Content-Type ~ "^text|application/x-javascript") {
        set beresp.do_gzip = true;
    }

    set beresp.ttl = 0s;

    // never cache a response that contains a Set-Cookie header
    if (beresp.http.Set-Cookie) {
        set beresp.ttl = 0s;
    }
    return (deliver);
}

sub vcl_deliver {

    if (resp.http.Content-Type ~ "text/html") {
        set resp.http.Cache-Control = "no-cache, must-revalidate";
    }
    if (obj.hits > 0) {
        set resp.http.X-Cache = "HIT";
        // fail safe for not serving 'set-cookie' headers.
        remove resp.http.Set-Cookie;
    } else {
        set resp.http.X-Cache = "MISS";
    }
}

sub vcl_error {
    if (obj.status == 752) {
        unset obj.http.location;
        set obj.http.location = obj.response;
        set obj.response = "Found";
        set obj.status = 302;
        return(deliver);
    } else if (obj.status == 751) {
        unset obj.http.location;
        set obj.http.location = obj.response;
        set obj.response = "Moved Permanently";
        set obj.status = 301;
        return(deliver);
    }
}

