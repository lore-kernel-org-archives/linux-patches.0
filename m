Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E33F02144A7
	for <patches@lists.linux.dev>; Wed,  5 Feb 2025 23:30:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738798224; cv=none; b=OekUX14xP7J/T6HRiUOcsS5P9JZs6rS00r1w7gA7DXsFeyo/9+xv/GIoSPD3mjiPcKuxhzFyM0son7xOu93Gmj2AHykQlQXihNFklAB3/3KbF6JhcnO0SF4dHQjp2IbI/yvHEkEyYDjjOQUEVl9l+3oZyxVNwh0QQR9MelWrjxg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738798224; c=relaxed/simple;
	bh=/4MVACIsm4mxXNiJSYO9O9WP/zDnD65LIiLgfNT+Jv4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NZAzhwjr0TkcHGz/K0lmxfHeVa6YGwpg7sWzGYm6KOqeqk24bkrnH/3/v1WkbY6psk1u6g6TZQLuwTan/qY0dYew8x6rNW40k4i8rZgNUxJ8mZ37kM5sx/2u/zz6m6zwqu5uiJAtc8IXDBU4Isu9Lo7AeKZYs0oWiSAUeT5w3No=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=e/vIKn49; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="e/vIKn49"
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-2166360285dso6582445ad.1
        for <patches@lists.linux.dev>; Wed, 05 Feb 2025 15:30:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1738798222; x=1739403022; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ENYD7Jqf2Ry9h9YG/MAy2Qwl7UQB5Doq6yEYLu32Qi0=;
        b=e/vIKn49gNHtH/Z2jGGHujbGSnxH35V53wCiTg0xaKIjIV6HJMfksUT22xt3xWCwaI
         qJCpHh2aBRYQ5VOMNCgIu/7jNUcnT3w0cKlK9KmIkrjU9obdx6XJOzm9JC/OdKUnQd/p
         YD5Zgn6c+bywsOWQ1biJ3Uj8fxeIltvj8r61o=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738798222; x=1739403022;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ENYD7Jqf2Ry9h9YG/MAy2Qwl7UQB5Doq6yEYLu32Qi0=;
        b=B40mEniqco2D+GTH+K8IbkL/QwRwEwkEz+n+F4wBrRYhrBMmEV+AbNAGVNTGDfq51e
         PBcshG1njYa58M7vKO8Jlsfyt9B/C2fAf2l2n9yqui03okPRGuYtW/liKhmRLFghr2m5
         mr8MkwjDKgMpYXRu046UJNlXwL5im9XFf++pIU+m6uTdmlthA2dKTs2dt0IgLzhVORFl
         w+7jQZf5/u1dtI4C43S4oZuwxeR3w545pJy5kIM0f7pAQmoLcwNXdMkyJO7yBjefKt/0
         rzBmApai26bmr1Y2kFiH9dN6f47mV88R24U+oeKQxVhPSmFsifWbtmpIpa3+n6NM4GtD
         xGQQ==
X-Forwarded-Encrypted: i=1; AJvYcCUswdB+kqV05EscZIL/R2OEie2hRP7fib54ZTAqlTexwgy3BF7TvGwtGj+uaE6sQG5He0F6Y9S7@lists.linux.dev
X-Gm-Message-State: AOJu0YwCtyh2Jm7J4IIPjnJUfGwTk38A+kT9rHzYE/gV6owiUrM2fHNA
	qtSkLFUS8S/viSep4me5tywG+ZKu2L6SBEmzFOrpadi/aUdY1lXgjvZVB1qbUg==
X-Gm-Gg: ASbGnctx1EXkt4s9N9zP/ypyB6O412eP1Zn22G+Zjf3trEDA5fOZydoH3xIBs9v5kmz
	6v6HJVXHWOVtJhCsF4SGigCDK38Ko1tyHDCy+fCzOXg2o1HYaoMRb5dLIWicHFAqvqAh9L5YP5m
	XDSztPWnnu7T2yMIIa6DGrFLgpcGYjSBRkq4ndGl6U+1bcDe/vUJUPJa0RNSeZQwMvYpcLj6znj
	MxRkJaht+PnC8V6k6Gi0mgRMFjW0BF+OujqUMT/CiCY9qQ1W5MGa6tUIKm8wF0dG5dJo46zYWjb
	sYCDPvcVjDGOb5rS7oIOCvYiCpYdaaie6l0KBYb3PgT4Ps+WPQzzuG0=
