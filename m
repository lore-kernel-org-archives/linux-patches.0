Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063439;
	b=fnJNoeOFEp2rM8Gwdqs8QDMYzRBJWzAh204hPywfGXIYVuUH/dM/SSNzNMZykSNobAdO
	 DEwbZgdELjjk34TLyhCgo8YBNk7XO4+RH0s9AVrQv9sPzWM/l8gpXCsyE0WSxfMWXnzcC
	 ASge7X+Me7Rr8Zs3B8mAQrYnrEmiorN0w4mGhPmOZ3FAk66kJid59XZUTHZeLCjyTzxoU
	 2OAZavg92sHCZfiaApc2LrEHtxfrfHhjLbX7YjP+5otmnjhF83aWQWXDiP6VYcfegkgaR
	 FlaO3pnI719ogl39b14zhljbd2j4962UqA73wLWbUVkc1+DImb6em4K3NqV7faSM+EQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063439;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=Ok0cKvL00sr3/rQzjg/HtXm9zvYMRdAT+rMiKR6PZg8=;
	b=wIJhhyVhb6sQCrrr3SHCRys89IlgPvlFPhGno8J2in+zPl8K0T0T7K7G/RgOuJ3zRhWr
	 65djt8bAU0xfA/KT6aY5LL1YaSgkh990D98tW0SAuwf9HgyXFVM8ikeOPFaTeG035/EYd
	 ABc/gh2uWrdCBryGGasj91pBHhmSIkmIKlsMof3bvqRgIkbYdB0kMaq8Mmq5zHZjJF794
	 vLUcGrxafLKuI63sEAEnw3/h+zRP7o4Mv96TSd7Nspm+8ZPzZgBQMi9KYGmJiW7Dc9WrL
	 UEXlS1Ih6CoeXuRYHpsC6P4cGnt8lxrCKQa09WnLgSOzSdt1Q2u6mLToJLo6qvCOAdg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ijmS63uu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1B51606A337;
	Sat,  7 Nov 2026 14:57:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ijmS63uu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FD7F1F0089F;
	Sat,  7 Nov 2026 14:57:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063438;
	bh=Ok0cKvL00sr3/rQzjg/HtXm9zvYMRdAT+rMiKR6PZg8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ijmS63uuPJXz0T9VMNvDp2dVHJ8MlE8bxXRMzXH+qy5LNTNdrL2xiKb1qWwlWc5il
	 Wf9zJELmEIElqu3t23cbhAAgeE/Dpe7AO+9pxNbgVe71ljdqjenPa0hUTNTtTLc3mg
	 hnEJvZXQL+APW6QZVHJvAC9VW7Xp2XHXlhrV8KsI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Nikolaj=20Klitlund=20B=C3=B8rty?= <nbn@sj.dk>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 564/869] Bluetooth: btusb: Add device ID for Realtek RTL8761BUE (StarTech AV53C1)
Date: Sat,  7 Nov 2026 08:54:06 -0500
Message-ID: <20261107134912.407625002@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btusb.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index 0b8c2ecf0a64c..5b8b71efffac9 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -843,6 +843,8 @@ static const struct usb_device_id quirks_table[] = {
 						     BTUSB_WIDEBAND_SPEECH },
 	{ USB_DEVICE(0x37ad, 0x0600), .driver_info = BTUSB_REALTEK |
 						     BTUSB_WIDEBAND_SPEECH },
+	{ USB_DEVICE(0x14b0, 0x047a), .driver_info = BTUSB_REALTEK |
+						     BTUSB_WIDEBAND_SPEECH },
 
 	/* Additional Realtek 8821AE Bluetooth devices */
 	{ USB_DEVICE(0x0b05, 0x17dc), .driver_info = BTUSB_REALTEK },
-- 
2.53.0



