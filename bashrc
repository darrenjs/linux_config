#!/usr/bin/env bash



# Attempt to discover system type
if [ $(uname) = "Linux" ]
then
    export LINUX=1
    SYS_FOUND=1
    SUPPORTS_COLOUR=1

    # Because I use these script on a Linux box at work as well as a Linux box
    # at home, a futher setting is made to determine the exact linux system in
    # use.

    # T61 Laptop running Ubuntu
    if [ $(hostname) = "t420" ]
    then
        export HOMELINUX=1
    fi

    # T61 Laptop running Ubuntu
    if [ $(hostname) = "t61" ]
    then
        export LENOVOT61=1
    fi

    if [ $(hostname) = "mushroom" ]
        then
        export MUSHROOM=1
    fi

    if [ $(hostname) = "darrens-t41" ]
        then
        export MUSHROOM=1
    fi
fi

# Attempt to discover system type
if [ $(uname) = "CYGWIN_NT-5.1" ]
then
    export CYGWIN=1
    SYS_FOUND=1
    SUPPORTS_COLOUR=1
fi


# Test to see if the yesshell is interactive (ie where both input and output
# streams are connected to terminals). If the shell is interactive a
# useful start message can be displayed. If not interactive, no message
# is displayed. The latter action is important, because writing text
# to non-interactive shells can cause 'sftp' to fail with the error
# 'Message received too long'. To determine within a startup script
# whether Bash is running interactively or not, we can examine the
# variable $PS1; it is unset in non-interactive shells, and set in
# interactive shells.
if [ -n "$PS1" ]
then

	if [ -z "$SYS_FOUND" ]
	then
	    echo "Warning: bash scripts (.bashrc) did not recognise system:$(uname)"
	fi

	# Display my welcome message if on mushroom
	if [ -n "$LINUX" ]
	then
	    cat ~/system/welcome_message.txt
	fi
fi


#======================================================================
# ENVIRONMENT
#======================================================================

# Start by resetting the environment, so that this script can be safely called
# multiple times within a same session.

export PATH=/usr/local/bin:/usr/bin:/bin:/sbin:/usr/sbin
export LD_LIBRARY_PATH=


#export PS1="\[\033[1;30m\]\$(date +%H:%M:%S) \[\033[1;32m\]\\h \[\033[1;34m\]\w\[\033[0m\] "
export PS1="\[\033[1;30m\]\$? \[\033[1;32m\]\\h \[\033[1;34m\]\w\[\033[0m\] "


#--- Include guard ---

# NOTE: we nolonger use an include guard, because we always start by
# reassigning PATH and LD_LIBRARY_PATH

# We don't want to run this script multiple times. So the first time this
# script is executed, an environment variable is set, so that later executions
# of this script can detected it and immediately return.

# if [ -n "$DARRENS_ENV_SETUP" ] ; then
#     return
# fi
# export DARRENS_ENV_SETUP=1



# #--- Subversion repository ---------------------------------------------------


if [ -n $HOMELINUX ] ; then
    export REPO=file:///home/darrens/system/subversion
fi


#--- Prioritise cricketlab bin directory -------------------------------------

# Feb 2006: Am nolonger doing this since I'm not involved with the NRS
#           project anymore.

#    CRICKETLAB_HOME=/disk/cricketlab
#    if [ -d "$CRICKETLAB_HOME" ]
#        then
#        export PATH=$CRICKETLAB_HOME/bin:$PATH
#        export LD_LIBRARY_PATH=$CRICKETLAB_HOME/lib:$LD_LIBRARY_PATH
#    fi

#--- Determine the PORT ------------------------------------------------------

# Get GCC compiler version
GCC=$(gcc -dumpversion)

# Get machine hardware class
MACHINE=$(uname -m)

# Get OS
OS=$(uname -s)

# Get Linux kernal
VERSION=$(uname -r)

export PORT=gcc-$GCC\_$MACHINE\_$OS-$VERSION

# Compiler flag
CXXFLAGS="-Wall"


#--- Configure history -------------------------------------------------------

export HISTCONTROL=ignoredups
export HISTSIZE=10000
export HISTFILESIZE=100000
export HISTIGNORE="&:h:p:ls:[bf]g:exit:dir:u"
shopt -s histappend

