Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030817;
	b=2Iewvkr6Nmz/0XonRdGXsiwbvF1ov6fQsM8A3swpH3Vud3ZNlkz+4Ku4cljNCBWL6AP7
	 1SvQ2A3C+cj4qRVkKaJb3D7j12yVsxb/iAv6m/fsV3Gj1cSOR76F9DHKayA/Pt5kE2Vy1
	 tLjP4Z6E8O99+NjfODZq/YyX4gs089AcdGOshblGQ5kqI1G2QD9+tHB8zlYF9ePnfUpVD
	 YLrdGTt0OcZrxCWfWWckc6XvXufX9cFUkXZNTlDOMjDUVaZMX5Shjcyy/MhCUDuM5dQuG
	 Lul3A9oLsPm5qTSkOIvKv/+pABR5wO28HgcEKKFRFzFF9LYfNBu7762LXABF91528lA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030817;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=NtGLsrwEsMVTvTl2v5H0Pg10PwG0ZZSK7IhbAk+HH3o=;
	b=4vdbXdbtH0MmjQTgLgRvT9WjmDxils7DGFsio/y/9iI4uptC2FCAfn/tKhOh9a8sxphD
	 Jvhnoyk7gLles6YunpNaQAZQ17xGpIM6x/xr+fCwcxOvIo7DpOQ8vk+IaKL1LyCLi4JZH
	 WCJ8D8NBxiuOVaq4mhhq/Xgz5H+bsrEkaEClfmfV1jFX99ZUVXoTpJ+y6V5yeU7O98Lvh
	 Gn/7IosNadKNTDxf7r5HPUf7K4uRHp22y71+kcGgEjswf4rsH+fN4EkJi5IMp7D1kTdp1
	 YqSZ1v7kZiJqgsSxsLzmN11bZGOWia7hgDL1QfzEjlOmi6S9+SETHiJYpihTp4rSq8w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RfOGIzs8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72234606C722;
	Wed, 18 Nov 2026 19:40:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RfOGIzs8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C77DF1F000C5;
	Wed, 18 Nov 2026 19:40:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795030817;
	bh=NtGLsrwEsMVTvTl2v5H0Pg10PwG0ZZSK7IhbAk+HH3o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RfOGIzs8tZcc7CBCxF21+Qu+vq1lX0gJX121BdAtj7crTZTdtH4nrrKRlqEiPJPe2
	 gTZjFqLKClNEk8C1Z7NO4q/UA4vgT1CNWe1maklB7VB8fdwqSnRPDEfw2eS6+beP17
	 hJ+gjb3U1LfltdEWod/Gdw3UL/xYg2Yx5pAyI4Ck=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Walleij <linusw@kernel.org>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0832/1756] power: supply: ab8500_charger: Decode AB8505 USB status
Date: Wed, 18 Nov 2026 15:49:19 +0100
Message-ID: <20261118150042.617356512@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linus Walleij <linusw@kernel.org>

[ Upstream commit 2b697df2b6394613a3bb168adfa8a845ad7c83d9 ]

AB8505 keeps USB link status in the same bit position as AB8500 but
defines a different five-bit value table. Reusing the AB8500 enum
treats several reserved AB8505 values as chargers and misidentifies
the AB8505 charger-fault and DM-high states.

Add an AB8505 decoder, reject reserved and non-charging states, and
retain conservative current limits for supported charger types.
Restrict the invalid-link workaround to AB8500 and stop processing
when the status register cannot be read.

Fixes: d4337660d069 ("ab8500-charger: Add AB8505_USB_LINK_STATUS")
Assisted-by: LLM
Signed-off-by: Linus Walleij <linusw@kernel.org>
Link: https://patch.msgid.link/20260916-ab8500-charging-v1-8-e986ed321cc6@kernel.org
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/ab8500_charger.c | 170 +++++++++++++++++++++-----
 1 file changed, 142 insertions(+), 28 deletions(-)

