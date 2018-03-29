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
    print(i, ": hello world")
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

function ga_onemax()
    return [[
--
-- A simple genetic algorithm for function optimization, in lua
-- Copyright (c) 2009 Jason Brownlee
--
-- It uses a binary string representation, tournament selection, 
-- one-point crossover, and point mutations. The test problem is 
-- called one max (a string of all ones)
--

-- configuration
problemSize = 64
mutationRate = 0.005
crossoverRate = 0.98
populationSize = 64
maxGenerations = 50
selectionTournamentSize = 3
seed = os.time()

function crossover(a, b) 
	if math.random() > crossoverRate then
		return ""..a
	end
	local cut = math.random(a:len()-1)
	local s = ""
	for i=1, cut do
		s = s..a:sub(i,i)
	end
	for i=cut+1, b:len() do
		s = s..b:sub(i,i)
	end		
	return s
end

function mutation(bitstring)
	local s = ""
	for i=1, bitstring:len() do
		local c = bitstring:sub(i,i)
		if math.random() < mutationRate then		 
			if c == "0" 
			then s = s.."1"
			else s = s.."0" end
		else s = s..c end
	end
	return s
end

function selection(population, fitnesses)
	local pop = {}
	repeat
		local bestString = nil
		local bestFitness = 0
		for i=1, selectionTournamentSize do
			local selection = math.random(#fitnesses)
			if fitnesses[selection] > bestFitness then
				bestFitness = fitnesses[selection]
				bestString = population[selection]
			end
		end
		table.insert(pop, bestString)
	until #pop == #population
	return pop
end

function reproduce(selected)
	local pop = {}
	for i, p1 in ipairs(selected) do
		local p2 = nil
		if (i%2)==0 then p2=selected[i-1] else p2=selected[i+1] end
		child = crossover(p1, p2)
		mutantChild = mutation(child)
		table.insert(pop, mutantChild);
	end
	return pop
end

function fitness(bitstring)
	local cost = 0
	for i=1, bitstring:len() do
		local c = bitstring:sub(i,i)
		if(c == "1") then cost = cost + 1 end
	end
	return cost
end

function random_bitstring(length)
	local s = ""
	while s:len() < length do
		if math.random() < 0.5
		then s = s.."0"
		else s = s.."1" end
	end 
	return s
end

function getBest(currentBest, population, fitnesses) 	
	local bestScore = currentBest==nil and 0 or fitness(currentBest)
	local best = currentBest
	for i,f in ipairs(fitnesses) do
		if(f > bestScore) then
			bestScore = f
			best = population[i]
		end
	end
	return best
end

function evolve()
	local population = {}
	local bestString = nil
	-- initialize the popuation random pool
	for i=1, populationSize do
		table.insert(population, random_bitstring(problemSize))
	end
	-- optimize the population (fixed duration)
	for i=1, maxGenerations do
		-- evaluate
		fitnesses = {}
		for i,v in ipairs(population) do
			table.insert(fitnesses, fitness(v))
		end
		-- update best
		bestString = getBest(bestString, population, fitnesses)
		-- select
		tmpPop = selection(population, fitnesses)		
		-- reproduce
		population = reproduce(tmpPop)
		print(">gen", i, "best cost=", fitness(bestString), bestString, "\n")
	end	
	return bestString
end

-- run
print("Genetic Algorithm on OneMax, with ", _VERSION, "\n")
best = evolve()
print("Finished!\nBest solution found had the fitness of", fitness(best),  best, "\n")
    ]]
end