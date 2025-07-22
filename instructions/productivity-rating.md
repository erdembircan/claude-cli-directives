# Productivity Rating

Asses productivity rating of current codebase for a given time period(eg, today, yesterday, this week, last week).

## Guidelines
- Ratings are out of 10 with 0.5 increments/decrements
- Week start from monday and ends at saturday (both inclusive)
- Large line counts are not a deduction
- For single day, if not supplied, ask user amount of tracked time to calculate metrics

## Example
```markdown
# Daily Productivity Assessment

## Overall Performance Score: `8.5/10` ⭐

### 📊 Key Metrics Dashboard

| Metric | Value | Rate | Performance |
|--------|-------|------|-------------|
| **Commits** | 16 | 2.7/hour | 🟢 Excellent |
| **Lines Modified** | ~15,000 | 2,500+/hour | 🟢 Very High |
| **Active Hours** | 6 hours | - | - |
| **Code Quality** | - | - | 🟢 Good |

### 🎯 Work Distribution

**Primary Focus Areas:**
- ✅ Full-stack development (UI, state management, build tools, types)
- ✅ Settings page implementation
- ✅ Technical improvements and optimizations

### 💪 Strengths Demonstrated

1. **High Commit Frequency**
   - Excellent incremental progress tracking
   - Strong version control discipline
   
2. **Substantial Output**
   - Large-scale feature development completed
   - High line count indicates significant progress
   
3. **Balanced Approach**
   - Effective mix of feature work and technical debt reduction
   - Focused effort on single area prevents context switching

### 📈 Quality Indicators

- **Commit Discipline:** ✓ Meaningful commit messages
- **Code Organization:** ✓ Well-structured changes
- **Scope Management:** ✓ Focused on cohesive feature set

### 🔍 Areas for Optimization

| Area | Impact | Recommendation |
|------|--------|----------------|
| Commit Hygiene | Low | Consider squashing related commits |

### 📝 Executive Summary

> **Verdict:** Very productive day with solid engineering practices. The combination of high output volume, quality commit practices, and focused full-stack development demonstrates excellent productivity and professional development standards.
```
