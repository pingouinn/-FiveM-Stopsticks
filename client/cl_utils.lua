if cfg.ESX then
    ESX = nil

    Citizen.CreateThread(function()
        while ESX == nil do
            TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
            Citizen.Wait(0)
        end
    end)

elseif cfg.QB then
    QBdata = {}

    RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
        QBdata = exports['qb-core']:GetCoreObject().Functions.GetPlayerData()
    end)

    RegisterNetEvent('QBCore:Client:OnJobUpdate', function(JobInfo)
        QBdata.job = JobInfo
    end)
end

function jobCheck()
    if cfg.ESX then
        local ESXdata = ESX.GetPlayerData()
        if ESXdata.job ~= nil then
            if ESXdata.job.name == cfg.jobName then
                return true
            end
        end
    elseif cfg.QB then
        if QBdata.job and QBdata.job.name == cfg.jobName then
            return true
        end
    else
        return true
    end

    return false
end

-- GFX Scaleform

function hintToDisplay(text)
    SetTextComponentFormat("STRING")
    AddTextComponentString(text)
    DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

function ShowNotification(text)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(text)
    EndTextCommandThefeedPostTicker(true, false)
end

