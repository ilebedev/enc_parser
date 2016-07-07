open Common

type attr_color = White | Black | Red | Green | Yellow |  Grey |  Brown 
| Amber | Violet | Orange | Magenta | Pink

type attr_color_pattern = CPHorizStripes | CPVertStripes | CPDiagStripes | CPSquared
        | CPStripesUnknown | CPBorderStripe

type attr_condition = AttrCDUnderConstruction | AttrCDRuined |
AttrCDUnderReclaim | AttrCDWingless | AttrCDPlannedConstruction

type attr_beacon_shape = 
        | AttrBSStake | AttrBSWithy | AttrBSBeaconTower | AttrBSLatticeBeacon 
        | AttrBSPileBeacon | AttrBSCairn | AttrBuoyantBeacon

type attr_beacon_mark = 
        | AttrBMFiringDangerArea | AttrBMTargetMark | AttrBMMarkerShipMark
        | AttrBMDegaussingRange 

type attr_radar_status = 
        | AttrRADConspicuous | AttrRADNotConspicuous | AttrRADHasReflector 

type attr_visibility = 
        | AttrVISConspicuous | AttrVISNotConspicuous 

type attr_material = 
        | AttrMATMasonry | AttrMATConcreted | AttrMATLooseBoulders |
        AttrMATHardSurfaced


type attr_status =
        | AttrSTATPermanent | AttrSTATOccasional | AttrSTATRecommended 
        | AttrSTATNotInUse | AttrSTATPeriodic

type attr_building_shape = 
        | AttrSHPHighRise | AttrSHPPyramid | AttrSHPCylindrical


type attr_building_function = 
        | AttrBFXNNoFunction | AttrBFXNHarborMasterOffice | AttrBFXNCustonOffice


(*9*)
type attr = 
        | AttrStatus of attr_status list 
        | AttrHeight of float 
        | AttrElevation of float
        | AttrDateStart of date
        | AttrDateEnd of date
        | AttrVisiblity of attr_visibility 
        | AttrColor of attr_color list
        | AttrBeaconShape of attr_beacon_shape 
        | AttrRadar of attr_radar_status
        | AttrCondition of attr_condition
        | AttrMaterial of attr_material 
        | AttrVerticalLength of float  
        | AttrBuildingShape of attr_building_shape
        | AttrBuildingFunction of attr_building_function

type entity_type =
        | ETypBuildingSingle
        | ETypAnchorageArea 
        | ETypBeaconLateral
        | ETypBeaconSafeWater

type feature = {
        attrs : attr list;
        typ : entity_type;
}

