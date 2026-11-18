Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048980;
	b=Xs+xnzSiIt9VJpQ9w2HzBknck9/Oul7/ZRhDcSnEvNLc666OsnkYv2y5LaZdgkOmcgca
	 gXY/10Onz/brs2R3EKXFd2P2PayKM1VOLasz3VGWj2NjWheYuAVVGphFtnEL+xVLSAyJf
	 Ta/5Nc8pXSyTl+XV6Xz/1+tadU2AQ6vDgjH16+l3A7hsicRr/UUR1l9SVwdB0Yrn8sL26
	 XoZmHhU4GjMh2WzWzUtblq1f/PbxoRJDmK39QdN4/kI4dHwplOWi7lpJiy3ry8wjpgfRP
	 XKw+3P5+j5yiMkQis/Q+9h2T+h9YTn0r0pZQCNyDo3wbEZgqOgg+QVcioxfspQ4jeow==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048980;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=BGiftTLm+G0Y1cmaPeEIDrucw8uE12jpDIXEO8bmo/g=;
	b=iL2+hPKtK2ujUAmx5MhkPIPZ1Usg2pIuSPlCJIy3KyZJ7Zg3pVcuEUUOcPCCOTVGKNmU
	 r0j2qj4GYDYB6XEc98Zb6odMbMh1YISZOKJFpF5bcEib5/iFB5NxmfG+sQ4Bcn4KUIpCO
	 9zelbfXh4ROaFx9sZuiX9ytO5aq8GeKeWSxS1/P19lIZweS13SqANlFEkxjmcY4zGnBgb
	 7KMyk0Qh06GZeccvnh5M8CC7VA0zSTDydeqiMklWyOfpt1HsM83+Sdpfw9lUFpPlkosPR
	 3pFJjw+i63JOfLEsSN4SdLN/FyUfVugyFVec2m6YP/pPRwvUkDldXDLspt0Y12TJNlA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=I9ux9nzi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B57B8606A320;
	Thu, 19 Nov 2026 00:43:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=I9ux9nzi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1952A1F000C5;
	Thu, 19 Nov 2026 00:42:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048980;
	bh=BGiftTLm+G0Y1cmaPeEIDrucw8uE12jpDIXEO8bmo/g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=I9ux9nziHS+6Q0cHkT3IEUBCQAGugeyjaWLpyKhD10Qq/apS4w5h+u+bEdid45sWg
	 PChHlUSxJ2heHtnr9wS4MDBv4BDjpjyxCiHypSOGMF3rbU79mqf3WPGWk9CjXo9vuT
	 Lq0AsjGx+i2qXBAzuuL1lTIK+j66pA/H/AfIGy8c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Prashant Malani <pmalani@chromium.org>,
	Benson Leung <bleung@chromium.org>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2171/2857] platform/chrome: cros_ec_typec: Move structs to header
Date: Wed, 18 Nov 2026 15:53:25 +0100
Message-ID: <20261118150319.571417463@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Prashant Malani <pmalani@chromium.org>

[ Upstream commit 69058096515359fbe15b63ea8b111fe0bb21cecb ]

Move ChromeOS Type-C structs into their own header, so they can be
referenced by other files which can be added to the same module.

No functional changes introduced by this patch.

Signed-off-by: Prashant Malani <pmalani@chromium.org>
Reviewed-by: Benson Leung <bleung@chromium.org>
Acked-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Link: https://lore.kernel.org/r/20221228004648.793339-7-pmalani@chromium.org
Stable-dep-of: 317e7abcaf60 ("platform/chrome: cros_ec_typec: Validate SVID and mode counts in discovery data")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 MAINTAINERS                             |  2 +-
 drivers/platform/chrome/cros_ec_typec.c | 78 +----------------------
 drivers/platform/chrome/cros_ec_typec.h | 85 +++++++++++++++++++++++++
 3 files changed, 88 insertions(+), 77 deletions(-)
 create mode 100644 drivers/platform/chrome/cros_ec_typec.h

