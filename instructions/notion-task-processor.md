# Notion Task Processor

## CRITICAL: FOLLOW EVERY STEP EXACTLY - NO SHORTCUTS OR ASSUMPTIONS

When the user asks to process AI tasks from Notion boards, **EXECUTE THE COMPLETE WORKFLOW** without skipping any steps.

## Setup Requirements

The Notion MCP server MUST be configured and available. No additional API authentication setup is required.

## MANDATORY EXECUTION WORKFLOW

**EXECUTE ALL STEPS IN SEQUENCE - DO NOT SKIP OR MODIFY:**

1. **Database Setup**: 
   - Check for `NOTION_URL` in `.env` file to extract database ID
   - If not found in `.env`, request Notion database URL from user

2. **Board Identification**: Extract database ID from `NOTION_URL` in `.env` file or from Notion URLs (format: `https://www.notion.so/{database_id}?v={view_id}`) or use provided database ID.

3. **Task Discovery**: Use Notion MCP server to query the database for tasks with status 'AI' or similar AI-assignment indicators.

4. **Task Analysis**: For each AI-assigned task, extract using MCP server calls:
   - **Complete Page Reading**: Read the ENTIRE page content including all todo lists, sub-lists, bullet points, sub-elements, code blocks, and detailed specifications. This is context engineering, not vibe coding - every detail matters for proper implementation
   - Task title and description
   - Priority level and due dates
   - Required deliverables or acceptance criteria
   - Dependencies or prerequisites
   - Order (`order` property) - numeric value to determine task execution sequence
   - Branch merge (`branch_merge` property) - the branch to checkout from and merge to when told (defaults to `development`)
   - Branch name (`branch` property) - overrides automatic branch name generation if specified
   - Any specific instructions or context
   - All implementation details, specifications, and requirements found in nested lists and sub-elements

5. **Initial Git Setup**: After analyzing all tasks:
   - Check current git status
   - Ensure working directory is clean before proceeding

6. **Task Prioritization**: Organize discovered tasks by:
   - Order property (PRIMARY: if `order` property exists, sort tasks by this numeric value first)
   - Dependencies and logical sequence (SECONDARY: tasks with dependencies must be sorted after their prerequisites)
   - Urgency and importance
   - Resource requirements
   - Estimated effort

7. **Task Execution**: FOR EACH TASK IN PRIORITY ORDER - EXECUTE COMPLETELY:
   
   **A. MANDATORY PRE-TASK SETUP (DO NOT SKIP):**
   - **Task ID Assignment**: ALWAYS set page ID as task ID and update `task-id` property on the page
   - **Branch Management (EXECUTE IN ORDER):**
     1. Extract `branch_merge` from task (default: `development`)
     2. `git checkout {branch_merge}` and `git pull origin {branch_merge}`
     3. **BRANCH NAME DETERMINATION - FOLLOW EXACTLY:**
        ```
        IF task has 'branch' property:
            working_branch_name = task.branch (EXACT VALUE)
        ELSE:
            working_branch_name = "notion-task-" + page_id_without_dashes
        ```
     4. `git checkout -b {working_branch_name}` (or `git checkout {working_branch_name}` if exists)
     
     **EXAMPLES:**
     - Task has branch="development" → USE "development"
     - Task has branch="feature-xyz" → USE "feature-xyz"  
     - Task has NO branch property → USE "notion-task-abc123def456"
   
   **B. CONFIDENCE ASSESSMENT (MANDATORY):**
   - Calculate confidence (1-100): Task clarity (25) + Context (25) + Technical feasibility (25) + Dependencies (25)
   - IF confidence < 70: SKIP task execution, proceed to step D
   - IF confidence ≥ 70: CONTINUE to step C
   
   **C. TASK IMPLEMENTATION (IF CONFIDENCE ≥ 70):**
   - Break down into actionable steps
   - **IMPLEMENT COMPLETELY**: All code changes, fixes, features per specifications
   - Recalculate confidence after implementation
   - IF final confidence < 70: `git reset --hard HEAD && git clean -fd`
   - IF final confidence ≥ 70: Commit with proper message
   
   **D. MANDATORY POST-TASK ACTIONS (NEVER SKIP):**
   - Mark task checkbox as completed in Notion (if confidence ≥ 70)
   - Apply strikethrough formatting to completed content
   **E. MANDATORY LOGGING (EXECUTE IMMEDIATELY AFTER EACH TASK):**
   - Add comment to Notion task using EXACT format:
   ```
   Date:                    YYYY-MM-DD HH:MM:SS
   Task ID:                 [page_id]
   Task:                    [Brief task description]
   Status:                  COMPLETED/SKIPPED/ROLLED BACK
   Branch:                  [Branch name used]
   Description:             [What was done or why skipped]
   Final confidence rating: XX/100
   Confidence breakdown:    [If <100, list factors with explanations]
   ```
   - Log to file: `notion-task-processor.log` (root) or `logs/notion-task-processor.log`
   - If neither exists, create in root with header:
   ```
   # Notion Task Processor Log
   # Automated task processing results with status and confidence ratings
   # Generated when processing AI-assigned tasks from Notion boards
   
   ```

