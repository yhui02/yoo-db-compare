YOO={};

function E$(id){return document.getElementById(id)}
function E$$(e,p){return p.getElementsByTagName(e)}

YOO.getFormElement=function(form, tName){
	var formObj=new Object();
	formObj=(typeof form=='string') ? E$(form) : form;
	var formElements=form.elements;
	return formElements[tName];
};

/*
 * DEMO
 *	<li onclick="YOO.box.show({html:'This is a warning!',animate:false,close:false,boxid:'error',top:5})">No Animation, No Close Button, Auto Width/Height, Custom Styling</li>
 *	<li onclick="YOO.box.show({url:'post.jsp',post:'id=16',width:200,height:100,opacity:20,topsplit:3})">Ajax Post, Fixed Width/Height, Light Mask, Custom Vertical Split</li>
 *	<li onclick="YOO.box.show({html:'The entry has been updated successfully!',animate:false,close:false,mask:false,boxid:'success',autohide:2,top:-14,left:-17})">Custom Position, No Mask, Auto-Hide</li>
 *	<li onclick="YOO.box.show({iframe:'http://www.scriptiny.com/',boxid:'frameless',width:750,height:450,fixed:false,maskid:'bluemask',maskopacity:40,closejs:function(){closeJS()}})">iFrame, Blue Mask, Absolute Position, Frameless, Close Callback</li>
 *	<li onclick="YOO.box.show({url:'advanced.html',width:300,height:150})">Ajax, Advanced Functions</li>
 *	<li onclick="YOO.box.show({image:'images/rhino.jpg',boxid:'frameless',animate:true,openjs:function(){openJS()}})">Image, Load Callback</li>
 */
