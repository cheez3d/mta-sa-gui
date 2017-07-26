local name = "Vector3";

local func = {}
local get  = {}

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
            return (function(...) return func_f(obj, ...) end);
        end
        
        local get_f = get[key];
        if (get_f) then
            return get_f(obj, key);
        end
    end,
    
    __newindex = function(proxy, key)
        error("attempt to modify a read-only key (" ..tostring(key).. ")", 2);
    end,
    
    
    __add = function(proxy1, proxy2)
        local proxy1_t = type(proxy1);
        
        if (proxy1_t ~= "Vector3") then
            error("bad operand #1 to '__add' (Vector3 expected, got " ..proxy1_t.. ")", 2);
        end
        
        local proxy2_t = type(proxy2);
        
        if (proxy2_t ~= "Vector3") then
            error("bad operand #2 to '__add' (Vector3 expected, got " ..proxy2_t.. ")", 2);
        end
        
        
        
        local obj1 = PROXY__OBJ[proxy1];
        local obj2 = PROXY__OBJ[proxy2];
        
        return new(obj1.x + obj2.x, obj1.y + obj2.y, obj1.z + obj2.z);
    end,
    
    __sub = function(proxy1, proxy2)
        local proxy1_t = type(proxy1);
        
        if (proxy1_t ~= "Vector3") then
            error("bad operand #1 to '__sub' (Vector3 expected, got " ..proxy1_t.. ")", 2);
        end
        
        local proxy2_t = type(proxy2);
        
        if (proxy2_t ~= "Vector3") then
            error("bad operand #2 to '__sub' (Vector3 expected, got " ..proxy2_t.. ")", 2);
        end
        
        
        
        local obj1 = PROXY__OBJ[proxy1];
        local obj2 = PROXY__OBJ[proxy2];
        
        return new(obj1.x - obj2.x, obj1.y - obj2.y, obj1.z - obj2.z);
    end,
    
    __mul = function(proxy1, proxy2)
        local proxy1_t = type(proxy1);
        
        if (proxy1_t ~= "Vector3") then
            error("bad operand #1 to '__mul' (Vector3 expected, got " ..proxy1_t.. ")", 2);
        end
        
        local proxy2_t = type(proxy2);
        
        if (proxy2_t ~= "Vector3" and proxy2_t ~= "Vector2" and proxy2_t ~= "Matrix3x3") then
            error("bad operand #2 to '__mul' (Vector3/Vector2/Matrix3x3 expected, got " ..proxy2_t.. ")", 2);
        end
        
        
        
        local obj1 = PROXY__OBJ[proxy1];
        local obj2 = PROXY__OBJ[proxy2];
        
        if (proxy2_t == "Vector2") then
            return new(obj1.x*obj2.x, obj1.y*obj2.y, obj1.z);
        elseif (proxy2_t == "Matrix3x3") then
            return new(
                obj1.x*obj2.m00 + obj1.y*obj2.m10 + obj1.z*obj2.m20,
                obj1.x*obj2.m01 + obj1.y*obj2.m11 + obj1.z*obj2.m21,
                obj1.x*obj2.m02 + obj1.y*obj2.m12 + obj1.z*obj2.m22
            );
        end
        
        return new(obj1.x*obj2.x, obj1.y*obj2.y, obj1.z*obj2.z);
    end,
    
    __div = function(proxy1, proxy2)
        local proxy1_t = type(proxy1);
        
        if (proxy1_t ~= "Vector3") then
            error("bad operand #1 to '__div' (Vector3 expected, got " ..proxy1_t.. ")", 2);
        end
        
        local proxy2_t = type(proxy2);
        
        if (proxy2_t ~= "Vector3" and proxy2_t ~= "Vector2") then
            error("bad operand #2 to '__div' (Vector3/Vector2 expected, got " ..proxy2_t.. ")", 2);
        end
        
        
        
        local obj1 = PROXY__OBJ[proxy1];
        local obj2 = PROXY__OBJ[proxy2];
        
        if (proxy2_t == "Vector2") then
            return new(obj1.x/obj2.x, obj1.y/obj2.y, obj1.z);
        end
        
        return new(obj1.x/obj2.x, obj1.y/obj2.y, obj1.z/obj2.z);
    end,
    
    
    __unm = function(proxy)
        local obj = PROXY__OBJ[proxy];
        
        return new(-obj.x, -obj.y, -obj.z);
    end,
    
    
    -- __eq, -- memoization takes care of it
    
    
    __tostring = function(proxy)
        local obj = PROXY__OBJ[proxy];
        
        return obj.x.. ", " ..obj.y.. ", " ..obj.z;
    end,
}



local MEM_PROXIES = setmetatable({}, { __mode = "v" });



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
            error("bad argument #2 to '" ..__func__.. "' (number expected, got " ..z_t.. ")", 2);
        end
    else
        z = 0;
    end
    
    
    local memId = x.. ":" ..y.. ":" ..z;
    
    local proxy = MEM_PROXIES[memId];
    
    if (not proxy) then
        local obj = {
            type = name,
            
            
            x = x,
            y = y,
            z = z,
        }
        
        proxy = setmetatable({}, meta);
        
        MEM_PROXIES[memId] = proxy;
        
        OBJ__PROXY[obj] = proxy;
        PROXY__OBJ[proxy] = obj;
    end
    
    return proxy;
end



function func.unpack(obj)
    return obj.x, obj.y, obj.z;
end



function get.mag(obj)
    obj.mag = math.sqrt(obj.x^2 + obj.y^2 + obj.z^2);
    
    return obj.mag;
end

function get.unit(obj)
    local mag = obj.mag or get.mag(obj); -- check if magnitude was already computed and memoized inside obj
    
    if (mag == 0) then return end
    
    obj.unit = new(obj.x/mag, obj.y/mag, obj.z/mag);
    
    return obj.unit;
end



Vector3 = {
    name = name,
    
    func = func,
    get  = get,
    
    meta = meta,
    
    new = new,
}
