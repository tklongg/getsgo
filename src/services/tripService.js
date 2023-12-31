import { Op } from 'sequelize'
import db from '../models/index'
import userService from './userService'
import Sequelize from 'sequelize'
// import socketServiceTS from '../socket/socketServiceTS.js'
import { CreateUserIfNotExist } from '../services/userService'
import { SendMessageToQueue } from '../mq/createChannel'
import { broadCastToClientById, sendMessageToS2, sendMessageToS3 } from '../socket/JS/userSocket.js'
import { sendMessageFirebase } from '../firebase/firebaseApp'
import historyService from './historyService'
// import userService from './userService'
import driverServices from './driverServices'
import { TripMap, DriverMap } from '../socket/JS/storage'

const CreateTrip = async (data) => {
    return new Promise(async (resolve, reject) => {
        //location
        const lat1 = data.start.lat
        const lng1 = data.start.lng
        const place1 = data.start.place
        const lat2 = data.end.lat
        const lng2 = data.end.lng
        const place2 = data.end.place
        const now = new Date()

        //user_info
        const user_id = data.user_id
        const is_scheduled = data.is_scheduled;
        console.log('wwwwwwwwwwwwwwww')
        console.log(data.schedule_time);
        const schedule_time = is_scheduled ? data.schedule_time : now
        console.log(schedule_time);
        //Check user role here
        const carType = data.carType
        const status = "Pending"
        const paymentMethod = data.paymentMethod
        const is_paid = false
        const price = data.price
        const trip = {
            start: {
                place: place1,
                lat: lat1,
                lng: lng1
            },
            end: {
                place: place2,
                lat: lat2,
                lng: lng2
            },
            user_id: user_id,
            is_scheduled: is_scheduled,
            schedule_time: schedule_time,
            status: status,
            type: carType,
            paymentMethod: paymentMethod,
            is_paid: is_paid,
            price: price,
            is_callcenter: false,
            distance: data.distance || 0,
            duration: data.duration
        }
        // console.log(trip)
        const newTrip = await db.Trip.create(
            trip
        )
        trip.trip_id = newTrip.id
        trip.createdAt = newTrip.createdAt

        // socketServiceTS.AddToTrips(trip)
        console.log(trip)
        if (newTrip.id == null) {
            return resolve({
                statusCode: 500,
                error: new Error('error creating trip')
            })
        }
        console.log("send trip to normal trip queue")
        SendMessageToQueue("book-trip-queue", JSON.stringify(trip))
        return resolve({
            statusCode: 200,
            trip_info: trip,
        })
    })
}

const CreateTripForCallCenter = async (data) => {
    return new Promise(async (resolve, reject) => {
        // let lat1 = data.start.lat
        // let lng1 = data.start.lng
        const place1 = data.start
        // let lat2 = data.end.lat
        // let lng2 = data.end.lng
        // const place2 = data.end
        const now = new Date()
        const phone = data.phone

        const is_scheduled = data.is_scheduled
        const schedule_time = is_scheduled ? data.schedule_time : now;
        const status = "Pending"
        const paymentMethod = data.paymentMethod
        const is_paid = false
        const price = data.price

        const user = await userService.CreateUserIfNotExist(phone);
        const user_id = user.id;

        console.log(user_id)

        let trip = {
            start: {
                place: place1
            },
            user_id: user_id,
            is_scheduled: is_scheduled,
            schedule_time: schedule_time,
            status: "Callcenter",
            paymentMethod: paymentMethod,
            is_paid: is_paid,
            price: price,
        }
        // console.log(trip)
        const newTrip = await db.Trip.create(
            trip
        )
        trip.trip_id = newTrip.id
        console.log(trip)
        if (newTrip.id == null) {
            return resolve({
                statusCode: 500,
                error: new Error('error creating trip')
            })
        }
        return resolve({
            statusCode: 200,
            trip_info: trip,
        })
    })
}

