# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Product as Code (PaC) is a specification for managing product development using GitOps principles. This repository contains the specification documents that define how to represent product requirements, development tasks, and business context in structured YAML/JSON files.

## Repository Structure

- `README.md` - Project overview and introduction
- `versions/` - Contains specification versions
  - `v0.0.1.md` - Current specification (v0.1.0) with formal schema definitions

## Key Concepts

The PaC specification defines a two-level hierarchy:
1. **Epics** - High-level features or projects
2. **Tickets** - Specific, actionable development items within epics
3. **Tasks** - Inline checklist items within tickets (not separate files)

## Development Status

This is a specification-only repository (v0.1.0). There is currently no implementation code, build system, or tests. The focus is on defining the standard before creating tooling.

## Working with the Specification

When modifying the specification:
- Follow RFC 2119 keywords (MUST, SHOULD, MAY, etc.)
- Maintain consistency with existing YAML/JSON examples
- Update version numbers appropriately
- Ensure examples are valid according to the schema

## Schema Requirements

Key fields defined in the specification:
- Epic: `id`, `title`, `description`, `priority`, `status`
- Ticket: `id`, `title`, `description`, `priority`, `acceptance_criteria`, `tasks`
- Both support custom extensions via `x-` prefixed fields

## Contributing

When contributing to this specification:
1. Changes should align with the GitOps philosophy
2. Consider AI assistant readability and context provision
3. Maintain backward compatibility where possible
4. Follow the existing documentation style and structure