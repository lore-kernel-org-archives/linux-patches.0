Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3843613D503
	for <patches@lists.linux.dev>; Sun,  1 Sep 2024 04:07:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725163644; cv=none; b=BTxqSl5BOmfTUg15mgSj9dkLc6r6HEO3HcSuHeeRTwbbMMklTvgluGDPBHfowkS3wRAh9ACGwa99yYjSQdVS5/4gaAjgZIWOiOdx6ZpXzYQaOiCeNcH2PWIqGeT27pAa6E24G3nOHlAi2NF2wFO15jzjYfkUx9HEvuaj/gV+xv0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725163644; c=relaxed/simple;
	bh=gQLHbxZ7YqvGpXB1p1t8XiyRzrvBZDrPBVB81RgQmGw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Wc9pSC7MIFGvWf+3f8Hrln6E2uAq3EqZmwoJaeCfsRDodbTdYXZ+7iS4m/v5yb6RlmAMOw4W9efx9nJ9YAZZR5Rxdzo11zlmkpgCmSEoX9E4HgSAbYAhTdlCvkYmcAAJJ37VMyPJTLWq8aj1psw0NXs5p42TtA1OgSIqTKri4KQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=Io2UkTlS; arc=none smtp.client-ip=209.85.216.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="Io2UkTlS"
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-2d8818337a5so1040890a91.1
        for <patches@lists.linux.dev>; Sat, 31 Aug 2024 21:07:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1725163642; x=1725768442; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7B0A+gjnynDK46J7Z91Ni0fcqv7iZd2DyUsBegaNPWE=;
        b=Io2UkTlSBOnGUY0DWQZqgX6g52pvOPEWURMOL9QQ+t0A/ysDaZnQT2U1ILDiV2yDx7
         ocEcDraDSpOfxXSHoUhpTSg1lb+PkQyJaRTUamdOwBGqNDuSkNR6E/GrEV/MOkqWiilC
         7Siahv7x3hkPb3f/VFSoQBrs7Xc5c0a5aZEco=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725163642; x=1725768442;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7B0A+gjnynDK46J7Z91Ni0fcqv7iZd2DyUsBegaNPWE=;
        b=TYntfy6If1J50hC7pQdSQ7qEvVNHM/lNvpp2oekFGIAFkMdVywuiz+4L14FBgl523X
         Ti80oOqiP3SELkoWyV2YM50Vk6mCMbRccOMP/h9GdOh0dfPOz6NXy5/0iLYBwKq9e8xD
         KBDRUb8ma8k0PIzBVTsWXYdGaAUMPYJvz9C6XBmeXpEtpOy9k+D4SEXsRC0zd9/pNwee
         j+vXl9CEgy4X9gax8LNaCz5mmL8NPkh4unrqLzpcM3HiwRjv/L140dhD3EeSSQtrQSvT
         F6MK+TsxIJHhpX67Sg333VQ/TytEN0KkZYShicPPecUKXAkzK/l2KlHeSCgZLxXUSuWa
         rvsg==
X-Forwarded-Encrypted: i=1; AJvYcCVStXv1qP9NNMc+1a7F++CTFXzCbuqMPvn30dfhWDuYNun4ai9i9ltfUusZ4Fd+4CE4I7xbJzat@lists.linux.dev
X-Gm-Message-State: AOJu0Yxt9io4PahndFonOM2mPV0+ITmqTUASVh5MlR0YHsVNaHXzzOkt
	XlSWIsIoMUWGU3JGi48V1em73bTCs7Eg5PLOQ5Dq98huG9F4TS+EjtGtWEMqqw==
X-Google-Smtp-Source: AGHT+IGSmH/wnxTJNBBOPKMZLyVY9PSbNYj6DYaZsk5ViTxQvzorla6wmYK6YTGx9bSlm2MFyUGXzg==
X-Received: by 2002:a17:90a:d310:b0:2cf:f860:f13b with SMTP id 98e67ed59e1d1-2d86b04e9eemr10621245a91.17.1725163641373;
        Sat, 31 Aug 2024 21:07:21 -0700 (PDT)
