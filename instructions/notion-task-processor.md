# Notion Task Processor

When the user asks to process AI tasks from Notion boards, automatically find and complete tasks assigned to AI using the Notion MCP server.

## Setup Requirements

The Notion MCP server should be configured and available for accessing Notion databases and pages. No additional API authentication setup is required as the MCP server handles the connection.

## Workflow Process

When processing Notion AI tasks, complete the entire workflow autonomously:

1. **Database Setup**: 
   - Check for `NOTION_URL` in `.env` file to extract database ID
   - If not found in `.env`, request Notion database URL from user

2. **Board Identification**: Extract database ID from `NOTION_URL` in `.env` file or from Notion URLs (format: `https://www.notion.so/{database_id}?v={view_id}`) or use provided database ID.

3. **Task Discovery**: Use Notion MCP server to query the database for tasks with status 'AI' or similar AI-assignment indicators.

4. **Task Analysis**: For each AI-assigned task, extract using MCP server calls:
   - **Complete Page Reading**: Read the ENTIRE page content including all todo lists, sub-lists, bullet points, sub-elements, code blocks, and detailed specifications. This is context engineering, not vibe coding - every detail matters for proper implementation
   - **Assign task ID**: Use the page ID as the task ID and update/create the `task-id` property on the page with this value
   - Task title and description
   - Priority level and due dates
   - Required deliverables or acceptance criteria
   - Dependencies or prerequisites
   - Order (`order` property) - numeric value to determine task execution sequence
   - Branch merge (`branch_merge` property) - the branch to checkout from and merge to when told (defaults to `development`)
   - Branch name (`branch` property) - overrides automatic branch name generation if specified
   - Any specific instructions or context
   - All implementation details, specifications, and requirements found in nested lists and sub-elements

5. **Git Branch Management**: After analyzing all tasks:
   - Check current git status
   - Determine branch configuration from analyzed tasks:
     - Use `branch_merge` property from tasks to determine which branch to checkout from and merge to when told (defaults to `development` if not specified)
     - Use `branch` property from tasks to override automatic branch name generation
   - Checkout to the specified merge branch (from `branch_merge` or default to `development`) and ensure it's up to date
   - Determine the working branch name:
     - If any task has a `branch` property specified, use that as the branch name
     - Otherwise, use the default format `ai-tasks-YYYY-MM-DD` (using today's date)
   - Create and checkout to the working branch from the merge branch
   - If the working branch already exists, switch to it instead of creating
   - Ensure working directory is clean before proceeding

6. **Task Prioritization**: Organize discovered tasks by:
   - Order property (PRIMARY: if `order` property exists, sort tasks by this numeric value first)
   - Dependencies and logical sequence (SECONDARY: tasks with dependencies must be sorted after their prerequisites)
   - Urgency and importance
   - Resource requirements
   - Estimated effort

7. **Task Execution**: Begin working on tasks in priority order and COMPLETE EACH TASK FULLY:
   - **Confidence Rating Assessment**: Before starting any task, calculate a confidence rating (1-100) based on:
     - Task clarity and specificity (25 points)
     - Available context and requirements (25 points)
     - Technical feasibility with current codebase (25 points)
     - Dependencies and prerequisites availability (25 points)
   - **Confidence Threshold Check**: Only proceed with task execution if initial confidence rating ≥ 70
   - If confidence < 70, skip task execution
   - Break down complex tasks into actionable steps
   - **EXECUTE TASKS COMPLETELY**: Implement all code changes, fixes, and features according to specifications
   - **Post-Fix Confidence Recalculation**: After completing any fixes or implementations, recalculate confidence rating
   - **Rollback Decision**: If final confidence rating < 70:
     - Rollback all changes made during task execution using git reset
   - **Success Path**: If final confidence rating ≥ 70:
     - Keep all changes and commit with appropriate messages
     - Update task status in Notion via MCP server as work progresses
     - Mark task checkbox as completed in Notion
     - Document progress and deliverables
   - **REQUIRED IMMEDIATELY AFTER EACH TASK**: Add comment to Notion task immediately after processing each individual task (NOT when all tasks are completed) using this exact format:
     ```
     Date:                    YYYY-MM-DD HH:MM:SS
     Task ID:                 [page_id]
     Task:                    [Short brief description of what was tasked]
     Status:                  COMPLETED/SKIPPED/ROLLED BACK
     Branch:                  [Branch where changes were made]
     Description:             [Short brief explanation of what was done or why it was skipped]
     Final confidence rating: XX/100
     Confidence breakdown:    [Only if rating below 100, list specific factors that reduced the score with short detailed explanations]
     ```
   - **LOG TO FILE**: Immediately after adding the comment to Notion, prepend the same comment content using the exact format above to `notion-task-processor.log` in the project root for local tracking (newest entries first)
     - If the log file doesn't exist in the project root, check for a `logs` directory and use `logs/notion-task-processor.log` instead
     - If neither location exists, create the log file in the project root with a header describing its purpose:
       ```
       # Notion Task Processor Log
       # This file logs task completion comments from the automated Notion task processor.
       # Each entry shows AI task processing results including status, confidence ratings, and outcomes.
       # Generated automatically when processing tasks assigned to AI in Notion boards.
       
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
# Use branch property if specified, otherwise use ai-tasks-YYYY-MM-DD format
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
