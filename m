Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212934;
	b=sqUQtxZjl5BOrDlibkNUwY6bOwvlGeTrwGx1EbAC3FRTgZSRBKE9MBZSVFCVhEtRp5BW
	 ZP7aX8C2+QSzVKJ7zDIeBnptUgS7JI7m/OD5tVBc3kHc5rQISAyHPBRUCHArpBGLRkEu3
	 QjHOBQfHegAoYWWwcY020XnydB9NxgkEibU1icysNdwAFgVcISsN24vXnyMI1N7aEfRtt
	 mzAaXXnExhRTViYymlWWnUSnX2kzmZD37j5nQuHkDjojyKv+qBdJmIzxFLamFLmkiUttE
	 Ti8wOMBO1+y2tQ/QKlMNKOAz/69dYHKvEBcGpfQIMDouVqWRjFl2TmK6G0IEdZQXqPw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212934;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=gtybiu8Uqsm24Uo60pWuW8NJP44Ec1ih6nZMJedcEVM=;
	b=kLh4wqTqmMrnYcnVAZbo9eQWA94ZuBWAXhqeJas8eAhs1eiNuMq/beerB8pid6x4raKO
	 wg7o5kV+nhhMe/XHnpf4UX+1m7JSNSXRFVfF82ri0MOT7/xby2s0ab1PH/XJPnmWQcGS4
	 Y+bsquAnpYn+MWOpsiEX/9EcHtA5PEF0ILqFH3UfX3jCzIBPrIf9CerqOqfmXmcLhM6oH
	 VbNy7Y4WXwuOBKYVE34mRTQRCFdTORanLnpozRceFNFZz0nGr8y1OVofbOTz/ZEt6+oxB
	 H6jKHMUHJARvDJ3V8k+gidxXgoNcRp5h9JNNWzzCELybZ54Mu1yNThujfF86WMbgEfA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pGIi5ZEB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B58E606A31A;
	Wed, 28 Oct 2026 18:42:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pGIi5ZEB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 375031F01825;
	Wed, 28 Oct 2026 18:42:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212933;
	bh=gtybiu8Uqsm24Uo60pWuW8NJP44Ec1ih6nZMJedcEVM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pGIi5ZEB2vCMYkAidgk+sFPBHYofBWW5+3EmWbF4z7kiAdGxsrUz00n4I3GhhBzyz
	 pN4SWbBBLB1mC5pvH0TI6wLYwcR3Otl3zN7aNesCkHK9QNaXjOjkt2wx2vrKOeLwm9
	 IVgD1CCW/mz/0Cqzuxs1Pt3MGM/xf5bHvu88qB1o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sebastian Sjoholm <sebastian.sjoholm@gmail.com>,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 6.1 0327/1887] USB: serial: option: add Quectel RG660QB
Date: Wed, 28 Oct 2026 17:40:23 +0100
Message-ID: <20261028170506.673367586@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sebastian Sjoholm <sebastian.sjoholm@gmail.com>

commit 6177bcd94be83f80a032c2e69a06606d325335b9 upstream.

Add support for the Quectel RG660QB 5G module (USB ID 2c7c:013d).
The interface layout is the same as the RG650V:

  If 0: DIAG   ff/ff/30, 2 endpoints
  If 1: NMEA   ff/00/00, 2 endpoints
  If 2: AT     ff/00/00, 3 endpoints
  If 3: Modem  ff/00/00, 3 endpoints
  If 4: QMI    ff/ff/ff, 3 endpoints

