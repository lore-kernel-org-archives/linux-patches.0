Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FA45171C9
	for <patches@lists.linux.dev>; Thu, 15 Aug 2024 00:34:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723682073; cv=none; b=eWFndC1JEmDCvJOH4z8t9efP3XmvnuLv57inWc1jTige3+kwz/HZmwyaP3EcCd9DNtatq/nMqQ4eoRZzHpkHAM8+xOm1FV0MOp7n32kE7q9zMcEWrWpKx8C3kiogSjSnBndCUQOQZm3R654DAaeVsOnHWm4d/Er9rmXh/aUL9WM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723682073; c=relaxed/simple;
	bh=zTeIEewkb693isW8NOwvdmeLRQkQjPtBIKI0+HHAg2E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dpkmktb4vg3HYQI8H1fKEr1otn2iJxHJm6b/8yJqQVML20zy1ng0tS+9t3oKravsT3JFv/qTDqtw5mataOdnLdU7GgGaqXQ426MrgVD4eQDWd2od/KTyKYTLlvdwTKUZlfkV2QZGfm+8F6kGUSSj0RRTCHTRVO4Kp2W8JfSZLXQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=KuZGrxFL; arc=none smtp.client-ip=209.85.210.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="KuZGrxFL"
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-7104f93a20eso341844b3a.1
        for <patches@lists.linux.dev>; Wed, 14 Aug 2024 17:34:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1723682071; x=1724286871; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LTAqmUB3C74WyCJMJxJLb1pif+r1V9bPB5gyO42OGKo=;
        b=KuZGrxFLnRRZRp6y6069S9ee/4Xk/j8Q/CFQwiIGPltoE28EX8UragvmrJxe+lah1K
         1F1VJY8zZ0X7W/CIvocGDie0cRysGLFuxpXtbMf4iBuUWe/LO63XJBiJiAS4l0gw3ev1
         JqIWS0Yl1Q/qMA6dsZztEaOfB5Qlc0iN18H4I=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723682071; x=1724286871;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LTAqmUB3C74WyCJMJxJLb1pif+r1V9bPB5gyO42OGKo=;
        b=J3TtgS/tDISwHRYt4u6/HTOKrOfQ83lzDEbeOlZJE2DVUw4KDgzl4NRGkbsN8E7LI5
         fu18rnQ7/Tfd14T4e5M1GndUGesPu6OFj83FdrCgVyj8Iz42IFPTmvOkAJRaNFp5RhF2
         VR7ORAa07tkHObPdH+CllFQgXEro0O87CR77HlUUEgY6dZLXE+DUG41SsfBJrH8AB+Hi
         2MFw/v3EXOPilWWe9S8VbKIPajaxLcECJ1QQT0dAJTx56ICC/6+aZy8QBtItF0qwxp6M
         XpeJRDGfWGV778CopXU2voca3zn4pzp1vwQ728qlrQ8XHuSW0XZvppOCriicX+X58xYs
         aGsg==
X-Forwarded-Encrypted: i=1; AJvYcCULzIm2QkGaCK7mHwWmKN3onhHrcWQU5Mp3cW7up/gwZxwyoGY/1PsK+VpUg0zSKFxPQJUm8jY9XCBnULQyMBQEvgoinXb03Q==
X-Gm-Message-State: AOJu0Yyn+3/rkJnjoAmQKXT6A4A/tFyZJ8xVXaGo2OehujwUGhwY0Qwo
	P0x/c0V/EqPjOEgU2fkN/Nu6siCVGM1VO8UfR9w+ychqi8G/6YvsOEI3MQASAg==
X-Google-Smtp-Source: AGHT+IFi1sUOZeFN/sl/EmCy6pJtHVwtGc94+AhjMPhFgSZ7/Ovt9ABuwlS25ptPfHZRf5MNIAy+Kw==
X-Received: by 2002:a05:6a21:2d0a:b0:1c6:fa3a:c798 with SMTP id adf61e73a8af0-1c8eaee91ecmr5582828637.32.1723682071315;
        Wed, 14 Aug 2024 17:34:31 -0700 (PDT)
Received: from localhost (210.73.125.34.bc.googleusercontent.com. [34.125.73.210])
        by smtp.gmail.com with UTF8SMTPSA id d2e1a72fcca58-7127af1999fsm151333b3a.169.2024.08.14.17.34.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 14 Aug 2024 17:34:30 -0700 (PDT)
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
	Tzung-Bi Shih <tzungbi@kernel.org>
Subject: [PATCH v2 05/11] drm/bridge: dp_typec: Add "no-hpd" support
Date: Wed, 14 Aug 2024 17:34:10 -0700
Message-ID: <20240815003417.1175506-6-swboyd@chromium.org>
X-Mailer: git-send-email 2.46.0.76.ge559c4bf1a-goog
In-Reply-To: <20240815003417.1175506-1-swboyd@chromium.org>
References: <20240815003417.1175506-1-swboyd@chromium.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Some EC firmwares on Trogdor/Strongbad boards don't properly indicate
the state of the DP HPD level on a type-c port. The EC only indicates
that DP mode is entered or exited for a type-c port. The HPD state is
expressed to the DP controller via a pin on the AP that the EC drives
high or low when the type-c port partner (i.e. monitor) asserts or
deasserts HPD.

TL;DR: These devices don't support HPD signaling from the type-c code
paths.

Add support for HPD coming from somewhere else in the bridge chain.
Callers can set the struct drm_dp_typec_bridge_desc::no_hpd member to
indicate that HPD shouldn't be signaled from this bridge.