diff --git a/drivers/power/supply/ab8500_charger.c b/drivers/power/supply/ab8500_charger.c
index b3b1fd7f82f2b..8715f54f0a3ca 100644
--- a/drivers/power/supply/ab8500_charger.c
+++ b/drivers/power/supply/ab8500_charger.c
@@ -136,6 +136,33 @@ enum ab8500_charger_link_status {
 	USB_STAT_ACA_DOCK_CHARGER,
 };
 
+/* UsbLink1Status register values used by AB8505 */
+enum ab8505_charger_link_status {
+	AB8505_USB_STAT_OFF,
+	AB8505_USB_STAT_SDP_NOT_CHARGING,
+	AB8505_USB_STAT_SDP_CHARGING,
+	AB8505_USB_STAT_SDP_SUSPENDED,
+	AB8505_USB_STAT_CDP,
+	AB8505_USB_STAT_RESERVED_5,
+	AB8505_USB_STAT_RESERVED_6,
+	AB8505_USB_STAT_DCP,
+	AB8505_USB_STAT_ACA_RID_A,
+	AB8505_USB_STAT_ACA_RID_B,
+	AB8505_USB_STAT_ACA_RID_C,
+	AB8505_USB_STAT_RESERVED_11,
+	AB8505_USB_STAT_RESERVED_12,
+	AB8505_USB_STAT_UPSTREAM_IDGND,
+	AB8505_USB_STAT_CHARGER_NOT_OK,
+	AB8505_USB_STAT_CHARGER_DM_HIGH,
+	AB8505_USB_STAT_PHY_ENABLED,
+	AB8505_USB_STAT_UPSTREAM_NO_IDGND,
+	AB8505_USB_STAT_UPSTREAM_IDGND_VBUS,
+	AB8505_USB_STAT_CHARGER_SE1,
+	AB8505_USB_STAT_CARKIT_1,
+	AB8505_USB_STAT_CARKIT_2,
+	AB8505_USB_STAT_ACA_DOCK_CHARGER,
+};
+
 enum ab8500_usb_state {
 	AB8500_BM_USB_STATE_RESET_HS,	/* HighSpeed Reset */
 	AB8500_BM_USB_STATE_RESET_FS,	/* FullSpeed/LowSpeed Reset */
@@ -699,20 +726,102 @@ static int ab8500_charger_detect_chargers(struct ab8500_charger *di, bool probe)
 }
 
 /**
- * ab8500_charger_max_usb_curr() - get the max curr for the USB type
+ * ab8505_charger_max_usb_curr() - get the max current for the USB type
  * @di:			pointer to the ab8500_charger structure
  * @link_status:	the identified USB type
  *
- * Get the maximum current that is allowed to be drawn from the host
- * based on the USB type.
+ * Decode AB8505-specific UsbLink1Status values and get the maximum current
+ * that is allowed to be drawn based on the USB type.
  * Returns error code in case of failure else 0 on success
  */