Match the serial interfaces on class/subclass/protocol so that the QMI
interface is left to qmi_wwan.

  # lsusb -v -d 2c7c:013d

  Bus 004 Device 002: ID 2c7c:013d Quectel Wireless Solutions Co., Ltd. RG660QB-EU
  Device Descriptor:
    bLength                18
    bDescriptorType         1
    bcdUSB               3.20
    bDeviceClass            0
    bDeviceSubClass         0
    bDeviceProtocol         0
    bMaxPacketSize0         9
    idVendor           0x2c7c Quectel Wireless Solutions Co., Ltd.
    idProduct          0x013d
    bcdDevice            6.06
    iManufacturer           1 Quectel
    iProduct                2 RG660QB-EU
    iSerial                 3 f50119d0
    bNumConfigurations      1
    Configuration Descriptor:
      bLength                 9
      bDescriptorType         2
      wTotalLength       0x0105
      bNumInterfaces          5
      bConfigurationValue     1
      iConfiguration          4 DIAG_SER_RMNET
      bmAttributes         0xa0
        (Bus Powered)
        Remote Wakeup
      MaxPower              896mA
      Interface Descriptor:
        bLength                 9
        bDescriptorType         4
        bInterfaceNumber        0
        bAlternateSetting       0
        bNumEndpoints           2
        bInterfaceClass       255 Vendor Specific Class
        bInterfaceSubClass    255 Vendor Specific Subclass
        bInterfaceProtocol     48
        iInterface              0
        Endpoint Descriptor:
          bLength                 7
          bDescriptorType         5
          bEndpointAddress     0x01  EP 1 OUT
          bmAttributes            2
            Transfer Type            Bulk
            Synch Type               None
            Usage Type               Data
          wMaxPacketSize     0x0400  1x 1024 bytes
          bInterval               0
          bMaxBurst               0
        Endpoint Descriptor:
          bLength                 7
          bDescriptorType         5
          bEndpointAddress     0x81  EP 1 IN
          bmAttributes            2
            Transfer Type            Bulk
            Synch Type               None
            Usage Type               Data
          wMaxPacketSize     0x0400  1x 1024 bytes
          bInterval               0
          bMaxBurst               0
      Interface Descriptor:
        bLength                 9
        bDescriptorType         4
        bInterfaceNumber        1
        bAlternateSetting       0
        bNumEndpoints           2
        bInterfaceClass       255 Vendor Specific Class
        bInterfaceSubClass      0
        bInterfaceProtocol      0
        iInterface              0
        Endpoint Descriptor:
          bLength                 7
          bDescriptorType         5
          bEndpointAddress     0x82  EP 2 IN
          bmAttributes            2
            Transfer Type            Bulk
            Synch Type               None
            Usage Type               Data
          wMaxPacketSize     0x0400  1x 1024 bytes
          bInterval               0
          bMaxBurst               0
        Endpoint Descriptor:
          bLength                 7
          bDescriptorType         5
          bEndpointAddress     0x02  EP 2 OUT
          bmAttributes            2
            Transfer Type            Bulk
            Synch Type               None
            Usage Type               Data
          wMaxPacketSize     0x0400  1x 1024 bytes
          bInterval               0
          bMaxBurst               0
      Interface Descriptor:
        bLength                 9
        bDescriptorType         4
        bInterfaceNumber        2
        bAlternateSetting       0
        bNumEndpoints           3
        bInterfaceClass       255 Vendor Specific Class
        bInterfaceSubClass      0
        bInterfaceProtocol      0
        iInterface              6 CDEV Serial
        ** UNRECOGNIZED:  05 24 00 10 01
        ** UNRECOGNIZED:  05 24 01 00 00
        ** UNRECOGNIZED:  04 24 02 02
        ** UNRECOGNIZED:  05 24 06 00 00
        Endpoint Descriptor:
          bLength                 7
          bDescriptorType         5
          bEndpointAddress     0x84  EP 4 IN
          bmAttributes            3
            Transfer Type            Interrupt
            Synch Type               None
            Usage Type               Data
          wMaxPacketSize     0x000a  1x 10 bytes
          bInterval               9
          bMaxBurst               0
        Endpoint Descriptor:
          bLength                 7
          bDescriptorType         5
          bEndpointAddress     0x83  EP 3 IN
          bmAttributes            2
            Transfer Type            Bulk
            Synch Type               None
            Usage Type               Data
          wMaxPacketSize     0x0400  1x 1024 bytes
          bInterval               0
          bMaxBurst               0
        Endpoint Descriptor:
          bLength                 7
          bDescriptorType         5
          bEndpointAddress     0x03  EP 3 OUT
          bmAttributes            2
            Transfer Type            Bulk
            Synch Type               None
            Usage Type               Data
          wMaxPacketSize     0x0400  1x 1024 bytes
          bInterval               0
          bMaxBurst               0
      Interface Descriptor:
        bLength                 9
        bDescriptorType         4
        bInterfaceNumber        3
        bAlternateSetting       0
        bNumEndpoints           3
        bInterfaceClass       255 Vendor Specific Class
        bInterfaceSubClass      0
        bInterfaceProtocol      0
        iInterface              6 CDEV Serial
        ** UNRECOGNIZED:  05 24 00 10 01
        ** UNRECOGNIZED:  05 24 01 00 00
        ** UNRECOGNIZED:  04 24 02 02
        ** UNRECOGNIZED:  05 24 06 00 00
        Endpoint Descriptor:
          bLength                 7
          bDescriptorType         5
          bEndpointAddress     0x86  EP 6 IN
          bmAttributes            3
            Transfer Type            Interrupt
            Synch Type               None
            Usage Type               Data
          wMaxPacketSize     0x000a  1x 10 bytes
          bInterval               9
          bMaxBurst               0
        Endpoint Descriptor:
          bLength                 7
          bDescriptorType         5
          bEndpointAddress     0x85  EP 5 IN
          bmAttributes            2
            Transfer Type            Bulk
            Synch Type               None
            Usage Type               Data
          wMaxPacketSize     0x0400  1x 1024 bytes
          bInterval               0
          bMaxBurst               0
        Endpoint Descriptor:
          bLength                 7
          bDescriptorType         5
          bEndpointAddress     0x04  EP 4 OUT
          bmAttributes            2
            Transfer Type            Bulk
            Synch Type               None
            Usage Type               Data
          wMaxPacketSize     0x0400  1x 1024 bytes
          bInterval               0
          bMaxBurst               0
      Interface Descriptor:
        bLength                 9
        bDescriptorType         4
        bInterfaceNumber        4
        bAlternateSetting       0
        bNumEndpoints           3
        bInterfaceClass       255 Vendor Specific Class
        bInterfaceSubClass    255 Vendor Specific Subclass
        bInterfaceProtocol    255 Vendor Specific Protocol
        iInterface              7 RmNet
        Endpoint Descriptor:
          bLength                 7
          bDescriptorType         5
          bEndpointAddress     0x88  EP 8 IN
          bmAttributes            3
            Transfer Type            Interrupt
            Synch Type               None
            Usage Type               Data
          wMaxPacketSize     0x0008  1x 8 bytes
          bInterval               9
          bMaxBurst               0
        Endpoint Descriptor:
          bLength                 7
          bDescriptorType         5
          bEndpointAddress     0x87  EP 7 IN
          bmAttributes            2
            Transfer Type            Bulk
            Synch Type               None
            Usage Type               Data
          wMaxPacketSize     0x0400  1x 1024 bytes
          bInterval               0
          bMaxBurst               6
        Endpoint Descriptor:
          bLength                 7
          bDescriptorType         5
          bEndpointAddress     0x05  EP 5 OUT
          bmAttributes            2
            Transfer Type            Bulk
            Synch Type               None
            Usage Type               Data
          wMaxPacketSize     0x0400  1x 1024 bytes
          bInterval               0
          bMaxBurst               2
  Binary Object Store Descriptor:
    bLength                 5
    bDescriptorType        15
    wTotalLength       0x0023
    bNumDeviceCaps          2
    SuperSpeed USB Device Capability:
      bLength                10
      bDescriptorType        16
      bDevCapabilityType      3
      bmAttributes         0x00
      wSpeedsSupported   0x000f
        Device can operate at Low Speed (1Mbps)
        Device can operate at Full Speed (12Mbps)
        Device can operate at High Speed (480Mbps)
        Device can operate at SuperSpeed (5Gbps)
      bFunctionalitySupport   1
        Lowest fully-functional device speed is Full Speed (12Mbps)
      bU1DevExitLat           0 micro seconds
      bU2DevExitLat           0 micro seconds
    SuperSpeedPlus USB Device Capability:
      bLength                20
      bDescriptorType        16
      bDevCapabilityType     10
      bmAttributes         0x00000001
        Sublink Speed Attribute count 1
        Sublink Speed ID count 0
      wFunctionalitySupport   0x1100
      bmSublinkSpeedAttr[0]   0x000a4030
        Speed Attribute ID: 0 10Gb/s Symmetric RX SuperSpeedPlus
      bmSublinkSpeedAttr[1]   0x000a40b0
        Speed Attribute ID: 0 10Gb/s Symmetric TX SuperSpeedPlus
  Device Status:     0x0000
    (Bus Powered)