const getAppointmentTrip2 = async () => {
    return new Promise(async (resolve, reject) => {
        const trips = await db.Trip.findAll(
            {
                where: {
                    is_scheduled: true,
                    driver_id: null
                    // status:
                    //     { [Op.eq]: "Waiting" }
                },
                include: {
                    model: db.User,
                    as: 'user',
                    attributes: ['name', 'phone', 'avatar']
                },
                order: [
                    ['createdAt', 'DESC'],
                ]
            }
        )
        for (const trip of trips) {
            trip.start = JSON.parse(trip.start)
            trip.end = JSON.parse(trip.end)
            // trip.schedule_time = new Date(trip.schedule_time)
        }
        return resolve({
            statusCode: 200,
            trips: trips
        })
        // let trips = await db.sequelize.query("SELECT DISTINCT * FROM trips join users on users.id = trips.user_id")
        // resolve({ trips })
    })
}

let GetTripById = async (trip_id) => {
    const trips = await db.Trip.findOne(
        {
            where: { id: trip_id },
            include: [
                {
                    model: db.User,
                    as: 'user',
                    attributes: ['name', 'phone', 'avatar']
                },
                {
                    model: db.User,
                    as: 'driver',
                    attributes: ['name', 'phone', 'avatar']
                }
            ]
        },


    )
    if (trips == null) throw new Error("Couldn't find trip")
    trips.start = JSON.parse(trips.start)
    trips.end = JSON.parse(trips.end)
    return trips
}

const AcceptTrip = async (data) => {
    try {

        const trip = await GetTripById(data.trip_id)
        // let driver_id = data.driver_id
        // if (trip.trips.id == null) throw new Error("Couldn't find trip")
        if (trip.status == "Cancelled") throw new Error("Trip has been cancelled")
        else if (trip.status == "Confirmed") {
            throw new Error("Trip has been confirmed by other driver")
        }
    } catch (error) {
        throw error
    }
    const result = await db.Trip.update(
        { status: 'Confirmed', driver_id: data.driver_id },
        {
            where: {
                id: data.trip_id,
            }
        }
    )
    console.log(result);
    if (result != 1) {
        throw new Error("Something went wrong")
    }
    // for (const [socket_id, driver_value] of DriverMap.getMap()) {
    //     if (driver_value.user_id === data.driver_id) {
    //         driver_value.status = "Driving"
    //         break
    //     }
    // }
    const newTrip = await GetTripById(data.trip_id)
    const driverInfo = await driverServices.GetDriverInfoById(data.driver_id)
    const returnDat = {
        trip_id: newTrip.trip_id,
        driverInfo,
    }
    broadCastToClientById(newTrip.user_id, "found-driver-schedule", returnDat)
    const userInfo = await userService.GetUserById(newTrip.user_id)

    sendMessageFirebase(userInfo.token_fcm, 'Chuyến đi hẹn giờ', "Đã có tài xế chấp nhận")
    return newTrip
}

const CancelTrip = async (trip_id) => {
    try {
        let trip = await GetTripById(trip_id)
        // if (trip.id == null) throw new Error("Couldn't find trip")
        let now = new Date().getTime()
        let createdAt = new Date(trip.createdAt)
        if (now - createdAt.getTime() > 300000) {
            throw new Error("Overtime due")
        }
        // if (trip.status != "Waiting") throw new Error("Trip is not waiting")
    } catch (error) {
        throw error
    }
    let result = await db.Trip.update(
        { status: 'Cancelled' },
        {
            where: {
                id: trip_id,
            }
        }
    )
    if (result != 1) {
        throw new Error("Something went wrong")
    }
    let newTrip = await GetTripById(trip_id)
    return newTrip
}