+static int ab8505_charger_max_usb_curr(struct ab8500_charger *di,
+				       u8 link_status)
+{
+	int ret = 0;
+
+	di->is_aca_rid = 0;
+
+	switch (link_status) {
+	case AB8505_USB_STAT_SDP_NOT_CHARGING:
+	case AB8505_USB_STAT_SDP_CHARGING:
+	case AB8505_USB_STAT_SDP_SUSPENDED:
+	case AB8505_USB_STAT_CDP:
+	case AB8505_USB_STAT_CHARGER_DM_HIGH:
+	case AB8505_USB_STAT_UPSTREAM_NO_IDGND:
+	case AB8505_USB_STAT_UPSTREAM_IDGND_VBUS:
+	case AB8505_USB_STAT_CHARGER_SE1:
+	case AB8505_USB_STAT_CARKIT_1:
+	case AB8505_USB_STAT_CARKIT_2:
+	case AB8505_USB_STAT_ACA_DOCK_CHARGER:
+		di->max_usb_in_curr.usb_type_max_ua = USB_CH_IP_CUR_LVL_0P5;
+		break;
+	case AB8505_USB_STAT_DCP:
+		di->max_usb_in_curr.usb_type_max_ua = USB_CH_IP_CUR_LVL_1P5;
+		break;
+	case AB8505_USB_STAT_ACA_RID_A:
+		di->max_usb_in_curr.usb_type_max_ua = USB_CH_IP_CUR_LVL_0P5;
+		di->is_aca_rid = 1;
+		break;
+	case AB8505_USB_STAT_ACA_RID_B:
+		di->max_usb_in_curr.usb_type_max_ua = USB_CH_IP_CUR_LVL_1P3;
+		di->is_aca_rid = 1;
+		break;
+	case AB8505_USB_STAT_ACA_RID_C:
+		di->max_usb_in_curr.usb_type_max_ua = USB_CH_IP_CUR_LVL_1P5;
+		di->is_aca_rid = 1;
+		break;
+	case AB8505_USB_STAT_OFF:
+		if (di->vbus_detected) {
+			di->usb_device_is_unrecognised = true;
+			di->max_usb_in_curr.usb_type_max_ua =
+				USB_CH_IP_CUR_LVL_1P5;
+			break;
+		}
+		fallthrough;
+	case AB8505_USB_STAT_UPSTREAM_IDGND:
+	case AB8505_USB_STAT_PHY_ENABLED:
+		dev_err(di->dev, "USB Type - Charging not allowed\n");
+		di->max_usb_in_curr.usb_type_max_ua = USB_CH_IP_CUR_LVL_0P05;
+		ret = -ENXIO;
+		break;
+	case AB8505_USB_STAT_CHARGER_NOT_OK:
+		di->flags.vbus_collapse = true;
+		dev_err(di->dev, "USB Type - VBUS has collapsed\n");
+		di->max_usb_in_curr.usb_type_max_ua = USB_CH_IP_CUR_LVL_0P05;
+		ret = -ENXIO;
+		break;
+	case AB8505_USB_STAT_RESERVED_5:
+	case AB8505_USB_STAT_RESERVED_6:
+	case AB8505_USB_STAT_RESERVED_11:
+	case AB8505_USB_STAT_RESERVED_12:
+	default:
+		dev_err(di->dev, "USB Type - Unknown\n");
+		di->max_usb_in_curr.usb_type_max_ua = USB_CH_IP_CUR_LVL_0P05;
+		ret = -ENXIO;
+		break;
+	}
+
+	return ret;
+}
+
+/**
+ * ab8500_charger_max_usb_curr() - get the max current for the USB type
+ * @di:			pointer to the ab8500_charger structure
+ * @link_status:	the identified USB type
+ *
+ * Get the maximum current that is allowed to be drawn based on the USB type.
+ * Returns error code in case of failure else 0 on success.
+ */
 static int ab8500_charger_max_usb_curr(struct ab8500_charger *di,
-		enum ab8500_charger_link_status link_status)
+				       u8 link_status)
 {
 	int ret = 0;
 
 	di->usb_device_is_unrecognised = false;
+	if (is_ab8505(di->parent)) {
+		ret = ab8505_charger_max_usb_curr(di, link_status);
+		goto out;
+	}
 
 	/*
 	 * Platform only supports USB 2.0.
@@ -721,7 +830,7 @@ static int ab8500_charger_max_usb_curr(struct ab8500_charger *di,
 	 * should set USB_CH_IP_CUR_LVL_0P5.
 	 */
 
-	switch (link_status) {
+	switch ((enum ab8500_charger_link_status)link_status) {
 	case USB_STAT_STD_HOST_NC:
 	case USB_STAT_STD_HOST_C_NS:
 	case USB_STAT_STD_HOST_C_S:
@@ -825,6 +934,7 @@ static int ab8500_charger_max_usb_curr(struct ab8500_charger *di,
 		break;
 	}
 
+out:
 	di->max_usb_in_curr.set_max_ua = di->max_usb_in_curr.usb_type_max_ua;
 	dev_dbg(di->dev, "USB Type - 0x%02x MaxCurr: %d",
 		link_status, di->max_usb_in_curr.set_max_ua);
@@ -866,8 +976,7 @@ static int ab8500_charger_read_usb_type(struct ab8500_charger *di)
 		val = (val & AB8500_USB_LINK_STATUS) >> USB_LINK_STATUS_SHIFT;
 	else
 		val = (val & AB8505_USB_LINK_STATUS) >> USB_LINK_STATUS_SHIFT;
-	ret = ab8500_charger_max_usb_curr(di,
-		(enum ab8500_charger_link_status) val);
+	ret = ab8500_charger_max_usb_curr(di, val);
 
 	return ret;
 }
@@ -929,8 +1038,7 @@ static int ab8500_charger_detect_usb_type(struct ab8500_charger *di)
 		if (val)
 			break;
 	}
-	ret = ab8500_charger_max_usb_curr(di,
-		(enum ab8500_charger_link_status) val);
+	ret = ab8500_charger_max_usb_curr(di, val);
 
 	return ret;
 }
