#!/bin/bash
APID=${1}
MFT_REPO_NAME=${2}
BRANCH_NAME=${3}
TFS_URL=${4}

HOME_PATH=$(pwd)"/ALM"
SFTP_PWD="2C6x45JB"
SFTP_USERNAME="TFS_devcloud"
SFTP_IP="88.8.232.164"
REPO_NAME_WORESPACE=${MFT_REPO_NAME}"_WORKSPACE"



echo "APID=${APID}"
echo "MFT_REPO_NAME=${MFT_REPO_NAME}"
echo "BRANCH_NAME=${BRANCH_NAME}"
echo "TFS_URL=${TFS_URL}"

echo "============================================== start action ========================================================"

echo "$(rm -rf ${HOME_PATH}/${APID}/${MFT_REPO_NAME})"
echo "$(mkdir -p ${HOME_PATH}/${APID}/${MFT_REPO_NAME})"
echo "$(chmod 755 -R ${HOME_PATH}/${APID}/${MFT_REPO_NAME})" >/dev/null 2>&1

if [ $? -ne 0 ];
then 
  echo "mkdir ${HOME_PATH}/${APID}/${MFT_REPO_NAME}  file failed"
  exit 1
fi

cd ${HOME_PATH}/${APID}/${MFT_REPO_NAME}/

echo "get -r ${MFT_REPO_NAME}.tar" | sshpass -p ${SFTP_PWD} sftp -o StrictHostKeyChecking=no ${SFTP_USERNAME}@${SFTP_IP} > /dev/null 2>&1
if [ $? -ne 0 ];
then
  echo "mft get file failed"
  exit 1
fi

echo "$(tar xvf ${MFT_REPO_NAME}.tar)"

echo "$(rm -rf ./${MFT_REPO_NAME}/.git)"

echo "$(mkdir ${HOME_PATH}/${APID}/${MFT_REPO_NAME}/${REPO_NAME_WORESPACE})" >/dev/null 2>&1
if [ $? -ne 0 ];
then
  echo "mkdir ${HOME_PATH}/${APID}/${MFT_REPO_NAME}/${REPO_NAME_WORESPACE} file failed"
  exit 1
fi

echo "$(ls -la)"

cd ${HOME_PATH}/${APID}/${MFT_REPO_NAME}/${REPO_NAME_WORESPACE}/

echo "$(git clone -b ${BRANCH_NAME} --single-branch ${TFS_URL})"

echo "$(cp -f ${HOME_PATH}/${APID}/${MFT_REPO_NAME}/${MFT_REPO_NAME}/* ${HOME_PATH}/${APID}/${MFT_REPO_NAME}/${REPO_NAME_WORESPACE}/${MFT_REPO_NAME}/)"

cd ${HOME_PATH}/${APID}/${MFT_REPO_NAME}/${REPO_NAME_WORESPACE}/${MFT_REPO_NAME}/

echo "$(git status)"

echo "$(git add .)"

echo "$(git commit -m "move mft source code to tfs")"

echo "$(git push)"






