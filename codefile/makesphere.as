package {// com.flashandmath.cs4 {
	 import flash.display.*;
	 import flash.geom.*;
	 
	 public class BitmapSphereBasic extends Sprite {
		  
		private var bdPic:BitmapData;
		private var vertsVec:Array;
        private var picWidth:Number;
		private var picHeight:Number;
		private var spSphere:Sprite;
        private var spSphereImage:Sprite;
		private var rad:Number;
		private var nMesh:Number;
		private var tilesNum:Number;
		
		public function BitmapSphereBasic(b:BitmapData) {
			
		  bdPic=b;
		  picWidth=bdPic.width;
		  picHeight=picWidth/2;		  
		  rad=Math.floor(picWidth/(Math.PI*2));
		  spSphere=new Sprite();
		  spSphere.rotationX=0;
		  spSphere.rotationY=0;
		  spSphere.rotationZ=0;
          spSphereImage=new Sprite();

          this.addChild(spSphereImage);
		  
		  nMesh=30;
		  tilesNum=nMesh*nMesh;
          vertsVec=[];
		  setVertsVec();
          rotateSphere(0,0,0);
	}
		
	private function setVertsVec():void {
	
	      var i:int;
	      var j:int;
	      var istep:Number;
          var jstep:Number;
	
          istep=2*Math.PI/nMesh;
          jstep=Math.PI/nMesh;

	  for(i=0;i<=nMesh;i++){
		  vertsVec[i]=[];
		
		 for(j=0;j<=nMesh;j++){
			
			vertsVec[i][j]=new Vector3D(rad*Math.sin(istep*i)*Math.sin(jstep*j),-rad*Math.cos(jstep*j),-rad*Math.cos(istep*i)*Math.sin(jstep*j));
		}}}
   
  public function rotateSphere(rotx:Number,roty:Number,rotz:Number):void {
	  
	  var paramMat:Matrix3D;
	  spSphere.transform.matrix3D.appendRotation(rotx,Vector3D.X_AXIS);
	  spSphere.transform.matrix3D.appendRotation(roty,Vector3D.Y_AXIS);
	  spSphere.transform.matrix3D.appendRotation(rotz,Vector3D.Z_AXIS);
	  paramMat=spSphere.transform.matrix3D.clone();
	  transformSphere(paramMat);
  }
  
  public function autoSpin(roty:Number):void {
	   
	  var paramMat:Matrix3D;
	  spSphere.transform.matrix3D.prependRotation(roty,Vector3D.Y_AXIS);
	  paramMat=spSphere.transform.matrix3D.clone();
	  transformSphere(paramMat);
   }

  private function transformSphere(mat:Matrix3D):void {
	
	var i:int;
	var j:int;
	var n:int;
	var distArray=[];
	var dispPoints=[];
	var newVertsVec=[];
	var zAverage:Number;
	var dist:Number;
	var curVertsNum:int=0;
    var vertices:Vector.<Number>=new Vector.<Number>();
    var indices:Vector.<int>=new Vector.<int>();
    var uvtData:Vector.<Number>=new Vector.<Number>();
	var curv0:Point=new Point();
	var curv1:Point=new Point();
	var curv2:Point=new Point();
	var curv3:Point=new Point();
	var curObjMat:Matrix3D=mat.clone();
	
	vertices=new Vector.<Number>();
    indices=new Vector.<int>();
	uvtData=new Vector.<Number>();
	spSphereImage.graphics.clear();
	
	for(i=0;i<=nMesh;i++){
		newVertsVec[i]=[]; 
		for(j=0;j<=nMesh;j++){
			newVertsVec[i][j]=curObjMat.deltaTransformVector(vertsVec[i][j]);
		}}
	
	for(i=0;i<nMesh;i++){
		for(j=0;j<nMesh;j++){
		zAverage=(newVertsVec[i][j].z+newVertsVec[i+1][j].z+newVertsVec[i][j+1].z+newVertsVec[i+1][j+1].z)/4;
		dist=zAverage;
		distArray.push([dist,i,j]);
		}}

	distArray.sort(byDist);

	for(i=0;i<=nMesh;i++){
		dispPoints[i]=[];
		for(j=0;j<=nMesh;j++){
		dispPoints[i][j]=new Point(newVertsVec[i][j].x,newVertsVec[i][j].y);
	}}
	
	for(n=0;n<tilesNum;n++){
		
		i=distArray[n][1]; 
		j=distArray[n][2];
		
		curv0=dispPoints[i][j].clone();
		curv1=dispPoints[i+1][j].clone();
		curv2=dispPoints[i+1][j+1].clone();
		curv3=dispPoints[i][j+1].clone();
		
		vertices.push(curv0.x,curv0.y,curv1.x,curv1.y,curv2.x,curv2.y,curv3.x,curv3.y);
		indices.push(curVertsNum,curVertsNum+1,curVertsNum+3,curVertsNum+1,curVertsNum+2,curVertsNum+3);
		uvtData.push(i/nMesh,j/nMesh,(i+1)/nMesh,j/nMesh,(i+1)/nMesh,(j+1)/nMesh,i/nMesh,(j+1)/nMesh);
		curVertsNum+=4;
	 }
	 
	spSphereImage.graphics.beginBitmapFill(bdPic);
	spSphereImage.graphics.drawTriangles(vertices,indices,uvtData);		
	spSphereImage.graphics.endFill();
  }

   private function byDist(v:Array,w:Array):Number {
	
	 if (v[0]>w[0]){
		return -1;
	  } else if (v[0]<w[0]){
		return 1;
	   } else {
		return 0;
	 }}
  
  //The public method that should be called before an instance of BitmapSphere is removed.
	  public function destroy():void {
		    
		  spSphereImage.graphics.clear();
		  spSphereImage=null;  
		  spSphere=null;
	  }}}