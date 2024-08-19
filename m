Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6ABC61E3CBA
	for <patches@lists.linux.dev>; Mon, 19 Aug 2024 22:38:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724107140; cv=none; b=mTsysiHxstTdZ3tPKsdr6zHqQLXmRYMT0rq3vp9ixQ6hSTvja+4+ZH15IIbzlvwAYnO9xKvaHi+ChCRqvXsASHYs55tkGgwP2hJ3YcVHUnJe9mP8txqKMAQ628mvi1j05ksJgCPTqJRJm27P+DVZd2FYWHkAcSoG3suaae/qDD0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724107140; c=relaxed/simple;
	bh=4V2ipobc0QJANgLcRKLlZNLcULLuLPLzgIJNP1W0OjA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O+cX3uYLmmI+s3e1A0+svO8gZWCyQ4dKSkC7BAGulrMwigPwBNHsdZVPX/laS8gwMKUm53ypJslUv2giW4K0Yg4Et1k+S26eMSjfzMaiQfkYEAo2lfZsWd4/T8MOAu7n+tyNm37nof4Va24L7Rd8lrwyQAcjv9zqu3KYZGclYxU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=E4zcerKe; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="E4zcerKe"
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-201df0b2df4so37289105ad.0
        for <patches@lists.linux.dev>; Mon, 19 Aug 2024 15:38:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1724107137; x=1724711937; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ywA8OaX1lKwB+QkeZviPO0tfv2glr07Z2pzYI3lLnXA=;
        b=E4zcerKemfByxjPINnofjdmaNl9No4hhDa93tkgVEUJapbAYcEgWMViZaupb6j0WsH
         g2JPdxYNghOey/HrKVWAhbU0GL6TFiL3eLZdgEZYbntqobsWC7nuvr6xVdlvN4Drbhyw
         N7yeaOhjQx/zZ5t/3bjh9lqMYTbRbfn7R2hyw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724107137; x=1724711937;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ywA8OaX1lKwB+QkeZviPO0tfv2glr07Z2pzYI3lLnXA=;
        b=B17oxmwkvbv0ry7qHmHc+72YeFaBhVu94+xTg7T6OBNhhQ9YOT4JoULEcaFNux5X5O
         bj6SzdJXrxgMXmajPECfdjJuAwWcvgiWQbzloauNk104szWCIup7VoBc6gDZanqSOZok
         EDaOkUgjqvCFKOGrJydOQxkpf+4fAgNomEcm+RmVe1TXPsZlEW9/Qc7UkW+aac6rKwOL
         hvDrdr0AYZsdR3xNy/ZugwdnkskuZV8wnGlc1GT/ltLqgC62cXMTxFELwAUwvhGfT6WA
         RcIQ2RKJ83ercer1fZrEBQlesb55cBlcJZN0kIv8nCuF48muuxJHG1cNQ83fB80mkeHy
         ZYCg==
X-Forwarded-Encrypted: i=1; AJvYcCU0eHnGADFx5c1niMuHo0BBw/Plp2ed/wubKZ/nhJJTXs5YjWlDwg1S0MTQ/qNCn/iQNtuI3myv@lists.linux.dev
X-Gm-Message-State: AOJu0YxgBBexGFnWEq/V0IwUTjzIvvtcxy+PYm4zsF+4LE+lLVJUTym2
	hKrFUBt55q/NHN1yparKo2NljRKxnqRzxPoZe7VZTsX6pM2QDqqGOZyqPpOGfg==
X-Google-Smtp-Source: AGHT+IHU3fWl4J6FiNvoKYuzaU+U5zGX0CHN6uE8R8CkbVuBd7tiKsG0Va+2cgyvp5/pf3qE90i/nA==
X-Received: by 2002:a17:902:d503:b0:201:f5e3:e36d with SMTP id d9443c01a7336-20203ea05d2mr143563805ad.25.1724107136555;
        Mon, 19 Aug 2024 15:38:56 -0700 (PDT)
Received: from localhost (210.73.125.34.bc.googleusercontent.com. [34.125.73.210])
        by smtp.gmail.com with UTF8SMTPSA id d9443c01a7336-201f03b2874sm66740535ad.308.2024.08.19.15.38.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Aug 2024 15:38:56 -0700 (PDT)
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
Subject: [PATCH v3 09/17] drm/bridge: dp_typec: Allow users to hook hpd notify path
Date: Mon, 19 Aug 2024 15:38:23 -0700
Message-ID: <20240819223834.2049862-10-swboyd@chromium.org>
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
 drivers/gpu/drm/bridge/aux-hpd-bridge.c | 30 +++++++++++++++++++++++++
 include/drm/bridge/aux-bridge.h         |  9 ++++++++
 2 files changed, 39 insertions(+)

diff --git a/drivers/gpu/drm/bridge/aux-hpd-bridge.c b/drivers/gpu/drm/bridge/aux-hpd-bridge.c
index adafda4f128f..815dc026718b 100644
--- a/drivers/gpu/drm/bridge/aux-hpd-bridge.c
+++ b/drivers/gpu/drm/bridge/aux-hpd-bridge.c
@@ -92,6 +92,8 @@ struct drm_dp_typec_bridge_dev {
 	struct auxiliary_device adev;
 	size_t max_lanes;
 	size_t num_typec_ports;
+	void (*hpd_notify)(void *data, enum drm_connector_status status);
+	void *hpd_data;
 };
 
 static inline struct drm_dp_typec_bridge_dev *
@@ -323,6 +325,20 @@ devm_drm_dp_typec_bridge_alloc(struct device *parent, struct device_node *np)
 }
 EXPORT_SYMBOL_GPL(devm_drm_dp_typec_bridge_alloc);
 
+/**
+ * drm_dp_typec_bridge_add_hpd_notify: Register a callback called when the
+ * bridge chain hpd state changes
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
@@ -362,6 +378,19 @@ void drm_aux_hpd_bridge_notify(struct device *dev, enum drm_connector_status sta
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
@@ -519,6 +548,7 @@ static const struct drm_bridge_funcs drm_dp_typec_bridge_funcs = {
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

