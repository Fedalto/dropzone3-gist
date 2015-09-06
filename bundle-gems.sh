#!/bin/bash

# You must have Bundler installed to use this script. You can install it with:
# gem install bundler
#
# This script designed for bundling gems along with a Dropzone action.
# First create a Gemfile inside the action bundle with the following like:
#
# source 'https://rubygems.org'
# gem 'great-gem'
#
# Then just run this script with ./bundle_gems <action_path> and it will install the gems into the current folder using bundler then remove unneeded cruft
# In your action.rb you then need to add
# require 'bundler/setup' at the top and then require the gems

# Note that this does the install to /tmp first then copies the results back as some gems will not install into a dir with spaces in name

dir_resolve() {
  cd "$*" 2>/dev/null || return $?
  echo "`pwd -P`"
}

if [ "$#" -ne 1 ]; then
  echo "Usage: bundle_gems.sh action_bundle_path"
  exit 1
fi

if [ ! -f "$1/Gemfile" ]; then
  echo "Gemfile not found. Create a Gemfile inside the action bundle first."
  exit 1
fi

ORIGINAL_WD=$(pwd)
ACTION_DIR=`dir_resolve $1`
rm -rf /tmp/bundled-gems
mkdir /tmp/bundled-gems
cp "$ACTION_DIR/Gemfile" /tmp/bundled-gems
cd /tmp/bundled-gems
bundle config build.nokogiri --use-system-libraries --with-xml2-include=/usr/include/libxml2 --with-xml2-lib=/usr/lib
bundle install --standalone --path .
cd ruby
cd $(ls | sort -n | head -1)
rm -rf bin build_info cache doc specifications
cd gems
find . ! -path . -type d -maxdepth 1 -exec sh -c '(cd {} && mv lib ../ && find . -not -path "./data*" -delete && mv ../lib ./)' ';'
cd "$ACTION_DIR"
rm -rf ruby
rm -rf bundler
mv -f /tmp/bundled-gems/* ./
rm -rf /tmp/bundled-gems
cd "$ORIGINAL_WD"
