import db from '../models/index'
import { Sequelize } from 'sequelize'
let initTable = async (req, res) => {
    // console.log(db.sequelize)
    await db.sequelize.sync({
        force: true,
        logging: false
    }).then(() => {
        res.send("Success!")
    })
}

let initSeed = async (req, res) => {
    let users = [
        {
            name: "Admin",
            phone: "+84111111111",
            password: "$2a$10$P3nKAg0XDgWKu5G96hhnjuYqmVsWkkmfUT4WDVMGEgWTI9/pDggxO",
            type: "Admin",
        },
        {
            name: "Driver",
            phone: "+84222222222",
            password: "$2a$10$P3nKAg0XDgWKu5G96hhnjuYqmVsWkkmfUT4WDVMGEgWTI9/pDggxO",
            type: "Driver",
        },
        {
            name: "Driver",
            phone: "+84333333333",
            password: "$2a$10$P3nKAg0XDgWKu5G96hhnjuYqmVsWkkmfUT4WDVMGEgWTI9/pDggxO",
            type: "Driver",
        },
        {
            name: "User_vip",
            phone: "+84444444444",
            password: "$2a$10$P3nKAg0XDgWKu5G96hhnjuYqmVsWkkmfUT4WDVMGEgWTI9/pDggxO",
            type: "User_Vip",
        },
        {
            name: "User",
            phone: "+84555555555",
            password: "$2a$10$P3nKAg0XDgWKu5G96hhnjuYqmVsWkkmfUT4WDVMGEgWTI9/pDggxO",
            type: "User",
        },
    ]
    let start = {
        "lat": 10.1,
        "lng": 10.2,
        "place": "random places"
    }
    let end = {
        "lat": 10.3,
        "lng": 10.4,
        "place": "2nd random places"
    }
    let startJSON = JSON.stringify(start)
    let endJSON = JSON.stringify(end)
    let trips = [
        {
            "user_id": 4,
            "driver_id": 2,
            "status": "Cancelled",
            "start": startJSON,
            "end": endJSON,
            "is_scheduled": false,
            "price": 50000,
            "is_paid": false,
            "paymentMethod": "Cash"
        },
        {
            "user_id": 4,
            "driver_id": 2,
            "status": "Done",
            "start": startJSON,
            "end": endJSON,
            "is_scheduled": false,
            "price": 50000,
            "is_paid": false,
            "paymentMethod": "Cash"
        },
        {
            "user_id": 5,
            "driver_id": 2,
            "status": "Done",
            "start": startJSON,
            "end": endJSON,
            "is_scheduled": false,
            "price": 50000,
            "is_paid": false,
            "paymentMethod": "Cash"
        },
        {
            "user_id": 4,
            "driver_id": 3,
            "status": "Cancelled",
            "start": startJSON,
            "end": endJSON,
            "is_scheduled": false,
            "price": 50000,
            "is_paid": false,
            "paymentMethod": "Cash"
        },
        {
            "user_id": 4,
            "driver_id": 3,
            "status": "Done",
            "start": startJSON,
            "end": endJSON,
            "is_scheduled": false,
            "price": 50000,
            "is_paid": false,
            "paymentMethod": "Cash"
        },
        {
            "user_id": 5,
            "driver_id": 3,
            "status": "Done",
            "start": startJSON,
            "end": endJSON,
            "is_scheduled": false,
            "price": 50000,
            "is_paid": false,
            "paymentMethod": "Cash"
        },
    ]
    let rates = [
        {
            star: 4,
            trip_id: 1,
        },
        {
            star: 5,
            trip_id: 2,
        },
        {
            star: 2,
            trip_id: 3,
        },
        {
            star: 5,
            trip_id: 4,
        },
        {
            star: 1,
            trip_id: 5,
        },
        {
            star: 4,
            trip_id: 6,
        },
    ]

    let vehicle_types = [
        {
            name: "Xe 4 Chỗ",
        },
        {
            name: "Xe 7 Chỗ",
        },
    ]

    let vehicles = [
        {
            "driver_license": "0964155097",
            "vehicle_registration": "123456",
            "license_plate": "30D-206.32",
            "name": "Honda 4 Chỗ Vip",
            "vehicle_type_id": 1,
            "driver_id": 2,
        },
        {
            "driver_license": "0964155097",
            "vehicle_registration": "123456",
            "license_plate": "30D-206.32",
            "name": "Honda 7 Chỗ Vip",
            "vehicle_type_id": 2,
            "driver_id": 3,
        },
    ]
    users.forEach(item => {
        item.createdAt = Sequelize.literal("NOW()")
        item.updatedAt = Sequelize.literal("NOW()")
    })
    trips.forEach(item => {
        item.createdAt = Sequelize.literal("NOW()")
        item.updatedAt = Sequelize.literal("NOW()")
    })
    rates.forEach(item => {
        item.createdAt = Sequelize.literal("NOW()")
        item.updatedAt = Sequelize.literal("NOW()")
    })
    vehicles.forEach(item => {
        item.createdAt = Sequelize.literal("NOW()")
        item.updatedAt = Sequelize.literal("NOW()")
    })
    vehicle_types.forEach(item => {
        item.createdAt = Sequelize.literal("NOW()")
        item.updatedAt = Sequelize.literal("NOW()")
    })


    try {
        await db.User.bulkCreate(users).then(() => {
            console.log("seeded users")
        })
        await db.Trip.bulkCreate(trips).then(() => {
            console.log("seeded trips")
        })
        await db.Rate.bulkCreate(rates).then(() => {
            console.log("seeded rates")
        })
        await db.Vehicle_Type.bulkCreate(vehicle_types).then(() => {
            console.log("seeded vehicle types")
        })
        await db.Vehicle.bulkCreate(vehicles).then(() => {
            console.log("seeded vehicle")
        })
        res.status(200).json({
            statusCode: 200,
            message: "ok"
        })
    } catch (error) {
        res.status(500).json({
            statusCode: 500,
            error: error.message,
        })
    }
}

let GetAllCustomer = async (req, res) => {
    let customers = await db.User.findAll()
    return res.status(200).json(customers)
}

let GetAllTrips = async (req, res) => {
    let trips = await db.Trip.findAll()
    return res.status(200).json(trips)
}

let GetAllVehicles = async (req, res) => {
    let vehicles = await db.Vehicle.findAll()
    return res.status(200).json(vehicles)
}

export default {
    initTable,
    initSeed,
    GetAllCustomer,
    GetAllTrips,
    GetAllVehicles
}