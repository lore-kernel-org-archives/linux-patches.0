Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 623CB4D8DF
	for <patches@lists.linux.dev>; Sun,  1 Sep 2024 04:07:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725163631; cv=none; b=M/lOoOk7qFTKgaJCvWuYa/E0O58NK87m+HZQLcWo3Kjpbh6i+Lehj3B8h8PFyd2UozxFy2mZbZHj6d4YnZ63ALbkICo8mu1umLs+RuWzGYWosYOWk0l2mDYo6wiu0NLsXK13odlhDkzF5WcEKzifLSUbX8VjPl/1rSXRO7Q2RFU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725163631; c=relaxed/simple;
	bh=aDCeN3nN9nRcFYme+ATD3OdKxYtiWgyuQ3zp7dza4rA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=clvUq1q9qZoN4IGWtkWHEJvplszknhZBFFN9KbRDQjLP3GZfCfs/u3h+BN/vutcM1Ol6LlLEk/jWYDdJvJblEvm0OgNzT4Vy2AkrAU7k8hCUHHX/H3sCiZHMPAkRmb+b9U2nPuZmW0AJI+eySm1Jj7hbpaltX/byj56DdOqjK2M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=kYpP68F6; arc=none smtp.client-ip=209.85.210.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="kYpP68F6"
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-7142448aaf9so2085527b3a.1
        for <patches@lists.linux.dev>; Sat, 31 Aug 2024 21:07:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1725163629; x=1725768429; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=q5JhzkdOpb5d78Mk6klz+de8MRC1bwTsy8AL/60ewZg=;
        b=kYpP68F6/+qkGITNDwttH6G4I41UMY+kUy2WHiBcaKPd0ridYwsb3N+8JGjOr4n2fq
         TTKl4i00i4w1WHtbdP7597YtWbPxRiMz1O7g8xU21lKjp79sEPRy6LQKbSEg+04I68Ep
         bKZCsVWlaSuTqVaho6LaMfKF0//thteuh6yLM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725163629; x=1725768429;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=q5JhzkdOpb5d78Mk6klz+de8MRC1bwTsy8AL/60ewZg=;
        b=PtjZZiS68vYhBwDH0lk37KbneJhP1gnb3bmC1o9wNUXo/nsyt+y2lJ+R+grUrRvfhL
         Pn0/iNVnCHTkQsku4Gk12Kp7lw77mUnUOWR4ZqjQ0Up7yFm8NzMPafVhIOb9vDSEqZCM
         //rGP5Xn8CNMuqNApwTBK5ocMTCvaB9lVIDESOuua562e0yPS9gqw8HOZII9fF4EM6oN
         6RUTlEKOHfcMt41HCgPu4LzUv8iWGHBelXZUlCCJqaZjAp99zxeKlC7sqVvuG8AWCok2
         tvyXEmJDd+fbCmTgW3wgHkGLks2SssGZ8tYXKLiS08WddchAkEWM+CZIGf6762OVBr7x
         NA6g==
X-Forwarded-Encrypted: i=1; AJvYcCW8RjEYIZCNYVUa1zkIXfQQU/+pFjMpzZ6EOGh+kxZGSCBCswIAnXKotqV+BrdEpzDctS+S0kSP@lists.linux.dev
X-Gm-Message-State: AOJu0YxXOcnbABg+5aoPwnfX8NVJSbOnpgMzdlkxLiyngLQ5GIz0L5Mv
	1XR4zAdfH9gUvDvc/APshxYSBwvqRRBnfmyEa0mo7vCzqG/9TW8IkY5fylFn5w==
X-Google-Smtp-Source: AGHT+IH443VeMjk4kx1Ih8MoClHHt+0Hz48LB1+P16Pb5YXD9rscHzWsBcV2jb1oYKBn+g57FtSFdA==
X-Received: by 2002:a05:6a21:9211:b0:1cc:e0de:c75a with SMTP id adf61e73a8af0-1cce1613874mr11265457637.8.1725163628444;
        Sat, 31 Aug 2024 21:07:08 -0700 (PDT)
Received: from localhost (210.73.125.34.bc.googleusercontent.com. [34.125.73.210])
        by smtp.gmail.com with UTF8SMTPSA id 41be03b00d2f7-7d22e9d4b77sm4590630a12.79.2024.08.31.21.07.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 31 Aug 2024 21:07:08 -0700 (PDT)
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
Subject: [PATCH v4 03/18] usb: typec: Stub out typec_switch APIs when CONFIG_TYPEC=n
Date: Sat, 31 Aug 2024 21:06:41 -0700
Message-ID: <20240901040658.157425-4-swboyd@chromium.org>
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

Ease driver development by adding stubs for the typec_switch APIs when
CONFIG_TYPEC=n. Copy the same method used for the typec_mux APIs to be
consistent.

Cc: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: <linux-usb@vger.kernel.org>
Cc: Pin-yen Lin <treapking@chromium.org>
Signed-off-by: Stephen Boyd <swboyd@chromium.org>
---
 include/linux/usb/typec_mux.h | 43 +++++++++++++++++++++++++++++++----
 1 file changed, 38 insertions(+), 5 deletions(-)

diff --git a/include/linux/usb/typec_mux.h b/include/linux/usb/typec_mux.h
index 2489a7857d8e..efb5ed32b813 100644
--- a/include/linux/usb/typec_mux.h
+++ b/include/linux/usb/typec_mux.h
@@ -3,6 +3,7 @@
 #ifndef __USB_TYPEC_MUX
 #define __USB_TYPEC_MUX
 
+#include <linux/err.h>
 #include <linux/property.h>
 #include <linux/usb/typec.h>
 
@@ -24,16 +25,13 @@ struct typec_switch_desc {
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
@@ -42,6 +40,41 @@ void typec_switch_unregister(struct typec_switch_dev *sw);
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

