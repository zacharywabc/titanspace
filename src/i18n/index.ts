import zh from './zh';

const langs: Record<string, any> = {
  'zh-CN': zh,
  en: {
    DEFI: 'DeFi',
  },
};

Object.keys(langs).forEach((k) => {
  langs[k.split('-')[0]] = langs[k];
});

langs.default = langs['zh-CN'];

export { langs };

export default function (lang: string) {
  return (key: string) => langs[lang]?.[key] || langs.default[key] || key;
}
