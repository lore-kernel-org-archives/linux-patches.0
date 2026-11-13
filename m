Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590071;
	b=PtJ8/lz1LhQG5jKaxCTvSkOKyBeexGQhDnbxaofB0diR2DSeJkrVlKzV3Jz7E7L8Bpeg
	 QH+v76v+/REpvr5iqCKZ5oDFUf1x5H2FzMsN2/qIJUc9V60/163IT15XVb7JpoN5W/+Xp
	 y52xX6j66B5cJY9Nl6y7vNow1cZrFXjjs4UT9LDPZnN6VRm7ZVFgWD9TyrC4z1DtXuZSf
	 9zrJbvtraDcLl0dLYz0wb+HKCQPEup6n3OkSoFieFzJYyajLbnWWvVMUFuN0qpWn1hqHG
	 H/9EWiusBn+4BeCR27kHtHMTHw3hExzZVTQGf3ugz1wGoPhxsdmvSrv44BMlqn9zywg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590071;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=LEj8MD0DXLpJ7T9pekyKjh3i7kErSb+6Tv46/jLTrEs=;
	b=ToeJQn9qwiSqpw0wP+EoJDuFFKB6fu8ugVYkjanPSs6sg0sxCCTkpwx/OWBfewLRf2/t
	 ATzgeDAc0rumBXaHnhG9R6+ox5YIWhJdldOUHeHxbzOFXuM4f8dZsaRvYlfKzp/jF7yod
	 ZRw6np0e5y/fSji80iKXo+vuXJ0MAdeDmOaYkli0wdEuVPX5T3jHN+SKY+FizMc2fw3/R
	 mQTgiMiMryifJcjI5sIdiqPlDqw0VtdnLq7pm4CvyHGrA98dthk+LrGgNEr2yjuBVlzp8
	 w8IRkyJCroY1Wm++uAqoccB5reL22lFX1s1+r/WC0JlJbQ58PAcYd1aUGkLCZagHaWw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2B8isCSy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01C1B606C08A;
	Fri, 13 Nov 2026 17:14:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2B8isCSy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 644E71F000C4;
	Fri, 13 Nov 2026 17:14:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590070;
	bh=LEj8MD0DXLpJ7T9pekyKjh3i7kErSb+6Tv46/jLTrEs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2B8isCSyqfNfhEHYPDWfE5RrQuJCFcz4jSyyi438R79YuS88AFBC6e19U0+VvbzUW
	 vsqnvfc+a3OF/JJw07Nti9aLxODWfsMBOOF2pyqI1/pPVBbSHrE+3IPBAn3gT97Sd1
	 4arEvJwIQYSZahgqZOZnYF2kxoNDULsyWjI1AI8g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Baggaley <me@drinkybird.net>,
	Ricardo Ribalda <ribalda@chromium.org>,
	Hans de Goede <johannes.goede@oss.qualcomm.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 102/686] media: uvcvideo: Add autosuspend quirk for AVerMedia Live Gamer HD 2
Date: Fri, 13 Nov 2026 10:43:55 -0500
Message-ID: <20261113153824.312715983@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ricardo Ribalda <ribalda@chromium.org>

[ Upstream commit b79251c881bb39f70c6f6fb30ad5d454b78c9f4a ]

A user has reported that this device gets stuck in a loop where every
few seconds it will turn off and turn back on, causing audio devices
to disappear and reappear, its LED to flash, spamming dmesg, etc.
This only happens when not in use; everything is fine when the video
device is actually being used.

They also reported that using the AUTOSUSPEND quirk via module parameters
fixes the issue.

Add the device to the quirk list.

