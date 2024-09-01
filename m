Received: from mail-pg1-f177.google.com (mail-pg1-f177.google.com [209.85.215.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F75413C820
	for <patches@lists.linux.dev>; Sun,  1 Sep 2024 04:07:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725163641; cv=none; b=EoZ0lzHNxkFovip8SIpr9X1lmGzcjTVMjgnLgOW4npS1njmuPfxPqbWlWl3ySZzeiLWPXwPs01Xx2qs6sFJA3V0bCgRlkUDflVgiLg2fnMHMJ8zPWCKUqXPZGSzr3F/Lk6+nlBdRewdX3GY7LTi/1Zefq9gv8S8qKc+PKCHkK3o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725163641; c=relaxed/simple;
	bh=K0vY/b3gdQJ7BbfGBTXVjSZjUjMpNMzLu+iBHhG2UV4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CvLMUEXHTuHI+MgxifvEppHUux+H2dFezqN//4JRGKXYHDIjZdQx62igtFjCMrDbXvcgcSyzze73hDBthQMevF5zOBWeAhGr8upPvjszrP+O/0dcohAu9q21joc1pWpTKS4n3SImJ5wLHHKVfIQLZI8lUq3EVas1XeGzOGylSOU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=e9tLYe0z; arc=none smtp.client-ip=209.85.215.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="e9tLYe0z"
Received: by mail-pg1-f177.google.com with SMTP id 41be03b00d2f7-7cd9cfe4748so2160975a12.2
        for <patches@lists.linux.dev>; Sat, 31 Aug 2024 21:07:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1725163639; x=1725768439; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dihu8n2PjcWrFXOuwWbECc9MpTZcbkDtMAPCx56QCc0=;
        b=e9tLYe0zEsSq1CFv5CvFjm1lPLLoOETmwOwD0MT82Vg+bpaQ3WbJx2Q1QUEN9fYXfR
         VcISsudjmFuTRn40hK5HNdwhbhYYFXd/ZWZ9YLBqm9UifczcDiTEjeGFWCr9m9UqZSWw
         5dLwBaYFKwKluIXVtE9mxa1SIhFg0FYLfGygM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725163639; x=1725768439;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dihu8n2PjcWrFXOuwWbECc9MpTZcbkDtMAPCx56QCc0=;
        b=Ur7fJl3sLnwFl8eXQpGdp0+2B24KLAvzBj+fMv+D+NaHsxgidbo10hKMI0A01O7Ugw
         EQOtby3qCeCxqaZli0mr4S2cQh1qlVbIs70IQ/apjR8m7uQviPmBsONtADVoVOVehxHX
         i4LNSYrhThZtSTadvWdzEoY18q+sgKGnhaKlleCswz9gPOdXcdcPLNzoUoxwR/FHsdEy
         MsMUq6OHSnL/hOSjVFtZq6KbGiwidx4yJKsRb6XioQGFBPGcBiVQJC5exMDpVh1yCDrd
         SpeMAFvAlrUTKnd6EeZoxT2vK1iAp+NoH5fpq0vQYx1UGlh4lwoHZ8Zf8hr4x5oeXt/u
         816A==
X-Forwarded-Encrypted: i=1; AJvYcCXCM08lt2DDAJvCjJRbaTDwta6ef9kR6+l7M+7rjz6Xi6H1h/hbyO6EWmAeQQUIXuD06jaBMEOT@lists.linux.dev
X-Gm-Message-State: AOJu0Yw7DtIcpe9iBJBsf9pr07jmnQpnlx0I6z2FrVrYKYhu8YMoHNy3
	BxQiVG2d9GPes2+i32LEcOwFrvOL0Rr/KBTDSoPRJ+TAUEYPtjpDWEL4yRQnrw==
X-Google-Smtp-Source: AGHT+IGUB6+86RHnw08wq757NS4DSJb/B5ixBOuB5HoLx7W2xOHzGQ0pL/7XrZLrWwYk0S+0GfQauw==
X-Received: by 2002:a05:6a21:3213:b0:1c4:a8a6:a85f with SMTP id adf61e73a8af0-1ced62a2b24mr2056687637.30.1725163639331;
        Sat, 31 Aug 2024 21:07:19 -0700 (PDT)
Received: from localhost (210.73.125.34.bc.googleusercontent.com. [34.125.73.210])
        by smtp.gmail.com with UTF8SMTPSA id 98e67ed59e1d1-2d8aba505bfsm1381042a91.8.2024.08.31.21.07.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 31 Aug 2024 21:07:19 -0700 (PDT)
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
Subject: [PATCH v4 08/18] drm/bridge: dp_typec: Add "no-hpd" support
Date: Sat, 31 Aug 2024 21:06:46 -0700
Message-ID: <20240901040658.157425-9-swboyd@chromium.org>
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

Add support for HPD coming from somewhere else in the drm_bridge chain.
Skip signaling HPD sate when "no-hpd" is present in the DT node backing
the dp_typec bridge.

Add this support because some EC firmwares on Trogdor/Strongbad boards
don't properly indicate the state of the DP HPD level on a type-c port.
The EC only indicates that DP mode is entered or exited for a type-c
port. The HPD level is expressed to the DP controller via a pin on the
AP that the EC drives high or low when the type-c port partner (i.e.
monitor) asserts or deasserts HPD.

Cc: Prashant Malani <pmalani@chromium.org>
Cc: Benson Leung <bleung@chromium.org>
Cc: Tzung-Bi Shih <tzungbi@kernel.org>
Cc: <chrome-platform@lists.linux.dev>
Cc: Pin-yen Lin <treapking@chromium.org>
Cc: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Stephen Boyd <swboyd@chromium.org>
---
 drivers/gpu/drm/bridge/aux-hpd-bridge.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/bridge/aux-hpd-bridge.c b/drivers/gpu/drm/bridge/aux-hpd-bridge.c
index d2832e6481d7..52db36aa190b 100644
--- a/drivers/gpu/drm/bridge/aux-hpd-bridge.c
+++ b/drivers/gpu/drm/bridge/aux-hpd-bridge.c
@@ -22,6 +22,7 @@ static DEFINE_IDA(drm_aux_hpd_bridge_ida);
 struct drm_aux_hpd_bridge_data {
 	struct drm_bridge bridge;
 	struct device *dev;
+	bool no_hpd;
 };
 
 enum dp_lane {
@@ -355,6 +356,8 @@ void drm_aux_hpd_bridge_notify(struct device *dev, enum drm_connector_status sta
 
 	if (!data)
 		return;
+	if (data->no_hpd)
+		return;
 
 	drm_bridge_hpd_notify(&data->bridge, status);
 }
@@ -672,6 +675,7 @@ static int drm_aux_hpd_bridge_probe(struct auxiliary_device *auxdev,
 			return -ENOMEM;
 		bridge = &hpd_data->bridge;
 		bridge->funcs = &drm_aux_hpd_bridge_funcs;
+		bridge->ops = DRM_BRIDGE_OP_HPD;
 	} else if (id->driver_data == DRM_AUX_TYPEC_BRIDGE) {
 		typec_data = devm_kzalloc(dev, sizeof(*typec_data), GFP_KERNEL);
 		if (!typec_data)
@@ -680,6 +684,9 @@ static int drm_aux_hpd_bridge_probe(struct auxiliary_device *auxdev,
 		bridge = &hpd_data->bridge;
 		bridge->funcs = &drm_dp_typec_bridge_funcs;
 		typec_bridge_dev = to_drm_dp_typec_bridge_dev(dev);
+		hpd_data->no_hpd = of_property_read_bool(np, "no-hpd");
+		if (!hpd_data->no_hpd)
+			bridge->ops = DRM_BRIDGE_OP_HPD;
 		memcpy(typec_data->dp_lanes, dp_lanes, sizeof(typec_data->dp_lanes));
 		ret = drm_dp_typec_bridge_probe_typec_ports(typec_data, typec_bridge_dev, np);
 		if (ret)
@@ -689,8 +696,7 @@ static int drm_aux_hpd_bridge_probe(struct auxiliary_device *auxdev,
 	}
 
 	hpd_data->dev = dev;
-	bridge->of_node = dev_get_platdata(dev);
-	bridge->ops = DRM_BRIDGE_OP_HPD;
+	bridge->of_node = np;
 	bridge->type = DRM_MODE_CONNECTOR_DisplayPort;
 
 	auxiliary_set_drvdata(auxdev, hpd_data);
-- 
https://chromeos.dev

