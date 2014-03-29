package view.map
{
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.Sprite;

	public class TileDrawer
	{
		public static function drawHexaTile(hexaRadius: int, isFlatTopped: Boolean):Sprite
		{
			var tileView: Sprite = new Sprite();
			var graphics: Graphics = tileView.graphics;
			var AThirdOFPi: Number = Math.PI/3;
			var rotationForPointy: Number = isFlatTopped ? 0 : (Math.PI * 0.5);
			var x:Number = hexaRadius * Math.cos(AThirdOFPi + rotationForPointy);
			var y:Number = hexaRadius * Math.sin(AThirdOFPi + rotationForPointy);
			graphics.moveTo(x,y);
			graphics.lineStyle(0.5,0x000000);
			graphics.beginFill(0xAABBCC);
			for( var i: int = 1; i < 8; ++i) {
				x = hexaRadius * Math.cos(i * AThirdOFPi + rotationForPointy);
				y = hexaRadius * Math.sin(i * AThirdOFPi + rotationForPointy);
				graphics.lineTo(x,y);
			}
			graphics.endFill();
			return tileView;
		}
		
		public static function drawSqaredTile(side: Number):Sprite
		{
			var tileView: Sprite = new Sprite();
			var graphics: Graphics = tileView.graphics;
			var x:Number = -side * 0.5;
			var y:Number = x;
			graphics.moveTo(x,y);
			graphics.lineStyle(0.5,0x000000);
			graphics.beginFill(0xAABBCC);
			graphics.lineTo(x += side,y);
			graphics.lineTo(x,y += side);
			graphics.lineTo(x -= side,y);
			graphics.lineTo(x,y -= side);
			graphics.endFill();
			return tileView;
		}
		
		public static function drawSkewedTile(side: Number, skewX: Number):Sprite
		{
			var tileView: Sprite = new Sprite();
			var graphics: Graphics = tileView.graphics;
			var skewedDistance: Number = side * skewX;
			var x:Number = (skewedDistance - side )* 0.5;
			var y:Number = - side * 0.5;;
			graphics.moveTo(x,y);
			graphics.lineStyle(0.5,0x000000);
			graphics.beginFill(0xAABBCC);
			graphics.lineTo(x += side,y);
			graphics.lineTo(x -= skewedDistance,y += side);
			graphics.lineTo(x -= side,y);
			graphics.lineTo(x += skewedDistance,y -= side);
			graphics.endFill();
			return tileView;
		}
		
		public static function drawIsoTile(height: Number):Sprite
		{
			var tileView: Sprite = new Sprite();
			var graphics: Graphics = tileView.graphics;
			var halfHeight: Number = height * 0.5;
			var x:Number = 0;
			var y:Number = -halfHeight;
			graphics.moveTo(x,y);
			graphics.lineStyle(0.5,0x000000);
			graphics.beginFill(0xAABBCC);
			graphics.lineTo(x = height, y = 0);
			graphics.lineTo(x = 0,y = halfHeight);
			graphics.lineTo(x = -height,y = 0);
			graphics.lineTo(x = 0,y = -halfHeight);
			graphics.endFill();
			return tileView;
		}
		
		public static function drawPivotPoint():Sprite
		{
			var pivotPoint: Sprite = new Sprite();
			var graphics: Graphics = pivotPoint.graphics;
			graphics.beginFill(0x000000);
			graphics.drawCircle(0, 0, 5);
			graphics.endFill();
			return pivotPoint;
		}
	}
}