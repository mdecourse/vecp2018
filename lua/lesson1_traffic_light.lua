--[[ 參考: http://www.coppeliarobotics.com/helpFiles/en/childScripts.htm#nonThreaded
Non-threaded child scripts

Non-threaded child scripts are pass-through scripts. This means that every time they are called, they should perform some task and then return control. 

If control is not returned, then the whole simulation halts. 

Non-threaded child scripts operate as functions, and are called by the main script twice per simulation step:

from the main script's actuation phase, and from the main script's sensing phase. 

This type of child script should always be chosen over threaded child scripts whenever possible.

Non-threaded child scripts are executed in a cascaded way: 

child scripts are executed starting with root objects (or parentless objects), and ending with leaf objects (or childless objects). 

The command simHandleChildScripts, called from the default main script, handles the execution of non-threaded child scripts.

Imagine an example of a simulation model representing an automatic door: 

a proximity sensor in the front and the back allows detecting an approaching person.

When the person is close enough, the door opens automatically. 

Following code shows a typical non-threaded child script illustrating above example:

if (sim_call_type==sim_childscriptcall_initialization) then
    sensorHandleFront=simGetObjectHandle("DoorSensorFront")
    sensorHandleBack=simGetObjectHandle("DoorSensorBack")
    motorHandle=simGetObjectHandle("DoorMotor")
end

if (sim_call_type==sim_childscriptcall_actuation) then
    resF=simReadProximitySensor(sensorHandleFront) 
    resB=simReadProximitySensor(sensorHandleBack)
    if ((resF>0)or(resB>0)) then
        simSetJointTargetVelocity(motorHandle,-0.2)
    else
        simSetJointTargetVelocity(motorHandle,0.2)
    end
end

if (sim_call_type==sim_childscriptcall_sensing) then

end

if (sim_call_type==sim_childscriptcall_cleanup) then
    -- Put some restoration code here
end

A non-threaded child script should be segmented in 4 parts:

the initialization part: 

this part will be executed just one time (the first time the child script is called). 

This can be at the beginning of a simulation, but also in the middle of a simulation: 

remember that objects associated with child scripts can be copy/pasted into a scene at any time, also when a simulation is running. 

Usually you would put some initialization code as well as handle retrieval in this part.

the actuation part: 

this part will be executed in each simulation step, during the actuation phase of a simulation step. 

Refer to the main script default code for more details about the actuation phase, but typically, you would do some actuation in this part (no sensing).
    
the sensing part:

this part will be executed in each simulation step, during the sensing phase of a simulation step. 

Refer to the main script default code for more details about the sensing phase, but typically, you would do only do sensing in this part (no actuation).
    
the restoration part: this part will be executed one time just before a simulation ends, or before the script is destroyed.
]]

-- 非執行緒子程式段

-- 自訂 round() 函式

function round(num, numDecimalPlaces)
  local mult = 10^(numDecimalPlaces or 0)
  return math.floor(num * mult + 0.5) / mult
end

-- 自訂 sleep() 函式

local clock = os.clock
function sleep(n)  -- seconds
  local t0 = clock()
  while clock() - t0 <= n do end
end

-- 起始程式段

if (sim_call_type==sim_childscriptcall_initialization) then

    -- 透過各燈號物件名稱字串, 以 simGwtObjectHandle 取得物件 handle 位址號碼
    
    greenLightHandle = simGetObjectHandle('green') 
    yellowLightHandle =simGetObjectHandle('yellow') 
    redLightHandle =simGetObjectHandle('red') 

    -- 利用 handle 位址號碼取得各物件顏色值
    
    r,initColor1=simGetShapeColor(greenLightHandle,nil,0)
    r,initColor2=simGetShapeColor(yellowLightHandle,nil,0)
    r,initColor3=simGetShapeColor(redLightHandle,nil,0)

    -- 利用 {R, G, B} 定義各顏色值
    
    white = {1,1,1}
    black = {0,0,0}
    blue = {0,0,1}
    red = {1,0,0}
    green = {0,1,0}
    yellow = {1,1,0}
    
    -- 以 simGetSimulationTime() 取得模擬時間, 並起始一個定時變數 timer

    lastTime = simGetSimulationTime()
    timer=0

end

-- 驅動程式段

if (sim_call_type==sim_childscriptcall_actuation) then

    -- 利用 local 宣告局部變數
    -- 利用 dt 表示時間進程增量, 定時變數 timer 則根據使用者所設定的模擬時間增量遞增
    
    local currentTime = simGetSimulationTime()
    local dt = currentTime - lastTime

    sleep(1)
    -- http://www.coppeliarobotics.com/helpFiles/en/regularApi/simAddStatusbarMessage.htm
    simAddStatusbarMessage("currentTime:" .. round(currentTime, 4))
    simAddStatusbarMessage("lastTime:" .. round(lastTime, 4))
    timer = timer + dt
    
    -- 假如定時變數大於 100, 變數歸零

    if (timer > 100) then
      timer=0
    end

    -- 假如定時變數小於 50, 則顯示綠燈
    
    if (timer < 50) then
      simSetShapeColor(greenLightHandle, nil, 0, green)
      simSetShapeColor(yellowLightHandle, nil, 0, black)
      simSetShapeColor(redLightHandle, nil, 0, black)

    -- 若定時變數介於 50-60 之間, 則顯示黃燈, 其餘情況顯示紅燈
    
    elseif(timer > 50 and timer < 60) then
      simSetShapeColor(greenLightHandle, nil, 0, black)
      simSetShapeColor(yellowLightHandle, nil, 0, yellow)
      simSetShapeColor(redLightHandle, nil, 0, black)
    else
      simSetShapeColor(greenLightHandle, nil, 0, black)
      simSetShapeColor(yellowLightHandle, nil, 0, black)
      simSetShapeColor(redLightHandle, nil, 0, red)
    end
    
    -- 將 lastTime 設為 currentTime, 且在模擬停止時將各燈號回復原來顏色
    
    lastTime = currentTime

    if (simGetSimulationState()==sim_simulation_advancing_lastbeforestop) then
      simSetShapeColor(greenLightHandle,nill,0,initColor1)
      simSetShapeColor(yellowLightHandle,nill,0,initColor2)
      simSetShapeColor(redLightHandle,nill,0,initColor3)
    end

end
