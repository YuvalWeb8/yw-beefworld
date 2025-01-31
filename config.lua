Config = {}

Config.Notification = 'qbcore' -- qbcore / codem-notification
Config.ClearInventory = true -- Clear inventory when changing lobby


Config.OnlyGangs = true
Config.GangScript = "core-gangs" -- core-gangs / qb-core gangs

-- Buckets
Config.BeefWorldBucket = 7668
Config.DefaultBucket = 0


-- Coords
Config.BeefWorldSpawn = vector3(240.10, -1379.87, 33.74)
Config.DefaultWorldSpawn = vector3(240.10, -1379.87, 33.74)
Config.Heading = 140.27


-- Target + NPC
Config.FadeIn = true 
Config.DistanceSpawn = 100.0 


Config.Target = true
Config.TargetZone = vector3(220.93, -1391.89, 30.59)
Config.PedList = {
    {
        coords = vector4(220.93, -1391.89, 30.59, 318.55),
        model = `chamber` 
    }
}