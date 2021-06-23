function SYWebInjection() {
    var obj = new Object();
    obj.logInNative = logInNative;
    obj.h5SendToNative = h5SendToNative;
    obj.syWebcallback = syWebcallback;
    obj.createMsgId = createMsgId;
    obj.nativeSendToH5 = nativeSendToH5;
    obj.nativeCallback = nativeCallback;
    obj.handleNativeMsg = handleNativeMsg;
    return obj;
}
//保存h5发送消息到native的回调方法
var sy_web_func_dic = {};
//保存native发送消息到h5的回调方法
var sy_native_func_dic = {};
var uniqueId = 1;

function logInNative(params) {
    var newParams = { param: params, key: "sy_web_log" };
    this.h5SendToNative(newParams);
}

//h5发送消息给native
function h5SendToNative(params, success, fail) {
    /*
    params = {key:"xxx",param:param}
    */
    var callbackId = this.createMsgId();
    var newParams = {
        callbackId: callbackId,
        params: params
    };
    sy_web_func_dic[callbackId] = { success: success, fail: fail };
    window.webkit.messageHandlers.msgFromH5.postMessage(newParams);
}

///native执行完消息之后的回调
function syWebcallback(params) {
    //native传过来的参数都是字符串，需要先转换成对象
    var jsonObj = JSON.parse(params);
    var msgid = jsonObj["callbackId"];
    var callback = sy_web_func_dic[msgid];
    if (callback == undefined) { return; }
    sy_web_func_dic[msgid] = null;
    var param = jsonObj["params"];
    var isSuc = Boolean(jsonObj["isSucCallback"]);
    if (isSuc) {
        var success = callback["success"];
        if (success == undefined) { return; }
        success(param);
        return;
    }
    var fail = callback["fail"];
    if (fail == undefined) { return; }
    fail(param);
}

function createMsgId() {
    return 'cb_' + (uniqueId++) + '_' + new Date().getTime();
}

//native传过来的参数都是字符串，需要先转换成对象
///native发送消息给web
function nativeSendToH5(params) {
    //native传过来的参数都是字符串，需要先转换成对象
    var jsonObj = JSON.parse(params);
    var msgid = jsonObj["callbackId"];
    var param = jsonObj["params"];
    var sucCallback = function (sucParams) {
        this.nativeCallback(sucParams, msgid, true);
    };
    var failCallback = function (failParams) {
        this.nativeCallback(failParams, msgid, false);
    };
    if (this.handleNativeMsg == undefined) {
        return;
    }
    this.handleNativeMsg(param, sucCallback, failCallback);
}

function nativeCallback(params, msgid, issuccess) {
    var newParams = {
        key: "sy_nativeCallback",
        param: params,
        msgId: msgid,
        issuccess: issuccess
    };
    this.h5SendToNative(newParams);
}

//需要重写此方法
function handleNativeMsg(params, success, fail) {
    var key = params["key"];
    if(key == "test"){
        this.logInNative(params);
        // success({nice:"success"});
        fail({nice:"fail"});
        return;
    }
}