Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com [209.85.215.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C16CB3BB37
	for <patches@lists.linux.dev>; Sat, 10 Feb 2024 07:10:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707549010; cv=none; b=nup1GyyRCmCGG7TFmfvsO076GIonOQAw2PewVZgqQoAU4trdZgnGs827rwNWcwNfO/W6js71f2hzzpbdAC8DVEhyHnV4WsN2FG2m0VxFnoPS179I4QWpZxN+iycbp9R9F75rdUY1ubOvpt7C+DZxghzvHt13Z7JniF8kPzPTTuw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707549010; c=relaxed/simple;
	bh=7ychZbXxS1s4pMACM5Sr3Sm2rydqrFGfJ5B9SLKGry0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DanL3y4AnTKUS4TDAi224aplE6gM/P+ma8M8DZu5k1o3n9+OAwWRhOMMdPAlesmHtZ7HlzHTrn2kr8/njNy27TarkKWvqLJyYJ4cXnFDPi0xg/ih6BBKmcqq9mIxTiyN+MY4h+NJ6a66/Qdn0C89BMfcQdrmbJ9a7qPbz78hgF0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=DuopWbXr; arc=none smtp.client-ip=209.85.215.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="DuopWbXr"
Received: by mail-pg1-f178.google.com with SMTP id 41be03b00d2f7-5d81b08d6f2so1284438a12.0
        for <patches@lists.linux.dev>; Fri, 09 Feb 2024 23:10:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1707549008; x=1708153808; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8lS/zI9DieZO4kpyCxOx0tCwEa/sTyMFOHybhXgcQ6k=;
        b=DuopWbXrBfNaXnXIIMBv1AtMeHeI88md5Pa9NhmE8qOQSb2mbqjDul1OUHuccEFJ7z
         +dhcEQv1yBjXf2NyOeBotI9K0KXPVYWv2xGz+IttKe/IWzNjqr/htruCWS4ogTUjwyTe
         IOBon8QXoFGjIJCuZQPXAwiHkaNcxDKwfxvtw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707549008; x=1708153808;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8lS/zI9DieZO4kpyCxOx0tCwEa/sTyMFOHybhXgcQ6k=;
        b=AZXXKsi4HXs01Jz5SqbCiRtPTR2R+yWSnEX/+q8yqKYgkd6F2jEcU6Kl64TERLES2f
         kZ8rWWl1/DMo1Ht+SCz/vCEWMLePXT2OCRNYPdkPowBgbYfTPt/kp4aURf69OW2WPkLU
         b+/6fvEBv3SUp47opfx4kC9vO6zPsZPpjBi9yh88UVd/l58M9i5QfHgE4iv2TfK86flC
         ZJLuJIaecpTJzfI29pl0qi/TMR+U/BAX+lu6LxvgelzWbDwwMtR5+xT3eu5FtmU8uDR9
         eIMif2TUTIhxzKND68lYEgodVwE+WALlfujVaeJg+/Qe045O/SZ2+sl/4tILm+pfPNhb
         PEaA==
X-Gm-Message-State: AOJu0YwVyK/y3C4JhaNZ/JJ8uW6+NLDqWHuQfkOvA1WFo26btcpnNNyr
	EGOveap/T66AemxYMo3XfbrIsaB33gV3m06Iq9D7sH9iNAqnB0wCruNVQ9y/wg==
X-Google-Smtp-Source: AGHT+IGsl/kRZRKlL+ejLfDG0H8w/xBbFJW8H2mG4Dnohi5PwiltDDRP/NGDaoxKd6S2A6sYjsRajA==
X-Received: by 2002:a05:6a21:9102:b0:19c:9b38:f398 with SMTP id tn2-20020a056a21910200b0019c9b38f398mr1875117pzb.22.1707549008286;
        Fri, 09 Feb 2024 23:10:08 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCVxVKRsZHGdz7T51QyBOeGTngT9/I4zjnFVZlFgfTySs80AvPD+gcp8pAywzgBSXuGJkHLs8GXlERRa+/aOskm6YO+aBk0O4JsRkPbqsq/HIF9wvIkHJaJ9p3c+S9gPsySDR2YcveYC5Dud+LaWCyR8Ok9AZCpX4R4qQDDHKrCYprfr3SwLujkyt4cOv88KYpJcN21HPl/XGv8wkxYw5o4cNnubbYkfwAMkaB4LbFLguENnb8tOQXJbgBembp46EqkVRYq+iW5mZicLeQN4fDtKo+5cCtS0A4hi6MP2L+NGJIhrjifwCtjNqHHnI4stBwFFIM86Tg7SoV8cY/kVIEid1QpkF6CLTUNGPnGqsP6U+Gt1fEyjSQ==
Received: from localhost (175.199.125.34.bc.googleusercontent.com. [34.125.199.175])
        by smtp.gmail.com with UTF8SMTPSA id fn7-20020a056a002fc700b006e0651ec052sm1650575pfb.32.2024.02.09.23.10.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 Feb 2024 23:10:07 -0800 (PST)
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
Subject: [PATCH 17/22] platform/chrome: cros_typec_switch: Handle lack of HPD information
Date: Fri,  9 Feb 2024 23:09:28 -0800
Message-ID: <20240210070934.2549994-18-swboyd@chromium.org>
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

Some EC firmwares on Trogdor/Strongbad boards don't properly indicate
the state of DP HPD on a type-c port. Instead, the EC only indicates
that DP mode is entered or exited for a type-c port. To make matters
worse, on these firmwares the DP signal is muxed between two USB type-c
connectors, so we can't use the HPD state to figure out which type-c
port is actually displaying DP.

Read the state of the EC's analog mux from the hpd notification callback
to figure out which type-c port is displaying DP. This circumvents the
entire host command/message interface, because it doesn't work all the
time. Only do this when we have the mux-gpios property in DT, indicating
that we have to read the EC gpio state to figure this out. For now we
only support a single gpio "bit", so there can only be two USB type-c
ports.

Cc: Prashant Malani <pmalani@chromium.org>
Cc: Benson Leung <bleung@chromium.org>
Cc: Tzung-Bi Shih <tzungbi@kernel.org>
Cc: <chrome-platform@lists.linux.dev>
Cc: Pin-yen Lin <treapking@chromium.org>
Signed-off-by: Stephen Boyd <swboyd@chromium.org>
---
 drivers/platform/chrome/cros_typec_switch.c | 33 ++++++++++++++++++++-
 1 file changed, 32 insertions(+), 1 deletion(-)

diff --git a/drivers/platform/chrome/cros_typec_switch.c b/drivers/platform/chrome/cros_typec_switch.c
index c22c2531327a..edd628eab7da 100644
--- a/drivers/platform/chrome/cros_typec_switch.c
+++ b/drivers/platform/chrome/cros_typec_switch.c
@@ -8,6 +8,7 @@
 
 #include <linux/acpi.h>
 #include <linux/delay.h>
+#include <linux/gpio/consumer.h>
 #include <linux/iopoll.h>
 #include <linux/module.h>
 #include <linux/of.h>
@@ -26,6 +27,7 @@
 struct cros_typec_dp_bridge {
 	/* TODO: Add mutex lock to protect active_port with respect to drm/typec framework calls */
 	struct cros_typec_port *active_port;
+	struct gpio_desc *mux_gpio;
 	struct cros_typec_switch_data *sdata;
 	size_t max_lanes;
 	bool hpd_enabled;
@@ -453,6 +455,29 @@ static void cros_typec_dp_bridge_hpd_disable(struct drm_bridge *bridge)
 	typec_dp_bridge->hpd_enabled = false;
 }
 
+static void cros_typec_dp_bridge_hpd_notify(struct drm_bridge *bridge,
+					    enum drm_connector_status status)
+{
+	struct cros_typec_dp_bridge *typec_dp_bridge;
+	struct cros_typec_switch_data *sdata;
+	struct gpio_desc *mux_gpio;
+	int mux_val;
+
+	typec_dp_bridge = bridge_to_cros_typec_dp_bridge(bridge);
+	mux_gpio = typec_dp_bridge->mux_gpio;
+
+	/*
+	 * Some ECs don't notify AP when HPD goes high or low so we have to
+	 * read the EC GPIO that controls the mux to figure out which type-c
+	 * port is connected to DP.
+	 */
+	if (mux_gpio) {
+		sdata = typec_dp_bridge->sdata;
+		mux_val = gpiod_get_value_cansleep(mux_gpio);
+		typec_dp_bridge->active_port = sdata->ports[mux_val];
+	}
+}
+
 static const struct drm_bridge_funcs cros_typec_dp_bridge_funcs = {
 	.attach = cros_typec_dp_bridge_attach,
 	.atomic_check = cros_typec_dp_bridge_atomic_check,
@@ -461,6 +486,7 @@ static const struct drm_bridge_funcs cros_typec_dp_bridge_funcs = {
 	.atomic_destroy_state = drm_atomic_helper_bridge_destroy_state,
 	.hpd_enable = cros_typec_dp_bridge_hpd_enable,
 	.hpd_disable = cros_typec_dp_bridge_hpd_disable,
+	.hpd_notify = cros_typec_dp_bridge_hpd_notify,
 };
 
 static int cros_typec_register_dp_bridge(struct cros_typec_switch_data *sdata,
@@ -478,6 +504,10 @@ static int cros_typec_register_dp_bridge(struct cros_typec_switch_data *sdata,
 	typec_dp_bridge->sdata = sdata;
 	sdata->typec_dp_bridge = typec_dp_bridge;
 
+	typec_dp_bridge->mux_gpio = devm_gpiod_get_optional(dev, "mux", 0);
+	if (IS_ERR(typec_dp_bridge->mux_gpio))
+		return PTR_ERR(typec_dp_bridge->mux_gpio);
+
 	num_lanes = fwnode_property_count_u32(fwnode, "data-lanes");
 	if (num_lanes < 0)
 		num_lanes = 4;
@@ -488,7 +518,8 @@ static int cros_typec_register_dp_bridge(struct cros_typec_switch_data *sdata,
 	bridge->funcs = &cros_typec_dp_bridge_funcs;
 	bridge->of_node = dev->of_node;
 	bridge->type = DRM_MODE_CONNECTOR_DisplayPort;
-	bridge->ops |= DRM_BRIDGE_OP_HPD;
+	if (!fwnode_property_present(dev_fwnode(dev), "no-hpd"))
+		bridge->ops |= DRM_BRIDGE_OP_HPD;
 
 	return devm_drm_bridge_add(dev, bridge);
 }
-- 
https://chromeos.dev

