Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6943116DEA7
	for <patches@lists.linux.dev>; Sun,  1 Sep 2024 04:07:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725163661; cv=none; b=g1F9VLL62jueVDPuoFBucAgoyoOF489qjx3Ku8pQFQC3Pa7j/NpXZY81jBmFN8TuKJZitxXCGRtFPS5+YpeoAtCcvz5GpDPvtSdXDbPXZKx0+dtnheJPei9Fi6Q2LNUbsAovmyWHuLJ/0d7xSB70D+gXh198tZDS/SSBeUIrTv4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725163661; c=relaxed/simple;
	bh=qwK70bPxM8LVw7h8REHJPsZb7kjgcSJTEZGj411FeVw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TaPydxaRqTrFVJXUjGIeYgSOgsR2gY+iaSWwhBLd0SKm4TJfshobM68fkzlZXRwHvgDsP47v17V6VlYopdCWG8LXrFPz3mFHtRK0GaeUOz5AG6HGJWJdYFnHpDrgxGsGY61lVSfoZYtGzncy6IKH3rLa+jqZOcG5qFQofTsNFGg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=XqVubzor; arc=none smtp.client-ip=209.85.216.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="XqVubzor"
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-2d89348de8fso688554a91.0
        for <patches@lists.linux.dev>; Sat, 31 Aug 2024 21:07:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1725163658; x=1725768458; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dYPu0stqsRx0TqGeKhWWj5HPmBRIxzjpP9BbfW7c5l4=;
        b=XqVubzor1fUflFRGwJlLGXKOhbMNCf+1gVs52qGuobpOMkIVftqrVdLdAYYK5dyZAg
         //s66b+SgZw7mshVvnC/z+/7dL3dnAieX/YSAf/PuvQonqIQVtOmXbnDSlGhBHh9/TWJ
         Qh5QSq6NVu+cqh0uxi4U6X2W/NgOFSuZLm2go=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725163658; x=1725768458;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dYPu0stqsRx0TqGeKhWWj5HPmBRIxzjpP9BbfW7c5l4=;
        b=CwyaUOS/f28HkKsymwXHc2tBam9yS9Mv/QuLvbFZZNmYqQEwGxNJzHLSMtOTnYUaDQ
         tu3NFfEdVffQlQ2aMM55uJjbSPoF9Zrc/qRss4bkYNwGouLTPA/sHAjNStkcPqEyXjrg
         e+aenpSMdbKFaxT/w3rz5Mhpdi96++jz3hraJLfLzI6oxeuIiETrxCrv4umo7JNc8FvA
         xjibSd3zXbFpXY6IE70bmqGW/IlkZWrLopyqykJH75/oDj5lPAlYpiYqYVZj8NcqgPHM
         usS5CjYYdDPuf/o9DJl0PbFyXHQXzRrD0coGJ/aFz6VEXa6/MhObwArKg6v8xFXMet55
         +UDA==
X-Forwarded-Encrypted: i=1; AJvYcCVuP6o6jNosdS+/EO67a8IAj0QAZZtpm0+pTdZVC/O5owHhKsFHHZlyjsA7NszKivFaF7f4n3X1@lists.linux.dev
X-Gm-Message-State: AOJu0YyOYHXy83HESlQ3qLK3jcG/UU09GxTlUT4rMSbVqWUj5Pu9BHYH
	Cv596gjuneWT7NiNtFoqe9IeXI2yVK4pvmWbe5h83QXc/OUjQNTKcfPTup4/Wg==
X-Google-Smtp-Source: AGHT+IERU9m/9viKAFaj9S2/X/9qEFrt7tD0EJG/4IvRq2IeDeMrMQQYu9a1+hSVg3+cqHjT5jopKg==
X-Received: by 2002:a17:90a:ea93:b0:2d3:bd6f:a31e with SMTP id 98e67ed59e1d1-2d88e3e64dcmr4070632a91.28.1725163658424;
        Sat, 31 Aug 2024 21:07:38 -0700 (PDT)
Received: from localhost (210.73.125.34.bc.googleusercontent.com. [34.125.73.210])
        by smtp.gmail.com with UTF8SMTPSA id 41be03b00d2f7-7d22e9d92a5sm4530018a12.90.2024.08.31.21.07.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 31 Aug 2024 21:07:38 -0700 (PDT)
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
Subject: [PATCH v4 17/18] platform/chrome: cros_ec_typec: Support DP muxing
Date: Sat, 31 Aug 2024 21:06:55 -0700
Message-ID: <20240901040658.157425-18-swboyd@chromium.org>
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

Most ARM based chromebooks with two usb-c-connector nodes and one DP
controller are muxing the DP lanes between the two USB ports. This is
done so that the type-c ports are at least equal in capability if not
functionality. Either an analog mux is used to steer the DP signal to
one or the other port, or a DP bridge chip has two lanes (e.g. DP
ML0/ML1) wired to one type-c port while the other two (e.g. DP ML2/ML3)
are wired to another type-c port.

Implement the same algorithm that the EC has to figure out which type-c
port has actually been muxed for DP altmode. Wait for the first type-c
port to assert HPD, and treat that as the actively muxed port until the
port exits DP altmode entirely. Allow HPD to be asserted or deasserted
during this time. If the port isn't active, simply ignore those events
and skip calling cros_typec_enable_dp(). Otherwise, pass the DP
information to the typec subsystem so that the DP controller can respond
to HPD events and pin configurations.

