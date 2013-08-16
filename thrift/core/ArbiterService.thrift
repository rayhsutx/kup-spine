/*
 * DeviceServerServices.thrift
 *
 * Copyright (C) KAI Square Pte Ltd
 *
 * This Thrift IDL defines internal communication between Arbiter and Services
 */

namespace java com.kaisquare.core.internal.thrift
namespace cpp com.kaisquare.core.internal.thrift

enum ServiceType {
	DeviceServer,
	StreamController
}

enum ServiceEventType {
	DeviceConnected,
	DeviceDisconnected,
	StreamCreated,
	StreamClosed,
	RecordingSpaceFull
}

/**
 * ArbiterService - The service provides API to let service communicate with Aribiter
 *					All of services should register to Arbiter when startup or unregister from Aribter when it's shutting down.
 *					And also provides some interfaces to let services report the status itself
 */
service ArbiterService {
	
	/**
	 *	Register service to Arbiter
	 *
	 *	(1) host - The host name or IP address of service, service must give its relative ServiceType service address
	 *	(2) port - The port of the service that binds service according to ServiceType
	 *	(3) type - The service type (defined in ServiceType enumeration)
	 *
	 *	RETURN the key of service that generated by Arbiter. using this key recognize the service. it returns NULL if failed
	 */
	string registerService(1: string host,
						2: i32 port,
						3: ServiceType type),


	/**
	 *	Unregister service from Arbiter
	 *
	 *	(1) key - The key which registered on Arbiter
	 *
	 *	RETURN true on success, false otherwise
	 */
	bool unregisterService(1: string key),

	/**
	 *	Received event from service, service notifies event or status to Aribter via this interface
	 *
	 *	(1) key - The key of service
	 *	(2) eventType - The type of event which is defined in ServiceEventType
	 *	(3) eventArgs - Service send event with arguments.
	 */
	void onServiceEvent(1: string key,
						2: ServiceEventType eventType,
						3: list<string> eventArgs)
}