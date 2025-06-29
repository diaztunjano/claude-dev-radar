# Git Workflow Guide

## Branch Strategy
- `main`: Production-ready code
- `develop`: Integration branch for features
- `feature/epic-xxx-description`: Feature branches for epics
- `fix/issue-xxx-description`: Bug fix branches

## Commit Message Format
```
[TYPE](scope): description

Epic: #epic-number
Issue: #issue-number
```

### Types
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation changes
- `refactor`: Code refactoring
- `test`: Adding tests
- `chore`: Maintenance tasks

## Workflow
1. Create feature branch from develop
2. Work on epic/issue
3. Commit regularly with descriptive messages
4. Push branch and create pull request
5. Code review and merge

## Commands
```bash
# Start new epic
git checkout develop
git pull origin develop
git checkout -b feature/epic-001-authentication

# Work and commit
git add .
git commit -m "feat(auth): implement user login component

Epic: #1
Issue: #123"

# Push and create PR
git push origin feature/epic-001-authentication
```
