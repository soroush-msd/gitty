#!/bin/dash

# if .girt directory exist already, remove it for testing
if test -d ".girt/"
then
    rm -r ".girt/"
fi

failed=0

###testing girt-rm erroe messages and functionality###
echo ""
echo "<<<<<<<<<<<<<<<START>>>>>>>>>>>>>>>"
echo ""

# error - calling girt-rm before init - exit 1
sh girt-rm filename
test $? -eq 1 || failed=1

sh girt-init

# no argument - print error and exit 1
sh girt-rm
test $? -eq 1 || failed=1

# invalid file - print error and exit 1
sh girt-rm filename
test $? -eq 1 || failed=1

# creating files - add - commit
seq 1 20 >> a 
seq 20 30 >> b 
seq 30 40 >> c 

sh girt-add a 
sh girt-commit -m "commit-0"

# removing a 
sh girt-rm a 
test $? -eq 0 || failed=1
if ! test -e a && ! test -e ".girt/index/a"
then
    echo "a removed from both cwd and index"
else
    echo "ERROR: a not removed correctly"
fi

# error - a not in .girt - exit 1
sh girt-rm a
test $? -eq 1 || failed=1

# adding b
sh girt-add b 

# error - b has staged changes in index exit 1
sh girt-rm b 
test $? -eq 1 || failed=1

sh girt-commit -m "commit b"

# modifiying b
seq 10 20 >> b

# error - b in the repository is different to the working file
sh girt-rm b
test $? -eq 1 || failed=1


# add - commit c
sh girt-add c 
sh girt-commit -m "commit c"

# change c and add to index
seq 100 200 >> c 
sh girt-add c 

# change c again
seq 23 43 >> c 

# error - c in index is different to both to the working file and the repository
sh girt-rm c
test $? -eq 1 || failed=1



rm -r .girt
rm b c

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
