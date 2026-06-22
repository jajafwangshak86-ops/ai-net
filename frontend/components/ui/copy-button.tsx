"use client";
import { Check, Copy } from "lucide-react";
import { useCopy } from "@/hooks/use-copy";

export function CopyButton({ text, className = "" }: { text: string; className?: string }) {
  const { copied, copy } = useCopy();
  return (
    <button onClick={() => copy(text)} className={`icon-btn transition-smooth ${className}`} title="Copy">
      {copied ? <Check className="icon-sm text-green-400" /> : <Copy className="icon-sm" />}
    </button>
  );
}
