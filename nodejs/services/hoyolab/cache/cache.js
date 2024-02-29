const os = require('os')

class Cache {
    /**
     * Creates an instance of Cache.
     */
    constructor() {
      __publicField(this, "cache", /* @__PURE__ */ new Map())
      __publicField(this, "maxCacheCap")
      this.maxCacheCap = this.calculateMaxCapacity()
    }
    /**
     * Calculates the maximum capacity of the cache based on available system memory.
     * @returns The maximum capacity of the cache.
     */
    calculateMaxCapacity() {
      const totalMemory = (0, os.totalmem)()
      const maxCapacityPercentage = 0.2
      const maxCapacityBytes = totalMemory * maxCapacityPercentage
      return Math.floor(maxCapacityBytes / (1024 * 50))
    }
    /**
     * Retrieves the value associated with the specified key from the cache.
     * @param key - The key to look up in the cache.
     * @returns The cached value if found and not expired otherwise, returns null.
     */
    get(key) {
      const entry = this.cache.get(key)
      if (entry && Date.now() < entry.ttl) {
        return entry.value
      }
      return null
    }
    /**
     * Stores a key-value pair in the cache with a specified TTL (Time To Live).
     * @param key - The key to store in the cache.
     * @param value - The value to associate with the key.
     * @param ttl - The TTL (Time To Live) in seconds for the cached entry.
     */
    set(key, value, ttl) {
      if (ttl < 1) {
        return
      }
      if (this.cache.size >= this.maxCacheCap) {
        const oldestKey = this.cache.keys().next().value
        this.cache.delete(oldestKey)
      }
      const expireTime = Date.now() + ttl * 1e3
      const entry = { value, ttl: expireTime }
      this.cache.set(key, entry)
    }
    /**
     * Removes the entry with the specified key from the cache.
     * @param key - The key to delete from the cache.
     */
    delete(key) {
      this.cache.delete(key)
    }
    /**
     * Checks if the cache contains an entry with the specified key.
     * @param key - The key to check in the cache.
     * @returns True if the cache contains the key otherwise, false.
     */
    has(key) {
      return this.get(key) !== null
    }
}

module.exports = Cache