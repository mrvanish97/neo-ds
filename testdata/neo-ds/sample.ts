import { readFile as read } from "fs";

export abstract class Box<T> {
  public static readonly size = 1;

  async method(value: unknown): Promise<boolean> {
    if (value instanceof Box && "x" in value) {
      return true;
    }
    throw new Error("nope");
  }
}
