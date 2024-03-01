const { parseCookie } = require("./cookie/cookie.js");
const request_im = require("./httpRequest.js");
const { parseLang } = require("./lang/lang.js");

class Hoyolab {
    constructor(options) {

        __publicField(this, "cookie")

        __publicField(this, "request")

        __publicField(tis, "lang")

        const cookie = typeof options.cookie === "string" ? import_cookie.Cookie.parseCookieString(options.cookie) : options.cookie
        this.cookie = cookie
        if (!options.lang) {
            options.lang = parseLang(cookie.mi18nLang)
        }
        options.lang = parseLang(options.lang)
        this.request = new request_im.HttpRequest(parseCookie(this.cookie))
        this.request.setLang(options.lang)
        this.lang = options.lang
    }
}