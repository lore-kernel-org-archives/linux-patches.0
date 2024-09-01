Received: from mail-pg1-f182.google.com (mail-pg1-f182.google.com [209.85.215.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 629187E111
	for <patches@lists.linux.dev>; Sun,  1 Sep 2024 04:07:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725163634; cv=none; b=mgodamaNr60vZphbZILhu3G1rgiO4jUYZfqv3QTl5Ops0lDBi2n0ekuOGWt3QuP67V3YF8mZZGRQ7X5/3m36NrpS3jrW8b6JT8L2NYIMEaiYkVsFRYB/PExBUw3kgcrwoyufCzds4zFmSose/iIU7tj32+KukXo8fcpNjauHVlk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725163634; c=relaxed/simple;
	bh=3V7619Mxma8Aeax8LSroAiPwdTZh9etPyCL5UGAdaDs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jP0trK5jVGaUxsqt3LiQwPU7bH5q/Xng3alaUJ2plH3z+lfS8epYEvTAUjlpOaBp+UzO7hHxyFQmkLz/bco5YaikdK3nwP6PyCBhglPV7VW1UcJSQ6yLCwrIrozeL8RXO3XmSSjhQTM0vAjpXS+jWK4DaBU9oIGT6s7H9v31yd4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=LATD8g2K; arc=none smtp.client-ip=209.85.215.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="LATD8g2K"
Received: by mail-pg1-f182.google.com with SMTP id 41be03b00d2f7-7cd8afc9ff3so2891917a12.0
        for <patches@lists.linux.dev>; Sat, 31 Aug 2024 21:07:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1725163633; x=1725768433; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Sko4acOmndCniAhhaR8U/EXx+Ad9ii+FHZslBTejwPk=;
        b=LATD8g2Ky1gUzPGbHHavi0DJTMegaCLDCOYPE0mHNcIxKInV4OCkVs9MAy34oaIRhq
         TldOvCN+6VlVSNPtYic6ebE95oSQ6FtiCI+FmWiZeVu3yaLfyhqHBgd130CJeATPrErs
         w5IWXuJ87biZCrLtfCp3lWwapFitZMooL3hCk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725163633; x=1725768433;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Sko4acOmndCniAhhaR8U/EXx+Ad9ii+FHZslBTejwPk=;
        b=j4U81Eohj8g6Soz1Hu0euHmRP/St1nkb9L2EvdRP3EqbqIerwJjSiEVZvn/uCLmsE8
         q1dE2gfB4WAXIjmzlxW9uFDzGJI0Rm+F+TzUp8dhgcwvFsob+Yx6g+TpdL22yjrog0FK
         qEhY7aPp7U6gDOBF7GstkeVEP3djahJtTE+ii+kOD5R49DtSf2lQjc60+qw27zK0JlCE
         D/gzbG6QJEQFGiEiJbn2mTohiH+5+atHa4hGpaWsioq9VE/sJOGf+aVuUHr9pvD73TEE
         aAAi1TNlNW6YfcKuEpCkL9A/SG8ofOKgUKdxrPgsdoJuaRDwUTG5zoOTIdvblt9/PsXW
         CbPg==
X-Forwarded-Encrypted: i=1; AJvYcCWc2Zqc9mJhfIT/lNQCxUirLJA6pNk+vuGbEwbCAtZqW9MhdgXkrOergBEQE1qd9NrxmooJ13sb@lists.linux.dev
X-Gm-Message-State: AOJu0YxjraqCvT1qA7hmvKsKK8EWGTv3p7qoZ2z5gA55641p7UBox40w
	cjj1ECDJW2H0Yyyuexsv+n2PqroBpdHHw+NXlFRXGGDnMhrjezjBiier/qJnZg==
X-Google-Smtp-Source: AGHT+IEupx5MlVbtKwKg6yvd5EiB5c1xx+gvkZPhgQaQWXBcBa4Tm7HItPIXvwrtuhd2v5lBCFGh8g==
X-Received: by 2002:a17:902:f60a:b0:1ff:4a01:43f7 with SMTP id d9443c01a7336-2050e97bf7bmr144975245ad.10.1725163632654;
        Sat, 31 Aug 2024 21:07:12 -0700 (PDT)
Received: from localhost (210.73.125.34.bc.googleusercontent.com. [34.125.73.210])
        by smtp.gmail.com with UTF8SMTPSA id d9443c01a7336-205155673a2sm47107365ad.303.2024.08.31.21.07.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 31 Aug 2024 21:07:12 -0700 (PDT)
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
Subject: [PATCH v4 05/18] usb: typec: Add device managed typec_switch_register()
Date: Sat, 31 Aug 2024 21:06:43 -0700
Message-ID: <20240901040658.157425-6-swboyd@chromium.org>
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

Simplify driver error paths by adding devm_typec_switch_register() which
will unregister the typec switch when the parent device is unbound.

Cc: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: <linux-usb@vger.kernel.org>
Cc: Pin-yen Lin <treapking@chromium.org>
Signed-off-by: Stephen Boyd <swboyd@chromium.org>
---
 drivers/usb/typec/mux.c       | 36 +++++++++++++++++++++++++++++++++++
 include/linux/usb/typec_mux.h |  9 +++++++++
 2 files changed, 45 insertions(+)

diff --git a/drivers/usb/typec/mux.c b/drivers/usb/typec/mux.c
index db644bec862c..f420185e36e3 100644
--- a/drivers/usb/typec/mux.c
+++ b/drivers/usb/typec/mux.c
@@ -235,6 +235,42 @@ void typec_switch_unregister(struct typec_switch_dev *sw_dev)
 }
 EXPORT_SYMBOL_GPL(typec_switch_unregister);
 
+static void devm_typec_switch_unregister(void *switch_dev)
+{
+	typec_switch_unregister(switch_dev);
+}
+
+/**
+ * devm_typec_switch_register - resource managed typec_switch_register()
+ * @parent: Parent device
+ * @desc: Multiplexer description
+ *
+ * Register a typec switch and automatically unregister the typec switch
+ * when @parent is unbound from its driver.
+ *
+ * The arguments to this function are identical to typec_switch_register().
+ *
+ * Return: the typec_switch_dev structure on success or error pointer on error.
+ */
+struct typec_switch_dev *
+devm_typec_switch_register(struct device *parent,
+			   const struct typec_switch_desc *desc)
+{
+	int ret;
+	struct typec_switch_dev *switch_dev;
+
+	switch_dev = typec_switch_register(parent ,desc);
+	if (IS_ERR(switch_dev))
+		return switch_dev;
+
+	ret = devm_add_action_or_reset(parent, devm_typec_switch_unregister, switch_dev);
+	if (ret)
+		return ERR_PTR(ret);
+
+	return switch_dev;
+}
+EXPORT_SYMBOL_GPL(devm_typec_switch_register);
+
 void typec_switch_set_drvdata(struct typec_switch_dev *sw_dev, void *data)
 {
 	dev_set_drvdata(&sw_dev->dev, data);
diff --git a/include/linux/usb/typec_mux.h b/include/linux/usb/typec_mux.h
index 08431f0896d5..c30fc7f4441f 100644
--- a/include/linux/usb/typec_mux.h
+++ b/include/linux/usb/typec_mux.h
@@ -35,6 +35,9 @@ int typec_switch_set(struct typec_switch *sw,
 struct typec_switch_dev *
 typec_switch_register(struct device *parent,
 		      const struct typec_switch_desc *desc);
+struct typec_switch_dev *
+devm_typec_switch_register(struct device *parent,
+			   const struct typec_switch_desc *desc);
 void typec_switch_unregister(struct typec_switch_dev *sw);
 
 void typec_switch_set_drvdata(struct typec_switch_dev *sw, void *data);
@@ -60,6 +63,12 @@ typec_switch_register(struct device *parent,
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

