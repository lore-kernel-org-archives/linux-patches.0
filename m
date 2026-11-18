Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795047309;
	b=FEPtCNk1BubfAYz20xFMA653ORSm69sXycfjMtYaKxVo5mw8Ss3L9OyuX5U74h9IQ2lB
	 TFbwd/hb45x/V7RLlHjPCSxhroMtlqRAMiWeEYAL2YcrYG+W4E3OYxQj4uKa8NP2MqJdB
	 lHEtkuescL8VnoKbdFYMr05DN9hlw89TZw+TCY+jGzBRqF8z6REIdDqe7qovpNKLHWB8U
	 OC30IRLLpRbdzJWZHVCmk06Crug18VN2YuqBYA7lGCm6L/wE7mFyi6iSbsuinspc3DtPM
	 tVdlVHKhZWpWUe/SQ+sK+cKICAIF/iAtRjMPYXUkE9M7l+/BybbaLhJRr+FX0zqwZXA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795047309;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=/E67EKSerdX0B8ceKIR0LqYul7aZ7nKmJORRpMyGG0s=;
	b=rnHljW8SE2r374wGTfvIXJkBbOIp/iu5Jlh5Mdc9aQu3933d1gmXGvCHWlBIvOcfKMv8
	 sHtkV5MN3oYZaOahJ82+i7ks9ddnPGd3p0/tJzj1d633S6Bp7iEXxP4RiOar7o9ezFcCg
	 UMsnXZOhI3odjH6quPPVUWv+6puuBAKwrDao8yKQAXKKzYhE5EKUrsMVTe++gZzSLs7jU
	 m5pg3sS96iGPd/10a+tSFQ2Gtrj9sCDCGDM88bKnP1zsf0ZPs3G5OWExrsvCBVwc/p8Xz
	 8Q5W5TS7gRRALuPOcRWKRfsWXOT8JOYEHBiwkkl5wza8VqY2o6es1oSwbuz3ZdfKLjQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AqMvTGZX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08EDE606A31C;
	Thu, 19 Nov 2026 00:15:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AqMvTGZX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D08861F000C5;
	Thu, 19 Nov 2026 00:15:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795047308;
	bh=/E67EKSerdX0B8ceKIR0LqYul7aZ7nKmJORRpMyGG0s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AqMvTGZXPGUJ4kV54iKUQ+5QQMA1Ee9dmMFLLFlou3EeDudwMDEDuSjwh+Oyx+BZc
	 bv49cbliw9mbFfgCxNZhJ0KAy2CJVwXIcLJWuz9E2X4QmhqxSWTE61TOTiT3ui+VTV
	 6LGlAS4mB+pJDcPkJsbxfjdN80oFLw72lPO7PQBw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Nikolaj=20Klitlund=20B=C3=B8rty?= <nbn@sj.dk>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1590/2857] Bluetooth: btusb: Add device ID for Realtek RTL8761BUE (StarTech AV53C1)
Date: Wed, 18 Nov 2026 15:43:44 +0100
Message-ID: <20261118150258.622676615@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: adapted the quirks_table insertion to the existing blacklist_table context because upstream's neighboring entries are absent ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btusb.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index 4702ab9aa9ca3..5ed1a89c090bc 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -692,6 +692,8 @@ static const struct usb_device_id blacklist_table[] = {
 						     BTUSB_WIDEBAND_SPEECH },
 	{ USB_DEVICE(0x7392, 0xc611), .driver_info = BTUSB_REALTEK |
 						     BTUSB_WIDEBAND_SPEECH },
+	{ USB_DEVICE(0x14b0, 0x047a), .driver_info = BTUSB_REALTEK |
+						     BTUSB_WIDEBAND_SPEECH },
 
 	/* Additional Realtek 8821AE Bluetooth devices */
 	{ USB_DEVICE(0x0b05, 0x17dc), .driver_info = BTUSB_REALTEK },
-- 
2.53.0



