package
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.geom.Matrix3D;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.utils.Dictionary;
	
	import tilemap.ITile;
	import tilemap.ITileMap;
	import tilemap.PivotAlignment;
	import tilemap.Tile;
	import tilemap.TileMap;
	import tilemap.hexmap.HexMap;
	import tilemap.hexmap.HexMapFactory;
	import tilemap.hexmap.layout.HexaMapLayout;
	import tilemap.isomap.IsoMap;
	import tilemap.skewedmap.SkewedMap;
	import tilemap.squaremap.SquareMap;
	
	import utils.ColorUtils;
	
	import view.map.MapView;
	import view.map.TiledViewCreator;
	import view.menu.ChooseMapMenu;
	
	[SWF(frameRate="30", width="1024", height="768")]
	public class HTilesExample extends Sprite
	{
		private const MAP_VIEW_X: int = 256;
		private const MAP_VIEW_Y: int = 200;
		
		private var map: ITileMap;
		private var chooseMenu: ChooseMapMenu;
		private var mapView: MapView;
		
		public function HTilesExample()
		{
			chooseMenu = new ChooseMapMenu();
			chooseMenu.addEventListener(ChooseMapMenu.CHANGE, onUiChange);
			chooseMenu.x = 10;

			mapView = new MapView();
			mapView.x = MAP_VIEW_X;
			mapView.y = MAP_VIEW_Y;
			
			addChild(mapView);
			addChild(chooseMenu);
			
			createMap();
			
			stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		private function createMap():void
		{
			map = TileMapFactory.createMap(chooseMenu.mapData);
			mapView.x = MAP_VIEW_X;
			mapView.y = MAP_VIEW_Y;
			
			if((map is HexMap) && HexMap(map).isAxial){
				var n: Number = chooseMenu.mapData.rows;
				mapView.createAxialMapView(map, n);
				mapView.x = stage.stageWidth * 0.5;
				mapView.y = stage.stageHeight * 0.5;
			} else {
				mapView.createOrthoMapView(map, chooseMenu.mapData.columns, chooseMenu.mapData.rows);
				if(map is IsoMap){
					mapView.x = stage.stageWidth * 0.5;
				}			
			}
		}
		
		protected function onUiChange(event:Event):void
		{
			createMap();		
		}
			
		protected function onEnterFrame(event:Event):void
		{
			var screenPoint: Point = mapView.globalToLocal(new Point(stage.mouseX, stage.mouseY));
			var mapPoint: Point = map.screenToMapCoordinates(screenPoint);
			var tile: ITile = map.getTile(screenPoint.x, screenPoint.y);
			mapView.update(map, tile);
			chooseMenu.updateTile(tile);
			chooseMenu.updateMapCoordinates(mapPoint);
		}
	}

}