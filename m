Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2659B1F757F;
	Tue, 21 Jan 2025 18:09:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737482981; cv=none; b=FgKmhsmqrWw02mji54lKPbUZZmenjRMy2uhmMH4Ai6fnFdXHdx/oKU71CTTOPcyfMpDyNrGxK5wiBHi1EuE94LXEzOlMAyDAAnmyBNDdv+L2Ew4xsHWYeX/nRoYEzypv8kLfnZPdb84u1zKG+VHIaTLPBstNulz3ohrCo3Mpj2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737482981; c=relaxed/simple;
	bh=51qGPWiRRrY0hpE+rMwIsWqa8Bx3j8wCqa0MTgHqfrc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JBU6W/7R35BxyrRSOvNg40Z9pJ6sNebxPsdZ/LYh9G/NqR3InI0JKSn7QZv3gYQyyg/tjWQw9X3vX0FumSgR0B4xUocj1v3avEYXF8f91vKyWLiDqKXsuAi6wetIrpXWv2YoMD5T9rVoMarNYQPe5I2UD/wdZUek2ZEHvD41ORY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EPB02qcc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EPB02qcc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38312C4CEE0;
	Tue, 21 Jan 2025 18:09:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1737482979;
	bh=51qGPWiRRrY0hpE+rMwIsWqa8Bx3j8wCqa0MTgHqfrc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EPB02qcc4134ku1LXekplqfPhsM/y/0Rv5rJ6aFrH9uOFV8KHZ0WYVfRMgKQYyEd/
	 56jFs+TxlOCZsnj7GVi1tZFCV3psBrCEQ04VeVnV8kY/0eHOHmjI1lmGa5YLVmUD37
	 QlboJ745WdsmHv6uqhaaIdHQm35Y8B5JYZcL2l9s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Giuseppe Corbelli <giuseppe.corbelli@antaresvision.com>,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 5.15 044/127] USB: serial: cp210x: add Phoenix Contact UPS Device
Date: Tue, 21 Jan 2025 18:51:56 +0100
Message-ID: <20250121174531.375532892@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250121174529.674452028@linuxfoundation.org>
References: <20250121174529.674452028@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

commit 854eee93bd6e3dca619d47087af4d65b2045828e upstream.

Phoenix Contact sells UPS Quint devices [1] with a custom datacable [2]
that embeds a Silicon Labs converter:

Bus 001 Device 003: ID 1b93:1013 Silicon Labs Phoenix Contact UPS Device
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               2.00
  bDeviceClass            0
  bDeviceSubClass         0
  bDeviceProtocol         0
  bMaxPacketSize0        64
  idVendor           0x1b93
  idProduct          0x1013
  bcdDevice            1.00
  iManufacturer           1 Silicon Labs
  iProduct                2 Phoenix Contact UPS Device
  iSerial                 3 <redacted>
  bNumConfigurations	 1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength       0x0020
    bNumInterfaces          1
    bConfigurationValue     1
    iConfiguration          0
    bmAttributes         0x80
      (Bus Powered)
    MaxPower              100mA
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           2
      bInterfaceClass       255 Vendor Specific Class
      bInterfaceSubClass      0
      bInterfaceProtocol      0
      iInterface              2 Phoenix Contact UPS Device
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x01  EP 1 OUT
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0040  1x 64 bytes
        bInterval               0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x82  EP 2 IN
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0040  1x 64 bytes
        bInterval               0

[1] https://www.phoenixcontact.com/en-pc/products/power-supply-unit-quint-ps-1ac-24dc-10-2866763
[2] https://www.phoenixcontact.com/en-il/products/data-cable-preassembled-ifs-usb-datacable-2320500

Reported-by: Giuseppe Corbelli <giuseppe.corbelli@antaresvision.com>
Cc: stable@vger.kernel.org
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/serial/cp210x.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/serial/cp210x.c
+++ b/drivers/usb/serial/cp210x.c
@@ -223,6 +223,7 @@ static const struct usb_device_id id_tab
 	{ USB_DEVICE(0x19CF, 0x3000) }, /* Parrot NMEA GPS Flight Recorder */
 	{ USB_DEVICE(0x1ADB, 0x0001) }, /* Schweitzer Engineering C662 Cable */
 	{ USB_DEVICE(0x1B1C, 0x1C00) }, /* Corsair USB Dongle */
+	{ USB_DEVICE(0x1B93, 0x1013) }, /* Phoenix Contact UPS Device */
 	{ USB_DEVICE(0x1BA4, 0x0002) },	/* Silicon Labs 358x factory default */
 	{ USB_DEVICE(0x1BE3, 0x07A6) }, /* WAGO 750-923 USB Service Cable */
 	{ USB_DEVICE(0x1D6F, 0x0010) }, /* Seluxit ApS RF Dongle */


