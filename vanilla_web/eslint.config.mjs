import globals from "globals";
import pluginJs from "@eslint/js"; // JavaScript plugin and recommended config
import tseslintPlugin from "@typescript-eslint/eslint-plugin"; // TypeScript plugin and recommended config
import tseslintParser from "@typescript-eslint/parser"; // TypeScript parser
import prettierPlugin from "eslint-plugin-prettier"; // Prettier plugin
import prettierConfig from "eslint-config-prettier"; // Prettier config
import htmlPlugin from "eslint-plugin-html"; // lint js inside html

/** @type {import('eslint').Linter.FlatConfig[]} */
export default [
  // Configuration for JavaScript files
  {
    files: ["**/*.js", "**/*.jsx"], // Target JS files
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
      "prettier/prettier": [
        "warn",
        {
          trailingComma: "es5", // Prettier option for trailing commas
        },
      ],
      "no-unused-vars": "off",
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
      "prettier/prettier": "warn", // Enforce Prettier formatting
      "no-unused-vars": "off",
    },
  },
  {
    files: ["**/*.html"],
    plugins: {
      html: htmlPlugin,
    },
    processor: "html/html", // Use the HTML processor for embedded JavaScript
    rules: {
      // JavaScript rules apply to <script> blocks
      "no-unused-vars": "off",
      "prettier/prettier": "warn",
    },
  },
  prettierConfig, // Add Prettier configuration
  prettierConfig, // Add this to disable conflicting rules
];

