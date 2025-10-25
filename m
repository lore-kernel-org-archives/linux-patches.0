Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48D513043D3;
	Sat, 25 Oct 2025 16:09:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761408555; cv=none; b=hTaLBcmdggmyxLnURhCM36B7zfQAeeKQUHMoce+y+PnyyrhPdJMGVmWOD7/CytTQVBSu5lyc16l1eelxINKyCVV1+QiclQJ0YTbDr3MunWsXxPNSI/jPY5LC/EXgHtJHbq4aSfUfjCSKHqlVfS++s9c6BH2i3t2mbTiVL3LcgAc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761408555; c=relaxed/simple;
	bh=icD1TZNA1EsLuesdMyVBsqPYejWcRPtFGUvapHk92HI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bb35cKMclc6VwxsEGVOd2NKGn27um8TK3DGh7WcacmO+9PqfiJTY84UPZ0+wqjDtytpC24B8QpsPtVsv6PeMtQvVnFgVkknjyNgE4zQzFAI6dDkpR62uGYXaNsUz0XzBz0qASAtslLcADiHVqyLdj6S9Zymtq0sEIjJezeJEgWo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HUK+21xA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HUK+21xA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8376C113D0;
	Sat, 25 Oct 2025 16:09:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761408555;
	bh=icD1TZNA1EsLuesdMyVBsqPYejWcRPtFGUvapHk92HI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HUK+21xAk0VU7vPmZYFfWHG0duvuP1r1dYAv9rOg2N8+xsRzWP/6XRVX2T8W6DGnC
	 jYatBumvwSLkpMVvkf90x6+6R+JNY4OaYeOexLraR+x/4LCjwje8tIKYclEPJ1YWOz
	 snv5ySnTJ2lD2BT9cisZbSbn0F09MV7Pi3PNyIsUdJg7k6xAUdQ21h9aQl698cZQaI
	 ZMJ3QOZ0StdFx+NfkSDBrJh9MgPfDglSK9PXtwtcGzSDzp2qHaDhBgpKkqZ5ZbpNMF
	 RYF8s+d4icd5KvH7ck8NhExUU8tfj5172yV42IG7sl/ICOobEHeuntW0Uxl61pCuNi
	 wSvnYeSdDAdow==
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
Subject: [PATCH AUTOSEL 6.17-6.12] Bluetooth: btusb: Add new VID/PID 13d3/3633 for MT7922
Date: Sat, 25 Oct 2025 11:53:56 -0400
Message-ID: <20251025160905.3857885-5-sashal@kernel.org>
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
Content-Transfer-Encoding: 8bit

From: Chris Lu <chris.lu@mediatek.com>

[ Upstream commit 70cd38d22d4659ca8133c7124528c90678215dda ]

Add VID 13d3 & PID 3633 for MediaTek MT7922 USB Bluetooth chip.

The information in /sys/kernel/debug/usb/devices about the Bluetooth
device is listed as the below.

T:  Bus=06 Lev=01 Prnt=01 Port=00 Cnt=01 Dev#=  2 Spd=480  MxCh= 0
D:  Ver= 2.10 Cls=ef(misc ) Sub=02 Prot=01 MxPS=64 #Cfgs=  1
P:  Vendor=13d3 ProdID=3633 Rev= 1.00
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

YES
- `drivers/bluetooth/btusb.c:704` adds the IMC Networks VID/PID pair
  `13d3:3633` to `quirks_table` with the existing `BTUSB_MEDIATEK |
  BTUSB_WIDEBAND_SPEECH` flags, so the MT7922-based dongle can be
  recognized as an already-supported MediaTek device variant.
- During probe, devices that match `quirks_table` inherit the
  `driver_info` bits (`drivers/bluetooth/btusb.c:3962-3968`); without
  this entry the new dongle only matches the generic class entry, leaves
  `driver_info` zero, and skips all MediaTek-specific handling.
- The MediaTek flag is what triggers allocation of the vendor private
  data and wires up the MTK callbacks
  (`drivers/bluetooth/btusb.c:4055-4160`), including `btusb_mtk_setup`,
  suspend/resume hooks, and the wideband speech capability
  (`drivers/bluetooth/btusb.c:4255-4256`). Missing those pieces is known
  to make MT79xx adapters either fail to initialize or lose SCO/WBS
  features, so the absence manifests as a real user-visible regression
  on that hardware.
- Change scope is limited to a single new table entry, touching no
  shared logic, so regression risk is negligible while fixing a concrete
  compatibility problem; identical patches for neighboring MT7922/MT7925
  IDs already live in stable kernels, making this consistent with past
  backports.

 drivers/bluetooth/btusb.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index b231caa84757c..5e9ebf0c53125 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -701,6 +701,8 @@ static const struct usb_device_id quirks_table[] = {
 						     BTUSB_WIDEBAND_SPEECH },
 	{ USB_DEVICE(0x13d3, 0x3615), .driver_info = BTUSB_MEDIATEK |
 						     BTUSB_WIDEBAND_SPEECH },
+	{ USB_DEVICE(0x13d3, 0x3633), .driver_info = BTUSB_MEDIATEK |
+						     BTUSB_WIDEBAND_SPEECH },
 	{ USB_DEVICE(0x35f5, 0x7922), .driver_info = BTUSB_MEDIATEK |
 						     BTUSB_WIDEBAND_SPEECH },
 
-- 
2.51.0