# Function to pull up the last directories navigated to
dh()
{
  history | \grep '^ *[0-9]*  cd [~/].*$' | \grep '^ *[0-9]* ' | sort -k 2 | uniq -f 1
}

#--- Set WORKDIR --------------------------------------------------------------

# Still need this for lots of makefiles that reference it

export WORKDIR=~/work

#--- Matlab on laptop ---------------------------------------------------------

MATLAB_HOME=/opt/matlab/latest
if [ -d "$MATLAB_HOME" ]
then
    export PATH=$MATLAB_HOME/bin:$PATH
else
    unset MATLAB_HOME
fi

#--- CNS ---------------------------------------------------------------------

if [ -n "$MUSHROOM" ]
then
    CNS_HOME=/opt/CNS/latest
fi


if [ -d "$CNS_HOME" ]
then
    export CNS_HOME
    export PATH=$CNS_HOME/bin:$PATH
fi

#--- LD_LIBRARY_PATH ---------------------------------------------------------

export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/lib:/usr/X11R6/lib

#--- Mozilla Firefox ---------------------------------------------------------

FIREFOX_HOME=/opt/firefox/latest
if [ -d "$FIREFOX_HOME" ]
then
    export PATH=$FIREFOX_HOME:$PATH
else
    unset FIREFOX_HOME
fi


#--- MAKEFLAGS - options for make ---------------------------------------------

export MAKEFLAGS="--no-print-directory"

#-------------------- QT 5.3 --------------------

QTHOME=/home/darrens/opt/Qt/5.3/gcc_64
export PATH=$QTHOME/bin:$PATH
export LD_LIBRARY_PATH=$QTHOME/lib:$LD_LIBRARY_PATH


#--- Unison -------------------------------------------------------------------

UNISON_HOME=/opt/unison/latest
if [ -d "$UNISON_HOME" ]
then
    export PATH=$UNISON_HOME/bin:$PATH
else
    unset UNISON_HOME
fi

#--- Miscellaneous path changes for LINUX -------------------------------------

if [ -n "$LINUX" ]
then
    export PATH=$PATH:/sbin:/usr/sbin
fi



#--- This is needed for Richard's NRS software --------------------------

if [ -n "$MUSHROOM" ]
then
    export SOFTHOME=~/work/academic/NRS/nrs1
    export PATH=$PATH:$SOFTHOME/bin/linux:$SOFTHOME/tools
fi



#--- Set the OpenCV path ------------------------------------------------------

if [ -n "$MUSHROOM" ]
then
    export OPENCV_HOME=~/work/dev/src/opencv/install
    export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:${OPENCV_HOME}/lib
fi

if [ -n "$TAXIS" ]
then
    export OPENCV_HOME=~/work/dev/src/opencv/install
    export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:${OPENCV_HOME}/lib
fi


#--- Set the Java paths -------------------------------------------------------


if [ "$LENOVOT61" = "1" ]
then
    export JAVA_HOME=/usr/lib/jvm/latest
fi


if [ -n "$JAVA_HOME" ];
then
	  export JDK_HOME=$JAVA_HOME
	  export PATH=$JAVA_HOME/bin:$PATH:
	  export MANPATH=$MANPATH:$JAVA_HOME/man
fi

#--- Set the CVS Repository ---------------------------------------------------

# First unset the CVS variables.  This is useful to do, because if we
# are starting an xterm then is picks up setting from the parent.  If
# that parent has defined CVS variables, we don't necessarily want to
# promoted them.  The end result is that nomatter how a shell is
# started, it's CVS values will be reconstructed and described as below.

unset CVSROOT;


# As of July 2003, the repository is located on cvs.inf.ed.ac.uk
cvsinfweb ()
{
    export CVSROOT=:pserver:darrens@cvs.inf.ed.ac.uk:/disk/cvs/cricketlab
}


if [ -n "$MUSHROOM" ]
then
    export CVSROOT=:local:/home/darrens/system/cvsroot
fi

if [ -n "$LENOVOT61" ]
then
    export CVSROOT=:local:/home/darrens/system/cvsroot
fi

