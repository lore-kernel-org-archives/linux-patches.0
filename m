Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B235D1E4EE8
	for <patches@lists.linux.dev>; Mon, 19 Aug 2024 22:38:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724107130; cv=none; b=GAwx3tT/uFHGslSy5g+0oq+sf2cAtjQsp1vP1muxCT9izzQIWXONiie0hV6OrdDz4VFm7TtVkOtMiGLW//LNN1JzAMj4i/RwneVMvTdR809LU+EXQvLIOo5XqYygOdtDbCF4GOoXsu1PZCrsx0OZH1WlvjfdmIXg4aRxwLprf9w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724107130; c=relaxed/simple;
	bh=HsvBWQDhlsn8H6zRFLK5T7gdVtCqYrCaBpLaZ8SUzbI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IF4owlA9to2e7Jk7RU4+2LasvhF7ttgt+c71SPGncZQN5fGwysvGOKxfufj15sLG7QlCatnjRO/lLdUe67T5ew7Dt3Zu651MZ10ozVLZGJ2sqGh4M07wGcjhcOBhpywmHaYGYx/uIhhLglJSYzh29m11Npd/y+mWiyDIa0f7pgc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=AmBkfTmJ; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="AmBkfTmJ"
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-20202df1c2fso23461265ad.1
        for <patches@lists.linux.dev>; Mon, 19 Aug 2024 15:38:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1724107128; x=1724711928; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/QfY7K5G02ZDzjvxUav8uCOJkIdUZDTh+/duvHHbQ8k=;
        b=AmBkfTmJGlj3OYqKpFSFfPcSxNAT29YgI6brGh6ajTgDwfi+XVI+kXlsFb2UdARHvu
         Lq2UbIrS7oc1cuJsV5nD0PMs6y7SQPxoBIHH0WWEUSglRamL5p37Es8iCi+G9n8zy5Nj
         c8AATEm2MtunScSbmSZlR8paRqtxhOvlknccs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724107128; x=1724711928;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/QfY7K5G02ZDzjvxUav8uCOJkIdUZDTh+/duvHHbQ8k=;
        b=Y82N6r8rb0HYwR2tsowV6bI6WqyZRzg3+S4mOcqdzsb2tNtLyfYHf8Z/DBPFynSW/m
         vptRCkyxIuVzPIgo12vSyBjIN+FNQ8youbQdmVZ8FCFHbYHsUUjdrsj4kzUMLnMLeoSg
         w3eokBFQbmuNDR0TsLbQhCUm81lHj8mYroY+ZVjCeV+93+ZbbelWTcAXTxXN6EwuV03R
         WM3Xg0DmEocm6OUL+WH3wXeFSbWjfHGhIM/HUSNeUkq/XtireweZLbzqIcaJl+sxRTlE
         G9oIvXTq44hd8cCoADtiwNl96usovJUMS4ZWuvl0Jfb9Bv5t7fHONnS7yq489z9BcgOm
         4oXw==
X-Forwarded-Encrypted: i=1; AJvYcCVt81G5G5Ckel2D4gTSqtfwLl1XN51UvijMioL0iyJQcxQ1icnuUrmOAJ+a7geqlm45NDubCfR6@lists.linux.dev
X-Gm-Message-State: AOJu0YxofvGk9GcQl88CjKaazyBintsqOM65pK+zdmviLotJlODi2TuH
	JRv8pGXXLr9NuauWuZZ9NEdlgAPkyqVy1uuoAs0yMY4y2tAgS/KyDzxMX+yBqonYlk6/UgLqXZw
	=
X-Google-Smtp-Source: AGHT+IEjvBWy5ocnu/ktRfbxtIPTfv9LDJE/ruEiBfpU+qt4ZXlJ9XqOGFL2pdFVOCA7+gyynTnvVA==
X-Received: by 2002:a17:902:da86:b0:200:79c1:a69f with SMTP id d9443c01a7336-2025f1c1077mr18748745ad.20.1724107127977;
        Mon, 19 Aug 2024 15:38:47 -0700 (PDT)
