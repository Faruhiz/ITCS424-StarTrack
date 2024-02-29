class APIError extends Error {
    /**
   * Constructs a new instance of the HoyolabError class with the specified message.
   *
   * @param message The message to associate with this error.
   */
  constructor(message, code, http) {
    super(message)
    /**
     * The name of this error.
     */
    __publicField(this, "name")
    /**
     * The message associated with this error.
     */
    __publicField(this, "message")
    /**
     * The HTTP object
     */
    __publicField(this, "http")
    /**
     * The error code
     */
    __publicField(this, "code")
    this.name = this.constructor.name
    this.message = message
    this.code = code
    this.http = http
    Error.captureStackTrace(this, this.constructor)
  }
}

module.exports = {
    APIError
}