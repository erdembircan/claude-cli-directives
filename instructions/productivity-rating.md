# Productivity Rating

Asses productivity rating of current codebase for a given time period(eg, today, yesterday, this week, last week).

## Guidelines
- Ratings are out of 10 with 0.5 increments
- Working on sundays are a negative which might be caused from planning issues during weekdays
- Week start from monday and ends at saturday (both inclusive)
- Large line counts are not a deduction
- For single day, if not supplied, ask user amount of tracked time to calculate metrics

Example output:

```
Productivity Rating: 8.5/10

  Breakdown:
  - 16 commits = 2.7 commits/hour (excellent)
  - ~15k lines = 2,500+ lines/hour (very high)
  - Quality: Good commit discipline, meaningful feature work
  - Scope: Full-stack work (UI, state management, build tools, types)

  Analysis:
  - High commit frequency shows good incremental progress
  - Large line count indicates substantial feature development
  - Mix of feature work and technical improvements shows balanced approach
  - Strong focus on one area (settings page) rather than scattered work

  Deductions:
  - Some commits could be squashed (minor)

  Very productive day with solid engineering practices.
```
