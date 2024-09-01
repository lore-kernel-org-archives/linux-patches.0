Received: from mail-oa1-f50.google.com (mail-oa1-f50.google.com [209.85.160.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 780A917ADFB
	for <patches@lists.linux.dev>; Sun,  1 Sep 2024 04:07:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725163663; cv=none; b=ZcTelOJkZ0TaC6j150XIxe0QVR9uPR/giIHAM3mx85yvLwSI2qyHI0nUPKEWc6oAlQDx6doYvBjjVKZ9gxJFOI2BmNag3ICWI3uvYOG9a1G2eRt0H+e82rvn1TpYP5afwX03XDz3GyHn6/r/uw5LwOWCiatnggfl8TRvmAqVDrg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725163663; c=relaxed/simple;
	bh=P5j7Fr9LGu/zW4lsyx25BQTDaO9/OJeLxNTA5aeJAcw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NlcPZdVDt0+lgXLs8G8xP41tMY72uAnFTSKNceknzFt5aQG0oh6HLfZ89Y5QS75UenN30oFTz8Jo5Yh/jx6L+7JJ3FOBhuxuLCvCkfkq8wnniPwz9M1r9bmgcRKgryjOw/X40MyB06UKNpyBuGiavf4WKH0cQ14yFal5iiUqaU0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=JVTWy1Il; arc=none smtp.client-ip=209.85.160.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="JVTWy1Il"
Received: by mail-oa1-f50.google.com with SMTP id 586e51a60fabf-27051f63018so2105309fac.3
        for <patches@lists.linux.dev>; Sat, 31 Aug 2024 21:07:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1725163660; x=1725768460; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YAnr/CInUuanIGWaUDroB3xFD+9prT3yLYHDcJ6D0Bo=;
        b=JVTWy1IlVv35mPOxLCFcD0x4k/p1JeOPeMXcU1UAStiimTZxkA8INO1IqhEsF44j8i
         zEhlWA30qFon+5Uxu1J7afRbH/aLWuBm6ad8FtuFQd/Sm2KrIm+HqlTY8mOzYN04O78M
         +fujtOyz+JCcVrb0iNsZBkx5fwrhNFwVxZ63o=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725163660; x=1725768460;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YAnr/CInUuanIGWaUDroB3xFD+9prT3yLYHDcJ6D0Bo=;
        b=sMFbWv9EKUkkz30rHPaDQom4PjVXP8i2QQcdC26pjfelKQkqzEMajZevWx3NNsJF6S
         cDL6bNv9J4+8civFqJGYnIW6P6KtoRnHVQ5S1aufQF1cDv5Nf6iOp2aMbVqzFMxjzHIH
         FS9Jy3ssMbqR59h0KUSiQ94kzp/gdgN2sRC5gDkT/oa3AE5VxCa4zl2GDdwccWmeg9zN
         E/rrAffsN27C5Tike1bMaS4R2y3V1YvLczRqsAQ5ZxvRQNAQ2h85BAbC6mEcCyN0iQ3n
         ZxkpQJzYFYuyzMx5E/vJf0xSjYtmML++1nc1sNLwcggBhTDqZiv8dzftJDoQk/uDPLWX
         cL3A==
X-Forwarded-Encrypted: i=1; AJvYcCXJ9/4ct1jkPLZ69MFaTaTwLMzhOlQvL8WhsRyo8SnAlBOyZgo+tmSOonxinlvJIvZHhDACZ8fZ@lists.linux.dev
X-Gm-Message-State: AOJu0YzPvu2wJhEyz9Wm89g18a2i8MHYUHQCtHlDkEECuZptLauxi1+0
	4rEHGuDDwB/e4zR5cTCNM2lIvu99M1HOVYD/IPoiU5ls/tBmNC2m9qJ/bSk5Jg==
X-Google-Smtp-Source: AGHT+IEJat/MH0aH5PxrzEOzEVWfG27VMiaK42He6BskeDGxOOCnFMowYgglO9wA7c39ubb74K4njg==
X-Received: by 2002:a05:6870:c14c:b0:25e:d62:f297 with SMTP id 586e51a60fabf-277d06c6446mr3278885fac.45.1725163660389;
        Sat, 31 Aug 2024 21:07:40 -0700 (PDT)
Received: from localhost (210.73.125.34.bc.googleusercontent.com. [34.125.73.210])
        by smtp.gmail.com with UTF8SMTPSA id d2e1a72fcca58-715e55aa11fsm4854824b3a.85.2024.08.31.21.07.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 31 Aug 2024 21:07:40 -0700 (PDT)
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
Subject: [PATCH v4 18/18] platform/chrome: cros_ec_typec: Handle lack of HPD information
Date: Sat, 31 Aug 2024 21:06:56 -0700
Message-ID: <20240901040658.157425-19-swboyd@chromium.org>
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

Some EC firmwares on Trogdor/Strongbad boards don't properly indicate
the state of DP HPD on a type-c port. Instead, the EC only indicates
that a type-c port has entered or exited DP mode. To make matters worse,
on these boards the DP signal is muxed between two USB type-c
connectors, so we can't use the DP entry of a port to figure out which
type-c port is actually displaying DP.

Stash the HPD state in this case whenever the drm_bridge is notified of
a connector status change and kick off the port worker so that the
type-c port state can be re-evaluated. If an analog mux is in use, read
the mux to figure out which type-c port signaled HPD. Once we know which
port is actually signaling HPD, inject that state into the message
received from the EC. This simplifies the rest of the logic as it can
all stay the same with respect to picking the first port to assert HPD,
etc.

Cc: Prashant Malani <pmalani@chromium.org>
Cc: Benson Leung <bleung@chromium.org>
Cc: Tzung-Bi Shih <tzungbi@kernel.org>
Cc: <chrome-platform@lists.linux.dev>
Cc: Pin-yen Lin <treapking@chromium.org>
Signed-off-by: Stephen Boyd <swboyd@chromium.org>
---
 drivers/platform/chrome/cros_ec_typec.c | 74 +++++++++++++++++++++++++
 drivers/platform/chrome/cros_ec_typec.h |  2 +
 2 files changed, 76 insertions(+)

diff --git a/drivers/platform/chrome/cros_ec_typec.c b/drivers/platform/chrome/cros_ec_typec.c
index 57d1484ce1ef..731b485634af 100644
--- a/drivers/platform/chrome/cros_ec_typec.c
+++ b/drivers/platform/chrome/cros_ec_typec.c
@@ -7,6 +7,7 @@
  */
 
 #include <linux/acpi.h>
+#include <linux/gpio/consumer.h>
 #include <linux/module.h>
 #include <linux/of.h>
 #include <linux/of_graph.h>
@@ -423,6 +424,17 @@ static int cros_typec_init_ports(struct cros_typec_data *typec)
 	return ret;
 }
 
+static void cros_typec_dp_bridge_hpd_notify(void *data, enum drm_connector_status status)
+{
+	struct cros_typec_data *typec = data;
+
+	/* Proxy the connector status as the HPD state to replay later. */
+	typec->hpd_asserted = status == connector_status_connected;
+
+	/* Refresh port state. */
+	schedule_work(&typec->port_work);
+}
+
 static int cros_typec_init_dp_bridge(struct cros_typec_data *typec)
 {
 	struct device *dev = typec->dev;
@@ -432,9 +444,17 @@ static int cros_typec_init_dp_bridge(struct cros_typec_data *typec)
 	if (!fwnode_property_read_bool(dev_fwnode(dev), "mode-switch"))
 		return 0;
 
+	typec->mux_gpio = devm_gpiod_get_optional(dev, "mux", GPIOD_ASIS);
+	if (IS_ERR(typec->mux_gpio))
+		return dev_err_probe(dev, PTR_ERR(typec->mux_gpio), "failed to get mux gpio\n");
+
 	dp_dev = devm_drm_dp_typec_bridge_alloc(dev, dev->of_node);
 	if (IS_ERR(dp_dev))
 		return PTR_ERR(dp_dev);
+
+	if (fwnode_property_read_bool(dev_fwnode(dev), "no-hpd"))
+		drm_dp_typec_bridge_add_hpd_notify(dp_dev, cros_typec_dp_bridge_hpd_notify, typec);
+
 	typec->dp_bridge = dp_dev;
 
 	return devm_drm_dp_typec_bridge_add(dev, dp_dev);
@@ -635,6 +655,59 @@ static int cros_typec_enable_usb4(struct cros_typec_data *typec,
 	return typec_mux_set(port->mux, &port->state);
 }
 
+/*
+ * Some ECs don't notify AP when HPD goes high or low because their firmware is
+ * broken. Capture the state of HPD in cros_typec_dp_bridge_hpd_notify() and
+ * inject the asserted state into the EC's response (deasserted is the
+ * default).
+ */
+static void cros_typec_inject_hpd(struct cros_typec_data *typec,
+				  struct ec_response_usb_pd_mux_info *resp,
+				  struct cros_typec_port *port)
+{
+	struct gpio_desc *mux_gpio = typec->mux_gpio;
+	int val;
+
+	/* Never registered a drm_bridge. Skip. */
+	if (!typec->dp_bridge)
+		return;
+
+	/* Don't need to inject HPD level when DP isn't enabled. */
+	if (!(resp->flags & USB_PD_MUX_DP_ENABLED))
+		return;
+
+	/*
+	 * The default setting is HPD deasserted. Ignore if nothing to inject.
+	 */
+	if (!typec->hpd_asserted)
+		return;
+
+	/*
+	 * Only read the mux GPIO setting if we need to change the active port.
+	 * Otherwise, an active port is already set and HPD going high or low
+	 * doesn't change the muxed port until DP mode is exited.
+	 */
+	if (!typec->active_dp_port) {
+		if (mux_gpio) {
+			val = gpiod_get_value_cansleep(mux_gpio);
+			if (val < 0) {
+				dev_err(typec->dev, "Failed to read mux gpio\n");
+				return;
+			}
+			/* Ignore HPD changes for non-active port. */
+			if (typec->ports[val] != port)
+				return;
+		}
+	} else if (port != typec->active_dp_port) {
+		/* Ignore HPD changes for non-active port. */
+		return;
+	}
+
+	/* Inject HPD from the GPIO state if EC firmware is broken. */
+	if (typec->hpd_asserted)
+		resp->flags |= USB_PD_MUX_HPD_LVL;
+}
+
 static int cros_typec_configure_mux(struct cros_typec_data *typec, int port_num,
 				struct ec_response_usb_pd_control_v2 *pd_ctrl)
 {
@@ -656,6 +729,7 @@ static int cros_typec_configure_mux(struct cros_typec_data *typec, int port_num,
 			 port_num, ret);
 		return ret;
 	}
+	cros_typec_inject_hpd(typec, &resp, port);
 
 	/* No change needs to be made, let's exit early. */
 	if (port->mux_flags == resp.flags && port->role == pd_ctrl->role)
diff --git a/drivers/platform/chrome/cros_ec_typec.h b/drivers/platform/chrome/cros_ec_typec.h
index f3a2b67df07c..4ccd3d014aa6 100644
--- a/drivers/platform/chrome/cros_ec_typec.h
+++ b/drivers/platform/chrome/cros_ec_typec.h
@@ -37,6 +37,8 @@ struct cros_typec_data {
 	struct cros_typec_port *ports[EC_USB_PD_MAX_PORTS];
 	struct drm_dp_typec_bridge_dev *dp_bridge;
 	struct cros_typec_port *active_dp_port;
+	struct gpio_desc *mux_gpio;
+	bool hpd_asserted;
 	struct notifier_block nb;
 	struct work_struct port_work;
 	bool typec_cmd_supported;
-- 
https://chromeos.dev

