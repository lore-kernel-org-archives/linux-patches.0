Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26C8F3F1AC6;
	Sat, 12 Sep 2026 09:59:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789207187; cv=none; b=Dh//LELcoEi/9IsNywd17UtiE4lOhn5Ny6XuBCRdQOP2QW45v82CDDdPRETvEU8I1KMxVufVLdXFDF/+XBwmuBJk1KA9oy4GQ712VbORp5oKc7MCEbTl9FF16RnImr9oMTebqaO7HQLa15PZsm4WOHPzEA7zJPTzgB+eWexwlwo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789207187; c=relaxed/simple;
	bh=8brO9qc90F72pqM19erZV6Ko0Ynk5K4AbeAEhRifUhU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rfCPnaJcrxTe5Kfb17tDwhz8e8H12ESQ7qVQKLzwqb84UvzjfN0vUSrykW2zAvvUCMzWgWwr06Ddc8O+1M91V6rsM7s11XhujVcuvh3uvagbupBeeppRck3r0qTPBpQ1sOZO5x759WZGUTQ3mWJuYokL7a7pDOQFLppHjNyCAKs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=isNTyTT8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="isNTyTT8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE7731F000FF;
	Sat, 12 Sep 2026 09:59:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789207185;
	bh=/Mn05e/AtnNrhp1ih6WvHTckrVaOnnbM9a1B0cP3JNo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=isNTyTT800aKUVdQD9/vaQEhGC+ViLumHFUhqTM7vhW56XTDzhGMxV7rbVpvexwj9
	 N77qX1bhRI/SGTHoEXixuHQPp2+HQ+vcN8NmKj+ChbDNDPmVsA7PviHurUb1QSfkUB
	 B08S/1pmlVhih+qvVLZ2PQpUGH9ZTh1LsPPlpQg0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengyu Luo <mitltlatltl@gmail.com>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0324/1518] usb: ucsi: huawei_gaokun: support mode switching
Date: Sat, 12 Sep 2026 08:41:33 +0200
Message-ID: <20260912065630.804335208@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

From: Pengyu Luo <mitltlatltl@gmail.com>

[ Upstream commit 1c2b66a7d7257d2652aa41f9a860ecb96dde27dd ]

The USB PHY (QMP Combo PHY) is always initialized in USB3+DP mode. In
the past, there was no MUX, and it was unnecessary to set it, since
MSM only supported 2-lane DP. But now, MST and 4-lane DP support has
been added to MSM, and a MUX has been added to the PHY. To support
4-lane DP and mode switching for gaokun, get the MUX and set it.

Signed-off-by: Pengyu Luo <mitltlatltl@gmail.com>
Acked-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Link: https://patch.msgid.link/20260607101844.820064-1-mitltlatltl@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: 2c5659a7064e ("usb: typec: ucsi: gaokun: unwind notifier on UCSI register failure")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/typec/ucsi/ucsi_huawei_gaokun.c | 55 +++++++++++++++------
 1 file changed, 41 insertions(+), 14 deletions(-)

diff --git a/drivers/usb/typec/ucsi/ucsi_huawei_gaokun.c b/drivers/usb/typec/ucsi/ucsi_huawei_gaokun.c
index c5965656babad..95b7b77b726d7 100644
--- a/drivers/usb/typec/ucsi/ucsi_huawei_gaokun.c
+++ b/drivers/usb/typec/ucsi/ucsi_huawei_gaokun.c
@@ -18,6 +18,7 @@
 #include <linux/usb/pd_vdo.h>
 #include <linux/usb/typec_altmode.h>
 #include <linux/usb/typec_dp.h>
+#include <linux/usb/typec_mux.h>
 #include <linux/workqueue_types.h>
 
 #include "ucsi.h"
