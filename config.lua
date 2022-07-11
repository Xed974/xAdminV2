Admin, Required, TP = {}, {}, {}

NameEventGiveCarKeys = 'esx_vehiclelock:registerkey'

Admin.Acces = {
    General =  {"mod", "admin", "superadmin", "_dev", "owner"},
    Noclip = {"admin", "superadmin", "_dev", "owner"},
    TPM = {"admin", "superadmin", "_dev", "owner"},
    ChatStaff = {"mod", "admin", "superadmin", "_dev", "owner"},
    GiveCar = {"owner"}
}

Required = {
    NoClip = false, -- true / false (true il faut le staff mode pour no clip | false il ne faut pas le staff mode pour noclip)
    TPM = true -- true / false (true il faut le staff mode pour tp marqueur | false il ne faut pas le staff mode pour tp marqueur)
}

TP = {
    Toit = vector3(-75.37, -818.83, 326.17),
    PC = vector3(216.47, -810.10, 30.71),
    Hopital = vector3(294.94, -570.19, 43.13),
    PDP = vector3(418.51, -986.29, 29.39),
    Vetement = vector3(80.83, -1394.05, 29.37),
    SandyShores = vector3(1724.91, 3710.38, 34.26),
    Paleto = vector3(123.37, 6627.40, 31.92),
    Epicerie = vector3(1137.91, -983.37, 46.41)
}

--- Xed#1188