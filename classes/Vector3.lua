local name = "Vector3";

local class;
local super = Object;

local func = inherit({}, super.func);
local get  = inherit({}, super.get);
local set  = inherit({}, super.set);

local new, meta;

local concrete = true;



local cache = setmetatable({}, { __mode = "v" });

function new(x, y, z)
    if (x ~= nil) then
        local x_t = type(x);
        if (x_t ~= "number") then
            error("bad argument #1 to '" ..__func__.. "' (number expected, got " ..x_t.. ")", 2);
        end
    else
        x = 0;
    end
    
    if (y ~= nil) then
        local y_t = type(y);
        if (y_t ~= "number") then
            error("bad argument #2 to '" ..__func__.. "' (number expected, got " ..y_t.. ")", 2);
        end
    else
        y = 0;
    end
    
    if (z ~= nil) then
        local z_t = type(z);
        if (z_t ~= "number") then
            error("bad argument #3 to '" ..__func__.. "' (number expected, got " ..z_t.. ")", 2);
        end
    else
        z = 0;
    end
    
    
    local cacheId = x.. ":" ..y.. ":" ..z;
    
    local obj = cache[cacheId];
    if (not obj) then
        local success;
        
        success, obj = pcall(super.new, class, meta);
        if (not success) then error(obj, 2) end
        
        obj.x = x;
        obj.y = y;
        obj.z = z;
        
        cache[cacheId] = obj;
    end
    
    return obj;
end

meta = extend({
    __metatable = name,
    
    
    __add = function(obj1, obj2)
        local obj1_t = type(obj1);
        if (obj1_t ~= "Vector3" and obj1_t ~= "number") then
            error("bad operand #1 to '+' (Vector3/number expected, got " ..obj1_t.. ")", 2);
        end
        
        local obj2_t = type(obj2);
        if (obj2_t ~= "Vector3" and obj2_t ~= "number") then
            error("bad operand #2 to '+' (Vector3/number expected, got " ..obj2_t.. ")", 2);
        end
        
        
        return (obj1_t == "number") and new(obj1+obj2.x, obj1+obj2.y, obj1+obj2.z)
        or (obj2_t == "number") and new(obj1.x+obj2, obj1.y+obj2, obj1.z+obj2)
        or new(obj1.x+obj2.x, obj1.y+obj2.y, obj1.z+obj2.z);
    end,
    
    __sub = function(obj1, obj2)
        local obj1_t = type(obj1);
        if (obj1_t ~= "Vector3" and obj1_t ~= "number") then
            error("bad operand #1 to '-' (Vector3/number expected, got " ..obj1_t.. ")", 2);
        end
        
        local obj2_t = type(obj2);
        if (obj2_t ~= "Vector3" and obj2_t ~= "number") then
            error("bad operand #2 to '-' (Vector3/number expected, got " ..obj2_t.. ")", 2);
        end
        
        
        return (obj1_t == "number") and new(obj1-obj2.x, obj1-obj2.y, obj1-obj2.z)
        or (obj2_t == "number") and new(obj1.x-obj2, obj1.y-obj2, obj1.z-obj2)
        or new(obj1.x-obj2.x, obj1.y-obj2.y, obj1.z-obj2.z);
    end,
    
    __mul = function(obj1, obj2)
        local obj1_t = type(obj1);
        if (obj1_t ~= "Vector3" and obj1_t ~= "number") then
            error("bad operand #1 to '*' (Vector3/number expected, got " ..obj1_t.. ")", 2);
        end
        
        local obj2_t = type(obj2);
        if (obj2_t ~= "Vector3" and obj2_t ~= "number") then
            error("bad operand #2 to '*' (Vector3/Matrix3x3/number expected, got " ..obj2_t.. ")", 2);
        end
        
        
        return (obj1_t == "number") and new(obj1*obj2.x, obj1*obj2.y, obj1*obj2.z)
        or (obj2_t == "Matrix3x3") and new(
            obj1.x*obj2.m00 + obj1.y*obj2.m10 + obj1.z*obj2.m20,
            obj1.x*obj2.m01 + obj1.y*obj2.m11 + obj1.z*obj2.m21,
            obj1.x*obj2.m02 + obj1.y*obj2.m12 + obj1.z*obj2.m22
        )
        or (obj2_t == "number") and new(obj1.x*obj2, obj1.y*obj2, obj1.z*obj2)
        or new(obj1.x*obj2.x, obj1.y*obj2.y, obj1.z*obj2.z);
    end,
    
    __div = function(obj1, obj2)
        local obj1_t = type(obj1);
        if (obj1_t ~= "Vector3" and obj1_t ~= "number") then
            error("bad operand #1 to '/' (Vector3/number expected, got " ..obj1_t.. ")", 2);
        end
        
        local obj2_t = type(obj2);
        if (obj2_t ~= "Vector3" and obj2_t ~= "number") then
            error("bad operand #2 to '/' (Vector3/number expected, got " ..obj2_t.. ")", 2);
        end
        
        
        return (obj1_t == "number") and new(obj1/obj2.x, obj1/obj2.y, obj1/obj2.z)
        or (obj2_t == "number") and new(obj1.x/obj2, obj1.y/obj2, obj1.z/obj2)
        or new(obj1.x/obj2.x, obj1.y/obj2.y, obj1.z/obj2.z);
    end,
    
    
    __unm = function(obj)
        return new(-obj.x, -obj.y, -obj.z);
    end,
    
    
    __tostring = function(obj)
        return obj.x.. ", " ..obj.y.. ", " ..obj.z;
    end,
}, super.meta);



function func.unpack(obj)
    return obj.x, obj.y, obj.z;
end



function get.mag(obj)
    if (not obj.mag) then
        obj.mag = math.sqrt(obj.x^2 + obj.y^2 + obj.z^2);
    end
    
    return obj.mag;
end

function get.unit(obj)
    local mag = obj.get.mag(obj);
    
    if (mag == 0) then
        error("attempt to get unit of 0 magnitude vector", 2);
    end
    
    
    if (not obj.unit) then
        obj.unit = obj/mag;
    end
    
    return obj.unit;
end


function get.vec2(obj)
    if (not obj.vec2) then
        obj.vec2 = Vector2.new(obj.x, obj.y);
    end
    
    return obj.vec2;
end



class = {
    name = name,
    func = func, get = get, set = set,
    
    new = new, meta = meta,
    
    concrete = concrete,
}

_G[name] = class;
classes[#classes+1] = class;
