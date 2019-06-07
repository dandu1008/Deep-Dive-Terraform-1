#!/bin/bash
plugins=( "terraform-provider-aws" "terraform-provider-external" "terraform-provider-template" "terraform-provider-terraform" )

dirCheck () {
    if [ ! -d "$1" ]; then
      # Control will enter here if $DIRECTORY doesn't exist.
      mkdir -p "$1"
    fi
}

download () {
  for plugin in "${plugins[@]}"
  do
    echo "Downloding plugin: $plugin"
	pluginVersionDir=$(curl -v --silent "https://releases.hashicorp.com/$plugin/" 2>&1 | grep -o -E "${plugin}_(\d*\.\d*\.\d*)" | awk 'NR==1;')
    echo "$pluginVersionDir is the latest vesrion"
    pluginVersion=$(echo $pluginVersionDir | sed -e 's/_/-/g' -e 's/[a-z-]//g')
    pluginFile="${pluginVersionDir}_linux_amd64.zip"
    if [[ `ls $1 | grep -e "$plugin.*$pluginVersion"` ]]; then
       echo "$pluginVersionDir is already downloaded"
    else
       wget https://releases.hashicorp.com/$plugin/$pluginVersion/$pluginFile -P $1
       if [ `echo $?` -eq 0 ]; then
         echo "${pluginFile} is successfully downloaded"
       else
         echo "Error: Downloading is not completed"
       fi
    fi
  done
}

unZip () {
  for file in `ls $1 | grep "\.*\.zip"`
  do
    echo "*******"
    echo "$file"
    unzip $1/$file -d $1
    if [ `echo $?` -eq 0 ]; then
      echo "${file} is extracted"
      rm -f $1/$file
    else
      echo "Error: Unzipping of ${file} is failed"
    fi
  done
}

dirCheck "./terraform_plugins"
download "./terraform_plugins"
unZip "./terraform_plugins"