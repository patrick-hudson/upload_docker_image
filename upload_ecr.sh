#!/bin/bash

# usage: Place script in same folder as Dockerfile
# usage 
#title           :upload_ecr.sh
#description     :This script install all necessary tools to build and upload docker images to Amazon ECR.
#author          :Patrick Hudson
#date            :20170307
#version         :0.1
#usage           :./upload_ecr.sh -i imagename -t tag
#notes           :Make sure you set the AWS_ACCOUNT_ID variable
#bash_version    :4.1.5(1)-release
#==============================================================================
G='\033[0;32m' # Green
N='\033[0m' # No Color
R='\033[0;31m' # RED
if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi
###########################
# AWS_ACCOUNT_ID VARIABLE IS REQUIRED
# To obtain your AWS_ACCOUNT_ID login to your AWS console and select Account settings
# Or go here: https://console.aws.amazon.com/billing/home?#/account
###########################
AWS_ACCOUNT_ID=""

function usage()
{
  cat <<EOF
  Usage: $0 [options]

  -h| --help           Displays this help text
                       this is more help text.
----------------------------------------------------------------
REQUIRED
----------------------------------------------------------------
  -u| --account-id     AWS Account ID - Found in Account settings in AWS Console
  -i| --image          Name of your image to upload
  -t| --tag            Image Tag (Maximum of 1 tag per image)
----------------------------------------------------------------
Optional
----------------------------------------------------------------
  -r| --region         AWS Region to upload to (Default: us-east-1) 
EOF
}

while [ "$1" != "" ]; do
    PARAM=`echo $1 | awk -F= '{print $1}'`
    VALUE=`echo $2 | awk -F= '{print $1}'`
    case $PARAM in
        -h | --help)
            usage
            exit
            ;;
        -a | --access-key)
            ACCESSKEY=$VALUE
            shift
            ;;
        -s | --secret-key)
            SECRETKEY=$VALUE
            shift
            ;;
        -r | --region)
            REGION=$VALUE
            shift
            ;;
        -i | --image-name)
            IMAGE=$VALUE
            shift
            ;;
        -t | --tag)
            TAG=$VALUE
            shift
            ;;
        -u | --account-id)
            AWSID=$VALUE
            shift
            ;;
        *)
            echo "ERROR: unknown parameter \"$PARAM\""
            usage
            exit 1
            ;;
    esac
    shift
done
if [ -z $AWSID ]; then
  printf "${R}ERROR: AWS Account ID not found. Run ./upload_ecr.sh -h for more info${N}\n"
  exit
fi
if [ -z "$IMAGE" ] || [ -z "$TAG" ]; then
  printf "${R}ERROR: You must define an image name, and tag. Use ./upload_ecr.sh -h for more info${N}\n"
  exit
fi
OS="undetermined"
if [ -f /etc/centos-release ]; then
  if [[ $(awk '{print $3}' /etc/centos-release | cut -d . -f 1) -eq 6 ]]; then 
    OS="centos6"
    printf "${G}CentOS 6 detected${N}\n"
    printf "${G}Installing EPEL if not already installed${N}\n"
    yum install -y yum-utils >/dev/null 2>&1
    rpm -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-6.noarch.rpm >/dev/null 2>&1
  elif [[ $(awk '{print $3}' /etc/centos-release | cut -d . -f 1) -eq 7 ]]; then
    OS="centos7"
    printf "${G}CentOS 7 detected${N}\n"
    printf "${G}Installing EPEL if not already installed${N}\n"
    yum install -y yum-utils >/dev/null 2>&1
    rpm -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm >/dev/null 2>&1
  fi
elif [ -f /etc/redhat-release ]; then
  if [[ $(awk '{print $3}' /etc/redhat-release | cut -d . -f 1) -eq 6 ]]; then 
    OS="centos6" 
  elif [[ $(awk '{print $3}' /etc/redhat-release | cut -d . -f 1) -eq 7 ]]; then
    OS="centos7"
  fi
elif [ -f /etc/os-release ]; then
  VERSION=$(awk -F= '/^ID=/{print $2}' /etc/os-release)
  if [[ $VERSION == "ubuntu" ]]; then
    OS="ubuntu"
  fi
else
  echo "OS Seems to be unsupported. Script works with RedHat Enterprise Linux 6 and 7, CentOS 6 and 7, and Ubuntu"
  exit
fi
OSREGEX="^(centos)"
if [[ $OS =~ $OSREGEX ]]; then
  OSPKGMAN="yum install -y"
else
  OSPKGMAN="apt-get install -y"
fi
#Install Python
printf "${G}Installing python packages and AWSCLI${N}\n"
eval $OSPKGMAN docker >/dev/null 2>&1
eval $OSPKGMAN python-pip >/dev/null 2>&1
pip install --upgrade awscli >/dev/null 2>&1
if [[ -z "$REGION" ]]; then
  REGION="us-east-1"
fi
if [ ! -f ~/.aws/credentials ]; then
  printf "${G}AWS Credentials not Found! You will be prompted for your AWS Access Key ID and Secret Access Key${N}\n"
  aws configure
fi
eval $(aws ecr get-login --region "$REGION")
echo "docker build -t $IMAGE:$TAG ."
#docker tag $IMAGE:$TAG $AWSID.dkr.ecr.$REGION.amazonaws.com/$IMAGE:$TAG
#docker push $AWSID.dkr.ecr.$REGION.amazonaws.com/$IMAGE:$TAG