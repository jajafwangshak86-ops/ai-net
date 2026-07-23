import { cn } from "@/lib/utils";

interface SkeletonProps {
  className?: string;
}

export function Skeleton({ className }: SkeletonProps) {
  return <div className={cn("skeleton", className)} />;
}

export function CardSkeleton({ className }: SkeletonProps) {
  return (
    <div className={cn("glass-card p-5 space-y-3", className)}>
      <div className="flex items-center gap-3">
        <Skeleton className="w-11 h-11 rounded-xl flex-shrink-0" />
        <div className="space-y-2 flex-1">
          <Skeleton className="h-4 w-24" />
          <Skeleton className="h-3 w-16" />
        </div>
      </div>
      <Skeleton className="h-3 w-full" />
      <Skeleton className="h-3 w-3/4" />
      <div className="flex gap-2 pt-2">
        <Skeleton className="h-5 w-16 rounded-md" />
        <Skeleton className="h-5 w-12 rounded-md" />
      </div>
    </div>
  );
}

export function StatCardSkeleton({ className }: SkeletonProps) {
  return (
    <div className={cn("glass-card p-5 space-y-3", className)}>
      <Skeleton className="w-9 h-9 rounded-lg" />
      <Skeleton className="h-7 w-20" />
      <Skeleton className="h-3 w-24" />
    </div>
  );
}

export function TableSkeleton({ rows = 5, className }: SkeletonProps & { rows?: number }) {
  return (
    <div className={cn("space-y-2", className)}>
      {Array.from({ length: rows }).map((_, i) => (
        <div key={i} className="flex items-center gap-4 p-3 rounded-lg">
          <Skeleton className="h-4 flex-1" />
          <Skeleton className="h-4 w-20" />
          <Skeleton className="h-4 w-16" />
        </div>
      ))}
    </div>
  );
}
