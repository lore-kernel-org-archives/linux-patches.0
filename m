Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CBBF4D1795;
	Thu, 17 Sep 2026 18:10:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789668655; cv=none; b=V+XbnbT58ecat3V53fxUIO2BE5QqlN2WPPoV9l88MEh6Yn3QNdctJHfEbSBGKlK4EtTxh30C8+GdEhvlY3Or9dsEVcY8tg1Yy7XUzYi1t58V0KHOI6ZmYh18AcnJvqx4kDSGBo1A5TBfkRRyQaNdC4UOt6jn+Xj3jj5On0+sDIs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789668655; c=relaxed/simple;
	bh=T/y0rF3gWQ1WnV8J+FPxPqkl3guJTX+U73JYdi55kNI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qorUMkaM7eNY05zh+XiesThgngVPacZKzqRUx05xh7KPtQQpAlImtnNliVB+RMgInd6zgssyKGsPwx1t4tKSVGGqoAt2+D41m5w8JpSwU+azWDlDM8NOcAujc6UfZKM3sn+YJS5gwQd/VX2kkmy8L1kQ95Zgc/EeVLZKzI0jQoQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zvseaeIK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zvseaeIK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C14371F00899;
	Thu, 17 Sep 2026 18:10:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789668654;
	bh=KqO6f/kFgDG9rLCemyroAwG3Oidnn4uJfYNGwwt7iJ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zvseaeIKcpRhB56IXoypupjYaveo5Jqsz0+7H3WmhH/pe/jpwyXOiwH8FdfFA7ha6
	 l0HXhEujqHbQThojrqc+Gc7VSjTd0v/AQW4eXbH/oAjhN+pVfoxJVx2BFDKZB547CE
	 qdgwBE899azPM1zA6hKXjI5g0FwAnoOsPPlqnSTo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Max Chou <max.chou@realtek.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0496/1102] Bluetooth: btrtl: Add the support for RTL8761CUV
Date: Thu, 17 Sep 2026 16:07:19 +0100
Message-ID: <20260917151552.176318755@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 49b74827344c2..a2c8340a5af99 100644
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
 		set_bit(HCI_QUIRK_WIDEBAND_SPEECH_SUPPORTED, &hdev->quirks);
 
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



