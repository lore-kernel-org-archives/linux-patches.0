Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A27A1E2132
	for <patches@lists.linux.dev>; Mon, 19 Aug 2024 22:38:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724107129; cv=none; b=A/WGdmIZ0JL+bN6b9PUJzdAmNPvtd8NgI/sCORmGttT04vmQqaJMq1QC71eA07Qw3Qnw60O6oRBuLxVMCJ19DHR6bPeXZYkIiwKmHigf0SYuRQtud6tCCM+oLS68lTxmIJ/xKiog+o+zPaH0eoodEXqBso+3L39+B86xw3QB0T4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724107129; c=relaxed/simple;
	bh=hmBdC6OuP0fFMyUtA27W3obsdBheUiPiVi+Dyq4Fm3g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aY0wX70hV5+x5HoS+HAQyrq3TRrbpDexv/yFGPzoi7GIXCkppYpsGIUPk6aGhC1RvvKAzC04q2rZ0yGT3Szuf1l5JYDsJorYOWb+FEBEKmONb5lucAdulxW8or3NSi3ULlXUyY6dcQlI/qR4JB/sh7CsEDGTzOcdj8WS8n6ynQA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=D1Ada07W; arc=none smtp.client-ip=209.85.210.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="D1Ada07W"
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-7126d62667bso2828533b3a.3
        for <patches@lists.linux.dev>; Mon, 19 Aug 2024 15:38:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1724107124; x=1724711924; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tjBNYQFa86nn8t+X15a2kIDQUg5jYzam5K2eZ8YJJCA=;
        b=D1Ada07WbojQ38sNNmt9yfPPRj08J3DseCuMr1evq02rj1J5hIBCAZhrnHAv2lctvp
         WUeiuB6Mj/+DHCtXrLF8e2eCiSHWenH1KqRRPYOiA2b049QyIG567utexnB36kY9aFtQ
         Ug8GDn0WeTeFNs3beuLzgV+m3QU6qaVlEElAw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724107124; x=1724711924;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tjBNYQFa86nn8t+X15a2kIDQUg5jYzam5K2eZ8YJJCA=;
        b=vmhpzmtE0rbzc189MiXC3tXzVYmY4l4gYGEDj6SL5LM/9mWrNmOJiHjK7LtdK7MWhf
         YweqPdrLuEw81SqnGP1FhUPVcPLlX3z1j99FX6AvLaiol6jqrNwVVsmv+Vk5SmH04x9R
         FBz8A1jS1iD/gkmazAp11RKshHsvI52xYiijLftTtuYHkv4amv/3jm1myB6gBWf+AmCq
         Kn9G0dAPEBQZ9yHjWbEgwv1jhZgh3AZJQ/bNh6meLCs5mlyqHEvppXFrF7c+SzZl3gao
         bBwwf/3Zv8YnWrzMnI6r0NZPxhrBlMuIR/R3FYbQUEmDuXdOoFrlQE3yLelckz2QVuaS
         5SaQ==
X-Forwarded-Encrypted: i=1; AJvYcCWWEmsnrVcXlTHB06Z4lk30khsJ17g4o24dYZqrF/7EVcRzIF/gznuGYgy4pFOO+Fteny+GZOVYtCuYNBtX/NpbB9nm4BQPlw==
X-Gm-Message-State: AOJu0YwY64tnIseq+gDUZPqDz7/pfYJ8/us/GQrzhtAQCjV5FBkgM6Vq
	q+sCf5TaH6isbuW5Cd9rv1TFI8P+bu1rwK9CX5r5gRVwI4UtnVIzeswMvL5NUw==
X-Google-Smtp-Source: AGHT+IHN/xP/IACjD57PXeDLdL97bMvELyNSW6GYvHFV5SlTTara1vBX1rN2aloQvAb4+mpkicUw5g==
X-Received: by 2002:a05:6a21:150b:b0:1c4:bbb8:5050 with SMTP id adf61e73a8af0-1c90502ae63mr11606193637.37.1724107123237;
        Mon, 19 Aug 2024 15:38:43 -0700 (PDT)
Received: from localhost (210.73.125.34.bc.googleusercontent.com. [34.125.73.210])
        by smtp.gmail.com with UTF8SMTPSA id 41be03b00d2f7-7c6b61c6bb5sm7011137a12.33.2024.08.19.15.38.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Aug 2024 15:38:42 -0700 (PDT)
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
Subject: [PATCH v3 03/17] usb: typec: Stub out typec_switch APIs when CONFIG_TYPEC=n
Date: Mon, 19 Aug 2024 15:38:17 -0700
Message-ID: <20240819223834.2049862-4-swboyd@chromium.org>
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

Ease driver development by adding stubs for the typec_switch APIs when
CONFIG_TYPEC=n. Copy the same method used for the typec_mux APIs to be
consistent.

Cc: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: <linux-usb@vger.kernel.org>
Cc: Pin-yen Lin <treapking@chromium.org>
Signed-off-by: Stephen Boyd <swboyd@chromium.org>
---
 include/linux/usb/typec_mux.h | 42 ++++++++++++++++++++++++++++++-----
 1 file changed, 37 insertions(+), 5 deletions(-)

diff --git a/include/linux/usb/typec_mux.h b/include/linux/usb/typec_mux.h
index 2489a7857d8e..094585205264 100644
--- a/include/linux/usb/typec_mux.h
+++ b/include/linux/usb/typec_mux.h
@@ -24,16 +24,13 @@ struct typec_switch_desc {
 	void *drvdata;
 };
 
+#if IS_ENABLED(CONFIG_TYPEC)
+
 struct typec_switch *fwnode_typec_switch_get(struct fwnode_handle *fwnode);
 void typec_switch_put(struct typec_switch *sw);
 int typec_switch_set(struct typec_switch *sw,
 		     enum typec_orientation orientation);
 
-static inline struct typec_switch *typec_switch_get(struct device *dev)
-{
-	return fwnode_typec_switch_get(dev_fwnode(dev));
-}
-
 struct typec_switch_dev *
 typec_switch_register(struct device *parent,
 		      const struct typec_switch_desc *desc);
@@ -42,6 +39,41 @@ void typec_switch_unregister(struct typec_switch_dev *sw);
 void typec_switch_set_drvdata(struct typec_switch_dev *sw, void *data);
 void *typec_switch_get_drvdata(struct typec_switch_dev *sw);
 
+#else
+
+static inline struct typec_switch *
+fwnode_typec_switch_get(struct fwnode_handle *fwnode)
+{
+	return NULL;
+}
+static inline void typec_switch_put(struct typec_switch *sw) {}
+static inline int typec_switch_set(struct typec_switch *sw,
+		     enum typec_orientation orientation)
+{
+	return 0;
+}
+
+static inline struct typec_switch_dev *
+typec_switch_register(struct device *parent,
+		      const struct typec_switch_desc *desc)
+{
+	return ERR_PTR(-EOPNOTSUPP);
+}
+static inline void typec_switch_unregister(struct typec_switch_dev *sw) {}
+
+static inline void typec_switch_set_drvdata(struct typec_switch_dev *sw, void *data) {}
+static inline void *typec_switch_get_drvdata(struct typec_switch_dev *sw)
+{
+	return ERR_PTR(-EOPNOTSUPP);
+}
+
+#endif /* CONFIG_TYPEC */
+
+static inline struct typec_switch *typec_switch_get(struct device *dev)
+{
+	return fwnode_typec_switch_get(dev_fwnode(dev));
+}
+
 struct typec_mux_state {
 	struct typec_altmode *alt;
 	unsigned long mode;
-- 
https://chromeos.dev

