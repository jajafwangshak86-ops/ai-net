"use client";

import { useState, useEffect } from "react";
import { usePathname, useRouter } from "next/navigation";
import { Sidebar } from "@/components/layout/sidebar";
import { Header } from "@/components/layout/header";
import { useMiniPay } from "@/hooks/use-minipay";
import { MiniPayBanner } from "@/components/layout/minipay-banner";

export function AppShell({ children }: { children: React.ReactNode }) {
  const [sidebarOpen, setSidebarOpen] = useState(false);
  const [detected, setDetected] = useState(false);
  const { isMiniPay, address: miniPayAddress } = useMiniPay();
  const pathname = usePathname();
  const router = useRouter();

  useEffect(() => {
    setDetected(true);
  }, []);

  useEffect(() => {
    if (detected && isMiniPay && pathname !== "/mini") {
      router.replace("/mini");
    }
  }, [detected, isMiniPay, pathname, router]);

  // /mini renders its own full-page layout
  if (pathname === "/mini") {
    return <>{children}</>;
  }

  // Suppress desktop shell while MiniPay detection runs
  if (!detected) {
    return (
      <div
        className="min-h-screen flex items-center justify-center"
        style={{ background: "#07070f" }}
        role="status"
        aria-label="Loading"
      >
        <div className="w-5 h-5 rounded-full border-2 border-cyan-500 border-t-transparent animate-spin" aria-hidden="true" />
      </div>
    );
  }

  return (
    <div className="flex min-h-screen">
      {!isMiniPay && (
        <Sidebar mobileOpen={sidebarOpen} onClose={() => setSidebarOpen(false)} />
      )}
      <div className="flex-1 flex flex-col min-w-0">
        <Header
          onMenuClick={() => setSidebarOpen(true)}
          isMiniPay={isMiniPay}
          miniPayAddress={miniPayAddress}
        />
        <main className="flex-1 p-3 md:p-6 overflow-auto pb-24" role="main">
          {children}
        </main>
      </div>
      <MiniPayBanner />
    </div>
  );
}
