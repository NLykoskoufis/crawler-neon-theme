// Greetings in a few languages, with enough TypeScript in it to show a colour theme.
type Language = "en" | "el" | "fr";

interface Greeting {
  readonly language: Language;
  readonly template: string;
}

const DEFAULT_TARGET = "World";
const MAX_WIDTH = 42;

class Greeter {
  private readonly greetings: readonly Greeting[];
  private readonly width: number;
  private count = 0;

  constructor(greetings: readonly Greeting[], width: number = MAX_WIDTH) {
    this.greetings = greetings;
    this.width = width;
  }

  get languages(): Set<Language> {
    return new Set(this.greetings.map((greeting) => greeting.language));
  }

  greet(target: string = DEFAULT_TARGET): string[] {
    const lines = this.greetings.map(({ template }) => template.replace("{target}", target));
    this.count += lines.length;
    if (lines.some((line) => line.length > this.width)) {
      throw new RangeError(`a greeting exceeds ${this.width} characters`);
    }
    return lines;
  }

  async greetLater(target?: string, delayMs = 10): Promise<string[]> {
    await new Promise<void>((resolve) => setTimeout(resolve, delayMs));
    return this.greet(target);
  }

  get total(): number {
    return this.count;
  }
}

async function main(argv: string[]): Promise<number> {
  const target = argv[2] ?? DEFAULT_TARGET;
  const greeter = new Greeter([
    { language: "en", template: "Hello, {target}!" },
    { language: "el", template: "Γεια σου, {target}!" },
    { language: "fr", template: "Bonjour, {target} !" },
  ]);
  const lines = await greeter.greetLater(target);
  lines.forEach((line, index) => console.log(`${String(index + 1).padStart(2)}. ${line}`));
  console.log(`-- ${greeter.total} greetings in ${greeter.languages.size} languages`);
  return 0;
}

main(process.argv).then((code) => process.exit(code));
