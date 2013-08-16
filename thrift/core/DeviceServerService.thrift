/*
 * DeviceServerServices.thrift
 *
 * Copyright (C) KAI Square Pte Ltd
 *
 * This Thrift IDL defines internal communication between Arbiter and Device Server
 */

namespace java com.kaisquare.core.internal.thrift
namespace cpp com.kaisquare.core.internal.thrift

/**
 * Device Data Entry
 * Most of the fields in this API are mapped to corresponding fields in
 * Core Engine's existing database.
 *
 * (1) id - Unique identifier of this device
 * (2) name - Device Name
 * (3) key - MAC address of the device in the common notational format, e.g. 01:23:45:67:89:ab
 * (4) host - Device IP address or hostname
 * (5) port - Device port.
 * (6) login - Device login (user name). Ignore if not required.
 * (7) password - Device password. Ignore if not required.
 * (8) model - Device model (should be the unique identifier of device model)
 */
struct DeviceEntry {
    1: string id,
    2: string name,
    3: string key,
    4: string host,
    5: string port,
    6: string login,
    7: string password,
    8: string model
}

/**
 * DeviceServerService - this service provides API for management of devices
 */
service DeviceServerService {

	/**
	 * Add a new device to the Device Server. This function will be typically called
     * from an administrative user interface. Arbiter also calls this methd after loading device data
     * from database.
     *
     * Device should be added to database and device ID should be assigned by Arbiter.
     * Device Server just keeps the device ID, ignoring and returns true directly if the device ID
     * has already existed in Device Server.
     *
	 * (1) device - The device object/structure with the non-empty deviceId field. The
     *              deviceId is generated by Aribiter.
     *
     * Returns true if Device Server accept the model of device to be added in current Device Server.
	 */
	bool addDevice(1: DeviceEntry device),

	/**
	 * Update device.
     *
	 * (1) device - The device object/structure with a valid deviceId. The
     *              corresponding device gets updated, Device Server should use the updated data
     *				to connect to device.
     *
     * Returns TRUE on success, FALSE otherwise.
	 */
	bool updateDevice(1: DeviceEntry device),

	/**
	 * Delete device.
     *
	 * (1) deviceId - ID of the device to be deleted.
     *
     * Returns TRUE on success, FALSE otherwise.
	 */
	bool deleteDevice(1: string deviceId)
}

/**
 * DeviceControlService - this service provides API for interactive control of devices
 */
