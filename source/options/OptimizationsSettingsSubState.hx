package options;


class OptimizationsSettingsSubState extends BaseOptionsMenu
{
	public function new()
	{
		title = 'Optimization';
		rpcTitle = 'Optimization Settings Menu'; //for Discord Rich Presence


		var option:Option = new Option('Static Opponent Strums', //Name
			"If checked, makes the opponent strums have no animations.", //Description
			'staticoppstrums',
			'bool');
		addOption(option);

        var option:Option = new Option('Static Player Strums', //Name
            "If checked, makes the player strums have no animations.", //Description
            'staticplayerstrums',
            'bool');
        addOption(option);

	super();
	}

	override function changeSelection(change:Int = 0)
	{
		super.changeSelection(change);
	}
}