Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795051366;
	b=BmmP+yWwkJigizKGk265k+x9mZsp22v7QhSBD1L/490ONNo233CMmcdC8vTSSIi3aBkJ
	 Va7+tk7rFxDAQjn3P+RkU/LQi2F6HB2ZCPB6SlToIYpwGwN9EdAIKJn8WIpvrvVSg8X9V
	 dqEDZP/4LN/V5wZ5sFw3El8/S1KdtYTovhcfUv1OSHLmt5EN8S30bmWKAs+LpyOLajV5H
	 36ulKnqCf6RsHg3kF0lQR2CwJLHUCcHl4zVWLqxrqb6lLyF1xmZkDjqwQg5liR+8ptU14
	 RUb4hQFUL/wxp2B2KCgfEZulIqBIrAnycrmt+MICRwwH5o8p3F+rz4IKfF3JD4AzxrA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795051366;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=JuE2U+MyFW8y24k54urr+7ws5PKjPWkWjC0pdwWaGVc=;
	b=YRRRAD6fjTIDQe9+ba3u1c8TPdxrFS7f7teAjE6sxLJ16bMw/3KZZy/w4WqbBU4YrTcU
	 5F8Eu1/qlMKa9bhDP/DP+UTcIaDMncqhCb1IMIUOMRpJsVMKQsMV3kLI8o5YFElJM1Qlv
	 dPJ71fEv36MRZj5VYEacsP7+ImsqWdQWjg2O513DAt9Nka9UmMX9tGItoKtaF8MJJcicB
	 7LWgpQ8n6zHQCVbKGjp1OZNGIoTfBGf+fCNGQfII1Qz4ybBpDlSqm3wsY+mqX0HiayRTP
	 jQ37dRXQDUXHviahKeJs2TrYtqL4kG8xkHmJAHpr9bZC2NILtZybNMeYQxExda3UBqA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="r4ePF/ab";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD409606A32F;
	Thu, 19 Nov 2026 01:22:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=r4ePF/ab
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 065D91F000C8;
	Thu, 19 Nov 2026 01:22:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795051366;
	bh=JuE2U+MyFW8y24k54urr+7ws5PKjPWkWjC0pdwWaGVc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=r4ePF/abC0QjQ3xiitA0xdNylr/3L3vfNSTmT6BJloJordMCUiwBjnHZNKaunuAyi
	 gC3p2km7MY6/pjfboM4YHW2mmDj5owRPNE44aQuuCpdGBobz+3pw+eEbY8ej2TqeFV
	 l7T27uD4ejWpXZGClMzjJch2VjVoiczJcJU4j7bY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavel Zverev <playximik29@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0184/2214] Bluetooth: btusb: Add support for 1357:c123 Realtek 8852BE device
Date: Wed, 18 Nov 2026 15:31:00 +0100
Message-ID: <20261118150017.388202278@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pavel Zverev <playximik29@gmail.com>

[ Upstream commit 335d7bd554a20f33acf762655cafe1089f7f5822 ]

Wiko Hi MateBook 14 Ryzen 200 laptops (DMI system-product-name
"MNCA-XX", board "M1060") are equipped with an RTL8852BE Wi-Fi/BT
combo chip (rtw89_8852be), whose Bluetooth radio enumerates as
1357:c123 instead of one of the already-supported 1358:c123 / 0bda:c123
identifiers, presumably due to OEM rebranding. Without a matching
entry it only matches the generic USB Bluetooth class fallback, so the
Realtek firmware/config (rtl8852btu_fw.bin / rtl8852btu_config.bin) is
never loaded and the adapter cannot discover or connect to any device,
even though hciconfig reports it as powered and scanning.

Device descriptor:
  idVendor           0x1357
  idProduct          0xc123
  bcdDevice            0.00
  iManufacturer           1 Realtek
  iProduct                2 Bluetooth Radio
  bDeviceClass          224 Wireless
  bDeviceSubClass         1 Radio Frequency
  bDeviceProtocol         1 Bluetooth

Adding the same BTUSB_REALTEK | BTUSB_WIDEBAND_SPEECH quirk already
used for 1358:c123 and 0bda:c123 fixes firmware loading and normal
operation.

Signed-off-by: Pavel Zverev <playximik29@gmail.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btusb.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index 6620db5205684..de588bee66e66 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -579,6 +579,8 @@ static const struct usb_device_id blacklist_table[] = {
 						     BTUSB_WIDEBAND_SPEECH },
 	{ USB_DEVICE(0x0bda, 0xc123), .driver_info = BTUSB_REALTEK |
 						     BTUSB_WIDEBAND_SPEECH },
+	{ USB_DEVICE(0x1357, 0xc123), .driver_info = BTUSB_REALTEK |
+						     BTUSB_WIDEBAND_SPEECH },
 	{ USB_DEVICE(0x0cb5, 0xc547), .driver_info = BTUSB_REALTEK |
 						     BTUSB_WIDEBAND_SPEECH },
 	{ USB_DEVICE(0x13d3, 0x3591), .driver_info = BTUSB_REALTEK |
-- 
2.53.0



