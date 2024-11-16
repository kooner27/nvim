import globals from "globals";
import pluginJs from "@eslint/js";
import tseslint from "typescript-eslint";
import tseslintParser from "@typescript-eslint/parser";
import prettierPlugin from "eslint-plugin-prettier"; // Import Prettier plugin
import prettierConfig from "eslint-config-prettier"; // Import Prettier config

/** @type {import('eslint').Linter.FlatConfig[]} */
export default [
  {
    files: ["**/*.{js,mjs,cjs,ts,tsx}"], // Include JavaScript and TypeScript files
    languageOptions: {
      globals: { ...globals.browser, ...globals.node },
      parser: tseslintParser, // Use TypeScript parser
    },
    rules: {
      "prettier/prettier": "error", // Report Prettier issues as ESLint errors
    },
    plugins: {
      prettier: prettierPlugin, // Prettier plugin for ESLint
    },
  },
  pluginJs.configs.recommended, // Recommended ESLint rules for JavaScript
  ...tseslint.configs.recommended, // Recommended ESLint rules for TypeScript
  {
    rules: {
      ...prettierConfig.rules, // Disable ESLint rules that conflict with Prettier
    },
  },
];
