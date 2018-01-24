-- 非執行緒子程式段

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
