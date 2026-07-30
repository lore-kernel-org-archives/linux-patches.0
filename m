Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2C0B441600;
	Thu, 30 Jul 2026 15:55:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785426906; cv=none; b=t5t3SyW0APhcfmtHOl7Thh/jXlHfs/jKpcMbOzmP+jeShBXXaR+ymRGs/p/MCcF2kAJ0f6S08FNOLPihTQQ5vd+dmTEdiQbYX9p2vEEBRUOSD7Tq6rPPvSyEGTwbdomw2kOl6tEaNFVqm8NnbsjvSlK0ZONajcKK1ojOSq4PWiY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785426906; c=relaxed/simple;
	bh=salZJJtpE/TxYhiooDc5IBqrUzCiYkx+1H0cX6ZhGwM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gr6vFmP1kC/FQVzXF9F35/bF3QRfJKZh+4CwIDrKLKPF4ClVWdpMEe6bER1mqp8wGup8xVATMrT/4nbJCj4iCSdI3ZHKgLwyjeRFieraYoIFFm3kInr7ALxs6hg8RBIOwIi+20qTiZ/DpVIPA1rwFzKDWFLobX7reBgdLJKIQtk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=APrLw9XR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="APrLw9XR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3816C1F00A3A;
	Thu, 30 Jul 2026 15:55:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785426904;
	bh=Aosop07yeNEoiLA9tvGT8w/m4WrgB/VqBZSIjpiNGLg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=APrLw9XRhHZzwqwehn5A8/UeDvRG+hIIcbAbJi4zluGm/AnUY8Bgv2ATq5CTsOBrU
	 YywyN0ak4HxaO40AAYg4BFvYJVOGXufWWcVx/69Ljdu5SwaSUhVBK8/NWn3fpRyH/U
	 eoRSRAbdagkpHRuD01oM1c0dRrSKuONGU4eAdnEE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 583/602] USB: gadget: Use str_enable_disable-like helpers
Date: Thu, 30 Jul 2026 16:16:15 +0200
Message-ID: <20260730141448.305600557@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
References: <20260730141435.976815864@linuxfoundation.org>
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

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

[ Upstream commit 5b6dc50e9ed870fffbf2ae6de77b30fb0d15eab8 ]

Replace ternary (condition ? "enable" : "disable") syntax with helpers
from string_choices.h because:
1. Simple function call with one argument is easier to read.  Ternary
   operator has three arguments and with wrapping might lead to quite
   long code.
2. Is slightly shorter thus also easier to read.
3. It brings uniformity in the text - same string.
4. Allows deduping by the linker, which results in a smaller binary
   file.

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Link: https://lore.kernel.org/r/20250114-str-enable-disable-usb-v1-5-c8405df47c19@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: c4dd150fceab ("USB: gadget: fsl-udc: fix dev_printk() device")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/function/f_ecm.c         |    4 ++--
 drivers/usb/gadget/function/f_ncm.c         |    3 ++-
 drivers/usb/gadget/function/u_serial.c      |    3 ++-
 drivers/usb/gadget/legacy/inode.c           |    3 ++-
 drivers/usb/gadget/udc/aspeed-vhub/hub.c    |    3 ++-
 drivers/usb/gadget/udc/at91_udc.c           |    3 ++-
 drivers/usb/gadget/udc/cdns2/cdns2-gadget.c |   13 +++++++------
 drivers/usb/gadget/udc/dummy_hcd.c          |    3 ++-
 drivers/usb/gadget/udc/fsl_udc_core.c       |    3 ++-
 drivers/usb/gadget/udc/omap_udc.c           |    3 ++-
 drivers/usb/gadget/udc/pxa27x_udc.c         |    3 ++-
 11 files changed, 27 insertions(+), 17 deletions(-)

--- a/drivers/usb/gadget/function/f_ecm.c
+++ b/drivers/usb/gadget/function/f_ecm.c
@@ -14,6 +14,7 @@
 #include <linux/module.h>
 #include <linux/device.h>
 #include <linux/etherdevice.h>
+#include <linux/string_choices.h>
 
 #include <linux/usb/gadget.h>
 