Received: from localhost (210.73.125.34.bc.googleusercontent.com. [34.125.73.210])
        by smtp.gmail.com with UTF8SMTPSA id 98e67ed59e1d1-2d844611384sm8985683a91.27.2024.08.31.21.07.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 31 Aug 2024 21:07:21 -0700 (PDT)
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
Subject: [PATCH v4 09/18] drm/bridge: dp_typec: Allow users to hook hpd notify path
Date: Sat, 31 Aug 2024 21:06:47 -0700
Message-ID: <20240901040658.157425-10-swboyd@chromium.org>
X-Mailer: git-send-email 2.46.0.469.g59c65b2a67-goog
In-Reply-To: <20240901040658.157425-1-swboyd@chromium.org>
References: <20240901040658.157425-1-swboyd@chromium.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The previous patch added support for no-hpd to drm_dp_typec_bridge code.
Allow users of this bridge to hook the HPD notification path of the
bridge chain so that they can be made aware of the connector status
changing. This helps HPD-less users of the bridge inject the HPD state
into their code by using the connector status as a proxy for HPD being
asserted or deasserted.

In particular, this will help Trogdor/Strongbad boards that need to read
the EC's analog mux which steers the DP signal to one or the other USB
type-c ports to figure out which type-c port has HPD asserted.

Cc: Prashant Malani <pmalani@chromium.org>
Cc: Benson Leung <bleung@chromium.org>
Cc: Tzung-Bi Shih <tzungbi@kernel.org>
Cc: <chrome-platform@lists.linux.dev>
Cc: Pin-yen Lin <treapking@chromium.org>
Cc: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Stephen Boyd <swboyd@chromium.org>
---
 drivers/gpu/drm/bridge/aux-hpd-bridge.c | 31 +++++++++++++++++++++++++
 include/drm/bridge/aux-bridge.h         |  9 +++++++
 2 files changed, 40 insertions(+)

diff --git a/drivers/gpu/drm/bridge/aux-hpd-bridge.c b/drivers/gpu/drm/bridge/aux-hpd-bridge.c
index 52db36aa190b..8ff8716b2630 100644
--- a/drivers/gpu/drm/bridge/aux-hpd-bridge.c
+++ b/drivers/gpu/drm/bridge/aux-hpd-bridge.c
@@ -93,6 +93,8 @@ struct drm_dp_typec_bridge_dev {
 	struct auxiliary_device adev;
 	size_t max_lanes;
 	size_t num_typec_ports;
+	void (*hpd_notify)(void *data, enum drm_connector_status status);
+	void *hpd_data;
 };
 
 static inline struct drm_dp_typec_bridge_dev *
@@ -324,6 +326,21 @@ devm_drm_dp_typec_bridge_alloc(struct device *parent, struct device_node *np)
 }
 EXPORT_SYMBOL_GPL(devm_drm_dp_typec_bridge_alloc);
 
