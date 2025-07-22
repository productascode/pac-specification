# Product as Code

> Version control for product management for AI-enhanced code generation. Treating product requirements with the same rigor as code itself.

[![Specification Version](https://img.shields.io/badge/spec-v0.0.1-blue.svg)](https://productascode.org/spec)
[![License](https://img.shields.io/badge/license-Apache%202.0-green.svg)](LICENSE)
[![GitHub Stars](https://img.shields.io/github/stars/productascode/spec?style=social)](https://github.com/productascode/pac-spec/stargazers)

Product as Code (PaC) is a methodology and specification for managing product development using GitOps principles. It brings version control, structured data, and AI-native workflows to product management.

## The Problem

**Product requirements are scattered everywhere.** Jira, Confluence, Shortcut, Linear, GitHub Issues, Slack, email, people's heads—there's no single source of truth. When your AI coding assistant needs to understand the business context behind a feature, it's left guessing.

**AI coding tools are context-starved.** They can write technically correct code, but they don't understand *why* you're building what you're building. When you restart Cursor or switch AI models, all context disappears.

**Product decisions live in people's heads.** When someone leaves the team, institutional knowledge vanishes. Documentation becomes stale immediately after creation.

## The Solution

Product as Code treats product management with the same rigor as software engineering. Instead of scattered requirements across multiple tools, everything lives as structured, version-controlled data in your repository alongside your code.

```yaml
apiVersion: productascode.org/v0.1.0
kind: Ticket
metadata:
  id: 660f9511-f39c-52e5-b827-557766551111
  name: "jwt-token-generation-validation"
spec:
  description: |
    Implement comprehensive JWT token generation and validation utilities
    for the authentication system.
  type: "feature"
  status: "in-progress"
  branch_name: "22-jwt-token-generation-validation"
  assignee: "@alice"

  acceptance_criteria:
    - "JWT token generation with configurable expiration times"
    - "Token validation with proper error handling"
    - "Refresh token mechanism for seamless user experience"
    - "Unit tests for all JWT utilities"

  tasks:
    - metadata:
        id: 1
      spec:
        description: "Enhance JWT token generation"
        done: true
    - metadata:
        id: 2
      spec:
        description: "Implement token validation"
        done: false
```

This isn't just a ticket—it's structured data that AI tools can understand completely.

## Key Benefits

### 🤖 **Perfect AI Context**
AI coding assistants understand business requirements, technical context, and implementation details in a single pass. No more guessing about business intent.

### 📋 **Single Source of Truth**
All product decisions, requirements, and progress live in version-controlled files alongside your code. No more tool switching or context loss.

### 🔄 **GitOps for Product**
Apply the same workflows you use for infrastructure and code to product management. Review product decisions like code reviews.

### ⚡ **Developer-Native**
Built for technical teams who prefer git workflows over traditional project management tools. Everything feels familiar.

### 📈 **Traceability**
Every product decision is traceable through git history. Understand exactly why decisions were made and when they changed.

### 🎯 **Atomic Development**
Each ticket maps to exactly one git branch and pull request. Clear scope boundaries with no confusion.


## Roadmap

### Phase 0: Foundation (Current - v0.1.0)
- 🏗️ Core specification published
- 📋 Basic validation tools
- 📋 Web viewer for PAC repositories
- 📋 AI integration examples and templates


## Contributing

Product as Code is an open source project and we welcome contributions!

### Ways to Contribute

- **Try the specification** with your team and share feedback
- **Report issues** or suggest improvements
- **Contribute to tooling** - help build the ecosystem
- **Write documentation** and examples
- **Spread the word** - blog posts, talks, social media

## Follow Us

Stay connected with the Product as Code community:

- **[X](https://x.com/productascode)** - Updates, tips, and community highlights
- **[Bluesky](https://bsky.app/profile/productascode.org)** - Join the conversation on Bluesky
- **[LinkedIn](https://linkedin.com/company/productascode)** - Professional updates and insights

## Acknowledgments

Product as Code was inspired by:

- **Infrastructure as Code** movement and GitOps principles
- **OpenAPI Specification** for structured API documentation
- **Kubernetes** resource definitions and YAML-first approach
- The growing need for **AI-native development workflows**


---
<sub>Built with ❤️ by developers who believe product management should be as rigorous as software engineering.</sub>