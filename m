Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036709;
	b=TE+fGkjoiwzHeM//rLt7sNcWcJBJs1BKexUt9UGUc/4q3+D891+qiL8kIBBcnYoiJBkd
	 lUR2rvn86XtIS0AaKFrTsacD86B9zvlg/UW7GnO17a2etLC4Tg7oEEMrH9joVT2neUnKv
	 JkIQjayBbpks7WXOKqRNgYSFCAXxWvNTSezNVid1JsJHM+87KUFaH7pMMxnrwDipYGFXy
	 knY3NSytH6a2CN8I++GRgoMhgv1jFz8Ve0qj8UEDvi8rjoinFegognESiw+Y1jdTSfGkO
	 TJwAwHRPmxvSpX604/4huS7Wmt10w1Bmn9vYUDgDoyfe5JPlQdNNSVLuATVpiN7wIQw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036709;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=Opz4OMUJjHmwjQa1geWeqY8zGrdRcTRAxN9CcQGvpfw=;
	b=Ir59kkoZBA6+ME51bAAd6LagCIQbcw8GhbOXU0PrzoWyxsKv/HR8bsl1RGkrSB9eknD4
	 BFp/AvEcpR9n5IskWd4F4P4gyF7WcG69MylyijLLhJcGViUMPFPKUMXPUj1wJwlOGuV9W
	 Lp+o5Rj9c7VO75HbHy+Xg6pH+ZJtGzwd/BbaGg6NS0w1Heu2/o6ec4GM4LALpGo9yoxow
	 fyyQactbwhvzInyyytJILGKJDYbID6D5PE2pg+7TnnK3j99UnP0K7rCetIQPtcZDqwJBs
	 NA4EjD/OJjif/rFerDcLvztj5vZiabir5jziF2p1kN/gxzBuQSJfKWOmYAcqEeBuUBQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=N5c7g5mz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAC26606A31C;
	Wed, 18 Nov 2026 21:18:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=N5c7g5mz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED3CC1F000C4;
	Wed, 18 Nov 2026 21:18:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036708;
	bh=Opz4OMUJjHmwjQa1geWeqY8zGrdRcTRAxN9CcQGvpfw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=N5c7g5mzP9z99e2OZib1TeiHiJ67gXRaVecMjnPPHwQE1Au9+GqKoaOnPWQRYhCky
	 V8Re2X7nIzAvTJs8MbWktgseF3bnrYV+NPBOZCrv50kb2f6KqMXXJdjlFkEMW6X6Ws
	 UYnq0Xu7NmeJm9vFnAfLLdfn9bUNypeEW+Q2WTE8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Nikolaj=20Klitlund=20B=C3=B8rty?= <nbn@sj.dk>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1112/3318] Bluetooth: btusb: Add device ID for Realtek RTL8761BUE (StarTech AV53C1)
Date: Wed, 18 Nov 2026 15:28:54 +0100
Message-ID: <20261118150353.362401212@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index a5a7cd41e0ae9..5c43250e4301c 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -771,6 +771,8 @@ static const struct usb_device_id quirks_table[] = {
 						     BTUSB_WIDEBAND_SPEECH },
 	{ USB_DEVICE(0x37ad, 0x0600), .driver_info = BTUSB_REALTEK |
 						     BTUSB_WIDEBAND_SPEECH },
+	{ USB_DEVICE(0x14b0, 0x047a), .driver_info = BTUSB_REALTEK |
+						     BTUSB_WIDEBAND_SPEECH },
 
 	/* Additional Realtek 8821AE Bluetooth devices */
 	{ USB_DEVICE(0x0b05, 0x17dc), .driver_info = BTUSB_REALTEK },
-- 
2.53.0



