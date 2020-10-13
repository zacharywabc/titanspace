module.exports = {
  root: true,
  env: {
    node: true,
  },
  extends: [
    'plugin:vue/essential',
    '@vue/airbnb',
    '@vue/typescript/recommended',
  ],
  parserOptions: {
    ecmaVersion: 2020,
  },
  rules: {
    'no-console': process.env.NODE_ENV === 'production' ? 'warn' : 'off',
    'no-debugger': process.env.NODE_ENV === 'production' ? 'warn' : 'off',
    '@typescript-eslint/no-explicit-any': 0,
    'class-methods-use-this': 0,
    'no-undef': 0,
    'max-len': 0,
    'eqeqeq': 0,
    'no-underscore-dangle': 0,
    'no-param-reassign': 0,
    'no-restricted-globals': 0
  },
};
