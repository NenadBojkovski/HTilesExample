package view.map
{
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.utils.Dictionary;
	
	import tilemap.ITile;
	import tilemap.ITileMap;
	import tilemap.Tile;
	import tilemap.hexmap.HexMap;
	import tilemap.hexmap.layout.FlatToppedHexMap;
	import tilemap.isomap.IsoMap;
	import tilemap.skewedmap.SkewedMap;
	import tilemap.squaremap.SquareMap;

	public class TiledViewCreator
	{
		public static function createOrthoMapView(tileContainer: Sprite, map: ITileMap, tiles: Dictionary, numColumns: int = 10, numRows: int = 10): void {
			var tileView: Sprite;
			var pivotPoint: Sprite;
			var point: Point;
			var tile:ITile;
			for (var i: int = 0; i < numColumns; ++i){
				for (var j: int = 0; j < numRows; ++j) {
					tileView = createTileView(map);
					tile = new Tile(i,j);
					point = map.getTileCenter(tile);
					tileView.x = point.x;
					tileView.y = point.y;
					tileView.rotation = -map.rotation;
					tileView.scaleX = map.scaleTileHorizontal;
					tileView.scaleY = map.scaleTileVertical;
					tileContainer.addChildAt(tileView, 0);
					pivotPoint = TileDrawer.drawPivotPoint();
					point = map.getTilePivot(tile);
					pivotPoint.x = point.x;
					pivotPoint.y = point.y;
					tileContainer.addChild(pivotPoint);
					tiles[i+"_"+j] = tileView;
				}
			}
		}
		
		public static function createAxialMapView(tileContainer: Sprite, map: ITileMap, tiles: Dictionary, n: int = 5): void {
			var hexaTile: Sprite;
			var pivotPoint: Sprite;
			var point: Point;
			var tile: ITile;
			const max: Function = Math.max;
			const min: Function = Math.min;
			for (var i: int = - n; i <= n; ++i){
				for (var j: int = max(-n, -i - n); j <= min(n, -i + n); ++j) {
					hexaTile = createTileView(map);
					var k: int = -i - j;
					tile = new Tile(i,k);
					point = map.getTileCenter(tile);
					hexaTile.x = point.x;
					hexaTile.y = point.y;
					hexaTile.rotation = -map.rotation;
					hexaTile.scaleX = map.scaleTileHorizontal;
					hexaTile.scaleY = map.scaleTileVertical;
					tileContainer.addChildAt(hexaTile, 0);
					pivotPoint = TileDrawer.drawPivotPoint();
					point = map.getTilePivot(tile);
					pivotPoint.x = point.x;
					pivotPoint.y = point.y;
					tileContainer.addChild(pivotPoint);
					tiles[i+"_"+k] = hexaTile;
				}
			}
		}
		
		private static function createTileView(map: ITileMap): Sprite {
			if (map is SkewedMap) {
				return TileDrawer.drawSkewedTile(SkewedMap(map).tileSideLenght, SkewedMap(map).skew);
			} else if (map is SquareMap) {
				return TileDrawer.drawSqaredTile(SquareMap(map).tileSideLenght);
			} else if (map is IsoMap) {
				return TileDrawer.drawIsoTile(IsoMap(map).tileHeight);
			} else if (map is HexMap) {
				return TileDrawer.drawHexaTile(HexMap(map).hexagonRadius, map is FlatToppedHexMap);
			}
			return new Sprite();
		}
	}
}