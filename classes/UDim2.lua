-- local UDim = require("UDim");

local name = "UDim2";

local func = {}

local new;

local meta = {
    __metatable = name,
    
    
    __index = function(proxy, key)
        local obj = PROXY__OBJ[proxy];
        
        local val = obj[key];
        if (val ~= nil) then -- val might be false so compare against nil
            return val;
        end

        local func_f = func[key];
        if (func_f) then
            return (function(...) return func_f(obj, ...) end); -- might be able to do memoization here
        end
    end,
    
    __newindex = function(proxy, key)
        error("attempt to modify a read-only key (" ..tostring(key).. ")", 2);
    end,
    
    
    __add = function(proxy1, proxy2)
        local proxy1_t = type(proxy1);
        
        if (proxy1_t ~= "UDim2") then
            error("bad operand #1 to '__add' (UDim2 expected, got " ..proxy1_t.. ")", 2);
        end
        
        local proxy2_t = type(proxy2);
        
        if (proxy2_t ~= "UDim2") then
            error("bad operand #2 to '__add' (UDim2 expected, got " ..proxy2_t.. ")", 2);
        end
        
        
        
        local obj1 = PROXY__OBJ[proxy1];
        local obj2 = PROXY__OBJ[proxy2];
        
        local obj1ScaleX, obj1OffsetX, obj1ScaleY, obj1OffsetY = func.unpack(obj1);
        local obj2ScaleX, obj2OffsetX, obj2ScaleY, obj2OffsetY = func.unpack(obj2);
        
        return new(
            obj1ScaleX  + obj2ScaleX,
            obj1OffsetX + obj2OffsetX,
            obj1ScaleY  + obj2ScaleY,
            obj1OffsetY + obj2OffsetY
        );
    end,
    
    
    __tostring = function(proxy)
        local obj = PROXY__OBJ[proxy];
        
        return "{" ..tostring(obj.x).. "}, {" ..tostring(obj.y).. "}";
    end,
}



local MEM_PROXIES = setmetatable({}, { __mode = "v" });



function new(scaleX, offsetX, scaleY, offsetY)
    if (scaleX ~= nil) then
        local scaleX_t = type(scaleX);
        
        if (scaleX_t ~= "number") then
            error("bad argument #1 to '" ..__func__.. "' (number expected, got " ..scaleX_t.. ")", 2);
        end
    else
        scaleX = 0;
    end
    
    if (offsetX ~= nil) then
        local offsetX_t = type(offsetX);
        
        if (offsetX_t ~= "number") then
            error("bad argument #2 to '" ..__func__.. "' (number expected, got " ..offsetX_t.. ")", 2);
        end
    else
        offsetX = 0;
    end
    
    if (scaleY ~= nil) then
        local scaleY_t = type(scaleY);
        
        if (scaleY_t ~= "number") then
            error("bad argument #3 to '" ..__func__.. "' (number expected, got " ..scaleY_t.. ")", 2);
        end
    else
        scaleY = 0;
    end
    
    if (offsetY ~= nil) then
        local offsetY_t = type(offsetY);
        
        if (offsetY_t ~= "number") then
            error("bad argument #4 to '" ..__func__.. "' (number expected, got " ..offsetY_t.. ")", 2);
        end
    else
        offsetY = 0;
    end
    
    
    local memId = scaleX.. ":" ..offsetX.. ":" ..scaleY.. ":" ..offsetY;
    
    local proxy = MEM_PROXIES[memId];
    
    if (not proxy) then
        local obj = {
            type = name,
            
            
            x = UDim.new(scaleX, offsetX),
            y = UDim.new(scaleY, offsetY),
        }
        
        proxy = setmetatable({}, meta);
        
        MEM_PROXIES[memId] = proxy;
        
        OBJ__PROXY[obj] = proxy;
        PROXY__OBJ[proxy] = obj;
    end
    
    return proxy;
end



function func.unpack(obj)
    return obj.x.scale, obj.x.offset, obj.y.scale, obj.y.offset;
end



UDim2 = {
    name = name,
    
    func = func,
    
    meta = meta,
    
    new = new,
}


-- return setmetatable({}, {
    -- __metatable = "UDim2",
    
    
    -- __index = function(proxy, key)
        -- return (key == "new") and new or nil;
    -- end,
    
    -- __newindex = function(proxy, key)
        -- error("attempt to modify a read-only key (" ..tostring(key).. ")", 2);
    -- end,
    
    
    -- __call = function(proxy, ...)
        -- local success, result = pcall(new, ...);
        
        -- if (not success) then
            -- error("call error", 2);
        -- end
        
        -- return result;
    -- end,
-- });
