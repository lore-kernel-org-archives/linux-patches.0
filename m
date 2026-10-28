Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212584;
	b=j86CY+l20ymBqeWwJtUbbc7P9+zUJrgLp1SqsFtw7P4YoHKpOenDGu2levTV1BzCoVBN
	 cufCTZtbNCCH0GCHAsMYnmvqo+lsDtf1HxAFWdHzubrgW+pIe1QFQk1RcJkyRoMpCUEl9
	 RjrgxT8+R13Lbwq2qYi2RPB8RPKU3qnHwlvL0rtnX+L8wTTnaphiGvisEdil5gufVQwG7
	 1GbXRSYD0N+D8qXswZ1LEI2RkTaWf5Ghvpc5uS2mfudd+3FC3PFZeQXh4X9P64P6QET4P
	 5ZZCd3y9RPy/3Tvl7kh/bKdvoCq3JvFV90u1ClJEfdfS/VqsZExNFAxYdRkgNTphdPQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212584;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=advfw/3GHcR5Ao89+g7jBdsDuH8Tg9DQHG1fBoWcyZo=;
	b=T/rL6WcLfxnpcugo//2PUiBFBXyVobaCh6N3dQvZ+YVEGPoa7YiqqDPmffeFJCR8Puxd
	 cq2fEkZWJtDSxZDV17hfEtPf+oDhJbLVO/vPH0rYV0mO8OmLR5IAF5WGnglZwnuWluor4
	 KF9Xzt0YvNQQ/EfXIsu/vTz5yNTq3PqctV2ZLTOG1kxvO1PjUH332/JkGUDcaZsQwXTgg
	 cRCi1AcW2PRQHV/hk4lc1iS92IHeI6lqWLhHtP35+HNAPdc8YFd6ObTRZCTLjsV2G/dnq
	 K9U9ydSGkL97oxK56br/tv9X0Dfgu/pQ8m+Yd3llKb/EPsfbd17zfotBpExPLBY6yZA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nNehoBg7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D458E606A31D;
	Wed, 28 Oct 2026 18:36:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nNehoBg7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30AFB1F01825;
	Wed, 28 Oct 2026 18:36:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212583;
	bh=advfw/3GHcR5Ao89+g7jBdsDuH8Tg9DQHG1fBoWcyZo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nNehoBg7GK9zjFMIMVEIaV+a93fn4+PUB9nP0MoIhzgHzednaYAOoIjxPNgSHJTix
	 xMDT+yMWhpqezUxBOKjVPflMtz6s2p0ERjb+vh5h+HBOZt+WL9F1aTcuD0ClpU1r9y
	 fEiOew31z1K6y7cePk9HmskH+7QDGah9IdrLNYtY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tibor Harcsa <silurust@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0161/1887] Bluetooth: btusb: Add IMC Networks QCA9377 to quirks table
Date: Wed, 28 Oct 2026 17:37:37 +0100
Message-ID: <20261028170502.898674579@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 3c1d6a711338d..3ffe8e3bcac9a 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -304,6 +304,8 @@ static const struct usb_device_id blacklist_table[] = {
 						     BTUSB_WIDEBAND_SPEECH },
 	{ USB_DEVICE(0x13d3, 0x3501), .driver_info = BTUSB_QCA_ROME |
 						     BTUSB_WIDEBAND_SPEECH },
+	{ USB_DEVICE(0x13d3, 0x3503), .driver_info = BTUSB_QCA_ROME |
+						     BTUSB_WIDEBAND_SPEECH },
 
 	/* QCA WCN6855 chipset */
 	{ USB_DEVICE(0x0cf3, 0xe600), .driver_info = BTUSB_QCA_WCN6855 |
-- 
2.53.0



