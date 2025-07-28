# Notion Task Processor

When the user asks to process AI tasks from Notion boards, automatically find and complete tasks assigned to AI using the Notion API.

## Setup Requirements

To use this feature, ensure:

1. **Notion Integration**: Create at https://www.notion.so/my-integrations and share your database with the integration
2. **Environment Setup**: Add `NOTION_TOKEN` and `NOTION_URL` to `.env` file (see examples below)


## Notion API Integration

You have access to Notion API capabilities through HTTP requests. Use these endpoints:

**Authentication**: Include `Authorization: Bearer {token}` header with all requests where `{token}` is the integration token.

**Key API Endpoints**:
- `GET https://api.notion.com/v1/databases/{database_id}/query` - Query database for tasks
- `PATCH https://api.notion.com/v1/pages/{page_id}` - Update task status/properties
- `GET https://api.notion.com/v1/pages/{page_id}` - Get task details
- `POST https://api.notion.com/v1/pages/{page_id}/comments` - Add comments to tasks

**Required Headers**:
```
Authorization: Bearer {notion_token}
Content-Type: application/json
Notion-Version: 2022-06-28
```

## Token and Access Setup

Before processing tasks, you need:
1. **Notion Integration Token** - First check for `NOTION_TOKEN` in `.env` file, if not found ask user to provide
2. **Database ID** - First check for `NOTION_URL` in `.env` file to extract database ID, if not found ask user to provide
3. **Board Access** - Ensure the integration has access to the target database

## Workflow Process

When processing Notion AI tasks, complete the entire workflow autonomously:

1. **API Setup**: 
   - Check for `NOTION_TOKEN` and `NOTION_URL` in `.env` file first
   - If not found in `.env`, request Notion integration token and database ID from user
   - Extract database ID from `NOTION_URL` if available

2. **Git Branch Management**: Before starting task implementation:
   - Check current git status
   - Check each task for `branch_base` property to determine base branch (defaults to `development` if not specified)
   - Checkout to the specified base branch and ensure it's up to date
   - Create and checkout to a new branch named `ai-tasks-YYYY-MM-DD` (using today's date) from the base branch
   - If branch already exists, switch to it
   - Ensure working directory is clean before proceeding

3. **Board Identification**: Extract database ID from `NOTION_URL` in `.env` file or from Notion URLs (format: `https://www.notion.so/{database_id}?v={view_id}`) or use provided database ID.

4. **Task Discovery**: Use Notion API to query the database for tasks with status 'AI' or similar AI-assignment indicators:
   ```json
   {
     "filter": {
       "property": "Status",
       "select": {
         "equals": "AI"
       }
     }
   }
   ```

5. **Task Analysis**: For each AI-assigned task, extract using API calls:
   - **Assign unique task ID**: Generate a UUID for each task and update the task description format from `some task to do` to `**#[uuid]** some task to do` (within the page content, NOT the page title)
   - Task title and description
   - Priority level and due dates
   - Required deliverables or acceptance criteria
   - Dependencies or prerequisites
   - Branch base (`branch_base` property) - the branch to checkout from (defaults to `development`)
   - Any specific instructions or context

6. **Task Prioritization**: Organize discovered tasks by:
   - Urgency and importance
   - Dependencies and logical sequence
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
     - Update task status in Notion via API as work progresses
     - Mark task checkbox as completed in Notion
     - Document progress and deliverables
   - **REQUIRED IMMEDIATELY AFTER EACH TASK**: Add comment to Notion task immediately after processing each individual task (NOT when all tasks are completed) using this exact format:
     ```
     Date:                    YYYY-MM-DD HH:MM:SS
     Task ID:                 [uuid]
     Task:                    [Short brief description of what was tasked]
     Status:                  COMPLETED/SKIPPED/ROLLED BACK
     Branch:                  [Branch where changes were made]
     Description:             [Short brief explanation of what was done or why it was skipped]
     Final confidence rating: XX/100
     Confidence breakdown:    [Only if rating below 100, list specific factors that reduced the score with short detailed explanations]
     ```
   - **LOG TO FILE**: Immediately after adding the comment to Notion, prepend the same comment content using the exact format above to `notion-task-processor.log` in the project root for local tracking (newest entries first)
     - If the log file doesn't exist, create it with a header describing its purpose:
       ```
       # Notion Task Processor Log
       # This file logs task completion comments from the automated Notion task processor.
       # Each entry shows AI task processing results including status, confidence ratings, and outcomes.
       # Generated automatically when processing tasks assigned to AI in Notion boards.
       
       ```

8. **Status Management**: Use Notion API to maintain accurate task status updates:
   - DO NOT move completed pages to 'Done' status - instead mark task checkbox as checked
   - DO NOT update task title - leave original title unchanged
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
# Notion Task Processor Configuration
# Copy this file to .env and replace with your actual values

# Notion Integration Token
# Get this from https://www.notion.so/my-integrations
NOTION_TOKEN=secret_abc123def456ghi789jkl012mno345pqr678stu

# Notion Database URL
# Copy the URL from your Notion database page
NOTION_URL=https://www.notion.so/example123abc456def789/your-database-name?v=view789xyz123
```

**Read .env file for configuration:**
```bash
# Check if .env file exists and read token/url
if [ -f .env ]; then
  export $(cat .env | grep -v '^#' | xargs)
  echo "Using NOTION_TOKEN from .env"
  echo "Using NOTION_URL from .env: $NOTION_URL"
  # Extract database ID from URL
  DATABASE_ID=$(echo $NOTION_URL | sed 's/.*notion\.so\/\([^?]*\).*/\1/')
else
  echo ".env file not found, please provide token and database ID"
fi
```

## API Usage Examples

**Query for AI tasks**:
```bash
curl -X POST 'https://api.notion.com/v1/databases/{database_id}/query' \
  -H 'Authorization: Bearer {token}' \
  -H 'Content-Type: application/json' \
  -H 'Notion-Version: 2022-06-28' \
  -d '{
    "filter": {
      "property": "Status",
      "select": {
        "equals": "AI"
      }
    }
  }'
