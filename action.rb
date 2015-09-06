# Dropzone Action Info
# Name: Gist
# Description: Create a Gist with the contents of the dropped text
# Handles: Text
# Creator: Leonardo Fedalto
# URL: https://github.com/Fedalto
# Events: Clicked, Dragged
# KeyModifiers: Command, Option, Control, Shift
# SkipConfig: No
# RunsSandboxed: Yes
# Version: 1.0
# MinDropzoneVersion: 3.0
# RubyPath: /System/Library/Frameworks/Ruby.framework/Versions/2.0/usr/bin/ruby


require './bundler/setup'
require 'gist'


def gist_text text
  new_gist = Gist.gist text
  new_gist['html_url']
end

def last_gist
  clipboard_contents = $dz.read_clipboard
  clipboard_contents
end

def dragged
  gist_url = gist_text $items[0]

  $dz.finish("Gist URL copied to clipboard")
  $dz.url(gist_url)
end

def clicked
  system("open http://gist.github.com/")
  $dz.url(false)
end
