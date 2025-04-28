Config = {}

--Para obter prints do servidor e cliente, desative em servidor live
Config.DevMode = true

--O comando a ser usado
Config.Command = "gunpowder"

--Quais funções têm permissão para usar o comando, ou false
Config.JobsAllowed = { "lawman", "Sheriff", "Marshal" }

--Quanto tempo o resíduo de pólvora permanecerá em um jogador em ms (padrão: 15 seg)
Config.DefaultTimeToExpire = 15000

--Armas que não deixam resíduos de pólvora (lassos, arcos, etc)
Config.WhitelistWeapons = {
    0x7A8A724A,  -- Lasso
    0x7BBD1FF6,  -- Reinforced Lasso
    0xb5fd67cd,  -- Bow
    0x791bbd2c,  -- Improved Bow
    0x169F59F7,  -- Throwables (Tomahawk, Throwing Knife) 
    0x63F46DE6,  -- Machete
    0xDBBD148E,  -- Knife
    0x1C02870C,  -- Hunting Knife
    0x23449635   -- Fists/Melee
}

--Tempos de expiração diferentes para armas específicas (em ms)
Config.WeaponExpireTimes = {
    -- Revolvers
    [0x169F59F7] = 25000,  -- Revolver
    [0x22D8FE39] = 25000,  -- Cattleman Revolver
    [0x6DFD08C4] = 25000,  -- Double-Action Revolver
    [0x7BBD1FF6] = 25000,  -- Lemat Revolver
    [0x2BE24105] = 25000,  -- Navy Revolver
    [0x8580C63E] = 25000,  -- Schofield Revolver
    
    -- Pistols
    [0x657065D6] = 22000,  -- Pistol
    [0x8D8D385E] = 22000,  -- Mauser Pistol
    [0xA84762EC] = 22000,  -- M1899 Pistol
    [0x060D6BDE] = 22000,  -- Semi-Automatic Pistol
    [0x3BCBE00C] = 22000,  -- Volcanic Pistol
    
    -- Rifles
    [0xDDF7BC1E] = 35000,  -- Rifle
    [0xA84762EC] = 35000,  -- Bolt Action Rifle
    [0x63F46DE6] = 35000,  -- Springfield Rifle
    [0xE1D2B317] = 35000,  -- Varmint Rifle
    [0x772C8DD6] = 35000,  -- Rolling Block Rifle
    [0x871C68F0] = 35000,  -- Carcano Rifle
    
    -- Shotguns
    [0x2AD544CE] = 40000,  -- Shotgun
    [0x31E15586] = 40000,  -- Double-Barrel Shotgun
    [0x6D9BB970] = 40000,  -- Pump-Action Shotgun
    [0x63F46DE6] = 40000,  -- Repeating Shotgun
    [0x28A46626] = 40000,  -- Semi-Auto Shotgun
    [0x6D46E338] = 40000,  -- Sawed-Off Shotgun
    
    -- Repeaters
    [0xD233612A] = 30000,  -- Repeater
    [0x7194721E] = 30000,  -- Carbine Repeater
    [0x32531D41] = 30000,  -- Evans Repeater
    [0x7574B20D] = 30000,  -- Henry Repeater
    [0xD421970B] = 30000,  -- Lancaster Repeater
    [0x9D13BB8B] = 30000,  -- Litchfield Repeater
    
    -- Machine Guns
    [0x7F5B2CCA] = 45000,  -- Maxim Gun
    [0xB2AD75D1] = 45000,  -- Gatling Gun
}

--Número de vezes que um jogador precisa se lavar para remover resíduos de pólvora
Config.WashesToClean = 1

--Requisitos de lavagem diferentes para armas específicas
Config.WeaponWashRequirements = {
    -- Revolvers
    [0x169F59F7] = 1,  -- Revolver
    [0x22D8FE39] = 1,  -- Cattleman Revolver
    [0x6DFD08C4] = 1,  -- Double-Action Revolver
    [0x7BBD1FF6] = 1,  -- Lemat Revolver
    [0x2BE24105] = 1,  -- Navy Revolver
    [0x8580C63E] = 1,  -- Schofield Revolver
    
    -- Pistols
    [0x657065D6] = 1,  -- Pistol
    [0x8D8D385E] = 1,  -- Mauser Pistol
    [0xA84762EC] = 1,  -- M1899 Pistol
    [0x060D6BDE] = 1,  -- Semi-Automatic Pistol
    [0x3BCBE00C] = 1,  -- Volcanic Pistol
    
    -- Rifles
    [0xDDF7BC1E] = 2,  -- Rifle
    [0xA84762EC] = 2,  -- Bolt Action Rifle
    [0x63F46DE6] = 2,  -- Springfield Rifle
    [0xE1D2B317] = 2,  -- Varmint Rifle
    [0x772C8DD6] = 2,  -- Rolling Block Rifle
    [0x871C68F0] = 2,  -- Carcano Rifle
    
    -- Shotguns
    [0x2AD544CE] = 3,  -- Shotgun
    [0x31E15586] = 3,  -- Double-Barrel Shotgun
    [0x6D9BB970] = 3,  -- Pump-Action Shotgun
    [0x63F46DE6] = 3,  -- Repeating Shotgun
    [0x28A46626] = 3,  -- Semi-Auto Shotgun
    [0x6D46E338] = 3,  -- Sawed-Off Shotgun
    
    -- Repeaters
    [0xD233612A] = 2,  -- Repeater
    [0x7194721E] = 2,  -- Carbine Repeater
    [0x32531D41] = 2,  -- Evans Repeater
    [0x7574B20D] = 2,  -- Henry Repeater
    [0xD421970B] = 2,  -- Lancaster Repeater
    [0x9D13BB8B] = 2,  -- Litchfield Repeater
    
    -- Machine Guns
    [0x7F5B2CCA] = 4,  -- Maxim Gun
    [0xB2AD75D1] = 4,  -- Gatling Gun
}
