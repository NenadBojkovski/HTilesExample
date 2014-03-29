package view.menu
{
	import fl.events.ComponentEvent;
	import fl.events.SliderEvent;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.geom.Point;
	import flash.utils.Dictionary;
	
	import tilemap.ITile;
	import tilemap.PivotAlignment;
	import tilemap.Tile;
	import tilemap.TileMap;
	import tilemap.hexmap.HexMap;
	import tilemap.hexmap.layout.HexaMapLayout;

	public class ChooseMapMenu extends Sprite
	{
		public static const CHANGE: String = "UIChange";
		
		private const SCALE_FACTOR: Number = 50;
		private const SKEW_FACTOR: Number = 100;
		
		private var _menu: MenuMc;	
		private var _mapData: MapData = new MapData();
		private var comboItemIndexToMapType: Dictionary = new Dictionary();
		private var comboItemIndexToMapTileType: Dictionary = new Dictionary();
		private var comboItemIndexToMapLayout: Dictionary = new Dictionary();
		private var comboItemIndexToPivotAlignment: Dictionary = new Dictionary();
		
		public function ChooseMapMenu()
		{
			_menu = new MenuMc();
			addChild(_menu);
			init();
		}
		
		public function updateTile(tile: ITile): void {
			_menu.tileLbl.text = tile.toString();
		}
		
		public function updateMapCoordinates(mapPoint: Point): void {
			_menu.mapCoordLbl.text = "MapCoord: "+mapPoint.toString();
		}
		
		public function get mapData(): MapData {
			_mapData.mapType = comboItemIndexToMapType[_menu.mapType.selectedIndex];
			_mapData.hexaTileType = comboItemIndexToMapTileType[_menu.hexaTopping.selectedIndex];
			_mapData.hexaMapLayout = comboItemIndexToMapLayout[_menu.hexaLayout.selectedIndex];
			_mapData.pivot = comboItemIndexToPivotAlignment[_menu.pivotType.selectedIndex];
			_mapData.hasDiagonalNeighbor = _menu.diagonalNeighbours.selected;
			_mapData.rotation = _menu.rotate.value;
			_mapData.scaleX = _menu.scale_x.value/SCALE_FACTOR;
			_mapData.scaleY = _menu.scale_y.value/SCALE_FACTOR;
			_mapData.skew = _menu.skew.value/SKEW_FACTOR;
			_mapData.side = _menu.side.value;
			_mapData.rows = _menu.rows.value;
			_mapData.columns = _menu.columns.value;
			return _mapData;
		}
		
		private function init():void
		{
			_menu.mapType.selectedIndex = 0;
			addMappings();
			addEvents();
			setMenuLayout();
			
			_menu.rotateLbl.text = "Rotation: 0";
			_menu.scaleXLbl.text = "ScaleX: 1";
			_menu.scaleYLbl.text = "ScaleY: 1";
			_menu.skewLbl.text = "Skew: 0.5";
			_menu.sideLbl.text = "Side: 50";
			_menu.rowsLbl.text = "Rows: 5";	
			_menu.columnsLbl.text = "Columns: 5";	
			
			_menu.skew.value = SKEW_FACTOR * 0.5;
			_menu.rows.value = _menu.columns.value = 5;
			_menu.scale_x.value = _menu.scale_y.value = SCALE_FACTOR;
			_menu.side.value = 50;
		}
		
		private function addMappings():void
		{
			comboItemIndexToMapType[0] = TileMap.SQUARED;
			comboItemIndexToMapType[1] = TileMap.SKEWED;
			comboItemIndexToMapType[2] = TileMap.ISO;
			comboItemIndexToMapType[3] = TileMap.HEXA;
			
			comboItemIndexToMapTileType[0] = HexMap.FLAT_TOPPED;
			comboItemIndexToMapTileType[1] = HexMap.POINTY_TOPPED;
			
			comboItemIndexToMapLayout[0] = HexaMapLayout.CONCAVE_FIRST;
			comboItemIndexToMapLayout[1] = HexaMapLayout.CONVEX_FIRST
			comboItemIndexToMapLayout[2] = HexaMapLayout.DIAMOND_ORIENTATION_UP;
			comboItemIndexToMapLayout[3] = HexaMapLayout.DIAMOND_ORIENTATION_DOWN;
			comboItemIndexToMapLayout[4] = HexaMapLayout.AXIAL;
			
			comboItemIndexToPivotAlignment[0] = PivotAlignment.CENTER;
			comboItemIndexToPivotAlignment[1] = PivotAlignment.CORNER_0;
			comboItemIndexToPivotAlignment[2] = PivotAlignment.CORNER_1;
			comboItemIndexToPivotAlignment[3] = PivotAlignment.CORNER_2;
			comboItemIndexToPivotAlignment[4] = PivotAlignment.CORNER_3;
			comboItemIndexToPivotAlignment[5] = PivotAlignment.CORNER_4;
			comboItemIndexToPivotAlignment[6] = PivotAlignment.CORNER_5;
		}
		
		private function addEvents():void
		{
			_menu.mapType.addEventListener(Event.CHANGE, onMapTypeChange, false, 0, true);	
			_menu.hexaTopping.addEventListener(Event.CHANGE, onChange, false, 0, true);	
			_menu.pivotType.addEventListener(Event.CHANGE, onChange, false, 0, true);	
			_menu.hexaLayout.addEventListener(Event.CHANGE, onLayoutChange, false, 0, true);	
			_menu.diagonalNeighbours.addEventListener(Event.CHANGE, onChange, false, 0, true);	
			_menu.rotate.addEventListener(SliderEvent.THUMB_DRAG, onRotateDrag, false, 0, true);
			_menu.scale_x.addEventListener(SliderEvent.THUMB_DRAG, onScaleXDrag, false, 0, true);
			_menu.scale_y.addEventListener(SliderEvent.THUMB_DRAG, onScaleYDrag, false, 0, true);
			_menu.skew.addEventListener(SliderEvent.THUMB_DRAG, onSkewDrag, false, 0, true);
			_menu.side.addEventListener(SliderEvent.THUMB_DRAG, onSideDrag, false, 0, true);
			_menu.rows.addEventListener(SliderEvent.THUMB_DRAG, onRowsDrag, false, 0, true);
			_menu.columns.addEventListener(SliderEvent.THUMB_DRAG, onColumnsDrag, false, 0, true);
		}
			
		protected function onColumnsDrag(event:SliderEvent):void
		{
			_menu.columnsLbl.text = "Columns: "+event.value;
			dispatchEvent(new Event(CHANGE));
		}
		
		protected function onRowsDrag(event:SliderEvent):void
		{
			updateRowsLblText();
			dispatchEvent(new Event(CHANGE));
		}
			
		protected function onSideDrag(event:SliderEvent):void
		{
			updateSideLblText();
			dispatchEvent(new Event(CHANGE));			
		}
		
		protected function onSkewDrag(event:SliderEvent):void
		{
			_menu.skewLbl.text = "Skew: "+event.value/SKEW_FACTOR;
			dispatchEvent(new Event(CHANGE));
		}
		
		protected function onScaleYDrag(event:SliderEvent):void
		{
			_menu.scaleYLbl.text = "ScaleY: "+event.value/SCALE_FACTOR;	
			dispatchEvent(new Event(CHANGE));
		}
		
		protected function onScaleXDrag(event:SliderEvent):void
		{
			_menu.scaleXLbl.text = "ScaleX: "+event.value/SCALE_FACTOR;
			dispatchEvent(new Event(CHANGE));
		}
		
		protected function onRotateDrag(event:SliderEvent):void
		{
			_menu.rotateLbl.text = "Rotation: "+_menu.rotate.value;
			dispatchEvent(new Event(CHANGE));
		}
		
		protected function onChange(event:Event):void
		{
			dispatchEvent(new Event(CHANGE));
		}
		
		protected function onLayoutChange(event:Event):void
		{
			_menu.columns.visible = _menu.columnsLbl.visible = _menu.mapType.selectedIndex != 3 || _menu.hexaLayout.selectedIndex != 4;
			updateRowsLblText();
			dispatchEvent(new Event(CHANGE));
		}
		
		protected function onMapTypeChange(event:Event):void
		{
			setMenuLayout();		
			dispatchEvent(new Event(CHANGE));
		}
		
		protected function setMenuLayout(): void {
			_menu.hexaLayout.visible = _menu.mapType.selectedIndex == 3;
			_menu.hexaTopping.visible = _menu.mapType.selectedIndex == 3;
			
			_menu.diagonalNeighbours.visible = _menu.mapType.selectedIndex < 3; 
			
			_menu.skew.visible = _menu.skewLbl.visible = _menu.mapType.selectedIndex == 1;
			_menu.columns.visible = _menu.columnsLbl.visible = _menu.mapType.selectedIndex != 3 || _menu.hexaLayout.selectedIndex != 4;
			
			updateSideLblText();
			updateRowsLblText();
		}
		
		protected function updateRowsLblText(): void {
			if (!_menu.columns.visible){
				_menu.rowsLbl.text = "N: "+ _menu.rows.value;
			} else {
				_menu.rowsLbl.text = "Rows: "+ _menu.rows.value;
			}
		}
		
		protected function updateSideLblText(): void {
			if (comboItemIndexToMapType[_menu.mapType.selectedIndex] == TileMap.HEXA) {
				_menu.sideLbl.text = "Hexagon radius: "+_menu.side.value;
			} else if (comboItemIndexToMapType[_menu.mapType.selectedIndex] == TileMap.HEXA) {
				_menu.sideLbl.text = "Isotile height: "+_menu.side.value;
			} else {
				_menu.sideLbl.text = "Side: "+_menu.side.value;
			}
		}
	}
}