@@ -390,8 +391,7 @@ static void ecm_do_notify(struct f_ecm *
 		event->wLength = 0;
 		req->length = sizeof *event;
 
-		DBG(cdev, "notify connect %s\n",
-				ecm->is_open ? "true" : "false");
+		DBG(cdev, "notify connect %s\n", str_true_false(ecm->is_open));
 		ecm->notify_state = ECM_NOTIFY_SPEED;
 		break;
 
--- a/drivers/usb/gadget/function/f_ncm.c
+++ b/drivers/usb/gadget/function/f_ncm.c
@@ -18,6 +18,7 @@
 #include <linux/device.h>
 #include <linux/etherdevice.h>
 #include <linux/crc32.h>
+#include <linux/string_choices.h>
 
 #include <linux/usb/cdc.h>
 #include <linux/usb/gadget.h>
@@ -560,7 +561,7 @@ static void ncm_do_notify(struct f_ncm *
 		req->length = sizeof *event;
 
 		DBG(cdev, "notify connect %s\n",
-				ncm->is_open ? "true" : "false");
+				str_true_false(ncm->is_open));
 		ncm->notify_state = NCM_NOTIFY_NONE;
 		break;
 
--- a/drivers/usb/gadget/function/u_serial.c
+++ b/drivers/usb/gadget/function/u_serial.c
@@ -21,6 +21,7 @@
 #include <linux/tty.h>
 #include <linux/tty_flip.h>
 #include <linux/slab.h>
+#include <linux/string_choices.h>
 #include <linux/export.h>
 #include <linux/module.h>
 #include <linux/console.h>
@@ -1541,7 +1542,7 @@ static int __init userial_init(void)
 
 	pr_debug("%s: registered %d ttyGS* device%s\n", __func__,
 			MAX_U_SERIAL_PORTS,
-			(MAX_U_SERIAL_PORTS == 1) ? "" : "s");
+			str_plural(MAX_U_SERIAL_PORTS));
 
 	return status;
 fail:
--- a/drivers/usb/gadget/legacy/inode.c
+++ b/drivers/usb/gadget/legacy/inode.c
@@ -20,6 +20,7 @@
 #include <linux/uaccess.h>
 #include <linux/sched.h>
 #include <linux/slab.h>
+#include <linux/string_choices.h>
 #include <linux/poll.h>
 #include <linux/kthread.h>
 #include <linux/aio.h>
