#!/bin/bash

# Structure:git_neutral
create_new_branch() {
	branch_name=$1
	company=$2
	git_repository=$3
	
	# create_repo branch
	theoutput=$(cd "$MIRROR_LOCATION/$company/$git_repository" && git checkout -b "$branch_name")
	
	# TODO: assert the branch is created
	
	# echo theoutput
	echo "$theoutput"
}

# Structure:git_neutral
# Check if the branch is contained in GitHub branch array (to filter the difference containing a branch that is (still) in GitLab but not in GitHub)
github_branch_is_in_gitlab_branches() {
	#eval gitlab_branches=$2
	local github_branch="$1"
	shift
	gitlab_branches=("$@")
	
	#"${branch_names_arr[i]}"
	
	# loop through file list and store search_result_boolean
	#for looping_filepath in "${file_list[@]}"; do
	#for gitlab_branch in "${gitlab_branches[@]}"; do
	#	echo "gitlab_branch=$gitlab_branch"
	#done
	if [[ " ${gitlab_branches[*]} " =~ ${github_branch} ]]; then
		# whatever you want to do when array contains value
		echo "github_branch=$github_branch"
		echo "FOUND"
	fi
}

# Structure:git_neutral
# 6.i If there are differences in files, and if the GitHub branch contains a GitLab yaml file:
# copy the content from GitHub to GitLab (except for the .git folder).
copy_files_from_github_to_gitlab_branch() {
	local github_repo_name="$1"
	local github_branch_name="$2"
	local gitlab_repo_name="$3"
	local gitlab_branch_name="$4"
	
	# If the GitHub repository exists
	if [ "$(github_repo_exists_locally "$github_repo_name")" == "FOUND" ]; then

		# If the GitHub branch exists
		github_branch_exists_output="$(github_branch_exists "$github_repo_name" "$github_branch_name")"
		github_branch_is_found=$(assert_ends_in_found_and_not_in_notfound ${github_branch_exists_output})
		if [ "$github_branch_is_found" == "TRUE" ]; then
		
			# If the GitHub branch contains a gitlab yaml file
			filepath="$MIRROR_LOCATION/GitHub/$github_repo_name/.gitlab-ci.yml"
			if [ "$(file_exists "$filepath")" == "FOUND" ]; then
				
				# If the GitLab repository exists
				if [ "$(gitlab_repo_exists_locally "$gitlab_repo_name")" == "FOUND" ]; then
					
					# If the GitLab branch exists
					found_branch_name="$(get_current_gitlab_branch "$gitlab_repo_name" "$gitlab_branch_name" "GitLab")"
					if [ "$found_branch_name" == "$gitlab_branch_name" ]; then
					
						# If there exist differences in the files or folders in the branch (excluding the .git directory)
						
						# Then copy the files and folders from the GitHub branch into the GitLab branch (excluding the .git directory)
						# That also deletes the files that exist in the GitLab branch that do not exist in the GitHub branch (excluding the .git directory)
						copy_github_files_and_folders_to_gitlab "$MIRROR_LOCATION/GitHub/$github_repo_name" "$MIRROR_LOCATION/GitLab/$github_repo_name"
						
						# Then verify the checksum of the files and folders in the branches are identical (excluding the .git directory)
						comparison_result="$(two_folders_are_identical_excluding_subdir "$MIRROR_LOCATION"/GitHub/"$github_repo_name" "$MIRROR_LOCATION"/GitLab/"$github_repo_name" .git)"
						
						if [ "$comparison_result" == "IDENTICAL" ]; then
							echo "IDENTICAL"
						else
							echo "ERROR, the content in the GitHub branch is not exactly copied into the GitLab branch, even when excluding the .git directory."
							exit 11
						fi
						
					else
						echo "ERROR, the GitLab branch does not exist locally."
						exit 12
					fi
				else
					echo "ERROR, the GitLab repository does not exist locally."
					exit 13
				fi
			else
				echo "ERROR, the GitHub branch does contain a yaml file."
				exit 14
			fi
		else 
			echo "ERROR, the GitHub branch does not exist locally."
			exit 24
		fi
	else 
		echo "ERROR, the GitHub repository does not exist locally."
		exit 25
	fi
}