YOO.box=function(){
	var j,m,b,g,v,p=0;
	return{
		show:function(o){
			v={opacity:70,close:1,animate:1,fixed:1,mask:1,maskid:'',boxid:'',topsplit:2,url:0,post:0,height:0,width:0,html:0,iframe:0};
			for(s in o){v[s]=o[s]}
			if(!p){
				j=document.createElement('div'); j.className='tbox';
				p=document.createElement('div'); p.className='tinner';
				b=document.createElement('div'); b.className='tcontent';
				m=document.createElement('div'); m.className='tmask';
				g=document.createElement('div'); g.className='tclose'; g.v=0;
				document.body.appendChild(m); document.body.appendChild(j); j.appendChild(p); p.appendChild(b);
				m.onclick=g.onclick=YOO.box.hide; window.onresize=YOO.box.resize
			}else{
				j.style.display='none'; clearTimeout(p.ah); if(g.v){p.removeChild(g); g.v=0}
			}
			p.id=v.boxid; m.id=v.maskid; j.style.position=v.fixed?'fixed':'absolute';
			if(v.html&&!v.animate){
				p.style.backgroundImage='none'; b.innerHTML=v.html; b.style.display='';
				p.style.width=v.width?v.width+'px':'auto'; p.style.height=v.height?v.height+'px':'auto'
			}else{
				b.style.display='none'; 
				if(!v.animate&&v.width&&v.height){
					p.style.width=v.width+'px'; p.style.height=v.height+'px'
				}else{
					p.style.width=p.style.height='100px'
				}
			}
			if(v.mask){this.mask(); this.alpha(m,1,v.opacity)}else{this.alpha(j,1,100)}
			if(v.autohide){p.ah=setTimeout(YOO.box.hide,1000*v.autohide)}else{document.onkeyup=YOO.box.esc}
		},
		fill:function(c,u,k,a,w,h){
			if(u){
				if(v.image){
					var i=new Image(); i.onload=function(){w=w||i.width; h=h||i.height; YOO.box.psh(i,a,w,h)}; i.src=v.image
				}else if(v.iframe){
					this.psh('<iframe src="'+v.iframe+'" width="'+v.width+'" frameborder="0" height="'+v.height+'"></iframe>',a,w,h)
				}else{
					var x=window.XMLHttpRequest?new XMLHttpRequest():new ActiveXObject('Microsoft.XMLHTTP');
					x.onreadystatechange=function(){
						if(x.readyState==4&&x.status==200){p.style.backgroundImage=''; YOO.box.psh(x.responseText,a,w,h)}
					};
					if(k){
    	            	x.open('POST',c,true); x.setRequestHeader('Content-type','application/x-www-form-urlencoded'); x.send(k)
					}else{
       	         		x.open('GET',c,true); x.send(null)
					}
				}
			}else{
				this.psh(c,a,w,h)
			}
		},
		psh:function(c,a,w,h){
			if(typeof c=='object'){b.appendChild(c)}else{b.innerHTML=c}
			var x=p.style.width, y=p.style.height;
			if(!w||!h){
				p.style.width=w?w+'px':''; p.style.height=h?h+'px':''; b.style.display='';
				if(!h){h=parseInt(b.offsetHeight)}
				if(!w){w=parseInt(b.offsetWidth)}
				b.style.display='none'
			}
			p.style.width=x; p.style.height=y;
			this.size(w,h,a)
		},
		esc:function(e){e=e||window.event; if(e.keyCode==27){YOO.box.hide()}},
		hide:function(){YOO.box.alpha(j,-1,0,3); document.onkeypress=null; if(v.closejs){v.closejs()}},
		resize:function(){YOO.box.pos(); YOO.box.mask()},
		mask:function(){m.style.height=this.total(1)+'px'; m.style.width=this.total(0)+'px'},
		pos:function(){
			var t;
			if(typeof v.top!='undefined'){t=v.top}else{t=(this.height()/v.topsplit)-(j.offsetHeight/2); t=t<20?20:t}
			if(!v.fixed&&!v.top){t+=this.top()}
			j.style.top=t+'px'; 
			j.style.left=typeof v.left!='undefined'?v.left+'px':(this.width()/2)-(j.offsetWidth/2)+'px'
		},
		alpha:function(e,d,a){
			clearInterval(e.ai);
			if(d){e.style.opacity=0; e.style.filter='alpha(opacity=0)'; e.style.display='block'; YOO.box.pos()}
			e.ai=setInterval(function(){YOO.box.ta(e,a,d)},20)
		},
		ta:function(e,a,d){
			var o=Math.round(e.style.opacity*100);
			if(o==a){
				clearInterval(e.ai);
				if(d==-1){
					e.style.display='none';
					e==j?YOO.box.alpha(m,-1,0,2):b.innerHTML=p.style.backgroundImage=''
				}else{
					if(e==m){
						this.alpha(j,1,100)
					}else{
						j.style.filter='';
						YOO.box.fill(v.html||v.url,v.url||v.iframe||v.image,v.post,v.animate,v.width,v.height)
					}
				}
			}else{
				var n=a-Math.floor(Math.abs(a-o)*.5)*d;
				e.style.opacity=n/100; e.style.filter='alpha(opacity='+n+')'
			}
		},
		size:function(w,h,a){
			if(a){
				clearInterval(p.si); var wd=parseInt(p.style.width)>w?-1:1, hd=parseInt(p.style.height)>h?-1:1;
				p.si=setInterval(function(){YOO.box.ts(w,wd,h,hd)},20)
			}else{
				p.style.backgroundImage='none'; if(v.close){p.appendChild(g); g.v=1}
				p.style.width=w+'px'; p.style.height=h+'px'; b.style.display=''; this.pos();
				if(v.openjs){v.openjs()}
			}
		},
		ts:function(w,wd,h,hd){
			var cw=parseInt(p.style.width), ch=parseInt(p.style.height);
			if(cw==w&&ch==h){
				clearInterval(p.si); p.style.backgroundImage='none'; b.style.display='block'; if(v.close){p.appendChild(g); g.v=1}
				if(v.openjs){v.openjs()}
			}else{
				if(cw!=w){p.style.width=(w-Math.floor(Math.abs(w-cw)*.6)*wd)+'px'}
				if(ch!=h){p.style.height=(h-Math.floor(Math.abs(h-ch)*.6)*hd)+'px'}
				this.pos()
			}
		},
		top:function(){return document.documentElement.scrollTop||document.body.scrollTop},
		width:function(){return self.innerWidth||document.documentElement.clientWidth||document.body.clientWidth},
		height:function(){return self.innerHeight||document.documentElement.clientHeight||document.body.clientHeight},
		total:function(d){
			var b=document.body, e=document.documentElement;
			return d?Math.max(Math.max(b.scrollHeight,e.scrollHeight),Math.max(b.clientHeight,e.clientHeight)):
			Math.max(Math.max(b.scrollWidth,e.scrollWidth),Math.max(b.clientWidth,e.clientWidth))
		}
	}
}();

/*
 * YOO ajax
 * YOO.ajax.call('get.jsp?id=32', 'content', 'display("red")'); // GET
 * YOO.ajax.call('post.jsp', 'content', 'display("green")', 'id=32'); // POST
 *
 * http://www.scripYOO.com/2011/01/simple-ajax-function-example/
 */
YOO.ajax=function(){
	return{
		call:function(u,d,f,p){
			var x=window.XMLHttpRequest?new XMLHttpRequest():new ActiveXObject('Microsoft.XMLHTTP');
			x.onreadystatechange=function(){
				if(x.readyState==4&&x.status==200){
					if(d){
						var t=E$(d);
						t.innerHTML=x.responseText
					}
					if(f){
						var c=new Function(f); c()
					}
				}
			};
			if(p){
				x.open('POST',u,true);
				x.setRequestHeader('Content-type','application/x-www-form-urlencoded');
				x.send(p)
			}else{
				x.open('GET',u,true);
				x.send(null)
			}
		}
	};
}();


/**
 * 设置INPUT默认值
 * @Zelipe
 */
YOO.inputDefaultValue=function(eId, cDef, cCue){
	var inputObj=E$(eId);
	var colorDef=cDef || '#333333';
	var colorCue=cDef || '#999999';
	
	if(inputObj.defaultValue==inputObj.value){
		inputObj.style.color=colorCue;
	}
	
	inputObj.onfocus=function(){
		if(inputObj.defaultValue==inputObj.value){
			inputObj.value='';
			inputObj.style.color=colorDef;
		}
	};
	
	inputObj.onblur=function(){
		if(inputObj.value==''){
			inputObj.style.color=colorCue;
			inputObj.value=inputObj.defaultValue;
		}
	};
};

