
# Constants
DEV_BRANCH = 'develop'
MAX_LINES_OF_CODE = 500

# Base branch
failure 'Development branch is not selected as base branch' if github.branch_for_base != DEV_BRANCH

# Big pull request
failure 'PR is too big' if git.lines_of_code > MAX_LINES_OF_CODE

# Labels
failure 'PR label is missing, please set `wip` or `ready` label' if github.pr_labels.empty?

# Merge status
warn('This PR cannot be merged yet.', sticky: false) unless github.pr_json['mergeable']

swiftlint.config_file = '.swiftlint.yml'
swiftlint.lint_files
