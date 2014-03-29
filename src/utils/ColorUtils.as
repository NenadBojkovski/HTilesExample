package utils
{
	import flash.display.DisplayObject;
	import flash.geom.ColorTransform;

	public class ColorUtils
	{
		public static function setColor(displayObject: DisplayObject, color: uint): void
		{
			var colorTransform: ColorTransform = displayObject.transform.colorTransform;
			colorTransform.color = color;
			displayObject.transform.colorTransform = colorTransform;
		}
		
		public static function removeColor(displayObject: DisplayObject): void
		{
			displayObject.transform.colorTransform = new ColorTransform();
		}
		
	}
}