const langEnum = require('./lang-interface')

class Language {
    /**
   * Parses a language string into its corresponding LanguageEnum value.
   *
   * @param lang The language string to parse, or null/undefined to default to English.
   * @returns The LanguageEnum value corresponding to the provided string, or English if the string is invalid or undefined.
   */
  static parseLang(lang) {
    if (!lang) {
      return langEnum.LanguageEnum.ENGLISH;
    }
    const langKeys = Object.keys(langEnum.LanguageEnum);
    const matchingKey = langKeys.find(
      (key) => langEnum.LanguageEnum[key] === lang
    );
    return matchingKey ? langEnum.LanguageEnum[matchingKey] : langEnum.LanguageEnum.ENGLISH;
  }
}

module.exports = Language