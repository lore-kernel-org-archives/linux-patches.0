Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BB4A50AC38;
	Thu, 17 Sep 2026 17:10:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789665039; cv=none; b=ia31cq1tG8BU3uCsXg6dm4oO284sH0NE8PB4U+wUUgsGWeFaM64NcLfq9+3pPp/wdkXhudyAUE/7vPtI+dQHO3dIJU6kgbp2K3Kj27cG6a1/kmzJ+xJ1PxxwSNM72dh0YWAbrBVV0QDOJZ8O8Nd6AlPvTF4IdWwZ6mO/Ihr6Fwo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789665039; c=relaxed/simple;
	bh=wJnIgDtxJ2PFiZ8bnJjdbj+LHoZQXLXf9V2AyiaIkN4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kgRE5O1UdqgClRrhKudgqU3Os9GjULC86vM5W6Vz+YIGKoPjV62Fgskkzk4yk9QD5Vye50mX2JzfxgOAkAq/u4eZVxzCWXIqqElfOaduKnQlVaVROIAxJ06YzxDON8pSSC/AMLcVknFmtZmu2own7agd2ZTsWtUb3csW7U4urWs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IlwW9i0q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IlwW9i0q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 774171F000FF;
	Thu, 17 Sep 2026 17:10:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789665038;
	bh=TtzPzMsp1Y7bHQW5ms3Q9X+1yfJ7/nc6O6S4GX5iLe8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IlwW9i0q3l6ElyJAvveaLlUjs6aW4zwJr7y4ehhJ3abjvM5Jlt2nyunCDz4vWJv0w
	 sZvj5W2LYmhaA3DRxVGDG9IucdaRHfQWYewwsDyGZjTubNZYfPSDW1vJWwgoNJiAHW
	 E3rUApAZjDmHO2mxyj52r4xfTznHQG4e+zpZyJEQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Max Chou <max.chou@realtek.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0573/1250] Bluetooth: btrtl: Add the support for RTL8761CUV
Date: Thu, 17 Sep 2026 16:06:08 +0100
Message-ID: <20260917151607.438465538@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Max Chou <max.chou@realtek.com>

[ Upstream commit 4a23ce935f74d19df48d1906497fad1cef391392 ]

Add support for RTL8761CUV BT controller on the USB interface.
Do not apply IC_MATCH_FL_HCIVER when hci_ver is 0 in the ic_id_table.

The device info from /sys/kernel/debug/usb/devices as below.

T:  Bus=02 Lev=01 Prnt=01 Port=00 Cnt=01 Dev#= 13 Spd=12   MxCh= 0
D:  Ver= 1.10 Cls=e0(wlcon) Sub=01 Prot=01 MxPS=64 #Cfgs=  1
P:  Vendor=0bda ProdID=c761 Rev= 2.00
S:  Manufacturer=Realtek
S:  Product=Bluetooth Controller
S:  SerialNumber=10000
C:* #Ifs= 2 Cfg#= 1 Atr=a0 MxPwr=100mA
I:* If#= 0 Alt= 0 #EPs= 3 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
E:  Ad=81(I) Atr=03(Int.) MxPS=  64 Ivl=1ms
E:  Ad=02(O) Atr=02(Bulk) MxPS=  64 Ivl=0ms
E:  Ad=82(I) Atr=02(Bulk) MxPS=  64 Ivl=0ms
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

Signed-off-by: Max Chou <max.chou@realtek.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btrtl.c | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/drivers/bluetooth/btrtl.c b/drivers/bluetooth/btrtl.c
index a62eae7276d64..c860358b53010 100644
--- a/drivers/bluetooth/btrtl.c
+++ b/drivers/bluetooth/btrtl.c
@@ -72,6 +72,7 @@ enum btrtl_chip_id {
 	CHIP_ID_8851B = 36,
 	CHIP_ID_8922A = 44,
 	CHIP_ID_8852BT = 47,
+	CHIP_ID_8761C = 51,
 };
 
 struct id_table {
@@ -230,6 +231,14 @@ static const struct id_table ic_id_table[] = {
 	  .cfg_name = "rtl_bt/rtl8761bu_config",
 	  .hw_info  = "rtl8761bu" },
 
+	/* 8761CU */
+	{ IC_INFO(RTL_ROM_LMP_8761A, 0x0e, 0, HCI_USB),
+	  .config_needed = false,
+	  .has_rom_version = true,
+	  .fw_name  = "rtl_bt/rtl8761cu_fw",
+	  .cfg_name = "rtl_bt/rtl8761cu_config",
+	  .hw_info  = "rtl8761cu" },
+
 	/* 8822C with UART interface */
 	{ IC_INFO(RTL_ROM_LMP_8822B, 0xc, 0x8, HCI_UART),
 	  .config_needed = true,
@@ -344,7 +353,8 @@ static const struct id_table *btrtl_match_ic(u16 lmp_subver, u16 hci_rev,
 		    (ic_id_table[i].hci_rev != hci_rev))
 			continue;
 		if ((ic_id_table[i].match_flags & IC_MATCH_FL_HCIVER) &&
-		    (ic_id_table[i].hci_ver != hci_ver))
+		    (ic_id_table[i].hci_ver != hci_ver) &&
+		    (ic_id_table[i].hci_ver != 0))
 			continue;
 		if ((ic_id_table[i].match_flags & IC_MATCH_FL_HCIBUS) &&
 		    (ic_id_table[i].hci_bus != hci_bus))
@@ -662,6 +672,7 @@ static int rtlbt_parse_firmware(struct hci_dev *hdev,
 		{ RTL_ROM_LMP_8851B, 36 },	/* 8851B */
 		{ RTL_ROM_LMP_8922A, 44 },	/* 8922A */
 		{ RTL_ROM_LMP_8852A, 47 },	/* 8852BT */
+		{ RTL_ROM_LMP_8761A, 51 },	/* 8761C */
 	};
 
 	if (btrtl_dev->fw_len <= 8)
@@ -1306,6 +1317,7 @@ void btrtl_set_quirks(struct hci_dev *hdev, struct btrtl_device_info *btrtl_dev)
 	case CHIP_ID_8851B:
 	case CHIP_ID_8922A:
 	case CHIP_ID_8852BT:
+	case CHIP_ID_8761C:
 		hci_set_quirk(hdev, HCI_QUIRK_WIDEBAND_SPEECH_SUPPORTED);
 
 		/* RTL8852C needs to transmit mSBC data continuously without
@@ -1525,6 +1537,8 @@ MODULE_FIRMWARE("rtl_bt/rtl8761b_fw.bin");
 MODULE_FIRMWARE("rtl_bt/rtl8761b_config.bin");
 MODULE_FIRMWARE("rtl_bt/rtl8761bu_fw.bin");
 MODULE_FIRMWARE("rtl_bt/rtl8761bu_config.bin");
+MODULE_FIRMWARE("rtl_bt/rtl8761cu_fw.bin");
+MODULE_FIRMWARE("rtl_bt/rtl8761cu_config.bin");
 MODULE_FIRMWARE("rtl_bt/rtl8821a_fw.bin");
 MODULE_FIRMWARE("rtl_bt/rtl8821a_config.bin");
 MODULE_FIRMWARE("rtl_bt/rtl8821c_fw.bin");
-- 
2.53.0



