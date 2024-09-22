package options;


class OptimizationsSettingsSubState extends BaseOptionsMenu
{
	public function new()
	{
		title = 'Optimization';
		rpcTitle = 'Optimization Settings Menu'; //for Discord Rich Presence

		var option:Option = new Option('Disable Ratings', //No more Combos
		"If checked, it disables the ratings that popup \n when pressing a note.",
		'noratings',
		'bool');
		addOption(option);

		var option:Option = new Option('Opponent Static Strums', // No more Strum Animations
		"Keeps the opponent strums static.",
		'oppstrumstatic',
		'bool');
		addOption(option);

		var option:Option = new Option('Player Static Strums', // No more Strum Animations
		"Keeps the player strums static.",
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