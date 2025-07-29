PATH="/opt/homebrew/Cellar/postgresql@16/16.9/bin:$PATH"
which pg_config
cmake -DCMAKE_INSTALL_PREFIX=/Users/mlo/git-web/pgquarrel/pgquarrel -DCMAKE_PREFIX_PATH=/Users/mlo/git-web/pgquarrel/.devbox/nix/profile/default/bin/psql
make