@@ -82,6 +83,8 @@ struct gaokun_ucsi_port {
 	struct gaokun_ucsi *ucsi;
 	struct auxiliary_device *bridge;
 
+	struct typec_mux *typec_mux;
+
 	int idx;
 	enum gaokun_ucsi_ccx ccx;
 	enum gaokun_ucsi_mux mux;
@@ -226,19 +229,18 @@ static void gaokun_ucsi_port_update(struct gaokun_ucsi_port *port,
 	port->hpd_state = FIELD_GET(GAOKUN_HPD_STATE_MASK, ddi);
 	port->hpd_irq = FIELD_GET(GAOKUN_HPD_IRQ_MASK, ddi);
 
-	/* Mode and SVID are unused; keeping them to make things clearer */
 	switch (port->mode) {
 	case USBC_DPAM_PAN_C:
 	case USBC_DPAM_PAN_C_REVERSE:
-		port->mode = DP_PIN_ASSIGN_C; /* correct it for usb later */
+		port->mode = TYPEC_DP_STATE_C; /* correct it for usb later */
 		break;
 	case USBC_DPAM_PAN_D:
 	case USBC_DPAM_PAN_D_REVERSE:
-		port->mode = DP_PIN_ASSIGN_D;
+		port->mode = TYPEC_DP_STATE_D;
 		break;
 	case USBC_DPAM_PAN_E:
 	case USBC_DPAM_PAN_E_REVERSE:
-		port->mode = DP_PIN_ASSIGN_E;
+		port->mode = TYPEC_DP_STATE_E;
 		break;
 	case USBC_DPAM_PAN_NONE:
 		port->mode = TYPEC_STATE_SAFE;
@@ -287,18 +289,32 @@ static int gaokun_ucsi_refresh(struct gaokun_ucsi *uec)
 	return idx;
 }
 
-static void gaokun_ucsi_handle_altmode(struct gaokun_ucsi_port *port)
+static void gaokun_ucsi_handle_usb_mode(struct gaokun_ucsi_port *port)
 {
 	struct gaokun_ucsi *uec = port->ucsi;
-	int idx = port->idx;
-
-	if (idx >= uec->ucsi->cap.num_connectors) {
+	struct typec_mux_state state = {};
+	struct typec_altmode dp_alt = {};
+	int idx = port->idx, ret;
+
+	/*
+	 * For every typec port on this platform, the only mode-switch is
+	 * controlled by its qmp combo phy which consumes svid and mode only.
+	 */
+	dp_alt.svid = port->svid;
+	state.mode = port->mode;
+	state.alt = &dp_alt;
+
+	if (idx >= uec->num_ports) {
 		dev_warn(uec->dev, "altmode port out of range: %d\n", idx);
 		return;
 	}
 
+	ret = typec_mux_set(port->typec_mux, &state);
+	if (ret)
+		dev_err(uec->dev, "failed to set mux %d\n", ret);
+
 	/* UCSI callback .connector_status() have set orientation */
-	if (port->bridge)
+	if (port->bridge && port->svid == USB_TYPEC_DP_SID)
 		drm_aux_hpd_bridge_notify(&port->bridge->dev,
 					  port->hpd_state ?
 					  connector_status_connected :
@@ -307,7 +323,7 @@ static void gaokun_ucsi_handle_altmode(struct gaokun_ucsi_port *port)
 	gaokun_ec_ucsi_pan_ack(uec->ec, port->idx);
 }
 
-static void gaokun_ucsi_altmode_notify_ind(struct gaokun_ucsi *uec)
+static void gaokun_ucsi_usb_notify_ind(struct gaokun_ucsi *uec)
 {
 	int idx;
 
@@ -320,7 +336,7 @@ static void gaokun_ucsi_altmode_notify_ind(struct gaokun_ucsi *uec)
 	if (idx == GAOKUN_UCSI_NO_PORT_UPDATE)
 		gaokun_ec_ucsi_pan_ack(uec->ec, idx); /* ack directly if no update */
 	else
-		gaokun_ucsi_handle_altmode(&uec->ports[idx]);
+		gaokun_ucsi_handle_usb_mode(&uec->ports[idx]);
 }
 
 /*
@@ -352,7 +368,7 @@ static void gaokun_ucsi_handle_no_usb_event(struct gaokun_ucsi *uec, int idx)
 	port = &uec->ports[idx];
 	if (!wait_for_completion_timeout(&port->usb_ack, 2 * HZ)) {
 		dev_warn(uec->dev, "No USB EVENT, triggered by UCSI EVENT");
-		gaokun_ucsi_altmode_notify_ind(uec);
+		gaokun_ucsi_usb_notify_ind(uec);
 	}
 }
 
@@ -366,7 +382,7 @@ static int gaokun_ucsi_notify(struct notifier_block *nb,
 	switch (action) {
 	case EC_EVENT_USB:
 		gaokun_ucsi_complete_usb_ack(uec);
-		gaokun_ucsi_altmode_notify_ind(uec);
+		gaokun_ucsi_usb_notify_ind(uec);
 		return NOTIFY_OK;
 
 	case EC_EVENT_UCSI:
@@ -429,8 +445,15 @@ static int gaokun_ucsi_ports_init(struct gaokun_ucsi *uec)
 			fwnode_handle_put(fwnode);
 			return PTR_ERR(ucsi_port->bridge);
 		}
-	}
 
+		ucsi_port->typec_mux = fwnode_typec_mux_get(fwnode);
+		if (IS_ERR(ucsi_port->typec_mux)) {
+			fwnode_handle_put(fwnode);
+			return dev_err_probe(dev, PTR_ERR(ucsi_port->typec_mux),
+					     "failed to acquire mode-switch for port: %d\n",
+					     port);
+		}
+	}
 	for (i = 0; i < num_ports; i++) {
 		if (!uec->ports[i].bridge)
 			continue;
@@ -502,10 +525,14 @@ static int gaokun_ucsi_probe(struct auxiliary_device *adev,
 static void gaokun_ucsi_remove(struct auxiliary_device *adev)
 {
 	struct gaokun_ucsi *uec = auxiliary_get_drvdata(adev);
+	int i;
 
 	disable_delayed_work_sync(&uec->work);
 	gaokun_ec_unregister_notify(uec->ec, &uec->nb);
 	ucsi_unregister(uec->ucsi);
+	for (i = 0; i < uec->num_ports; ++i)
+		typec_mux_put(uec->ports[i].typec_mux);
+
 	ucsi_destroy(uec->ucsi);
 }
 
-- 
2.53.0



