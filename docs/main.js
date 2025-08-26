// ++++++++ AUTO GENERATED FILE ++++++++
    
// List of themes you want to cycle through
const themes = ['theme1', 'theme2', 'theme3', 'theme4', 'theme5', 'theme6', 'theme7', 'theme8', 'theme9'];

// Apply theme & mode to the <html> element
function setTheme(theme, mode) {
  document.documentElement.setAttribute('data-theme', theme);
  document.documentElement.setAttribute('data-mode', mode);

  // Save preferences
  localStorage.setItem('theme', theme);
  localStorage.setItem('mode', mode);
}

// Detect system dark mode preference
function getSystemMode() {
  return window.matchMedia('(prefers-color-scheme: dark)').matches ? 'dark' : 'light';
}

// Load saved settings or fall back to defaults
function initTheme() {
  const savedTheme = localStorage.getItem('theme');
  const savedMode = localStorage.getItem('mode');

  if (savedTheme && savedMode) {
    setTheme(savedTheme, savedMode);
  } else {
    setTheme('theme1', getSystemMode());
  }
}

// Toggle between light and dark mode (for current theme)
function toggleMode() {
  const currentMode = document.documentElement.getAttribute('data-mode');
  const newMode = currentMode === 'light' ? 'dark' : 'light';
  setTheme(document.documentElement.getAttribute('data-theme'), newMode);
}

// Change to a different theme, keeping the current mode
function changeTheme(newTheme) {
  const currentMode = document.documentElement.getAttribute('data-mode');
  setTheme(newTheme, currentMode);
}

// Cycle through themes
function cycleTheme() {
  const currentTheme = document.documentElement.getAttribute('data-theme');
  const currentIndex = themes.indexOf(currentTheme);
  const nextIndex = (currentIndex + 1) % themes.length;
  changeTheme(themes[nextIndex]);
}

document.documentElement.classList.add('no-transitions');

// Run at page-load
document.addEventListener('DOMContentLoaded', () => {
  initTheme();
  
  // Allow transitions after a tiny delay
  requestAnimationFrame(() => {
    document.documentElement.classList.remove('no-transitions');
  });

  // Theme cycle button
  const themeButton = document.getElementById('theme-button');
  if (themeButton) {
    themeButton.addEventListener('click', cycleTheme);
  }

  // Light/Dark toggle button
  const modeButton = document.getElementById('mode-button');
  if (modeButton) {
    modeButton.addEventListener('click', toggleMode);
  }
});

// Expose functions globally (optional)
window.setTheme = setTheme;
window.toggleMode = toggleMode;
window.changeTheme = changeTheme;
window.cycleTheme = cycleTheme;
    