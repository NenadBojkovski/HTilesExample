package
{
	
	import tilemap.ITileMap;
	import tilemap.TileMap;
	import tilemap.hexmap.HexMapFactory;
	import tilemap.isomap.IsoMap;
	import tilemap.skewedmap.SkewedMap;
	import tilemap.squaremap.SquareMap;

	public class TileMapFactory
	{
		public static function createMap(mapData: MapData): ITileMap
		{
			var map: ITileMap;
			switch(mapData.mapType)
			{
				case TileMap.SQUARED:
				{
					map = new SquareMap(mapData.side, mapData.hasDiagonalNeighbor);
					break;
				}
				case TileMap.SKEWED:
				{
					map = new SkewedMap(mapData.side, mapData.skew, mapData.hasDiagonalNeighbor);
					break;
				}
				case TileMap.ISO:
				{
					var height: int = mapData.side;
					map = new IsoMap(height, mapData.hasDiagonalNeighbor);
					break;
				}
				case TileMap.HEXA:
				{
					var hexRadius: int = mapData.side;
					map = HexMapFactory.creatHexMap(hexRadius, mapData.hexaTileType, mapData.hexaMapLayout);
					break;
				}
				default:
				{
					break;
				}
			}
			map.rotation = mapData.rotation;
			map.scaleTileHorizontal = mapData.scaleX;
			map.scaleTileVertical = mapData.scaleY;
			map.pivotAlignment = mapData.pivot;
			return map;
		}
	}
}