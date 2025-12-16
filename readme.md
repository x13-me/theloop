# theloop LineageOS FHS env

------

this flake creates a LineageOS FHS build env, it probably doesn't work yet

use

```bash
nix run github:x13-me/theloop/#lineageos-fhs
```

note:

you **must** have a `/theloop` mountpoint, with LineageOS (`22.2` Tested) as `/theloop/lineage` for this to work properly

see [notes.md](./notes.md) for notes