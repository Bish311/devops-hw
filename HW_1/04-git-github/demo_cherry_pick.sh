#!/usr/bin/env bash
set -e

DEMO_DIR="/tmp/git_cherry_pick_demo"
rm -rf "$DEMO_DIR"
mkdir -p "$DEMO_DIR"
cd "$DEMO_DIR"

git init -b main
git config user.name "Bishwayan"
git config user.email "bish@example.com"

echo "=== Task 1 Demonstration: git commit -m vs git commit -a -m ==="
echo "initial project notes" > file1.txt
git add file1.txt
git commit -m "Initialize project structure"

echo "modified line" >> file1.txt
echo "new untracked file" > file2.txt

# git commit -m without staging modified changes would fail to commit the modifications
# git commit -a -m automatically stages modifications to tracked files (file1.txt),
# but strictly ignores newly created untracked files (file2.txt).
git commit -a -m "Update existing tracked file via automatic staging"

echo "Status after git commit -a -m (untracked file remains unstaged):"
git status -s

git add file2.txt
git commit -m "Add secondary project file"

echo "=== Task 2 Demonstration: Git Cherry-Pick ==="
echo "main commit 3 content" > main_feature.txt
git add main_feature.txt
git commit -m "Add main feature core logic"

echo "Commits on main branch prior to branching:"
git log --oneline

git checkout -b feature-branch

echo "branch feature A" > feature_a.txt
git add feature_a.txt
git commit -m "Implement feature component A"

echo "branch feature B critical patch" > feature_b.txt
git add feature_b.txt
git commit -m "Apply standalone patch B for production"

echo "branch feature C" > feature_c.txt
git add feature_c.txt
git commit -m "Implement feature component C"

echo "Commits on feature-branch:"
git log --oneline -n 3

TARGET_COMMIT=$(git log --grep="Apply standalone patch B" --format="%h")
echo "Selected commit for cherry-pick: $TARGET_COMMIT"

git checkout main
echo "Current main branch before cherry-pick:"
git log --oneline

git cherry-pick "$TARGET_COMMIT"

echo "Main branch git log after cherry-picking $TARGET_COMMIT:"
git log --oneline -n 5

echo "Verifying cherry-picked file exists on main:"
ls -l feature_b.txt
cat feature_b.txt

rm -rf "$DEMO_DIR"
echo "Git tasks executed and verified successfully."
