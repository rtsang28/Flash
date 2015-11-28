package ASfile {

	import flash.display.*;
	import flash.geom.*;
	 
	public class spheresettings extends Sprite {
		  
		private var bdPic:BitmapData;
		private var vertsVec:Array;
        private var picWidth:Number;
		private var picHeight:Number;
		private var spSphere:Sprite;
        private var spSphereImage:Sprite;
		private var radius:Number;
		private var nMesh:Number;
		private var tilesNum:Number;
		
		/*
		The constructor takes one parameter: a BitmapData object, 'b', corresponding
		to the picture to be pasted over a sphere. Typically, it will be
		a BitmapData object corresponding to an image imported to the Library
		in a fla file and linked to AS3 or an image loaded at runtime. 
		The radius of the sphere is calculated based on the dimensions of 'b'.
		'b'  should have dimension ratio 2 to 1 for best results.
		*/
		//bdPic holds all the pixels information about the image
		//that will be pasted over a sphere.
		public function spheresettings(b:BitmapData) {
			bdPic=b;
		  
			//The width of the main image is set to the width of the BitmapData
			//object passed to the constructor. Its height is set to the half
			// of the width. If the image passed to the constructor is taller,
			//the bottom will be cropped. If you change picHeight to bdPic.height,
			//the image will be distorted rather than cropped.
			picWidth=bdPic.width;
			picHeight=picWidth/2;
		  
			//The width of the picture has to be equal to the circumference
			//of the sphere. Thus, the radiusius, radius, is set accordingly.
			//Choosing a different radiusius will distort the image.
			radius=Math.floor(picWidth/(Math.PI*2));
		  
			/*
			The Sprite spSphere is an abstract 3D construct.
			spSphere is never added to the Display List. It
			serves as a holder for 3D vertices on the sphere, 
			coordinates of their 2D projections, and the current transformation matrix. 
			After all the vertex calculations are perfomed and the coordinates
			of all 2D points necessary for drawing an image of the sphere
			are obtained, the actual image is drawn in the Sprite spSphereImage.
			*/
			spSphere=new Sprite();
			//AS3 will see it as 3D object after call up 3D property
			spSphere.rotationX=0;
			spSphere.rotationY=0;
			spSphere.rotationZ=0;
			spSphereImage=new Sprite();
			this.addChild(spSphereImage);
		  
			/*I decided to set mesh number to 28. just right; low number leads to unsmoothness of spehere
			& higher number will slow the performance down, but sharper edges. */
			nMesh=20;
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
			 
			//Setting 3D coordinates of mesh vertices on the sphere 
			vertsVec[i][j]=new Vector3D(radius*Math.sin(istep*i)*Math.sin(jstep*j),-radius*Math.cos(jstep*j),-radius*Math.cos(istep*i)*Math.sin(jstep*j));
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