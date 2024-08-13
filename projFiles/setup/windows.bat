@echo off
color 0a
cd ..
@echo on
echo Installing dependencies.
echo This might take a few moments depending on your internet speed.
haxelib install lime
haxelib install openfl
haxelib install flixel
haxelib install flixel-addons
haxelib install flixel-ui
haxelib install flixel-tools
haxelib install SScript
haxelib install tjson 1.4.0
haxelib install markdown
haxelib install UnRAR
haxelib install crypto
haxelib install hxvlc
haxelib git extension-androidtools https://github.com/MAJigsaw77/extension-androidtools.git
haxelib git hscript-improved https://github.com/FNF-CNE-Devs/hscript-improved.git
haxelib git flxanimate https://github.com/ShadowMario/flxanimate dev
haxelib git linc_luajit https://github.com/superpowers04/linc_luajit
haxelib git hxdiscord_rpc https://github.com/MAJigsaw77/hxdiscord_rpc
haxelib git funkin.vis https://github.com/FunkinCrew/funkVis d5361037efa3a02c4ab20b5bd14ca11e7d00f519
haxelib git grig.audio https://gitlab.com/haxe-grig/grig.audio.git cbf91e2180fd2e374924fe74844086aab7891666
echo Finished!
pause