@@ -1182,7 +1183,7 @@ ep0_fasync (int f, struct file *fd, int
 {
 	struct dev_data		*dev = fd->private_data;
 	// caller must F_SETOWN before signal delivery happens
-	VDEBUG (dev, "%s %s\n", __func__, on ? "on" : "off");
+	VDEBUG(dev, "%s %s\n", __func__, str_on_off(on));
 	return fasync_helper (f, fd, on, &dev->fasync);
 }
 
--- a/drivers/usb/gadget/udc/aspeed-vhub/hub.c
+++ b/drivers/usb/gadget/udc/aspeed-vhub/hub.c
@@ -22,6 +22,7 @@
 #include <linux/usb/gadget.h>
 #include <linux/of.h>
 #include <linux/regmap.h>
+#include <linux/string_choices.h>
 #include <linux/dma-mapping.h>
 #include <linux/bcd.h>
 #include <linux/version.h>
@@ -219,7 +220,7 @@ static int ast_vhub_hub_dev_feature(stru
 	if (wValue == USB_DEVICE_REMOTE_WAKEUP) {
 		ep->vhub->wakeup_en = is_set;
 		EPDBG(ep, "Hub remote wakeup %s\n",
-		      is_set ? "enabled" : "disabled");
+		      str_enabled_disabled(is_set));
 		return std_req_complete;
 	}
 
--- a/drivers/usb/gadget/udc/at91_udc.c
+++ b/drivers/usb/gadget/udc/at91_udc.c
@@ -16,6 +16,7 @@
 #include <linux/delay.h>
 #include <linux/ioport.h>
 #include <linux/slab.h>
+#include <linux/string_choices.h>
 #include <linux/errno.h>
 #include <linux/list.h>
 #include <linux/interrupt.h>
@@ -131,7 +132,7 @@ static void proc_ep_show(struct seq_file
 	seq_printf(s, "csr %08x rxbytes=%d %s %s %s" EIGHTBITS "\n",
 		csr,
 		(csr & 0x07ff0000) >> 16,
-		(csr & (1 << 15)) ? "enabled" : "disabled",
+		str_enabled_disabled(csr & (1 << 15)),
 		(csr & (1 << 11)) ? "DATA1" : "DATA0",
 		types[(csr & 0x700) >> 8],
 
--- a/drivers/usb/gadget/udc/cdns2/cdns2-gadget.c
+++ b/drivers/usb/gadget/udc/cdns2/cdns2-gadget.c
@@ -29,6 +29,7 @@
 #include <linux/pm_runtime.h>
 #include <linux/interrupt.h>
 #include <linux/property.h>
+#include <linux/string_choices.h>
 #include <linux/dmapool.h>
 #include <linux/iopoll.h>
 
@@ -2233,12 +2234,12 @@ static int cdns2_init_eps(struct cdns2_d
 		dev_dbg(pdev->dev, "Init %s, SupType: CTRL: %s, INT: %s, "
 			"BULK: %s, ISOC %s, SupDir IN: %s, OUT: %s\n",
 			pep->name,
-			(pep->endpoint.caps.type_control) ? "yes" : "no",
-			(pep->endpoint.caps.type_int) ? "yes" : "no",
-			(pep->endpoint.caps.type_bulk) ? "yes" : "no",
-			(pep->endpoint.caps.type_iso) ? "yes" : "no",
-			(pep->endpoint.caps.dir_in) ? "yes" : "no",
-			(pep->endpoint.caps.dir_out) ? "yes" : "no");
+			str_yes_no(pep->endpoint.caps.type_control),
+			str_yes_no(pep->endpoint.caps.type_int),
+			str_yes_no(pep->endpoint.caps.type_bulk),
+			str_yes_no(pep->endpoint.caps.type_iso),
+			str_yes_no(pep->endpoint.caps.dir_in),
+			str_yes_no(pep->endpoint.caps.dir_out));
 
 		INIT_LIST_HEAD(&pep->pending_list);
 		INIT_LIST_HEAD(&pep->deferred_list);
--- a/drivers/usb/gadget/udc/dummy_hcd.c
+++ b/drivers/usb/gadget/udc/dummy_hcd.c
@@ -28,6 +28,7 @@
 #include <linux/delay.h>
 #include <linux/ioport.h>
 #include <linux/slab.h>
+#include <linux/string_choices.h>
 #include <linux/errno.h>
 #include <linux/init.h>
 #include <linux/hrtimer.h>
@@ -649,7 +650,7 @@ static int dummy_enable(struct usb_ep *_
 		desc->bEndpointAddress & 0x0f,
 		(desc->bEndpointAddress & USB_DIR_IN) ? "in" : "out",
 		usb_ep_type_string(usb_endpoint_type(desc)),
-		max, ep->stream_en ? "enabled" : "disabled");
+		max, str_enabled_disabled(ep->stream_en));
 
 	/* at this point real hardware should be NAKing transfers
 	 * to that endpoint, until a buffer is queued to it.
--- a/drivers/usb/gadget/udc/fsl_udc_core.c
+++ b/drivers/usb/gadget/udc/fsl_udc_core.c
@@ -22,6 +22,7 @@
 #include <linux/errno.h>
 #include <linux/err.h>
 #include <linux/slab.h>
+#include <linux/string_choices.h>
 #include <linux/init.h>
 #include <linux/list.h>
 #include <linux/interrupt.h>
@@ -1181,7 +1182,7 @@ static int fsl_vbus_session(struct usb_g
 
 	udc = container_of(gadget, struct fsl_udc, gadget);
 	spin_lock_irqsave(&udc->lock, flags);
-	dev_vdbg(&gadget->dev, "VBUS %s\n", is_active ? "on" : "off");
+	dev_vdbg(&gadget->dev, "VBUS %s\n", str_on_off(is_active));
 	udc->vbus_active = (is_active != 0);
 	if (can_pullup(udc))
 		fsl_writel((fsl_readl(&dr_regs->usbcmd) | USB_CMD_RUN_STOP),
--- a/drivers/usb/gadget/udc/omap_udc.c
+++ b/drivers/usb/gadget/udc/omap_udc.c
@@ -18,6 +18,7 @@
 #include <linux/errno.h>
 #include <linux/delay.h>
 #include <linux/slab.h>
+#include <linux/string_choices.h>
 #include <linux/timer.h>
 #include <linux/list.h>
 #include <linux/interrupt.h>
@@ -1248,7 +1249,7 @@ static int omap_vbus_session(struct usb_
 
 	udc = container_of(gadget, struct omap_udc, gadget);
 	spin_lock_irqsave(&udc->lock, flags);
-	VDBG("VBUS %s\n", is_active ? "on" : "off");
+	VDBG("VBUS %s\n", str_on_off(is_active));
 	udc->vbus_active = (is_active != 0);
 	if (cpu_is_omap15xx()) {
 		/* "software" detect, ignored if !VBUS_MODE_1510 */
--- a/drivers/usb/gadget/udc/pxa27x_udc.c
+++ b/drivers/usb/gadget/udc/pxa27x_udc.c
@@ -20,6 +20,7 @@
 #include <linux/gpio.h>
 #include <linux/gpio/consumer.h>
 #include <linux/slab.h>
+#include <linux/string_choices.h>
 #include <linux/prefetch.h>
 #include <linux/byteorder/generic.h>
 #include <linux/platform_data/pxa2xx_udc.h>
@@ -1083,7 +1084,7 @@ static int pxa_ep_queue(struct usb_ep *_
 
 	is_first_req = list_empty(&ep->queue);
 	ep_dbg(ep, "queue req %p(first=%s), len %d buf %p\n",
-			_req, is_first_req ? "yes" : "no",
+			_req, str_yes_no(is_first_req),
 			_req->length, _req->buf);
 
 	if (!ep->enabled) {


