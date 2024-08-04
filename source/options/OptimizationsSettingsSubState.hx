package options;


class OptimizationsSettingsSubState extends BaseOptionsMenu
{
	public function new()
	{
		title = 'Optimization';
		rpcTitle = 'Optimization Settings Menu'; //for Discord Rich Presence

		var option:Option = new Option('Disable Note Splash', //No more splashy :)
		"Disables Notesplashes. \n Disables Note Colors menu",
		'nosplashes',
		'bool');
		addOption(option);

		var option:Option = new Option('Disable Ratings', //No more Combos
		"If checked, it disables the ratings that popup \n when presing a note. \n Kind of ruins the optimization of the engine :/.",
		'noratings',
		'bool');
		addOption(option);

		var option:Option = new Option('Opponent Static Strums', // No more Strum Animations
		"Keeps the opponent strums static. \n Disables Note Colors menu",
		'oppstrumstatic',
		'bool');
		addOption(option);

		var option:Option = new Option('Player Static Strums', // No more Strum Animations
		"Keeps the player strums static. \n Disables Note Colors menu",
		'playerstrumstatic',
		'bool');
		addOption(option);

	super();
	}

	override function changeSelection(change:Int = 0)
	{
		super.changeSelection(change);
	}
}