diff --git a/MAINTAINERS b/MAINTAINERS
index bf4a79088f500..66aa65cdddffb 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4932,7 +4932,7 @@ CHROMEOS EC USB TYPE-C DRIVER
 M:	Prashant Malani <pmalani@chromium.org>
 L:	chrome-platform@lists.linux.dev
 S:	Maintained
-F:	drivers/platform/chrome/cros_ec_typec.c
+F:	drivers/platform/chrome/cros_ec_typec.*
 F:	drivers/platform/chrome/cros_typec_switch.c
 
 CHROMEOS EC USB PD NOTIFY DRIVER
diff --git a/drivers/platform/chrome/cros_ec_typec.c b/drivers/platform/chrome/cros_ec_typec.c
index 7414d33016922..2febfef7943f9 100644
--- a/drivers/platform/chrome/cros_ec_typec.c
+++ b/drivers/platform/chrome/cros_ec_typec.c
@@ -7,96 +7,22 @@
  */
 
 #include <linux/acpi.h>
-#include <linux/list.h>
 #include <linux/module.h>
 #include <linux/of.h>
 #include <linux/platform_data/cros_ec_commands.h>
-#include <linux/platform_data/cros_ec_proto.h>
 #include <linux/platform_data/cros_usbpd_notify.h>
 #include <linux/platform_device.h>
-#include <linux/usb/pd.h>
 #include <linux/usb/pd_vdo.h>
-#include <linux/usb/typec.h>
-#include <linux/usb/typec_altmode.h>
 #include <linux/usb/typec_dp.h>
-#include <linux/usb/typec_mux.h>
-#include <linux/usb/typec_retimer.h>
 #include <linux/usb/typec_tbt.h>
-#include <linux/usb/role.h>
+
+#include "cros_ec_typec.h"
 
 #define DRV_NAME "cros-ec-typec"
 
 #define DP_PORT_VDO	(DP_CONF_SET_PIN_ASSIGN(BIT(DP_PIN_ASSIGN_C) | BIT(DP_PIN_ASSIGN_D)) | \
 				DP_CAP_DFP_D | DP_CAP_RECEPTACLE)
 
-/* Supported alt modes. */
-enum {
-	CROS_EC_ALTMODE_DP = 0,
-	CROS_EC_ALTMODE_TBT,
-	CROS_EC_ALTMODE_MAX,
-};
-
-/* Container for altmode pointer nodes. */
-struct cros_typec_altmode_node {
-	struct typec_altmode *amode;
-	struct list_head list;
-};
-
-/* Per port data. */
-struct cros_typec_port {
-	struct typec_port *port;
-	int port_num;
-	/* Initial capabilities for the port. */
-	struct typec_capability caps;
-	struct typec_partner *partner;
-	struct typec_cable *cable;
-	/* SOP' plug. */
-	struct typec_plug *plug;
-	/* Port partner PD identity info. */
-	struct usb_pd_identity p_identity;
-	/* Port cable PD identity info. */
-	struct usb_pd_identity c_identity;
-	struct typec_switch *ori_sw;
-	struct typec_mux *mux;
-	struct typec_retimer *retimer;
-	struct usb_role_switch *role_sw;
-
-	/* Variables keeping track of switch state. */
-	struct typec_mux_state state;
-	uint8_t mux_flags;
-	uint8_t role;
-
-	struct typec_altmode *port_altmode[CROS_EC_ALTMODE_MAX];
-
-	/* Flag indicating that PD partner discovery data parsing is completed. */
-	bool sop_disc_done;
-	bool sop_prime_disc_done;
-	struct ec_response_typec_discovery *disc_data;
-	struct list_head partner_mode_list;
-	struct list_head plug_mode_list;
-
-	/* PDO-related structs */
-	struct usb_power_delivery *partner_pd;
-	struct usb_power_delivery_capabilities *partner_src_caps;
-	struct usb_power_delivery_capabilities *partner_sink_caps;
-
-	struct cros_typec_data *typec_data;
-};
-
-/* Platform-specific data for the Chrome OS EC Type C controller. */
-struct cros_typec_data {
-	struct device *dev;
-	struct cros_ec_device *ec;
-	int num_ports;
-	unsigned int pd_ctrl_ver;
-	/* Array of ports, indexed by port number. */
-	struct cros_typec_port *ports[EC_USB_PD_MAX_PORTS];
-	struct notifier_block nb;
-	struct work_struct port_work;
-	bool typec_cmd_supported;
-	bool needs_mux_ack;
-};
-
 static int cros_typec_parse_port_props(struct typec_capability *cap,
 				       struct fwnode_handle *fwnode,
 				       struct device *dev)
