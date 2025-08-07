# Notion Task Refinement

## Purpose

Refine and improve Notion task descriptions to provide better context and enable faster, more accurate AI execution.

## When to Use Task Refinement

- Tasks with vague or incomplete requirements
- Tasks lacking technical specifications  
- Tasks missing acceptance criteria
- Tasks with unclear implementation approach
- Tasks that previously resulted in low confidence ratings
- When user explicitly requests task improvement

## Refinement Workflow

### 1. TASK ASSESSMENT
- Analyze current task for clarity gaps and missing context
- Identify vague requirements or unclear specifications
- **MANDATORY CODEBASE RESEARCH**: Before making any assumptions, search and examine the codebase to understand:
  - Existing architecture and patterns
  - Current technology stack and dependencies
  - File structure and naming conventions
  - Similar implementations or existing features
  - Code quality standards and testing approaches
- Evaluate technical feasibility based on codebase findings
- Check for missing acceptance criteria, dependencies, or success metrics

### 2. COMPLETE PAGE CLEARING
- **CRITICAL**: Use Notion MCP server to delete ALL existing blocks from the page
- Preserve only the page properties (title, status, order, branch, etc.)
- Ensure page content is completely cleared before adding improved version

### 3. IMPROVED CONTENT GENERATION

**CRITICAL**: Base all content on actual codebase findings, not assumptions.

Create structured, comprehensive task description using this format:

```
# [Task Title]

## Overview
[Clear, concise 2-3 sentence summary based on codebase analysis]

## Requirements
### Functional Requirements
- [Requirements derived from codebase patterns and existing features]
- [Specific, testable requirements based on similar implementations]

### Technical Requirements
- [ACTUAL technology stack found in codebase - package.json, requirements.txt, etc.]
- [Performance requirements based on existing benchmarks/patterns]
- [Security considerations from codebase security patterns]
- [Compatibility requirements from existing configurations]

## Implementation Approach
### Architecture
[Architecture decisions based on EXISTING codebase patterns and structure]

### Step-by-Step Implementation
1. [Steps based on similar implementations found in codebase]
2. [ACTUAL file names, directory structure, and function patterns from codebase]
3. [Error handling patterns observed in existing code]

### Code Examples/Pseudocode
```language
[Examples based on EXISTING code patterns, not assumptions]
[Use actual function signatures and patterns found in codebase]
```

## Acceptance Criteria
- [ ] [Criteria based on existing feature acceptance patterns]
- [ ] [Test patterns observed in codebase]
- [ ] [Performance criteria from existing benchmarks]
- [ ] [User experience criteria from existing UI patterns]

## Dependencies
### Technical Dependencies
- [ACTUAL dependencies from package.json/requirements/etc.]
- [Version requirements from existing dependency management]

### Task Dependencies
- [Dependencies based on codebase architecture and file relationships]
- [Blocking issues identified through code analysis]

## Testing Requirements
- [ ] [Test patterns matching existing test structure and frameworks]
- [ ] [Integration test patterns from codebase]
- [ ] [Manual testing approaches used in existing features]

## Success Metrics
- [Metrics based on existing performance monitoring in codebase]
- [Benchmarks from similar existing features]
- [User satisfaction patterns from existing implementations]

## Risk Assessment
### High Risk
- [Risks identified through codebase analysis] → [Mitigation from existing patterns]

### Medium Risk  
- [Technical risks based on dependency analysis] → [Solutions used elsewhere in codebase]

## Estimated Effort
**Time Estimate**: [Based on similar feature complexity found in codebase]
**Complexity**: [Based on architectural complexity and dependencies found]
**Reasoning**: [Explanation referencing specific codebase evidence and patterns]

## Additional Context
[Context derived from codebase documentation, comments, and existing implementations]
```

### 4. QUALITY VALIDATION
- Ensure all sections reference actual codebase evidence
- Verify acceptance criteria match existing testing patterns
- Confirm technical approach uses existing architectural patterns
- Check that dependencies match actual project dependencies
- Validate all file paths, function names, and technical details against codebase

### 5. REFINEMENT COMPLETION
- Update page with improved structured content
- Preserve all original page properties (order, branch, etc.)
- Add comment documenting refinement with timestamp
- Mark original task as refined for tracking purposes

## Refinement Success Criteria

A well-refined task should:
- Have zero ambiguity in requirements based on codebase analysis
- Include specific technical implementation details derived from existing code patterns
- Provide clear acceptance criteria matching existing test and quality patterns
- Identify all dependencies and risks through actual codebase examination
- Reference specific files, functions, and architectural patterns from the codebase
- Enable high-confidence AI execution (>90%) through evidence-based specifications

## Environment Requirements

The Notion MCP server MUST be configured and available for page content manipulation.