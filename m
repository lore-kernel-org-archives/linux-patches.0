Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E3D7226545;
	Thu, 12 Dec 2024 16:23:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734020608; cv=none; b=pMnLifKg3rrc6ahjTTQOhmKJmXd3f+JfhocPRFKQDcjQ2GeeBp0e5nAOMPRuaApt1b1EhsY1U761rnRLhe6FL1UU5nd93pyFXv0V0G3cBwPx2ci1H8sdIoIguplzZbXgRYcLP2w49EhiFAXmUu3yfKT1R0AnMDzels2rFJFoWNw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734020608; c=relaxed/simple;
	bh=gBBOveGmwT6YxoYNVchNpdSHE2BOSMvEmEpSEmSyRlM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l5tm3GOzlYuzZWM/SsM0zL85UcuzJEOzoAm7KhQnsL1dQNqo2nNFkokNP8GXlvpKOND40WVKV4BOQVjWFhqHgW+jl8md2SsmKCOiLrYoCxZRM4OfrryNusIDX1sAtMerXfjTABo1v6Astyb2W3qbKk9y0rMtoYoCTqOJDLF/qGU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z86RoNC/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z86RoNC/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B05F4C4CECE;
	Thu, 12 Dec 2024 16:23:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734020608;
	bh=gBBOveGmwT6YxoYNVchNpdSHE2BOSMvEmEpSEmSyRlM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z86RoNC/RqRMridN04Z3cwm0AOzZfJx0FoO/35qLJUoWMYEpglz1ZxT8mW5mJftdB
	 AfKOZxrU43pOcQvIKHUgyg7OPhvtIf5oluaRgvhedUvWfkGhLUifQ847qHLnv+wC20
	 2WWGdfjt8jKh4HEK+mf/hmyEf1sAcfueOaJW3PK8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 512/772] can: gs_usb: uniformly use "parent" as variable name for struct gs_usb
Date: Thu, 12 Dec 2024 15:57:37 +0100
Message-ID: <20241212144411.108786734@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marc Kleine-Budde <mkl@pengutronix.de>

[ Upstream commit b6980ad3a90c73c95cab97e9a33129b8f53e2a5b ]

To ease readability and maintainability uniformly use the variable
name "parent" for the struct gs_usb in the gs_usb driver.

Link: https://lore.kernel.org/all/20230718-gs_usb-cleanups-v1-4-c3b9154ec605@pengutronix.de
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Stable-dep-of: 889b2ae9139a ("can: gs_usb: add usb endpoint address detection at driver probe step")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/usb/gs_usb.c | 62 ++++++++++++++++++------------------
 1 file changed, 31 insertions(+), 31 deletions(-)

