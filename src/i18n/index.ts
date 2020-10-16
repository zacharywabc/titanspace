import zh from './zh';
import en from './en';

const langs: Record<string, any> = {
  zh,
  en,
};

Object.keys(langs).forEach((k) => {
  langs[k.split('-')[0]] = langs[k];
});

langs.default = langs.en;

export { langs };

export default function (lang: string) {
  return (key: string) => langs[lang]?.[key] || langs.default[key] || key;
}
