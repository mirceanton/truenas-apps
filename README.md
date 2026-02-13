# TrueNAS Apps

GitOps source of truth for applications running via Docker on my TrueNAS home server, managed by [doco-cd](https://github.com/kimdre/doco-cd), a lightweight GitOps controller for Docker Compose.

## Overview

This repository defines all the Docker Compose stacks deployed on my homelab TrueNAS server. Changes pushed to `main` are automatically picked up and applied, making the repo the single source of truth for what applications run on the server.

## Initial Setup

1. SSH into the TrueNAS server
2. Create the secret directory and token file:

   ```bash
   mkdir -p /root/.doco-cd
   echo "<1password-service-account-token>" > /root/.doco-cd/1pw_token
   ```

3. Clone the repo locally

   ```bash
   git clone https://github.com/mirceanton/truenas-apps /var/apps
   ```

4. Deploy the bootstrap compose stack:

   ```bash
   cd /var/apps/bootstrap
   docker compose up -d
   ```

5. Create a CronJob in TrueNAS to run the `scripts/cron.sh` scrip on a schedule (I personally do hourly)

   ![TrueNAS CronJob](docs/truenas_cron.png)

From this point on, *everything* is self-managing.

## How It Works

### Auto-Discovery

doco-cd uses `auto_discover: true` with `depth: 1`, meaning it automatically finds and deploys any subdirectory containing a `compose.yaml`. Adding a new app is as simple as creating a new folder under `apps/` with a compose file. The `delete: true` option ensures that removing a directory also tears down the corresponding stack.

### Secret Management

Secrets are managed through **1Password** using doco-cd's built-in secret provider integration. A 1Password service account token is stored on the TrueNAS host at `/root/.doco-cd/1pw_token`, and doco-cd injects secrets from 1Password vaults into compose stacks as environment variables.

### DocoCD Updates

The `scripts/cron.sh` script can be run as an cronjob on the TrueNAS server. It fetches the latest changes from the repository, checks for updates in the `bootstrap/` directory, and if any are found, runs `docker compose up -d` to apply them. The script waits for all containers to become healthy before finishing. This ensures that the doco-cd stack and all managed applications are always up to date with the repository.

## License

[MIT](LICENSE)
