Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FD5727E077;
	Tue, 22 Jul 2025 19:11:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753211488; cv=none; b=qO9XPOWxXUa2rLt+kbUJvr7yuJh+2KCZA6qc84XR7QtCHUmwlhIwT+GOLu4h6t58iesPe5aei5AbSOdCZ4LycmyY9nrH0wE4pec4uOk8HVisCLZe8Nt/wjhlGfUMzpqSQTRKPmGmORPGlzIp7wVUDpXgVCmQYRvexwN61lyi7hQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753211488; c=relaxed/simple;
	bh=AlDGH8LMnbCC2+qZqNb7xkjTZR3D+b+9XwvWK4epyZQ=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=aqUTrbaZjyLx3Xoqy/7ocq8YhnOrHXs4V2tMB22cFxD+jZHdcZqWY9rP1jcPSME1mIUeF8fnXdn+19Sb+DCgM/siNSv0yPpdT62k5BsR7fOZ+lLjxqDXWJ1VtRxHz/ZFW6vBwVayYtwsWQ0Kna4tj8bSJ8ORkZ77/ySbA9JFI9I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Q0YLnxi+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Q0YLnxi+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C209EC4CEEB;
	Tue, 22 Jul 2025 19:11:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753211488;
	bh=AlDGH8LMnbCC2+qZqNb7xkjTZR3D+b+9XwvWK4epyZQ=;
	h=From:Date:Subject:To:Cc:From;
	b=Q0YLnxi+Ysu6XkdzqTG4tTl81NcHj6SZYiJJNsjsli8hQLmsbJjK+i9bYjfjPfS/K
	 5xNk/Ne4cKwwNUOdJvQ5MtThdXQqIqKKqkbWi+IOlyF4ISUw92JF0vVWPohP90fa1U
	 o5P1Quu2eKE9oBGIPdV44xONi+mmFQs0ydh6ep2SKoaZJWEla7iewcsaiXmcpHdjSp
	 FxUNxbI7e9txXUifEB6+/T8DmqYGsQpAdtyORAIfNMccGRfy89BrzfqwFVWGLS2vJt
	 B7MkCigu14mt5L3Dai4mLD289K6SNO8q75QfDy+JHTwoEV0XxoLiLIo7RU9YIy13Ha
	 ODyG8xjDfHPOQ==
From: Nathan Chancellor <nathan@kernel.org>
Date: Tue, 22 Jul 2025 12:11:18 -0700
Subject: [PATCH v2] usb: atm: cxacru: Merge cxacru_upload_firmware() into
 cxacru_heavy_init()
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250722-usb-cxacru-fix-clang-21-uninit-warning-v2-1-6708a18decd2@kernel.org>
X-B4-Tracking: v=1; b=H4sIAFXif2gC/5WNQQ6CQBAEv0L27JjdRSB48h+GAwwjTCSLmQXEE
 P7uyA+8dXU6XZuJJEzRXJPNCC0ceQwK/pQY7OvQEXCrbLz1mS1cBnNsANcaZYYHr4CDjsA7mAM
 HnuBdi4YOyktq2zLHvEFn9OwlpPNDdK+Ue47TKJ/Du7hf+7diceCgJXVkHlNblLcnSaDhPEpnq
 n3fv6akkVHdAAAA
X-Change-ID: 20250715-usb-cxacru-fix-clang-21-uninit-warning-9430d96c6bc1
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-usb@vger.kernel.org, llvm@lists.linux.dev, 
 patches@lists.linux.dev, stable@vger.kernel.org, 
 Nathan Chancellor <nathan@kernel.org>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=8750; i=nathan@kernel.org;
 h=from:subject:message-id; bh=AlDGH8LMnbCC2+qZqNb7xkjTZR3D+b+9XwvWK4epyZQ=;
 b=owGbwMvMwCUmm602sfCA1DTG02pJDBn1j+L+z+SY59s5Se8uH+MHi4lHJmzizpHqUXLuXJwkw
 t2YeKypo5SFQYyLQVZMkaX6sepxQ8M5ZxlvnJoEM4eVCWQIAxenAEykqJWRYed30+OpB2ZfNO+M
 72jYdNfi8TX1mNKk/Czxty9FefKcFzD8FT531X3ifO2IJb//yUxsl2lZ/GP5xrOyl2NrtS3cX3K
 +4gcA
X-Developer-Key: i=nathan@kernel.org; a=openpgp;
 fpr=2437CB76E544CB6AB3D9DFD399739260CB6CB716

