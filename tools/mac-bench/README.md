# mac-bench

Runs BAR's 650-unit benchmark (`coding-agents/test-scripts/bar-benchmark.tdf`) against any `spring` binary and prints the Draw, Sim and Update means.

```sh
tools/mac-bench/bench.sh /path/to/spring label [seconds]
python3 tools/mac-bench/summarize.py ~/.spring-bench/results/*.infolog.txt
```

## Setup, once

1. Data dir `~/.spring-bench` with symlinks `pool`, `packages`, `rapid`, `maps` into an existing BAR install, plus the map Starwatcher 1.0.
2. Copy `bar-benchmark.tdf` there and set `gametype` to the installed BAR version (`Beyond All Reason test-31943-6cd6caa` at the time of writing).
3. After the first run, set `["Mission Info"] = 0` in `~/.spring-bench/LuaUI/Config/BYAR.lua`. Otherwise the widget pauses the game and later runs stall at frame 2.
4. A binary needs `mesa/` and the engine content (`base`, `fonts`, `AI`, `LuaUI`) next to it. For a build, make a folder that symlinks those from an installed release engine and copy the built `spring` in.

The script links engine content into the data dir per run and keeps `LuaUI/Config` local, so BAR never writes into an engine folder.

## Results, 2026-11-14, M5 Pro 64 GB

Released engine, quiet machine, 3 runs: Draw 5.5 to 6.0 ms, Sim 10.8 to 12.8 ms.

Base build against this branch's two StreamBuffer and ModelsDataUploader commits, four alternating rounds while other processes used several cores:

| Round | Base Draw / Sim | Ports Draw / Sim |
|---|---|---|
| 1 | 9.62 / 18.27 | 11.39 / 19.84 |
| 2 | 10.01 / 19.73 | 8.91 / 17.77 |
| 3 | 10.93 / 20.27 | 10.36 / 19.99 |
| 4 | 10.54 / 19.97 | 9.67 / 19.03 |

Inconclusive. The ports touch only rendering, yet Sim moved as much as Draw between paired runs, so the noise is at least as large as any effect. Screenshots at frame 2015 differ as much between two runs of one build as between builds, so they cannot show visual equivalence either.
