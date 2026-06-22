import { useState } from "react";

export function useLocalStorage<T>(key: string, initial: T) {
  const [value, setValue] = useState<T>(() => {
    if (typeof window === "undefined") return initial;
    try { return JSON.parse(localStorage.getItem(key) ?? "") ?? initial; }
    catch { return initial; }
  });
  const set = (v: T) => { setValue(v); localStorage.setItem(key, JSON.stringify(v)); };
  const remove = () => { setValue(initial); localStorage.removeItem(key); };
  return [value, set, remove] as const;
}
