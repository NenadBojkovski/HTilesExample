package view.map
{
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.utils.Dictionary;
	
	import tilemap.ITile;
	import tilemap.ITileMap;
	import tilemap.Tile;
	
	import utils.ColorUtils;

	public class MapView extends Sprite
	{
		private var tiles: Dictionary = new Dictionary(); 
		private var tileHovered: Sprite;
		private var neighbors: Vector.<Sprite> = new Vector.<Sprite>();
		
		public function MapView()
		{
		}
		
		public function createOrthoMapView(map: ITileMap, columns: Number, rows: Number): void {
			invalidate();
			TiledViewCreator.createOrthoMapView(this, map, tiles, columns, rows);
		}
	
		public function createAxialMapView(map: ITileMap, n: Number): void {
			invalidate();
			TiledViewCreator.createAxialMapView(this, map, tiles, n);
		}
	
		private function invalidate(): void {
			while (numChildren > 0) {
				removeChildAt(0);
			}
			tiles = new Dictionary(); 
			tileHovered = null;
			neighbors.length = 0;
		}
		
		public function update(map: ITileMap, tile: ITile):void
		{
			var tileView: Sprite = tiles[tile.i+"_"+tile.j];
			if(tileView && (tileHovered != tileView)){
				removeNeighborColor();
				tileHovered && ColorUtils.removeColor(tileHovered);
				tileHovered = tileView;
				ColorUtils.setColor(tileHovered, 0xFF0000);
				setNeighborColor(map, tile);
			}
		}
		
		protected function setNeighborColor(map: ITileMap, tile: ITile): void {
			neighbors.length = 0;
			var tileView: Sprite;
			var neighborTile: ITile;
			var neighborTiles: Vector.<ITile> = map.getTileNeighbors(tile);
			var neighborLenght: int = neighborTiles.length;
			for(var i:int = 0; i < neighborLenght; ++i) {
				neighborTile = neighborTiles[i];
				tileView = tiles[neighborTile.i+"_"+neighborTile.j];
				if (tileView) {
					ColorUtils.setColor(tileView,0x0000FF);
					neighbors.push(tileView);
				}
			}
		}
		
		protected function removeNeighborColor(): void {
			var neighborLenght: int = neighbors.length;
			for(var i:int = 0; i < neighborLenght; ++i) {
				ColorUtils.removeColor(neighbors[i]);
			}
			neighbors.length = 0;
		}
	}
}