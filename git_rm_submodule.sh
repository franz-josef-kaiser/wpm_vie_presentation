#!/bin/bash
# Start from blank screen
clear

# Basic info
echo -e "\n\t+-------------------------------+"
echo -e "\t|\t\t\t\t|"
echo -e "\t|\tREMOVE SUBMODULE\t|"
echo -e "\t|\t\t\t\t|"
echo -e "\t+-------------------------------+\n"

branch_name=$(git symbolic-ref -q HEAD)
branch_name=${branch_name##refs/heads/}
branch_name=${branch_name:-HEAD}
echo -en '\tOn branch:\t'"\033[1m*$branch_name"

echo -e "\n"
top_level="$(git rev-parse --show-toplevel)"
echo -en "\tCurrent location: $top_level"

echo -e "\n"
echo -e "\t ------------------------------- \n"

submodules=()

modules=`git submodule`
# change the semicolons to white space
modules=${modules//;/$'\n'}

count=2
i=0
for module in $modules
do
	# Modulus
	current=$[ $count % 3 ];
	# If zero, assign it to submodules
	if (( $current == 0 )); then
		submodules[ $i ]=$module;
   		(( i++ ))
	fi
    (( count++ ))
done

echo -e "\tPlease chose the submodule you want to remove: \c"
echo -e "\n"
echo -e "\t ------------------------------- \n"

select module in ${submodules[*]}
do
	echo -e "\n"
	echo -e "\tYou have chosen to remove:"
    echo -e "\t$module"
    exit
done

echo -e "\n"
echo -e "\t ------------------------------- \n"

exit

## REMOVE task

echo -e "\n"
echo -e "\tRemove the submodule:"
git rm --cached $removeme

echo -e "\n"
echo -e "\tWe also need to remove the entry from our config file..."
git config -f .git/config --remove-section submodule.$removeme

echo -e "\n"
echo -e "\t...as well as from the .gitmodules file"
git config -f .gitmodules --remove-section submodule.$removeme

echo -e "\n"
echo -e "\t...and the modules folder"
rm -Rf .git/modules/$removeme

echo -e "\n"
echo -e "\t...and the actual folder"
rm -Rf "./$removeme"

exit



for i in ${!array[*]};
do
	echo -e "\t$i: ${array[@]}\n"

	IFS=" " read -a ${array[$i]} <<< "$module"
	echo $module[2]
	echo -e "\t${!module[*]}"

	for i in ${!module[*]};
	do
		echo --
		#echo $i: ${module[@]}
	done
done

exit

result=${PWD##*/}
printf '%s\n' "${PWD##*/}"

find . -type d -depth 1 -exec echo git --git-dir={}/.git --work-tree=$PWD/{} status \;

echo -e "Please chose the submodule you want to remove: \c "
read word
echo "You have chosen to remove: $word"
echo "======================="

top_level="$(git rev-parse --show-toplevel)"
echo $top_level

# git submodule foreach '[ "$path" = "$top_level" ] \ branch=master; git $branch'

git submodule

exit 0

# Don't allow more than one argument: The name of the submodule
if [ $# -gt 1 ]; then
	echo Only one argument supported: The name of the submodule
	exit 0
fi

PS3='Choose one word: '

# bash select
select word in "linux" "bash" "scripting" "tutorial"
do
	echo "The word you have selected is: $word"
	# Break, otherwise endless loop
	break
done

for f in $( cat .gitmodules ); do
	echo $f
done

# Remove the submodule
# git rm --cached some-project.git
# We also need to remove the entry from our config file...
# git config -f .git/config --remove-section submodule.thirdparty
# ...as well as from the .gitmodules file
# git config -f .gitmodules --remove-section submodule.thirdparty
# ...and the modu              