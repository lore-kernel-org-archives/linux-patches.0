Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C110E45945;
	Wed,  3 Jul 2024 11:21:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720005700; cv=none; b=AoZrUDWmp39cNvZ2M2+fO5z1kcFuBygfuOSoB4oonjQKM5z2+CZD6J+mpwL4V/riekqZw/rouLAaOUf1jRuYfwtH5HTdp11H6kwZaoL/OvsC/qbwtEF2h+DoEkYLxYAzp/coezJLwAroLC8vbas68uVE51OuqgCU1QreIkCWKOQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720005700; c=relaxed/simple;
	bh=aMKVK5hk1OJeYh3XNOLBMitaLmSRGx4jReyeCv0IacE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rSulp//U8WTfPFK1xfjguKsWGo5howb1/BcWzTpMZjHTRKoSNyqBw2xtVsTAP/R3Zc2pSqpCF/c5nK2k7FSE1ILbIg3O8+zGJsgqg5gpkwSHSPDT4+iKIEnprEnyaEuZePSeonX+lKOq1cDXGfVoBs3RR22m3MvWiAL0Q+LomBc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WQXuh4/t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WQXuh4/t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47692C2BD10;
	Wed,  3 Jul 2024 11:21:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720005700;
	bh=aMKVK5hk1OJeYh3XNOLBMitaLmSRGx4jReyeCv0IacE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WQXuh4/txY+1uSVhyj6YoNlvkN8fEai2bfZkVGddikeRKcZXORmpr1GurxoSqRB1y
	 Y5j5q2gC9LXFkSxGUbP39xh/3FVN116R6PLuSG5O850K8j9P6DsEiYRejNKItTwOlD
	 AGAW4Sdty+Ec1kMeIetZW+FTI0mk/c7iUrv2Mhls=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Uri Arev <me@wantyapps.xyz>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 167/356] Bluetooth: ath3k: Fix multiple issues reported by checkpatch.pl
Date: Wed,  3 Jul 2024 12:38:23 +0200
Message-ID: <20240703102919.423068426@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102913.093882413@linuxfoundation.org>
References: <20240703102913.093882413@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Uri Arev <me@wantyapps.xyz>

[ Upstream commit 68aa21054ec3a1a313af90a5f95ade16c3326d20 ]

This fixes some CHECKs reported by the checkpatch script.

Issues reported in ath3k.c:
-------
ath3k.c
-------
CHECK: Please don't use multiple blank lines
+
+