export const UpdateTrip = async (data) => {
    let updateObj = {}
    const tripDat = TripMap.getMap().get(data.trip_id)
    if (data.driver_id != null) {
        updateObj.driver_id = data.driver_id
    }
    if (data.status != "Cancelled" && data.status != null) {
        updateObj.status = data.status
    }
    if (data.finished_date != null) {
        updateObj.finished_date = data.finished_date
    }
    if (data.end != null) {
        updateObj.end = data.end
        tripDat.end = data.end
    }
    if (data.price != null) {
        updateObj.price = data.price
        tripDat.price = data.price
    }
    if (data.distance != null) {
        updateObj.distance = data.distance
        tripDat.distance = data.distance
    }
    if (data.duration != null) {
        updateObj.duration = data.duration
        tripDat.duration = data.duration
    }

    // console.log(updateObj)
    // console.log(data.trip_id)
    try {
        const res = await db.Trip.update(updateObj, {
            where: { id: data.trip_id }
        })
        console.log(res)
        if (res != 1) {
            throw new Error("Something went wrong")
        }
        // return {
        //     "message": "success",
        // }
        let newTrip = await GetTripById(data.trip_id)
        if (newTrip.is_scheduled) {
            console.log('tripservice is_schedule')
            TripMap.getMap().set(data.trip_id, tripDat)
        }
        return newTrip
    } catch (error) {
        throw error
    }
}

export const DeleteTrip = async (trip_id) => {
    try {
        await db.Trip.destroy({
            where: { id: trip_id }
        })
    } catch (error) {
        throw error
    }

}

export const initTripForCallcenter = async (data) => {
    const phone = data.phone
    const user = await CreateUserIfNotExist(phone)
    console.log("cout<<userid")
    console.log(user.id)
    const start = {
        place: data.start.place,
        lat: data.start.lat,
        lng: data.start.lng
    }
    const status = "Pending"
    const carType = data.carType
    const user_id = user.id
    const trip = {
        phone,
        start,
        user_id: user_id,
        type: carType,
        status
    }
    let newTrip = await db.Trip.create(trip)
    console.log(newTrip)
    trip.trip_id = newTrip.id

    console.log("send trip to callcenter trip queue")
    SendMessageToQueue("callcenter-trip-queue", JSON.stringify(trip))
    return trip

}

export const initTripCallCenterS1 = async (data) => {
    const phone = data.phone
    const user = await CreateUserIfNotExist(phone)
    console.log("cout<<userid")
    console.log(user.id)
    const now = new Date()
    const is_scheduled = data.is_scheduled
    const schedule_time = is_scheduled ? data.schedule_time : now;
    const lat = data.start.lat
    const lng = data.start.lng
    const start = {
        place: data.start.place,
        lat: lat,
        lng: lng
    }
    let status = "Callcenter"
    if (lat !== undefined && lng !== undefined) {
        console.log('Pending')
        status = "Pending"
    } else {
        console.log('Callcenter')
        status = "Callcenter"
    }
    const carType = data.carType
    const user_id = user.id
    const trip = {
        phone,
        start,
        user_id: user_id,
        type: carType,
        status,
        is_callcenter: true,
        is_scheduled: is_scheduled == 0 ? false : true,
        schedule_time: schedule_time
    }
    console.log(trip)
    console.log('newTrip1')
    let newTrip = await db.Trip.create(trip)
    console.log('newTrip')
    console.log(newTrip)
    trip.trip_id = newTrip.id

    // console.log("send trip to callcenter trip queue")
    if (lat !== undefined && lng !== undefined) {
        const result = await db.Trip.findOne({
            where: {
                id: newTrip.id
            },
            include: [
                {
                    model: db.User,
                    as: 'user',
                    attributes: ['name', 'phone', 'avatar'],
                    required: true,
                },
                {
                    model: db.User,
                    as: 'driver',
                    attributes: ['id', 'phone', 'email', 'avatar'],
                    include: [
                        {
                            model: db.Vehicle,
                            as: "driver_vehicle",
                            required: true,
                            attributes: {
                                exclude: ['createdAt', 'updatedAt', "driver_id", "vehicle_type_id"],
                            },
                            include: [
                                {
                                    model: db.Vehicle_Type,
                                    as: "vehicle_type",
                                    attributes: {
                                        exclude: ['createdAt', 'updatedAt', 'id'],
                                    },
                                }
                            ]
                        },
                    ],
                }
            ],
            attributes: {
                include: [[db.Sequelize.json('start.place'), 'startAddress'], [db.Sequelize.json('end.place'), 'endAddress']],
                exclude: ['createdAt', 'updatedAt', 'accessToken', "start", "end", "driver"]
            },
            raw: true,
            nest: true,
        })
        const a = await historyService.GetHistoryOfDriver(result.driver_id);
        console.log("cout<<data s1");
        // console.log(a);
        result.driver_stats = historyService.GetDriverStatics(a);
        console.log(trip)
        SendMessageToQueue("callcenter-trip-queue", JSON.stringify(trip))
        sendMessageToS3(result)
    }
    else {
        const trip2 = {
            id: trip.trip_id,
            user_phone: phone,
            startAddress: start.place,
            type: carType,
            trip_id: trip.trip_id,
            status: status,
            is_scheduled: is_scheduled == 0 ? false : true,
            schedule_time: schedule_time,
            is_callcenter: true
        }
        console.log("thằng s2 định vị nè ", trip2)
        sendMessageToS2(trip2)
    }
    console.log('heeelllllllllll')
    return trip
}