diff --git a/drivers/net/can/usb/gs_usb.c b/drivers/net/can/usb/gs_usb.c
index cb96e42961109..257e5f10ff1be 100644
--- a/drivers/net/can/usb/gs_usb.c
+++ b/drivers/net/can/usb/gs_usb.c
@@ -522,7 +522,7 @@ static void gs_usb_set_timestamp(struct gs_can *dev, struct sk_buff *skb,
 
 static void gs_usb_receive_bulk_callback(struct urb *urb)
 {
-	struct gs_usb *usbcan = urb->context;
+	struct gs_usb *parent = urb->context;
 	struct gs_can *dev;
 	struct net_device *netdev;
 	int rc;
@@ -533,7 +533,7 @@ static void gs_usb_receive_bulk_callback(struct urb *urb)
 	struct canfd_frame *cfd;
 	struct sk_buff *skb;
 
-	BUG_ON(!usbcan);
+	BUG_ON(!parent);
 
 	switch (urb->status) {
 	case 0: /* success */
@@ -550,7 +550,7 @@ static void gs_usb_receive_bulk_callback(struct urb *urb)
 	if (hf->channel >= GS_MAX_INTF)
 		goto device_detach;
 
-	dev = usbcan->canch[hf->channel];
+	dev = parent->canch[hf->channel];
 
 	netdev = dev->netdev;
 	stats = &netdev->stats;
@@ -640,10 +640,10 @@ static void gs_usb_receive_bulk_callback(struct urb *urb)
 	}
 
 resubmit_urb:
-	usb_fill_bulk_urb(urb, usbcan->udev,
-			  usb_rcvbulkpipe(usbcan->udev, GS_USB_ENDPOINT_IN),
+	usb_fill_bulk_urb(urb, parent->udev,
+			  usb_rcvbulkpipe(parent->udev, GS_USB_ENDPOINT_IN),
 			  hf, dev->parent->hf_size_rx,
-			  gs_usb_receive_bulk_callback, usbcan);
+			  gs_usb_receive_bulk_callback, parent);
 
 	rc = usb_submit_urb(urb, GFP_ATOMIC);
 
@@ -651,8 +651,8 @@ static void gs_usb_receive_bulk_callback(struct urb *urb)
 	if (rc == -ENODEV) {
 device_detach:
 		for (rc = 0; rc < GS_MAX_INTF; rc++) {
-			if (usbcan->canch[rc])
-				netif_device_detach(usbcan->canch[rc]->netdev);
+			if (parent->canch[rc])
+				netif_device_detach(parent->canch[rc]->netdev);
 		}
 	}
 }
@@ -1328,7 +1328,7 @@ static int gs_usb_probe(struct usb_interface *intf,
 {
 	struct usb_device *udev = interface_to_usbdev(intf);
 	struct gs_host_frame *hf;
-	struct gs_usb *dev;
+	struct gs_usb *parent;
 	struct gs_host_config hconf = {
 		.byte_order = cpu_to_le32(0x0000beef),
 	};
@@ -1371,49 +1371,49 @@ static int gs_usb_probe(struct usb_interface *intf,
 		return -EINVAL;
 	}
 
-	dev = kzalloc(sizeof(*dev), GFP_KERNEL);
-	if (!dev)
+	parent = kzalloc(sizeof(*parent), GFP_KERNEL);
+	if (!parent)
 		return -ENOMEM;
 
-	init_usb_anchor(&dev->rx_submitted);
+	init_usb_anchor(&parent->rx_submitted);
 
-	usb_set_intfdata(intf, dev);
-	dev->udev = udev;
+	usb_set_intfdata(intf, parent);
+	parent->udev = udev;
 
 	for (i = 0; i < icount; i++) {
 		unsigned int hf_size_rx = 0;
 
-		dev->canch[i] = gs_make_candev(i, intf, &dconf);
-		if (IS_ERR_OR_NULL(dev->canch[i])) {
+		parent->canch[i] = gs_make_candev(i, intf, &dconf);
+		if (IS_ERR_OR_NULL(parent->canch[i])) {
 			/* save error code to return later */
-			rc = PTR_ERR(dev->canch[i]);
+			rc = PTR_ERR(parent->canch[i]);
 
 			/* on failure destroy previously created candevs */
 			icount = i;
 			for (i = 0; i < icount; i++)
-				gs_destroy_candev(dev->canch[i]);
+				gs_destroy_candev(parent->canch[i]);
 
-			usb_kill_anchored_urbs(&dev->rx_submitted);
-			kfree(dev);
+			usb_kill_anchored_urbs(&parent->rx_submitted);
+			kfree(parent);
 			return rc;
 		}
-		dev->canch[i]->parent = dev;
+		parent->canch[i]->parent = parent;
 
 		/* set RX packet size based on FD and if hardware
 		 * timestamps are supported.
 		 */
-		if (dev->canch[i]->can.ctrlmode_supported & CAN_CTRLMODE_FD) {
-			if (dev->canch[i]->feature & GS_CAN_FEATURE_HW_TIMESTAMP)
+		if (parent->canch[i]->can.ctrlmode_supported & CAN_CTRLMODE_FD) {
+			if (parent->canch[i]->feature & GS_CAN_FEATURE_HW_TIMESTAMP)
 				hf_size_rx = struct_size(hf, canfd_ts, 1);
 			else
 				hf_size_rx = struct_size(hf, canfd, 1);
 		} else {
-			if (dev->canch[i]->feature & GS_CAN_FEATURE_HW_TIMESTAMP)
+			if (parent->canch[i]->feature & GS_CAN_FEATURE_HW_TIMESTAMP)
 				hf_size_rx = struct_size(hf, classic_can_ts, 1);
 			else
 				hf_size_rx = struct_size(hf, classic_can, 1);
 		}
-		dev->hf_size_rx = max(dev->hf_size_rx, hf_size_rx);
+		parent->hf_size_rx = max(parent->hf_size_rx, hf_size_rx);
 	}
 
 	return 0;
@@ -1421,22 +1421,22 @@ static int gs_usb_probe(struct usb_interface *intf,
 
 static void gs_usb_disconnect(struct usb_interface *intf)
 {
-	struct gs_usb *dev = usb_get_intfdata(intf);
+	struct gs_usb *parent = usb_get_intfdata(intf);
 	unsigned int i;
 
 	usb_set_intfdata(intf, NULL);
 
-	if (!dev) {
+	if (!parent) {
 		dev_err(&intf->dev, "Disconnect (nodata)\n");
 		return;
 	}
 
 	for (i = 0; i < GS_MAX_INTF; i++)
-		if (dev->canch[i])
-			gs_destroy_candev(dev->canch[i]);
+		if (parent->canch[i])
+			gs_destroy_candev(parent->canch[i]);
 
-	usb_kill_anchored_urbs(&dev->rx_submitted);
-	kfree(dev);
+	usb_kill_anchored_urbs(&parent->rx_submitted);
+	kfree(parent);
 }
 
 static const struct usb_device_id gs_usb_table[] = {
-- 
2.43.0



