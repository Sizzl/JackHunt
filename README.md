# Unreal Tournament '99 Halloween Hunt Mutator
Designed for Halloween events at utassault.net Discord - https://discord.gg/unbFxh2t66

## Client-side component
- Compiles to JackHunt.u
- Add mutator to start HUD overlay: JackHunt.JackHunt
- Add to ServerPackages for client-side compatibility:

```
[Engine.GameEngine]
; ** Keep existing entries, but also add this package: **
ServerPackages=JackHunt
```

## Server-side component
- Example code provided, without giving away the hunt ;)
- Compiles to JackHuntSP.u
- Do not add to ServerPackages otherwise you'll be giving the game away
- Add mutator to spawn collectibles: JackHuntSP.JackHuntSP
- Decoration support outside of hunting - add mutator: JackHuntSP.Decorations

