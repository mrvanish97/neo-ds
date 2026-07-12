import type { Stats } from "fs";

export interface Item {
  id: string;
  count: number;
}

type LoadState = "idle" | "loading" | "done";

export abstract class Box<T extends Item> {
  public static readonly size = 1;
  protected state: LoadState = "idle";

  constructor(protected readonly item: T) {}

  async method(value: unknown): Promise<boolean> {
    const label = `${this.item.id}:${this.item.count}`;

    if (value instanceof Box && "x" in value) {
      return true;
    }

    const total = [1, 2, 3].map((n) => n * this.item.count);
    if (!label) {
      throw new Error("missing");
    }
    return total.length > 0 && label.length > 0;
  }

  abstract render(stats: Stats | null): string;
}

export class Widget extends Box<Item> {
  override render(stats: Stats | null): string {
    const extra = stats?.isFile() ? "file" : "other";
    return `${this.item.id}-${extra}`;
  }
}
