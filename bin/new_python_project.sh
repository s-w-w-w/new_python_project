#!/usr/bin/env bash 

### new_python_project.js - create scaffolding for new python project
### Help: type -h for available options

### What this program does:
# 1. parse script options
# 2. make app dir
# 3. prepare lib directory
# 4. prepare test directory
# 5. create bin directory and a basic executable script in it
# 6. create README.md
# 7. create gitignore

#configuration
APPS_DIR=~/www/tests/python/algorithms
APP_NAME=NewProject
# detect help

# display help
Help(){
cat <<EOF
Usage: ${0##*/} [-h | -p projectName | -d directory ]

    -h help
    -p projectName - specify library name
    -d specify directory name

EOF
}

# 1. parse script options
while getopts ":hp:d:" option; do
   case $option in
      h) # display Help
         Help "$0"
         exit;;
      p) # Enter application name
         APP_NAME=$OPTARG;;
      d) # Enter directory   
         APPS_DIR=$OPTARG;;
     \?) # Invalid option
         echo "Error: Invalid option"
         exit;;
   esac
done
shift "$((OPTIND-1))"   # Discard the options and sentinel --


# set path 
APP_PATH="$APPS_DIR/$APP_NAME"

if [[ -d "$APP_PATH" ]]
  then {
    echo "There exists $APP_PATH already. Choose a different app name" 
    exit 2;
  }
fi 

# 2. make app dir
mkdir "$APP_PATH"
cd "$APP_PATH"

# 3. prepare lib directory 
mkdir lib
cat <<END > "lib/$APP_NAME.py";
"""
$APP_NAME - [class description]
    Version: 1.0.0
    Methods:
        __init__() - constructor
"""
class $APP_NAME(object):
    def __init__(self):    
        pass
END

# 4. prepare test directory
mkdir test
read -r -d '' <<TND
#!/usr/bin/env python3

import sys
from pathlib import Path
# add parent path of lib dir to path
sys.path.insert(0, str(Path(__file__).resolve().parent.parent))

import unittest

# display path
from lib.$APP_NAME import *

class Test$APP_NAME(unittest.TestCase): 

    """
    Sample test
    """
    def test_something(self):
        self.assertEqual(1, 1)

if __name__ == '__main__':
    unittest.main()
TND
echo "$REPLY" > "test/test$APP_NAME.py"

# 5. create bin directory and a basic executable script in it
mkdir bin

PROG_NAME=${APP_NAME,,}

touch "bin/$PROG_NAME"

read -r -d '' <<PFL
#!/usr/bin/env python3

import sys
from pathlib import Path
# add parent path of lib dir to path
sys.path.insert(0, str(Path(__file__).resolve().parent.parent))

import unittest
from optparse import OptionParser

# load library
from lib.$APP_NAME import *

def main():
    usage = "usage: %prog [options] n"
    parser = OptionParser(usage)

    (options, args) = parser.parse_args()

    ##################################### start the program
    #Access program options and args:  https://docs.python.org/3/library/optparse.html#putting-it-all-together


    ###################################### end of program
     
        
if __name__ == "__main__":
    main()
PFL
echo "$REPLY" > "bin/$PROG_NAME"
chmod 755 "bin/$PROG_NAME" 

# 6. create README.md
touch README.md

# 7. create gitignore
touch .gitignore

echo "Success!"
echo "New project created at: $APP_PATH"
