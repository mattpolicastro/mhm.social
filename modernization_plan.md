# mhm.social Modernization Plan

Modernization pass modeled after [soundblasterblaster](https://github.com/mattpolicastro/soundblasterblaster) PRs #5, #7, #8, #16.

## PR 1: Migrate to Vue 3 + Vite + Composition API

Branch: `claude/modernize-vue3-vite`

### Build tooling (Vue CLI → Vite)

- Delete `vue.config.js`, `babel.config.js`
- Add `vite.config.js` with `@vitejs/plugin-vue`, `base: '/'`
- Move `public/index.html` → root `index.html`
  - Replace `<%= htmlWebpackPlugin.options.title %>` with `mhm.social`
  - Drop the `<noscript>` webpack boilerplate
  - Keep Google Analytics snippet and Montserrat font import as-is
- Update `package.json`:
  - Remove: `core-js`, `@vue/cli-plugin-babel`, `@vue/cli-plugin-eslint`, `@vue/cli-service`, `babel-eslint`, `eslint`, `eslint-plugin-vue`
  - Add: `vite`, `@vitejs/plugin-vue`
  - Scripts: `serve` → `dev` (vite), `build` → `vite build`, `lint` → remove, `deploy` → remove
  - Remove `eslintConfig` and `browserslist` sections
- Delete `yarn.lock`, generate `package-lock.json` (switch to npm)

### Components (Options API → `<script setup>`)

**App.vue** — convert to `<script setup>`. Auto-registration replaces the `components` block; just import the four components.

**Header.vue** — `data().tagline` → `const tagline = ref('an asocial (not/net)work')`. `mounted()` → `onMounted()` with same random tagline logic.

**Post.vue** — most complex:
- `data()` fields → `ref()` calls (`mhmContent`, `mhmSounds`, `mhmHistory`, `showHistory`, `config` can stay as a plain const)
- `computed.mhmLength` → `const mhmLength = computed(() => mhmContent.value.length)`
- `require.context('../assets/sounds', true, /\.mp3$/)` → `import.meta.glob('../assets/sounds/*.mp3', { query: '?url', eager: true })` — iterate `Object.values()` to build the sounds array
- `mounted()` → `onMounted()`, same localStorage hydration logic
- Methods stay as plain functions; update all `this.x` → `x.value`

**FAQ.vue** — `data().showFAQ` → `const showFAQ = ref(false)`, `toggleFAQ` → plain function.

**Footer.vue** — no script block needed, template-only component.

### Verification

- `npm run dev` serves locally, same appearance and behavior
- `npm run build` produces `dist/` with working app
- Sound playback, post history (localStorage), character counter all work
- No `this.$set`, `require.context`, or Options API patterns remain

---

## PR 2: Deploy via GitHub Actions

Branch: `claude/deploy-github-actions`

- Add `.github/workflows/deploy.yml`:
  - Trigger on push to `main`
  - Jobs: checkout → setup-node → npm ci → npm run build → upload-pages-artifact (path: dist) → deploy-pages
  - Use `actions/checkout`, `actions/setup-node`, `actions/configure-pages`, `actions/upload-pages-artifact`, `actions/deploy-pages`
- Delete `deploy.sh`
- Remove `deploy` script from `package.json` (if not already removed in PR 1)
- **Manual step after merge**: Go to repo Settings → Pages → Source → switch to "GitHub Actions"
- Leave `gh-pages` branch in place as rollback escape hatch

---

## PR 3: Add Dependabot

Branch: `claude/add-dependabot`

- Add `.github/dependabot.yml`:
  ```yaml
  version: 2
  updates:
    - package-ecosystem: npm
      directory: /
      schedule:
        interval: weekly
    - package-ecosystem: github-actions
      directory: /
      schedule:
        interval: weekly
  ```

---

## PR 4: Replace Twitter references with Bluesky

Branch: `claude/replace-twitter-with-bluesky`

Two references remain in `src/components/FAQ.vue`:
- Line 15: `hit me up on <a href="https://twitter.com/mattpolicastro">twitter</a>` → link to `https://bsky.app/profile/mattpolicastro.bsky.social` with text "bluesky"
- Line 17: `let me know on twitter or github` → `let me know on bluesky or github`

---

## Notes

- Each PR should be behavior-preserving (except the Twitter→Bluesky content change)
- CNAME file in `public/` stays as-is for custom domain
- `@vue/compiler-sfc` may need a version bump to match the installed Vue 3 version — check compatibility