ID 07ca:1570 AVerMedia Technologies, Inc. AVerMedia USB Device
Negotiated speed: High Speed (480Mbps)
Device Descriptor:
   bLength                18
   bDescriptorType         1
   bcdUSB               2.10
   bDeviceClass          239 Miscellaneous Device
   bDeviceSubClass         2 [unknown]
   bDeviceProtocol         1 Interface Association
   bMaxPacketSize0        64
   idVendor           0x07ca AVerMedia Technologies, Inc.
   idProduct          0x1570 AVerMedia USB Device
   bcdDevice            1.00
   iManufacturer           6 AVerMedia
   iProduct                7 AVerMedia USB Device
   iSerial                 3 53106326013650
   bNumConfigurations      1
   Configuration Descriptor:
     bLength                 9
     bDescriptorType         2
     wTotalLength       0x01d6
     bNumInterfaces          4
     bConfigurationValue     1
     iConfiguration          0
     bmAttributes         0xa0
       (Bus Powered)
       Remote Wakeup
     MaxPower              150mA
     Interface Association:
       bLength                 8
       bDescriptorType        11
       bFirstInterface         0
       bInterfaceCount         2
       bFunctionClass         14 Video
       bFunctionSubClass       3 Video Interface Collection
       bFunctionProtocol       0
       iFunction               8 AVerMedia Live Gamer HD 2
     Interface Descriptor:
       bLength                 9
       bDescriptorType         4
       bInterfaceNumber        0
       bAlternateSetting       0
       bNumEndpoints           0
       bInterfaceClass        14 Video
       bInterfaceSubClass      1 Video Control
       bInterfaceProtocol      0
       iInterface              8 AVerMedia Live Gamer HD 2
       VideoControl Interface Descriptor:
         bLength                13
         bDescriptorType        36
         bDescriptorSubtype      1 (HEADER)
         bcdUVC               1.00
         wTotalLength       0x004d
         dwClockFrequency      120.000000MHz
         bInCollection           1
         baInterfaceNr( 0)       1
       VideoControl Interface Descriptor:
         bLength                18
         bDescriptorType        36
         bDescriptorSubtype      2 (INPUT_TERMINAL)
         bTerminalID             1
         wTerminalType      0x0201 Camera Sensor
         bAssocTerminal          0
         iTerminal               0
         wObjectiveFocalLengthMin      0
         wObjectiveFocalLengthMax      0
         wOcularFocalLength            0
         bControlSize                  3
         bmControls           0x00000000
       VideoControl Interface Descriptor:
         bLength                11
         bDescriptorType        36
         bDescriptorSubtype      5 (PROCESSING_UNIT)
       Warning: Descriptor too short
         bUnitID                 3
         bSourceID               1
         wMaxMultiplier          0
         bControlSize            2
         bmControls     0x0000000f
           Brightness
           Contrast
           Hue
           Saturation
         iProcessing             0
         bmVideoStandards     0x09
           None
           SECAM - 625/50
       VideoControl Interface Descriptor:
         bLength                 9
         bDescriptorType        36
         bDescriptorSubtype      3 (OUTPUT_TERMINAL)
         bTerminalID             2
         wTerminalType      0x0101 USB Streaming
         bAssocTerminal          0
         bSourceID               4
         iTerminal               0
       VideoControl Interface Descriptor:
         bLength                28
         bDescriptorType        36
         bDescriptorSubtype      6 (EXTENSION_UNIT)
         bUnitID                 4
         guidExtensionCode         {c66d125b-0480-0844-8c26-b8363a84de63}
         bNumControls           17
         bNrInPins               1
         baSourceID( 0)          3
         bControlSize            3
         bmControls( 0)       0x07
         bmControls( 1)       0xfe
         bmControls( 2)       0x01
         iExtension              0
     Interface Descriptor:
       bLength                 9
       bDescriptorType         4
       bInterfaceNumber        1
       bAlternateSetting       0
       bNumEndpoints           0
       bInterfaceClass        14 Video
       bInterfaceSubClass      2 Video Streaming
       bInterfaceProtocol      0
       iInterface              8 AVerMedia Live Gamer HD 2
       VideoStreaming Interface Descriptor:
         bLength                            14
         bDescriptorType                    36
         bDescriptorSubtype                  1 (INPUT_HEADER)
         bNumFormats                         1
         wTotalLength                   0x00bd
         bEndpointAddress                 0x89  EP 9 IN
         bmInfo                              0
         bTerminalLink                       2
         bStillCaptureMethod                 0
         bTriggerSupport                     0
         bTriggerUsage                       0
         bControlSize                        1
         bmaControls( 0)                     0
       VideoStreaming Interface Descriptor:
         bLength                            11
         bDescriptorType                    36
         bDescriptorSubtype                  6 (FORMAT_MJPEG)
         bFormatIndex                        1
         bNumFrameDescriptors                5
         bFlags                              0
           Fixed-size samples: No
         bDefaultFrameIndex                  1
         bAspectRatioX                       0
         bAspectRatioY                       0
         bmInterlaceFlags                 0x00
           Interlaced stream or variable: No
           Fields per frame: 1 fields
           Field 1 first: No
           Field pattern: Field 1 only
         bCopyProtect                        0
       VideoStreaming Interface Descriptor:
         bLength                            34
         bDescriptorType                    36
         bDescriptorSubtype                  7 (FRAME_MJPEG)
         bFrameIndex                         1
         bmCapabilities                   0x00
           Still image unsupported
         wWidth                            640
         wHeight                           480
         dwMinBitRate                294617088
         dwMaxBitRate                294912000
         dwMaxVideoFrameBufferSize      614400
         dwDefaultFrameInterval         166833
         bFrameIntervalType                  2
         dwFrameInterval( 0)            166666
         dwFrameInterval( 1)            166833
       VideoStreaming Interface Descriptor:
         bLength                            34
         bDescriptorType                    36
         bDescriptorSubtype                  7 (FRAME_MJPEG)
         bFrameIndex                         2
         bmCapabilities                   0x00
           Still image unsupported
         wWidth                            720
         wHeight                           480
         dwMinBitRate                331444224
         dwMaxBitRate                331776000
         dwMaxVideoFrameBufferSize      691200
         dwDefaultFrameInterval         166833
         bFrameIntervalType                  2
         dwFrameInterval( 0)            166666
         dwFrameInterval( 1)            166833
       VideoStreaming Interface Descriptor:
         bLength                            30
         bDescriptorType                    36
         bDescriptorSubtype                  7 (FRAME_MJPEG)
         bFrameIndex                         3
         bmCapabilities                   0x00
           Still image unsupported
         wWidth                            720
         wHeight                           576
         dwMinBitRate                331776000
         dwMaxBitRate                331776000
         dwMaxVideoFrameBufferSize      829440
         dwDefaultFrameInterval         200000
         bFrameIntervalType                  1
         dwFrameInterval( 0)            200000
       VideoStreaming Interface Descriptor:
         bLength                            38
         bDescriptorType                    36
         bDescriptorSubtype                  7 (FRAME_MJPEG)
         bFrameIndex                         4
         bmCapabilities                   0x00
           Still image unsupported
         wWidth                           1280
         wHeight                           720
         dwMinBitRate                737280000
         dwMaxBitRate                884736000
         dwMaxVideoFrameBufferSize     1843200
         dwDefaultFrameInterval         166666
         bFrameIntervalType                  3
         dwFrameInterval( 0)            166666
         dwFrameInterval( 1)            166833
         dwFrameInterval( 2)            200000
       VideoStreaming Interface Descriptor:
         bLength                            46
         bDescriptorType                    36
         bDescriptorSubtype                  7 (FRAME_MJPEG)
         bFrameIndex                         5
         bmCapabilities                   0x00
           Still image unsupported
         wWidth                           1920
         wHeight                          1080
         dwMinBitRate                994332672
         dwMaxBitRate                1990656000
         dwMaxVideoFrameBufferSize     4147200
         dwDefaultFrameInterval         166666
         bFrameIntervalType                  5
         dwFrameInterval( 0)            166666
         dwFrameInterval( 1)            166833
         dwFrameInterval( 2)            200000
         dwFrameInterval( 3)            333333
         dwFrameInterval( 4)            333667
       VideoStreaming Interface Descriptor:
         bLength                             6
         bDescriptorType                    36
         bDescriptorSubtype                 13 (COLORFORMAT)
         bColorPrimaries                     1 (BT.709,sRGB)
         bTransferCharacteristics            1 (BT.709)
         bMatrixCoefficients                 4 (SMPTE 170M (BT.601))
     Interface Descriptor:
       bLength                 9
       bDescriptorType         4
       bInterfaceNumber        1
       bAlternateSetting       1
       bNumEndpoints           1
       bInterfaceClass        14 Video
       bInterfaceSubClass      2 Video Streaming
       bInterfaceProtocol      0
       iInterface              8 AVerMedia Live Gamer HD 2
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x89  EP 9 IN
         bmAttributes            5
           Transfer Type            Isochronous
           Synch Type               Asynchronous
           Usage Type               Data
         wMaxPacketSize     0x1400  3x 1024 bytes
         bInterval               1
     Interface Association:
       bLength                 8
       bDescriptorType        11
       bFirstInterface         2
       bInterfaceCount         2
       bFunctionClass          1 Audio
       bFunctionSubClass       2 Streaming
       bFunctionProtocol       0
       iFunction               9 AVerMedia Live Gamer HD 2
     Interface Descriptor:
       bLength                 9
       bDescriptorType         4
       bInterfaceNumber        2
       bAlternateSetting       0
       bNumEndpoints           0
       bInterfaceClass         1 Audio
       bInterfaceSubClass      1 Control Device
       bInterfaceProtocol      0
       iInterface              9 AVerMedia Live Gamer HD 2
       AudioControl Interface Descriptor:
         bLength                 9
         bDescriptorType        36
         bDescriptorSubtype      1 (HEADER)
         bcdADC               1.00
         wTotalLength       0x003a
         bInCollection           1
         baInterfaceNr(0)        3
       AudioControl Interface Descriptor:
         bLength                12
         bDescriptorType        36
         bDescriptorSubtype      2 (INPUT_TERMINAL)
         bTerminalID             1
         wTerminalType      0x0602 Digital Audio Interface
         bAssocTerminal          0
         bNrChannels             1
         wChannelConfig     0x0000
         iChannelNames           0
         iTerminal               0
       AudioControl Interface Descriptor:
         bLength                12
         bDescriptorType        36
         bDescriptorSubtype      2 (INPUT_TERMINAL)
         bTerminalID             5
         wTerminalType      0x0603 Line Connector
         bAssocTerminal          0
         bNrChannels             1
         wChannelConfig     0x0000
         iChannelNames           0
         iTerminal               0
       AudioControl Interface Descriptor:
         bLength                 9
         bDescriptorType        36
         bDescriptorSubtype      3 (OUTPUT_TERMINAL)
         bTerminalID             2
         wTerminalType      0x0101 USB Streaming
         bAssocTerminal          0
         bSourceID               3
         iTerminal               0
       AudioControl Interface Descriptor:
         bLength                 8
         bDescriptorType        36
         bDescriptorSubtype      6 (FEATURE_UNIT)
         bUnitID                 3
         bSourceID               4
         bControlSize            1
         bmaControls(0)       0x01
           Mute Control
         iFeature                0
       AudioControl Interface Descriptor:
         bLength                 8
         bDescriptorType        36
         bDescriptorSubtype      5 (SELECTOR_UNIT)
         bUnitID                 4
         bNrInPins               2
         baSourceID(0)           1
         baSourceID(1)           5
         iSelector               0
     Interface Descriptor:
       bLength                 9
       bDescriptorType         4
       bInterfaceNumber        3
       bAlternateSetting       0
       bNumEndpoints           0
       bInterfaceClass         1 Audio
       bInterfaceSubClass      2 Streaming
       bInterfaceProtocol      0
       iInterface              9 AVerMedia Live Gamer HD 2
     Interface Descriptor:
       bLength                 9
       bDescriptorType         4
       bInterfaceNumber        3
       bAlternateSetting       1
       bNumEndpoints           1
       bInterfaceClass         1 Audio
       bInterfaceSubClass      2 Streaming
       bInterfaceProtocol      0
       iInterface              9 AVerMedia Live Gamer HD 2
       AudioStreaming Interface Descriptor:
         bLength                 7
         bDescriptorType        36
         bDescriptorSubtype      1 (AS_GENERAL)
         bTerminalLink           2
         bDelay                  1 frames
         wFormatTag         0x0001 PCM
       AudioStreaming Interface Descriptor:
         bLength                11
         bDescriptorType        36
         bDescriptorSubtype      2 (FORMAT_TYPE)
         bFormatType             1 (FORMAT_TYPE_I)
         bNrChannels             2
         bSubframeSize           2
         bBitResolution         16
         bSamFreqType            1 Discrete
         tSamFreq[ 0]        48000
       Endpoint Descriptor:
         bLength                 9
         bDescriptorType         5
         bEndpointAddress     0x8a  EP 10 IN
         bmAttributes            5
           Transfer Type            Isochronous
           Synch Type               Asynchronous
           Usage Type               Data
         wMaxPacketSize     0x00c0  1x 192 bytes
         bInterval               4
         bRefresh                0
         bSynchAddress           0
         AudioStreaming Endpoint Descriptor:
           bLength                 7
           bDescriptorType        37
           bDescriptorSubtype      1 (EP_GENERAL)
           bmAttributes         0x01
             Sampling Frequency
           bLockDelayUnits         0 Undefined
           wLockDelay         0x0000
