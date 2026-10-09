Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 862C04E2F03;
	Fri,  9 Oct 2026 14:38:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791556736; cv=none; b=boLyWlgtnQN8fGb7Cc7/WVZKpjkYv/P2w+Pxy3pS8F0FKi5toXs85LSxp4dz5SVxUE8Y/MGeM7sd/ciDK8T4f5omYq7hPvuV377EUmcRQA9M3cluFweTQ4SZt7vv1bpbSFrZGqlORpB5jGBdbHhrSyGg52rgL/TLgRHeKQus/X0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791556736; c=relaxed/simple;
	bh=rYoE1u4Vr4sW/P89qrqkY8d4HHRfi2pbczFZWFZN3VQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DOTWa+gQuJXC1kZUlCU0tUNMpvMtLLsYS8oFWchHw/95tr2L9i3PqwoUMZM/jUhHm8Mz8OJL49PuFiyKjEtv/yu27TGs/3MHxOBMEktXDgOG+Lqi/f+PuidBFEX9PrvQsw6CsG5wYtWolsF+l924LeVomrEHiW+CZXTPI84iL5k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w9dnUhJ6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w9dnUhJ6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC48B1F00893;
	Fri,  9 Oct 2026 14:38:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791556735;
	bh=xvjBas0j7BRGydSbYqpbO9t3ZWCW41t4ueuHzdgsjdc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=w9dnUhJ6wTbR7/FH7FEAWosnbFNf9zANqV1CH4sSwQsOwA7LBcUSVzUFO278UmaJg
	 1QjQz5331MypEKwC8m3M1qfOD/aN8RSxVRP0U3LvbLOndtDgvUCuITcfWPC4F/BjYc
	 +QOHPjPwUI0Atc1dezxE0WtRCrZhIlnpc4s/EXzU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sebastian Sjoholm <sebastian.sjoholm@gmail.com>,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 6.18 285/403] USB: serial: option: add Quectel RG660QB
Date: Fri,  9 Oct 2026 16:10:46 +0200
Message-ID: <20261009140958.860890873@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140952.119038291@linuxfoundation.org>
References: <20261009140952.119038291@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

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


