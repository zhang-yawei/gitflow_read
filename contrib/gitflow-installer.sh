#!/bin/bash

# git-flow make-less installer for *nix systems, by Rick Osborne
# Based on the git-flow core Makefile:
# http://github.com/nvie/gitflow/blob/master/Makefile

# Licensed under the same restrictions as git-flow:
# http://github.com/nvie/gitflow/blob/develop/LICENSE

# Does this need to be smarter for each host OS?

# 判断INSTALL_PREFIX 长度是否为0, 也就是是否定义
if [ -z "$INSTALL_PREFIX" ] ; then
	INSTALL_PREFIX="/usr/local/bin"
fi

# repo name
if [ -z "$REPO_NAME" ] ; then
	REPO_NAME="gitflow"
fi

# repo home
if [ -z "$REPO_HOME" ] ; then
	REPO_HOME="http://github.com/nvie/gitflow.git"
fi
# 可执行文件名字
EXEC_FILES="git-flow"
# 脚本文件
SCRIPT_FILES="git-flow-init git-flow-feature git-flow-hotfix git-flow-release git-flow-support git-flow-version gitflow-common gitflow-shFlags"
# 子库文件
SUBMODULE_FILE="gitflow-shFlags"

echo "### gitflow no-make installer ###"

case "$1" in
	uninstall)
		echo "Uninstalling git-flow from $INSTALL_PREFIX"
		# 如果是文件夹，则为真
		if [ -d "$INSTALL_PREFIX" ] ; then
			for script_file in $SCRIPT_FILES $EXEC_FILES ; do
				echo "rm -vf $INSTALL_PREFIX/$script_file"
				rm -vf "$INSTALL_PREFIX/$script_file"
			done
		else
			echo "The '$INSTALL_PREFIX' directory was not found."
			echo "Do you need to set INSTALL_PREFIX ?"
		fi
		exit
		;;
	help)
		echo "Usage: [environment] gitflow-installer.sh [install|uninstall]"
		echo "Environment:"
		echo "   INSTALL_PREFIX=$INSTALL_PREFIX"
		echo "   REPO_HOME=$REPO_HOME"
		echo "   REPO_NAME=$REPO_NAME"
		exit
		;;
	*)
		echo "Installing git-flow to $INSTALL_PREFIX"
		# -a : and 并，   -o : or 或
		if [ -d "$REPO_NAME" -a -d "$REPO_NAME/.git" ] ; then
			echo "Using existing repo: $REPO_NAME"
		else
			echo "Cloning repo from GitHub to $REPO_NAME"
			git clone "$REPO_HOME" "$REPO_NAME"
		fi
		if [ -f "$REPO_NAME/$SUBMODULE_FILE" ] ; then # -f 文件是否存在
			echo "Submodules look up to date"
		else
			echo "Updating submodules"
			lastcwd=$PWD
			cd "$REPO_NAME"
			git submodule init
			git submodule update
			cd "$lastcwd"
		fi
		# copy 安装脚本
		install -v -d -m 0755 "$INSTALL_PREFIX"
		for exec_file in $EXEC_FILES ; do
			install -v -m 0755 "$REPO_NAME/$exec_file" "$INSTALL_PREFIX"
		done
		for script_file in $SCRIPT_FILES ; do
			install -v -m 0644 "$REPO_NAME/$script_file" "$INSTALL_PREFIX"
		done
		exit
		;;
esac