# Set CVS editor
export CVSEDITOR=vim

#--- Set a PDF viewer ---------------------------------------------------------

if [ -n "$LINUX" ]
then
	  export PDFVIEWER=acroread
fi

if [ -n "$CYGWIN" ]
then
	  export PDFVIEWER=/cygdrive/c/Program\ Files/Adobe/Acrobat\ 5.0/Reader/AcroRd32.exe
fi


#--- Set the editor  ----------------------------------------------------------

export EDITOR='vim'

#--- Set up the PATH ----------------------------------------------------------

PATH=~/bin:${PATH}


ulimit -c unlimited


#======================================================================
# alias

   ##    #          #      ##     ####
  #  #   #          #     #  #   #
 #    #  #          #    #    #   ####
 ######  #          #    ######       #
 #    #  #          #    #    #  #    #
 #    #  ######     #    #    #   ####

#======================================================================

#--- PhD work -----------------------------------------------------------------

# Short cuts for PhD work
alias get_cns_script='cp /opt/CNS/latest/bin/CNS.py .'

#--- General ------------------------------------------------------------------

alias u="cd .."
alias uu="cd ../.."
alias uuu="cd ../../.."
alias uuuu="cd ../../../.."
alias uuuuu="cd ../../../../.."

alias -- +="pushd ."
alias -- -="popd"

alias taill='filetotail=$(dir -tr1 | tail -1; ); echo \*\*\* Tailing $filetotail \*\*\*; tail -f $filetotail'
# Modify the ls alias to show colour on those systems that support it

if [ -n "$SUPPORTS_COLOUR" ]
then
	alias ls='ls -Fltrkh --color'
	alias ls.='ls  -Fltrkh --color -d .*'
else
	alias ls='ls -Fltrkh'
	alias ls.='ls  -Fltrkh -d .*'
fi
alias sl=ls

alias p='cd -'
alias vi='vim'

alias mu='make update'
alias mc='make clean'
alias mr='make run'
alias mi='make install'
alias mj='make -j 10'
alias rm='rm -i'
alias grep="grep -n --color=auto"
alias man='man -a'
alias du='du -skh'
alias df='df -h'

alias bb='echo -e "\E[33m********************************************************************************\E[37m"'

alias h='history'

# Note, when invoking a history command, often it is safer to use the
# format,
#         > !55:p
# so that the command is printed, and not executed. We can then use the
# up arrow to quicky bring it into the buffer, and either immediately
# execute or edit.


# Alias to psme command to show all useful processes - the grep -v excludes
# lines with the matching string.
GREP=/bin/grep
#alias psme='ps -fu $LOGNAME | $GREP -v bash | $GREP -v csh | $GREP -v xterm | $GREP -v rlogin | $GREP -v grep | cut -c 8-22,49-'


alias xmms="audacious"
alias backup="backupFile"

# directory changes

alias how="cd ~/work/HOWTO"
alias work="cd ~/work"


#======================================================================
# functions

 ######  #    #  #    #   ####    #####     #     ####   #    #   ####
 #       #    #  ##   #  #    #     #       #    #    #  ##   #  #
 #####   #    #  # #  #  #          #       #    #    #  # #  #   ####
 #       #    #  #  # #  #          #       #    #    #  #  # #       #
 #       #    #  #   ##  #    #     #       #    #    #  #   ##  #    #
 #        ####   #    #   ####      #       #     ####   #    #   ####

#======================================================================

#--- Functions ---

tidy()
{
    for f in $*
    do
        clang-format-3.5  -i -style=file  "$f"
    done
}

m()
{
    local CSCODE="32";
    local CSOBJ="36";
    local CSWARN="33;01";
    local CSGCCERROR="31;02";
    local CSMAKEERROR="31;07";
    export CS_COLORS="37;01,${CSMAKEERROR},${CSGCCERROR},${CSWARN},${CSOBJ},${CSCODE},${CSCODE},${CSCODE},${CSCODE},${CSCODE}";
    \make $* 2>&1 | cs "^make.* Error .*"  " error: .*"   " warning:.*" "[^ ]*\.o" "[^ ]*\.cpp" "[^ ]*\.cc" "[^ ]*\.c" "[^ ]*\.h" "[^ ]*\.hh"
    local __returncode=${PIPESTATUS[0]}
    return ${__returncode}
}


