# Tasks
* Currently I just make `krew` install the plugins in a systemd user unit... the best way would be to just download the plugins into `.krew`, making each of them a derivation... but this seems pretty difficult, considering one would have to parse the `krew` manifest.
* I don't know why but the `krew` systemd unit never seems to start on activation time... so one has to restart or start it manually. UPDATE: It also works when restarting the system but that's not perfectly good. User activation time would be better.
* Helm and plugins? For example `helmfile` needs `helm-diff`
* I should respect the `KREW_ROOT` env var. See [this](https://krew.sigs.k8s.io/docs/user-guide/setup/install/)
* Install `krew` completions
* The systemd unit fails sometimes when restarting because the network is not ready, so I guess I should wait for it.
