
function suitup-git-status {
  git status
}

function suitup-git-push-origin {
  git push origin HEAD
}

function suitup-git-push-origin-force {
  git push origin HEAD -f
}

function suitup-git-log {
  git log --graph --pretty=format:'%Cred%h%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset -%C(yellow)%d%Creset' --abbrev-commit --
}

function suitup-git-current-branch {
  git branch 2>/dev/null | grep '^*' | colrm 1 2
}

function suitup-git-current-remote-branch {
  local current_branch=$(suitup-git-current-branch)
  git config branch.${current_branch}.merge | colrm 1 11
}

function suitup-git-reset-remote-branch {
  local remote_branch=$(suitup-git-current-remote-branch)
  git reset origin/$remote_branch
}

# suitup-git-reset-commit-push 'update'
# suitup-git-reset-commit-push 'update' 'Jack <jack@gmail.com>'
function suitup-git-reset-commit-push {
  git reset origin/master
  suitup-git-commit "$1" "$2"
  git push origin HEAD
}

# suitup-git-reset-commit 'update'
# suitup-git-reset-commit 'update' 'Jack <jack@gmail.com>'
function suitup-git-reset-commit {
  git reset origin/master
  suitup-git-commit "$1" "$2"
}

# suitup-git-commit-push 'update'
# suitup-git-commit-push 'update' 'Jack <jack@gmail.com>'
function suitup-git-commit-push {
  suitup-git-commit "$1" "$2"
  git push origin HEAD
}

# suitup-git-commit 'update'
# suitup-git-commit 'update' 'Jack <jack@gmail.com>'
function suitup-git-commit {
  if [ -n "$1" ]; then
    MESSAGE="$1"
  else
    MESSAGE="No message."
  fi

  if [ -n "$2" ]; then
    AUTHOR="$2"
  fi

  git add .

  if [ -n "$2" ]; then
    git commit -am "$MESSAGE" --author="$AUTHOR"
  else
    git commit -am "$MESSAGE"
  fi
}

# suitup-git-create-issue-branch 666_new_customer
function suitup-git-create-issue-branch {
  ISSUE_NAME=$1

  if [ -n "$ISSUE_NAME" ]; then
    echo "Creating new branch for issue $ISSUE_NAME"
    echo '............................................'
  else
    echo 'Have to input issue name'
    return
  fi

  git checkout master
  git pull origin master
  git push origin master:"$ISSUE_NAME"
  git branch --track "$ISSUE_NAME" origin/"$ISSUE_NAME"
  git checkout "$ISSUE_NAME"
}

# suitup-git-checkout-issue-branch 922_form_toolbar_mirror
function suitup-git-checkout-issue-branch {
  ISSUE_NAME=$1

  if [ -n "$ISSUE_NAME" ]; then
    echo "Checkout issue branch for $ISSUE_NAME"
    echo '............................................'
  else
    echo 'Have to input issue name'
    return
  fi

  git checkout -b $ISSUE_NAME origin/$ISSUE_NAME
}


function suitup-git-diff-master {
  suitup-git-diff master
}

function suitup-git-diff-develop {
  suitup-git-diff develop
}

# If you want to konw?
# What is differents between last and target commits?
# And target commit id is cdf987c1bdf2dfc1e910216804e78ac7ac3700f2.
# Then input:
# suitup-git-diff cdf987c1bdf2dfc1e910216804e78ac7ac3700f2
function suitup-git-diff {
  TARGET=$1
  if [ -z "$TARGET" ]; then
    echo 'Must input a commit id'
    return
  fi

  RESULT_FILE=/tmp/suitup-git-diff.COMMIT_EDITMSG
  rm $RESULT_FILE 2> /dev/null
  touch $RESULT_FILE

  echo '-----------------------------------------' >> $RESULT_FILE
  echo ''                                          >> $RESULT_FILE
  echo "suitup-git-diff"                           >> $RESULT_FILE
  echo "Between HEAD and $TARGET"                  >> $RESULT_FILE
  echo ''                                          >> $RESULT_FILE

  function run-command {
    echo '-----------------------------------------'
    echo ''
    echo "$ $1"
    echo ''
    eval $1
  }

  run-command "git log HEAD -n 1"                 >> $RESULT_FILE
  run-command "git log $TARGET -n 1"              >> $RESULT_FILE
  run-command "git diff $TARGET -C --name-status" >> $RESULT_FILE
  run-command "git diff $TARGET -C "              >> $RESULT_FILE

  echo "suitup-git-diff output: $RESULT_FILE"

  suitup-edit-some /tmp/suitup-git-diff.COMMIT_EDITMSG
}

function suitup-git-release-branch {
  RELEASE_TIME=$(date "+%Y%m%d_%H%M");
  BRANCH_NAME="release_$RELEASE_TIME";
  echo "-----------------------------------------";
  echo "Create Branch $BRANCH_NAME , base on current branch.";
  git branch "$BRANCH_NAME";
  echo "";
  echo "-----------------------------------------";
  echo "Push Branch $BRANCH_NAME to Origin.";
  git push origin "$BRANCH_NAME":"$BRANCH_NAME";
  echo "";
  echo "Checkout Branch $BRANCH_NAME .";
  echo "-----------------------------------------";
  git checkout "$BRANCH_NAME";
  echo ""
}

function suitup-git-show {
  TARGET=$1
  if [ -z "$TARGET" ]; then
    echo 'Must input a commit id'
    return
  fi

  CURRENT_TIME=$(date '+%Y%m%d%H%M%S')
  RESULT_FILE="/tmp/suitup-git-show."$CURRENT_TIME"_"$TARGET".COMMIT_EDITMSG"

  rm -f $RESULT_FILE

  git show $TARGET >> $RESULT_FILE

  suitup-edit-some $RESULT_FILE
}
