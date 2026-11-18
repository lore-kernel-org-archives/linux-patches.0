Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795059870;
	b=dku4WwSC7hDXvuVcE0AElgz/grJqJWAJ0LA0HqwlfHresor2hyX1XISO2dQfyI5abut9
	 4Y2uOXWm7JxxGcGa43TPgVsAR2NXaSnaiP6VDPwqbs2NeviZI35oHZ4T5c/JDI/Ot43Mz
	 vklUZEDZQnOWfxVWuCebAkouhCamimGEJMBlPMOsy0roIQ6nA8zMge06kglC0DmN3Dec7
	 RB8l8eHCQNFZbbP1OJ/hWbDrV+Zhf60YFwONSLjW4UISGK2CkwAeHp5MbBFdlcfk1HGP+
	 33oXlbRXDvypVQMDc2peMkx0F8EWBVvGESV6VVrtDenzpfFyP928bRo3/KP3oxyZewA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795059870;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=fPLOllrzmV2UEt5SQboLhLel0xP3OYKkPEKMKf30/cQ=;
	b=3KYxjmT+3bAgyN7oG6zBwQqckxGqLVWsyNxjiY33wfvdy6XNz5uGdSTgb7rske/AdIKO
	 PtxbsBs7mKtI/3T7Eb9Bp01tZ88/D5TlhwcGn0bKuGsp9A+ba1TJ/LDK0tByAm7J1yAnM
	 /Esg8jIn3uprLNwQ+QQmUuZn1lfhkbTvTHxLgHZmVAeaFCTwS2D9AZoJcbh3l8L4d628g
	 Lv9N4GYqjUi39jOj9uern3+LW0U20KoHjHOCioNB/lb9X4aD4e7yNA2C2rCnWuHVTdhDV
	 E98tnBaz4Zs1gCOLYYERG+KKpezMugFkXSKKjBl4KhcCMz8hBgOj3SKFezu5zYrphcQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HJRNyWWP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07657606A320;
	Thu, 19 Nov 2026 03:44:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HJRNyWWP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 523BB1F000C4;
	Thu, 19 Nov 2026 03:44:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795059869;
	bh=fPLOllrzmV2UEt5SQboLhLel0xP3OYKkPEKMKf30/cQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HJRNyWWPgQHbCHJDzTsWjCOMtNOS56X5BPrJ2Z0crazKJyKmKNzMC922FeYn5SCVN
	 kvYROi+5ohjsSgRcm8HB68DCe7OKfUW7DvWj2kUqNLODoNuTW6rm4TfwDHhHyYGNO8
	 of11NwTloFkydrsSg4a//TIjaU/YvAPKnbAGJJTs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Nikolaj=20Klitlund=20B=C3=B8rty?= <nbn@sj.dk>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0996/1848] Bluetooth: btusb: Add device ID for Realtek RTL8761BUE (StarTech AV53C1)
Date: Wed, 18 Nov 2026 15:50:34 +0100
Message-ID: <20261118145958.540634937@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: adapted quirks_table insertion to blacklist_table with the missing Realtek group heading added ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btusb.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index 55a54612a59e6..1eaa5c83da306 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -500,6 +500,10 @@ static const struct usb_device_id blacklist_table[] = {
 	{ USB_DEVICE(0x0bda, 0xb009), .driver_info = BTUSB_REALTEK },
 	{ USB_DEVICE(0x2ff8, 0xb011), .driver_info = BTUSB_REALTEK },
 
+	/* Additional Realtek 8761BUV Bluetooth devices */
+	{ USB_DEVICE(0x14b0, 0x047a), .driver_info = BTUSB_REALTEK |
+						     BTUSB_WIDEBAND_SPEECH },
+
 	/* Additional Realtek 8821AE Bluetooth devices */
 	{ USB_DEVICE(0x0b05, 0x17dc), .driver_info = BTUSB_REALTEK },
 	{ USB_DEVICE(0x13d3, 0x3414), .driver_info = BTUSB_REALTEK },
-- 
2.53.0



