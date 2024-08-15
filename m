Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA17828683
	for <patches@lists.linux.dev>; Thu, 15 Aug 2024 00:34:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723682075; cv=none; b=toydHTOWN1LOABADDBr1O84cjU9IvR8QD47WJ3rKptXFZL/4QDjAhxhsJXyGcjEa7VJ9UnhSy4rxVVr0yBsbz81+oMT2IiwkNPgCUPBXmwqsRw9k6mGDLcZ9V/TtO6T58Fn2RxX+5zkSixP9NGCL1Yqsa2EOUXFz/iuvJ2Fh4J4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723682075; c=relaxed/simple;
	bh=/jcJ+rI0gKZr/IVP6XjS/Ak4IPjJQVitYadHxzTrZ4s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cHL1bhVD2f725nWKTllYwvbMx3TB8nh/7Rjm1de+0ju9NomYqaZHlEobTmHxt3I/dT07QRxleciVUTjuzOVymod+pnx/DTyBoQwmYTT8Em8Cn7GH8dtbQrg8lDdWZ+YQ0eiNQGa/kU5Q8kSIEceaYLwyILuwHkK2uz7YGEIVlYQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=A69DsFGd; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="A69DsFGd"
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-201f2b7fe0dso28725ad.1
        for <patches@lists.linux.dev>; Wed, 14 Aug 2024 17:34:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1723682073; x=1724286873; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/yiv0xFPMhU7ZUs+XvuB/ZZA+l47REHWpzG575OPKPI=;
        b=A69DsFGdMednrGF3pFnSkOQHqKt66AlUBP8RpG7Bf8QF5hyrKqyQ7YNxajAtQanD6u
         pzdHBFTlQY8XVYgbqoMf+t2XOyXiIaWeux9pFU0wAx7DAnegBnP8Tc6hghS5uG6UpovE
         6ALKrL7x0YMFhbGJazypRXx9/jAOQOiifqeSY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723682073; x=1724286873;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/yiv0xFPMhU7ZUs+XvuB/ZZA+l47REHWpzG575OPKPI=;
        b=Rchc34XVFsTL4Q8DNpj2O3Zgv5bB6MrmwoRpYJOFFDy2eVjGR94G7Vif6pNGj+58Aw
         Bsnv+vdVgk1NwNhzYgxCuj3dlBxrOCbmrfm2dUWLF+0xHbcO69DjBXs5OPsr0xzNKFkM
         xMZCWR2p8l+2l1BJz9tqBYzVoVw5Uz/GI6l9cohIi0ur0gl4PQDQiATTij3ZhxdrXPBj
         MwZwuwA4+zCUlFb6KR1SmDmyCnazw2E2OrWx0HcHEpEwfLNumhaWR9PICU7AFrBrCLpS
         5KaP0gu60/5R/ZZhuVXAIL8pmoPOJmKhdjrazg0U2laoe3rFFXjjBPOQcTPJX+TN3iJc
         /s7w==
X-Forwarded-Encrypted: i=1; AJvYcCVIOk+rabe7/U+nZwFOcThnql3/+Q0DB0PhVKMvrHtDd24w5B74Jo+CkQNe1bLoiVXEso/g/HyimTE39KeWZsZ++KLOLHFo5A==
X-Gm-Message-State: AOJu0Yxe/TPyFu/Y4rWVB1YwgXdamQBN5/poelfMg90IBkuJuP5MEo2w
	N9iEBC/55Y9aAFlfX/UO6Gzzfl+wQMRlwKddFKqoSV8rY2is2wLt8ddJCd9Ujg==
X-Google-Smtp-Source: AGHT+IHJN+4iBjtg5BFHkoM0j1LHWILoEX4QehkqxO/ua5YPwB+wrtI73F9/wcxBEBcJXyMVg84zJg==
X-Received: by 2002:a17:902:7c92:b0:1fc:6b8b:4918 with SMTP id d9443c01a7336-201d64b09ddmr38089775ad.41.1723682072985;
        Wed, 14 Aug 2024 17:34:32 -0700 (PDT)
