#!/bin/dash

# if .girt directory exist already, remove it for testing
if test -d ".girt/"
then
    rm -r ".girt/"
fi

failed=0

###exploring girt-rm further with options###
echo ""
echo "<<<<<<<<<<<<<<<START>>>>>>>>>>>>>>>"
echo ""

# error - calling girt-rm before init - exit 1
sh girt-rm --force filename
test $? -eq 1 || failed=1

sh girt-rm --cached filename
test $? -eq 1 || failed=1

sh girt-init

# no filename - output usage - exit 1
sh girt-rm --cached
test $? -eq 1 || failed=1

sh girt-rm --force
test $? -eq 1 || failed=1

# invalid file - output message - exit 1
sh girt-rm --cached filename
test $? -eq 1 || failed=1

sh girt-rm --force filename
test $? -eq 1 || failed=1


seq 1 10 >> a 
seq 1 10 >> b 
seq 1 10 >> c 
seq 1 10 >> d 
seq 1 10 >> e

# add a to index and remove it from index using --cached - check still exists in cwd
sh girt-add a
sh girt-rm --cached a
test $? -eq 0 || failed=1
test -e "a" || failed=1
! test -e ".girt/index/a" || failed=1

# add b to index and --force - removes b from index and cwd
sh girt-add b 
sh girt-rm --force b 
test $? -eq 0 || failed=1
! test -e "b" || failed=1
! test -e ".girt/index/b" || failed=1


# add and commit c - change c - add c and remove it from index
sh girt-add c 
sh girt-commit -m "committing c"
seq 1 10 >> c 
sh girt-add c 
sh girt-rm --cached c 
test $? -eq 0 || failed=1
test -e "c" || failed=1
! test -e ".girt/index/c" || failed=1

# add and commit d - remove the index
sh girt-add d 
sh girt-commit -m "committing d"
sh girt-rm --cached d 
test $? -eq 0 || failed=1
test -e "d" || failed=1
! test -e ".girt/index/d" || failed=1


# add and commit e - change e and add e - change e again and delete from index
# error in index is different to both to the working file and the repository
sh girt-add e 
sh girt-commit -m "committing e"
seq 20 30 >> e
sh girt-add e 
seq 30 40 >> e
sh girt-rm --cached e 
test $? -eq 1 || failed=1
test -e "e" || failed=1
test -e ".girt/index/e" || failed=1

# add and commit e - change e and add e - change e again and delete with force
# error in index is different to both to the working file and the repository - exit 0
sh girt-add e 
sh girt-commit -m "committing e"
seq 20 30 >> e
sh girt-add e 
seq 30 40 >> e
sh girt-rm --force e 
test $? -eq 0 || failed=1
! test -e "e" || failed=1
! test -e ".girt/index/e" || failed=1

# add and commit f - change f and add f - change f again and delete with cached and force
# error in index is different to both to the working file and the repository - exit 0
seq 1 10 >> f
sh girt-add f 
sh girt-commit -m "committing f"
seq 20 30 >> f
sh girt-add f 
seq 30 40 >> f
sh girt-rm --force --cached f 
test $? -eq 0 || failed=1
test -e "f" || failed=1
! test -e ".girt/index/f" || failed=1


# add g to index - remove from cwd and index with force - exit 0
seq 1 10 >> g 
sh girt-add g 
sh girt-rm --force g
test $? -eq 0 || failed=1
! test -e "g" || failed=1
! test -e ".girt/index/g" || failed=1

# add and commit h - change h - add h - change h - remove from cwd and index with force - exit 0
seq 1 10 >> h 
sh girt-add h
sh girt-commit -m "committing h"
seq 20 30 >> h 
sh girt-add h 
seq 30 40 >> h 
sh girt-rm --force h
test $? -eq 0 || failed=1
! test -e "h" || failed=1
! test -e ".girt/index/h" || failed=1


rm -r .girt
rm a c d f

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

