Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F24D47127A;
	Tue, 21 Jul 2026 18:47:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784659631; cv=none; b=KQOUzmtfSZlkcw3Ub2X3O+vBJT6n2ip+v8t1tFiZ3ZsQrJnrpGJOHHEn7iDPbnzIZDlAzekON/dE+kq4n019n4eCjX0IVRKpvnaqmiZo/bBQYgvhAciNkcF2+j9aPlU1SzT82tpn6bED+hx1p+HUtXCIYJl6ONdCnlbW5cYVb18=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784659631; c=relaxed/simple;
	bh=pwsy3C5HlkemkkMF55g5ZvbWs2UtvKgPe6i424SF3+I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i4agx7JljTCvvQzS5f9y5Os7RNDzYhEAUg/QeI/3Qrm4Slu9im8a7sIQI9KFDGHtu7+G+lEmMVyUwCQdk7UMN9TTP3ryEoSCydJ5/KL2m78P9LizqT/UfhrAaEO56uJ/lYKaLRYHU0HQwc/Yp+Kfr4dTcjSMTT3x1rYw04KMZsU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YbLbqikC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YbLbqikC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FAD81F00A3A;
	Tue, 21 Jul 2026 18:47:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784659630;
	bh=YBybmr1jD3XDvRpMLPmPCDv8Y2Tp9EXtiYxP9msUB2c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YbLbqikCKDp7XJ8LZegz2at3g20p3VkNL9f9fa2dh/wF6M4GQLGehyPsoxIMK5oSY
	 itTlkmRboQQ/wG8nwdyVIWa8uBdYHgNHsfZ03En2Wic4+FyARxQg02DRdpJmZpS9/Y
	 ROZ81vTFF1XW7cwVcA+dtunImt3VpDGxKlhrC/OY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mauricio Faria de Oliveira <mfo@igalia.com>,
	Stanislaw Gruszka <stf_xl@wp.pl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1576/1611] usb: atm: ueagle-atm: remove function entry/exit debug messages
Date: Tue, 21 Jul 2026 17:28:12 +0200
Message-ID: <20260721152550.918041813@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

From: Mauricio Faria de Oliveira <mfo@igalia.com>

[ Upstream commit 1414b2242c2e9d670c4d8b83480f13db57627ba9 ]

Remove the driver-internal function entry/exit debug messages
in favor of existing kernel-level function tracing mechanisms.

Suggested-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Link: https://lore.kernel.org/all/2026051657-scruffy-embark-45ea@gregkh/
Signed-off-by: Mauricio Faria de Oliveira <mfo@igalia.com>
Acked-by: Stanislaw Gruszka <stf_xl@wp.pl>
Link: https://patch.msgid.link/20260520-ueagle-atm-cleanup-v1-2-010c8bc7b214@igalia.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: e2674dfbed8a ("usb: atm: ueagle-atm: wait for pre-firmware load in .disconnect()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/atm/ueagle-atm.c |   56 ++++---------------------------------------
 1 file changed, 6 insertions(+), 50 deletions(-)

--- a/drivers/usb/atm/ueagle-atm.c
+++ b/drivers/usb/atm/ueagle-atm.c
@@ -50,12 +50,6 @@
 				"[ueagle-atm vdbg]  " format, ##args); \
 	} while (0)
 
