# TrueNAS Apps

GitOps source of truth for applications running via Docker on my TrueNAS home server, managed by [doco-cd](https://github.com/kimdre/doco-cd), a lightweight GitOps controller for Docker Compose.

## Overview

This repository defines all the Docker Compose stacks deployed on my homelab TrueNAS server. Changes pushed to `main` are automatically picked up and applied, making the repo the single source of truth for what applications run on the server.

The setup uses a **two-stage doco-cd architecture** (bootstrap -> apps) to achieve a fully self-managing deployment pipeline, since by default doco-cd cannot manage/update itself.

## Initial Setup

1. SSH into the TrueNAS server
2. Create the secret directory and token file:

   ```bash
   mkdir -p /root/.doco-cd
   echo "<1password-service-account-token>" > /root/.doco-cd/1pw_token
   ```

3. Deploy the bootstrap compose stack:

   ```bash
   cd /path/to/bootstrap
   docker compose up -d
   ```

From this point on, *everything* is self-managing.

## How It Works

### The Two doco-cd Instances

The system uses two doco-cd instances to solve a chicken-and-egg problem:

| Instance                     | Deployed by                | Watches                | Purpose                                                     |
| ---------------------------- | -------------------------- | ---------------------- | ----------------------------------------------------------- |
| **Bootstrap** (`bootstrap/`) | Manual `docker compose up` | `apps/` directory      | Gets the system started; deploys and manages all app stacks |
| **Apps** (`apps/doco-cd/`)   | The bootstrap instance     | `bootstrap/` directory | Keeps the bootstrap instance itself up to date              |

**Why two instances?** A single doco-cd instance cannot update its own compose file. Replacing yourself mid-run is a recipe for trouble. Instead, each instance watches and manages the *other*:

1. **Bootstrap doco-cd** polls the repo every **5 minutes** and deploys everything under `apps/`, including the apps doco-cd instance.
2. **Apps doco-cd** polls every **1 hour** and deploys the `bootstrap/` directory, keeping the bootstrap instance updated.

This creates a "mutual management loop" where both instances keep each other current, and the entire stack is self-healing from a single `git push`.

Since both doco-cd instances manage each other, a simultaneous update of both could leave the system with no running controller to recover from a failure. To prevent this, the [Renovate configuration](.renovaterc.json) creates separate PRs for each instance (via distinct `additionalBranchPrefix` values) and uses different `minimumReleaseAge` settings — 3 days for the bootstrap instance vs. 2 days for the apps instance. This ensures that when a new doco-cd version is released, the two instances are never upgraded at the same time; one is always running and healthy to manage the other's rollout. (at least in theory :sweat_smile:)

### Auto-Discovery

Both doco-cd instances use `auto_discover: true` with `depth: 1`, meaning they automatically find and deploy any subdirectory containing a `compose.yaml`. Adding a new app is as simple as creating a new folder under `apps/` with a compose file. The `delete: true` option ensures that removing a directory also tears down the corresponding stack.

### Secret Management

Secrets are managed through **1Password** using doco-cd's built-in secret provider integration. A 1Password service account token is stored on the TrueNAS host at `/root/.doco-cd/1pw_token`, and doco-cd injects secrets from 1Password vaults into compose stacks as environment variables.

## License

[MIT](LICENSE)