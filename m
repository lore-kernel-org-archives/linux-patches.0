Received: from mail-ot1-f41.google.com (mail-ot1-f41.google.com [209.85.210.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FA691E6722
	for <patches@lists.linux.dev>; Mon, 19 Aug 2024 22:38:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724107135; cv=none; b=H0Nm/RvTjBwcvujTMA2ByTNS+dtf4OqUGfBJ/09fFw3n5vw4OjcUAiOlhfCnRdpr+GuBAL0Gn8M5x3MKuexdVc5EcMe1oYVpn5CgEWJkJF5tHc3SXI1UMt/1fFRAPShKb0RELaLa9LRhCHCVTULhACU2w9Zm0OSogaFPwM8/eko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724107135; c=relaxed/simple;
	bh=5K13Rr7Ye52MphZA4brc+qhak8CJv7kQslQnmneUWjM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RZMr9XvxNzhoAO2hC5XTA+Enx1cqdUtLMTZ4fmfe+OQKQ6ejysiBX+rfgRJ9jKyxjhgfubeY70eVimvcvToY2X5pXHQowQcY7jGIYK1xK7lRquwAs7YaOTP9cKtcCbPpC/9Pmm+I/adu7kWWnGjL4U+U5peojtQIS/FVPNpHsB8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=hxhNjPCO; arc=none smtp.client-ip=209.85.210.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="hxhNjPCO"
Received: by mail-ot1-f41.google.com with SMTP id 46e09a7af769-70b3b62025dso3431699a34.0
        for <patches@lists.linux.dev>; Mon, 19 Aug 2024 15:38:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1724107132; x=1724711932; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VbFRLEAP1yQ8phmhKg1xt4/PZ50JZmra4jTs/cBI9Fc=;
        b=hxhNjPCO2SDHrX03c+lVF6y9EcWK9ssPzTtpcRibDvY0/MBoeMl2GaDZxHZteSN4YI
         esmvfz3wo8jdbW9V9RksKYfcFFdaZBZTGVDR1vDtL4hPpIVWEP4jgJaxK45VlgVkKOBs
         4NvgjrTrO9aBrKBZ8kFxZOwth+FhRKxngYUrE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724107132; x=1724711932;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VbFRLEAP1yQ8phmhKg1xt4/PZ50JZmra4jTs/cBI9Fc=;
        b=cPvsKEg8/wMwlpxQzMj+gZCEy3393yjWRC2yKrNI/qbuJjoebLxc9BKjKponSQnfrX
         Ic0pqx6wZauyMhiVGHxoJS1k+DFm/959+fn0pJdL7hsVSnfSBV1yGmCv/9q1Mskw5GKh
         fMBZQRbWkAO8zHUm/c3rJ7f9qjd00SCn6PD3S2Sxb4xVgPDpgxRNh7y4Nann1kzcaY+0
         nEEzd70JEV8SqPAtcnwARRvdm5GOnz6iT4YzM4ttx8HKeRrwQVYDqYEiW58z/ouDvmb0
         rYvp9ztdPR5PHgx86jcwbcu+cBcIVeIDTSo4PmjJRAqbE8PtmQuB832kGr4cckvEgDV4
         UEng==
X-Forwarded-Encrypted: i=1; AJvYcCW2o3Pjr0rNJRqivrEjHeMOzi7rlncxU4WTTfZgCSTu23sQQ3r6BbeyFkLHnXq8WwLpbNJF5XSWk59eQlv660Ozn5F3gdlyvg==
X-Gm-Message-State: AOJu0YwpEz6A7U82Xcos0usS8+KetoaUGIkwgx36CHYdTGPgBletwdpW
	w3Z2NpfWfujZRn81KGj4qu/gax8ANh03GaJWy0TgGfYgS4vsECRZrBthERn7EA==
X-Google-Smtp-Source: AGHT+IGU+fzlXtM8B7VTp6DiytUOY+YJu/MAdpU9aLNWJBc8EuVBU83rDKxEo/rTgqaOBZmzP3dSGw==
X-Received: by 2002:a05:6870:c1d0:b0:267:dfce:95eb with SMTP id 586e51a60fabf-2701c345f49mr14663404fac.5.1724107132395;
        Mon, 19 Aug 2024 15:38:52 -0700 (PDT)
Received: from localhost (210.73.125.34.bc.googleusercontent.com. [34.125.73.210])
        by smtp.gmail.com with UTF8SMTPSA id 41be03b00d2f7-7c6b61c60f7sm8091519a12.22.2024.08.19.15.38.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Aug 2024 15:38:51 -0700 (PDT)
From: Stephen Boyd <swboyd@chromium.org>
To: chrome-platform@lists.linux.dev
Cc: linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	devicetree@vger.kernel.org,
	Douglas Anderson <dianders@chromium.org>,
	Pin-yen Lin <treapking@chromium.org>,
	Andrzej Hajda <andrzej.hajda@intel.com>,
	Benson Leung <bleung@chromium.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Daniel Vetter <daniel@ffwll.ch>,
	David Airlie <airlied@gmail.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	dri-devel@lists.freedesktop.org,
	Guenter Roeck <groeck@chromium.org>,
	Jernej Skrabec <jernej.skrabec@gmail.com>,
	Jonas Karlman <jonas@kwiboo.se>,
	Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
	Laurent Pinchart <Laurent.pinchart@ideasonboard.com>,
	Lee Jones <lee@kernel.org>,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Maxime Ripard <mripard@kernel.org>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Prashant Malani <pmalani@chromium.org>,
	Robert Foss <rfoss@kernel.org>,
	Rob Herring <robh+dt@kernel.org>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Tzung-Bi Shih <tzungbi@kernel.org>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Daniel Scally <djrscally@gmail.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Ivan Orlov <ivan.orlov0322@gmail.com>,
	linux-acpi@vger.kernel.org,
	linux-usb@vger.kernel.org,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	"Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH v3 07/17] drm/bridge: dp_typec: Support USB Type-C orientation
Date: Mon, 19 Aug 2024 15:38:21 -0700
Message-ID: <20240819223834.2049862-8-swboyd@chromium.org>
X-Mailer: git-send-email 2.46.0.184.g6999bdac58-goog
In-Reply-To: <20240819223834.2049862-1-swboyd@chromium.org>
References: <20240819223834.2049862-1-swboyd@chromium.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Register an orientation switch for each type-c output node to support
flipping the lane mapping when the port is in reverse orientation. Only
do this when the orientation-switch property is present. This is mostly
useful for the case where the DP lanes are directly connected to the
usb-c-connector and the device doesn't have an orientation switch wired
down on the board between the connector and the DP controller.

Cc: Prashant Malani <pmalani@chromium.org>
Cc: Benson Leung <bleung@chromium.org>
Cc: Tzung-Bi Shih <tzungbi@kernel.org>
Cc: <chrome-platform@lists.linux.dev>
Cc: Pin-yen Lin <treapking@chromium.org>
Cc: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Stephen Boyd <swboyd@chromium.org>
---
 drivers/gpu/drm/bridge/aux-hpd-bridge.c | 74 +++++++++++++++++++++----
 1 file changed, 63 insertions(+), 11 deletions(-)

diff --git a/drivers/gpu/drm/bridge/aux-hpd-bridge.c b/drivers/gpu/drm/bridge/aux-hpd-bridge.c
index 47315a8077a3..3d33f7936cbc 100644
--- a/drivers/gpu/drm/bridge/aux-hpd-bridge.c
+++ b/drivers/gpu/drm/bridge/aux-hpd-bridge.c
@@ -47,12 +47,15 @@ struct drm_dp_typec_bridge_data;
 /**
  * struct drm_dp_typec_bridge_typec_port - USB type-c port associated with DP bridge
  * @lane_mapping: Physical (array index) to logical (array value) USB type-C lane mapping
+ * @orientation: Orientation of USB type-c port
  * @mode_switch: DP altmode switch
  * @typec_data: Back pointer to type-c bridge data
  */
 struct drm_dp_typec_bridge_typec_port {
 	u32 lane_mapping[NUM_USB_SS];
+	enum typec_orientation orientation;
 	struct typec_mux_dev *mode_switch;
+	struct typec_switch_dev *orientation_switch;
 	struct drm_dp_typec_bridge_data *typec_data;
 };
 
@@ -378,17 +381,35 @@ static int dp_lane_to_typec_lane(enum dp_lane lane)
 	return -EINVAL;
 }
 
-static int typec_to_dp_lane(enum usb_ss_lane lane)
+static int typec_to_dp_lane(enum usb_ss_lane lane,
+			    enum typec_orientation orientation)
 {
-	switch (lane) {
-	case USB_SSRX1:
-		return DP_ML3;
-	case USB_SSTX1:
-		return DP_ML2;
-	case USB_SSTX2:
-		return DP_ML0;
-	case USB_SSRX2:
-		return DP_ML1;
+	switch (orientation) {
+	case TYPEC_ORIENTATION_NONE:
+	case TYPEC_ORIENTATION_NORMAL:
+		switch (lane) {
+		case USB_SSRX1:
+			return DP_ML3;
+		case USB_SSTX1:
+			return DP_ML2;
+		case USB_SSTX2:
+			return DP_ML0;
+		case USB_SSRX2:
+			return DP_ML1;
+		}
+		break;
+	case TYPEC_ORIENTATION_REVERSE:
+		switch (lane) {
+		case USB_SSRX1:
+			return DP_ML0;
+		case USB_SSTX1:
+			return DP_ML1;
+		case USB_SSTX2:
+			return DP_ML3;
+		case USB_SSRX2:
+			return DP_ML2;
+		}
+		break;
 	}
 
 	return -EINVAL;
@@ -413,6 +434,7 @@ drm_dp_typec_bridge_assign_pins(struct drm_dp_typec_bridge_dev *typec_bridge_dev
 				u32 conf,
 				struct drm_dp_typec_bridge_typec_port *port)
 {
+	enum typec_orientation orientation = port->orientation;
 	enum usb_ss_lane *lane_mapping = port->lane_mapping;
 	struct auxiliary_device *adev = &typec_bridge_dev->adev;
 	struct drm_aux_hpd_bridge_data *hpd_data = auxiliary_get_drvdata(adev);
@@ -448,7 +470,7 @@ drm_dp_typec_bridge_assign_pins(struct drm_dp_typec_bridge_dev *typec_bridge_dev
 		typec_lane = lane_mapping[typec_lane];
 
 		/* Map logical type-c lane to logical DP lane */
-		dp_lanes[i] = typec_to_dp_lane(typec_lane);
+		dp_lanes[i] = typec_to_dp_lane(typec_lane, orientation);
 	}
 
 	return 0;
@@ -496,6 +518,23 @@ static const struct drm_bridge_funcs drm_dp_typec_bridge_funcs = {
 	.atomic_destroy_state = drm_atomic_helper_bridge_destroy_state,
 };
 
+static int drm_dp_typec_bridge_orientation_set(struct typec_switch_dev *sw,
+					       enum typec_orientation orientation)
+{
+	struct drm_dp_typec_bridge_typec_port *port;
+
+	/*
+	 * Lane remapping is in drm_dp_typec_bridge_mode_switch_set(). Whenever
+	 * an orientation changes the mode will switch in and out of DP mode,
+	 * HPD will deassert and reassert so that
+	 * drm_dp_typec_bridge_atomic_check() sees the proper state.
+	 */
+	port = typec_switch_get_drvdata(sw);
+	port->orientation = orientation;
+
+	return 0;
+}
+
 static int
 drm_dp_typec_bridge_mode_switch_set(struct typec_mux_dev *mode_switch,
 				    struct typec_mux_state *state)
@@ -544,7 +583,9 @@ drm_dp_typec_bridge_probe_typec_ports(struct drm_dp_typec_bridge_data *typec_dat
 	struct drm_dp_typec_bridge_typec_port *port;
 	size_t num_ports = typec_bridge_dev->num_typec_ports;
 	struct typec_mux_desc mode_switch_desc = { };
+	struct typec_switch_desc orientation_switch_desc = { };
 	struct fwnode_handle *fwnode;
+	bool orientation = of_property_read_bool(np, "orientation-switch");
 
 	port = devm_kcalloc(dev, num_ports, sizeof(*port), GFP_KERNEL);
 	if (!port)
@@ -581,6 +622,17 @@ drm_dp_typec_bridge_probe_typec_ports(struct drm_dp_typec_bridge_data *typec_dat
 		if (IS_ERR(port->mode_switch))
 			return PTR_ERR(port->mode_switch);
 
+		if (orientation) {
+			orientation_switch_desc.set = drm_dp_typec_bridge_orientation_set,
+			orientation_switch_desc.fwnode = fwnode;
+			orientation_switch_desc.drvdata = port;
+			orientation_switch_desc.name = fwnode_get_name(fwnode);
+			port->orientation_switch = typec_switch_register(dev,
+									 &orientation_switch_desc);
+			if (IS_ERR(port->orientation_switch))
+				return PTR_ERR(port->orientation_switch);
+		}
+
 		port++;
 	}
 
-- 
https://chromeos.dev

