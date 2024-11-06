// See the Tailwind configuration guide for advanced usage
// https://tailwindcss.com/docs/configuration

const plugin = require("tailwindcss/plugin");
const fs = require("fs");
const path = require("path");

module.exports = {
  content: [
    "./js/**/*.js",
    "../lib/*_web.ex",
    "../lib/*_web/**/*.*ex",
  ],
  theme: {
    extend: {
      colors: {
        "charcoal": {
          DEFAULT: "#394053",
          100: "#0b0d10",
          200: "#161921",
          300: "#212631",
          400: "#2d3242",
          500: "#394053",
          600: "#56617e",
          700: "#7a85a5",
          800: "#a6aec3",
          900: "#d3d6e1",
        },
        "anti-flash_white": {
          DEFAULT: "#eef0f2",
          100: "#2a3036",
          200: "#53606c",
          300: "#81909e",
          400: "#b8c0c8",
          500: "#eef0f2",
          600: "#f1f3f4",
          700: "#f5f6f7",
          800: "#f8f9fa",
          900: "#fcfcfc",
        },
        "silver": {
          DEFAULT: "#c6c7c4",
          100: "#282826",
          200: "#4f514c",
          300: "#777972",
          400: "#9ea09a",
          500: "#c6c7c4",
          600: "#d1d1cf",
          700: "#dcdddb",
          800: "#e8e8e7",
          900: "#f3f4f3",
        },
        "rose_quartz": {
          DEFAULT: "#a2999e",
          100: "#211e20",
          200: "#423c40",
          300: "#645a5f",
          400: "#85787f",
          500: "#a2999e",
          600: "#b5aeb2",
          700: "#c8c2c5",
          800: "#dad6d8",
          900: "#edebec",
        },
        "cornell_red": {
          DEFAULT: "#a8201a",
          100: "#220705",
          200: "#430d0a",
          300: "#651410",
          400: "#861b15",
          500: "#a8201a",
          600: "#dd2d24",
          700: "#e5625b",
          800: "#ee9692",
          900: "#f6cbc8",
        },
      },
    },
  },
  plugins: [
    require("@tailwindcss/forms"),
    require("@tailwindcss/typography"),
    // Allows prefixing tailwind classes with LiveView classes to add rules
    // only when LiveView classes are applied, for example:
    //
    //     <div class="phx-click-loading:animate-ping">
    //
    plugin(({ addVariant }) =>
      addVariant("phx-no-feedback", [".phx-no-feedback&", ".phx-no-feedback &"])
    ),
    plugin(({ addVariant }) =>
      addVariant("phx-click-loading", [
        ".phx-click-loading&",
        ".phx-click-loading &",
      ])
    ),
    plugin(({ addVariant }) =>
      addVariant("phx-submit-loading", [
        ".phx-submit-loading&",
        ".phx-submit-loading &",
      ])
    ),
    plugin(({ addVariant }) =>
      addVariant("phx-change-loading", [
        ".phx-change-loading&",
        ".phx-change-loading &",
      ])
    ),

    // Embeds Heroicons (https://heroicons.com) into your app.css bundle
    // See your `CoreComponents.icon/1` for more information.
    //
    plugin(function ({ matchComponents, theme }) {
      let iconsDir = path.join(__dirname, "./vendor/heroicons/optimized");
      let values = {};
      let icons = [
        ["", "/24/outline"],
        ["-solid", "/24/solid"],
        ["-mini", "/20/solid"],
      ];
      icons.forEach(([suffix, dir]) => {
        fs.readdirSync(path.join(iconsDir, dir)).map((file) => {
          let name = path.basename(file, ".svg") + suffix;
          values[name] = { name, fullPath: path.join(iconsDir, dir, file) };
        });
      });
      matchComponents({
        "hero": ({ name, fullPath }) => {
          let content = fs.readFileSync(fullPath).toString().replace(
            /\r?\n|\r/g,
            "",
          );
          return {
            [`--hero-${name}`]: `url('data:image/svg+xml;utf8,${content}')`,
            "-webkit-mask": `var(--hero-${name})`,
            "mask": `var(--hero-${name})`,
            "mask-repeat": "no-repeat",
            "background-color": "currentColor",
            "vertical-align": "middle",
            "display": "inline-block",
            "width": theme("spacing.5"),
            "height": theme("spacing.5"),
          };
        },
      }, { values });
    }),
  ],
};
