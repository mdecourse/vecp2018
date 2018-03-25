function fun1()
    -- 多行字串可以利用兩個中括號圈起
    return [[
-- 導入 "js" 模組
local js = require "js"
-- global 就是 javascript 的 window
local global = js.global
local document = global.document
-- html 檔案中 canvas　id 設為 "canvas"
local canvas = document:getElementById("canvas")
-- 將 ctx 設為 canvas 2d 繪圖畫布變數
local ctx = canvas:getContext("2d")

-- 屬性呼叫使用 . 而方法呼叫使用 :
-- 設定填圖顏色
ctx.fillStyle = "rgb(200,0,0)"
-- 設定畫筆顏色
ctx.strokeStyle = "rgb(0,0,200)"

-- 乘上 deg 可轉為徑度單位
deg = math.pi / 180

-- 建立多邊形定點位置畫線函式
function star(radius, xc, yc, n)
    --radius = 100
    --xc = 200
    --yc = 200
    xi = xc + radius*math.cos((360/n)*deg+90*deg)
    yi = yc - radius*math.sin((360/n)*deg+90*deg)
    ctx:beginPath()
    ctx:moveTo(xi,yi)
    for i = 2, n+1 do
        x = xc + radius*math.cos((360/n)*deg*i+90*deg)
        y = yc - radius*math.sin((360/n)*deg*i+90*deg)
        ctx:lineTo(x,y)
    end
end

-- 以下利用多邊形畫線函式呼叫執行畫框線或填入顏色
-- 畫五邊形框線
star(100, 200, 200, 5)
ctx:closePath()
ctx:stroke()

-- 填三角形色塊
star(50, 350, 200, 3)
ctx:closePath()
ctx:fill()

-- 改變畫線顏色後, 畫七邊形框線
ctx.strokeStyle = "rgb(0,200,20)"
star(50, 450, 200, 7)
ctx:closePath()
ctx:stroke()
    ]]
end

function hello()
    return [[
for i = 1, 5 do
    print("hello world")
end
    ]]
end

function guess1()
    return [[
-- 導入 js 模組
js = require("js")
-- 取得 window
window = js.global
-- 猜小於或等於 n 的整數
big = 100
-- 計算猜測次數, 配合 while 至少會猜一次
num = 1
-- 利用 window:prompt 方法回應取得使用者所猜的整數
guess = window:prompt("請猜一個介於 1 到 "..big.." 的整數")
-- 利用數學模組的 random 函數以亂數產生答案
answer = math.random(big)
output = ""
-- 若沒猜對, 一直猜到對為止
while answer ~= tonumber(guess) do
    if answer > tonumber(guess) then
        output = "猜第 "..num.." 次, guess="..guess..", answer="..answer.." - too small"
        print(output)
    else
        output = "猜第 "..num.." 次, guess="..guess..", answer="..answer.." - too big"
        print(output)
    end 
    guess = window:prompt(output..", 請猜一個介於 1 到 "..big.." 的整數")
    num = num + 1
end
print("總共猜了 "..num.." 次, answer=guess="..answer.." - correct")
    ]]
end

function guess2()
    return [[
-- 利用電腦亂數玩猜數字遊戲
-- 導入 js 模組
js = require("js")
-- 取得 window
window = js.global
execnum = 100
guessnum = 0
playnum = 0
-- 猜小於或等於 n 的整數
for i = 1, execnum do
    small = 1
    big = 100
    -- 計算猜測次數, 配合 while 至少會猜一次
    num = 1
    -- 利用 window:prompt 方法回應取得使用者所猜的整數
    pcguess = math.random(small, big)
    -- guess = window:prompt("請猜一個介於 "..small.." 到 "..big.." 的整數")
    -- 利用數學模組的 random 函數以亂數產生答案
    answer = math.random(small, big)
    output = ""
    playnum = playnum + 1
    print("")
    print("------第 "..playnum.." 次執行")
    print("")
    -- 若沒猜對, 一直猜到對為止
    while answer ~= tonumber(pcguess) do
        if answer > tonumber(pcguess) then
            small = pcguess + 1
            output = "猜第 "..num.." 次, guess="..pcguess..", answer="..answer.." - too small"
            print(output)
        else
            big = pcguess - 1
            output = "猜第 "..num.." 次, guess="..pcguess..", answer="..answer.." - too big"
            print(output)
        end 
        --guess = window:prompt(output..", 請猜一個介於 "..small.." 到 "..big.." 的整數")
        pcguess = math.random(small, big)
        num = num + 1
    end
    print("總共猜了 "..num.." 次, answer=guess="..answer.." - correct")
    guessnum = guessnum + num
end
averagenum = math.floor(guessnum/execnum)
print("----------")
print("平均猜對次數: "..averagenum)
    ]]
end

function scope1()
    return [[
-- var here is global variable
var = 1
for i = 1, 3 do
-- var here is local variable in for loop
    local var = 2
    -- here print the local var value
    print(var)
end
-- here print the global var value
print(var)
    ]]
end

function function1()
    return [[
function myfun(n)
    for i = 1, n do
        print(i)
    end
end

myfun(5)
    ]]
end