export const initTripCallCenterS2 = async (data) => {
    const trip_id = data.trip_id
    // const user_id = data.user_id
    // const user = await CreateUserIfNotExist(phone)
    console.log("cout<<userid")
    const start = {
        place: data.start.place,
        lat: data.start.lat,
        lng: data.start.lng
    }
    const status = "Pending"

    const updateObj = {
        start,
        status
    }
    await db.Trip.update(updateObj, {
        where: { id: trip_id }
    })
    ///
    const result = await db.Trip.findOne({
        where: {
            id: trip_id
        },
        include: [
            {
                model: db.User,
                as: 'user',
                attributes: ['name', 'phone', 'avatar'],
                required: true,
            },
            {
                model: db.User,
                as: 'driver',
                attributes: ['id', 'phone', 'email', 'avatar'],
                include: [
                    {
                        model: db.Vehicle,
                        as: "driver_vehicle",
                        required: true,
                        attributes: {
                            exclude: ['createdAt', 'updatedAt', "driver_id", "vehicle_type_id"],
                        },
                        include: [
                            {
                                model: db.Vehicle_Type,
                                as: "vehicle_type",
                                attributes: {
                                    exclude: ['createdAt', 'updatedAt', 'id'],
                                },
                            }
                        ]
                    },
                ],
            }
        ],
        attributes: {
            include: [[db.Sequelize.json('start.place'), 'startAddress'], [db.Sequelize.json('end.place'), 'endAddress']],
            exclude: ['createdAt', 'updatedAt', 'accessToken', "start", "end", "driver"]
        },
        raw: true,
        nest: true,
    })

    console.log("cout<<data");

    const a = await historyService.GetHistoryOfDriver(result.driver_id);
    console.log("cout<<data");
    console.log(a);
    result.driver_stats = historyService.GetDriverStatics(a);

    ///
    console.log(result)
    const newTrip = {
        id: result.id,
        trip_id: result.id,
        phone: result.user.phone,
        start: start,
        user_id: result.user_id,
        type: result.type,
        status: result.status,
        is_scheduled: result.is_scheduled == 0 ? false : true,
        schedule_time: result.schedule_time,
        is_callcenter: true
    }
    result.trip_id = result.id
    sendMessageToS3(result)
    console.log("send trip to callcenter trip queue")
    SendMessageToQueue("callcenter-trip-queue", JSON.stringify(newTrip))
    return result
}

