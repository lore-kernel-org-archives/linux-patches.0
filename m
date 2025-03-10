Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A4841DE89C;
	Mon, 10 Mar 2025 17:44:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741628691; cv=none; b=NGymKfCiW2mNNnKaLOzKCut9/SNfBAUU+puS+SX1XIzUTBQInXdNtqO4hBJeddPPju4ciWmCZfn5CiJehkwSdpl+9b/mYyMXQh7F7+C4/oh+Yrb1cb0qN/d06VZXs+2LWsA73L355BQDfpNh+mAhSL8yDt6sxX2wN38gzfYETCs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741628691; c=relaxed/simple;
	bh=sFpzfLECERwi/D2m5o1haxFJ6QGCBlS0V1q2AxACb3Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BO0B/7wN8ofNkjHhA90rH2nPoikSESx/FK3OEK00C61qeus4RE9Qg63ikVnM39yX1a8mE3dwjt1DwsuHT7UGyNo99D+g0vgtkqS3I8uoQ2HCmwS7yO8f9zDWKh5F/oZCVKYDvintSoLlG765Q95HMNuTEyQYUhqUKOLwl+a/WXI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HWatx5+w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HWatx5+w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2FD3C4CEE5;
	Mon, 10 Mar 2025 17:44:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741628691;
	bh=sFpzfLECERwi/D2m5o1haxFJ6QGCBlS0V1q2AxACb3Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HWatx5+wM6WOHAECxHGVYs7XMWVxkbWyR480Fb5RkL57WTc3qD8nt+H9wmOa0lB+F
	 lqHrfVGTQecK3kFPJcSvlqVi2BpZiSlzWVwQZEUIzBlDezlkcEeqYJncNOmYjBTyDs
	 oQjZyUOQj/zb0dU/KATr+DQPfAh++g6ozRZerFMs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sven Schwermer <sven.schwermer@disruptive-technologies.com>,
	Rob Herring <robh@kernel.org>,
	Pavel Machek <pavel@ucw.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 035/620] dt-bindings: leds: Add multicolor PWM LED bindings
Date: Mon, 10 Mar 2025 17:58:01 +0100
Message-ID: <20250310170546.964857762@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sven Schwermer <sven.schwermer@disruptive-technologies.com>

[ Upstream commit ac123741b8f52311af118f8a052b1cbbed041291 ]

This allows to group multiple PWM-connected monochrome LEDs into
multicolor LEDs, e.g. RGB LEDs.

Signed-off-by: Sven Schwermer <sven.schwermer@disruptive-technologies.com>
Reviewed-by: Rob Herring <robh@kernel.org>
Signed-off-by: Pavel Machek <pavel@ucw.cz>
Stable-dep-of: 609bc99a4452 ("dt-bindings: leds: class-multicolor: Fix path to color definitions")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../bindings/leds/leds-pwm-multicolor.yaml    | 79 +++++++++++++++++++
 1 file changed, 79 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/leds/leds-pwm-multicolor.yaml

diff --git a/Documentation/devicetree/bindings/leds/leds-pwm-multicolor.yaml b/Documentation/devicetree/bindings/leds/leds-pwm-multicolor.yaml
new file mode 100644
index 0000000000000..6625a528f7275
--- /dev/null
+++ b/Documentation/devicetree/bindings/leds/leds-pwm-multicolor.yaml
@@ -0,0 +1,79 @@
+# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/leds/leds-pwm-multicolor.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: Multi-color LEDs connected to PWM
+
+maintainers:
+  - Sven Schwermer <sven.schwermer@disruptive-technologies.com>
+
+description: |
+  This driver combines several monochrome PWM LEDs into one multi-color
+  LED using the multicolor LED class.
+
+properties:
+  compatible:
+    const: pwm-leds-multicolor
+
+  multi-led:
+    type: object
+
+    patternProperties:
+      "^led-[0-9a-z]+$":
+        type: object
+        $ref: common.yaml#
+
+        additionalProperties: false
+
+        properties:
+          pwms:
+            maxItems: 1
+
+          pwm-names: true
+
+          color: true
+
+        required:
+          - pwms
+          - color
+
+required:
+  - compatible
+
+allOf:
+  - $ref: leds-class-multicolor.yaml#
+
+additionalProperties: false
+
+examples:
+  - |
+    #include <dt-bindings/leds/common.h>
+
+    led-controller {
+        compatible = "pwm-leds-multicolor";
+
+        multi-led {
+          color = <LED_COLOR_ID_RGB>;
+          function = LED_FUNCTION_INDICATOR;
+          max-brightness = <65535>;
+
+          led-red {
+              pwms = <&pwm1 0 1000000>;
+              color = <LED_COLOR_ID_RED>;
+          };
+
+          led-green {
+              pwms = <&pwm2 0 1000000>;
+              color = <LED_COLOR_ID_GREEN>;
+          };
+
+          led-blue {
+              pwms = <&pwm3 0 1000000>;
+              color = <LED_COLOR_ID_BLUE>;
+          };
+        };
+    };
+
+...
-- 
2.39.5