service DeviceControlService {

	/**
	 * Gets a device's current status.
	 *
	 * (1) deviceId - ID of the device.
	 *
	 * Returns the device's status:
	 * "online" if the device is currently connected and able to communicate with the backend (Core Engine/RMS+).
	 * "offline" if the device is not connected to the backend.
	 * "error" if the device is connected but in an error state.
	 * "incorrect-password" if the backend is able to connect to the device, but not log in due to invalid login credentials.
	 */
	string getDeviceStatus(1: string deviceId),

	/**
	 * Gets the current status of an I/O pin. This is applicable only to devices which
	 * have ON/OFF type I/O pins.
	 *
	 * (1) deviceId - ID of the device.
	 * (2) ioNumber - The digital I/O number of the device, starting with 0.
	 *
	 * Returns the result of the operation. 
	 * "on" if the pin status is ON or HIGH
	 * "off" if the pin status is OFF or LOW
	 * "error" on failure to read pin status. There could be several reasons of failure e.g. device is offline or device doesn't
	 * have the specified I/O control.
	 */
	string getGPIO(1: string deviceId, 2: string ioNumber),

	/**
	 * Sets an I/O control pin ON or OFF. This is applicable only to devices which
	 * have ON/OFF type digital I/O control pins.
	 *
	 * (1) deviceId - ID of the device.
	 * (2) ioNumber - The digital I/O number of the device, starting with 0.
	 * (3) value - The new value to set - "on" means ON/HIGH; "off" means OFF/LOW.
	 *
	 * Returns the result of the operation. 
	 * "ok" on successful completion of the operation.
	 * "error" on failure. There could be several reasons of failure e.g. device is offline or device doesn't
	 * have the specified I/O control.
	 */
	string setGPIO(1: string deviceId, 2: string ioNumber, 3: string value),

	/**
	 * Starts to pan a PTZ device in the specified direction.
	 *
	 * (1) deviceId - ID of the device.
	 * (2) channelId - channel of the device.
	 * (3) direction - The direction of panning: "left" or "right".
	 *
	 * Returns the result of the operation. 
	 * "ok" on successful completion of the operation.
	 * "error" on failure. There could be several reasons of failure e.g. device is offline or device doesn't
	 * have Pan feature.
	 */
	string startPanDevice(1: string deviceId, 2: string channelId, 3: string direction),

	/**
	 * Stops panning of a PTZ device.
	 *
	 * (1) deviceId - ID of the device.
	 * (2) channelId - channel of the device.
	 *
	 * Returns the result of the operation. 
	 * "ok" on successful completion of the operation.
	 * "error" on failure. There could be several reasons of failure e.g. device is offline or device doesn't
	 * have Pan feature.
	 */
	string stopPanDevice(1: string deviceId, 2: string channelId),

	/**
	 * Starts to tilt a PTZ device in the specified direction.
	 *
	 * (1) deviceId - ID of the device.
	 * (2) channelId - channel of the device.
	 * (3) direction - The direction of panning: "left" or "right".
	 *
	 * Returns the result of the operation. 
	 * "ok" on successful completion of the operation.
	 * "error" on failure. There could be several reasons of failure e.g. device is offline or device doesn't
	 * have Tilt feature.
	 */
	string startTiltDevice(1: string deviceId, 2: string channelId, 3: string direction),

	/**
	 * Stops tilting of a PTZ device.
	 *
	 * (1) deviceId - ID of the device.
	 * (2) channelId - channel of the device.
	 *
	 * Returns the result of the operation. 
	 * "ok" on successful completion of the operation.
	 * "error" on failure. There could be several reasons of failure e.g. device is offline or device doesn't
	 * have Tilt feature.
	 */
	string stopTiltDevice(1: string deviceId, 2: string channelId),

	/**
	 * Starts to zoom a PTZ device in the specified direction.
	 *
	 * (1) deviceId - ID of the device.
	 * (2) channelId - channel of the device.
	 * (3) direction - The direction of panning: "in" or "out".
	 *
	 * Returns the result of the operation. 
	 * "ok" on successful completion of the operation.
	 * "error" on failure. There could be several reasons of failure e.g. device is offline or device doesn't
	 * have Zoom feature.
	 */
	string startZoomDevice(1: string deviceId, 2: string channelId, 3: string direction),

	/**
	 * Stops zooming of a PTZ device.
	 *
	 * (1) deviceId - ID of the device.
	 * (2) channelId - channel of the device.
	 *
	 * Returns the result of the operation. 
	 * "ok" on successful completion of the operation.
	 * "error" on failure. There could be several reasons of failure e.g. device is offline or device doesn't
	 * have Zoom feature.
	 */
	string stopZoomDevice(1: string deviceId, 2: string channelId),

	/**
	 * Writes data to a data port of the specified device.
	 *
	 * (1) deviceId - ID of the device.
	 * (2) portNumber - The data port number.
	 * (3) data - The data to be written out.
	 *
	 * Returns the result of the operation. 
	 * "ok" on successful completion of the operation.
	 * "error" on failure. There could be several reasons of failure e.g. device is offline or device doesn't
	 * have the specified I/O control.
	 */
	string writeData(1: string deviceId, 2: string portNumber, 3: list<byte> data),

	/**
	 * Reads data from a data port of the specified device.
	 *
	 * (1) deviceId - ID of the device.
	 * (2) portNumber - The data port number.
	 *
	 * Returns the data read from the device's data port.
	 */
	list<byte> readData(1: string deviceId, 2: string portNumber),

}