Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17E37248BA1;
	Wed, 15 Jan 2025 10:42:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736937763; cv=none; b=FAGg184kFy61ZcV5MU0Q3qp7BpjKfDUI64vdLr+LjYaxuAiP2As3T4lFP6IteCFtbYaPgHe+STZsanZI9NEK5m28v+BqKOVse5qvn4bkWyBcCgdKG5rRvAIINcfsDqPhQxHHGT25J9NPXF6NmSI8P37F2og2bSJ0wyF2sFik3Bg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736937763; c=relaxed/simple;
	bh=2CSr10hLYzODpD5Uc/7oaR4Bs4dw4+uwKz5gb8/Szcg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UFSZ+R+cR9LWzSBttPOMv59vuCfppEFeMrQjjW9AOV8f+4TkVOOP5hLEwQJ6aRa8qxZG4BYgazyULihThf+G2dFUU68pgyldhqytHQvcLOirYJ9g0Cu5nlpgFb7hFphlTJcjHeHgEMFtWNDhLgd6L0qhfRRAKA5oNgyWCyl0ess=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ougUxGfm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ougUxGfm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 858F0C4CEE2;
	Wed, 15 Jan 2025 10:42:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736937762;
	bh=2CSr10hLYzODpD5Uc/7oaR4Bs4dw4+uwKz5gb8/Szcg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ougUxGfmSstbS/Is6pSPswR3zlLxIybGBMefW2HuOfJrX0FTg6s1VmpGcAA8o/L3t
	 7TOamNeEVF86F+xL+L0++SGmdltoFXSLK6mZZlOV/hEbJN0b1Xj4GlAEr2m+kjmnmR
	 rFFYMSrgshD1saZpJl6hSiKAMZauWzIwf9NcJ8mg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Giuseppe Corbelli <giuseppe.corbelli@antaresvision.com>,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 6.1 57/92] USB: serial: cp210x: add Phoenix Contact UPS Device
Date: Wed, 15 Jan 2025 11:37:15 +0100
Message-ID: <20250115103549.836799400@linuxfoundation.org>
X-Mailer: git-send-email 2.48.0
In-Reply-To: <20250115103547.522503305@linuxfoundation.org>
References: <20250115103547.522503305@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


