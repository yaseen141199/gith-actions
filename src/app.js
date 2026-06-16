function greet(name) {
  return "Hello, " + name + "!";
}

function generate(count, value) {
  if (count < 0) {
    throw new Error("count must be non-negative");
  }

  return Array.from({ length: count }, (__, index) =>
    typeof value === "function" ? value(index) : value,
  );
}