The EC can mux the DP signal to any number of USB type-c ports. We only
need to make sure that the active USB type-c port is tracked so that DP
information about the other ports is ignored. Unfortunately, the EC
doesn't hide these details from the AP so we have to reimplement the
logic in the kernel.

Cc: Prashant Malani <pmalani@chromium.org>
Cc: Benson Leung <bleung@chromium.org>
Cc: Tzung-Bi Shih <tzungbi@kernel.org>
Cc: <chrome-platform@lists.linux.dev>
Cc: Pin-yen Lin <treapking@chromium.org>
Signed-off-by: Stephen Boyd <swboyd@chromium.org>
---
 drivers/platform/chrome/cros_ec_typec.c | 31 +++++++++++++++++++++++--
 drivers/platform/chrome/cros_ec_typec.h |  1 +
 2 files changed, 30 insertions(+), 2 deletions(-)

diff --git a/drivers/platform/chrome/cros_ec_typec.c b/drivers/platform/chrome/cros_ec_typec.c
index a57053bdec18..57d1484ce1ef 100644
--- a/drivers/platform/chrome/cros_ec_typec.c
+++ b/drivers/platform/chrome/cros_ec_typec.c
@@ -639,6 +639,7 @@ static int cros_typec_configure_mux(struct cros_typec_data *typec, int port_num,
 				struct ec_response_usb_pd_control_v2 *pd_ctrl)
 {
 	struct cros_typec_port *port = typec->ports[port_num];
+	bool has_dp_bridge = !!typec->dp_bridge;
 	struct ec_response_usb_pd_mux_info resp;
 	struct ec_params_usb_pd_mux_info req = {
 		.port = port_num,
@@ -646,6 +647,7 @@ static int cros_typec_configure_mux(struct cros_typec_data *typec, int port_num,
 	struct ec_params_usb_pd_mux_ack mux_ack;
 	enum typec_orientation orientation;
 	int ret;
+	bool dp_enabled, hpd_asserted, is_active_port;
 
 	ret = cros_ec_cmd(typec->ec, 0, EC_CMD_USB_PD_MUX_INFO,
 			  &req, sizeof(req), &resp, sizeof(resp));
@@ -659,6 +661,25 @@ static int cros_typec_configure_mux(struct cros_typec_data *typec, int port_num,
 	if (port->mux_flags == resp.flags && port->role == pd_ctrl->role)
 		return 0;
 
+	dp_enabled = resp.flags & USB_PD_MUX_DP_ENABLED;
+	hpd_asserted = resp.flags & USB_PD_MUX_HPD_LVL;
+	/*
+	 * Assume the first port to have HPD asserted is the one muxed to DP
+	 * (i.e. active_port). When there's only one port this delays setting
+	 * the active_port until HPD is asserted, but before that the
+	 * drm_connector looks disconnected so active_port doesn't need to be
+	 * set.
+	 */
+	if (has_dp_bridge && hpd_asserted && !typec->active_dp_port)
+		typec->active_dp_port = port;
+
+	/*
+	 * Skip calling cros_typec_enable_dp() for the non-active type-c port
+	 * when muxing one DP to multiple type-c ports. This is only the case
+	 * on platforms using a drm_bridge.
+	 */
+	is_active_port = !has_dp_bridge || typec->active_dp_port == port;
+
 	port->mux_flags = resp.flags;
 	port->role = pd_ctrl->role;
 
@@ -686,8 +707,11 @@ static int cros_typec_configure_mux(struct cros_typec_data *typec, int port_num,
 		ret = cros_typec_enable_usb4(typec, port_num, pd_ctrl);
 	} else if (port->mux_flags & USB_PD_MUX_TBT_COMPAT_ENABLED) {
 		ret = cros_typec_enable_tbt(typec, port_num, pd_ctrl);
-	} else if (port->mux_flags & USB_PD_MUX_DP_ENABLED) {
-		ret = cros_typec_enable_dp(typec, port_num, pd_ctrl);
+	} else if (dp_enabled) {
+		ret = 0;
+		/* Ignore DP events for the non-active port */
+		if (is_active_port)
+			ret = cros_typec_enable_dp(typec, port_num, pd_ctrl);
 	} else if (port->mux_flags & USB_PD_MUX_SAFE_MODE) {
 		ret = cros_typec_usb_safe_state(port);
 	} else if (port->mux_flags & USB_PD_MUX_USB_ENABLED) {
@@ -704,6 +728,9 @@ static int cros_typec_configure_mux(struct cros_typec_data *typec, int port_num,
 	}
 
 mux_ack:
+	if (has_dp_bridge && !dp_enabled && is_active_port)
+		typec->active_dp_port = NULL;
+
 	if (!typec->needs_mux_ack)
 		return ret;
 
diff --git a/drivers/platform/chrome/cros_ec_typec.h b/drivers/platform/chrome/cros_ec_typec.h
index eb816d30d880..f3a2b67df07c 100644
--- a/drivers/platform/chrome/cros_ec_typec.h
+++ b/drivers/platform/chrome/cros_ec_typec.h
@@ -36,6 +36,7 @@ struct cros_typec_data {
 	/* Array of ports, indexed by port number. */
 	struct cros_typec_port *ports[EC_USB_PD_MAX_PORTS];
 	struct drm_dp_typec_bridge_dev *dp_bridge;
+	struct cros_typec_port *active_dp_port;
 	struct notifier_block nb;
 	struct work_struct port_work;
 	bool typec_cmd_supported;
-- 
https://chromeos.dev

