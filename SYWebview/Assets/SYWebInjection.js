function SYWebInjection() {
    var obj = new Object();
    obj.logInNative = logInNative;
    obj.h5SendToNative = h5SendToNative;
    obj.syWebcallback = syWebcallback;
    obj.createMsgId = createMsgId;
    obj.nativeSendToH5 = nativeSendToH5;
    obj.nativeCallback = nativeCallback;
    obj.handleNativeMsg = handleNativeMsg;
    obj.syRealH5SendToNative = syRealH5SendToNative;
    obj.registerFunc = registerFunc;
    return obj;
}

function SYWebMsg(msgid,key,params,issuccess){
    var obj = new Object();
    obj.msgid = msgid;
    obj.key = key;
    obj.params = params;
    obj.issuccess = Boolean(issuccess);
    return obj;
}

//保存h5发送消息到native的回调方法
var sy_web_func_dic = {};
//保存native发送消息到h5的回调方法
var sy_native_func_dic = {};
var uniqueId = 1;

function logInNative(params) {
    var msgid = this.createMsgId()
    this.syRealH5SendToNative(msgid,"sy_web_log",params);
}

function h5SendToNative(key,params,success,fail) {
    var msgid = this.createMsgId()
    this.syRealH5SendToNative(msgid,key,params,true,success,fail);
}

//h5发送消息给native
function syRealH5SendToNative(msgid,key,params,isSuccess, success, fail) {
    /*
 msg = {
 sy_msgid:xxx,
 sy_key:xxx,
 sy_params:xxx,
 sy_success:bool
 }
 */
    var msg = {
        sy_msgid: msgid,
        sy_key: key,
        sy_params:params,
        sy_success:isSuccess
    };
    sy_web_func_dic[msgid] = { success: success, fail: fail };
    window.webkit.messageHandlers.syMsgFromH5.postMessage(msg);
}

///native执行完消息之后的回调
function syWebcallback(msgid,params,issuccess) {
    var callback = sy_web_func_dic[msgid];
    if (callback == undefined) { return; }
    sy_web_func_dic[msgid] = null;
    if (issuccess) {
        var success = callback["success"];
        if (success == undefined) { return; }
        success(params);
        return;
    }
    var fail = callback["fail"];
    if (fail == undefined) { return; }
    fail(params);
}

function createMsgId() {
    return 'cb_' + (uniqueId++) + '_' + new Date().getTime();
}

//native传过来的参数都是字符串，需要先转换成对象
///native发送消息给web
function nativeSendToH5(params) {
    //native传过来的参数都是字符串，需要先转换成对象
    var jsonObj = JSON.parse(params);
    var msgid = jsonObj["sy_msgid"];
    var param = jsonObj["sy_params"];
    var key = jsonObj["sy_key"];
    var issuccess = Boolean(jsonObj["sy_success"]);
    if (key == "sy_web_callback"){
        this.syWebcallback(msgid,param,issuccess);
        return
    }
    var sucCallback = function (sucParams) {
        this.nativeCallback(sucParams, msgid, true);
    };
    var failCallback = function (failParams) {
        this.nativeCallback(failParams, msgid, false);
    };
    var isRegistered = this.handleRegEvent(key,param,sucCallback,failCallback);
    if(isRegistered){
        return;
    }
    if (this.handleNativeMsg == undefined) {
        return;
    }
    this.handleNativeMsg(key,param, sucCallback, failCallback);
}

function nativeCallback(params, msgid, issuccess) {
    this.syRealH5SendToNative(msgid,"sy_nativeCallback",params,issuccess);
}

//需要重写此方法
function handleNativeMsg(key,params, success, fail) {
    console.log("请自己实现这个方法");
    if(key == "test"){
        this.logInNative(params);
        // success({nice:"success"});
        fail({nice:"fail"});
        return;
    }
}

var sy_reg_dic = {};
function registerFunc(key,handle) {
    sy_reg_dic[key] = handle;    
}

function handleRegEvent(key,params,success,fail) {
    var handle = sy_reg_dic[key];
    if (handle == undefined){
        return false;
    }
    handle(params,success,fail);
    return true;
}