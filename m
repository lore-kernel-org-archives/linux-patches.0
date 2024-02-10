Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com [209.85.215.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E77B025629
	for <patches@lists.linux.dev>; Sat, 10 Feb 2024 07:09:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707548983; cv=none; b=Cosl8cqf/ybUDAYZpRJYQnBIlFPbY+OHzLSPamlAQyV+D4WDowbrR5sv/hm97bzozYwFOSxo67PrCi5NmmQaiDFJMR4bwNJlpAUdTaDQP41vnFyDQX0bO9/67+YNdtk3KHYHbRew+3EyW48VsjQGXK2dp9QGvIpUXMXcnWoXVi8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707548983; c=relaxed/simple;
	bh=WXij6tQJVWGfA0jVq1TwtVWpf8MLUZF7maDtetHyCq8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tqLjtAaSFP3+2HVPcmyWXezUc3caONqfRg4h04i7GyT13w9cNCe1D1M/iVB+tRtSHIgIYookoKfMmBaoZsGcC0Gne8gmB9TrPqV5L8djz4x3gsOoBKwtI9fMkMm4Bgn6DWvuvpxV939ADNKjeLZGuGdv0ZiAAjvAjFUCfL9I8JQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=LMPrEgot; arc=none smtp.client-ip=209.85.215.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="LMPrEgot"
Received: by mail-pg1-f174.google.com with SMTP id 41be03b00d2f7-5d8b70b39efso1419339a12.0
        for <patches@lists.linux.dev>; Fri, 09 Feb 2024 23:09:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1707548981; x=1708153781; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=q+i5FQpJgQZM9grJNtVDZ+U7TB243p9ucbtyKq1qJsw=;
        b=LMPrEgot0hzR6Wo7K+MEBn+3TNsFNuBfxRm/XNqcnnK2Spt11/jIwrcuCDEAp+dOJN
         JNxdejuIoiRAPB1eUKBKhhwUZDJeWawiCZNs+/EG98/r1N8OfwRnef0tGCd5zvp0q8/m
         wfvSW6Z+uw9yt26XfAqXFWr5RYbe5XcCqBMhE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707548981; x=1708153781;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=q+i5FQpJgQZM9grJNtVDZ+U7TB243p9ucbtyKq1qJsw=;
        b=gwUKAmtoeej3vjg7Iq3R8F3G5Afcu5PUAJqe7JMhNYFcqUQMlcs6kbuJIY4iZb6/s6
         GNvZThh4L94UqsNYahkgd0oBYbxfnFdi9lB8VrahQrgCukC6gBK/yPxKe3LoS7u3mBVd
         1OlgDe6z077Wry9WaPWv7Y55RGH8TpIgTERc0zcYj5l6Y3wUVe3H/i3JuAg6c/Xx33zo
         EP8WZJxGpPWl45gl2xZxpwY8rDSOSxozjnjH8mlpNn02JRCDEkrypt2dOoXx/7OeGzkg
         kRvCCZxGnJMExkdvsRSfbuQl3nYbZhP4e3upKJalT9VgV4sr3Rdy0B01/SlXW4B+XhCO
         ny0Q==
X-Gm-Message-State: AOJu0Yx7Y+mUAF4UjnflxQgD1bwBGoo2POCUUKODrVFGS5gTKK5zoAtx
	hkhWDP0UrI/qgFj+QRnKRJYYGiLb2T3W8OWBiKgdylFmGtkqmhsEnf08ByohHQ==
X-Google-Smtp-Source: AGHT+IGJpsGseEF23OonuLcKGtLB9bLVO6H9DZbcYv6zzMtyY1WMMmBxT79RXg/o+l1OjBFEjT7+5g==
X-Received: by 2002:a05:6a00:990:b0:6e0:6c89:e30b with SMTP id u16-20020a056a00099000b006e06c89e30bmr2062527pfg.19.1707548981026;
        Fri, 09 Feb 2024 23:09:41 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCXfaOQFPe2ptrEFchii8p8d5wFLx6aGOVBzgPCXZjXz6vMArnzaBrz54ebBSrY7Rc7Zb7W2VUAj9BdKIpE0W9dkz5cxBOzIBdQ4QU0l/WvK0O7VjhRWZMwqOXXJ5ykMFpmTSqgratP/faTwzXpvQwn39FSfIVAhwQwraGaTVviZc4cp5j3/BD5CdKGz4B69dvTKZDYXQVUFxLlqnjUvGKFk/DOrZ2zHtEL4xejpVDpzr3Dej3ggRlW+HoqkdCsWPepKV9T+nn9nGOIx4uY7HkdsNGhKIBRFHvFYOERt3EAfj1LY3bkRx0U41mzkKYcK1byjGEHYtEjLSBA3XWVqiZEGmSVaJTnW7QekqO11p2FvukW0hU6g6S8g5ev5eGJBl644kRvLYhHhmgIt237GF/RFZeOSkp6lJLy6lhPpBTyHf9wAeXRDf4/GfAKkUsAuhXX6e5pxcnu723SER6nLBovy4WVE9TkC2SLLkdafuZ/oWR/6aqc7YxZlFlDXXfwdiEzrdLr2sP1bzMCNmf2WF+hM6HhJXzB0gz/8ZcEMMipVJH9k
Received: from localhost (175.199.125.34.bc.googleusercontent.com. [34.125.199.175])
        by smtp.gmail.com with UTF8SMTPSA id z16-20020aa78890000000b006dff3ca9e26sm1635066pfe.102.2024.02.09.23.09.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 Feb 2024 23:09:40 -0800 (PST)
From: Stephen Boyd <swboyd@chromium.org>
To: chrome-platform@lists.linux.dev
Cc: linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	devicetree@vger.kernel.org,
	linux-arm-msm@vger.kernel.org,
	Douglas Anderson <dianders@chromium.org>,
	Pin-yen Lin <treapking@chromium.org>,
	Linus Walleij <linus.walleij@linaro.org>,
	Bartosz Golaszewski <brgl@bgdev.pl>,
	Rob Herring <robh+dt@kernel.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Lee Jones <lee@kernel.org>,
	Benson Leung <bleung@chromium.org>,
	Guenter Roeck <groeck@chromium.org>,
	linux-gpio@vger.kernel.org
Subject: [PATCH 01/22] dt-bindings: gpio: Add binding for ChromeOS EC GPIO controller
Date: Fri,  9 Feb 2024 23:09:12 -0800
Message-ID: <20240210070934.2549994-2-swboyd@chromium.org>
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

The ChromeOS embedded controller (EC) supports setting the state of
GPIOs when the system is unlocked, and getting the state of GPIOs in all
cases. The GPIOs are on the EC itself, so the EC acts similar to a GPIO
expander. Add a binding to describe these GPIOs in DT so that other
devices described in DT can read the GPIOs on the EC.

Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: Bartosz Golaszewski <brgl@bgdev.pl>
Cc: Rob Herring <robh+dt@kernel.org>
Cc: Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>
Cc: Conor Dooley <conor+dt@kernel.org>
Cc: Lee Jones <lee@kernel.org>
Cc: Benson Leung <bleung@chromium.org>
Cc: Guenter Roeck <groeck@chromium.org>
Cc: <linux-gpio@vger.kernel.org>
Cc: <devicetree@vger.kernel.org>
Cc: <chrome-platform@lists.linux.dev>
Cc: Pin-yen Lin <treapking@chromium.org>
Signed-off-by: Stephen Boyd <swboyd@chromium.org>
---
 .../bindings/gpio/google,cros-ec-gpio.yaml    | 49 +++++++++++++++++++
 .../bindings/mfd/google,cros-ec.yaml          |  3 ++
 2 files changed, 52 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/gpio/google,cros-ec-gpio.yaml

diff --git a/Documentation/devicetree/bindings/gpio/google,cros-ec-gpio.yaml b/Documentation/devicetree/bindings/gpio/google,cros-ec-gpio.yaml
new file mode 100644
index 000000000000..a9f1d7784070
--- /dev/null
+++ b/Documentation/devicetree/bindings/gpio/google,cros-ec-gpio.yaml
@@ -0,0 +1,49 @@
+# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/gpio/google,cros-ec-gpio.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: GPIOs controlled by ChromeOS EC
+
+maintainers:
+  - Stephen Boyd <swboyd@chromium.org>
+
+description:
+  Google's ChromeOS EC has a gpio controller inside the Embedded Controller
+  (EC) and controlled via a host-command interface. The node for this
+  device should be under a cros-ec node like google,cros-ec-spi.
+
+properties:
+  compatible:
+    const: google,cros-ec-gpio
+
+  '#gpio-cells':
+    const: 2
+
+  gpio-controller: true
+
+required:
+  - compatible
+  - '#gpio-cells'
+  - gpio-controller
+
+additionalProperties: false
+
+examples:
+  - |
+    spi {
+      #address-cells = <1>;
+      #size-cells = <0>;
+
+      cros-ec@0 {
+        compatible = "google,cros-ec-spi";
+        reg = <0>;
+        interrupts = <101 0>;
+        gpio {
+          compatible = "google,cros-ec-gpio";
+          gpio-controller;
+          #gpio-cells = <2>;
+        };
+      };
+    };
diff --git a/Documentation/devicetree/bindings/mfd/google,cros-ec.yaml b/Documentation/devicetree/bindings/mfd/google,cros-ec.yaml
index e1ca4f297c6d..ded396b28fba 100644
--- a/Documentation/devicetree/bindings/mfd/google,cros-ec.yaml
+++ b/Documentation/devicetree/bindings/mfd/google,cros-ec.yaml
@@ -93,6 +93,9 @@ properties:
   '#size-cells':
     const: 0
 
+  gpio:
+    $ref: /schemas/gpio/google,cros-ec-gpio.yaml#
+
   typec:
     $ref: /schemas/chrome/google,cros-ec-typec.yaml#
 
-- 
https://chromeos.dev