diff --git a/drivers/platform/chrome/cros_ec_typec.h b/drivers/platform/chrome/cros_ec_typec.h
new file mode 100644
index 0000000000000..deda180a646f3
--- /dev/null
+++ b/drivers/platform/chrome/cros_ec_typec.h
@@ -0,0 +1,85 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+
+#ifndef __CROS_EC_TYPEC__
+#define __CROS_EC_TYPEC__
+
+#include <linux/list.h>
+#include <linux/notifier.h>
+#include <linux/platform_data/cros_ec_proto.h>
+#include <linux/usb/pd.h>
+#include <linux/usb/role.h>
+#include <linux/usb/typec.h>
+#include <linux/usb/typec_altmode.h>
+#include <linux/usb/typec_mux.h>
+#include <linux/usb/typec_retimer.h>
+#include <linux/workqueue.h>
+
+/* Supported alt modes. */
+enum {
+	CROS_EC_ALTMODE_DP = 0,
+	CROS_EC_ALTMODE_TBT,
+	CROS_EC_ALTMODE_MAX,
+};
+
+/* Container for altmode pointer nodes. */
+struct cros_typec_altmode_node {
+	struct typec_altmode *amode;
+	struct list_head list;
+};
+
+/* Platform-specific data for the Chrome OS EC Type C controller. */
+struct cros_typec_data {
+	struct device *dev;
+	struct cros_ec_device *ec;
+	int num_ports;
+	unsigned int pd_ctrl_ver;
+	/* Array of ports, indexed by port number. */
+	struct cros_typec_port *ports[EC_USB_PD_MAX_PORTS];
+	struct notifier_block nb;
+	struct work_struct port_work;
+	bool typec_cmd_supported;
+	bool needs_mux_ack;
+};
+
+/* Per port data. */
+struct cros_typec_port {
+	struct typec_port *port;
+	int port_num;
+	/* Initial capabilities for the port. */
+	struct typec_capability caps;
+	struct typec_partner *partner;
+	struct typec_cable *cable;
+	/* SOP' plug. */
+	struct typec_plug *plug;
+	/* Port partner PD identity info. */
+	struct usb_pd_identity p_identity;
+	/* Port cable PD identity info. */
+	struct usb_pd_identity c_identity;
+	struct typec_switch *ori_sw;
+	struct typec_mux *mux;
+	struct typec_retimer *retimer;
+	struct usb_role_switch *role_sw;
+
+	/* Variables keeping track of switch state. */
+	struct typec_mux_state state;
+	uint8_t mux_flags;
+	uint8_t role;
+
+	struct typec_altmode *port_altmode[CROS_EC_ALTMODE_MAX];
+
+	/* Flag indicating that PD partner discovery data parsing is completed. */
+	bool sop_disc_done;
+	bool sop_prime_disc_done;
+	struct ec_response_typec_discovery *disc_data;
+	struct list_head partner_mode_list;
+	struct list_head plug_mode_list;
+
+	/* PDO-related structs */
+	struct usb_power_delivery *partner_pd;
+	struct usb_power_delivery_capabilities *partner_src_caps;
+	struct usb_power_delivery_capabilities *partner_sink_caps;
+
+	struct cros_typec_data *typec_data;
+};
+
+#endif /*  __CROS_EC_TYPEC__ */
-- 
2.53.0



