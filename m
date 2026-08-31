Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80318589CDF;
	Mon, 31 Aug 2026 13:50:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184226; cv=none; b=jzd2gAVt8k6TH7jobxpKZBVcUAqPAb2Vb9wL1TlCBglmW04IcKte+JCsZtYdjBu2Gf60zwkm8hur8/nyM+pxoyFnhA38AgrDJKOcKYzXcZGs9r7WoumRetVy2HX+pL00+7oNCMFDJVXV6fsu5XcORicM91M4r0rpRO4D2+ukL0k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184226; c=relaxed/simple;
	bh=55LmMl97cgvBRzMHgZgnnNA51Ls3d6RP9FfMMRxgibs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fey8qZh6WQGb7SX+Owid9hB07b2+hVR5z7HSwULY7lLfvhLnNX0rJpU99Udn8mzWp4g1S8Vcfx4cB3qZarQDLKfSCH3tTFuyWda4RAXCTXTv32sV2uBBUpUhRR1T3t8wo7uk93IIYmemtA8Sznxv3bj9BqNIU89AIpEzslmrPuk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=avwRCUya; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="avwRCUya"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 531B31F00ADE;
	Mon, 31 Aug 2026 13:50:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788184223;
	bh=2IkytGnHzb0jbOto/foUYpjdJWqvC7pRB2Kl+nyg90A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=avwRCUyaXmhRl18JSL0OlT+N+l3ycVIoBSrzlJLdaAfSsWdCQGbrIuYA0GSOdIIrv
	 vkdw7FAyNigUvwL40ZPKmL7K4pygX2W7PqrPyTAc6g8wzqvDlAMWchfDd3B/ck0mMT
	 lSSra9HLO2DGv1zrbznESwnJvK8dBbG9LP+LSIgsoUz5lL5LQBVh9CmnO9UUrB7ahs
	 RSJp+jTB+NgEISDT8STqBFF7aAk5dibiI+w0fiWCSS66ASzCsINcR/+wqFM/6pcFmF
	 RnwnBbqPEYg8Yw7XfpTwBEVgbIIwxacErw0JDLumenMLD/7blKwNElAyf4lNsJn8kv
	 CuiDD90ztkdjA==
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
Subject: [PATCH AUTOSEL 6.18-6.12] Bluetooth: btusb: Add Realtek RTL8922AE VID/PID 0bda/d922
Date: Mon, 31 Aug 2026 09:29:53 -0400
Message-ID: <20260831133314.4125787-565-sashal@kernel.org>
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

[ Upstream commit 480dcc68f2826a9768e6fc9e81f02078c1ed0e01 ]

Add the vendor/product ID (0x0bda, 0xd922) to usb_device_id table for
Realtek RTL8922AE.

The device info from /sys/kernel/debug/usb/devices as below.

T:  Bus=10 Lev=01 Prnt=01 Port=00 Cnt=01 Dev#=  2 Spd=12   MxCh= 0
D:  Ver= 1.00 Cls=e0(wlcon) Sub=01 Prot=01 MxPS=64 #Cfgs=  1
P:  Vendor=0bda ProdID=d922 Rev= 0.00
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

The backport analysis is done.

**Verdict: YES** for **linux-6.18.y** (v6.18.44).

This adds USB ID `0x0bda/0xd922` for Realtek RTL8922AE to
`quirks_table[]` in btusb — a 2-line device-ID addition, same pattern as
the existing `0x8922` entry. RTL8922A support is already in this tree;
the patch applies cleanly; maintainer-reviewed.

The follow-up repo searches didn’t change that: broad `--grep="d922"`
hits were mostly false positives (hash substrings), and the exact commit
(`480dcc68f2826`) lives on `autosel`, not on the current stable
checkout.

 drivers/bluetooth/btusb.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index 2f7ff83ee78ca..6d4c5d75cfc61 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -602,6 +602,8 @@ static const struct usb_device_id quirks_table[] = {
 	/* Realtek 8922AE Bluetooth devices */
 	{ USB_DEVICE(0x0bda, 0x8922), .driver_info = BTUSB_REALTEK |
 						     BTUSB_WIDEBAND_SPEECH },
+	{ USB_DEVICE(0x0bda, 0xd922), .driver_info = BTUSB_REALTEK |
+						     BTUSB_WIDEBAND_SPEECH },
 	{ USB_DEVICE(0x13d3, 0x3617), .driver_info = BTUSB_REALTEK |
 						     BTUSB_WIDEBAND_SPEECH },
 	{ USB_DEVICE(0x13d3, 0x3616), .driver_info = BTUSB_REALTEK |
-- 
2.53.0

