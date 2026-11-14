# bar-mac

One script to install and play Beyond All Reason (BAR) on an Apple Silicon Mac with the macOS Recoil test builds from [tomjn's integration branch](https://github.com/beyond-all-reason/RecoilEngine/pull/3271). It replaces BAR's launcher, which has no macOS release.

Unofficial. Report engine problems on PR #3271 with `infolog.txt`, not to BAR support.

## What it does

The BAR launcher only downloads content and runs one command. This script does the same:

1. Downloads `recoil_<version>_arm64-macos.7z` from the engine release and extracts it to `~/.spring/engine/macos_arm64/<version>`.
2. Fetches `byar:test` and `byar-chobby:test` from BAR's CDN with the bundled `pr-downloader`, using the same CDN settings as the launcher's "Engine Test" setup.
3. Writes `RapidTagResolutionOrder` and `chobby_config.json`, then starts `spring --menu rapid://byar-chobby:test`.

Game content always comes from BAR's servers. BAR's art is CC-BY-NC-ND, so never commit or rehost it.

## Use

```sh
brew install sevenzip
tools/mac-play/bar-mac install      # about 3.5 GB on first run
tools/mac-play/bar-mac play         # BAR lobby: skirmish against AI, replays
```

The test engine reports 2026.09.02, BAR's "Engine Test" version. It cannot join games on the live engine.

## Private direct-IP games

These never touch BAR's servers. Everyone needs engine 2026.09.02 and the same `byar:test` game version. Windows and Linux players get that engine from the official launcher's "Engine Test" setup.

```sh
bar-mac host --players 2 --map "Red Comet Remake 1.8"     # prints a password
bar-mac join HOST_IP --name p2 --password PASSWORD
```

The host listens on UDP 8452 (`--port` to change). Players outside the host's network need a reachable address: a VPN such as Tailscale or ZeroTier, a forwarded port, or a host running on a rented server. Many campus and office networks block devices from reaching each other.

Cross-platform sync for the test build is unproven. Play a short game first.

## Self-test

```sh
bar-mac selftest 60
```

Runs `spring-dedicated` and two `spring-headless` players on 127.0.0.1 for 60 seconds, then prints the relevant log lines and fails on any sync error.

## Settings

| Variable | Default |
|---|---|
| `BAR_MAC_HOME` | `~/.spring` |
| `BAR_MAC_ENGINE_REPO` | `tomjn/RecoilEngine` |
| `BAR_MAC_ENGINE_TAG` | `macos-2026.09.02-test1` |
| `BAR_MAC_ENGINE_VERSION` | `2026.09.02` |