export const GetAppointmentTrip = async () => {
    const trips = await db.Trip.findAll({
        where: {
            is_scheduled: true,
            driver_id: null,
            schedule_time: {
                [Op.gt]: Sequelize.literal('NOW()')
            },
        },
        include: {
            model: db.User,
            as: 'user',
            attributes: ['name', 'phone', 'avatar'],
            required: true,
        },
        order: [
            ['schedule_time', 'ASC'],
        ]
    }
    )
    if (trips) {
        for (const trip of trips) {
            trip.start = JSON.parse(trip.start)
            trip.end = JSON.parse(trip.end)
            trip.is_scheduled = trip.is_scheduled == 0 ? false : true
            trip.is_callcenter = trip.is_callcenter == 0 ? false : true
            // trip.schedule_time = new Date(trip.schedule_time).toLocaleString()
        }
        return trips;
    }
    return []
}

export const GetTripS2 = async () => {
    const result = await db.Trip.findAll({
        where: {
            status: "Callcenter",
            // is_callcenter: true,
        },
        include: {
            model: db.User,
            as: 'user',
            attributes: ['name', 'phone', 'avatar'],
            required: true,
        },
        attributes: ["id", "type", 'createdAt', [db.Sequelize.col('user.phone'), 'user_phone'], [db.Sequelize.json('start.place'), 'startAddress'],],
        order: [
            ['createdAt', 'DESC'],
        ],
        raw: true,
        nest: true,
    }
    )
    if (result) {
        return result
    }
    return []
    //phone,place,carType,trip_id
}

export const GetTripS3 = async () => {
    const today = new Date()
    today.setHours(0, 0, 0, 0)
    const tmr = new Date(today)
    tmr.setDate(tmr.getDate() + 1);

    const result = await db.Trip.findAll({
        where: {
            status: {
                [Op.ne]: "Callcenter"
            },
            // createdAt: {
            //     [Op.between]: [today, tmr]
            // },
            is_callcenter: true
        },
        include: [
            {
                model: db.User,
                as: 'user',
                attributes: ['name', 'phone', 'avatar'],
                required: true,
            },
            {
                model: db.User,
                as: 'driver',
                attributes: ['id', 'phone', 'email', 'avatar'],
                include: [
                    {
                        model: db.Vehicle,
                        as: "driver_vehicle",
                        required: true,
                        attributes: {
                            exclude: ['createdAt', 'updatedAt', "driver_id", "vehicle_type_id"],
                        },
                        include: [
                            {
                                model: db.Vehicle_Type,
                                as: "vehicle_type",
                                attributes: {
                                    exclude: ['createdAt', 'updatedAt', 'id'],
                                },
                            }
                        ]
                    },
                ],
            }
        ],
        attributes: {
            include: [[db.Sequelize.json('start.place'), 'startAddress'], [db.Sequelize.json('end.place'), 'endAddress']],
            exclude: ['createdAt', 'updatedAt', 'accessToken', "start", "end", "driver"]
        },
        order: [
            ['createdAt', 'DESC'],
        ],
        raw: true,
        nest: true,
    })
    if (result) {
        // console.log(result)
        for (const item of result) {
            const data = await historyService.GetHistoryOfDriver(item.driver_id);
            item["driver_stats"] = historyService.GetDriverStatics(data);
        }
        return result
    }
    return []
}
export const GetAcceptedScheduledTrip = async (driver_id) => {
    const trips = await db.Trip.findAll({
        where: {
            is_scheduled: true,
            driver_id: driver_id,
            [Op.and]: [
                {
                    status: {
                        [Op.ne]: "Done"
                    },
                },
                {
                    status: {
                        [Op.ne]: "Cancelled"
                    },
                },
                {
                    schedule_time: {
                        [Op.gt]: Sequelize.literal('NOW()')
                    },
                }

            ]

        },
        include: [
            {
                model: db.User,
                as: 'user',
                attributes: ['name', 'phone', 'avatar'],
                required: true,
            },
        ],
        order: [
            ['schedule_time', 'ASC'],
        ],
        nest: true,
        raw: true
    })
    if (trips) {
        for (const trip of trips) {
            trip.start = JSON.parse(trip.start)
            trip.end = JSON.parse(trip.end)
            trip.is_scheduled = trip.is_scheduled == 0 ? false : true
            trip.is_callcenter = trip.is_callcenter == 0 ? false : true

            // trip.schedule_time = new Date(trip.schedule_time).toLocaleString()
        }
        return trips;
    }
    return []
    git
}
export const CreateRating = async (trip_id, star) => {
    await db.Rate.create({
        trip_id: trip_id,
        star: star,

    })
}