Tested with an early sample of the module on a Quectel 5G EVB connected
over USB 3 to a Raspberry Pi 5.

Assisted-by: LLM
Signed-off-by: Sebastian Sjoholm <sebastian.sjoholm@gmail.com>
Cc: stable@vger.kernel.org
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/serial/option.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -261,6 +261,7 @@ static void option_instat_callback(struc
 #define QUECTEL_PRODUCT_EM060K_12a		0x012a
 #define QUECTEL_PRODUCT_EM060K_12b		0x012b
 #define QUECTEL_PRODUCT_EM060K_12c		0x012c
+#define QUECTEL_PRODUCT_RG660QB			0x013d
 #define QUECTEL_PRODUCT_EG91			0x0191
 #define QUECTEL_PRODUCT_EG95			0x0195
 #define QUECTEL_PRODUCT_BG96			0x0296
@@ -1277,6 +1278,8 @@ static const struct usb_device_id option
 	{ USB_DEVICE_AND_INTERFACE_INFO(QUECTEL_VENDOR_ID, QUECTEL_PRODUCT_RM500K, 0xff, 0x00, 0x00) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(QUECTEL_VENDOR_ID, QUECTEL_PRODUCT_RG650V, 0xff, 0xff, 0x30) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(QUECTEL_VENDOR_ID, QUECTEL_PRODUCT_RG650V, 0xff, 0, 0) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(QUECTEL_VENDOR_ID, QUECTEL_PRODUCT_RG660QB, 0xff, 0xff, 0x30) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(QUECTEL_VENDOR_ID, QUECTEL_PRODUCT_RG660QB, 0xff, 0, 0) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(QUECTEL_VENDOR_ID, QUECTEL_PRODUCT_RG255C, 0xff, 0xff, 0x30) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(QUECTEL_VENDOR_ID, QUECTEL_PRODUCT_RG255C, 0xff, 0, 0) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(QUECTEL_VENDOR_ID, QUECTEL_PRODUCT_RG255C, 0xff, 0xff, 0x40) },