-#define uea_enters(usb_dev) \
-	uea_vdbg(usb_dev, "entering %s\n" , __func__)
-
-#define uea_leaves(usb_dev) \
-	uea_vdbg(usb_dev, "leaving  %s\n" , __func__)
-
 #define uea_err(usb_dev, format, args...) \
 	dev_err(&(usb_dev)->dev , "[UEAGLE-ATM] " format , ##args)
 
@@ -605,7 +599,6 @@ static void uea_upload_pre_firmware(cons
 	u32 crc = 0;
 	int ret, size;
 
-	uea_enters(usb);
 	if (!fw_entry) {
 		uea_err(usb, "firmware is not available\n");
 		goto err;
@@ -669,7 +662,6 @@ err_fw_corrupted:
 	uea_err(usb, "firmware is corrupted\n");
 err:
 	release_firmware(fw_entry);
-	uea_leaves(usb);
 }
 
 /*
@@ -680,7 +672,6 @@ static int uea_load_firmware(struct usb_
 	int ret;
 	char *fw_name = EAGLE_FIRMWARE;
 
-	uea_enters(usb);
 	uea_info(usb, "pre-firmware device, uploading firmware\n");
 
 	switch (ver) {
@@ -709,7 +700,6 @@ static int uea_load_firmware(struct usb_
 	else
 		uea_info(usb, "loading firmware %s\n", fw_name);
 
-	uea_leaves(usb);
 	return ret;
 }
 
@@ -1136,7 +1126,6 @@ static int uea_cmv_e1(struct uea_softc *
 	struct cmv_e1 cmv;
 	int ret;
 
-	uea_enters(INS_TO_USBDEV(sc));
 	uea_vdbg(INS_TO_USBDEV(sc), "Function : %d-%d, Address : %c%c%c%c, "
 			"offset : 0x%04x, data : 0x%08x\n",
 			E1_FUNCTION_TYPE(function),
@@ -1163,9 +1152,8 @@ static int uea_cmv_e1(struct uea_softc *
 							sizeof(cmv), &cmv);
 	if (ret < 0)
 		return ret;
-	ret = wait_cmv_ack(sc);
-	uea_leaves(INS_TO_USBDEV(sc));
-	return ret;
+
+	return wait_cmv_ack(sc);
 }
 
 static int uea_cmv_e4(struct uea_softc *sc,
@@ -1174,7 +1162,6 @@ static int uea_cmv_e4(struct uea_softc *
 	struct cmv_e4 cmv;
 	int ret;
 
-	uea_enters(INS_TO_USBDEV(sc));
 	memset(&cmv, 0, sizeof(cmv));
 
 	uea_vdbg(INS_TO_USBDEV(sc), "Function : %d-%d, Group : 0x%04x, "
@@ -1198,9 +1185,8 @@ static int uea_cmv_e4(struct uea_softc *
 							sizeof(cmv), &cmv);
 	if (ret < 0)
 		return ret;
-	ret = wait_cmv_ack(sc);
-	uea_leaves(INS_TO_USBDEV(sc));
-	return ret;
+
+	return wait_cmv_ack(sc);
 }
 
 static inline int uea_read_cmv_e1(struct uea_softc *sc,
@@ -1294,7 +1280,6 @@ static int uea_stat_e1(struct uea_softc
 	u32 data;
 	int ret;
 
-	uea_enters(INS_TO_USBDEV(sc));
 	data = sc->stats.phy.state;
 
 	ret = uea_read_cmv_e1(sc, E1_SA_STAT, 0, &sc->stats.phy.state);
@@ -1437,7 +1422,6 @@ static int uea_stat_e4(struct uea_softc
 	u32 tmp_arr[2];
 	int ret;
 
-	uea_enters(INS_TO_USBDEV(sc));
 	data = sc->stats.phy.state;
 
 	/* XXX only need to be done before operationnal... */
@@ -1804,7 +1788,6 @@ static int uea_start_reset(struct uea_so
 	u16 zero = 0;	/* ;-) */
 	int ret;
 
-	uea_enters(INS_TO_USBDEV(sc));
 	uea_info(INS_TO_USBDEV(sc), "(re)booting started\n");
 
 	/* mask interrupt */
@@ -1872,7 +1855,6 @@ static int uea_start_reset(struct uea_so
 		return ret;
 
 	sc->reset = 0;
-	uea_leaves(INS_TO_USBDEV(sc));
 	return ret;
 }
 
@@ -1888,7 +1870,6 @@ static int uea_kthread(void *data)
 	int ret = -EAGAIN;
 
 	set_freezable();
-	uea_enters(INS_TO_USBDEV(sc));
 	while (!kthread_should_stop()) {
 		if (ret < 0 || sc->reset)
 			ret = uea_start_reset(sc);
@@ -1897,7 +1878,7 @@ static int uea_kthread(void *data)
 		if (ret != -EAGAIN)
 			uea_wait(sc, 0, msecs_to_jiffies(1000));
 	}
-	uea_leaves(INS_TO_USBDEV(sc));
+
 	return ret;
 }
 
@@ -1910,8 +1891,6 @@ static int load_XILINX_firmware(struct u
 	u8 value;
 	char *fw_name = FPGA930_FIRMWARE;
 
-	uea_enters(INS_TO_USBDEV(sc));
-
 	ret = request_firmware(&fw_entry, fw_name, &sc->usb_dev->dev);
 	if (ret) {
 		uea_err(INS_TO_USBDEV(sc), "firmware %s is not available\n",
@@ -1955,7 +1934,6 @@ static int load_XILINX_firmware(struct u
 err1:
 	release_firmware(fw_entry);
 err0:
-	uea_leaves(INS_TO_USBDEV(sc));
 	return ret;
 }
 
@@ -1965,7 +1943,6 @@ static void uea_dispatch_cmv_e1(struct u
 	struct cmv_dsc_e1 *dsc = &sc->cmv_dsc.e1;
 	struct cmv_e1 *cmv = &intr->u.e1.s2.cmv;
 
-	uea_enters(INS_TO_USBDEV(sc));
 	if (le16_to_cpu(cmv->wPreamble) != E1_PREAMBLE)
 		goto bad1;
 
@@ -1989,7 +1966,6 @@ static void uea_dispatch_cmv_e1(struct u
 	if (cmv->bFunction == E1_MAKEFUNCTION(E1_ADSLDIRECTIVE,
 							E1_MODEMREADY)) {
 		wake_up_cmv_ack(sc);
-		uea_leaves(INS_TO_USBDEV(sc));
 		return;
 	}
 
@@ -2003,7 +1979,6 @@ static void uea_dispatch_cmv_e1(struct u
 	sc->data = sc->data << 16 | sc->data >> 16;
 
 	wake_up_cmv_ack(sc);
-	uea_leaves(INS_TO_USBDEV(sc));
 	return;
 
 bad2:
@@ -2011,14 +1986,12 @@ bad2:
 			"Function : %d, Subfunction : %d\n",
 			E1_FUNCTION_TYPE(cmv->bFunction),
 			E1_FUNCTION_SUBTYPE(cmv->bFunction));
-	uea_leaves(INS_TO_USBDEV(sc));
 	return;
 
 bad1:
 	uea_err(INS_TO_USBDEV(sc), "invalid cmv received, "
 			"wPreamble %d, bDirection %d\n",
 			le16_to_cpu(cmv->wPreamble), cmv->bDirection);
-	uea_leaves(INS_TO_USBDEV(sc));
 }
 
 /* The modem send us an ack. First with check if it right */
@@ -2027,7 +2000,6 @@ static void uea_dispatch_cmv_e4(struct u
 	struct cmv_dsc_e4 *dsc = &sc->cmv_dsc.e4;
 	struct cmv_e4 *cmv = &intr->u.e4.s2.cmv;
 
-	uea_enters(INS_TO_USBDEV(sc));
 	uea_dbg(INS_TO_USBDEV(sc), "cmv %x %x %x %x %x %x\n",
 		be16_to_cpu(cmv->wGroup), be16_to_cpu(cmv->wFunction),
 		be16_to_cpu(cmv->wOffset), be16_to_cpu(cmv->wAddress),
@@ -2039,7 +2011,6 @@ static void uea_dispatch_cmv_e4(struct u
 	if (be16_to_cpu(cmv->wFunction) == E4_MAKEFUNCTION(E4_ADSLDIRECTIVE,
 						E4_MODEMREADY, 1)) {
 		wake_up_cmv_ack(sc);
-		uea_leaves(INS_TO_USBDEV(sc));
 		return;
 	}
 
@@ -2052,7 +2023,6 @@ static void uea_dispatch_cmv_e4(struct u
 	sc->data = be32_to_cpu(cmv->dwData[0]);
 	sc->data1 = be32_to_cpu(cmv->dwData[1]);
 	wake_up_cmv_ack(sc);
-	uea_leaves(INS_TO_USBDEV(sc));
 	return;
 
 bad2:
@@ -2060,7 +2030,6 @@ bad2:
 			"Function : %d, Subfunction : %d\n",
 			E4_FUNCTION_TYPE(cmv->wFunction),
 			E4_FUNCTION_SUBTYPE(cmv->wFunction));
-	uea_leaves(INS_TO_USBDEV(sc));
 	return;
 }
 
@@ -2088,8 +2057,6 @@ static void uea_intr(struct urb *urb)
 	struct intr_pkt *intr = urb->transfer_buffer;
 	int status = urb->status;
 
-	uea_enters(INS_TO_USBDEV(sc));
-
 	if (unlikely(status < 0)) {
 		uea_err(INS_TO_USBDEV(sc), "uea_intr() failed with %d\n",
 		       status);
@@ -2129,8 +2096,6 @@ static int uea_boot(struct uea_softc *sc
 	int ret = -ENOMEM;
 	int size;
 
-	uea_enters(INS_TO_USBDEV(sc));
-
 	if (UEA_CHIP_VERSION(sc) == EAGLE_IV) {
 		size = E4_INTR_PKT_SIZE;
 		sc->dispatch_cmv = uea_dispatch_cmv_e4;
@@ -2187,7 +2152,6 @@ static int uea_boot(struct uea_softc *sc
 		goto err2;
 	}
 
-	uea_leaves(INS_TO_USBDEV(sc));
 	return 0;
 
 err2:
@@ -2197,7 +2161,6 @@ err1:
 	sc->urb_int = NULL;
 	kfree(intr);
 err0:
-	uea_leaves(INS_TO_USBDEV(sc));
 	return ret;
 }
 
@@ -2207,7 +2170,7 @@ err0:
 static void uea_stop(struct uea_softc *sc)
 {
 	int ret;
-	uea_enters(INS_TO_USBDEV(sc));
+
 	ret = kthread_stop(sc->kthread);
 	uea_dbg(INS_TO_USBDEV(sc), "kthread finish with status %d\n", ret);
 
@@ -2221,7 +2184,6 @@ static void uea_stop(struct uea_softc *s
 	flush_work(&sc->task);
 
 	release_firmware(sc->dsp_firm);
-	uea_leaves(INS_TO_USBDEV(sc));
 }
 
 /* syfs interface */
@@ -2494,8 +2456,6 @@ static int uea_bind(struct usbatm_data *
 	int ret, ifnum = intf->altsetting->desc.bInterfaceNumber;
 	unsigned int alt;
 
-	uea_enters(usb);
-
 	/* interface 0 is for firmware/monitoring */
 	if (ifnum != UEA_INTR_IFACE_NO)
 		return -ENODEV;
@@ -2588,7 +2548,6 @@ static int uea_probe(struct usb_interfac
 	struct usb_device *usb = interface_to_usbdev(intf);
 	int ret;
 
-	uea_enters(usb);
 	uea_dbg(usb, "ADSL device found with vid (%#X) pid (%#X) Rev (%#X): %s\n",
 		le16_to_cpu(usb->descriptor.idVendor),
 		le16_to_cpu(usb->descriptor.idProduct),
@@ -2619,7 +2578,6 @@ static void uea_disconnect(struct usb_in
 {
 	struct usb_device *usb = interface_to_usbdev(intf);
 	int ifnum = intf->altsetting->desc.bInterfaceNumber;
-	uea_enters(usb);
 
 	/* ADI930 has 2 interfaces and eagle 3 interfaces.
 	 * Pre-firmware device has one interface
@@ -2630,8 +2588,6 @@ static void uea_disconnect(struct usb_in
 		mutex_unlock(&uea_mutex);
 		uea_info(usb, "ADSL device removed\n");
 	}
-
-	uea_leaves(usb);
 }
 
 /*