```

**Update task status**:
```bash
curl -X PATCH 'https://api.notion.com/v1/pages/{page_id}' \
  -H 'Authorization: Bearer {token}' \
  -H 'Content-Type: application/json' \
  -H 'Notion-Version: 2022-06-28' \
  -d '{
    "properties": {
      "Status": {
        "select": {
          "name": "In Progress"
        }
      }
    }
  }'
```

**Check task checkbox (mark as completed)**:
```bash
curl -X PATCH 'https://api.notion.com/v1/pages/{page_id}' \
  -H 'Authorization: Bearer {token}' \
  -H 'Content-Type: application/json' \
  -H 'Notion-Version: 2022-06-28' \
  -d '{
    "properties": {
      "Done": {
        "checkbox": true
      }
    }
  }'
```

**Add comments to tasks**:
```bash
curl -X POST 'https://api.notion.com/v1/pages/{page_id}/comments' \
  -H 'Authorization: Bearer {token}' \
  -H 'Content-Type: application/json' \
  -H 'Notion-Version: 2022-06-28' \
  -d '{
    "parent": {
      "page_id": "{page_id}"
    },
    "rich_text": [
      {
        "text": {
          "content": "{comment_text}"
        }
      }
    ]
  }'
```


## Quality Assurance
- Verify task completion against acceptance criteria
- Ensure all deliverables meet specified requirements
- Double-check that status updates are accurate
- Provide clear documentation of work performed

## Git Commands for Branch Management

**Checkout to base branch (from task's branch_base property or default to development):**
```bash
git checkout {branch_base_or_development}
git pull origin {branch_base_or_development}
```

**Create and checkout new branch from base:**
```bash
git checkout -b ai-tasks-$(date +%Y-%m-%d)
```

**Switch to existing branch:**
```bash
git checkout ai-tasks-$(date +%Y-%m-%d)
```

**Check if branch exists:**
```bash
git branch -l ai-tasks-$(date +%Y-%m-%d)
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
- If API authentication fails, request valid Notion integration token
- If board access fails, verify integration permissions and database ID
- If git operations fail, ensure repository is in clean state
- If task details are unclear, flag for clarification before proceeding
- If dependencies are missing, identify and communicate blockers
- Handle API rate limits and connection errors gracefully
