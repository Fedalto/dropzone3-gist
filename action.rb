# Dropzone Action Info
# Name: Gist
# Version: 0.1
# Description: Create a Gist with the contents of the dropped text.
# Handles: Text
# Creator: Leonardo Fedalto
# URL: https://github.com/Fedalto
# Events: Clicked, Dragged
# KeyModifiers: Command, Option, Control, Shift
# SkipConfig: No
# OptionsNIB: APIKey
# SkipValidation: Yes
# RunsSandboxed: Yes
# MinDropzoneVersion: 3.0
# RubyPath: /System/Library/Frameworks/Ruby.framework/Versions/2.0/usr/bin/ruby


require './bundler/setup'
require 'gist'


def public?
  not ENV['KEY_MODIFIERS'].nil?
end

def gist_text text
  begin
    new_gist = Gist.gist(
      text,
      filename: "gistfile.txt",
      access_token: ENV['api_key'].strip,
      public: public?,
    )
  rescue RuntimeError => exc
    if exc.message.include? "Net::HTTPUnauthorized"
      $dz.error("Could not create gist.",
        "Please ensure that the API access token is correct " \
        "and has permission to manage your gists.")
    else
      $dz.error("Could not create gist.", exc.message)
    end
  end

  new_gist['html_url']
end

def dragged
  $dz.begin("Creating gist...")
  $dz.determinate(false)

  gist_url = gist_text $items[0]

  $dz.finish("Gist URL copied to clipboard")
  $dz.url(gist_url)
end

def clicked
  system("open http://gist.github.com/")
  $dz.url(false)
end
