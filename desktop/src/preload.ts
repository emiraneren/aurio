import { contextBridge, ipcRenderer } from "electron";

// The only bridge between the web app and the desktop shell.
contextBridge.exposeInMainWorld("aurioDesktop", {
  platform: process.platform,
  setTheme: (theme: "dark" | "light") => ipcRenderer.send("aurio:theme", theme),
  setLanguage: (lang: string) => ipcRenderer.send("aurio:lang", lang),
  retry: () => ipcRenderer.send("aurio:retry"),
});
