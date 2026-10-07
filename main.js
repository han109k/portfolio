// Visitor ⇄ recruiter view switch.
// Order of precedence: ?view= in the URL → last choice (localStorage) → "visitor".
// Share  https://your-site/?view=recruiter  with recruiters to open the résumé view directly.

(function () {
  const VIEWS = ["visitor", "recruiter"];
  const root = document.documentElement;
  const buttons = document.querySelectorAll("[data-set-view]");

  function readSaved() {
    try {
      return localStorage.getItem("view");
    } catch (e) {
      return null;
    }
  }

  function setView(view, { updateUrl = true } = {}) {
    if (!VIEWS.includes(view)) view = "visitor";
    root.dataset.view = view;

    buttons.forEach((btn) => {
      btn.setAttribute("aria-pressed", String(btn.dataset.setView === view));
    });

    try {
      localStorage.setItem("view", view);
    } catch (e) {}

    if (updateUrl) {
      const url = new URL(location.href);
      url.searchParams.set("view", view);
      history.replaceState(null, "", url);
    }
  }

  const fromUrl = new URLSearchParams(location.search).get("view");
  setView(fromUrl || readSaved() || "visitor", { updateUrl: Boolean(fromUrl) });

  buttons.forEach((btn) => {
    btn.addEventListener("click", () => {
      setView(btn.dataset.setView);
      window.scrollTo({
        top: 0,
        behavior: matchMedia("(prefers-reduced-motion: reduce)").matches
          ? "auto"
          : "smooth",
      });
    });
  });

  // Light ⇄ dark toggle.
  // Follows the device setting until the visitor picks one; the pick is remembered.
  const themeToggle = document.querySelector("[data-theme-toggle]");
  const prefersDark = matchMedia("(prefers-color-scheme: dark)");

  function currentTheme() {
    return root.dataset.theme || (prefersDark.matches ? "dark" : "light");
  }

  function updateThemeLabel() {
    if (!themeToggle) return;
    const next = currentTheme() === "dark" ? "light" : "dark";
    themeToggle.setAttribute("aria-label", `switch to ${next} mode`);
  }

  if (themeToggle) {
    themeToggle.addEventListener("click", () => {
      const next = currentTheme() === "dark" ? "light" : "dark";
      root.dataset.theme = next;
      try {
        localStorage.setItem("theme", next);
      } catch (e) {}
      updateThemeLabel();
    });
    prefersDark.addEventListener("change", updateThemeLabel);
    updateThemeLabel();
  }

  // Keep the footer year current
  const year = document.getElementById("year");
  if (year) year.textContent = new Date().getFullYear();
})();