/**
 * 获取客户端操作系统类型
 * @Zelipe
 */  
YOO.detectOS=function(){
    var sUserAgent=navigator.userAgent;  
    var isWin=(navigator.platform == "Win32") || (navigator.platform == "Windows"); 
    var isMac=(navigator.platform == "Mac68K") || (navigator.platform == "MacPPC") || (navigator.platform == "Macintosh") || (navigator.platform == "MacIntel"); 
    if (isMac) return "Mac";
    var isUnix=(navigator.platform == "X11") && !isWin && !isMac; 
    if (isUnix) return "Unix";
    var isLinux=(String(navigator.platform).indexOf("Linux") > -1); 
    if (isLinux) return "Linux";
    if (isWin) {
        var isWin2K=sUserAgent.indexOf("Windows NT 5.0") > -1 || sUserAgent.indexOf("Windows 2000") > -1; 
        if (isWin2K) return "Win2000";
        var isWinXP=sUserAgent.indexOf("Windows NT 5.1") > -1 || sUserAgent.indexOf("Windows XP") > -1; 
        if (isWinXP) return "WinXP";
        var isWin2003=sUserAgent.indexOf("Windows NT 5.2") > -1 || sUserAgent.indexOf("Windows 2003") > -1; 
        if (isWin2003) return "Win2003";
        var isWin2003=sUserAgent.indexOf("Windows NT 6.0") > -1 || sUserAgent.indexOf("Windows Vista") > -1; 
        if (isWin2003) return "WinVista";
        var isWin2003=sUserAgent.indexOf("Windows NT 6.1") > -1 || sUserAgent.indexOf("Windows 7") > -1;
        if (isWin2003) return "Win7";
    }  
    return "None"; 
};

/**
 * 数组去重复
 * @Zelipe
 */
YOO.delRepeat=function(ary){
	if(!ary) return '';
	var array=new Array();
	var nary=ary.sort();
	for(var i=0,j=0;i<nary.length-1;i++){
		if(nary[i]!=nary[i+1]){
			array[j]=nary[i];
			j++;
		}
	}
	return array;
};

/**
 * 鼠标跟随提示
 * <a href='javascript:;' onmouseover="eTitle(event, 'test a')" onmouseout="eTitle(event, 0)">aa</a>
 * <a href='javascript:;' onmouseover="eTitle(event, 'test b')" onmouseout="eTitle(event, 0)">bb</a>
 */
YOO.eTitle=function(e, str){
    var oThis=arguments.callee;
    if(!str){
        oThis.sug.style.visibility='hidden';
        document.onmousemove=null;
        return;
    }
    if(!oThis.sug){
        var div=document.createElement('div');
        div.className='eTitle';
        var sug=document.createElement('div');
        sug.className='eTitle1';
        var dr=document.createElement('div');
        dr.className='eTitle2';
        var ifr=document.createElement('iframe');
        ifr.className='eTitle3';
        div.appendChild(ifr);
        div.appendChild(dr);
        div.appendChild(sug);
        div.sug=sug;
        document.body.appendChild(div);
        oThis.sug=div;
        oThis.dr=dr;
        oThis.ifr=ifr;
        div=dr=ifr=sug=null;
    }
    var e=e || window.event, obj=oThis.sug, dr=oThis.dr, ifr=oThis.ifr;
    obj.sug.innerHTML=str;

    var w=obj.sug.offsetWidth, h=obj.sug.offsetHeight, dw=document.documentElement.clientWidth||document.body.clientWidth; dh=document.documentElement.clientHeight || document.body.clientHeight;
    var st=document.documentElement.scrollTop || document.body.scrollTop, sl=document.documentElement.scrollLeft || document.body.scrollLeft;
    var left=e.clientX +sl +17 + w < dw + sl  &&  e.clientX + sl + 15 || e.clientX +sl-8 - w, top=e.clientY + st +17 + h < dh + st  &&  e.clientY + st + 17 || e.clientY + st - 5 - h;
    obj.style.left=left+ 10 + 'px';
    obj.style.top=top + 10 + 'px';
    dr.style.width=w + 'px';
    dr.style.height=h + 'px';
    ifr.style.width=w + 3 + 'px';
    ifr.style.height=h + 3 + 'px';
    obj.style.visibility='visible';
    document.onmousemove=function(e){
        var e=e || window.event, st=document.documentElement.scrollTop || document.body.scrollTop, sl=document.documentElement.scrollLeft || document.body.scrollLeft;
        var left=e.clientX +sl +17 + w < dw + sl  &&  e.clientX + sl + 15 || e.clientX +sl-8 - w, top=e.clientY + st +17 + h < dh + st  &&  e.clientY + st + 17 || e.clientY + st - 5 - h;
        obj.style.left=left + 'px';
        obj.style.top=top + 'px';
    }
};
