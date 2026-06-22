import { useState, useEffect } from "react";

export function useScroll() {
  const [scrollY, setScrollY] = useState(0);
  const [scrolled, setScrolled] = useState(false);
  useEffect(() => {
    const handler = () => { setScrollY(window.scrollY); setScrolled(window.scrollY > 10); };
    window.addEventListener("scroll", handler, { passive: true });
    return () => window.removeEventListener("scroll", handler);
  }, []);
  return { scrollY, scrolled };
}
