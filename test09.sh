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

touch a b c d e

echo "***STATUS 1***"
sh girt-status # => all files untracked
echo "***STATUS 1***"

sh girt-add a b c 
echo "***STATUS 2***"
sh girt-status # => a, b and c added to index - the rest untracked
echo "***STATUS 2***"

rm a 
echo "***STATUS 3***"
sh girt-status
# => b, c added to index
# a added to index - file deleted
# rest untracked
echo "***STATUS 3***"

sh girt-commit -m "commit-0"
echo "***STATUS 4***"
sh girt-status
# => b and c same as repo
# a - file deleted
# rest untracked
echo "***STATUS 4***"

sh girt-rm b 
echo "***STATUS 5***"
sh girt-status 
# => c same as repo
# b - deleted
# a - file deleted
# rest untracked
echo "***STATUS 5***"

rm d
echo "***STATUS 6***"
sh girt-status 
# no change => c same as repo
# b - deleted
# a - file deleted
# e untracked
echo "***STATUS 6***"


sh girt-rm --cached c
echo "***STATUS 7***"
sh girt-status 
# c untracked
# b - deleted
# a - file deleted
# e untracked
echo "***STATUS 7***"

sh girt-add e 
sh girt-commit -m "e"
echo "***STATUS 8***"
sh girt-status 
# c untracked
# a - file deleted
# e same as repo 
echo "***STATUS 8***"

seq 1 10 >> e 
sh girt-add e 
rm e 
echo "***STATUS 9***"
sh girt-status
# c untracked 
# a - file deleted 
# e - file deleted, different changes staged for commit
echo "***STATUS 9***"


rm -r .girt
rm c

echo ""
echo "<<<<<<<<<<<<<<<END>>>>>>>>>>>>>>>"
echo ""