@@ -2278,6 +2386,7 @@ static void ab8500_charger_usb_link_status_work(struct work_struct *work)
 	int ret;
 	u8 val;
 	u8 link_status;
+	u8 link_status_mask;
 
 	struct ab8500_charger *di = container_of(work,
 		struct ab8500_charger, usb_link_status_work);
@@ -2304,20 +2413,22 @@ static void ab8500_charger_usb_link_status_work(struct work_struct *work)
 		ret = abx500_get_register_interruptible(di->dev, AB8500_USB,
 					AB8500_USB_LINK1_STAT_REG, &val);
 
-	if (ret >= 0)
-		dev_dbg(di->dev, "UsbLineStatus register = 0x%02x\n", val);
-	else
-		dev_dbg(di->dev, "Error reading USB link status\n");
+	if (ret < 0) {
+		dev_err(di->dev, "Error reading USB link status\n");
+		return;
+	}
+	dev_dbg(di->dev, "UsbLineStatus register = 0x%02x\n", val);
 
 	if (is_ab8500(di->parent))
-		link_status = AB8500_USB_LINK_STATUS;
+		link_status_mask = AB8500_USB_LINK_STATUS;
 	else
-		link_status = AB8505_USB_LINK_STATUS;
+		link_status_mask = AB8505_USB_LINK_STATUS;
+	link_status = (val & link_status_mask) >> USB_LINK_STATUS_SHIFT;
 
 	if (detected_chargers & USB_PW_CONN) {
-		if (((val & link_status) >> USB_LINK_STATUS_SHIFT) ==
-				USB_STAT_NOT_VALID_LINK &&
-				di->invalid_charger_detect_state == 0) {
+		if (is_ab8500(di->parent) &&
+		    link_status == USB_STAT_NOT_VALID_LINK &&
+		    di->invalid_charger_detect_state == 0) {
 			dev_dbg(di->dev,
 					"Invalid charger detected, state= 0\n");
 			/*Enable charger*/
@@ -2340,18 +2451,21 @@ static void ab8500_charger_usb_link_status_work(struct work_struct *work)
 			abx500_mask_and_set_register_interruptible(di->dev,
 					AB8500_USB, AB8500_USB_LINE_CTRL2_REG,
 					USB_CH_DET, 0x00);
-			/*Check link status*/
-			if (is_ab8500(di->parent))
-				ret = abx500_get_register_interruptible(di->dev,
-					AB8500_USB, AB8500_USB_LINE_STAT_REG,
-					&val);
-			else
-				ret = abx500_get_register_interruptible(di->dev,
-					AB8500_USB, AB8500_USB_LINK1_STAT_REG,
-					&val);
+			/* Check link status */
+			ret = abx500_get_register_interruptible(di->dev,
+								AB8500_USB,
+								AB8500_USB_LINE_STAT_REG,
+								&val);
+			if (ret < 0) {
+				dev_err(di->dev,
+					"Error reading USB link status\n");
+				return;
+			}
 
+			link_status = (val & link_status_mask) >>
+				USB_LINK_STATUS_SHIFT;
 			dev_dbg(di->dev, "USB link status= 0x%02x\n",
-				(val & link_status) >> USB_LINK_STATUS_SHIFT);
+				link_status);
 			di->invalid_charger_detect_state = 2;
 		}
 	} else {
-- 
2.53.0



