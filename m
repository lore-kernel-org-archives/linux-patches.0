Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793210726;
	b=GYCEp2LHJNYSxuAM/Pq9lsKnPCWZCSjrR7HpzNbac2lmBqKZPomOlypSsy0OXKuPj5NX
	 YGHHtZqTkEygw31OhlSSfmCs5IeZGt72e8dzNyVAZED67JvYCxkfJjqWML9M9qvFGxjaK
	 4nHxz9+44DGa4tTdHa9Y/xotCBeKXaakzJDRIKvTuliiGtHuhJU6BrkM4BtJAVxX3cNme
	 42LXmDG6v06wIwyRTsNcYZWHLik4XG+cjzNZa3VIBnhIykHNpdaxiVcBpuCmcKfmOBRJg
	 aJ4IdKb4cCltzJ+4b4Blm9ksAbY3hEKR80M+UDiH3O3+CpteLyFBF7qn2RLHmmRz6xA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793210726;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=P0v1Jq8jOiXSh+y/S+XwyAgnUQiISudHgtRsxchiCc4=;
	b=TQL++dckfF813OqjCpJGAMlpCwdg7IqmWN88UyGYoKDJjWOeU8B2+yyzrSdKp+SYbYFR
	 9a4ZEd/0q9jkgNYcmj8ed8+leFQ/75gtNGdZAX7U8naK2JHKo0BBslSLS5+OTXScQvYm8
	 y1XjuvktsjUomB49dEr71zufnh+uW0k5tSpAvR0uURJxeRHeZqxsw7Nh5MhWGvxN8PfRx
	 lgFCCJzlEZfqnxuva8xzAu3gZfvvWY0dZNouWWMshyTs2Fwji11CCE0o+S9bMcSFLPabG
	 VGvjtS4uat0//ZWT1KJZeccjEW+wqf967diYRsd2j1x5qDKUtE8dH9pwK/f58nJDuRQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RNnE3Qo+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70DC2606A31C;
	Wed, 28 Oct 2026 18:05:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RNnE3Qo+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1F251F01829;
	Wed, 28 Oct 2026 18:05:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793210726;
	bh=P0v1Jq8jOiXSh+y/S+XwyAgnUQiISudHgtRsxchiCc4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RNnE3Qo+JS7itJ2BV65kweqsVUMlQF0HW43uBxPj3gJN6Mdm98lr4eBRe/3dV/yzZ
	 0j6DxjymY7KYUP1+BTWI3pj7g+K45kTH4iDc9wE3XD6+xNU1j5Sy8IX1lWYgV6Ht3i
	 sXD3uoSm2PjrVqCtpbBxPrfau4kp359Q5Lpft+oQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tibor Harcsa <silurust@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 125/571] Bluetooth: btusb: Add IMC Networks QCA9377 to quirks table
Date: Wed, 28 Oct 2026 17:54:32 +0100
Message-ID: <20261028170010.985425848@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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
index d6a89d6604c7b..6620db5205684 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -301,6 +301,8 @@ static const struct usb_device_id blacklist_table[] = {
 						     BTUSB_WIDEBAND_SPEECH },
 	{ USB_DEVICE(0x13d3, 0x3501), .driver_info = BTUSB_QCA_ROME |
 						     BTUSB_WIDEBAND_SPEECH },
+	{ USB_DEVICE(0x13d3, 0x3503), .driver_info = BTUSB_QCA_ROME |
+						     BTUSB_WIDEBAND_SPEECH },
 
 	/* QCA WCN6855 chipset */
 	{ USB_DEVICE(0x0cf3, 0xe600), .driver_info = BTUSB_QCA_WCN6855 |
-- 
2.53.0