copy_files_from_github_to_gitlab_commit() {
	local github_repo_name="$1"
	local github_branch_name="$2"
	local gitlab_repo_name="$3"
	local gitlab_branch_name="$4"
	
	# If the GitHub repository exists
	if [ "$(github_repo_exists_locally "$github_repo_name")" == "FOUND" ]; then

		# If the GitHub branch exists
		
			# If the GitHub branch contains a gitlab yaml file
			filepath="$MIRROR_LOCATION/GitHub/$github_repo_name/.gitlab-ci.yml"
			if [ "$(file_exists "$filepath")" == "FOUND" ]; then
				
				# If the GitLab repository exists
				if [ "$(gitlab_repo_exists_locally "$gitlab_repo_name")" == "FOUND" ]; then
					
					# If the GitLab branch exists
					found_branch_name="$(get_current_gitlab_branch "$gitlab_repo_name" "$gitlab_branch_name" "GitLab")"
					if [ "$found_branch_name" == "$gitlab_branch_name" ]; then
					
						# If there exist differences in the files or folders in the branch (excluding the .git directory)
						
						# Then copy the files and folders from the GitHub branch into the GitLab branch (excluding the .git directory)
						# That also deletes the files that exist in the GitLab branch that do not exist in the GitHub branch (excluding the .git directory)
						copy_github_files_and_folders_to_gitlab "$MIRROR_LOCATION/GitHub/$github_repo_name" "$MIRROR_LOCATION/GitLab/$github_repo_name"
						
						# Then verify the checksum of the files and folders in the branches are identical (excluding the .git directory)
						comparison_result="$(two_folders_are_identical_excluding_subdir "$MIRROR_LOCATION"/GitHub/"$github_repo_name" "$MIRROR_LOCATION"/GitLab/"$github_repo_name" .git)"
						
						if [ "$comparison_result" == "IDENTICAL" ]; then
							echo "IDENTICAL"
						else
							echo "ERROR, the content in the GitHub branch is not exactly copied into the GitLab branch, even when excluding the .git directory."
							exit 11
						fi
						
					else
						echo "ERROR, the GitLab branch does not exist locally."
						exit 12
					fi
				else
					echo "ERROR, the GitLab repository does not exist locally."
					exit 13
				fi
			else
				echo "ERROR, the GitHub branch does contain a yaml file."
				exit 14
			fi
	else 
		echo "ERROR, the GitHub repository does not exist locally."
		exit 25
	fi
}


# Structure:gitlab_status
# 6.i.0
#source src/helper/git_neutral/helper_git_neutral.sh && copy_github_files_and_folders_to_gitlab "src/mirrors/GitHub/sponsor_example" "src/mirrors/GitLab/sponsor_example"
copy_github_files_and_folders_to_gitlab() {
	github_dir="$1"
	gitlab_dir="$2"
	
	if [ "$gitlab_dir" == "" ]; then
		echo "Error, the GitLab directory is not specified."
		exit 18
	fi
	
	# Delete all GitLab files and folders except for ., .., .git.
	delete_all_gitlab_files "$gitlab_dir/.*"
	delete_all_gitlab_files "$gitlab_dir/*" 
	delete_all_gitlab_folders "$gitlab_dir/.*" 
	delete_all_gitlab_folders "$gitlab_dir/*"
	
	# Copy all GitHub folders to GitLab
	copy_all_gitlab_files "$github_dir/.*" "$gitlab_dir"
	copy_all_gitlab_files "$github_dir/*" "$gitlab_dir"
	
	# Copy all GitHub files to GitLab.
	copy_all_gitlab_folders "$github_dir/.*" "$gitlab_dir"
	copy_all_gitlab_folders "$github_dir/*" "$gitlab_dir"
	
}

# Structure:git_neutral
export_repo() {
	# check if target folder already exists
	
	# delete target folder if it already exists
	#$(delete_target_folder)
	cp -r "$SOURCE_FOLDERPATH" ../
	# create target folder
	# copy source folder to target
}

# Structure:git_neutral
create_new_branch() {
	branch_name=$1
	company=$2
	git_repository=$3
	
	# create_repo branch
	theoutput=$(cd "$MIRROR_LOCATION/$company/$git_repository" && git checkout -b "$branch_name")
	
	# TODO: assert the branch is created
	
	# echo theoutput
	echo "$theoutput"
}

git_has_changes() {
	target_directory="$1"
	cd "$target_directory" || exit
	if [[ $(git status --porcelain) ]]; then
		# Changes
		echo "FOUND"
	else
		# No changes
		echo "NOTFOUND"
	fi
}