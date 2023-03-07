Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BD4DBA3E
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 17:41:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 021F9C433D2;
	Tue,  7 Mar 2023 17:41:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678210864;
	bh=Ce3JaWUVG2SKygFx46jNlgf502grAli+lNOJcCiG7SY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kV29CNJ+JJXoXrlPG0ELgNgLY/CnyKrGTXUIkUSMsarap6xnHTwqsIYDjuu0Me2Q3
	 78vaVaazczF2sjzLtYgQV6cCGa2x1CyqKcD14emp/hoznLUzuiO8GqmWoQ1Tux4qCo
	 cgTP9BbI0QRcoAxRHuuE0ItTuYWA5XqKCMu/kvZQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marcel Holtmann <marcel@holtmann.org>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0678/1001] Bluetooth: Fix issue with Actions Semi ATS2851 based devices
Date: Tue,  7 Mar 2023 17:57:30 +0100
Message-Id: <20230307170051.020352634@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Marcel Holtmann <marcel@holtmann.org>

[ Upstream commit 5d44f76fab0839799b19cbc88d13575da968dc08 ]

Their devices claim to support the erroneous data reporting, but don't
actually support the required commands. So blacklist them and add a
quirk.

  < HCI Command: Read Default Erroneous Data Reporting (0x03|0x005a) plen 0
  > HCI Event: Command Status (0x0f) plen 4
        Read Default Erroneous Data Reporting (0x03|0x005a) ncmd 1
          Status: Unknown HCI Command (0x01)

T:  Bus=02 Lev=02 Prnt=08 Port=02 Cnt=01 Dev#= 10 Spd=12   MxCh= 0
D:  Ver= 2.00 Cls=e0(wlcon) Sub=01 Prot=01 MxPS=64 #Cfgs=  1
P:  Vendor=10d7 ProdID=b012 Rev=88.91
S:  Manufacturer=Actions
S:  Product=general adapter
S:  SerialNumber=ACTIONS1234
C:* #Ifs= 2 Cfg#= 1 Atr=c0 MxPwr=100mA
I:* If#= 0 Alt= 0 #EPs= 3 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
E:  Ad=81(I) Atr=03(Int.) MxPS=  64 Ivl=1ms
E:  Ad=02(O) Atr=02(Bulk) MxPS=  64 Ivl=0ms
E:  Ad=82(I) Atr=02(Bulk) MxPS=  64 Ivl=0ms
I:* If#= 1 Alt= 0 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
E:  Ad=01(O) Atr=01(Isoc) MxPS=   0 Ivl=1ms
E:  Ad=83(I) Atr=01(Isoc) MxPS=   0 Ivl=1ms
I:  If#= 1 Alt= 1 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
E:  Ad=01(O) Atr=01(Isoc) MxPS=   9 Ivl=1ms
E:  Ad=83(I) Atr=01(Isoc) MxPS=   9 Ivl=1ms
I:  If#= 1 Alt= 2 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
E:  Ad=01(O) Atr=01(Isoc) MxPS=  17 Ivl=1ms
E:  Ad=83(I) Atr=01(Isoc) MxPS=  17 Ivl=1ms
I:  If#= 1 Alt= 3 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
E:  Ad=01(O) Atr=01(Isoc) MxPS=  25 Ivl=1ms
E:  Ad=83(I) Atr=01(Isoc) MxPS=  25 Ivl=1ms
I:  If#= 1 Alt= 4 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
E:  Ad=01(O) Atr=01(Isoc) MxPS=  33 Ivl=1ms
E:  Ad=83(I) Atr=01(Isoc) MxPS=  33 Ivl=1ms
I:  If#= 1 Alt= 5 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
E:  Ad=01(O) Atr=01(Isoc) MxPS=  49 Ivl=1ms
E:  Ad=83(I) Atr=01(Isoc) MxPS=  49 Ivl=1ms

Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btusb.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index 2ad4efdd9e40b..afd2f08ffe30f 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -64,6 +64,7 @@ static struct usb_driver btusb_driver;
 #define BTUSB_INTEL_BROKEN_SHUTDOWN_LED	BIT(24)
 #define BTUSB_INTEL_BROKEN_INITIAL_NCMD BIT(25)
 #define BTUSB_INTEL_NO_WBS_SUPPORT	BIT(26)
+#define BTUSB_ACTIONS_SEMI		BIT(27)
 
 static const struct usb_device_id btusb_table[] = {
 	/* Generic Bluetooth USB device */
@@ -677,6 +678,9 @@ static const struct usb_device_id blacklist_table[] = {
 	{ USB_DEVICE(0x0cb5, 0xc547), .driver_info = BTUSB_REALTEK |
 						     BTUSB_WIDEBAND_SPEECH },
 
+	/* Actions Semiconductor ATS2851 based devices */
+	{ USB_DEVICE(0x10d7, 0xb012), .driver_info = BTUSB_ACTIONS_SEMI },
+
 	/* Silicon Wave based devices */
 	{ USB_DEVICE(0x0c10, 0x0000), .driver_info = BTUSB_SWAVE },
 
@@ -4098,6 +4102,11 @@ static int btusb_probe(struct usb_interface *intf,
 		set_bit(BTUSB_USE_ALT3_FOR_WBS, &data->flags);
 	}
 
+	if (id->driver_info & BTUSB_ACTIONS_SEMI) {
+		/* Support is advertised, but not implemented */
+		set_bit(HCI_QUIRK_BROKEN_ERR_DATA_REPORTING, &hdev->quirks);
+	}
+
 	if (!reset)
 		set_bit(HCI_QUIRK_RESET_ON_CLOSE, &hdev->quirks);
 
-- 
2.39.2