8. **Status Management**: Use Notion MCP server to maintain accurate task status updates:
   - DO NOT move completed pages to 'Done' status - instead mark task checkbox as checked
   - DO NOT update task title - leave original title unchanged
   - **Task Completion Formatting**: When a task is completed, update the page content to:
     - Check any task-related checkboxes within the page content
     - Apply strikethrough formatting to completed text and list items
     - Update the task description to show completion status while preserving the page ID format
   - Flag any blockers or issues requiring human intervention

9. **Git Integration**: Throughout the process:
   - Make regular commits for each completed task or logical chunk
   - Use descriptive commit messages that reference the Notion task
   - Keep the branch up to date with completed work
   - Prepare branch for review/merge when all tasks are complete

10. **Final Reporting**: At the end of the session, provide a comprehensive summary:
    - Total tasks found and processed
    - Tasks completed successfully with confidence ratings
    - Tasks skipped due to low confidence with reasons
    - Any issues encountered and how they were handled
    - Git branch created and commit summary
    - Notion board synchronization status

## Environment Variables

**Example .env file configuration:**
```bash
# Notion Database URL
# Copy the URL from your Notion database page
NOTION_URL=https://www.notion.so/example123abc456def789/your-database-name?v=view789xyz123
```

## Quality Assurance
- Verify task completion against acceptance criteria
- Ensure all deliverables meet specified requirements
- Double-check that status updates are accurate
- Provide clear documentation of work performed

## Git Commands for Branch Management

**Checkout to merge branch (from task's branch_merge property or default to development):**
```bash
git checkout {branch_merge_or_development}
git pull origin {branch_merge_or_development}
```

**Create and checkout new branch from merge branch:**
```bash
# BRANCH NAME LOGIC - PRIORITY ORDER:
# **FIRST PRIORITY**: IF task has 'branch' property: USE THAT EXACT VALUE
# **FALLBACK ONLY**: ELSE use notion-task-{page_id_without_dashes}
git checkout -b {working_branch_name}
```

**Switch to existing branch:**
```bash
git checkout {working_branch_name}
```

**Check if branch exists:**
```bash
git branch -l {working_branch_name}
```

**Commit with task reference:**
```bash
git commit -m "[FEAT]: implement task from Notion - {task_title}"
```

**Rollback changes for low confidence tasks:**
```bash
# Reset all changes back to HEAD (before task execution)
git reset --hard HEAD
# Remove untracked files
git clean -fd
```

## Error Handling
- If MCP server connection fails, verify Notion MCP server is configured and running
- If board access fails, verify database ID is correct
- If git operations fail, ensure repository is in clean state
- If task details are unclear, flag for clarification before proceeding
- If dependencies are missing, identify and communicate blockers
- Handle MCP server rate limits and connection errors gracefully