+/**
+ * drm_dp_typec_bridge_add_hpd_notify: Register a callback called when the
+ * bridge chain hpd state changes
+ * @typec_bridge_dev: USB type-c DisplayPort bridge
+ * @hpd_notify: callback for bridge hot plug detect events
+ * @hpd_data: data passed to @hpd_notify callback
+ */
+void drm_dp_typec_bridge_add_hpd_notify(struct drm_dp_typec_bridge_dev *typec_bridge_dev,
+					hpd_notify_fn_t hpd_notify, void *hpd_data)
+{
+	typec_bridge_dev->hpd_notify = hpd_notify;
+	typec_bridge_dev->hpd_data = hpd_data;
+}
+EXPORT_SYMBOL_GPL(drm_dp_typec_bridge_add_hpd_notify);
+
 /**
  * devm_drm_dp_typec_bridge_add - register a USB type-c DisplayPort bridge
  * @dev: struct device to tie registration lifetime to
@@ -363,6 +380,19 @@ void drm_aux_hpd_bridge_notify(struct device *dev, enum drm_connector_status sta
 }
 EXPORT_SYMBOL_GPL(drm_aux_hpd_bridge_notify);
 
+static void drm_dp_typec_bridge_hpd_notify(struct drm_bridge *bridge,
+					    enum drm_connector_status status)
+{
+	struct drm_dp_typec_bridge_data *data;
+	struct drm_dp_typec_bridge_dev *typec_bridge_dev;
+
+	data = to_drm_dp_typec_bridge_data(bridge);
+	typec_bridge_dev = to_drm_dp_typec_bridge_dev(data->hpd_bridge.dev);
+
+	if (typec_bridge_dev->hpd_notify)
+		typec_bridge_dev->hpd_notify(typec_bridge_dev->hpd_data, status);
+}
+
 static int drm_aux_hpd_bridge_attach(struct drm_bridge *bridge,
 				     enum drm_bridge_attach_flags flags)
 {
@@ -520,6 +550,7 @@ static const struct drm_bridge_funcs drm_dp_typec_bridge_funcs = {
 	.atomic_reset = drm_atomic_helper_bridge_reset,
 	.atomic_duplicate_state = drm_atomic_helper_bridge_duplicate_state,
 	.atomic_destroy_state = drm_atomic_helper_bridge_destroy_state,
+	.hpd_notify = drm_dp_typec_bridge_hpd_notify,
 };
 
 static int drm_dp_typec_bridge_orientation_set(struct typec_switch_dev *sw,
diff --git a/include/drm/bridge/aux-bridge.h b/include/drm/bridge/aux-bridge.h
index 73fc8582ec07..300f4a203a9b 100644
--- a/include/drm/bridge/aux-bridge.h
+++ b/include/drm/bridge/aux-bridge.h
@@ -22,6 +22,8 @@ static inline int drm_aux_bridge_register(struct device *parent)
 
 struct drm_dp_typec_bridge_dev;
 
+typedef void (*hpd_notify_fn_t)(void *data, enum drm_connector_status status);
+
 #if IS_ENABLED(CONFIG_DRM_AUX_HPD_BRIDGE)
 struct auxiliary_device *devm_drm_dp_hpd_bridge_alloc(struct device *parent, struct device_node *np);
 int devm_drm_dp_hpd_bridge_add(struct device *dev, struct auxiliary_device *adev);
@@ -30,6 +32,8 @@ struct device *drm_dp_hpd_bridge_register(struct device *parent,
 void drm_aux_hpd_bridge_notify(struct device *dev, enum drm_connector_status status);
 struct drm_dp_typec_bridge_dev *devm_drm_dp_typec_bridge_alloc(struct device *parent,
 							       struct device_node *np);
+void drm_dp_typec_bridge_add_hpd_notify(struct drm_dp_typec_bridge_dev *typec_bridge_dev,
+					hpd_notify_fn_t hpd_notify, void *hpd_data);
 int devm_drm_dp_typec_bridge_add(struct device *dev, struct drm_dp_typec_bridge_dev *typec_bridge_dev);
 #else
 static inline struct auxiliary_device *devm_drm_dp_hpd_bridge_alloc(struct device *parent,
@@ -55,6 +59,11 @@ devm_drm_dp_typec_bridge_alloc(struct device *parent, struct device_node *np)
 	return NULL;
 }
 
+static inline void drm_dp_typec_bridge_add_hpd_notify(struct drm_dp_typec_bridge_dev *typec_bridge_dev,
+						      hpd_notify_fn_t hpd_notify, void *hpd_data)
+{
+}
+
 static inline int devm_drm_dp_typec_bridge_add(struct device *dev,
 					       struct drm_dp_typec_bridge_dev *typec_bridge_dev)
 {
-- 
https://chromeos.dev

