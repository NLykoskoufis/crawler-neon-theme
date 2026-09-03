//! Greetings in a few languages, with enough Rust in it to show a colour theme.
use std::fmt;

const DEFAULT_TARGET: &str = "World";
const MAX_WIDTH: usize = 42;

#[derive(Debug, Clone, Copy, PartialEq, Eq, Hash)]
enum Language {
    English,
    Greek,
    French,
}

#[derive(Debug, Clone)]
struct Greeting {
    language: Language,
    template: &'static str,
}

impl Greeting {
    fn render(&self, target: &str) -> String {
        self.template.replace("{target}", target)
    }
}

impl fmt::Display for Greeting {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        write!(f, "{:?}: {}", self.language, self.template)
    }
}

struct Greeter {
    greetings: Vec<Greeting>,
    width: usize,
    count: usize,
}

impl Greeter {
    fn new(greetings: Vec<Greeting>) -> Self {
        Self { greetings, width: MAX_WIDTH, count: 0 }
    }

    fn greet(&mut self, target: &str) -> Result<Vec<String>, String> {
        let lines: Vec<String> = self.greetings.iter().map(|g| g.render(target)).collect();
        if let Some(long) = lines.iter().find(|line| line.chars().count() > self.width) {
            return Err(format!("greeting exceeds {} characters: {long}", self.width));
        }
        self.count += lines.len();
        Ok(lines)
    }
}

fn main() -> Result<(), String> {
    let target = std::env::args().nth(1).unwrap_or_else(|| DEFAULT_TARGET.to_string());
    let mut greeter = Greeter::new(vec![
        Greeting { language: Language::English, template: "Hello, {target}!" },
        Greeting { language: Language::Greek, template: "Γεια σου, {target}!" },
        Greeting { language: Language::French, template: "Bonjour, {target} !" },
    ]);
    for (index, line) in greeter.greet(&target)?.iter().enumerate() {
        println!("{:>2}. {line}", index + 1);
    }
    println!("-- {} greetings", greeter.count);
    Ok(())
}
