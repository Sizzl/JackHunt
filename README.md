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

## Build-related Script(s)
Simply place the required number of Small, Medium and Large objects around maps meeting the naming convention (e.g., matching AS-\*E.unr or AS-\*J.unr), then run the node.js script with the first argument pointing to the root of your Unreal Tournament installation to generate the required function.
- Requires node.js compatible UTPackage.js - e.g., [Sizzl/UTPackage.js](https://github.com/Sizzl/UTPackage.js)

Example:
```
node Export-HuntingCode.js C:/UnrealTournament
```