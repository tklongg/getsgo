import { Server, Socket } from "socket.io"
import { DefaultEventsMap } from "socket.io/dist/typed-events"
import { io } from "../../services/initServer"
import userService from "../../services/userService"
import locationServices from "../../services/locationService"
import { DriverInBroadcast, DriverMap, TripMap, UserMap } from './storage'
import tripService from "../../services/tripService"
import driverServices from "../../services/driverServices"
import initRedis from "../../config/connectRedis"

interface Driver {
    user_id: number
    lat: number
    lng: number
    heading: number
    status: string
    vehicle_type: string
    hasResponded?: boolean
    client_id?: number
    // rating: number,
    response?: 'Accept' | 'Deny' | string
}

interface TripValue {
    trip_id: number
    user_id?: number
    driver_id?: number
    start: {
        lat: number
        lng: number
        place: string
    }
    end: {
        lat: number
        lng: number
        place: string
    }
    status?: "Pending" | "Waiting" | "Confirmed" | "Driving" | "Arrived" | "Done" | "Cancelled" | string
    price: number
    is_paid: boolean
    paymentMethod: string
    is_scheduled: boolean
    createdAt: Date
    cancellable: boolean
    finished_date?: Date
    schedule_time?: Date
}

export const handleDriverLogin = (socket: Socket<DefaultEventsMap, DefaultEventsMap, DefaultEventsMap, any>) => {
    socket.on('driver-login', (data: Driver) => {
        const user_id = data.user_id
        socket.join(`/driver/${user_id}`)
        DriverMap.getMap().set(socket.id, {
            user_id: user_id,
            lat: data.lat,
            lng: data.lng,
            status: data.status,
            heading: data.heading,
            vehicle_type: data.vehicle_type,
            // rating: data.rating,
            client_id: undefined,
        })
        console.log(data)
    })
}
const senDriver = async (trip: TripValue, driver: Driver, socket_id: any) => {
    await tripService.UpdateTrip({ trip_id: trip.trip_id, status: "Confirmed", driver_id: driver.user_id })
    let driverData = await driverServices.GetDriverInfoById(driver.user_id);
    let responseData = {
        trip_id: trip.trip_id,
        driver_info: driverData,
        lat:driver.lat,
        lng:driver.lng,
        heading:driver.heading,
        message: "coming"
    }
    // const stringifiedResponse = JSON.stringify(responseData);

    io.in(`/user/${trip.user_id}`).emit('found-driver', responseData)


    // khi driver chấp nhận thì set lại client_id cho tài xế đó
    driver.client_id = trip.user_id
    DriverMap.getMap().set(socket_id, driver)
}
export const handleDriverResponseBooking = (socket: Socket<DefaultEventsMap, DefaultEventsMap, DefaultEventsMap, any>) => {
    socket.on('driver-response-booking', async (data: { trip: TripValue, status: 'Accept' | 'Deny' }) => {
        // console.log(data)
        const driver = DriverMap.getMap().get(socket.id)
        if (driver == undefined) return
        if (data.status == "Accept") {
            const trip = TripMap.getMap().get(data.trip.trip_id)
            if (trip !== undefined && trip.driver_id === undefined) {
                trip.driver_id = driver.user_id
                trip.status = 'Confirmed'

                // const newTrip = trip
                // trip.status = 'Confirmed'
                // trip.driver_id = driver.user_id
                console.log(trip)
                TripMap.getMap().set(trip.trip_id, trip)

                senDriver(trip, driver, socket.id);
            }
            
        }
        // let driver_id = driver?.user_id
        // let trip_id = data.trip_id
        // setDriverResponseStatus(driver_id, data.status)
        // console.log(DriverMap.getMap().get(socket.id))

        //long
        // console.log(data)
        // let driver = DriverMap.getMap().get(socket.id)
        // if (driver == undefined) return
        // let driver_id = driver?.user_id
        // let trip_id = data.trip_id
        // setDriverResponseStatus(driver_id, data.status)
        // console.log(DriverMap.getMap().get(socket.id))


        // if (data.status == 'Deny' ) return 

        // driver.status = 'Driving'
        // drivers.set(socket.id,driver)
        // await tripService.UpdateTrip({trip_id:trip_id,status:"Confirmed",driver_id: driver_id})
        // let driverData = await driverServices.GetDriverInfoById(driver_id)

        // let responseData = {
        //     trip_id: trip_id,
        //     driver_info: driverData,
        //     message: "found driver"
        // }
        // let stringifiedResponse = JSON.stringify(responseData)
        // let trip = trips.get(trip_id)
        // let user_id = trip?.user_id

        // // io.to(`/trip/${trip_id}`).emit('found-driver', stringifiedResponse)
        // // socket.join(`/trip/${trip_id}`)
        // io.in(`/user/${user_id}`).emit('found-driver', stringifiedResponse)

        // let updatedTrip = trips.get(trip_id)
        // updatedTrip!.driver_id = driver_id
        // if (updatedTrip === undefined) return
        // trips.set(trip_id, updatedTrip)
        // clearInterval(current_intervals.get(trip_id))
        // current_intervals.delete(trip_id)
    })
}

export const setDriverStatus = (driver_id: number, status: string) => {
    DriverMap.getMap().forEach((driver_value, socketid) => {
        if (driver_value.user_id === driver_id) {
            driver_value.status = status
            return
        }
    })
}

export const setDriverResponseStatus = (driver_id: number, status: string) => {
    if (status == undefined) return
    DriverMap.getMap().forEach((driver_value, socketid) => {
        if (driver_value.user_id === driver_id) {
            // driver_value.hasResponded = true
            driver_value.response = status

            setTimeout(() => {
                // driver_value.hasResponded = false,
                driver_value.response = undefined
            }, 30000)
            return
        }
    })
}

export const getCurrentDriverInfoById = (id: number): { lat: number, lng: number } => {
    DriverMap.getMap().forEach((socket_value, socket_id) => {
        if (socket_value.user_id == id) {
            return {
                lat: socket_value.lat,
                lng: socket_value.lng
            }
        }
    })
    return { lat: 0, lng: 0 }
}

export const handleLocationUpdate = (socket: Socket<DefaultEventsMap, DefaultEventsMap, DefaultEventsMap, any>) => {
    socket.on('driver-location-update', (data: { lat: number, lng: number, heading: number }) => {
        let driver = DriverMap.getMap().get(socket.id)
        if (driver == undefined) return
        // let driver_id = driver?.user_id
        // let socket_ids = GetSocketByDriverId(driver_id)

        // for (let i = 0; i < socket_ids.length; i++) {
        //     let driver = DriverMap.getMap().get(socket_ids[i])
        //     if (driver == undefined) return
        //     driver!.lat = data.lat
        //     driver!.lng = data.lng
        //     driver!.heading = data.heading
        //     DriverMap.getMap().set(socket_ids[i], driver)
        // } 
        driver!.lat = data.lat
        driver!.lng = data.lng
        console.log('update location driver')
        driver!.heading = data.heading
        if (driver.client_id !== undefined) {
            io.in(`/user/${driver.client_id}`).emit('get-location-driver', data)
        }
    })
}

const GetSocketByDriverId = (driver_id: number) => {
    let socketArr: string[] = []
    DriverMap.getMap().forEach((socket_value, socket_id) => {
        if (socket_value.user_id == driver_id) {
            socketArr.push(socket_id)
        }
    })
    return socketArr
}