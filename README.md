# Claude CLI Directives

Personal collection of reusable Claude Code commands and workflow configurations.

## Installation and Usage

### Setup

1. Clone this repository to your Claude CLI configuration directory:
   ```bash
   git clone <repository-url> ~/.claude
   ```

2. The configuration files will be automatically loaded by Claude Code from the `~/.claude` directory.

### Usage

The directives in this repository are automatically available when using Claude Code. Simply reference them in your conversations:

- Reference instructions using `@instructions/<filename>` 
- Use commands by mentioning them in natural language

### Configuration Structure

```
~/.claude/
├── CLAUDE.md                    # Main configuration file
├── commands/                    # Reusable commands
└── instructions/               # Instruction templates
    ├── git-commit-instructions.md
    ├── wordpress-docker-setup.md
    └── inc/                    # Template files and resources
```

## Commands

- **`ai-git-push`** - Automated git staging, commit, and push workflow

## Instructions

- **`git-commit-instructions.md`** - Conventional commit format guidelines
  - Example: "Commit my changes with a proper conventional commit message"
  - Sample commit messages:
    - `[FEAT]: add user authentication system`
    - `[FIX]: resolve login redirect issue`
    - `[DOCS]: update API documentation`
    - `[REFACTOR]: restructure user service`
- **`wordpress-docker-setup.md`** - WordPress Docker development environment setup
  - Example: "Set up WordPress with Docker for this project"
- **`productivity-rating.md`** - Assess productivity rating of active codebase for given time periods 
  - Example: "Rate my productivity for today" or "Assess my productivity for this week"
