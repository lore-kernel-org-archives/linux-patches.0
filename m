Received: from mail-oo1-f52.google.com (mail-oo1-f52.google.com [209.85.161.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 138C23B2A4
	for <patches@lists.linux.dev>; Sat, 10 Feb 2024 07:10:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707549008; cv=none; b=mw/GRId0MKHDxH0rxXVCT6MIhp8x5VEEjK/JJgnfG1/AAwqqzXTiqix+HWDooQwJkr+MehbsVrzP6O8V7no/UX6NtUxgGzLB4oSm6uiexjrul0KeVcAlOlujBPTQvhWf0AD0GOxCsoEfj4ftG0l16M/JsWLHGpI26jc9mbX8ngM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707549008; c=relaxed/simple;
	bh=K7+22g0lNcVFXAqxGfKn8cA8DpWhqUDmXOrSd7iqmCI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ppZ34/YmdLDeMtSaUE5r1wMWppLRz9dOnFgMkPOzf8YyqVbrGfazBvtHq7MSpSaK813X3Z4ouKkTHmwxDeGtHMcK1+9rqKXo+4WL0Q1bupkAxdIi/XMkEoqx1KiMO0B/uNP93aV1qcW/rBhP7gyz91PjtgQCS+oYorCuf6LgGSU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=WYcMXWcx; arc=none smtp.client-ip=209.85.161.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="WYcMXWcx"
Received: by mail-oo1-f52.google.com with SMTP id 006d021491bc7-59a31c14100so680283eaf.0
        for <patches@lists.linux.dev>; Fri, 09 Feb 2024 23:10:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1707549005; x=1708153805; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wd31Lb0kMP3/plG0wIxMro3C79SofcRoKH3rOQKLIE8=;
        b=WYcMXWcxe69NArMqADEuCy66Ycu7YoWPyVFW/59J8UFVfUZJ780SpdjlivSJ8KSqx3
         5b3ZssBquKofhvd06lLHncohOfIplH9QJDEkx2LhlTI77VpMlEymIFPmkgrK3FaspNHy
         h0vHwgNvEpL0latJyoCbBnowiXGtaNh9HvPlo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707549005; x=1708153805;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wd31Lb0kMP3/plG0wIxMro3C79SofcRoKH3rOQKLIE8=;
        b=IkBuvfMx4qscf9bGqfNxjFq7smFVo/vGA88RKI00oN3RstKkJHi8G59TF8Xn7X1Arj
         +ZC7Jf+vkwK8fvNehQhnqZX9poW/U0FfqbATM2KKvXxRQcmQNaj/f0//BPJZcsRrJ82c
         NZfzfANKofIUAVIfbOdYbm8wuE/NlVU9/mFs2tZLR1BP+QvE/zJUNlHuce50ZFHTYPTU
         BaMQgzRgj0PMnd3ukCgFu1yjtdXAcSfWbC2NupdFzZ/7FpeP8KbnYJ7bvfYaUicTrgg8
         y119x0QZIt8a9+pxb+/scqJDx5zDd0OUzxArduOoT7Y0jm8WOqZVqHgu4t2uwYIZcpnN
         J0QA==
X-Gm-Message-State: AOJu0Yx30UcFxLG4j3sbUN2VcPHK4JsTe4fgGYrrk4+q8XGsdSBlDKaZ
	CRUFKUGuMpGoQ4uOcmNakNhjYeN2n9hnsajmeq3rl8+AEhQJwE4foDY7+IfQOg==
X-Google-Smtp-Source: AGHT+IFocyLptCHQu7cD93yC9LBb4sMmackx5/kVRGn/AZS0OVtF+h66UCQRfJiJiNXH0PNn702ejg==
X-Received: by 2002:a05:6358:724f:b0:178:a555:c312 with SMTP id i15-20020a056358724f00b00178a555c312mr1815970rwa.32.1707549005109;
        Fri, 09 Feb 2024 23:10:05 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCWsXajTcewLtH1HrGdkpwo/bXi1kEBGm247X7ndwkCI37Be0lgSn/r86+ticjkQ50MAl9j0WkD3/OgNgbjc5CGZLSgMv/O/cn/QLGOfzWSIUXhY+o+i8AeFCE9R7ZxKT5a9xyftvgYlR1a0aXrhwPB0kGGWhAWVIaoVYE2Zp3Le58g3nkYcszmEr2L3pRcSZDA0COGsE5cr9Uiu/yDo/7DaWuk8qmYkODuxvG4jM54L2LusI8+u7w2Xs5IIjla7PJ069w+gYCKzCrLPWIDsvnvX3Tj2vuvt4ao3KMyAJgwDTOUd8MWyhlxc28LdqCpWbuq3CoKNEh1qeJE1BJ8dWXL0jxc8JAmzKqkAwhIshq7JQfxdoeVG+g==
Received: from localhost (175.199.125.34.bc.googleusercontent.com. [34.125.199.175])
        by smtp.gmail.com with UTF8SMTPSA id e12-20020a17090ab38c00b0029652c53a32sm2831885pjr.33.2024.02.09.23.10.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 Feb 2024 23:10:04 -0800 (PST)
From: Stephen Boyd <swboyd@chromium.org>
To: chrome-platform@lists.linux.dev
Cc: linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	devicetree@vger.kernel.org,
	linux-arm-msm@vger.kernel.org,
	Douglas Anderson <dianders@chromium.org>,
	Pin-yen Lin <treapking@chromium.org>,
	Prashant Malani <pmalani@chromium.org>,
	Benson Leung <bleung@chromium.org>,
	Tzung-Bi Shih <tzungbi@kernel.org>
Subject: [PATCH 15/22] platform/chrome: cros_typec_switch: Support DP muxing via DRM lane assignment
Date: Fri,  9 Feb 2024 23:09:26 -0800
Message-ID: <20240210070934.2549994-16-swboyd@chromium.org>
X-Mailer: git-send-email 2.43.0.687.g38aa6559b0-goog
In-Reply-To: <20240210070934.2549994-1-swboyd@chromium.org>
References: <20240210070934.2549994-1-swboyd@chromium.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Implement DP lane assignment in the drm_bridge atomic_check() callback
so that DP altmode configurations like pinconf D can be supported and DP
muxing can be implemented. In the DP altmode spec, pinconf C assigns all
4 SuperSpeed lanes in the usb-c-connector node to DP, while pinconf D
assigns 2 SuperSpeed lanes to DP and 2 SuperSpeed lanes to USB. Use the
'data-lanes' property from the input DP graph port to calculate the
maximum number of lanes coming from the DP source (either 2 or
4) and limit the lanes requested to the smaller of this or the pin
configuration.

Once we know the maximum number of lanes that can be assigned, map the
DP lanes to the active type-c output port with the assigned pin
configuration. Use the 'data-lanes' property from the active type-c
output port to determine which logical DP lanes should be assigned to
the output of the drm_bridge. For now assume the type-c pins are in the
normal orientation.

This design supports different DP altmode pin configurations and also
allows us to effectively mux one DP phy to two different USB type-c
connectors by wiring the physical DP lanes to one or the other USB
type-c connectors in the hardware. For example, DP ML0/ML1 are hardwired
to one USB type-c connector and DP ML2/ML3 are hardwired to the other
connector. The 'data-lanes' of the first USB type-c port would be the
default "<0 1 2 3>" while the 'data-lanes' of the second USB type-c port
would be "<2 3 0 1>". Depending on the active USB type-c port, map the
logical DP lane to the logical type-c lane, and then find the physical
type-c lane corresponding to that logical lane from the type-c port's
'data-lanes' property. Once we have that, map the physical type-c lane
to the physical DP lane and request that physical DP lane as the logical
DP lane through the DRM lane assignment logic on the input of the
drm_bridge.

Cc: Prashant Malani <pmalani@chromium.org>
Cc: Benson Leung <bleung@chromium.org>
Cc: Tzung-Bi Shih <tzungbi@kernel.org>
Cc: <chrome-platform@lists.linux.dev>
Cc: Pin-yen Lin <treapking@chromium.org>
Signed-off-by: Stephen Boyd <swboyd@chromium.org>
---
 drivers/platform/chrome/cros_typec_switch.c | 136 +++++++++++++++++++-
 1 file changed, 131 insertions(+), 5 deletions(-)

diff --git a/drivers/platform/chrome/cros_typec_switch.c b/drivers/platform/chrome/cros_typec_switch.c
index d8fb6662cf8d..adcbf8f44c98 100644
--- a/drivers/platform/chrome/cros_typec_switch.c
+++ b/drivers/platform/chrome/cros_typec_switch.c
@@ -19,20 +19,28 @@
 #include <linux/usb/typec_mux.h>
 #include <linux/usb/typec_retimer.h>
 
+#include <drm/drm_atomic_state_helper.h>
 #include <drm/drm_bridge.h>
 #include <drm/drm_print.h>
 
 struct cros_typec_dp_bridge {
+	/* TODO: Add mutex lock to protect active_port with respect to drm/typec framework calls */
+	struct cros_typec_port *active_port;
 	struct cros_typec_switch_data *sdata;
+	size_t max_lanes;
 	bool hpd_enabled;
 	struct drm_bridge bridge;
 };
 
+#define USBC_LANES_COUNT 4
+
 /* Handles and other relevant data required for each port's switches. */
 struct cros_typec_port {
 	int port_num;
 	struct typec_mux_dev *mode_switch;
 	struct typec_retimer *retimer;
+	size_t num_dp_lanes;
+	u32 lane_mapping[USBC_LANES_COUNT];
 	struct cros_typec_switch_data *sdata;
 };
 
@@ -163,6 +171,8 @@ static int cros_typec_dp_port_switch_set(struct typec_mux_dev *mode_switch,
 	struct cros_typec_dp_bridge *typec_dp_bridge;
 	struct drm_bridge *bridge;
 	bool hpd_asserted;
+	u8 pin_assign;
+	size_t num_lanes, max_lanes;
 
 	port = typec_mux_get_drvdata(mode_switch);
 	typec_dp_bridge = port->sdata->typec_dp_bridge;
@@ -172,17 +182,41 @@ static int cros_typec_dp_port_switch_set(struct typec_mux_dev *mode_switch,
 	bridge = &typec_dp_bridge->bridge;
 
 	if (state->mode == TYPEC_STATE_SAFE || state->mode == TYPEC_STATE_USB) {
-		if (typec_dp_bridge->hpd_enabled)
-			drm_bridge_hpd_notify(bridge, connector_status_disconnected);
+		/* Clear active port when port isn't in DP mode */
+		port->num_dp_lanes = 0;
+		if (typec_dp_bridge->active_port == port) {
+			typec_dp_bridge->active_port = NULL;
+			if (typec_dp_bridge->hpd_enabled)
+				drm_bridge_hpd_notify(bridge, connector_status_disconnected);
+		}
 
 		return 0;
 	}
 
 	if (state->alt && state->alt->svid == USB_TYPEC_DP_SID) {
-		if (typec_dp_bridge->hpd_enabled) {
-			dp_data = state->data;
-			hpd_asserted = dp_data->status & DP_STATUS_HPD_STATE;
+		dp_data = state->data;
+		hpd_asserted = dp_data->status & DP_STATUS_HPD_STATE;
+		/*
+		 * Assume the first port to have HPD asserted is the one muxed
+		 * to DP (i.e. active_port). When there's only one port this
+		 * delays setting the active_port until HPD is asserted, but
+		 * before that the drm_connector looks disconnected so
+		 * active_port doesn't need to be set.
+		 */
+		if (hpd_asserted && !typec_dp_bridge->active_port)
+			typec_dp_bridge->active_port = port;
 
+		/* Determine number of logical DP lanes from pin assignment */
+		pin_assign = DP_CONF_GET_PIN_ASSIGN(dp_data->conf);
+		if (pin_assign == DP_PIN_ASSIGN_D)
+			num_lanes = 2;
+		else
+			num_lanes = 4;
+		max_lanes = typec_dp_bridge->max_lanes;
+		port->num_dp_lanes = min(num_lanes, max_lanes);
+
+		/* Only notify hpd state for the port that has entered DP mode. */
+		if (typec_dp_bridge->hpd_enabled && typec_dp_bridge->active_port == port) {
 			if (hpd_asserted)
 				drm_bridge_hpd_notify(bridge, connector_status_connected);
 			else
@@ -278,6 +312,81 @@ bridge_to_cros_typec_dp_bridge(struct drm_bridge *bridge)
 	return container_of(bridge, struct cros_typec_dp_bridge, bridge);
 }
 
+static int dp_lane_to_typec_lane(unsigned int dp_lane)
+{
+	switch (dp_lane) {
+	case 0:
+		return 2;
+	case 1:
+		return 3;
+	case 2:
+		return 1;
+	case 3:
+		return 0;
+	}
+
+	return -EINVAL;
+}
+
+static int typec_to_dp_lane(unsigned int typec_lane)
+{
+	switch (typec_lane) {
+	case 0:
+		return 3;
+	case 1:
+		return 2;
+	case 2:
+		return 0;
+	case 3:
+		return 1;
+	}
+
+	return -EINVAL;
+}
+
+static int cros_typec_dp_bridge_atomic_check(struct drm_bridge *bridge,
+			    struct drm_bridge_state *bridge_state,
+			    struct drm_crtc_state *crtc_state,
+			    struct drm_connector_state *conn_state)
+{
+	struct cros_typec_dp_bridge *typec_dp_bridge;
+	struct drm_lane_cfg *in_lanes;
+	size_t num_lanes;
+	struct cros_typec_port *port;
+	int i, typec_lane;
+
+	typec_dp_bridge = bridge_to_cros_typec_dp_bridge(bridge);
+	if (!typec_dp_bridge->active_port)
+		return -ENODEV;
+
+	port = typec_dp_bridge->active_port;
+
+	num_lanes = port->num_dp_lanes;
+	in_lanes = kcalloc(num_lanes, sizeof(*in_lanes), GFP_KERNEL);
+	if (!in_lanes)
+		return -ENOMEM;
+
+	bridge_state->input_bus_cfg.lanes = in_lanes;
+	bridge_state->input_bus_cfg.num_lanes = num_lanes;
+
+	for (i = 0; i < num_lanes; i++) {
+		/* Get physical type-c lane for DP lane */
+		typec_lane = dp_lane_to_typec_lane(i);
+		if (typec_lane < 0) {
+			DRM_ERROR("Invalid type-c lane configuration\n");
+			return -EINVAL;
+		}
+
+		/* Map to logical type-c lane */
+		typec_lane = port->lane_mapping[typec_lane];
+
+		/* Map logical type-c lane to logical DP lane */
+		in_lanes[i].logical = typec_to_dp_lane(typec_lane);
+	}
+
+	return 0;
+}
+
 static void cros_typec_dp_bridge_hpd_enable(struct drm_bridge *bridge)
 {
 	struct cros_typec_dp_bridge *typec_dp_bridge;
@@ -296,6 +405,10 @@ static void cros_typec_dp_bridge_hpd_disable(struct drm_bridge *bridge)
 
 static const struct drm_bridge_funcs cros_typec_dp_bridge_funcs = {
 	.attach = cros_typec_dp_bridge_attach,
+	.atomic_check = cros_typec_dp_bridge_atomic_check,
+	.atomic_reset = drm_atomic_helper_bridge_reset,
+	.atomic_duplicate_state = drm_atomic_helper_bridge_duplicate_state,
+	.atomic_destroy_state = drm_atomic_helper_bridge_destroy_state,
 	.hpd_enable = cros_typec_dp_bridge_hpd_enable,
 	.hpd_disable = cros_typec_dp_bridge_hpd_disable,
 };
@@ -305,6 +418,7 @@ static int cros_typec_register_dp_bridge(struct cros_typec_switch_data *sdata,
 {
 	struct cros_typec_dp_bridge *typec_dp_bridge;
 	struct drm_bridge *bridge;
+	int num_lanes;
 	struct device *dev = sdata->dev;
 
 	typec_dp_bridge = devm_kzalloc(dev, sizeof(*typec_dp_bridge), GFP_KERNEL);
@@ -313,6 +427,12 @@ static int cros_typec_register_dp_bridge(struct cros_typec_switch_data *sdata,
 
 	typec_dp_bridge->sdata = sdata;
 	sdata->typec_dp_bridge = typec_dp_bridge;
+
+	num_lanes = fwnode_property_count_u32(fwnode, "data-lanes");
+	if (num_lanes < 0)
+		num_lanes = 4;
+	typec_dp_bridge->max_lanes = num_lanes;
+
 	bridge = &typec_dp_bridge->bridge;
 
 	bridge->funcs = &cros_typec_dp_bridge_funcs;
@@ -333,6 +453,7 @@ static int cros_typec_register_port(struct cros_typec_switch_data *sdata,
 	struct fwnode_handle *port_node;
 	u32 index;
 	int ret;
+	const u32 default_lane_mapping[] = { 0, 1, 2, 3 };
 	const char *prop_name;
 
 	port = devm_kzalloc(dev, sizeof(*port), GFP_KERNEL);
@@ -359,6 +480,11 @@ static int cros_typec_register_port(struct cros_typec_switch_data *sdata,
 	port->port_num = index;
 	sdata->ports[index] = port;
 
+	if (fwnode_property_read_u32_array(fwnode, "data-lanes",
+					   port->lane_mapping,
+					   ARRAY_SIZE(port->lane_mapping)))
+		memcpy(port->lane_mapping, default_lane_mapping, sizeof(default_lane_mapping));
+
 	port_node = fwnode;
 	if (np)
 		fwnode = fwnode_graph_get_port_parent(fwnode);
-- 
https://chromeos.dev

