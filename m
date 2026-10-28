Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208468;
	b=mI95KhVyIbD/8fIVSbgAk5gRyJGoWmeCzqsi99npBbIzPN31dVei6wxM5lv0u7YwWK8I
	 DHQSO2H68BYqKdqcqMpMY1GnIis1NuW7S1ggwjunrc6gn+9bOsvzQhRz5N1rICno/4L0u
	 sQFj8HvSAIA5rX2WbmMbWA6BLy9hDm0qeBW34eVho5xAkhGQUj1S1c9vd+L0XGF6r5SdX
	 FYSsl+9qEhjuJ7Pt82Uqx0bat3bU1dL5uhGeKSIgtHPFVN8rRK+sjCwinpE45aXhW8rO9
	 XVJHG6jjz1rTOuq9ezSk2FfSO9oEu0RY9Myrc5u8lVQz/b/RO4kcU2/2HN3zcW1D3gQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208468;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=57nDk5gJC4lvaqB4JMPLMSuY9OZ0KBA9GC5/70LtQXk=;
	b=gRwhU+LJ1W1Ec9Xm7w6C0Z7SZSKKoIn+DqFreijEPXC1aeVM655YiiBN/0ZNr7MGjlxk
	 /a5FkKC2iZheaL72rMulfAdPLx8llWbTjyjan6PqTaxrefBskStXoiq7fNYdVVvdnbghu
	 4EgvimiEHsMFPtYyu0y4OyIzEeUh7bBsOY8vTMmh86CxoU2ups/Jiv9HLjeUJtL5kXxZ5
	 v3oGuTdIC5E7QHUdKfuoewW7c0iVcNl8bxKrML5ysJpZMfG5HVHP/xp44h+kDl+ExUHSr
	 5U/FN7J6SlhHmNSmVxUaJENMgS86LucOPjm6X4N71yVgUKe1+vB449loWoHLOB1tj6A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ssSM27rM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80669606A31E;
	Wed, 28 Oct 2026 17:27:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ssSM27rM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D051D1F01825;
	Wed, 28 Oct 2026 17:27:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208468;
	bh=57nDk5gJC4lvaqB4JMPLMSuY9OZ0KBA9GC5/70LtQXk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ssSM27rMoAmP6nXS3yp+7TBZ6ec1H0W7sNQeKPPlnqSmf0fyuaxLkDjjMY+0yKpgT
	 c9lZjICyjDhR0ojxfU161Lja+daZvh4MHmM7Vkp1HzBCUmU/3B05B0nGo1SX8zM22W
	 kmPDUIBxpObbrqTiKL/r8CVWTl5Jpg2eoQsg3zak=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tibor Harcsa <silurust@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 129/516] Bluetooth: btusb: Add IMC Networks QCA9377 to quirks table
Date: Wed, 28 Oct 2026 17:54:41 +0100
Message-ID: <20261028170006.569077828@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tibor Harcsa <silurust@gmail.com>

[ Upstream commit dc16388d45ecbd3be0d8c9424dbbaa2c81806578 ]

Add the USB ID (13d3:3503) for the IMC Networks Qualcomm Atheros
QCA9377 Bluetooth controller to the btusb quirks table. This device
requires Qualcomm Rome firmware and wideband speech support to function
properly; otherwise, BLE scanning fails with HCI unexpected event
opcode 0x2005 errors.

The device reports the following in /sys/kernel/debug/usb/devices:

P:  Vendor=13d3 ProdID=3503 Rev= 0.01
C:* #Ifs= 2 Cfg#= 1 Atr=e0 MxPwr=100mA
I:* If#= 0 Alt= 0 #EPs= 3 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
E:  Ad=81(I) Atr=03(Int.) MxPS=  16 Ivl=1ms
E:  Ad=82(I) Atr=02(Bulk) MxPS=  64 Ivl=0ms
E:  Ad=02(O) Atr=02(Bulk) MxPS=  64 Ivl=0ms
I:* If#= 1 Alt= 0 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
E:  Ad=83(I) Atr=01(Isoc) MxPS=   0 Ivl=1ms
E:  Ad=03(O) Atr=01(Isoc) MxPS=   0 Ivl=1ms
I:  If#= 1 Alt= 1 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
E:  Ad=83(I) Atr=01(Isoc) MxPS=   9 Ivl=1ms
E:  Ad=03(O) Atr=01(Isoc) MxPS=   9 Ivl=1ms
I:  If#= 1 Alt= 2 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
E:  Ad=83(I) Atr=01(Isoc) MxPS=  17 Ivl=1ms
E:  Ad=03(O) Atr=01(Isoc) MxPS=  17 Ivl=1ms
I:  If#= 1 Alt= 3 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
E:  Ad=83(I) Atr=01(Isoc) MxPS=  25 Ivl=1ms
E:  Ad=03(O) Atr=01(Isoc) MxPS=  25 Ivl=1ms
I:  If#= 1 Alt= 4 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
E:  Ad=83(I) Atr=01(Isoc) MxPS=  33 Ivl=1ms
E:  Ad=03(O) Atr=01(Isoc) MxPS=  33 Ivl=1ms
I:  If#= 1 Alt= 5 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
E:  Ad=83(I) Atr=01(Isoc) MxPS=  49 Ivl=1ms
E:  Ad=03(O) Atr=01(Isoc) MxPS=  49 Ivl=1ms

Signed-off-by: Tibor Harcsa <silurust@gmail.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btusb.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index 6dfae55901987..55a54612a59e6 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -302,6 +302,8 @@ static const struct usb_device_id blacklist_table[] = {
 						     BTUSB_WIDEBAND_SPEECH },
 	{ USB_DEVICE(0x13d3, 0x3501), .driver_info = BTUSB_QCA_ROME |
 						     BTUSB_WIDEBAND_SPEECH },
+	{ USB_DEVICE(0x13d3, 0x3503), .driver_info = BTUSB_QCA_ROME |
+						     BTUSB_WIDEBAND_SPEECH },
 
 	/* QCA WCN6855 chipset */
 	{ USB_DEVICE(0x0cf3, 0xe600), .driver_info = BTUSB_QCA_WCN6855 |
-- 
2.53.0



