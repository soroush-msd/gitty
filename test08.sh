#!/bin/dash

# if .girt directory exist already, remove it for testing
if test -d ".girt/"
then
    rm -r ".girt/"
fi


###exploring girt-status with different delete status###
echo ""
echo "<<<<<<<<<<<<<<<START>>>>>>>>>>>>>>>"
echo ""

# error - call before init
sh girt-status
test $? -eq 1 || echo "FAILED"

sh girt-init 

touch a b c d e f g h 

echo "***STATUS 1***"
sh girt-status # => all files untracked
echo "***STATUS 1***"

sh girt-add a b c 
echo "***STATUS 2***"
sh girt-status # => a, b and c added to index - the rest untracked
echo "***STATUS 2***"

sh girt-commit -m "commit-0" 
echo "***STATUS 3***"
sh girt-status # => a, b and c same as repo - the rest untracked
echo "***STATUS 3***"

sh girt-add d
seq 1 10 >> d
echo "***STATUS 4***"
sh girt-status 
# => a, b and c same as repo - d (added to index - file changed) - the rest untracked
echo "***STATUS 4***"

sh girt-commit -m "commit-1"
echo "***STATUS 5***"
sh girt-status
# => a, b and c same as repo
# d file changed, changes not staged for commit
# rest untracked
echo "***STATUS 5***"

sh girt-add d 
echo "***STATUS 6***"
sh girt-status 
# => a, b and c same as repo
# d file changed, changes staged for commit
# rest untracked
echo "***STATUS 6***"

seq 20 30 >> d 
echo "***STATUS 7***"
sh girt-status
# => a, b and c same as repo
# d file changed, different changes staged for commit
# rest untracked
echo "***STATUS 7***"


rm -r .girt
rm a b c d e f g h

echo ""
echo "<<<<<<<<<<<<<<<END>>>>>>>>>>>>>>>"
echo ""