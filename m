Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AD13313E31
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:52:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301121; cv=none; b=pgIpP5dPx+mLtEVe4FtxH6xu/whXM4GEHZadL/FL/kYuQyW/Gu+w099d+pTZPMCb0G6kOmQnOE6z7nPxcccX0oiqkhCeOVAGGg9aqpovdRTd8fdGUSvfWAHhSHS+S+7HpHhd03ukiNAUmJ/TaJfONNKTz5QXJsbgrfTMb2o1Yt8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301121; c=relaxed/simple;
	bh=CLLuMZj6sIoa7VbhMD2iLW0toeLneMplK5pMfpFvLDw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ME7n3y2z6Tjk20EeR/N7QujXhiZlqqHU5QRNfF7/WBsYqee9ykLgnRw4tHJtxdFHmL6wEYUAAbF+dDiUbQknvGPzUBLOWKEkDsnlDawBLej+F0Q86TN7H0ZOIL1XM2Pixr6RmQKTltHUGSnb0OTp0cLEwjffkptTxtBWnXKEBZc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CtPOAuvN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CtPOAuvN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40287C19425;
	Sat, 28 Feb 2026 17:52:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301120;
	bh=CLLuMZj6sIoa7VbhMD2iLW0toeLneMplK5pMfpFvLDw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CtPOAuvNAc9M8A7lTyuzBM0UeX6dQJd7N0bROODwqKeno10ApiexT4EfJPHjOLZj4
	 tzBMDs5CVw3v/PLPDbQYPoN/ep9RWmxKWxGjRicKfdvzBELExkKEf8wycThHYhNUqc
	 ZvTZvlx3JjdRPmBPmouOj0c6PaU4r4R8J6BOM39XVBfzxVMPrSY0FqF98bybCCSmvc
	 RspN1Herd06UMMPNISm9aP1IbvOqnJvuMfQKrDA3unrgVosMse6oYgAyD1qTq9Ds0q
	 jGhgrziAaHgWx9FOpFqgkTdX+PyoREk4RRPOEWMpbkD5R5yC9pY/D0B09CMrXmrleN
	 8XxJ8iKNeZ1vg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Shell Chen <w27@sorz.org>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 278/752] Bluetooth: btusb: Add new VID/PID for RTL8852CE
Date: Sat, 28 Feb 2026 12:39:49 -0500
Message-ID: <20260228174750.1542406-278-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Shell Chen <w27@sorz.org>

[ Upstream commit d9f7c39c6b7548bd70519b241b6c2d1bcc658d4b ]

Add VID:PID 13d3:3612 to the quirks_table.

This ID pair is found in the Realtek RTL8852CE PCIe module
in an ASUS TUF A14 2025 (FA401KM) laptop.

Tested on aforementioned laptop.

The device info from /sys/kernel/debug/usb/devices is listed as below.

T:  Bus=03 Lev=01 Prnt=01 Port=04 Cnt=01 Dev#=  2 Spd=12   MxCh= 0
D:  Ver= 1.00 Cls=e0(wlcon) Sub=01 Prot=01 MxPS=64 #Cfgs=  1
P:  Vendor=13d3 ProdID=3612 Rev= 0.00
S:  Manufacturer=Realtek
S:  Product=Bluetooth Radio
S:  SerialNumber=00e04c000001
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

Signed-off-by: Shell Chen <w27@sorz.org>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btusb.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index 4c802b0f2f516..b70cc8d5e0389 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -561,6 +561,8 @@ static const struct usb_device_id quirks_table[] = {
 						     BTUSB_WIDEBAND_SPEECH },
 	{ USB_DEVICE(0x13d3, 0x3592), .driver_info = BTUSB_REALTEK |
 						     BTUSB_WIDEBAND_SPEECH },
+	{ USB_DEVICE(0x13d3, 0x3612), .driver_info = BTUSB_REALTEK |
+						     BTUSB_WIDEBAND_SPEECH },
 	{ USB_DEVICE(0x0489, 0xe122), .driver_info = BTUSB_REALTEK |
 						     BTUSB_WIDEBAND_SPEECH },
 
-- 
2.51.0

