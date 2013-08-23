/*
 * DeviceServerServices.thrift
 *
 * Copyright (C) KAI Square Pte Ltd
 *
 * This Thrift IDL defines internal communication between Arbiter and Stream Controller
 */

namespace java com.kaisquare.core.internal.thrift
namespace cpp com.kaisquare.core.internal.thrift

/**
 * StreamControlService - this service provides interface for
 * management (control) of a streaming sessions. Aribiter uses
 * this interface to tell stream controller how to handle specified stream
 * NOTE 1: This is only for control, not for actual video data transfer.
 * 		2: Stream Controller must handle all sessions between it and streaming server,
 		   which means Stream Controller have to keep all the current session state of streaming server,
 		   if the stream has existed in streaming server, Stream Controller can ignore adding same stream to streaming server.
 */
service StreamControlService {

    /**
     * Begin a new media session. This is a request from Platform to Core
     * Engine. On success, Core Engine should return the dynamically generated
     * URL of stream.
     *
     * (1) streamName - A unique name of the liveview stream, which means this name is also for specific device channel
     * (2) liveUri - the live stream URI, stream controller send this URI to streaming server to pull this stream
     * (3) type - the type of stream, (h264, mjpeg only)
     * (4) allowedClientIpAddresses - list of IP address from which the Core
     *      may accept connections for streaming of this URL.
     *
     * IMPORTANT:
     * Arbiter may call this method repeatly due to changing allowedClientIpAddress or 
     * Stream Controller should handle this if streaming server has already pulled the same stream
     * and just update the allowed IP address if it's changed.
     *
     * RETURN value is a public live URL generated by Stream Controller.
     * The URL must be able to be connected from allowed clients which are defined in allowedClientIpAddress,
     * client be able to see the live view from this URL.
     */
	string addLiveStream(1: string streamName,
					2: string liveUri,
		            3: string type,
		            4: list<string> allowedClientIpAddresses),

    /**
     * Record stream from specific URI
     * (1) streamName - The unique name of stream, this name will be used for playback,
     *					if the streamName is as same as the name of live stream, 
     *					Stream Controller will record the current live stream
     * (2) streamUri - The stream URI for recording, it will be ignored if streamName is as same as the name of live stream
     * (3) type - the type of stream, (h264, mjpeg only)
     *
     * RETURN true on success, false otherwise
     */
	bool recordSteam(1: string streamName,
				2: string streamUri,
				3: string type),

	/**
	 * Request a playback stream with start time and end time
	 *
	 * (1) streamName - the stream name which specified for recording
	 * (2) type - the type of stream, (h264, mjpeg only)
	 * (3) startTimestamp - The start time of playback (UTC), it's unix time, defined as the number of seconds that have elapsed since 00:00:00 
	 * 						Coordinated Universal Time (UTC), Thursday, 1 January 1970, not counting leap seconds.
	 * (4) endTimestamp - The end time of playback (UTC), it's unix time, defined as the number of seconds that have elapsed since 00:00:00 
	 * 						Coordinated Universal Time (UTC), Thursday, 1 January 1970, not counting leap seconds.
	 *
	 * RETURN list of playback URL, it can be a playlist that contains all required streams, to be played in that order. if it returns NULL
	 * or an empty of list that represent there's no available video for playback.
	 */
	list<string> addPlaybackStream(1: string streamName,
					2: string type,
					3: i64 startTimestamp,
					4: i64 endTimestamp),

    /**
     * Terminate stream with specified stream name
     * (1) streamName - the stream name to be shutdown.
     */
	bool shutdownStream(1: string streamName)
}