Cc: Prashant Malani <pmalani@chromium.org>
Cc: Benson Leung <bleung@chromium.org>
Cc: Tzung-Bi Shih <tzungbi@kernel.org>
Cc: <chrome-platform@lists.linux.dev>
Cc: Pin-yen Lin <treapking@chromium.org>
Cc: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Stephen Boyd <swboyd@chromium.org>
---
 drivers/gpu/drm/bridge/aux-hpd-bridge.c | 12 +++++++++++-
 include/drm/bridge/aux-bridge.h         |  2 ++
 2 files changed, 13 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/bridge/aux-hpd-bridge.c b/drivers/gpu/drm/bridge/aux-hpd-bridge.c
index 79652d27db40..a5a434b7d5ec 100644
--- a/drivers/gpu/drm/bridge/aux-hpd-bridge.c
+++ b/drivers/gpu/drm/bridge/aux-hpd-bridge.c
@@ -20,6 +20,7 @@ static DEFINE_IDA(drm_aux_hpd_bridge_ida);
 struct drm_aux_hpd_bridge_data {
 	struct drm_bridge bridge;
 	struct device *dev;
+	bool no_hpd;
 };
 
 enum dp_lane {
@@ -54,6 +55,7 @@ to_drm_dp_typec_bridge_data(struct drm_bridge *bridge)
 struct drm_dp_typec_bridge_dev {
 	struct auxiliary_device adev;
 	size_t max_lanes;
+	bool no_hpd;
 };
 
 static inline struct drm_dp_typec_bridge_dev *
@@ -232,6 +234,7 @@ devm_drm_dp_typec_bridge_alloc(struct device *parent, const struct drm_dp_typec_
 	adev->dev.release = drm_dp_typec_bridge_release;
 	adev->dev.platform_data = of_node_get(desc->of_node);
 	typec_bridge_dev->max_lanes = desc->num_dp_lanes;
+	typec_bridge_dev->no_hpd = desc->no_hpd;
 
 	ret = auxiliary_device_init(adev);
 	if (ret) {
@@ -278,6 +281,8 @@ void drm_aux_hpd_bridge_notify(struct device *dev, enum drm_connector_status sta
 
 	if (!data)
 		return;
+	if (data->no_hpd)
+		return;
 
 	drm_bridge_hpd_notify(&data->bridge, status);
 }
@@ -467,6 +472,7 @@ static int drm_aux_hpd_bridge_probe(struct auxiliary_device *auxdev,
 {
 	struct device *dev = &auxdev->dev;
 	struct drm_aux_hpd_bridge_data *hpd_data;
+	struct drm_dp_typec_bridge_dev *typec_bridge_dev;
 	struct drm_dp_typec_bridge_data *typec_data;
 	struct drm_bridge *bridge;
 	u8 dp_lanes[] = { DP_ML0, DP_ML1, DP_ML2, DP_ML3 };
@@ -477,6 +483,7 @@ static int drm_aux_hpd_bridge_probe(struct auxiliary_device *auxdev,
 			return -ENOMEM;
 		bridge = &hpd_data->bridge;
 		bridge->funcs = &drm_aux_hpd_bridge_funcs;
+		bridge->ops = DRM_BRIDGE_OP_HPD;
 	} else if (id->driver_data == DRM_AUX_TYPEC_BRIDGE) {
 		typec_data = devm_kzalloc(dev, sizeof(*typec_data), GFP_KERNEL);
 		if (!typec_data)
@@ -484,6 +491,10 @@ static int drm_aux_hpd_bridge_probe(struct auxiliary_device *auxdev,
 		hpd_data = &typec_data->hpd_bridge;
 		bridge = &hpd_data->bridge;
 		bridge->funcs = &drm_dp_typec_bridge_funcs;
+		typec_bridge_dev = to_drm_dp_typec_bridge_dev(dev);
+		if (!typec_bridge_dev->no_hpd)
+			bridge->ops = DRM_BRIDGE_OP_HPD;
+		hpd_data->no_hpd = typec_bridge_dev->no_hpd;
 		memcpy(typec_data->dp_lanes, dp_lanes, sizeof(typec_data->dp_lanes));
 	} else {
 		return -ENODEV;
@@ -491,7 +502,6 @@ static int drm_aux_hpd_bridge_probe(struct auxiliary_device *auxdev,
 
 	hpd_data->dev = dev;
 	bridge->of_node = dev_get_platdata(dev);
-	bridge->ops = DRM_BRIDGE_OP_HPD;
 	bridge->type = DRM_MODE_CONNECTOR_DisplayPort;
 
 	auxiliary_set_drvdata(auxdev, hpd_data);
diff --git a/include/drm/bridge/aux-bridge.h b/include/drm/bridge/aux-bridge.h
index 258b87c93623..13f5e98b4d31 100644
--- a/include/drm/bridge/aux-bridge.h
+++ b/include/drm/bridge/aux-bridge.h
@@ -28,10 +28,12 @@ struct drm_dp_typec_bridge_dev;
  * struct drm_dp_typec_bridge_desc - drm_dp_typec_bridge descriptor
  * @of_node: device node pointer corresponding to this bridge instance
  * @num_dp_lanes: number of input DP lanes possible (1, 2 or 4)
+ * @no_hpd: true if this bridge can't signal HPD state with drm_dp_typec_bridge_notify()
  */
 struct drm_dp_typec_bridge_desc {
 	struct device_node *of_node;
 	size_t num_dp_lanes;
+	bool no_hpd;
 };
 
 enum usb_ss_lane {
-- 
https://chromeos.dev

