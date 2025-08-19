# Product as Code Specification

#### Version 0.1.0

The key words "MUST", "MUST NOT", "REQUIRED", "SHALL", "SHALL NOT", "SHOULD",
"SHOULD NOT", "RECOMMENDED", "NOT RECOMMENDED", "MAY", and "OPTIONAL" in this
document are to be interpreted as described in
[BCP 14](https://tools.ietf.org/html/bcp14)
[RFC2119](https://tools.ietf.org/html/rfc2119)
[RFC8174](https://tools.ietf.org/html/rfc8174) when, and only when, they appear
in all capitals, as shown here.

This document is licensed under
[The Apache License, Version 2.0](http://www.apache.org/licenses/LICENSE-2.0.html).

## Introduction

The Product as Code Specification (PaC) defines a standard, version-controlled
interface to product development workflows that enables both humans and AI
coding assistants to discover and understand product requirements, development
tasks, and implementation context. When properly implemented, AI coding tools
can understand not only what to build, but exactly how it fits into the
development workflow, git branches, and deployment process.

A Product as Code definition bridges product management and development
execution, providing AI tools with complete context about business requirements,
technical implementation details, and workflow integration points.

## Table of Contents

- [Definitions](#definitions)
  - [Product as Code Document](#product-as-code-document)
  - [Hierarchical Structure](#hierarchical-structure)
- [Specification](#specification)
  - [Versions](#versions)
  - [Format](#format)
  - [Document Structure](#document-structure)
  - [Metadata vs Specification Separation](#metadata-vs-specification-separation)
  - [Data Types](#data-types)
  - [Time and Duration Formats](#time-and-duration-formats)
  - [Estimation](#estimation)
  - [Dependency Management](#dependency-management)
  - [Schema](#schema)
    - [Epic Object](#epic-object)
    - [Ticket Object](#ticket-object)
    - [Task Object](#task-object)
    - [Pull Request Object](#pull-request-object)
    - [Estimation Object](#estimation-object)
    - [Estimate Value Object](#estimate-value-object)
    - [Metadata Object](#metadata-object)
  - [Specification Extensions](#specification-extensions)
- [Appendix A: Configuration Files](#appendix-a-configuration-files)
- [Appendix B: Project Organization](#appendix-b-project-organization)
- [Appendix C: Revision History](#appendix-c-revision-history)

## Definitions

##### Product as Code Document

A document (or set of documents) that defines or describes product requirements,
development tasks, and business context. A Product as Code definition uses and
conforms to the Product as Code Specification.

##### Hierarchical Structure

Product as Code follows a two-level hierarchy: Epics contain Tickets. Tickets
represent atomic units of development work that map to single branches and pull
requests. Tasks are lightweight implementation steps embedded within tickets as
inline arrays. This structure provides natural scope boundaries while
maintaining practical development workflow integration.

## Specification

### Versions

The Product as Code Specification is versioned using
[Semantic Versioning 2.0.0](http://semver.org/spec/v2.0.0.html) (semver) and
follows the semver specification.

The `major`.`minor` portion of the semver (for example `0.1`) SHALL designate
the PaC feature set. Typically, _`.patch`_ versions address errors in this
document, not the feature set. Tooling which supports PaC 0.1 SHOULD be
compatible with all PaC 0.1.\* versions.

A Product as Code document compatible with PaC 0.\*.\* contains a required
`apiVersion` field which designates the semantic version of the PaC that it
uses.

### Format

A Product as Code document that conforms to the Product as Code Specification is
itself a structured object, which may be represented in either YAML or JSON
format.

All field names in the specification are **case sensitive**.

The schema exposes two types of fields: Fixed fields, which have a declared
name, and Optional fields, which may be included to provide additional context
but are not required for basic compliance.

#### YAML Format

YAML version [1.2](http://www.yaml.org/spec/1.2/spec.html) is RECOMMENDED for
human readability and ease of editing. YAML is particularly well-suited for:

- Manual editing and review
- Version control diffs
- Collaborative editing in text editors

#### JSON Format

JSON format is RECOMMENDED for programmatic generation and processing. JSON is
particularly well-suited for:

- Tool integration and API consumption
- Automated generation from existing systems
- Environments where YAML parsing is not available

#### Format Equivalence

Both formats MUST represent identical data structures. Tools SHOULD provide
conversion utilities between YAML and JSON representations of Product as Code
documents.

### Document Structure

A Product as Code document MAY be made up of a single document or be divided
into multiple, connected parts at the discretion of the user. In the latter
case, references between documents MUST use the unique identifier fields.

It is RECOMMENDED that Product as Code documents be named with descriptive names
and appropriate file extensions:

- YAML format: `epic-user-auth.yaml`, `ticket-login-form.yml`
- JSON format: `epic-user-auth.json`, `ticket-login-form.json`

### Metadata vs Specification Separation

Product as Code follows established patterns for separating object metadata from
work specification. This separation ensures clean boundaries between object
management and work execution, making the specification both powerful for
advanced tooling and intuitive for daily use.

#### Metadata

Contains information about the PaC object itself - its identity, lifecycle, and
system integration:

- **Object Identity**: Unique identifiers, names, and labels for organization
- **Object Lifecycle**: When the PaC document was created and last modified
- **Work Lifecycle**: When actual work started, is due, and was completed
- **System Integration**: Tool-specific IDs and import sources using x-prefixed
  extension fields

Metadata fields are primarily managed by PaC-compatible tools and change less
frequently during normal workflow execution.

#### Specification

Contains the actual work definition, current state, and execution details:

- **Work Definition**: What needs to be accomplished and why
- **Current State**: Progress status and active assignments
- **Work Relationships**: Dependencies and connections between work items
- **Business Context**: Priority, ownership, success criteria, and
  categorization
- **Implementation Details**: Technical requirements, branches, and pull
  requests

Specification fields are actively managed by users during work execution and
contain the information most relevant to AI coding assistants and project
management workflows.

### Data Types

Primitive data types in PaC are based on YAML 1.2 supported types:

- `string` - UTF-8 text
- `integer` - Whole numbers
- `number` - Numeric values including decimals
- `boolean` - true/false values
- `array` - Ordered list of values
- `object` - Key-value pairs

### Time and Duration Formats

#### Timestamps

All timestamp fields in Product as Code documents MUST use ISO 8601 format and
SHOULD be expressed in UTC timezone. The format MUST include the timezone
designator.

**Required format:** `YYYY-MM-DDTHH:MM:SSZ` (UTC) or `YYYY-MM-DDTHH:MM:SS±HH:MM`
(with timezone offset)

**Examples:**

- UTC: `"2025-01-15T10:30:00Z"`
- With timezone: `"2025-01-15T10:30:00+02:00"`

**Recommended practice:** All timestamps SHOULD use UTC timezone (`Z` suffix) to
avoid confusion across distributed teams.

#### Durations

Duration fields such as `estimate` and `actual_time` in Task objects MUST use
ISO 8601 duration format to ensure consistent parsing across tools.

**Required format:** `PT[n]H[n]M[n]S` where:

- `P` indicates the start of duration
- `T` separates date and time components
- `H` = hours, `M` = minutes, `S` = seconds

**Examples:**

- 8 hours: `"PT8H"`
- 2 hours 30 minutes: `"PT2H30M"`
- 45 minutes: `"PT45M"`
- 1 hour 15 minutes 30 seconds: `"PT1H15M30S"`

**Legacy support:** Tools MAY accept human-readable duration strings (e.g.,
`"8h"`, `"2.5 hours"`) for user convenience but MUST convert them to ISO 8601
format when storing or exchanging PaC documents.

### Estimation

Product as Code uses structured estimation objects to provide consistent project
planning and progress tracking capabilities across all development work.

#### Story Points

PaC v0.1.0 uses Fibonacci-based story point estimation to encourage appropriate
work sizing and maintain consistency with established agile practices. Story
points represent relative complexity and effort rather than absolute time.

**Fibonacci Scale:** All story point values MUST be from the Fibonacci sequence:
`1, 2, 3, 5, 8`

**Scale Guidelines:**

- **1 point**: Very small, well-understood changes
- **2 points**: Small features or straightforward bug fixes
- **3 points**: Medium complexity work with some unknowns
- **5 points**: Larger features requiring multiple changes
- **8 points**: Complex work that should be considered for breakdown

**Epic Aggregation:** Epic estimates are automatically calculated as the sum of
their constituent ticket estimates, providing natural roll-up reporting and
progress tracking.

### Dependency Management

Product as Code supports three types of relationships between objects:
dependencies, blocking relationships, and general associations. Tools
implementing PaC MUST validate these relationships to prevent inconsistencies.

#### Relationship Types

The following relationship types are supported:

- `depends_on`: Objects that must be completed before this object can start
- `blocked_by`: Objects that are preventing this object from starting or
  continuing
- `related_to`: Objects that are associated but don't have blocking
  relationships

#### Validation Rules

##### Circular Dependency Prevention

Tools MUST detect and prevent circular dependencies in `depends_on` and
`blocked_by` relationships:

**Prohibited patterns:**

- Direct circular dependency: A `depends_on` B, B `depends_on` A
- Indirect circular dependency: A `depends_on` B, B `depends_on` C, C
  `depends_on` A
- Self-dependency: A `depends_on` A

**Validation requirement:** Tools MUST perform dependency graph validation
before accepting changes to PaC documents and MUST reject documents that create
circular dependencies.

##### Cross-Hierarchy Dependencies

Dependencies MAY exist across different levels of the hierarchy with the
following rules:

**Allowed:**

- Epic to Epic dependencies
- Ticket to Ticket dependencies (within same or different Epics)
- Epic to Ticket dependencies (Epic depends on specific Ticket completion)

**Prohibited:**

- Ticket to Epic dependencies (use Epic to Epic instead)
- Task dependencies (Tasks are implementation details within Tickets)

##### Reference Validation

All values in `depends_on`, `blocked_by`, and `related_to` arrays MUST reference
valid object identifiers that exist in the current document set or can be
resolved by the implementing tool.

**Validation requirements:**

- Referenced IDs MUST exist and be accessible
- Referenced objects MUST be of compatible types (see Cross-Hierarchy
  Dependencies)
- Tools SHOULD warn when referenced objects are in different repositories or
  document sets

##### Dependency State Consistency

Tools SHOULD enforce logical consistency between object states and their
dependencies:

**State rules:**

- Objects with `status: "completed"` SHOULD NOT have active `blocked_by`
  relationships
- Objects with `status: "todo"` that have incomplete dependencies SHOULD be
  automatically marked as blocked
- Tools MAY automatically update object statuses based on dependency completion

**Implementation note:** These consistency rules are recommendations for tool
behavior rather than strict document validation requirements, allowing teams
flexibility in their workflows.

## Schema

In the following description, if a field is not explicitly **REQUIRED** or
described with a MUST or SHALL, it can be considered OPTIONAL.

### Epic Object

An Epic represents a large feature set or initiative that provides business
value. Epics contain multiple related tickets and serve as the highest level of
organization in the Product as Code hierarchy.

#### Fixed Fields

| Field Name |                          Type                           | Description                                                                                                                                                                                                                        |
| ---------- | :-----------------------------------------------------: | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| apiVersion |                        `string`                         | **REQUIRED**. This string MUST be `productascode.org/v0.1.0` for documents conforming to version 0.1.0 of the Product as Code Specification. The `apiVersion` field SHOULD be used by tooling to interpret the document correctly. |
| kind       |                        `string`                         | **REQUIRED**. MUST be `"Epic"` for Epic objects.                                                                                                                                                                                   |
| metadata   |           [Metadata Object](#metadata-object)           | **REQUIRED**. Metadata about the Epic including unique identifiers and timestamps.                                                                                                                                                 |
| spec       | [Epic Specification Object](#epic-specification-object) | **REQUIRED**. The specification of the Epic including description and optional fields.                                                                                                                                             |

#### Epic Specification Object

| Field Name      |                  Type                   | Description                                                                                                              |
| --------------- | :-------------------------------------: | ------------------------------------------------------------------------------------------------------------------------ |
| description     |                `string`                 | **REQUIRED**. A clear, concise description of what the Epic accomplishes and why it provides business value.             |
| parent          |                `string`                 | The unique identifier of the parent Epic this Epic belongs to. MUST NOT be present for top-level Epics.                  |
| status          |                `string`                 | **REQUIRED**. The current status of the Epic. Common values include `planning`, `in-progress`, `completed`, `cancelled`. |
| priority        |                `string`                 | **REQUIRED**. The business priority of the Epic. Common values include `low`, `medium`, `high`, `critical`.              |
| owner           |                `string`                 | The person or team responsible for this Epic's delivery and success.                                                     |
| success_metrics |           `array` of `string`           | Measurable outcomes that define success for this Epic.                                                                   |
| tickets         |           `array` of `string`           | List of ticket identifiers that belong to this Epic.                                                                     |
| epics           |           `array` of `string`           | List of sub-epic identifiers that belong to this Epic.                                                                   |
| estimate        | [Estimation Object](#estimation-object) | Estimation information for this Epic. When present, represents the aggregate estimate of all contained tickets.          |
| labels          |                `object`                 | Key-value pairs for categorization and filtering specific to this Epic's work context.                                   |
| blocked_by      |           `array` of `string`           | List of epic identifiers that are blocking this Epic from starting or completing.                                        |
| related_to      |           `array` of `string`           | List of epic identifiers that are related to this Epic but not blocking.                                                 |
| depends_on      |           `array` of `string`           | List of epic identifiers that must be completed before this Epic can start.                                              |

### Ticket Object

A Ticket represents an atomic unit of development work that maps to a single git
branch and pull request. Tickets belong to Epics and contain inline tasks that
represent implementation steps within the unit of work.

#### Fixed Fields

| Field Name |                            Type                             | Description                                                                                                                                  |
| ---------- | :---------------------------------------------------------: | -------------------------------------------------------------------------------------------------------------------------------------------- |
| apiVersion |                          `string`                           | **REQUIRED**. This string MUST be `productascode.org/v0.1.0` for documents conforming to version 0.1.0 of the Product as Code Specification. |
| kind       |                          `string`                           | **REQUIRED**. MUST be `"Ticket"` for Ticket objects.                                                                                         |
| metadata   |             [Metadata Object](#metadata-object)             | **REQUIRED**. Metadata about the Ticket including unique identifiers and timestamps.                                                         |
| spec       | [Ticket Specification Object](#ticket-specification-object) | **REQUIRED**. The specification of the Ticket including description and optional fields.                                                     |

#### Ticket Specification Object

| Field Name          |                    Type                     | Description                                                                                                                                                                                                            |
| ------------------- | :-----------------------------------------: | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| description         |                  `string`                   | **REQUIRED**. A detailed description of what needs to be implemented or accomplished in this unit of work.                                                                                                             |
| parent              |                  `string`                   | The unique identifier of the Epic this Ticket belongs to. If not specified, the Ticket is considered standalone or orphaned.                                                                                           |
| type                |                  `string`                   | **REQUIRED**. The type of work this Ticket represents. Common values include `feature`, `bug`, `chore`, `refactor`. Teams MAY define custom types as needed.                                                           |
| status              |                  `string`                   | **REQUIRED**. The current status of the Ticket. Common values include `todo`, `in-progress`, `review`, `completed`, `blocked`.                                                                                         |
| priority            |             `string` or `null`              | **REQUIRED**. The priority of the Ticket within its Epic. Common values include `low`, `medium`, `high`, `critical`. MUST be `null` if priority is not set.                                                            |
| branch_name         |             `string` or `null`              | **REQUIRED**. The git branch name for this unit of work. Enables AI coding assistants to know exactly where to implement changes. MUST be `null` if branch has not been created yet. RECOMMENDED for development work. |
| assignee            |             `string` or `null`              | **REQUIRED**. The person responsible for implementing this Ticket. MUST be `null` if no one is assigned.                                                                                                               |
| reviewer            |             `string` or `null`              | **REQUIRED**. The person responsible for reviewing this Ticket's implementation. MUST be `null` if no reviewer is assigned.                                                                                            |
| estimate            |   [Estimation Object](#estimation-object)   | Estimation information for this Ticket using story point methodology.                                                                                                                                                  |
| acceptance_criteria |             `array` of `string`             | Specific, testable conditions that must be met for the ticket to be considered complete.                                                                                                                               |
| tasks               |   `array` of [Task Object](#task-object)    | Inline array of implementation steps within this unit of work. Use when the ticket requires breakdown into multiple actionable steps.                                                                                  |
| pull_request        | [Pull Request Object](#pull-request-object) | Information about the pull request associated with this Ticket.                                                                                                                                                        |
| labels              |             `array` of `string`             | Tags for categorization and filtering specific to this Ticket's work context.                                                                                                                                          |
| blocked_by          |             `array` of `string`             | List of ticket identifiers that are blocking this Ticket from starting or completing.                                                                                                                                  |
| related_to          |             `array` of `string`             | List of ticket identifiers that are related to this Ticket but not blocking.                                                                                                                                           |
| depends_on          |             `array` of `string`             | List of ticket identifiers that must be completed before this Ticket can start.                                                                                                                                        |

### Task Object

A Task represents a lightweight implementation step within a Ticket. Tasks are
embedded inline within Tickets and represent checkboxes or action items that
comprise the unit of work.

#### Fixed Fields

| Field Name |                          Type                           | Description                                                                                   |
| ---------- | :-----------------------------------------------------: | --------------------------------------------------------------------------------------------- |
| metadata   |      [Task Metadata Object](#task-metadata-object)      | **REQUIRED**. Metadata about the Task including unique identifiers and timestamps.            |
| spec       | [Task Specification Object](#task-specification-object) | **REQUIRED**. The specification of the Task including description and implementation details. |

#### Task Metadata Object

| Field Name   |        Type        | Description                                                                                                |
| ------------ | :----------------: | ---------------------------------------------------------------------------------------------------------- |
| id           |     `integer`      | **REQUIRED**. A unique identifier for this Task within its parent Ticket.                                  |
| created_at   |      `string`      | **REQUIRED**. ISO 8601 timestamp of when the Task was created.                                             |
| updated_at   |      `string`      | **REQUIRED**. ISO 8601 timestamp of when the Task was last updated.                                        |
| started_at   | `string` or `null` | **REQUIRED**. ISO 8601 timestamp of when work on this Task began. MUST be `null` if work has not started.  |
| due_at       | `string` or `null` | **REQUIRED**. ISO 8601 timestamp of when this Task is due. MUST be `null` if no deadline is set.           |
| completed_at | `string` or `null` | **REQUIRED**. ISO 8601 timestamp of when this Task was completed. MUST be `null` if work is not completed. |

#### Task Specification Object

| Field Name  |   Type   | Description                                                                                                                                                           |
| ----------- | :------: | --------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| description | `string` | **REQUIRED**. A specific, actionable description of the implementation step.                                                                                          |
| status      | `string` | **REQUIRED**. The current status of the Task. Common values include `todo`, `in-progress`, `completed`, `blocked`.                                                    |
| type        | `string` | The type of work this Task represents. Common values include `feature`, `bug`, `chore`, `refactor`, `test`, `documentation`. Teams MAY define custom types as needed. |
| assignee    | `string` | The person responsible for this Task.                                                                                                                                 |
| estimate    | `string` | Time estimate for completing this Task in ISO 8601 duration format (e.g., `"PT2H"` for 2 hours).                                                                      |
| actual_time | `string` | Actual time spent completing this Task in ISO 8601 duration format.                                                                                                   |

### Pull Request Object

Information about the pull request associated with a Ticket's implementation.

#### Pull Request Specification Object

| Field Name |        Type         | Description                                                                                |
| ---------- | :-----------------: | ------------------------------------------------------------------------------------------ |
| url        |      `string`       | The URL of the pull request.                                                               |
| status     |      `string`       | The status of the pull request. Common values include `draft`, `open`, `merged`, `closed`. |
| title      |      `string`       | The title of the pull request.                                                             |
| created_at |      `string`       | ISO 8601 timestamp of when the pull request was created.                                   |
| reviewers  | `array` of `string` | List of people assigned to review the pull request.                                        |

### Estimation Object

The Estimation Object provides structured estimation information using story
point methodology. This object contains both planned estimates and actual effort
tracking in a unified structure.

#### Fixed Fields

| Field Name |                      Type                       | Description                                                                    |
| ---------- | :---------------------------------------------: | ------------------------------------------------------------------------------ |
| estimated  | [Estimate Value Object](#estimate-value-object) | **REQUIRED**. The planned estimate for this work using Fibonacci story points. |
| actual     | [Estimate Value Object](#estimate-value-object) | Actual effort spent on this work. Only present when work is completed.         |

#### Estimate Value Object

| Field Name |   Type    | Description                                                                                         |
| ---------- | :-------: | --------------------------------------------------------------------------------------------------- |
| value      | `integer` | **REQUIRED**. The story point value using Fibonacci scale. MUST be one of: `1`, `2`, `3`, `5`, `8`. |
| unit       | `string`  | **REQUIRED**. The unit of estimation. MUST be `"story_points"` in v0.1.0.                           |
| confidence | `string`  | The confidence level in this estimate. Common values include `low`, `medium`, `high`.               |
| notes      | `string`  | Additional context about the estimate or what differed from expectations.                           |

#### Estimation Guidelines

**Story Point Values:**

- **1 point**: Very small, well-understood changes (quick fixes, simple updates)
- **2 points**: Small features or straightforward bug fixes requiring minimal
  investigation
- **3 points**: Medium complexity work with some unknowns but clear scope
- **5 points**: Larger features requiring multiple changes across several files
- **8 points**: Complex work that should be considered for breakdown into
  smaller tickets

**Confidence Levels:**

- **low**: Significant unknowns, requirements unclear, or complex technical
  challenges
- **medium**: Some unknowns but general approach is understood
- **high**: Well-understood work with clear requirements and approach

**Epic Aggregation:** When present on Epic objects, estimated values represent
the sum of all contained ticket estimates, and actual values represent the sum
of completed ticket actuals, providing automatic roll-up reporting and progress
tracking.

### Metadata Object

The Metadata Object contains identifying information, lifecycle timestamps, and
system integration details for all Product as Code objects. This information
describes the PaC object itself rather than the work it defines.

#### Fixed Fields

| Field Name   |        Type        | Description                                                                                                                                                                        |
| ------------ | :----------------: | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| id           |      `string`      | **REQUIRED**. A globally unique identifier for this object in ULID format (e.g., `01HK8Q2M3NP7YBE4VTQZ8JF2RG`). MUST be generated by PaC-compatible tooling.                       |
| sequence     |     `integer`      | OPTIONAL. A sequential integer identifier for this object. MAY be used for human convenience and branch naming but tools SHOULD use the `id` field for all references and linking. |
| name         |      `string`      | A human-readable name for the object.                                                                                                                                              |
| created_at   |      `string`      | **REQUIRED**. ISO 8601 timestamp of when the PaC object was created.                                                                                                               |
| updated_at   |      `string`      | **REQUIRED**. ISO 8601 timestamp of when the PaC object was last updated.                                                                                                          |
| started_at   | `string` or `null` | **REQUIRED**. ISO 8601 timestamp of when work on this object began. MUST be `null` if work has not started.                                                                        |
| due_at       | `string` or `null` | **REQUIRED**. ISO 8601 timestamp of when this work is due. MUST be `null` if no deadline is set.                                                                                   |
| completed_at | `string` or `null` | **REQUIRED**. ISO 8601 timestamp of when work on this object was completed. MUST be `null` if work is not completed.                                                               |
| labels       |      `object`      | Key-value pairs for system integration and tool-specific metadata. SHOULD use x-prefixed fields for custom extensions (e.g., `x-jira-key`, `x-legacy-id`).                         |

**Identifier Guidelines:**

- The `id` field is **REQUIRED** and MUST be generated by PaC-compatible tooling
  using ULID format for global uniqueness and time-sortability
- `sequence` MAY be provided for human convenience and backwards compatibility
  with existing workflows
- Tools SHOULD use the `id` field for all object references and linking in
  `depends_on`, `blocked_by`, `related_to`, and other relationship fields
- Teams requiring custom identifier formats SHOULD use the extension mechanism
  with `x-` prefixed fields in the `labels` object

**Timestamp Guidelines:**

- `created_at` and `updated_at` track the PaC document lifecycle and are
  **REQUIRED**
- `started_at`, `due_at`, and `completed_at` track the actual work lifecycle and
  MUST use `null` when not applicable
- Both document and work timestamps provide valuable context for different use
  cases
- Tools MAY validate that due dates are logically consistent within object
  hierarchies (e.g., Task `due_at` <= Ticket `due_at` <= Epic `due_at`)

**Labels for System Integration:**

- The `labels` object in metadata is reserved for system integration and
  tool-specific identifiers
- All custom extensions SHOULD use x-prefixed field names (e.g.,
  `x-jira-epic: "AUTH-123"`)
- This separation keeps system metadata distinct from work-related
  categorization in spec.labels

## Examples

### Epic Example (YAML)

```yaml
apiVersion: productascode.org/v0.1.0
kind: Epic
metadata:
  id: 01HK8Q2M3NP7YBE4VTQZ8JF2RG
  sequence: 1
  name: user-authentication
  created_at: 2025-01-15T10:30:00Z
  updated_at: 2025-01-15T10:30:00Z
  started_at: 2025-01-16T09:00:00Z
  due_at: 2025-03-15T00:00:00Z
  completed_at: null
  labels:
    x-jira-epic: "AUTH-123"
    x-imported-from: "linear"
spec:
  description:
    "Complete user authentication system with signup, login, and password
    recovery"
  status: in-progress
  priority: high
  owner: product-team
  success_metrics:
    - "90% signup completion rate"
    - "< 2 second login time"
    - "Zero critical security vulnerabilities"
  estimate:
    estimated:
      value: 21
      unit: "story_points"
      confidence: "medium"
    actual:
      value: 13
      unit: "story_points"
      confidence: "high"
  tickets:
    - "01HK8Q2N1QS9ZCF5WUXA9KG3SH"
    - "01HK8Q2P2RT0ADF6XVYB0LH4TI"
  epics:
    - "01HK8Q2Q3SU1BEG7YWZC1MI5UJ"
  labels:
    team: auth-team
    quarter: Q1-2025
    area: security
  related_to:
    - "01HK8Q2R4TV2CFH8ZXAD2NJ6VK"
    - "01HK8Q2S5UW3DGI9AYBE3OK7WL"
```

### Epic Example (JSON)

```json
{
  "apiVersion": "productascode.org/v0.1.0",
  "kind": "Epic",
  "metadata": {
    "id": "01HK8Q2M3NP7YBE4VTQZ8JF2RG",
    "sequence": 1,
    "name": "user-authentication",
    "created_at": "2025-01-15T10:30:00Z",
    "updated_at": "2025-01-15T10:30:00Z",
    "started_at": "2025-01-16T09:00:00Z",
    "due_at": "2025-03-15T00:00:00Z",
    "completed_at": null,
    "labels": {
      "x-jira-epic": "AUTH-123",
      "x-imported-from": "linear"
    }
  },
  "spec": {
    "description": "Complete user authentication system with signup, login, and password recovery",
    "status": "in-progress",
    "priority": "high",
    "owner": "product-team",
    "success_metrics": [
      "90% signup completion rate",
      "< 2 second login time",
      "Zero critical security vulnerabilities"
    ],
    "estimate": {
      "estimated": {
        "value": 21,
        "unit": "story_points",
        "confidence": "medium"
      },
      "actual": {
        "value": 13,
        "unit": "story_points",
        "confidence": "high"
      }
    },
    "tickets": ["01HK8Q2N1QS9ZCF5WUXA9KG3SH", "01HK8Q2P2RT0ADF6XVYB0LH4TI"],
    "epics": ["01HK8Q2Q3SU1BEG7YWZC1MI5UJ"],
    "labels": {
      "team": "auth-team",
      "quarter": "Q1-2025",
      "area": "security"
    },
    "related_to": ["01HK8Q2R4TV2CFH8ZXAD2NJ6VK", "01HK8Q2S5UW3DGI9AYBE3OK7WL"]
  }
}
```

### Ticket Example (YAML)

```yaml
apiVersion: productascode.org/v0.1.0
kind: Ticket
metadata:
  id: 01HK8Q2N1QS9ZCF5WUXA9KG3SH
  sequence: 22
  name: "jwt-token-generation-validation"
  created_at: 2025-07-09T00:00:00Z
  updated_at: 2025-07-09T13:47:39Z
  started_at: "2025-07-09T14:05:10Z"
  due_at: "2025-07-10T17:00:00Z"
  completed_at: "2025-07-09T14:47:39Z"
  labels:
    x-linear-id: "DEV-456"
    x-github-issue: "123"
spec:
  description: |
    Implement comprehensive JWT token generation and validation utilities
    for the authentication system. This includes token creation,
    validation, refresh mechanisms, and proper error handling for
    expired or invalid tokens.
  type: "feature"
  parent: 01HK8Q2M3NP7YBE4VTQZ8JF2RG
  status: "completed"
  priority: "high"
  branch_name: "22-jwt-token-generation-validation"
  assignee: "@mantcz"
  reviewer: "@mantcz"
  estimate:
    estimated:
      value: 8
      unit: "story_points"
      confidence: "medium"
    actual:
      value: 5
      unit: "story_points"
      confidence: "high"

  acceptance_criteria:
    - "JWT token generation with configurable expiration times"
    - "Token validation with proper error handling"
    - "Refresh token mechanism for seamless user experience"
    - "Token blacklisting for logout functionality"
    - "Proper JWT claims validation (exp, iat, sub)"
    - "Environment-based JWT configuration"
    - "Comprehensive error handling for invalid/expired tokens"
    - "Token extraction from Authorization headers"
    - "Unit tests for all JWT utilities"
    - "Integration with existing authentication flow"

  tasks:
    - metadata:
        id: 1
        created_at: "2025-07-09T14:05:00Z"
        updated_at: "2025-07-09T16:50:10Z"
        started_at: "2025-07-09T14:05:10Z"
        due_at: "2025-07-09T16:00:00Z"
        completed_at: "2025-07-09T16:50:10Z"
      spec:
        description: "Enhance JWT token generation with configurable options"
        done: true
        type: "feature"
        assignee: "@mantcz"
        estimate: "PT3H"
        actual_time: "PT2H45M"
    - metadata:
        id: 2
        created_at: "2025-07-09T14:05:00Z"
        updated_at: "2025-07-09T20:05:15Z"
        started_at: "2025-07-09T16:50:15Z"
        due_at: "2025-07-09T20:00:00Z"
        completed_at: "2025-07-09T20:05:15Z"
      spec:
        description: "Implement JWT token validation with proper error handling"
        done: true
        type: "feature"
        assignee: "@mantcz"
        estimate: "PT3H"
        actual_time: "PT3H15M"
    - metadata:
        id: 3
        created_at: "2025-07-09T14:05:00Z"
        updated_at: "2025-07-09T22:05:20Z"
        started_at: "2025-07-09T20:05:20Z"
        due_at: "2025-07-09T22:00:00Z"
        completed_at: "2025-07-09T22:05:20Z"
      spec:
        description: "Create refresh token mechanism"
        done: true
        type: "feature"
        assignee: "@mantcz"
        estimate: "PT2H"
        actual_time: "PT2H"

  pull_request:
    url: "https://github.com/company/repo/pull/22"
    status: "merged"
    title: "Implement JWT token generation and validation"
    created_at: "2025-07-09T14:30:00Z"
    reviewers: ["@mantcz"]

  labels:
    - "authentication"
    - "jwt"
    - "security"
    - "middleware"

  depends_on:
    - "01HK8Q2P2RT0ADF6XVYB0LH4TI"
  related_to:
    - "01HK8Q2Q3SU1BEG7YWZC1MI5UJ"
    - "01HK8Q2R4TV2CFH8ZXAD2NJ6VK"
```

### Ticket Example (JSON)

```json
{
  "apiVersion": "productascode.org/v0.1.0",
  "kind": "Ticket",
  "metadata": {
    "id": "01HK8Q2N1QS9ZCF5WUXA9KG3SH",
    "sequence": 22,
    "name": "jwt-token-generation-validation",
    "created_at": "2025-07-09T00:00:00Z",
    "updated_at": "2025-07-09T13:47:39Z",
    "started_at": "2025-07-09T14:05:10Z",
    "due_at": "2025-07-09T17:00:00Z",
    "completed_at": "2025-07-09T14:47:39Z",
    "labels": {
      "x-linear-id": "DEV-456",
      "x-github-issue": "123"
    }
  },
  "spec": {
    "description": "Implement comprehensive JWT token generation and validation utilities for the authentication system. This includes token creation, validation, refresh mechanisms, and proper error handling for expired or invalid tokens.",
    "type": "feature",
    "parent": "01HK8Q2M3NP7YBE4VTQZ8JF2RG",
    "status": "completed",
    "priority": "high",
    "branch_name": "22-jwt-token-generation-validation",
    "assignee": "@mantcz",
    "reviewer": "@mantcz",
    "estimate": {
      "estimated": {
        "value": 8,
        "unit": "story_points",
        "confidence": "medium"
      },
      "actual": {
        "value": 5,
        "unit": "story_points",
        "confidence": "high"
      }
    },
    "acceptance_criteria": [
      "JWT token generation with configurable expiration times",
      "Token validation with proper error handling",
      "Refresh token mechanism for seamless user experience",
      "Token blacklisting for logout functionality",
      "Proper JWT claims validation (exp, iat, sub)",
      "Environment-based JWT configuration",
      "Comprehensive error handling for invalid/expired tokens",
      "Token extraction from Authorization headers",
      "Unit tests for all JWT utilities",
      "Integration with existing authentication flow"
    ],
    "tasks": [
      {
        "metadata": {
          "id": 1,
          "created_at": "2025-07-09T14:05:00Z",
          "updated_at": "2025-07-09T16:50:10Z",
          "started_at": "2025-07-09T14:05:10Z",
          "due_at": "2025-07-09T16:00:00Z",
          "completed_at": "2025-07-09T16:50:10Z"
        },
        "spec": {
          "description": "Enhance JWT token generation with configurable options",
          "done": true,
          "type": "feature",
          "assignee": "@mantcz",
          "estimate": "PT3H",
          "actual_time": "PT2H45M"
        }
      },
      {
        "metadata": {
          "id": 2,
          "created_at": "2025-07-09T14:05:00Z",
          "updated_at": "2025-07-09T20:05:15Z",
          "started_at": "2025-07-09T16:50:15Z",
          "due_at": "2025-07-09T20:00:00Z",
          "completed_at": "2025-07-09T20:05:15Z"
        },
        "spec": {
          "description": "Implement JWT token validation with proper error handling",
          "done": true,
          "type": "feature",
          "assignee": "@mantcz",
          "estimate": "PT3H",
          "actual_time": "PT3H15M"
        }
      },
      {
        "metadata": {
          "id": 3,
          "created_at": "2025-07-09T14:05:00Z",
          "updated_at": "2025-07-09T22:05:20Z",
          "started_at": "2025-07-09T20:05:20Z",
          "due_at": "2025-07-09T22:00:00Z",
          "completed_at": "2025-07-09T22:05:20Z"
        },
        "spec": {
          "description": "Create refresh token mechanism",
          "done": true,
          "type": "feature",
          "assignee": "@mantcz",
          "estimate": "PT2H",
          "actual_time": "PT2H"
        }
      }
    ],
    "pull_request": {
      "url": "https://github.com/company/repo/pull/22",
      "status": "merged",
      "title": "Implement JWT token generation and validation",
      "created_at": "2025-07-09T14:30:00Z",
      "reviewers": ["@mantcz"]
    },
    "labels": ["authentication", "jwt", "security", "middleware"],
    "depends_on": ["01HK8Q2P2RT0ADF6XVYB0LH4TI"],
    "related_to": ["01HK8Q2Q3SU1BEG7YWZC1MI5UJ", "01HK8Q2R4TV2CFH8ZXAD2NJ6VK"]
  }
}
```

### Task Example

Tasks are embedded inline within Tickets as shown in the Ticket example above.
They represent lightweight implementation steps with metadata and specification
separation:

```yaml
tasks:
  - metadata:
      id: 1
      created_at: "2025-07-09T14:05:00Z"
      updated_at: "2025-07-09T16:50:10Z"
      started_at: "2025-07-09T14:05:10Z"
      due_at: "2025-07-09T16:00:00Z"
      completed_at: "2025-07-09T16:50:10Z"
    spec:
      description: "Enhance JWT token generation with configurable options"
      done: true
      type: "feature"
      assignee: "@mantcz"
      estimate: "PT2H"
      actual_time: "PT2H15M"
  - metadata:
      id: 2
      created_at: "2025-07-25T08:26:00Z"
      updated_at: "2025-07-25T08:26:00Z"
      started_at: null
      due_at: "2025-07-25T18:00:00Z"
      completed_at: null
    spec:
      description: "Update environment variables for JWT configuration"
      done: false
      type: "chore"
      assignee: "@alice"
      estimate: "PT30M"
```

## Specification Extensions

While the Product as Code Specification tries to accommodate most use cases,
additional data can be added to extend the specification at certain points.

The extensions properties are implemented as patterned fields that are always
prefixed by `"x-"`.

| Field Pattern | Type | Description                                                                                                                                                                      |
| ------------- | :--: | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| ^x-           | Any  | Allows extensions to the Product as Code Schema. The field name MUST begin with `x-`, for example, `x-internal-id`. The value can be `null`, a primitive, an array or an object. |

The extensions may or may not be supported by the available tooling, but those
may be extended as well to add requested support.

## Appendix A: Configuration Files

Product as Code implementations MAY support project-level configuration files to
provide consistent settings and defaults across a project. While not required
for v0.1.0 compliance, this appendix establishes the recommended patterns for
tools that choose to implement configuration support.

### Configuration File Location

Configuration files SHOULD be located at `.pac/config.yaml` in the project root
directory. This follows established patterns from other development tools and
provides a clear, discoverable location for PaC settings.

### Configuration File Structure

When implemented, configuration files SHOULD follow this basic structure:

```yaml
apiVersion: productascode.org/v0.1.0
kind: Config

# Project metadata
project:
  name: "Cortexy"
  description: "Business Assistant"
  owner: "product-team"
  folder: "product" # Directory for PaC files (default: "product")

# Sequence tracking for auto-generated sequence numbers
sequences:
  epic: 4 # Next epic will get sequence 5
  ticket: 23 # Next ticket will get sequence 24
  # tasks use per-ticket numbering, no global counter needed

# Default values for new objects
defaults:
  epic:
    owner: "product-team"
    labels:
      team: "auth"
      area: "security"
  ticket:
    type: "feature"
    assignee: "@unassigned"
    priority: null
    labels:
      - "needs-review"
  task:
    type: "feature"

# Team-specific field values
enums:
  ticket_types: ["feature", "bug", "chore", "refactor", "docs", "test"]
  statuses: ["todo", "in-progress", "review", "testing", "completed", "blocked"]
  priorities: ["low", "medium", "high", "critical"]

# Tool integrations (optional)
integrations:
  git:
    branch_naming: "{sequence}-{name}"
    commit_template: "{type}({sequence}): {description}"
  ai:
    context_files: [".cursorrules", "README.md", "ARCHITECTURE.md"]
    rules_file: ".pac/ai-rules.md"
```

### Configuration Field Descriptions

#### Project Section

- **name**: Human-readable project name
- **description**: Brief project description
- **owner**: Default owner for project-level objects
- **folder**: Directory path where PaC files are stored (default: "product" if
  not specified)

#### Sequences Section

- **epic**: Next sequence number for new Epic objects (integer, minimum 1)
- **ticket**: Next sequence number for new Ticket objects (integer, minimum 1)
- **Purpose**: Auto-increment tracking for human-friendly numbering
- **Management**: Automatically updated by PaC-compatible tools when creating
  objects

#### Defaults Section

Provides default field values when creating new PaC objects. Tools SHOULD apply
these defaults while allowing users to override them during object creation.

#### Enums Section

Defines valid values for common fields. Tools MAY use these for validation or UI
dropdowns, but MUST still accept values outside these lists to maintain
flexibility.

#### Integrations Section

Optional tool-specific settings for common integrations. The structure is
intentionally flexible to accommodate different tool implementations.

### Implementation Guidelines

- Configuration files are OPTIONAL for PaC v0.1.0 compliance
- Tools SHOULD ignore unknown configuration fields to maintain compatibility
- Configuration SHOULD provide defaults, not enforce restrictions
- Teams MAY commit configuration files to version control for shared settings
- Tools SHOULD provide clear error messages for invalid configuration syntax
- Tools MUST increment sequence counters when creating new objects
- Tools SHOULD scan existing files to detect and resolve sequence conflicts

### Benefits of Configuration Files

- **Consistency**: Shared defaults across team members and tools
- **Efficiency**: Reduced manual field entry for common patterns
- **Customization**: Team-specific workflows and integrations
- **Portability**: Project settings travel with the repository
- **Automation**: Sequence tracking enables automatic numbering

This appendix establishes a foundation for configuration support that can be
expanded in future versions of the PaC specification.

## Appendix B: Project Organization

Product as Code projects benefit from consistent directory organization that
separates concerns and scales with project complexity. While the specification
does not mandate any particular file organization, this appendix provides
recommended patterns based on common use cases.

### Single Document Approach

For small projects or initial experimentation, all PaC objects MAY be defined in
a single file:

```
project-root/
├── product.yaml                # All epics and tickets
├── .pac/
│   └── config.yaml            # Optional configuration
└── README.md
```

### Multi-Document Organization

A Product as Code project MAY consist of multiple documents organized in a
logical directory structure. The RECOMMENDED organization for larger projects
is:

```
project-root/
├── .pac/
│   ├── config.yaml              # Project configuration
│   ├── schemas/                 # Custom schema extensions
│   │   └── custom-fields.json   # Team-specific field definitions
│   └── templates/               # Object templates
│       ├── epic-template.yaml
│       └── ticket-template.yaml
├── product/
│   ├── epics/
│   │   ├── epic-auth.yaml       # Authentication epic
│   │   ├── epic-payments.yaml   # Payments epic
│   │   └── epic-analytics.yaml  # Analytics epic
│   ├── tickets/
│   │   ├── auth/                # Tickets grouped by epic
│   │   │   ├── ticket-login.yaml
│   │   │   ├── ticket-signup.yaml
│   │   │   └── ticket-logout.yaml
│   │   ├── payments/
│   │   │   ├── ticket-stripe.yaml
│   │   │   └── ticket-billing.yaml
│   │   └── shared/              # Cross-epic tickets
│   │       └── ticket-logging.yaml
│   └── archived/                # Completed epics/tickets
│       └── 2024-q4/
└── README.md
```

### Directory Structure Guidelines

#### .pac/ Directory

- **Purpose**: Contains project-level configuration and tooling support
- **config.yaml**: Project settings, defaults, and team preferences
- **schemas/**: Custom field definitions and validation rules
- **templates/**: Reusable object templates for consistency

#### product/ Directory

- **Purpose**: Contains all Product as Code objects
- **Flexibility**: Teams MAY organize by epic, feature area, or timeline
- **Naming**: Use descriptive names that match object metadata.name fields

#### Grouping Strategies

**By Epic (Recommended)**:

```
product/
├── epics/
└── tickets/
    ├── epic-auth/
    ├── epic-payments/
    └── shared/
```

**By Feature Area**:

```
product/
├── backend/
├── frontend/
├── mobile/
└── infrastructure/
```

**By Timeline**:

```
product/
├── current/
├── backlog/
└── archived/
    ├── 2024-q4/
    └── 2025-q1/
```

### File Naming Conventions

#### Recommended Patterns

- **Epics**: `epic-{name}.yaml` (e.g., `epic-user-auth.yaml`)
- **Tickets**: `ticket-{name}.yaml` (e.g., `ticket-jwt-validation.yaml`)
- **Descriptive names**: Match the `metadata.name` field for consistency

#### Tools Integration

- File names SHOULD be URL-safe and git-friendly
- Avoid spaces, special characters, and case sensitivity issues
- Consider tool limitations when choosing naming patterns

### Scaling Considerations

#### Small Teams (1-5 people)

- Single `product.yaml` file or simple epic/ticket separation
- Minimal directory structure to reduce overhead

#### Medium Teams (5-20 people)

- Epic-based organization with clear ownership boundaries
- Separate directories for different product areas

#### Large Teams (20+ people)

- Feature area organization with team ownership
- Archived directories for completed work
- Custom schemas for specialized workflows

### Benefits of Organized Structure

**Developer Experience**:

- Predictable file locations for AI context generation
- Clear git history and change attribution
- Easier navigation and discovery

**Team Collaboration**:

- Reduced merge conflicts through logical separation
- Clear ownership boundaries
- Consistent patterns across projects

**Tool Integration**:

- Efficient indexing and search capabilities
- Automated validation and processing
- Better performance with large projects

### Migration Path

Teams adopting Product as Code can start simple and evolve their organization:

1. **Start**: Single `product.yaml` file
2. **Grow**: Separate epics and tickets into directories
3. **Scale**: Add grouping strategies and archived sections
4. **Optimize**: Custom schemas and team-specific patterns

This appendix provides guidance while maintaining the flexibility teams need to
adapt PaC to their specific workflows and constraints.

## Appendix C: Revision History

| Version | Date       | Notes                                                |
| ------- | ---------- | ---------------------------------------------------- |
| 0.1.0   | 2025-01-25 | Initial release of the Product as Code Specification |