Binary Object Store Descriptor:
   bLength                 5
   bDescriptorType        15
   wTotalLength       0x0016
   bNumDeviceCaps          2
   USB 2.0 Extension Device Capability:
     bLength                 7
     bDescriptorType        16
     bDevCapabilityType      2
     bmAttributes   0x00000006
       BESL Link Power Management (LPM) Supported
   SuperSpeed USB Device Capability:
     bLength                10
     bDescriptorType        16
     bDevCapabilityType      3
     bmAttributes         0x00
     wSpeedsSupported   0x000e
       Device can operate at Full Speed (12Mbps)
       Device can operate at High Speed (480Mbps)
       Device can operate at SuperSpeed (5Gbps)
     bFunctionalitySupport   1
       Lowest fully-functional device speed is Full Speed (12Mbps)
     bU1DevExitLat           4 micro seconds
     bU2DevExitLat           4 micro seconds
Device Status:     0x0000
   (Bus Powered)

Reported-by: Sean Baggaley <me@drinkybird.net>
Closes: https://lore.kernel.org/linux-media/5ef59031-0853-41a7-8d11-c345fe535daf@drinkybird.net/
Signed-off-by: Ricardo Ribalda <ribalda@chromium.org>
Link: https://patch.msgid.link/20260730-uvc-avermedia-v1-1-7272dd394d83@chromium.org
Reviewed-by: Hans de Goede <johannes.goede@oss.qualcomm.com>
Signed-off-by: Hans de Goede <johannes.goede@oss.qualcomm.com>
Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/usb/uvc/uvc_driver.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/media/usb/uvc/uvc_driver.c b/drivers/media/usb/uvc/uvc_driver.c
index aa3e8d295e0f5..c15e73f419101 100644
--- a/drivers/media/usb/uvc/uvc_driver.c
+++ b/drivers/media/usb/uvc/uvc_driver.c
@@ -2847,6 +2847,15 @@ static const struct usb_device_id uvc_ids[] = {
 	  .bInterfaceSubClass	= 1,
 	  .bInterfaceProtocol	= 0,
 	  .driver_info		= (kernel_ulong_t)&uvc_quirk_fix_bandwidth },
+	/* AVerMedia Live Gamer HD 2 capture card */
+	{ .match_flags		= USB_DEVICE_ID_MATCH_DEVICE
+				| USB_DEVICE_ID_MATCH_INT_INFO,
+	  .idVendor		= 0x07ca,
+	  .idProduct		= 0x1570,
+	  .bInterfaceClass	= USB_CLASS_VIDEO,
+	  .bInterfaceSubClass	= 1,
+	  .bInterfaceProtocol	= 0,
+	  .driver_info		= UVC_INFO_QUIRK(UVC_QUIRK_DISABLE_AUTOSUSPEND) },
 	/* ViMicro Vega */
 	{ .match_flags		= USB_DEVICE_ID_MATCH_DEVICE
 				| USB_DEVICE_ID_MATCH_INT_INFO,
-- 
2.53.0