Received: from localhost (210.73.125.34.bc.googleusercontent.com. [34.125.73.210])
        by smtp.gmail.com with UTF8SMTPSA id d9443c01a7336-201f03758a6sm66871225ad.180.2024.08.19.15.38.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Aug 2024 15:38:47 -0700 (PDT)
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
Subject: [PATCH v3 05/17] usb: typec: Add device managed typec_switch_register()
Date: Mon, 19 Aug 2024 15:38:19 -0700
Message-ID: <20240819223834.2049862-6-swboyd@chromium.org>
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

Simplify driver error paths by adding devm_typec_switch_register() which
will unregister the typec switch when the parent device is unbound.

Cc: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: <linux-usb@vger.kernel.org>
Cc: Pin-yen Lin <treapking@chromium.org>
Signed-off-by: Stephen Boyd <swboyd@chromium.org>
---
 drivers/usb/typec/mux.c       | 27 +++++++++++++++++++++++++++
 include/linux/usb/typec_mux.h |  9 +++++++++
 2 files changed, 36 insertions(+)

diff --git a/drivers/usb/typec/mux.c b/drivers/usb/typec/mux.c
index 65c60eb56428..3531ab03bac4 100644
--- a/drivers/usb/typec/mux.c
+++ b/drivers/usb/typec/mux.c
@@ -235,6 +235,33 @@ void typec_switch_unregister(struct typec_switch_dev *sw_dev)
 }
 EXPORT_SYMBOL_GPL(typec_switch_unregister);
 
+static void devm_typec_switch_unregister(struct device *dev, void *switch_dev)
+{
+	typec_switch_unregister(*(struct typec_switch_dev **)switch_dev);
+}
+
+struct typec_switch_dev *
+devm_typec_switch_register(struct device *parent,
+			   const struct typec_switch_desc *desc)
+{
+	struct typec_switch_dev **ptr, *switch_dev;
+
+	ptr = devres_alloc(devm_typec_switch_unregister, sizeof(*ptr), GFP_KERNEL);
+	if (!ptr)
+		return ERR_PTR(-ENOMEM);
+
+	switch_dev = typec_switch_register(parent ,desc);
+	if (!IS_ERR(switch_dev)) {
+		*ptr = switch_dev;
+		devres_add(parent, ptr);
+	} else {
+		devres_free(ptr);
+	}
+
+	return switch_dev;
+}
+EXPORT_SYMBOL_GPL(devm_typec_switch_register);
+
 void typec_switch_set_drvdata(struct typec_switch_dev *sw_dev, void *data)
 {
 	dev_set_drvdata(&sw_dev->dev, data);
diff --git a/include/linux/usb/typec_mux.h b/include/linux/usb/typec_mux.h
index c6f49756530d..fe7a05dd71c8 100644
--- a/include/linux/usb/typec_mux.h
+++ b/include/linux/usb/typec_mux.h
@@ -34,6 +34,9 @@ int typec_switch_set(struct typec_switch *sw,
 struct typec_switch_dev *
 typec_switch_register(struct device *parent,
 		      const struct typec_switch_desc *desc);
+struct typec_switch_dev *
+devm_typec_switch_register(struct device *parent,
+			   const struct typec_switch_desc *desc);
 void typec_switch_unregister(struct typec_switch_dev *sw);
 
 void typec_switch_set_drvdata(struct typec_switch_dev *sw, void *data);
@@ -59,6 +62,12 @@ typec_switch_register(struct device *parent,
 {
 	return ERR_PTR(-EOPNOTSUPP);
 }
+static inline struct typec_switch_dev *
+devm_typec_switch_register(struct device *parent,
+			   const struct typec_switch_desc *desc)
+{
+	return typec_switch_register(parent, desc);
+}
 static inline void typec_switch_unregister(struct typec_switch_dev *sw) {}
 
 static inline void typec_switch_set_drvdata(struct typec_switch_dev *sw, void *data) {}
-- 
https://chromeos.dev

