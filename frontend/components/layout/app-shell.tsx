"use client";

import { useState } from "react";
import { Sidebar } from "@/components/layout/sidebar";
import { Header } from "@/components/layout/header";
import { useMiniPay } from "@/hooks/use-minipay";
import { MiniPayBanner } from "@/components/layout/minipay-banner";

export function AppShell({ children }: { children: React.ReactNode }) {
  const [sidebarOpen, setSidebarOpen] = useState(false);
  const { isMiniPay, address: miniPayAddress } = useMiniPay();

  return (
    <div className="flex min-h-screen">
      {!isMiniPay && <Sidebar mobileOpen={sidebarOpen} onClose={() => setSidebarOpen(false)} />}
      <div className="flex-1 flex flex-col min-w-0">
        <Header
          onMenuClick={() => setSidebarOpen(true)}
          isMiniPay={isMiniPay}
          miniPayAddress={miniPayAddress}
        />
        <main className="flex-1 p-3 md:p-6 overflow-auto pb-24">{children}</main>
      </div>
      <MiniPayBanner />
    </div>
  );
}