export const GetRunningTripOfUser = async (user_id) => {
    const trip = await db.Trip.findAll({
        where: {
            user_id: user_id,
            is_scheduled: true,
            [Op.and]: [
                {
                    status: {
                        [Op.ne]: "Done"
                    },
                },
                {
                    status: {
                        [Op.ne]: "Cancelled"
                    },
                },
                {
                    schedule_time: {
                        [Op.gt]: Sequelize.literal('NOW()')
                    },
                },
            ]
        },
        include: [
            {
                model: db.User,
                as: 'user',
                attributes: ['name', 'phone', 'avatar'],
                required: true,
            },
            // {
            //     model: db.User,
            //     as: 'driver',
            //     attributes: ['id', 'name', 'phone', 'email', 'avatar'],
            //     include: [
            //         {
            //             model: db.Vehicle,
            //             as: "driver_vehicle",
            //             required: true,
            //             attributes: {
            //                 exclude: ['createdAt', 'updatedAt', "driver_id", "vehicle_type_id"],
            //             },
            //             include: [
            //                 {
            //                     model: db.Vehicle_Type,
            //                     as: "vehicle_type",
            //                     attributes: {
            //                         exclude: ['createdAt', 'updatedAt', 'id'],
            //                     },
            //                 }
            //             ]
            //         },
            //     ],
            // },
        ],
        order: [
            ['schedule_time', 'ASC'],
        ],
    })

    if (trip) {
        for (const t of trip) {
            t.start = JSON.parse(t.start)
            t.end = JSON.parse(t.end)
            t.is_scheduled = t.is_scheduled == 0 ? false : true
            t.is_callcenter = t.is_callcenter == 0 ? false : true
            if (t.driver_id) {
                const driverDat = await driverServices.GetDriverInfoById(t.driver_id)
                // driverDat['location'] = location
                t["driver_info"] = driverDat
            }
            else t["driver_info"] = null
            // t.schedule_time = new Date(t.schedule_time).toLocaleString()
        }
        return trip
    }
    return null
}
export const GetRunningTripOfDriver = async (driver_id) => {
    const trip = await db.Trip.findAll({
        where: {
            driver_id: driver_id,
            [Op.and]: [
                {
                    status: {
                        [Op.ne]: "Done"
                    },
                },
                {
                    status: {
                        [Op.ne]: "Cancelled"
                    },
                },
            ]
        },
        include: [
            {
                model: db.User,
                as: 'user',
                attributes: ['name', 'phone', 'avatar'],
                required: true,
            },
        ],
        order: [
            ['schedule_time', 'ASC'],
        ],
    })
    if (trip) return trip
    return null
}
export default {
    CreateTrip,
    CreateTripForCallCenter,
    GetTripById,
    AcceptTrip,
    CancelTrip,
    CreateRating,
    UpdateTrip,
    DeleteTrip,
    GetTripS2,
    GetTripS3,
    GetAppointmentTrip,
    GetAcceptedScheduledTrip,
    GetRunningTripOfUser,
    GetRunningTripOfDriver
}