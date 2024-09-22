package mobile.objects;

import mobile.input.MobileInputManager;
import mobile.objects.TouchButton;

/**
 * ...
 * @author: Karim Akra
 */
interface IMobileControls
{
	public var buttonLeft:TouchButton;
	public var buttonUp:TouchButton;
	public var buttonRight:TouchButton;
	public var buttonDown:TouchButton;
	public var buttonExtra:TouchButton;
	public var buttonExtra2:TouchButton;
	public var instance:MobileInputManager;
}