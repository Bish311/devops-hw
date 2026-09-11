BISHWAYAN CHATTERJEE -- 24BCS10200

# Git & GitHub Fundamentals

This module demonstrates working with the Git staging lifecycle, understanding `git commit -a -m` mechanics, and performing selective commit integration using `git cherry-pick`.

---

## Task 1: `git commit -a -m` vs `git commit -m`

### Core Mechanism
- **`git commit -m "message"`**: Commits files that are **already staged in the index** (via `git add`). Any modified tracked files or untracked files that were not staged will NOT be included in the commit.
- **`git commit -a -m "message"`**: Automatically stages and commits all modified or deleted **tracked files** in a single operation.
  - **Crucial Invariant:** The `-a` flag does **NOT** stage newly created **untracked** files. New files must still be explicitly added using `git add <file>`.

### Comparison Matrix

| Property | `git commit -m` | `git commit -a -m` |
|---|---|---|
| **Staged changes committed** | Yes | Yes |
| **Modified tracked files automatically committed** | No (must run `git add` first) | Yes (stages modifications in memory) |
| **Deleted tracked files automatically committed** | No | Yes |
| **New untracked files committed** | No | **No (ignored)** |

### Command Walkthrough & Output

```bash
# 1. Modify existing tracked file and create brand new file
echo "Updated parameters" >> tracked_file.txt
echo "New secret keys" > untracked_file.txt

# 2. Execute git commit -a -m
git commit -a -m "Update existing tracked configuration"

# 3. Check git status
git status -s
# Output:
# ?? untracked_file.txt
# (Notice tracked_file.txt is cleanly committed, while untracked_file.txt remains untracked)
```

---

## Task 2: Git Cherry-Pick Workflow

`git cherry-pick <commit-hash>` applies the exact diff introduced by an existing commit from another branch onto the current working branch, generating a new commit with its own unique SHA on the destination branch.

### Step-by-Step Workflow

#### 1. Initial Commits on `main` Branch
```bash
git checkout main
git log --oneline
```
Output:
```text
c4a10e1 Add main feature core logic
8f921d4 Add secondary project file
1a783b2 Initialize project structure
```

#### 2. Create Feature Branch and Commit Isolated Work
```bash
git checkout -b feature-branch
# Make 3 commits
git log --oneline -n 3
```
Output:
```text
e93b120 Implement feature component C
7d41f0a Apply standalone patch B for production
5b20c99 Implement feature component A
```

#### 3. Cherry-Pick Selected Commit into `main`
We wish to backport only `Apply standalone patch B for production` (`7d41f0a`) without bringing in component A or component C.

```bash
# Switch back to main
git checkout main

# Cherry pick commit 7d41f0a
git cherry-pick 7d41f0a
```
Output:
```text
[main 2f0e911] Apply standalone patch B for production
 Date: Fri Sep 11 11:45:00 2026 +0000
 1 file changed, 1 insertion(+)
 create mode 100644 feature_b.txt
```

#### 4. Verification on `main`
```bash
git log --oneline -n 4
```
Output:
```text
2f0e911 Apply standalone patch B for production
c4a10e1 Add main feature core logic
8f921d4 Add secondary project file
1a783b2 Initialize project structure
```

Notice that the patch commit is now part of `main` history with a new commit hash (`2f0e911`), while commits `5b20c99` and `e93b120` remain strictly isolated in `feature-branch`.

---

## 3. Verified Execution Output (Git Bash Run)

```text
Initialized empty Git repository in C:/Users/Bishwayan Chatterjee/AppData/Local/Temp/git_cherry_pick_demo/.git/
=== Task 1 Demonstration: git commit -m vs git commit -a -m ===
[main (root-commit) 994873f] Initialize project structure
 1 file changed, 1 insertion(+)
 create mode 100644 file1.txt
[main 4ff1cda] Update existing tracked file via automatic staging
 1 file changed, 1 insertion(+)
Status after git commit -a -m (untracked file remains unstaged):
?? file2.txt
[main a211343] Add secondary project file
 1 file changed, 1 insertion(+)
 create mode 100644 file2.txt

=== Task 2 Demonstration: Git Cherry-Pick ===
[main 29700ca] Add main feature core logic
 1 file changed, 1 insertion(+)
 create mode 100644 main_feature.txt
Commits on main branch prior to branching:
29700ca Add main feature core logic
a211343 Add secondary project file
4ff1cda Update existing tracked file via automatic staging
994873f Initialize project structure
Switched to a new branch 'feature-branch'
[feature-branch 504bb21] Implement feature component A
 1 file changed, 1 insertion(+)
 create mode 100644 feature_a.txt
[feature-branch 1c72f86] Apply standalone patch B for production
 1 file changed, 1 insertion(+)
 create mode 100644 feature_b.txt
[feature-branch 72b6080] Implement feature component C
 1 file changed, 1 insertion(+)
 create mode 100644 feature_c.txt
Commits on feature-branch:
72b6080 Implement feature component C
1c72f86 Apply standalone patch B for production
504bb21 Implement feature component A
Selected commit for cherry-pick: 1c72f86
Switched to branch 'main'
Current main branch before cherry-pick:
29700ca Add main feature core logic
a211343 Add secondary project file
4ff1cda Update existing tracked file via automatic staging
994873f Initialize project structure
[main 5cc3522] Apply standalone patch B for production
 Date: Fri Sep 11 21:36:20 2026 +0530
 1 file changed, 1 insertion(+)
 create mode 100644 feature_b.txt
Main branch git log after cherry-picking 1c72f86:
5cc3522 Apply standalone patch B for production
29700ca Add main feature core logic
a211343 Add secondary project file
4ff1cda Update existing tracked file via automatic staging
994873f Initialize project structure
Verifying cherry-picked file exists on main:
-rw-r--r-- 1 Bishwayan Chatterjee 197609 33 Sep 11 21:36 feature_b.txt
branch feature B critical patch
Git tasks executed and verified successfully.
```
