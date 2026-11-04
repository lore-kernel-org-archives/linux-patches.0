Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793830904;
	b=4aLGSR6svz5Nj7gAmdNJ6pAguKyDymmYYwkKW/4ecHOlURu3r/fOQp05DDsoUnG3OA+c
	 7XwrB/vARvHwmtX+bwmScn1dDU0DX62TlPAgsPIQgfd5b7Or3rHQTGF7NI/+2DnYC/gf8
	 m5PK8HMp5xqY0M0TGFeXgCsOv2dmjlXwOM0bGljKnPIX4YVx2vjL7omNA5VjlY7zNOZNl
	 dcpAHUTWcvw4J/HtuyxP9w2/XtAguluuRm7jr3x9Fbaa1eApQeFE5tCOBNu9RC5pFX2ko
	 teHOJRztDNpLPJQfgs2Yeqd4tl6jHYOsBvwA8xEd/MUJFy8uhAHbQGn876PDc8tuVlw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793830904;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=kcjGuQsEPLI6gB+7yqgqHFC/FjxE3BPEFpjjMiCGkm4=;
	b=ypYK5iVBrmtKofzW3T7bOTyB/Zu28gfJqHUOCtN0qHF0PoBBuvi0KL2n2g7KXnGtSA+d
	 YzOUzd6a9B00jHaxhxUGUz+2oC/7ffGj9V2TGgCgtZwUOEgPt5j4O+JdHXRJRpbWURAxT
	 6X+vgJiJ19s/7iADORk2XTA8CTs5EptgNMZtC87fVhPzMrohECq1CfawtyKJ+qVtRga5S
	 9Mz1aS/MdMSMG4/OTpL7D2S76ajgHSWhxEQA28pi5AE/trokgx1qH6HJ4M+N0dligkWpM
	 +CMQfqm6KDhD0gT29hVBybQ+uT7qBez4gfmHM4V1LGVmUO1BBGX2aqWrfQSkeKKj9BQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Fsk0nm6t;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E076606EEB1;
	Wed,  4 Nov 2026 22:21:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Fsk0nm6t
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A013D1F000C1;
	Wed,  4 Nov 2026 22:21:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793830904;
	bh=kcjGuQsEPLI6gB+7yqgqHFC/FjxE3BPEFpjjMiCGkm4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Fsk0nm6tBNMNOxbDhId/KDpxxhJy3A0C6XVsljRpOhWCcwF98Lg30ytHSUTqWo8If
	 V1E4wxZiLYM3EozHOHTMCZLwxKQiBbHVK7J4/5uSfNOzzPnNwaWWpXlnugDvYsZbZz
	 xVp+FxoIxarZ+K45c5qrXVhg4JLIYr6OUIsTlE0w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xu Rao <raoxu@uniontech.com>,
	Mathias Nyman <mathias.nyman@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0393/1005] xhci: include all root port children in recovery prevention on link error
Date: Wed,  4 Nov 2026 16:02:06 -0500
Message-ID: <20261104211055.086905294@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mathias Nyman <mathias.nyman@linux.intel.com>

[ Upstream commit e3d757dc9257f2638ca61eda4faef26c2daeea10 ]

Driver already prevents useless transfer retry and endpoint recovery
for devices directly connected to a root port with link errors.

These devices are either disconnecting or will be reset. Link is gone.

Move the flag indicating link error from the xhci device structure to
the root port strucure, allowing all child devices behind hubs to easily
check for root port link errors, avoiding useless transfer retries and
endpoint recovery.

