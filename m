Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1525B4B1B5F;
	Mon, 31 Aug 2026 13:50:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184258; cv=none; b=mrL15rroRDcrr35ybrKmxcf2Dt/pePct2A20Ce2nxZRfMr4sTw1BUh1pvq5fcfa0V0n3vWX7qnAONs7cw76WE3QZMSiWjiSGompSPqtZT7SS7F//hFHngolBRtGgicn3xRaHto+DQ8QSDgDubudTQLk8X7sqDm6yC26NdDySccU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184258; c=relaxed/simple;
	bh=3ZV2+Pw7D9VzpYokzAPv0U41nDw8ubdgNTkOD043wYQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SPfj/DckBwUm0uze+R78AbQUU2eCr1t38h5QR8P0haxjgaa5T2YJ4/VhUBQmLd5XgFL4nwwN1JiX7Gb5UL1dhGnGAtbJx6VUdePsar74050AgLtAyvkpOBmzOGuVWHLhTsXI0GvvulWqq+I5dShxdywvNswHvbUa8sJQVJk9An0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dL5CF+cR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dL5CF+cR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA26A1F00ACF;
	Mon, 31 Aug 2026 13:50:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788184256;
	bh=BasNP7Rq1MiEoMB6w7glWy4aVMfvxmmw0zVRrfeVddw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dL5CF+cRmbgmXPV6CPXbx0tvuWV/6SWIbfQ+JKumumcYqRrCNnhzuaqjayXvxq2Di
	 1+fjc18+hYp/am8Cfb8GQq9gQfxu15aRhulAVMaNix449k4bWXXqYaO3SEtPuTNHQo
	 Ztuu9C/qs1VS3AFWlppKFoR0JNuKiIcRBNezMXN6OcDN1ScTlpV3JlmIPrpsC8gBXI
	 94bkuYgO7OtdGorryfUYZfwL6s8ucc0ukoZQ0qLmNGac0YAOFPNvxWNBPYpCncrfjg
	 SqlV3p4qjmEdGSC5lKxDYJzLZvzV5+FI2RfcijD/bggPXGSXpo9ROaluFEuURv55sf
	 sqzUvOS881Wsg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Chen Zhang <zhangchen01@kylinos.cn>,
	Paul Menzel <pmenzel@molgen.mpg.de>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	marcel@holtmann.org,
	luiz.dentz@gmail.com,
	linux-bluetooth@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.12] Bluetooth: btusb: Add Realtek RTL8922AE VID/PID 0bda/d923
Date: Mon, 31 Aug 2026 09:30:13 -0400
Message-ID: <20260831133314.4125787-585-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260831133314.4125787-1-sashal@kernel.org>
References: <20260831133314.4125787-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.48
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Chen Zhang <zhangchen01@kylinos.cn>

[ Upstream commit 5612ee230a33c450976c3bcaea174f1d816a2697 ]

Add the vendor/product ID (0x0bda, 0xd923) to usb_device_id table for
Realtek RTL8922AE.

The device info from /sys/kernel/debug/usb/devices as below.

T:  Bus=10 Lev=01 Prnt=01 Port=00 Cnt=01 Dev#=  2 Spd=12   MxCh= 0
D:  Ver= 1.00 Cls=e0(wlcon) Sub=01 Prot=01 MxPS=64 #Cfgs=  1
P:  Vendor=0bda ProdID=d923 Rev= 0.00
S:  Manufacturer=Realtek
S:  Product=Bluetooth Radio
S:  SerialNumber=00E04C885A01
C:* #Ifs= 2 Cfg#= 1 Atr=e0 MxPwr=500mA
I:* If#= 0 Alt= 0 #EPs= 3 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
E:  Ad=81(I) Atr=03(Int.) MxPS=  16 Ivl=1ms
E:  Ad=02(O) Atr=02(Bulk) MxPS=  64 Ivl=0ms
E:  Ad=82(I) Atr=02(Bulk) MxPS=  64 Ivl=0ms
I:* If#= 1 Alt= 0 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
E:  Ad=03(O) Atr=01(Isoc) MxPS=   0 Ivl=1ms
E:  Ad=83(I) Atr=01(Isoc) MxPS=   0 Ivl=1ms
I:  If#= 1 Alt= 1 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
E:  Ad=03(O) Atr=01(Isoc) MxPS=   9 Ivl=1ms
E:  Ad=83(I) Atr=01(Isoc) MxPS=   9 Ivl=1ms
I:  If#= 1 Alt= 2 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
E:  Ad=03(O) Atr=01(Isoc) MxPS=  17 Ivl=1ms
E:  Ad=83(I) Atr=01(Isoc) MxPS=  17 Ivl=1ms
I:  If#= 1 Alt= 3 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
E:  Ad=03(O) Atr=01(Isoc) MxPS=  25 Ivl=1ms
E:  Ad=83(I) Atr=01(Isoc) MxPS=  25 Ivl=1ms
I:  If#= 1 Alt= 4 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
E:  Ad=03(O) Atr=01(Isoc) MxPS=  33 Ivl=1ms
E:  Ad=83(I) Atr=01(Isoc) MxPS=  33 Ivl=1ms
I:  If#= 1 Alt= 5 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
E:  Ad=03(O) Atr=01(Isoc) MxPS=  49 Ivl=1ms
E:  Ad=83(I) Atr=01(Isoc) MxPS=  49 Ivl=1ms
I:  If#= 1 Alt= 6 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
E:  Ad=03(O) Atr=01(Isoc) MxPS=  63 Ivl=1ms
E:  Ad=83(I) Atr=01(Isoc) MxPS=  63 Ivl=1ms

Signed-off-by: Chen Zhang <zhangchen01@kylinos.cn>
Reviewed-by: Paul Menzel <pmenzel@molgen.mpg.de>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Connection lost, reconnecting to https://agentn.us.api5.cursor.sh
(attempt 1)...
Retry attempt 1...
Connection lost, reconnecting to https://agentn.us.api5.cursor.sh
(attempt 2)...
Retry attempt 2...
**Verdict: YES** — backport to 6.18.y.

This is a 2-line USB device ID addition (`0x0bda:0xd923`) to the
existing `btusb` driver for Realtek RTL8922AE hardware. It fits the
standard stable exception for new device IDs: small, obviously correct,
and the prerequisites are already in your tree (RTL8922A support in
`btrtl.c`, the 8922AE quirks section in `btusb.c`).

Confirmed: neither `0xd922` nor `0xd923` is present in 6.18.44 yet. The
patch should apply cleanly by inserting the new entry after the existing
`0x8922` line rather than after `0xd922` (which mainline has but this
tree doesn't).

 drivers/bluetooth/btusb.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index 38a066cc3404a..502b2984d994a 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -604,6 +604,8 @@ static const struct usb_device_id quirks_table[] = {
 						     BTUSB_WIDEBAND_SPEECH },
 	{ USB_DEVICE(0x0bda, 0xd922), .driver_info = BTUSB_REALTEK |
 						     BTUSB_WIDEBAND_SPEECH },
+	{ USB_DEVICE(0x0bda, 0xd923), .driver_info = BTUSB_REALTEK |
+						     BTUSB_WIDEBAND_SPEECH },
 	{ USB_DEVICE(0x13d3, 0x3617), .driver_info = BTUSB_REALTEK |
 						     BTUSB_WIDEBAND_SPEECH },
 	{ USB_DEVICE(0x13d3, 0x3616), .driver_info = BTUSB_REALTEK |
-- 
2.53.0

