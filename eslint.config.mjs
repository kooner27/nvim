import globals from "globals";
import pluginJs from "@eslint/js"; // JavaScript plugin and recommended config
import tseslintPlugin from "@typescript-eslint/eslint-plugin"; // TypeScript plugin and recommended config
import tseslintParser from "@typescript-eslint/parser"; // TypeScript parser
import prettierPlugin from "eslint-plugin-prettier"; // Prettier plugin
// import prettierConfig from "eslint-config-prettier"; // Prettier config
// we can use prettierConfig to disable eslint rules that overlap with prettier rules

/** @type {import('eslint').Linter.FlatConfig[]} */
export default [
  // Configuration for JavaScript files
  {
    files: ["**/*.js", "**/*.mjs", "**/*.cjs"], // Target JS files
    languageOptions: {
      globals: { ...globals.browser, ...globals.node },
      ecmaVersion: 2020,
      sourceType: "module",
    },
    plugins: {
      prettier: prettierPlugin, // Include Prettier for formatting
    },
    rules: {
      ...pluginJs.configs.recommended.rules, // Use recommended JS rules
      "prettier/prettier": "error", // Enforce Prettier formatting
    },
  },
  // Configuration for TypeScript files
  {
    files: ["**/*.ts", "**/*.tsx"], // Target TS files
    languageOptions: {
      globals: { ...globals.browser, ...globals.node },
      parser: tseslintParser, // Use TypeScript parser
      ecmaVersion: 2020,
      sourceType: "module",
    },
    plugins: {
      prettier: prettierPlugin, // Include Prettier
      "@typescript-eslint": tseslintPlugin, // Include TypeScript rules
    },
    rules: {
      ...tseslintPlugin.configs.recommended.rules, // Use recommended TS rules
      "prettier/prettier": "error", // Enforce Prettier formatting
    },
  },
];
