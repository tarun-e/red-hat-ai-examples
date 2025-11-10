# CI/CD Quick Reference Card

## 🚀 Quick Start (First Time Setup)

```bash
# One-line setup
./setup-dev.sh

# Or manually
pip install -r requirements-dev.txt
pre-commit install
```

## 📝 Daily Workflow

```bash
# 1. Before you start coding
git checkout -b feature/your-feature-name

# 2. Write your code
# ... make changes ...

# 3. Format code (auto-fix)
make format

# 4. Check for issues
make lint

# 5. Run tests
make test

# 6. Commit (pre-commit hooks run automatically)
git add .
git commit -m "feat: your change description"

# 7. Push and create PR
git push origin feature/your-feature-name
```

## ⚡ Quick Commands

| Command | What it does |
|---------|--------------|
| `make format` | Auto-format Python files and notebooks |
| `make lint` | Check code quality (Ruff, Flake8, MyPy) |
| `make test` | Run all tests with coverage |
| `make security` | Run security checks |
| `make notebooks` | Format and lint notebooks |
| `make check-all` | Run ALL checks before PR |
| `make clean` | Remove cache files |

## 🔧 Fixing Common Issues

### "Black would reformat X files"
```bash
black --line-length=100 .
```

### "isort would reformat X files"
```bash
isort --profile black --line-length 100 .
```

### "Ruff found X errors"
```bash
ruff check --fix .
```

### "Notebook outputs not stripped"
```bash
nbstripout **/*.ipynb
```

### "Pre-commit hooks failed"
```bash
# See what's wrong
pre-commit run --all-files

# Update hooks
pre-commit autoupdate

# Clear cache if needed
pre-commit clean
```

## 📓 Jupyter Notebook Checklist

Before committing notebooks:

- [ ] Run `make notebooks` to format and strip outputs
- [ ] Ensure cells execute in order (Kernel → Restart & Run All)
- [ ] Add markdown cells explaining what code does
- [ ] No hardcoded credentials or secrets
- [ ] Outputs are stripped (check with `git diff`)

## 🎯 PR Checklist

Before creating a pull request:

- [ ] `make format` - Code formatted
- [ ] `make lint` - No linting errors
- [ ] `make test` - All tests pass
- [ ] `make security` - No security issues
- [ ] Pre-commit hooks pass
- [ ] Branch is up to date with main
- [ ] Descriptive commit messages
- [ ] PR description filled out

## 🤖 What Happens in CI

### On Every Commit (Pre-commit Hooks)
1. Trailing whitespace removed
2. Files formatted (Black, isort)
3. Code linted (Ruff)
4. Type checked (MyPy)
5. Security scanned (Bandit)
6. Notebook outputs stripped

### On Every PR
1. **Code Quality Checks** - Linting, formatting, type checking
2. **Tests** - Run on Python 3.9, 3.10, 3.11
3. **Notebook Validation** - Check notebooks execute
4. **Security Scans** - Check dependencies and code
5. **Inline Comments** - Reviewdog posts issues on specific lines
6. **Summary Comment** - Overall quality report posted

## 🛠️ Tool Configuration

All tools configured in **`pyproject.toml`**:

```toml
[tool.black]
line-length = 100

[tool.ruff]
line-length = 100
select = ["E", "W", "F", "I", "C", "B", "UP"]

[tool.pytest]
testpaths = ["tests"]
```

## 🚨 When Things Go Wrong

### CI failing but local checks pass?
- Check Python version matches (3.9+)
- Ensure all deps installed: `pip install -r requirements-dev.txt`
- Check GitHub Actions logs for details

### Can't push because pre-commit fails?
```bash
# Fix the issues first
make format
make lint

# Or skip hooks (NOT recommended)
git commit --no-verify
```

### Need to update a dependency?
- Edit `requirements-dev.txt` or project `requirements.txt`
- Run `pip install -r requirements-dev.txt`
- Test that everything works
- Commit changes

## 📚 Documentation

- **Full CI Setup**: [CI_SETUP.md](CI_SETUP.md)
- **Contributing Guide**: [../CONTRIBUTING.md](../CONTRIBUTING.md)
- **Implementation Summary**: [CI_IMPLEMENTATION_SUMMARY.md](CI_IMPLEMENTATION_SUMMARY.md)

## 💡 Pro Tips

1. **Run checks before committing**: Save time by catching issues early
   ```bash
   make check-all
   ```

2. **Fix formatting automatically**: Don't manually format
   ```bash
   make format
   ```

3. **Use Makefile**: It's faster than typing full commands
   ```bash
   make lint  # instead of: ruff check . && flake8 . && mypy .
   ```

4. **Check specific files only**:
   ```bash
   black --check path/to/file.py
   ruff check path/to/file.py
   ```

5. **Skip slow hooks temporarily**:
   ```bash
   SKIP=mypy git commit -m "your message"
   ```

6. **Run single pre-commit hook**:
   ```bash
   pre-commit run black --all-files
   ```

## 🎓 Learning Resources

- [Black Documentation](https://black.readthedocs.io/)
- [Ruff Rules](https://docs.astral.sh/ruff/rules/)
- [Pytest Guide](https://docs.pytest.org/)
- [Pre-commit Hooks](https://pre-commit.com/)

---

**Need help?** Open an issue or check the full documentation!
