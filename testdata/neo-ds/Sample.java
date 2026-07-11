package demo;

import java.util.List;

public final class Sample {
  private static boolean ok(Object value) {
    if (value instanceof String) {
      return true;
    }
    throw new RuntimeException("nope");
  }
}
