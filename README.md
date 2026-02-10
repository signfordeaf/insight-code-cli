# Insight CLI

Offline accessibility code analysis tool for **Flutter**, **iOS (UIKit)**, and **SwiftUI** projects.

Scans your source code against 160+ accessibility rules and generates detailed reports with actionable recommendations — all without sending data to external servers.

## Features

- **Offline Analysis** — No data leaves your machine
- **Multi-Platform** — Flutter, iOS (UIKit), SwiftUI, and hybrid projects
- **160+ Rules** — WCAG 2.1 Level A & AA compliance checks
- **Scoring System** — 0-100 accessibility score with A-F grades
- **Multiple Formats** — JSON, HTML, SARIF (GitHub Code Scanning)
- **CI/CD Ready** — GitHub Actions, GitLab CI, Jenkins
- **Encrypted Rules** — Built-in AES-256-GCM encrypted rule engine

## Quick Install

```bash
curl -sSL https://raw.githubusercontent.com/signfordeaf/insight-code-cli/main/install.sh | bash
```

### Manual Download

| Platform | Architecture | Download |
|----------|-------------|----------|
| macOS | Apple Silicon (M1/M2/M3) | [Download](https://github.com/signfordeaf/insight-code-cli/releases/latest) |
| macOS | Intel | [Download](https://github.com/signfordeaf/insight-code-cli/releases/latest) |
| Linux | amd64 | [Download](https://github.com/signfordeaf/insight-code-cli/releases/latest) |
| Linux | arm64 | [Download](https://github.com/signfordeaf/insight-code-cli/releases/latest) |
| Windows | amd64 | [Download](https://github.com/signfordeaf/insight-code-cli/releases/latest) |
| Windows | arm64 | [Download](https://github.com/signfordeaf/insight-code-cli/releases/latest) |

### Verify Installation

```bash
insight version
```

## Usage

### Scan a Project

```bash
# Basic scan (auto-detect platform)
insight scan ./my-flutter-app

# Specify platform
insight scan ./my-ios-app --platform ios

# HTML report
insight scan ./my-swiftui-app --format html --output report.html

# SARIF output (GitHub Code Scanning)
insight scan ./my-project --format sarif --output results.sarif

# CI mode (exit code 1 if score < threshold)
insight scan ./my-app --ci --min-score 70
```

### List Available Rules

```bash
# All rules
insight rules

# Platform-specific
insight rules --platform flutter
insight rules --platform swiftui

# Filter by severity
insight rules --severity critical
```

### Initialize Config

```bash
# Create .insight.yml in your project
insight init
```

### Command Reference

| Command | Description |
|---------|-------------|
| `insight scan <path>` | Scan project for accessibility issues |
| `insight rules` | List available accessibility rules |
| `insight init` | Initialize configuration file |
| `insight version` | Show version information |

### Scan Options

| Flag | Description | Default |
|------|-------------|---------|
| `--format` | Output format: `json`, `html`, `sarif` | `json` |
| `--output` | Write report to file | stdout |
| `--platform` | Force platform: `flutter`, `ios`, `swiftui` | auto-detect |
| `--severity` | Minimum severity: `info`, `warning`, `error`, `critical` | all |
| `--min-score` | Minimum passing score (0-100) | `0` |
| `--ci` | CI mode (non-zero exit on failure) | `false` |
| `--verbose` | Verbose output | `false` |

## CI/CD Integration

### GitHub Actions

```yaml
name: Accessibility Check
on: [push, pull_request]

jobs:
  accessibility:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      
      - name: Install Insight CLI
        run: curl -sSL https://raw.githubusercontent.com/signfordeaf/insight-code-cli/main/install.sh | bash
      
      - name: Run Accessibility Scan
        run: insight scan . --format sarif --output results.sarif --ci --min-score 60
      
      - name: Upload SARIF
        if: always()
        uses: github/codeql-action/upload-sarif@v3
        with:
          sarif_file: results.sarif
```

### GitLab CI

```yaml
accessibility:
  image: ubuntu:latest
  script:
    - curl -sSL https://raw.githubusercontent.com/signfordeaf/insight-code-cli/main/install.sh | bash
    - insight scan . --ci --min-score 60
```

## Scoring System

| Grade | Score Range | Description |
|-------|-----------|-------------|
| A | 90-100 | Excellent accessibility |
| B | 80-89 | Good, minor improvements needed |
| C | 70-79 | Fair, several issues to address |
| D | 60-69 | Poor, significant work needed |
| F | 0-59 | Critical accessibility gaps |

## License

Proprietary — © 2024 SignForDeaf. All rights reserved.