X-Google-Smtp-Source: AGHT+IEZ4n+Jd53BNMcbz3qeJy5aLqWtFVqnGwoigd8TEJYu9DWYm8+Vg9ly6TVuMdEWwx88axmwQQ==
X-Received: by 2002:a17:902:cf12:b0:216:48f4:4f1a with SMTP id d9443c01a7336-21f17e4ca85mr82422235ad.16.1738798222190;
        Wed, 05 Feb 2025 15:30:22 -0800 (PST)
Received: from localhost (129.135.125.34.bc.googleusercontent.com. [34.125.135.129])
        by smtp.gmail.com with UTF8SMTPSA id 41be03b00d2f7-acec0a69b3bsm12388570a12.71.2025.02.05.15.30.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Feb 2025 15:30:21 -0800 (PST)
From: Stephen Boyd <swboyd@chromium.org>
To: Konrad Dybcio <konradybcio@kernel.org>,
	Bjorn Andersson <andersson@kernel.org>
Cc: linux-kernel@vger.kernel.org,
	linux-arm-msm@vger.kernel.org,
	patches@lists.linux.dev,
	cros-qcom-dts-watchers@chromium.org,
	Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Benson Leung <bleung@chromium.org>,
	devicetree@vger.kernel.org,
	chrome-platform@lists.linux.dev,
	Pin-yen Lin <treapking@chromium.org>
Subject: [PATCH v2 1/2] dt-bindings: chrome: Add binding for ChromeOS Pogo pin connector
Date: Wed,  5 Feb 2025 15:30:14 -0800
Message-ID: <20250205233016.1600517-2-swboyd@chromium.org>
X-Mailer: git-send-email 2.48.1.362.g079036d154-goog
In-Reply-To: <20250205233016.1600517-1-swboyd@chromium.org>
References: <20250205233016.1600517-1-swboyd@chromium.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Describe the set of pins used to connect the detachable keyboard on
detachable ChromeOS devices. The set of pins is called the "pogo pins".
It's basically USB 2.0 with an extra pin for base detection. We expect
to find a keyboard on the other side of this connector with a specific
vid/pid, so describe that as a child device at the port of the usb
device connected upstream.

Cc: Rob Herring <robh@kernel.org>
Cc: Krzysztof Kozlowski <krzk+dt@kernel.org>
Cc: Conor Dooley <conor+dt@kernel.org>
Cc: Benson Leung <bleung@chromium.org>
Cc: <devicetree@vger.kernel.org>
Cc: <chrome-platform@lists.linux.dev>
Cc: Pin-yen Lin <treapking@chromium.org>
Signed-off-by: Stephen Boyd <swboyd@chromium.org>
---
 .../chrome/google,pogo-pin-connector.yaml     | 68 +++++++++++++++++++
 1 file changed, 68 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/chrome/google,pogo-pin-connector.yaml

diff --git a/Documentation/devicetree/bindings/chrome/google,pogo-pin-connector.yaml b/Documentation/devicetree/bindings/chrome/google,pogo-pin-connector.yaml
new file mode 100644
index 000000000000..622e171b6b08
--- /dev/null
+++ b/Documentation/devicetree/bindings/chrome/google,pogo-pin-connector.yaml
@@ -0,0 +1,68 @@
+# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/chrome/google,pogo-pin-connector.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: Google Pogo Pin Connector
+
+maintainers:
+  - Stephen Boyd <swboyd@chromium.org>
+
+description:
+  ChromeOS devices with a detachable keyboard have a set of five pins called
+  pogo pins that are the typical four pins for USB (D+/D-, vbus, ground) and an
+  extra pin for base detection. The detachable keyboard is a USB device that
+  connects to the pogo pins.
+
+properties:
+  compatible:
+    const: google,pogo-pin-connector
+
+  '#address-cells':
+    const: 1
+
+  '#size-cells':
+    const: 0
+
+  port:
+    $ref: /schemas/graph.yaml#/properties/port
+    description: Connection to USB2 port providing USB signals
+    required:
+      - endpoint
+
+patternProperties:
+  "^keyboard@[0-9a-f]{1,2}$":
+    description: The detachable keyboard
+    type: object
+    $ref: /schemas/usb/usb-device.yaml
+    unevaluatedProperties: false
+
+required:
+  - compatible
+  - '#address-cells'
+  - '#size-cells'
+  - port
+
+additionalProperties: false
+
+examples:
+  - |
+    connector {
+      compatible = "google,pogo-pin-connector";
+      #address-cells = <1>;
+      #size-cells = <0>;
+
+      keyboard@2 {
+        compatible = "usb18d1,504c";
+        reg = <2>;
+      };
+
+      port {
+        pogo_connector_in: endpoint {
+          remote-endpoint = <&usb_hub_dsp3_hs>;
+        };
+      };
+    };
+
+...
-- 
https://chromeos.dev

