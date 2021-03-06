-------------------------------------------------------------------
----***************************************************************
----Dimension Action Functions
----Created at: 03/01/2021
----Author: Jayson.Ye/Roy.Fang @Microtest
----***************************************************************
-------------------------------------------------------------------

local System = {}
local Log = require("Matchbox/logging")
local comFunc = require("Matchbox/CommonFunc")
local Record = require("Matchbox/record")


--[[---------------------------------------------------------------------------------
-- Unique Function ID : Microtest_000049_1.0
-- System.getByteLen( paraTab )
-- Function to get the Byte len with the Input value and create the Parametric Record.
-- Created By : Jayson Ye
-- Initial Creation Date : 15/06/2021
-- Modified By : N/A
-- Modification Date : N/A
-- Current_Version : 1.0
-- Changes from Previous version : Initial Version
-- Vendor_Name : Microtest
-- Primary Usage : DFU
-- Input Arguments : param table
-- Output Arguments : N/A
-----------------------------------------------------------------------------------]]

function System.getByteLen( paraTab )
    local ret = paraTab.Input
    if ret == nil then
        Record.createBinaryRecord(false, paraTab.Technology, paraTab.TestName, paraTab.AdditionalParameters.subsubtestname)
        return false
    end
    ret = string.gsub( ret, '0x', '')
    ret = string.gsub( ret, ' ', '')
    Log.LogInfo("Byte: " .. ret .. '\n')
    if #ret %2 == 0 then
        local limitTab = paraTab.limit
        local limit = limitTab[paraTab.AdditionalParameters.subsubtestname]
        Record.createParametricRecord(tonumber(#ret /2), paraTab.Technology, paraTab.TestName, paraTab.AdditionalParameters.subsubtestname,limit)
    else
        Record.createBinaryRecord(false, paraTab.Technology, paraTab.TestName, paraTab.AdditionalParameters.subsubtestname)
    end
end

return System