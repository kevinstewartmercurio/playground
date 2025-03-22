// Setup: https://webreaper.dev/posts/astro-prettier-tailwind-setup/
module.exports = {
    plugins: ["prettier-plugin-astro", "prettier-plugin-tailwindcss"],
    overrides: [
      {
        files: "*.astro",
        options: {
          parser: "astro",
        },
      },
    ],
  };