package demo;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.function.Function;

@Deprecated
public final class Sample<T extends Number> {
  private final List<T> values = new ArrayList<>();

  public Sample(List<T> values) {
    this.values.addAll(values);
  }

  private static boolean ok(Object value) {
    if (value instanceof String text && !text.isBlank()) {
      return true;
    }
    throw new IllegalArgumentException("bad value");
  }

  public <R> R map(Function<T, R> mapper) {
    return mapper.apply(values.get(0));
  }

  public String describe(Object value) {
    return switch (value) {
      case String text -> text.trim();
      case Integer number -> "int:" + number;
      default -> Optional.ofNullable(value).map(Object::toString).orElse("none");
    };
  }

  public enum Kind {
    SIMPLE,
    COMPLEX
  }
}