Received: from localhost (210.73.125.34.bc.googleusercontent.com. [34.125.73.210])
        by smtp.gmail.com with UTF8SMTPSA id d9443c01a7336-201f03a16b2sm1970445ad.268.2024.08.14.17.34.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 14 Aug 2024 17:34:32 -0700 (PDT)
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
Subject: [PATCH v2 06/11] drm/bridge: dp_typec: Allow users to hook hpd notify path
Date: Wed, 14 Aug 2024 17:34:11 -0700
Message-ID: <20240815003417.1175506-7-swboyd@chromium.org>
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
 drivers/gpu/drm/bridge/aux-hpd-bridge.c | 19 +++++++++++++++++++
 include/drm/bridge/aux-bridge.h         |  5 +++++
 2 files changed, 24 insertions(+)

diff --git a/drivers/gpu/drm/bridge/aux-hpd-bridge.c b/drivers/gpu/drm/bridge/aux-hpd-bridge.c
index a5a434b7d5ec..32c0171c512c 100644
--- a/drivers/gpu/drm/bridge/aux-hpd-bridge.c
+++ b/drivers/gpu/drm/bridge/aux-hpd-bridge.c
@@ -55,6 +55,9 @@ to_drm_dp_typec_bridge_data(struct drm_bridge *bridge)
 struct drm_dp_typec_bridge_dev {
 	struct auxiliary_device adev;
 	size_t max_lanes;
+	void (*hpd_notify)(struct drm_dp_typec_bridge_dev *dev,
+			   void *data, enum drm_connector_status status);
+	void *hpd_data;
 	bool no_hpd;
 };
 
@@ -235,6 +238,8 @@ devm_drm_dp_typec_bridge_alloc(struct device *parent, const struct drm_dp_typec_
 	adev->dev.platform_data = of_node_get(desc->of_node);
 	typec_bridge_dev->max_lanes = desc->num_dp_lanes;
 	typec_bridge_dev->no_hpd = desc->no_hpd;
+	typec_bridge_dev->hpd_notify = desc->hpd_notify;
+	typec_bridge_dev->hpd_data = desc->hpd_data;
 
 	ret = auxiliary_device_init(adev);
 	if (ret) {
@@ -305,6 +310,19 @@ void drm_dp_typec_bridge_notify(struct drm_dp_typec_bridge_dev *typec_bridge_dev
 }
 EXPORT_SYMBOL_GPL(drm_dp_typec_bridge_notify);
 
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
+		typec_bridge_dev->hpd_notify(typec_bridge_dev, typec_bridge_dev->hpd_data, status);
+}
+
 static int drm_aux_hpd_bridge_attach(struct drm_bridge *bridge,
 				     enum drm_bridge_attach_flags flags)
 {
@@ -460,6 +478,7 @@ static const struct drm_bridge_funcs drm_dp_typec_bridge_funcs = {
 	.atomic_reset = drm_atomic_helper_bridge_reset,
 	.atomic_duplicate_state = drm_atomic_helper_bridge_duplicate_state,
 	.atomic_destroy_state = drm_atomic_helper_bridge_destroy_state,
+	.hpd_notify = drm_dp_typec_bridge_hpd_notify,
 };
 
 enum drm_aux_bridge_type {
diff --git a/include/drm/bridge/aux-bridge.h b/include/drm/bridge/aux-bridge.h
index 13f5e98b4d31..3229f200f0df 100644
--- a/include/drm/bridge/aux-bridge.h
+++ b/include/drm/bridge/aux-bridge.h
@@ -28,11 +28,16 @@ struct drm_dp_typec_bridge_dev;
  * struct drm_dp_typec_bridge_desc - drm_dp_typec_bridge descriptor
  * @of_node: device node pointer corresponding to this bridge instance
  * @num_dp_lanes: number of input DP lanes possible (1, 2 or 4)
+ * @hpd_notify: callback for bridge hot plug detect events
+ * @hpd_data: data passed to @hpd_notify callback
  * @no_hpd: true if this bridge can't signal HPD state with drm_dp_typec_bridge_notify()
  */
 struct drm_dp_typec_bridge_desc {
 	struct device_node *of_node;
 	size_t num_dp_lanes;
+	void (*hpd_notify)(struct drm_dp_typec_bridge_dev *typec_bridge_dev,
+			   void *data, enum drm_connector_status status);
+	void *hpd_data;
 	bool no_hpd;
 };
 
-- 
https://chromeos.dev

