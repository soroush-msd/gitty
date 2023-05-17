#!/bin/dash

# if .girt directory exist already, remove it for testing
if test -d ".girt/"
then
    rm -r ".girt/"
fi

failed=0

###testing girt-show with different options###
echo ""
echo "<<<<<<<<<<<<<<<START>>>>>>>>>>>>>>>"
echo ""

# error - calling girt-show before init - exit 1
sh girt-show :a 
test $? -eq 1 || failed=1

sh girt-init

# no argument - print usage and exit 1
sh girt-show
test $? -eq 1 || failed=1

# many arguments - print usage and exit 1
sh girt-show 1:a 2:a
test $? -eq 1 || failed=1

# incorrect commit - output message - exit 1
sh girt-show 1:a
test $? -eq 1 || failed=1

# incorrect filename - output message - exit 1
sh girt-show :a
test $? -eq 1 || failed=1

# creating files - add - commit
echo "***A***" >> a
echo "***B***" >> b
echo "***C***" >> c

sh girt-add a
sh girt-commit -m "commit-0 => committing a"

sh girt-add b
sh girt-commit -m "commit-1 => comitting b"

sh girt-add c
sh girt-commit -m "commit-2 => committing c"

# showing a - present in all three commits
sh girt-show 0:a
test $? -eq 0 || failed=1

sh girt-show 1:a 
test $? -eq 0 || failed=1

sh girt-show 2:a
test $? -eq 0 || failed=1

# showing b - present in commit 1 and 2
sh girt-show 1:b
test $? -eq 0 || failed=1

sh girt-show 1:b
test $? -eq 0 || failed=1

# showing c - only in last commit
sh girt-show 2:c
test $? -eq 0 || failed=1

# b not present in commit 0 - output error - exit 1
sh girt-show 0:b
test $? -eq 1 || failed=1

# c not present in commit 0 and 1 - output error - exit 1
sh girt-show 0:c
test $? -eq 1 || failed=1

sh girt-show 1:c
test $? -eq 1 || failed=1


# modifying files and add them to index

echo "###A###" >> a
echo "###B###" >> b
echo "####C###" >> c 

sh girt-add a b c 

# showing their contents in index
sh girt-show :a 
test $? -eq 0 || failed=1

sh girt-show :b 
test $? -eq 0 || failed=1

sh girt-show :c
test $? -eq 0 || failed=1



rm -r .girt
rm a b c

echo ""
echo "<<<<<<<<<<<<<<<END>>>>>>>>>>>>>>>"
echo ""

if test "$failed" -eq 1
then
    echo "***************TEST FAILED***************" 1>&2
    echo ""
    exit 1
else
    echo "***************TEST PASSED***************" 1>&2
    echo ""
    exit 0
fi