#======================================================================
# FUNCTIONS
#======================================================================


#----------------------------------------------------------------------
## Print Full Path
fp ()
{
    for FILE in $*
    do
        # \ls to side-step any alias
      # -1 to list only filename
      # -d to show directory name instead of contents
      \ls -1 -d $PWD/$FILE
    done
}

#----------------------------------------------------------------------

# Short cut for launching xmessage
xm ()
{
    retcode=$?
    message=$@;

    xmsghistory=`history | tail -2 | head -1`

    tempfilemktemp=`mktemp --tmpdir xmsg-XXXXXXXX.txt`

    echo '+++ XMESSAGE +++' >> $tempfilemktemp
    echo pwd: `pwd` >> $tempfilemktemp
    echo date: `date` >>  $tempfilemktemp
    echo history-1: "$xmsghistory" >>  $tempfilemktemp
    echo result: $retcode >> $tempfilemktemp

    if [ -n  "$message" ]; then
        echo JOB: $message >> $tempfilemktemp
    fi

    xmessage -buttons Close:0 -title 'JOB DONE' -bg lightgrey -fg black  -geometry 400x150  -file $tempfilemktemp

    rm -f $tempfilemktemp
    echo RESULT: $retcode
}

#----------------------------------------------------------------------

# Copy options:

# -H  -- follow links  ( and -L )
#
#   This will copy the destination of the link, rather than creating a new
#   link to the destination. WE DON'T WANT TO DO THIS, because we want to
#   preserve what the link was pointing to.  E.g,
#
#         rel ->  1.9.9
#
#   ...after backup we will get
#
#         rel.20120910 -> 1.9.9
#
#   ...so the backup tells us the original was a soft link, and what it was
#   linked to.
#
# -d    same as --no-dereference --preserve=links
#
#   Don't follow links.  If we copy a file that is a soft-link, the
#   destination file will also be a softlink to the same destination.
#
# -R  recurse
#
#
# --preserve=mode,ownership
#
#   We provide our own --preserve, because we don't want to use --preserve=all

backupFile ()
{
    local retcode=0;

    if [ "${BACKUP_NO_COLOUR}x" == "x" ]; then
        local boldft="\033[1m";
        local reverseft="\033[7m";
        local redft="\033[31m";
        local greenft="\033[32m";
        local cyanft="\033[36m";
        local normalft="\033[0m";
    fi;

    if [ -z "${1}" ]; then
        echo backup: missing file operand;
        return 1;
    else
        for file in "$@";
        do
            local __copyargs="-dR --preserve=mode,ownership";
            local __src="${file}";
            local __dest="${__src}.`date +%Y%m%d.%H%M%S`.${USER}";

            echo -n cp "${__copyargs}";
            echo -ne $cyanft;
            echo -n " ${__src}";
            echo -ne $normalft$greenft;
            echo " ${__dest}";
            echo -ne $normalft;

            cp $__copyargs  "${__src}"  "${__dest}";
            __retval="$?";

            if [ "$__retval" != "0" ]; then
                retcode="$__retval";
            fi;
        done;
    fi;

    if [ "$retcode" != "0" ]; then
        echo -e ${redft}${boldft}some files not copied${normalft};
    fi;

    return $retcode
}
alias backup=backupFile

#---------------------------------------------------------------------
##
## Grep Files  -- deprecated. Instead use the gf script
##
# gf ()
# {
#     if [ -z "$1" ];
#     then
#         echo search for what?
#         return 1
#     fi

#     local searchterm="$1"
#     shift;

#     if [ -z "$1" ];
#     then
#         # User did not provide a directory, so, assume current dir.
#         grep --color -R -i "$searchterm" .
#     else
#         # Search in the directories specified by the user
#         grep --color -R -i "$searchterm" $*
#     fi
# }

#---------------------------------------------------------------------
##
## Find File
##
ff ()
{
    for file in $*;
    do
        # Use -iname for case-insensitive search, and then pass through grep
        # in order to colourise the output
        find . -iname \*$file\* | \grep --color=auto -i $file
    done
}


