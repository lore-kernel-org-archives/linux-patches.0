Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 004E820012E
	for <patches@lists.linux.dev>; Mon, 19 Aug 2024 22:39:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724107147; cv=none; b=UnPoheIIVvqIupcH8hOgoJEFBrnd1rF/xbMD4/2/4XBt6W3X7CPDHlIM9Teh4f5waFCA/G2jLtOKrAZ9owJ0TiCa+iZOakAz65ydNbCAsuj9bkh4TKeqUUCwdlcTNpeAF0RlfNL+lGcazV4qrGMquVtZs0snKtT0n0eE8hpgy44=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724107147; c=relaxed/simple;
	bh=Ti4xspzmJb0dyaL6KteaBPQDBI0NpBagPW8WNKTO9c4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bJ6LluWgma2vhfPf6ivRS5yFwgwWn5NgdIOl4OEYBf/LLdojqk7IIrVFaGniuhkRYBnQtG50maeKkoTkd1zK+Zvc2+K45fx35AR/O/hX9LtmXEbykVQ+MmvLcsGLkC93wdo8IlZ34D0lB1+9zJ9r6qLC27mFLtvMNew41WzbC8s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=TyPJYB4g; arc=none smtp.client-ip=209.85.210.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="TyPJYB4g"
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-713dc00ce9dso2138414b3a.0
        for <patches@lists.linux.dev>; Mon, 19 Aug 2024 15:39:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1724107145; x=1724711945; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=T31q96nI7HTHANhAbPDLeTjBqmklGP7ssi3aURXB78Y=;
        b=TyPJYB4gjbQCz4c0F4dHRYCYjpgurwJTXFZZNb8lreAHyp6MYH4WfpK9UkzhBgVmLZ
         I6HsEivpZTKaWkpkklB3CZAUyFzN/8ODivslbQ+M+Y9gmD0QMrirXPe9z9zrRSQJq8Z9
         Xy9Uwe2hDSXa894s2/1djEY9OFeWBSqilezDs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724107145; x=1724711945;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=T31q96nI7HTHANhAbPDLeTjBqmklGP7ssi3aURXB78Y=;
        b=n/VzetYyGkZeEzbhHGIhgdjhwX8RdfqUyxIy7zAKo7I7blGH5Qbbv+o2jA/8VIz36R
         npdttOa/Ho9emHfhd8uCY9ut/nKL5QBcwtf8D5kmcwdBe/vli74I5TEk0R58YQybNlMu
         IjQBaL+M8wO9Mt+AXu3/dpakbJnF6dhK/Ak6N+ksF47j1lrUWSVdabn3E2d/9Rsn8ZR2
         3kt5ywL4BJh++WruY4FoeUMLHDrKcIoC5/A4m45XSYficjCX5SlcZBX2/6d7PueV1Jy2
         78Xj9zzRgiciVldCF7yg0UnqeCrcQyqydlmlaI8KAMDUXqb0KD1d9Mjdcm6yuqQW2NTT
         GDNg==
X-Forwarded-Encrypted: i=1; AJvYcCUNQS40pZY6Z2dFU7qWRQeKu9ECRQF5RmwX8zcpfMCY4HtwvMtcsM9M3shynvtyhICMu7uX+2knvJZCSF/L3JNNtw0ONTRQLg==
X-Gm-Message-State: AOJu0Yxkw2GzVDyCC2b/cTmLGRPhmB2qDWa9zjjf1WmQfqOHmMZCzIjk
	pgAVkyQ3txlybAWQEK+QyYY3gE5Ztl7SyGV4NT6UcYY6qEfen7hcoN9KSax4/Q==
X-Google-Smtp-Source: AGHT+IGkbe8vELlVZVdfm7iYACRe3TPZ4k2lnZ7T8LU4DsUAYy70X4jlTSj4PuE13uFvl6Gg6qUx3g==
X-Received: by 2002:a05:6a00:6f68:b0:70d:2556:2b1 with SMTP id d2e1a72fcca58-713c4e73cccmr14140075b3a.13.1724107145269;
        Mon, 19 Aug 2024 15:39:05 -0700 (PDT)
Received: from localhost (210.73.125.34.bc.googleusercontent.com. [34.125.73.210])
        by smtp.gmail.com with UTF8SMTPSA id d2e1a72fcca58-7127add7660sm7040208b3a.38.2024.08.19.15.39.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Aug 2024 15:39:04 -0700 (PDT)
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
	Vinod Koul <vkoul@kernel.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Subject: [PATCH v3 13/17] dt-bindings: Move google,cros-ec-typec binding to usb
Date: Mon, 19 Aug 2024 15:38:27 -0700
Message-ID: <20240819223834.2049862-14-swboyd@chromium.org>
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

This binding is about USB type-c control. Move the binding to the usb
directory as it's a better home than chrome.

Cc: Rob Herring <robh+dt@kernel.org>
Cc: Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>
Cc: Conor Dooley <conor+dt@kernel.org>
Cc: Lee Jones <lee@kernel.org>
Cc: Benson Leung <bleung@chromium.org>
Cc: Guenter Roeck <groeck@chromium.org>
Cc: Prashant Malani <pmalani@chromium.org>
Cc: Tzung-Bi Shih <tzungbi@kernel.org>
Cc: <devicetree@vger.kernel.org>
Cc: <chrome-platform@lists.linux.dev>
Cc: Pin-yen Lin <treapking@chromium.org>
Suggested-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Stephen Boyd <swboyd@chromium.org>
---
 Documentation/devicetree/bindings/mfd/google,cros-ec.yaml     | 2 +-
 .../bindings/{chrome => usb}/google,cros-ec-typec.yaml        | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)
 rename Documentation/devicetree/bindings/{chrome => usb}/google,cros-ec-typec.yaml (90%)

diff --git a/Documentation/devicetree/bindings/mfd/google,cros-ec.yaml b/Documentation/devicetree/bindings/mfd/google,cros-ec.yaml
index aac8819bd00b..c991626dc22b 100644
--- a/Documentation/devicetree/bindings/mfd/google,cros-ec.yaml
+++ b/Documentation/devicetree/bindings/mfd/google,cros-ec.yaml
@@ -99,7 +99,7 @@ properties:
   gpio-controller: true
 
   typec:
-    $ref: /schemas/chrome/google,cros-ec-typec.yaml#
+    $ref: /schemas/usb/google,cros-ec-typec.yaml#
 
   ec-pwm:
     $ref: /schemas/pwm/google,cros-ec-pwm.yaml#
diff --git a/Documentation/devicetree/bindings/chrome/google,cros-ec-typec.yaml b/Documentation/devicetree/bindings/usb/google,cros-ec-typec.yaml
similarity index 90%
rename from Documentation/devicetree/bindings/chrome/google,cros-ec-typec.yaml
rename to Documentation/devicetree/bindings/usb/google,cros-ec-typec.yaml
index 9f9816fbecbc..5ec4a9777ea1 100644
--- a/Documentation/devicetree/bindings/chrome/google,cros-ec-typec.yaml
+++ b/Documentation/devicetree/bindings/usb/google,cros-ec-typec.yaml
@@ -1,10 +1,10 @@
 # SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
 %YAML 1.2
 ---
-$id: http://devicetree.org/schemas/chrome/google,cros-ec-typec.yaml#
+$id: http://devicetree.org/schemas/usb/google,cros-ec-typec.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: Google Chrome OS EC(Embedded Controller) Type C port driver.
+title: Google Chrome OS Embedded Controller (EC) USB type-c port driver
 
 maintainers:
   - Benson Leung <bleung@chromium.org>
-- 
https://chromeos.dev

