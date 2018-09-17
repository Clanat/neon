
fail("Failure PR") if github.pr_title.include? "failure"
warn("Warning PR") if github.pr_title.include? "warning"

# Warn when there is a big PR
warn("Big PR") if git.lines_of_code > 500