CHECK: Blank lines aren't necessary after an open brace '{'
+static const struct usb_device_id ath3k_blist_tbl[] = {
+

CHECK: Alignment should match open parenthesis
+static int ath3k_load_firmware(struct usb_device *udev,
+                               const struct firmware *firmware)

CHECK: Alignment should match open parenthesis
+               err = usb_bulk_msg(udev, pipe, send_buf, size,
+                                       &len, 3000);

CHECK: Unnecessary parentheses around 'len != size'
+               if (err || (len != size)) {

CHECK: Alignment should match open parenthesis
+static int ath3k_get_version(struct usb_device *udev,
+                       struct ath3k_version *version)

CHECK: Alignment should match open parenthesis
+static int ath3k_load_fwfile(struct usb_device *udev,
+               const struct firmware *firmware)

CHECK: Alignment should match open parenthesis
+               err = usb_bulk_msg(udev, pipe, send_buf, size,
+                                       &len, 3000);

CHECK: Unnecessary parentheses around 'len != size'
+               if (err || (len != size)) {

CHECK: Blank lines aren't necessary after an open brace '{'
+       switch (fw_version.ref_clock) {
+

CHECK: Alignment should match open parenthesis
+       snprintf(filename, ATH3K_NAME_LEN, "ar3k/ramps_0x%08x_%d%s",
+               le32_to_cpu(fw_version.rom_version), clk_value, ".dfu");

CHECK: Alignment should match open parenthesis
+static int ath3k_probe(struct usb_interface *intf,
+                       const struct usb_device_id *id)

CHECK: Alignment should match open parenthesis
+                       BT_ERR("Firmware file \"%s\" not found",
+                                                       ATH3K_FIRMWARE);

CHECK: Alignment should match open parenthesis
+               BT_ERR("Firmware file \"%s\" request failed (err=%d)",
+                                               ATH3K_FIRMWARE, ret);

total: 0 errors, 0 warnings, 14 checks, 540 lines checked

Signed-off-by: Uri Arev <me@wantyapps.xyz>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/ath3k.c | 25 +++++++++++--------------
 1 file changed, 11 insertions(+), 14 deletions(-)

diff --git a/drivers/bluetooth/ath3k.c b/drivers/bluetooth/ath3k.c
index 759d7828931d9..56ada48104f0e 100644
--- a/drivers/bluetooth/ath3k.c
+++ b/drivers/bluetooth/ath3k.c
@@ -3,7 +3,6 @@
  * Copyright (c) 2008-2009 Atheros Communications Inc.
  */
 
-
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/init.h>
@@ -129,7 +128,6 @@ MODULE_DEVICE_TABLE(usb, ath3k_table);
  * for AR3012
  */
 static const struct usb_device_id ath3k_blist_tbl[] = {
-
 	/* Atheros AR3012 with sflash firmware*/
 	{ USB_DEVICE(0x0489, 0xe04e), .driver_info = BTUSB_ATH3012 },
 	{ USB_DEVICE(0x0489, 0xe04d), .driver_info = BTUSB_ATH3012 },
@@ -203,7 +201,7 @@ static inline void ath3k_log_failed_loading(int err, int len, int size,
 #define TIMEGAP_USEC_MAX	100
 
 static int ath3k_load_firmware(struct usb_device *udev,
-				const struct firmware *firmware)
+			       const struct firmware *firmware)
 {
 	u8 *send_buf;
 	int len = 0;
@@ -238,9 +236,9 @@ static int ath3k_load_firmware(struct usb_device *udev,
 		memcpy(send_buf, firmware->data + sent, size);
 
 		err = usb_bulk_msg(udev, pipe, send_buf, size,
-					&len, 3000);
+				   &len, 3000);
 
-		if (err || (len != size)) {
+		if (err || len != size) {
 			ath3k_log_failed_loading(err, len, size, count);
 			goto error;
 		}
@@ -263,7 +261,7 @@ static int ath3k_get_state(struct usb_device *udev, unsigned char *state)
 }
 
 static int ath3k_get_version(struct usb_device *udev,
-			struct ath3k_version *version)
+			     struct ath3k_version *version)
 {
 	return usb_control_msg_recv(udev, 0, ATH3K_GETVERSION,
 				    USB_TYPE_VENDOR | USB_DIR_IN, 0, 0,
@@ -272,7 +270,7 @@ static int ath3k_get_version(struct usb_device *udev,
 }
 
 static int ath3k_load_fwfile(struct usb_device *udev,
-		const struct firmware *firmware)
+			     const struct firmware *firmware)
 {
 	u8 *send_buf;
 	int len = 0;
@@ -311,8 +309,8 @@ static int ath3k_load_fwfile(struct usb_device *udev,
 		memcpy(send_buf, firmware->data + sent, size);
 
 		err = usb_bulk_msg(udev, pipe, send_buf, size,
-					&len, 3000);
-		if (err || (len != size)) {
+				   &len, 3000);
+		if (err || len != size) {
 			ath3k_log_failed_loading(err, len, size, count);
 			kfree(send_buf);
 			return err;
@@ -426,7 +424,6 @@ static int ath3k_load_syscfg(struct usb_device *udev)
 	}
 
 	switch (fw_version.ref_clock) {
-
 	case ATH3K_XTAL_FREQ_26M:
 		clk_value = 26;
 		break;
@@ -442,7 +439,7 @@ static int ath3k_load_syscfg(struct usb_device *udev)
 	}
 
 	snprintf(filename, ATH3K_NAME_LEN, "ar3k/ramps_0x%08x_%d%s",
-		le32_to_cpu(fw_version.rom_version), clk_value, ".dfu");
+		 le32_to_cpu(fw_version.rom_version), clk_value, ".dfu");
 
 	ret = request_firmware(&firmware, filename, &udev->dev);
 	if (ret < 0) {
@@ -457,7 +454,7 @@ static int ath3k_load_syscfg(struct usb_device *udev)
 }
 
 static int ath3k_probe(struct usb_interface *intf,
-			const struct usb_device_id *id)
+		       const struct usb_device_id *id)
 {
 	const struct firmware *firmware;
 	struct usb_device *udev = interface_to_usbdev(intf);
@@ -506,10 +503,10 @@ static int ath3k_probe(struct usb_interface *intf,
 	if (ret < 0) {
 		if (ret == -ENOENT)
 			BT_ERR("Firmware file \"%s\" not found",
-							ATH3K_FIRMWARE);
+			       ATH3K_FIRMWARE);
 		else
 			BT_ERR("Firmware file \"%s\" request failed (err=%d)",
-							ATH3K_FIRMWARE, ret);
+			       ATH3K_FIRMWARE, ret);
 		return ret;
 	}
 
-- 
2.43.0



