#!/bin/bash

function fatal() {
    echo "$@" >&2
    exit 1
}

[[ "$(id -u)" != "0" ]] || fatal "Must NOT run as root!"

mkdir -p ~/.config/direnv
cat <<EOF >~/.config/direnv/config.toml
[whitelist]
prefix = [
	"/home",
]
EOF

mkdir -p ~/.docker
cat <<EOF >~/.docker/config.json
{
  "credHelpers": {
    "gcr.io": "gcloud",
    "us-docker.pkg.dev": "gcloud"
  }
}
EOF

mkdir -p ~/.sandbox
cat <<EOF >~/.sandbox/setup
#!/bin/bash
[[ -f "~/.kube/config" || -z "\$KUBECONFIG_SECRET" ]] || {
  mkdir -p ~/.kube
  cp -f "/run/sandbox/fs/secrets/shared/\$KUBECONFIG_SECRET" ~/.kube/config
  chmod +w ~/.kube/config
  [[ -z "\$APP_NS" ] || kubectl config set contexts.default.namespace \$APP_NS
}
EOF
chmod a+rx ~/.sandbox/setup

mkdir -p ~/.config ~/.local ~/.cache
mkdir -p ~/.snapshot
mkdir -p ~/.vscode-server/extensions
mkdir -p ~/.vscode-remote/extensions
cat <<EOF >~/.snapshot/includes.txt
.bashrc
.bash_logout
.profile
.config
.local
.cache
.snapshot
.vscode-server/extensions
.vscode-remote/extensions
.docker/config.json
.sandbox
go
EOF

cat <<EOF >~/.snapshot/excludes.txt
.ssh
.bash_history
.gitconfig
EOF

sed -i '/^# BEGIN-WORKSPACE-ENV/,/^# END-WORKSPACE-ENV/d' ~/.bashrc
cat <<EOF >>~/.bashrc
# BEGIN-WORKSPACE-ENV
if [[ -d '/usr/local/google-cloud-sdk' ]]; then
    . '/usr/local/google-cloud-sdk/path.bash.inc'
    . '/usr/local/google-cloud-sdk/completion.bash.inc'
fi
export PATH="\$HOME/go/bin:\$PATH"
eval "\$(direnv hook bash)"
# END-WORKSPACE-ENV
EOF

go install -v github.com/uudashr/gopkgs/v2/cmd/gopkgs@latest
go install -v github.com/ramya-rao-a/go-outline@latest
go install -v github.com/cweill/gotests/gotests@latest
go install -v github.com/fatih/gomodifytags@latest
go install -v github.com/josharian/impl@latest
go install -v github.com/haya14busa/goplay/cmd/goplay@latest
go install -v github.com/go-delve/delve/cmd/dlv@latest
go install -v github.com/go-delve/delve/cmd/dlv@master
go install -v honnef.co/go/tools/cmd/staticcheck@latest
go install -v golang.org/x/tools/gopls@latest
go install -v github.com/cosmtrek/air@latest