This extends the previous endpoint recovery prevention in
commit b8c3b718087b ("usb: xhci: Don't try to recover an endpoint if port
is in error state.")
Only root port link errors can be detected early by xhci driver,
not link errors between external hubs and their children.

Tested-by: Xu Rao <raoxu@uniontech.com>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://patch.msgid.link/20260806142113.2436238-4-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/host/xhci-ring.c | 27 +++++++++++++++------------
 drivers/usb/host/xhci.c      |  4 +---
 drivers/usb/host/xhci.h      |  9 +--------
 3 files changed, 17 insertions(+), 23 deletions(-)

diff --git a/drivers/usb/host/xhci-ring.c b/drivers/usb/host/xhci-ring.c
index 6ce5874fc4b3d..dc18da8385a21 100644
--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -1008,7 +1008,7 @@ static int xhci_handle_halted_endpoint(struct xhci_hcd *xhci,
 	 * Avoid resetting endpoint if link is inactive. Can cause host hang.
 	 * Device will be reset soon to recover the link so don't do anything
 	 */
-	if (ep->vdev->flags & VDEV_PORT_ERROR)
+	if (ep->vdev->rhub_port->link_inactive)
 		return -ENODEV;
 
 	/* add td to cancelled list and let reset ep handler take care of it */
@@ -2007,13 +2007,15 @@ static void xhci_cavium_reset_phy_quirk(struct xhci_hcd *xhci)
 static void handle_port_status(struct xhci_hcd *xhci, union xhci_trb *event)
 {
 	struct xhci_virt_device *vdev = NULL;
-	struct usb_hcd *hcd;
-	u32 port_id;
-	u32 portsc, cmd_reg;
-	unsigned int hcd_portnum;
 	struct xhci_bus_state *bus_state;
-	bool bogus_port_status = false;
 	struct xhci_port *port;
+	struct usb_hcd *hcd;
+	bool bogus_port_status = false;
+	unsigned int hcd_portnum;
+	u32 cmd_reg;
+	u32 port_id;
+	u32 portsc;
+	u32 pls;
 
 	/* Port status change events always have a successful completion code */
 	if (GET_COMP_CODE(le32_to_cpu(event->generic.field[2])) != COMP_SUCCESS)
@@ -2050,6 +2052,7 @@ static void handle_port_status(struct xhci_hcd *xhci, union xhci_trb *event)
 	bus_state = &port->rhub->bus_state;
 	hcd_portnum = port->hcd_portnum;
 	portsc = xhci_portsc_readl(port);
+	pls = portsc & PORT_PLS_MASK;
 
 	xhci_dbg(xhci, "Port change event, %d-%d, id %d, portsc: 0x%x\n",
 		 hcd->self.busnum, hcd_portnum + 1, port_id, portsc);
@@ -2061,12 +2064,12 @@ static void handle_port_status(struct xhci_hcd *xhci, union xhci_trb *event)
 		usb_hcd_resume_root_hub(hcd);
 	}
 
-	if (vdev && (portsc & PORT_PLS_MASK) == XDEV_INACTIVE) {
-		if (!(portsc & PORT_RESET))
-			vdev->flags |= VDEV_PORT_ERROR;
-	} else if (vdev && portsc & PORT_RC) {
-		vdev->flags &= ~VDEV_PORT_ERROR;
-	}
+	/*
+	 * Tag broken links to avoid retries while hub driver sorts it out.
+	 * Link status is not relible while port is in reset.
+	 */
+	if (!(portsc & PORT_RESET))
+		port->link_inactive = (pls == XDEV_INACTIVE);
 
 	if ((portsc & PORT_PLC) && (portsc & PORT_PLS_MASK) == XDEV_RESUME) {
 		xhci_dbg(xhci, "port resume event for port %d\n", port_id);
diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
index 14eeb16f668b2..a4fab82da76b6 100644
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -1674,7 +1674,7 @@ static int xhci_urb_enqueue(struct usb_hcd *hcd, struct urb *urb, gfp_t mem_flag
 		goto free_priv;
 	}
 
-	if (xhci->devs[slot_id]->flags & VDEV_PORT_ERROR) {
+	if (xhci->devs[slot_id]->rhub_port->link_inactive) {
 		xhci_dbg(xhci, "Can't queue urb, port error, link inactive\n");
 		ret = -ENODEV;
 		goto free_priv;
@@ -4038,7 +4038,6 @@ static int xhci_discover_or_reset_device(struct usb_hcd *hcd,
 				xhci_get_slot_state(xhci, virt_dev->out_ctx));
 		xhci_dbg(xhci, "Not freeing device rings.\n");
 		/* Don't treat this as an error.  May change my mind later. */
-		virt_dev->flags = 0;
 		ret = 0;
 		goto command_cleanup;
 	case COMP_SUCCESS:
@@ -4090,7 +4089,6 @@ static int xhci_discover_or_reset_device(struct usb_hcd *hcd,
 	}
 	/* If necessary, update the number of active TTs on this root port */
 	xhci_update_tt_active_eps(xhci, virt_dev, old_active_eps);
-	virt_dev->flags = 0;
 	ret = 0;
 
 command_cleanup:
diff --git a/drivers/usb/host/xhci.h b/drivers/usb/host/xhci.h
index caa3fbee29f2c..87d43bc95bf33 100644
--- a/drivers/usb/host/xhci.h
+++ b/drivers/usb/host/xhci.h
@@ -741,14 +741,6 @@ struct xhci_virt_device {
 	struct xhci_port		*rhub_port;
 	struct xhci_interval_bw_table	*bw_table;
 	struct xhci_tt_bw_info		*tt_info;
-	/*
-	 * flags for state tracking based on events and issued commands.
-	 * Software can not rely on states from output contexts because of
-	 * latency between events and xHC updating output context values.
-	 * See xhci 1.1 section 4.8.3 for more details
-	 */
-	unsigned long			flags;
-#define VDEV_PORT_ERROR			BIT(0) /* Port error, link inactive */
 
 	/* The current max exit latency for the enabled USB3 link states. */
 	u16				current_mel;
@@ -1469,6 +1461,7 @@ struct xhci_port {
 	int			hcd_portnum;
 	struct xhci_hub		*rhub;
 	struct xhci_port_cap	*port_cap;
+	unsigned int		link_inactive:1;
 	unsigned int		lpm_incapable:1;
 	unsigned long		resume_timestamp;
 	bool			rexit_active;
-- 
2.53.0



