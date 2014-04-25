# Utilities

Small collection of useful scripts, right now it host the benchmarking script.

`rake benchmarking:wrap_all_devices`

## Install

Open `config/settings.yml`, and adjust your image server url. db/username/host are the settings
which will be used to pull data from your store application.

Next, run `rake db:migrate rake import`

