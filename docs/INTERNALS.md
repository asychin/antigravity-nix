# Internal Documentation

This document contains technical details about the implementation, troubleshooting, and development of the `antigravity-nix` flake.

## Implementation Details

### Packaging Approach

Antigravity is distributed as a binary that expects a standard Linux filesystem layout. NixOS uses a non-standard structure (`/nix/store`), requiring special handling:

1. **antigravity-unwrapped**: Extracts upstream tarball without modification
2. **FHS Environment**: Wraps binary in isolated container with standard paths and all required libraries

### Auto-Update System

The flake implements automated version tracking:

1. **Scheduled checks**: GitHub Actions runs every 6 hours
2. **Browser automation**: Playwright scrapes version from JavaScript-rendered download page
3. **Hash verification**: Downloads and verifies SHA256 hashes for all platforms
4. **Build testing**: Validates package builds successfully before creating PR
5. **Auto-merge**: Merges PR when tests pass
6. **Release tagging**: Creates GitHub releases for version pinning

### Chrome Integration

Creates a Chrome wrapper that:

- Forces use of user's Chrome profile (`~/.config/google-chrome`)
- Preserves installed extensions
- Sets `CHROME_BIN` and `CHROME_PATH` environment variables

## Troubleshooting

### Hash Mismatch Error

Upstream binary changed. Update with:

```bash
./scripts/update-version.sh
```

Or wait for automatic update (runs every 6 hours).

### Application Won't Start

Verify unfree packages are enabled:

```bash
nix-instantiate --eval -E '(import <nixpkgs> {}).config.allowUnfree'
```

Should return `true`.

### Missing Libraries

The FHS environment provides all necessary libraries. If issues persist:

1. Check NixOS version: `nixos-version`
2. Rebuild: `nix build .#default --rebuild`
3. Open issue with error details and system architecture

## Project Structure

```
antigravity-nix/
├── flake.nix              # Main flake configuration (flake-parts)
├── package.nix            # Package derivation with FHS environment
├── modules/               # NixOS and Home Manager modules
│   ├── nixos.nix
│   └── home-manager.nix
├── scripts/
│   ├── scrape-version.js  # Playwright-based version scraper
│   ├── check-version.sh   # Quick version comparison
│   └── update-version.sh  # Full update process
└── .github/
    └── workflows/
        ├── update.yml     # Auto-update workflow (every 6 hours)
        ├── release.yml    # Automatic release tagging
        └── cleanup-branches.yml  # Branch cleanup
```

## Development

This project uses `flake-parts` for structure and `treefmt` for formatting.

```bash
# Format code
nix fmt

# Check flake
nix flake check
```
