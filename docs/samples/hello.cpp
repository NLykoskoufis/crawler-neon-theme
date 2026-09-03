// Greetings in a few languages, with enough C++ in it to show a colour theme.
#include <cstdint>
#include <iostream>
#include <string>
#include <string_view>
#include <vector>

namespace crawler {

constexpr std::string_view kDefaultTarget = "World";
constexpr std::size_t kMaxWidth = 42;

enum class Language : std::uint8_t { English, Greek, French };

struct Greeting {
    Language language;
    std::string_view prefix;
    std::string_view suffix;

    [[nodiscard]] std::string render(std::string_view target) const {
        return std::string{prefix} + std::string{target} + std::string{suffix};
    }
};

class Greeter {
public:
    explicit Greeter(std::vector<Greeting> greetings, std::size_t width = kMaxWidth)
        : greetings_{std::move(greetings)}, width_{width} {}

    template <typename Sink>
    void greet(std::string_view target, Sink&& sink) {
        for (const auto& greeting : greetings_) {
            const std::string line = greeting.render(target);
            if (line.size() > width_) {
                throw std::length_error("a greeting exceeds the maximum width");
            }
            sink(++count_, line);
        }
    }

    [[nodiscard]] int count() const noexcept { return count_; }

private:
    std::vector<Greeting> greetings_;
    std::size_t width_;
    int count_ = 0;
};

}  // namespace crawler

int main(int argc, char** argv) {
    const std::string_view target = argc > 1 ? argv[1] : crawler::kDefaultTarget;
    crawler::Greeter greeter{{
        {crawler::Language::English, "Hello, ", "!"},
        {crawler::Language::Greek, "Γεια σου, ", "!"},
        {crawler::Language::French, "Bonjour, ", " !"},
    }};
    greeter.greet(target, [](int index, const std::string& line) {
        std::cout << index << ". " << line << '\n';
    });
    std::cout << "-- " << greeter.count() << " greetings\n";
    return 0;
}
