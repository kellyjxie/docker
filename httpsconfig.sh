#!/bin/sh

cygwin=false
darwin=false
os400=false
hpux=false
case "`uname`" in
CYGWIN*) cygwin=true;;
Darwin*) darwin=true;;
OS400*) os400=true;;
HP-UX*) hpux=true;;
esac

#check if jar file exists
PRG="$0"
PRGDIR=`dirname "$PRG"`
EXECUTABLE=HTTPSCert.jar

if [ ! -e "$PRGDIR"/"$EXECUTABLE" ]; then
    echo
    echo "Cannot find $PRGDIR/$EXECUTABLE"
    echo "This file is needed to run this program"
    echo
    exit 1
  fi

display_help() {
    echo
    echo "   -a [jar] [fully qualified classname], --add-jar              Setting up HTTPS with an external JAR"
    echo "   -s [tool], --select                                          Setting up HTTPS with specific tool [KT, BC]"
    echo
    # echo some stuff here for the -a or --add-options 
    exit 1
}

setup_https_default_keytool() {
    if $darwin; then
    echo
    echo "   Setting up HTTPS with default Keytool, to manually select run with -s [KT, BC]"
    echo "   For additional options, run with -h"
    echo
    java -jar HTTPSCert.jar KeytoolCertStrategyUnix
    exit 1  
    fi
    if $cywin; then 
    echo
    echo "   Setting up HTTPS with default Keytool, to manually select run with -s [KT, BC]"
    echo "   For additional options, run with -h"
    echo
    java -jar HTTPSCert.jar KeytoolCertStrategyWindows
    fi
}

setup_https_keytool() {
    if $darwin; then
        echo
        echo "   Setting up HTTPS with Keytool"
        echo
        java -jar HTTPSCert.jar KeytoolCertStrategyUnix
        exit 1  
    fi
    if $cygwin; then 
        echo
        echo "   Setting up HTTPS with Keytool"
        echo
        java -jar HTTPSCert.jar KeytoolCertStrategyWindows
    fi
}

setup_https_bouncycastle() {
    if $darwin; then
        echo
        echo "   Setting up HTTPS with BouncyCastle"
        echo
        java -jar HTTPSCert.jar BouncyCastleCertStrategyUnix
        exit 1  
    fi
    if $cygwin; then
        echo
        echo "   Setting up HTTPS with BouncyCastle"
        echo
        java -jar HTTPSCert.jar BouncyCastleCertStrategyWindows
    fi
}

if [ "$#" -eq 0 ]
then
    setup_https_default_keytool
    exit 0
fi

while :
do
    case "$1" in
      -a | --add-jar)
          if [ "$2" = "" ] || [ "$3" = "" ]; then
            echo "   Please enter .jar file and fully qualified class name"
            exit 0
          else
            case "$3" in
           *.*) echo; echo "   Setting up HTTPS with external JAR"; echo;java -jar HTTPSCert.jar -cp $2 $3; exit 0;;
            *) echo "   Wrong/missing argument $3"; exit 1;;
            esac
          fi
          ;;
      -h | --help)
          display_help  # Call your function
          exit 0
          ;;
      -s | --select)
          if [ "$2" == "KT" ]; then
            setup_https_keytool
            exit 0
          elif [ "$2" == "BC" ]; then
            setup_https_bouncycastle
            exit 0
          else 
            echo "Error: Unknown option: $2" >&2
            exit 0
          fi
          ;;
      --) # End of all options
          break
          ;;
      -*)
          echo "Error: Unknown option: $1" >&2
          display_help
          return 
          ;;
      *)  # No more options
          break
          ;;
    esac
done

