Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9551930DD36;
	Sat, 25 Oct 2025 16:23:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761409423; cv=none; b=TUWGwPdRqNxxxMcIv4cfe4V3xtIJmZM90Cjqm4vaEYdiILznVBdb5B4V/o4+U5mA/vuMc2C6AZ/USL9v9WHJ7cK2bLS2pm6tC7+vRW1O3SdHOoVpPibkrS+DDtmHOVtVBsjApmj0uViwtUAzULvKfA02RAbHkcolsPS/OpNKKLQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761409423; c=relaxed/simple;
	bh=dVIj/Jzrg38NOB9dFskUPH1WhSVl2WkINUH0kBi6Y3M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gzuwLs2FiHTh9Oa3aZTgRjcsBf27h12w013LvLzjhSwXqUByZjZSFUyLvG1rtXKi0QQgtJSxBpN/OJJBcmzNHDARLjbDEb27qIAiWOHsKMUsIOogQhciQp16fuDb2NSmIEHO8gcQAxKO/pKSVN4nI0XEx45jCOk3HvpiBQH6mJU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WPfveNjS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WPfveNjS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14E82C4CEF5;
	Sat, 25 Oct 2025 16:23:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761409423;
	bh=dVIj/Jzrg38NOB9dFskUPH1WhSVl2WkINUH0kBi6Y3M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WPfveNjSBueBaWFb0OLfhNDzpMHerAtTft0y+fRqYuasOMXg9V0MD5/vZokyl0HfU
	 8adtY/6GsHJ5UGnzsgbV/pBF/0BmD3J3mrjRynIiSEt6LIecBP8BO2GVS/l3UTOm5+
	 serPM50Z2W79xa0WvdbZM8b1+Ru0D7plRcAmROi78kIs+ivZF9Uokabegs0wt0yS3i
	 flHWHDYfOY3fmUD1/GfsoPeWO3mstSKmLn6YSyTfWa3Or5dofutze+X3Ch3cYjWy3+
	 V02V8tC4A4Dm8HvZaoLCwghNfYLOjd5q40POafBzDkr/F32EEdm9NB93y0rYy0w9DU
	 Nn/ti6AXkMqQA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Chris Lu <chris.lu@mediatek.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	marcel@holtmann.org,
	luiz.dentz@gmail.com,
	matthias.bgg@gmail.com,
	angelogioacchino.delregno@collabora.com,
	linux-bluetooth@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org
Subject: [PATCH AUTOSEL 6.17] Bluetooth: btusb: Add new VID/PID 13d3/3627 for MT7925
Date: Sat, 25 Oct 2025 11:59:10 -0400
Message-ID: <20251025160905.3857885-319-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251025160905.3857885-1-sashal@kernel.org>
References: <20251025160905.3857885-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Chris Lu <chris.lu@mediatek.com>

[ Upstream commit 576952cf981b7d2b7d3227b246b4326e5548a133 ]

Add VID 13d3 & PID 3627 for MediaTek MT7922 USB Bluetooth chip.

The information in /sys/kernel/debug/usb/devices about the Bluetooth
device is listed as the below.

T:  Bus=07 Lev=01 Prnt=01 Port=00 Cnt=01 Dev#=  2 Spd=480  MxCh= 0
D:  Ver= 2.10 Cls=ef(misc ) Sub=02 Prot=01 MxPS=64 #Cfgs=  1
P:  Vendor=13d3 ProdID=3627 Rev= 1.00
S:  Manufacturer=MediaTek Inc.
S:  Product=Wireless_Device
S:  SerialNumber=000000000
C:* #Ifs= 3 Cfg#= 1 Atr=e0 MxPwr=100mA
A:  FirstIf#= 0 IfCount= 3 Cls=e0(wlcon) Sub=01 Prot=01
I:* If#= 0 Alt= 0 #EPs= 3 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
E:  Ad=81(I) Atr=03(Int.) MxPS=  16 Ivl=125us
E:  Ad=82(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=02(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
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
I:  If#= 1 Alt= 6 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
E:  Ad=83(I) Atr=01(Isoc) MxPS=  63 Ivl=1ms
E:  Ad=03(O) Atr=01(Isoc) MxPS=  63 Ivl=1ms
I:* If#= 2 Alt= 0 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=(none)
E:  Ad=8a(I) Atr=03(Int.) MxPS=  64 Ivl=125us
E:  Ad=0a(O) Atr=03(Int.) MxPS=  64 Ivl=125us
I:  If#= 2 Alt= 1 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=(none)
E:  Ad=8a(I) Atr=03(Int.) MxPS= 512 Ivl=125us
E:  Ad=0a(O) Atr=03(Int.) MxPS= 512 Ivl=125us

Signed-off-by: Chris Lu <chris.lu@mediatek.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES – adding the new 13d3:3627 USB ID simply lets existing MT7925
hardware bind to the driver and reuses already‑shipped logic without
introducing risk.

**Key Points**
- The change only inserts one more MediaTek MT7925 entry in the btusb
  quirks table (`drivers/bluetooth/btusb.c:740`), matching the flags
  used for every other MT7925 board ID right above it
  (`drivers/bluetooth/btusb.c:730-744`). This is a classic stable-
  friendly hardware enablement fix: without it the adapter enumerates
  but never loads the btusb driver, so end users have a non‑functional
  Bluetooth stack.
- The added ID inherits the well-tested BTUSB_MEDIATEK and
  BTUSB_WIDEBAND_SPEECH flow; the probe path for those flags (e.g.
  `drivers/bluetooth/btusb.c:4053-4168`) already handles MT7925
  variants, so no new code paths or quirk differences are introduced.
- Prior commits in this area repeatedly add individual VID/PID pairs for
  the same chipset with no regressions, confirming this is a routine,
  low-risk extension of the table rather than new functionality.

Given the user-visible failure it resolves, the contained nature of the
change, and the absence of architectural churn, this commit meets the
stable backport criteria. Plugging the device on a stable kernel with
the backport should be the only validation needed.

 drivers/bluetooth/btusb.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index 3595a8bad6bdf..30679a572095c 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -734,6 +734,8 @@ static const struct usb_device_id quirks_table[] = {
 						     BTUSB_WIDEBAND_SPEECH },
 	{ USB_DEVICE(0x13d3, 0x3613), .driver_info = BTUSB_MEDIATEK |
 						     BTUSB_WIDEBAND_SPEECH },
+	{ USB_DEVICE(0x13d3, 0x3627), .driver_info = BTUSB_MEDIATEK |
+						     BTUSB_WIDEBAND_SPEECH },
 	{ USB_DEVICE(0x13d3, 0x3628), .driver_info = BTUSB_MEDIATEK |
 						     BTUSB_WIDEBAND_SPEECH },
 	{ USB_DEVICE(0x13d3, 0x3630), .driver_info = BTUSB_MEDIATEK |
-- 
2.51.0

