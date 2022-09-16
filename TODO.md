# Tasks
* Currently I just make `krew` install the plugins in a systemd user unit... the best way would be to just download the plugins into `.krew`, making each of them a derivation... but this seems pretty difficult, considering one would have to parse the `krew` manifest.
* I don't know why but the `krew` systemd unit never seems to start on activation time... so one has to restart or start it manually.
