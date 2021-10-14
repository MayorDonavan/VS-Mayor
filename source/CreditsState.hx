package;

#if desktop
import Discord.DiscordClient;
#end
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.tweens.FlxTween;
import lime.utils.Assets;

using StringTools;

class CreditsState extends MusicBeatState
{
	var curSelected:Int = 1;

	private var grpOptions:FlxTypedGroup<Alphabet>;
	private var iconArray:Array<AttachedSprite> = [];

	private static var creditsStuff:Array<Dynamic> = [ //Name - Icon name - Description - Link - BG Color
		['VS Mayor Crew'],
		['Mayor',				'mayor',					'Mewsician, Main Purrogrammer',						'https://youtube.com/MayorD',			0xFFa86dec],
		['ChromaSen',			'noicon',					'Assistant Programmer',								'https://gamebanana.com/members/1875122',	0xFFa86dec],
		['Plazer Lazer',		'noicon',					'Main Animations',							'https://gamebanana.com/members/1794424',	0xFFa86dec],
		['LiterallyNick',		'noicon',					'Gag Animation',											'https://gamebanana.com/members/1963033',	0xFFFFBF00],
		['Oreo',				'noicon',					'Background Art, Touchup on Icons',										'',											0xFFA020F0],
		['RonLol',				'noicon',					'Background Art',									'https://gamebanana.com/members/1868271',	0xFFFFA500],
		['BlikiEX',				'blick',					'Logo',												'https://gamebanana.com/members/1866060',	0xFFFF0000],
		['Milk',				'milk',				'Icons',											'https://gamebanana.com/members/1908922',	0xFFADD8E6],
		['Megaman9009',			'megaman9009',		'Notes',											'https://gamebanana.com/members/1846410',	0xFF00FF00],
		['Azarel',				'azarel',					'Game Icon',										'',											0xFF0000FF],
		['AntoineVortex',		'noicon',			'BF Modifications',									'https://gamebanana.com/members/1762735',	0xFFa86dec],
		['YushUhBeanz',			'noicon',			'Playable Skid and Pump',							'https://gamebanana.com/members/1687187',	0xFFa86dec],
		['theoriginalalex',		'noicon',			'GF Deletion',										'https://gamebanana.com/members/1816291',	0xFFa86dec],
		['Nurf',				'noicon',					'Charting for Better, Feesh Overload, Beans, Miau, Found, Frightin, and Spookin',	'https://gamebanana.com/members/1866253',	0xFF00FF00],
		['TheRealFerret',		'therealferret',	'Charting for Feesh',								'https://gamebanana.com/members/1726229',	0xFFA020F0],
		['boink',				'boink',			'Charting for Yum',									'https://gamebanana.com/members/1780459',	0xFFA020F0],
		['Felix',				'noicon',					'Beta Tester',										'',											0xFF16C76C],
		['Sharpie',				'sharpieee',					'Beta Tester',										'',											0xFFA020F0],
		['Jack',				'mousie',					'Beta Tester',								'https://twitter.com/Skullface_XP',			0xFF20a9d7],
		['Psych Engine Team'],
		['Shadow Mario',		'shadowmario',		'Main Programmer of Psych Engine',					'https://twitter.com/Shadow_Mario_',	0xFFFFDD33],
		['RiverOaken',			'riveroaken',		'Main Artist/Animator of Psych Engine',				'https://twitter.com/river_oaken',		0xFFC30085],
		[''],
		['Engine Contributor'],
		['Keoiki',				'keoiki',			'Note Splash Animations',							'https://twitter.com/Keoiki_',			0xFFFFFFFF],
		[''],
		["Funkin' Crew"],
		['ninjamuffin99',		'ninjamuffin99',	"Programmer of Friday Night Funkin'",				'https://twitter.com/ninja_muffin99',	0xFFF73838],
		['PhantomArcade',		'phantomarcade',	"Animator of Friday Night Funkin'",					'https://twitter.com/PhantomArcade3K',	0xFFFFBB1B],
		['evilsk8r',			'evilsk8r',			"Artist of Friday Night Funkin'",					'https://twitter.com/evilsk8r',			0xFF53E52C],
		['kawaisprite',			'kawaisprite',		"Composer of Friday Night Funkin'",					'https://twitter.com/kawaisprite',		0xFF6475F3]
	];

	var bg:FlxSprite;
	var descText:FlxText;
	var intendedColor:Int;
	var colorTween:FlxTween;

	override function create()
	{
		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("Lookin' At The Credits!", null);
		#end

		bg = new FlxSprite().loadGraphic(Paths.image('menuDesat'));
		add(bg);

		grpOptions = new FlxTypedGroup<Alphabet>();
		add(grpOptions);

		for (i in 0...creditsStuff.length)
		{
			var isSelectable:Bool = !unselectableCheck(i);
			var optionText:Alphabet = new Alphabet(0, 70 * i, creditsStuff[i][0], !isSelectable, false);
			optionText.isMenuItem = true;
			optionText.screenCenter(X);
			if(isSelectable) {
				optionText.x -= 70;
			}
			optionText.forceX = optionText.x;
			//optionText.yMult = 90;
			optionText.targetY = i;
			grpOptions.add(optionText);

			if(isSelectable) {
				var icon:AttachedSprite = new AttachedSprite('credits/' + creditsStuff[i][1]);
				icon.xAdd = optionText.width + 10;
				icon.sprTracker = optionText;
	
				// using a FlxGroup is too much fuss!
				iconArray.push(icon);
				add(icon);
			}
		}

		descText = new FlxText(50, 600, 1180, "", 32);
		descText.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		descText.scrollFactor.set();
		descText.borderSize = 2.4;
		add(descText);

		bg.color = creditsStuff[curSelected][4];
		intendedColor = bg.color;
		changeSelection();
		super.create();
	}

	override function update(elapsed:Float)
	{
		if (FlxG.sound.music.volume < 0.7)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}

		var upP = controls.UI_UP_P;
		var downP = controls.UI_DOWN_P;

		if (upP)
		{
			changeSelection(-1);
		}
		if (downP)
		{
			changeSelection(1);
		}

		if (controls.BACK)
		{
			if(colorTween != null) {
				colorTween.cancel();
			}
			FlxG.sound.play(Paths.sound('cancelMenu'));
			MusicBeatState.switchState(new MainMenuState());
		}
		if(controls.ACCEPT) {
			CoolUtil.browserLoad(creditsStuff[curSelected][3]);
		}
		super.update(elapsed);
	}

	function changeSelection(change:Int = 0)
	{
		FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
		do {
			curSelected += change;
			if (curSelected < 0)
				curSelected = creditsStuff.length - 1;
			if (curSelected >= creditsStuff.length)
				curSelected = 0;
		} while(unselectableCheck(curSelected));

		var newColor:Int = creditsStuff[curSelected][4];
		if(newColor != intendedColor) {
			if(colorTween != null) {
				colorTween.cancel();
			}
			intendedColor = newColor;
			colorTween = FlxTween.color(bg, 1, bg.color, intendedColor, {
				onComplete: function(twn:FlxTween) {
					colorTween = null;
				}
			});
		}

		var bullShit:Int = 0;

		for (item in grpOptions.members)
		{
			item.targetY = bullShit - curSelected;
			bullShit++;

			if(!unselectableCheck(bullShit-1)) {
				item.alpha = 0.6;
				if (item.targetY == 0) {
					item.alpha = 1;
				}
			}
		}
		descText.text = creditsStuff[curSelected][2];
	}

	private function unselectableCheck(num:Int):Bool {
		return creditsStuff[num].length <= 1;
	}
}