After a recent change in clang to expose uninitialized warnings from
const variables [1], there is a warning in cxacru_heavy_init():

  drivers/usb/atm/cxacru.c:1104:6: error: variable 'bp' is used uninitialized whenever 'if' condition is false [-Werror,-Wsometimes-uninitialized]
   1104 |         if (instance->modem_type->boot_rom_patch) {
        |             ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  drivers/usb/atm/cxacru.c:1113:39: note: uninitialized use occurs here
   1113 |         cxacru_upload_firmware(instance, fw, bp);
        |                                              ^~
  drivers/usb/atm/cxacru.c:1104:2: note: remove the 'if' if its condition is always true
   1104 |         if (instance->modem_type->boot_rom_patch) {
        |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  drivers/usb/atm/cxacru.c:1095:32: note: initialize the variable 'bp' to silence this warning
   1095 |         const struct firmware *fw, *bp;
        |                                       ^
        |                                        = NULL

While the warning is technically correct that bp is conditionally passed
uninitialized to cxacru_upload_firmware(), it is ultimately a false
positive warning on the uninitialized use of bp because the same
condition that initializes bp, instance->modem_type->boot_rom_patch, is
the same one that gates the use of bp within cxacru_upload_firmware().
As this warning occurs in clang's frontend before inlining occurs, it
cannot know that these conditions are indentical to avoid the warning.

Manually inline cxacru_upload_firmware() into cxacru_heavy_init(), as
that is its only callsite, so that clang can see that bp is initialized
and used under the same condition, clearing up the warning without any
functional changes to the code (LLVM was already doing this inlining
later).

Cc: stable@vger.kernel.org
Fixes: 1b0e61465234 ("[PATCH] USB ATM: driver for the Conexant AccessRunner chipset cxacru")
Closes: https://github.com/ClangBuiltLinux/linux/issues/2102
Link: https://github.com/llvm/llvm-project/commit/2464313eef01c5b1edf0eccf57a32cdee01472c7 [1]
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
Changes in v2:
- Rather than initialize bp to NULL, manually inline
  cxacru_upload_firmware() into cxacru_heavy_init() so that clang can
  see the matching conditions for bp's initialization and use (based on
  feedback from Greg).
- Drop accessrunner-general@lists.sourceforge.net, as I got bounces when
  sending to it unsubscribed.
- Link to v1: https://lore.kernel.org/r/20250715-usb-cxacru-fix-clang-21-uninit-warning-v1-1-de6c652c3079@kernel.org
---
 drivers/usb/atm/cxacru.c | 106 ++++++++++++++++++++++-------------------------
 1 file changed, 49 insertions(+), 57 deletions(-)

diff --git a/drivers/usb/atm/cxacru.c b/drivers/usb/atm/cxacru.c
index a12ab90b3db75b230dcf319a949e6d10dbac0363..68a8e9de8b4fe95be31b561f7f5df7e3c59142ae 100644
--- a/drivers/usb/atm/cxacru.c
+++ b/drivers/usb/atm/cxacru.c
@@ -980,25 +980,60 @@ static int cxacru_fw(struct usb_device *usb_dev, enum cxacru_fw_request fw,
 	return ret;
 }
 
-static void cxacru_upload_firmware(struct cxacru_data *instance,
-				   const struct firmware *fw,
-				   const struct firmware *bp)
+
+static int cxacru_find_firmware(struct cxacru_data *instance,
+				char *phase, const struct firmware **fw_p)
 {
-	int ret;
+	struct usbatm_data *usbatm = instance->usbatm;
+	struct device *dev = &usbatm->usb_intf->dev;
+	char buf[16];
+
+	sprintf(buf, "cxacru-%s.bin", phase);
+	usb_dbg(usbatm, "cxacru_find_firmware: looking for %s\n", buf);
+
+	if (request_firmware(fw_p, buf, dev)) {
+		usb_dbg(usbatm, "no stage %s firmware found\n", phase);
+		return -ENOENT;
+	}
+
+	usb_info(usbatm, "found firmware %s\n", buf);
+
+	return 0;
+}
+
+static int cxacru_heavy_init(struct usbatm_data *usbatm_instance,
+			     struct usb_interface *usb_intf)
+{
+	const struct firmware *fw, *bp;
+	struct cxacru_data *instance = usbatm_instance->driver_data;
 	struct usbatm_data *usbatm = instance->usbatm;
 	struct usb_device *usb_dev = usbatm->usb_dev;
 	__le16 signature[] = { usb_dev->descriptor.idVendor,
 			       usb_dev->descriptor.idProduct };
 	__le32 val;
+	int ret;
 
-	usb_dbg(usbatm, "%s\n", __func__);
+	ret = cxacru_find_firmware(instance, "fw", &fw);
+	if (ret) {
+		usb_warn(usbatm_instance, "firmware (cxacru-fw.bin) unavailable (system misconfigured?)\n");
+		return ret;
+	}
+
+	if (instance->modem_type->boot_rom_patch) {
+		ret = cxacru_find_firmware(instance, "bp", &bp);
+		if (ret) {
+			usb_warn(usbatm_instance, "boot ROM patch (cxacru-bp.bin) unavailable (system misconfigured?)\n");
+			release_firmware(fw);
+			return ret;
+		}
+	}
 
 	/* FirmwarePllFClkValue */
 	val = cpu_to_le32(instance->modem_type->pll_f_clk);
 	ret = cxacru_fw(usb_dev, FW_WRITE_MEM, 0x2, 0x0, PLLFCLK_ADDR, (u8 *) &val, 4);
 	if (ret) {
 		usb_err(usbatm, "FirmwarePllFClkValue failed: %d\n", ret);
-		return;
+		goto done;
 	}
 
 	/* FirmwarePllBClkValue */
@@ -1006,7 +1041,7 @@ static void cxacru_upload_firmware(struct cxacru_data *instance,
 	ret = cxacru_fw(usb_dev, FW_WRITE_MEM, 0x2, 0x0, PLLBCLK_ADDR, (u8 *) &val, 4);
 	if (ret) {
 		usb_err(usbatm, "FirmwarePllBClkValue failed: %d\n", ret);
-		return;
+		goto done;
 	}
 
 	/* Enable SDRAM */
@@ -1014,7 +1049,7 @@ static void cxacru_upload_firmware(struct cxacru_data *instance,
 	ret = cxacru_fw(usb_dev, FW_WRITE_MEM, 0x2, 0x0, SDRAMEN_ADDR, (u8 *) &val, 4);
 	if (ret) {
 		usb_err(usbatm, "Enable SDRAM failed: %d\n", ret);
-		return;
+		goto done;
 	}
 
 	/* Firmware */
@@ -1022,7 +1057,7 @@ static void cxacru_upload_firmware(struct cxacru_data *instance,
 	ret = cxacru_fw(usb_dev, FW_WRITE_MEM, 0x2, 0x0, FW_ADDR, fw->data, fw->size);
 	if (ret) {
 		usb_err(usbatm, "Firmware upload failed: %d\n", ret);
-		return;
+		goto done;
 	}
 
 	/* Boot ROM patch */
@@ -1031,7 +1066,7 @@ static void cxacru_upload_firmware(struct cxacru_data *instance,
 		ret = cxacru_fw(usb_dev, FW_WRITE_MEM, 0x2, 0x0, BR_ADDR, bp->data, bp->size);
 		if (ret) {
 			usb_err(usbatm, "Boot ROM patching failed: %d\n", ret);
-			return;
+			goto done;
 		}
 	}
 
@@ -1039,7 +1074,7 @@ static void cxacru_upload_firmware(struct cxacru_data *instance,
 	ret = cxacru_fw(usb_dev, FW_WRITE_MEM, 0x2, 0x0, SIG_ADDR, (u8 *) signature, 4);
 	if (ret) {
 		usb_err(usbatm, "Signature storing failed: %d\n", ret);
-		return;
+		goto done;
 	}
 
 	usb_info(usbatm, "starting device\n");
@@ -1051,7 +1086,7 @@ static void cxacru_upload_firmware(struct cxacru_data *instance,
 	}
 	if (ret) {
 		usb_err(usbatm, "Passing control to firmware failed: %d\n", ret);
-		return;
+		goto done;
 	}
 
 	/* Delay to allow firmware to start up. */
@@ -1065,53 +1100,10 @@ static void cxacru_upload_firmware(struct cxacru_data *instance,
 	ret = cxacru_cm(instance, CM_REQUEST_CARD_GET_STATUS, NULL, 0, NULL, 0);
 	if (ret < 0) {
 		usb_err(usbatm, "modem failed to initialize: %d\n", ret);
-		return;
-	}
-}
-
-static int cxacru_find_firmware(struct cxacru_data *instance,
-				char *phase, const struct firmware **fw_p)
-{
-	struct usbatm_data *usbatm = instance->usbatm;
-	struct device *dev = &usbatm->usb_intf->dev;
-	char buf[16];
-
-	sprintf(buf, "cxacru-%s.bin", phase);
-	usb_dbg(usbatm, "cxacru_find_firmware: looking for %s\n", buf);
-
-	if (request_firmware(fw_p, buf, dev)) {
-		usb_dbg(usbatm, "no stage %s firmware found\n", phase);
-		return -ENOENT;
-	}
-
-	usb_info(usbatm, "found firmware %s\n", buf);
-
-	return 0;
-}
-
-static int cxacru_heavy_init(struct usbatm_data *usbatm_instance,
-			     struct usb_interface *usb_intf)
-{
-	const struct firmware *fw, *bp;
-	struct cxacru_data *instance = usbatm_instance->driver_data;
-	int ret = cxacru_find_firmware(instance, "fw", &fw);
-
-	if (ret) {
-		usb_warn(usbatm_instance, "firmware (cxacru-fw.bin) unavailable (system misconfigured?)\n");
-		return ret;
+		goto done;
 	}
 
-	if (instance->modem_type->boot_rom_patch) {
-		ret = cxacru_find_firmware(instance, "bp", &bp);
-		if (ret) {
-			usb_warn(usbatm_instance, "boot ROM patch (cxacru-bp.bin) unavailable (system misconfigured?)\n");
-			release_firmware(fw);
-			return ret;
-		}
-	}
-
-	cxacru_upload_firmware(instance, fw, bp);
-
+done:
 	if (instance->modem_type->boot_rom_patch)
 		release_firmware(bp);
 	release_firmware(fw);

---
base-commit: fdfa018c6962c86d2faa183187669569be4d513f
change-id: 20250715-usb-cxacru-fix-clang-21-uninit-warning-9430d96c6bc1

Best regards,
-- 
Nathan Chancellor <nathan@kernel.org>

