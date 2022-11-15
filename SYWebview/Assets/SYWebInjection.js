
var sy_web_bridge_container = {}
var sy_web_bridge_id = "sy_web_bridge_id"

function nativeSendToH5(params) {
    //native传过来的参数都是字符串，需要先转换成对象
    var msgObj = JSON.parse(params)
    var sy_bridge_id = msgObj[sy_web_bridge_id];
    var sy_web_bridge = sy_web_bridge_container[sy_bridge_id];
    var realMsg = msgObj["sy_bridge_params"];
    if (typeof(realMsg) == "String") {
        realMsg = JSON.parse(realMsg);
    }
    sy_web_bridge.syRealNativeSendToH5(realMsg);
}

function SYWebInjection() {
    var obj = new Object();
    //保存消息的回调方法
    obj.sy_web_func_dic = {};
    //注册的消息
    obj.sy_reg_dic = {};
    obj.sy_bridge_id = sy_web_bridge_id + "_" + new Date().getTime();

    //初始化
    function initWebBridge(){
        var msgid = this.createMsgId();
        var bridge_id = this.sy_bridge_id;
        sy_web_bridge_container[bridge_id] = this
        this.syRealH5SendToNative(msgid,
                                  "sy_web_bridge_init",
                                  {sy_web_bridge_id:bridge_id},
                                  true);
    }
    
    //通过native打印日志
    function logInNative(params) {
        var msgid = this.createMsgId()
        this.syRealH5SendToNative(msgid, "sy_web_log", params);
    }

    function h5SendToNative(key, params, success, fail) {
        var msgid = this.createMsgId()
        this.syRealH5SendToNative(msgid, key, params, true, success, fail);
    }

    //h5发送消息给native
    function syRealH5SendToNative(msgid, key, params, isSuccess, success, fail) {
        /*
     msg = {
     sy_msgid:xxx,
     sy_key:xxx,
     sy_params:xxx,
     sy_success:bool
     }
     */
        var msg = { };
        msg["sy_msgid"] = msgid;
        msg["sy_key"] = key;
        msg["sy_params"] = params;
        msg["sy_success"] = isSuccess;
        
        var callback = {};
        var noSuccessCallback = success == null || typeof(success) == "undefined";
        if (!noSuccessCallback){
            callback["success"] = success;
        }
        var noFailCallback = noFailCallback = fail == null || typeof(fail) == "undefined";
        if(!noFailCallback){
            callback["fail"] = fail;
        }
        var noCallback = noSuccessCallback && noFailCallback;
        if(!noCallback){
            this.sy_web_func_dic[msgid] = callback;
        }
        window.webkit.messageHandlers.syMsgFromH5.postMessage(msg);
    }
    
    ///native执行完消息之后的回调
    function syWebcallback(msgid, params, issuccess) {
        var callback = this.sy_web_func_dic[msgid];
        if (callback == undefined) { return; }
        this.sy_web_func_dic[msgid] = null;
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
        return 'cb_' + new Date().getTime();
    }
    
    ///native发送消息给web
    function syRealNativeSendToH5(msgObj) {
        var msgid = msgObj["sy_msgid"];
        var param = msgObj["sy_params"];
        var key = msgObj["sy_key"];
        var issuccess = Boolean(msgObj["sy_success"]);
        if (key == "sy_web_callback") {
            this.syWebcallback(msgid, param, issuccess);
            return
        }
        var that = this;
        var sucCallback = function (sucParams) {
            that.nativeCallback(sucParams, msgid, true);
        };
        var failCallback = function (failParams) {
            that.nativeCallback(failParams, msgid, false);
        };
        var isRegistered = this.handleRegEvent(key, param, sucCallback, failCallback);
        if (isRegistered) {
            return;
        }
        if (this.handleNativeMsg == undefined) {
            return;
        }
        this.handleNativeMsg(key, param, sucCallback, failCallback);
    }

    function nativeCallback(params, msgid, issuccess) {
        this.syRealH5SendToNative(msgid, "sy_nativeCallback", params, issuccess);
    }

    //需要重写此方法
    function handleNativeMsg(key, params, success, fail) {
    }

    function registerFunc(key, handle) {
        this.sy_reg_dic[key] = handle;
    }

    function handleRegEvent(key, params, success, fail) {
        var handle = this.sy_reg_dic[key];
        if (handle == undefined) {
            return false;
        }
        handle(params, success, fail);
        return true;
    }
    
    obj.initWebBridge = initWebBridge;
    obj.logInNative = logInNative;
    obj.h5SendToNative = h5SendToNative;
    obj.syRealNativeSendToH5 = syRealNativeSendToH5;
    obj.handleNativeMsg = handleNativeMsg;
    obj.registerFunc = registerFunc;
    obj.handleRegEvent = handleRegEvent;
    obj.createMsgId = createMsgId;
    obj.nativeCallback = nativeCallback;
    obj.syRealH5SendToNative = syRealH5SendToNative;
    obj.syWebcallback = syWebcallback;


    return obj;
}
