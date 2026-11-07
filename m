Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064848;
	b=Z1my9rIrI6HmM2RxAeIAbQnhS7MkyC6WFlU3aXau9hqv2/L3k73hzN2whaF3wn/VdM43
	 qZut/Uz6t7+pAdGSFofkzpVYriungk7J0mEfCZCpo0c9mnT60ZHqk8l4mW8qW7b87yVLt
	 O/eATj1CfBdL/9FcVfn0/DcaO36tcNV5kt5UIN4/OV5FcS/ts0cXadwU4ZLSVCmtaaGgi
	 F8Kdd6PUXYKaGgFXEOZKgb5AfKuKgK1EE0t6UaNjiGGd21bS/U+M8ieJ1+n3+RsAJpqBW
	 /uxrTDfxbu7a8vwd3XsZ+C5S5/CncN4J+0syj8LTcdLqa99VAXBAyilD/yq7XjiZl/A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064848;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=0D5CNtSNvji7nAAH8Y40dAOFhw9zYeWmHGzk0L3AsT0=;
	b=aSExK7/Lwm5q+RCNc0Sxgm6n19/EmmDQLTYT4E6NRza4kSpDnbQJFrX5g3Uk0+QSYsIz
	 WMYP4wbmsCMQTdEcjoxADoScooPyqZGq2VM23UM+KqD7sA9oV7qUKC6KW3KR6JhauJv4q
	 dbY0bHDvIml1vQtAi7rDYZ7b0kgY1fDm9+G3wNnlTVBaUCVmOaXNxIC49icqSkDEV9NYE
	 cX3jmBKO1v2ZQxyJu9EAk81YZcbTtzsli2LJnpGlthaDWCDlb/7Dj0GkM/9+u3zdpRcgl
	 IRqCS09yTDuBk+lVb/NaDZZo6K2SM0AwXe9cfKEeVyJskzKAQLNtPh1V+8D50vPc7og==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="WE2OYCG/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38C5F606B8AD;
	Sat,  7 Nov 2026 15:20:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WE2OYCG/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C83691F008A1;
	Sat,  7 Nov 2026 15:20:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064848;
	bh=0D5CNtSNvji7nAAH8Y40dAOFhw9zYeWmHGzk0L3AsT0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WE2OYCG/wWQAbJ9ijGunRGjmsXBI/sFoHB9iWKoj2w34vmu1jLBHgMTIUMX5F3BxA
	 qyyQ/QLBQpo/UPeplxArfav1KU8OMCECKd6nwocdQWtV8l2rUMmtT/vZ4iKbCI1G4T
	 nBjmMbiBjeieOPq5iIJmDEKPRwR22LwXwXZ8tObE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Nikolaj=20Klitlund=20B=C3=B8rty?= <nbn@sj.dk>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0772/1257] Bluetooth: btusb: Add device ID for Realtek RTL8761BUE (StarTech AV53C1)
Date: Sat,  7 Nov 2026 08:51:08 -0500
Message-ID: <20261107135000.618572710@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index dc7191bf42349..ece1fd426f12b 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -878,6 +878,8 @@ static const struct usb_device_id quirks_table[] = {
 						     BTUSB_WIDEBAND_SPEECH },
 	{ USB_DEVICE(0x37ad, 0x0600), .driver_info = BTUSB_REALTEK |
 						     BTUSB_WIDEBAND_SPEECH },
+	{ USB_DEVICE(0x14b0, 0x047a), .driver_info = BTUSB_REALTEK |
+						     BTUSB_WIDEBAND_SPEECH },
 
 	/* Additional Realtek 8761CU Bluetooth devices */
 	{ USB_DEVICE(0x0b05, 0x1bef), .driver_info = BTUSB_REALTEK |
-- 
2.53.0



