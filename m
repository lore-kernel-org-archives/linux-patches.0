Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795054203;
	b=PkbU9OSjp/vwBl4S1O+q9Wnp6LCusIolnWIROjfCngVANRy2YPzTzMAkxsH15YtaEYiV
	 aL5SIwh8IDsZbr5Azj7M6OYyae5olzsOnpBNAsbCH9hU/uhA+KWMNeqtl7baI+MCzqANC
	 1wviPdB3qtltYVKQ7sGMU0gm7H/SBEF93HxcR8opwXV+2wOOvtP9URxILGtO+nJVR775l
	 3o3sTOv4IDnhQJTRID3dIWutCH739+XAthOGHM6RJ+WCIdYR21GTwTt3P2FALVXjr0kFM
	 /xk996ffx5VH0ayRKgTjg7AlMbijH5jy/6cJbsg0LcGFLcxDN44iIOKbmBALzadHTBA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054203;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=fJxNQXJYB7CfVrAZv1xsv9/hT4hPYlCkp8ZghrhzFI0=;
	b=3zWr7/Toyf+P6w0TufhC88mTrpKmR419zOea1ItmKFadnLD/bSy91HSjOA0WGFPulRKQ
	 laFHDTtrywV08MoYqvo5xc8sZbbOv94ogz/+OdhuTRA+iDE8LI8BsfOD3uMPo8chn4zXs
	 MFW07dcWqc55L9JjaJTRi0G+Fwm/jR9n5nOZp1Y0GpBJ9X4nY9GpD3AYGYhThoS8E1o24
	 rI07MigIKpElvenQ08QuhSDwizEDpWL9fC+D/M5W6zmJHcCjqTCrgWMKYg6asf+Ufkjg7
	 p2GNhqu8Oxuk4BRnSeCtJZsu4I8SwYi8zH3BgPS0MPdbRMfiScbfQ8TXyoLIVhGa1IA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="Gox/CyZH";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 196CA606A31C;
	Thu, 19 Nov 2026 02:10:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Gox/CyZH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 808BF1F000C4;
	Thu, 19 Nov 2026 02:10:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795054202;
	bh=fJxNQXJYB7CfVrAZv1xsv9/hT4hPYlCkp8ZghrhzFI0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Gox/CyZHLNDE7WhfDmh0ULWeRDVFGC921R7S16tAwyaf/kfabUnUijkRTOEI9MSwi
	 VmfF3eId5hPHjrdJ2+kaZ+YCpLvNFl2BOGXJLaUKfpW7AlmWDSZRpZr542fMtDgK0k
	 YXA6+6R924kVwOLcCXOVvrmhF1Dq10So4pSxisVg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Nikolaj=20Klitlund=20B=C3=B8rty?= <nbn@sj.dk>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1190/2214] Bluetooth: btusb: Add device ID for Realtek RTL8761BUE (StarTech AV53C1)
Date: Wed, 18 Nov 2026 15:47:46 +0100
Message-ID: <20261118150059.508661037@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nikolaj Klitlund Børty <nbn@sj.dk>

[ Upstream commit 1430308fc9d47a801a305700cd444b1a0051d14a ]

Add the USB ID 0x14b0:0x047a for the StarTech AV53C1-USB-BLUETOOTH
adapter, a Realtek RTL8761BUE based Bluetooth 5.3 dongle.

Without this entry btusb treats the device as a generic Bluetooth
adapter and never loads the Realtek firmware, leaving the controller on
its ROM firmware. In that state it advertises and scans actively, but
never reports advertisements during passive scanning. LE connections
initiated by the kernel wait for a passive-scan report before issuing
LE Create Connection, so connecting and pairing from BlueZ time out
without any error from the controller.

The same product is also sold with the ID 0x2c0a:0x8761, which is
already supported.

lsusb -v output for the device:

Bus 001 Device 010: ID 14b0:047a StarTech.com Ltd. Bluetooth Radio
Device Descriptor:
  bcdUSB               1.10
  bDeviceClass          224 Wireless
  bDeviceSubClass         1 Radio Frequency
  bDeviceProtocol         1 Bluetooth
  idVendor           0x14b0 StarTech.com Ltd.
  idProduct          0x047a
  bcdDevice            2.00
  iManufacturer           1 Realtek
  iProduct                2 Bluetooth Radio
  iSerial                 3 00E04C239987
  bNumInterfaces          2
    Interface Descriptor:
      bInterfaceClass       224 Wireless
      bInterfaceSubClass      1 Radio Frequency
      bInterfaceProtocol      1 Bluetooth

Cc: stable@vger.kernel.org
Signed-off-by: Nikolaj Klitlund Børty <nbn@sj.dk>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
[ sashal: Adjusted insertion context to the existing RTL8761BU group in blacklist_table instead of quirks_table. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btusb.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index de588bee66e66..0b96df90c65e4 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -546,6 +546,8 @@ static const struct usb_device_id blacklist_table[] = {
 	  					     BTUSB_WIDEBAND_SPEECH },
 	{ USB_DEVICE(0x2550, 0x8761), .driver_info = BTUSB_REALTEK |
 						     BTUSB_WIDEBAND_SPEECH },
+	{ USB_DEVICE(0x14b0, 0x047a), .driver_info = BTUSB_REALTEK |
+						     BTUSB_WIDEBAND_SPEECH },
 
 	/* Additional Realtek 8821AE Bluetooth devices */
 	{ USB_DEVICE(0x0b05, 0x17dc), .driver_info = BTUSB_REALTEK },
-- 
2.53.0