#----------------------------------------------------------------------
# Smart 'cd down' command.
#
# Darren Smith
d()
{
	# Reference to the 'dir' command
	DIRCMD="/bin/dir"

	# Store the path where this command is called from
	if [ -z "$_d_OLDDIR" ]
		then
		_d_OLDDIR=`pwd`
	fi

	# Test if an argument has been provided
	if [ -n "$1" ]
		then

		# Attempt to cd into specified directory.  We don't do any
		# prechecks here, since bash will check and report on any errors.
		cd "$1"

		if [ $? == "0" ]
			then
				#echo Successfully changed directory
			d

			if [ -n "$_d_OLDDIR" ]
				then
				OLDPWD=$_d_OLDDIR
				unset _d_OLDDIR
			fi

			return $?;
		else
				#echo Failed to change directory

			unset _d_OLDDIR
			return 1;
		fi
	else
		LINES=`$DIRCMD -1 | wc -l`

		if [[ $LINES == "1" ]]
			then
			dirname=`$DIRCMD -1`
			if [ -d "$dirname" ]
				then
				cd `$DIRCMD -1`
				d;
			fi
		fi

		if [ -n "$_d_OLDDIR" ]
			then
			OLDPWD=$_d_OLDDIR
			unset _d_OLDDIR
		fi
		return 0;
	fi

}

#--- SetTitle script ----------------------------------------------------------

# Bash version
st()
{
   echo -e "\033]0;$*\007";
}

# Function for setting tab title. WARNING: if you use this in a bashrc script,
# only do so for interactive modes, otherwise ssh / scp to that host can fail.
tt()
{
    # For setting the session title, we use code 30
    echo -ne "\033]30;${1}\007"
}

# Function for setting window title. WARNING: if you use this in a bashrc
# script, only do so for interactive modes, otherwise ssh / scp to that host
# can fail.
wt()
{
    # For setting the window title, we use code 0
    echo -ne "\033]0;${1}\007"
}



svnst()
{
  svn status -uv --depth files |  cs ^\!.*$ ^M.*$ ^?.*$
}


svnlog()
{
  svn log -v -l 5 $*
}


svndiff()
{
    svn diff --diff-cmd tkdiff $*
}

xt()
{
    local title=$1

    if [ -n "$title" ]; then
        xtopt_title="-title $title"
    else
        unset xtopt_title
    fi
    xterm $xtopt_title &
    disown
}


autobuild ()
{
    fgbold=`tput bold`
    fgred=`tput setaf 1`
    fggreen=`tput setaf 2`
    treset=`tput sgr0`

    lastmake="0000-00-00 00:00:00";
    while :; do
        highmodstat=`find .  -regextype posix-egrep  \( \( -iregex '.*\.c[cp]*' -o -name \*h \) -a -type f \) -exec stat --format "%y%n" '{}' \; | sort | tail -1`;
        highmodstamp=`echo $highmodstat  | cut -b 1-19`;
        if [ "${highmodstamp}" \> "${lastmake}" ]; then
            echo $highmodstat;
            make -j 4;
            errcode=$?;
            lastmake="${highmodstamp}";
            echo;
            if [ $errcode -eq 0 ]; then
                echo ${fgbold}${fggreen}"     "=== AUTOBUILD -- SUCCESS ===${treset};
            else
                echo ${fgbold}${fgred}"     "=== AUTOBUILD -- FAILED ===${treset};
            fi;
            echo;
        fi;
        usleep 750000;
    done
}

#======================================================================


source ~/opt/emacs-24.5/env.sh

source ~/system/git-prompt.sh
source ~/system/git-completion.bash
export GIT_PS1_SHOWDIRTYSTATE=1
export GIT_PS1_SHOWCOLORHINTS=1
export GIT_PS1_SHOWSTASHSTATE=1

PROMPT_COMMAND='__git_ps1 "\[\033[1;32m\]\h \[\033[1;34m\]\w\[\033[0m\]" " "'


export USER_CXX=g++
export JANSSONHOME=/home/darrens/opt/jansson-2.7
export JALSONHOME=/home/darrens/opt/jalson-1.0

cd ~
