Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46E5A22D4C3;
	Mon, 10 Mar 2025 17:44:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741628694; cv=none; b=JYTdffvDxjIUBzCSsd1IYW2im+N+40Cbx2sZqwCVYPLOfGvPiug2Fpvgk8H5U19A6AWjRAVAMXQxoFTU738lg046y3//UtE5+c+1LCQFEqUcab6GPSy92ZA0tXEwiuVLHAGmcMlb226SkPnl1OZxlQrNrkYCRCX0XFhPswVzSkQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741628694; c=relaxed/simple;
	bh=IjBCSmfatBVorqLd6OHM4UOht1+r+TTriUnx6OgEH5o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WkerN++iRxWXbdQSgbz9bMc39KnXdFS+FWldH3kqTzrAJAZz4PmfC2G10g1nSraPAr90IwevqATo7B8iMlgDDSLqzJCIiQQPc7HD4bAwDYftJ+TgWF/DovzquiikJTgl+mEV9MkXZMsjYYDHbEEnjrD4g8VZE2dZmmFTd0SmvUg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KKS7MKmS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KKS7MKmS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8287C4CEE5;
	Mon, 10 Mar 2025 17:44:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741628694;
	bh=IjBCSmfatBVorqLd6OHM4UOht1+r+TTriUnx6OgEH5o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KKS7MKmSBLHnXNRByPU9FTf6z15Bxr64UKmaGGNijpGA3KJGMTsQ16oz+KZ0wSOry
	 QdIfbdh9v665Z+v9eiBHIm9MN65PD3YRnVSj9q3yqMK1NN5MWR9kEAX1fT3+eg7jSI
	 AhS9cJ6Z8QaeQjZy8/jSiCPcFHdOiQWTEjuWYb3Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Rob Herring <robh@kernel.org>,
	Pavel Machek <pavel@ucw.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 036/620] dt-bindings: leds: class-multicolor: reference class directly in multi-led node
Date: Mon, 10 Mar 2025 17:58:02 +0100
Message-ID: <20250310170547.004006843@linuxfoundation.org>
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

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

[ Upstream commit de40c8496ead3e25d1e989999eed0c3ecee8fc96 ]

The leds/common.yaml is referenced directly in each LED node, which
leads to people doing the same with leds/leds-class-multicolor.yaml.
This is not correct because leds-class-multicolor.yaml defined multi-led
property and its children.  Some schemas implemented this incorrect.

Rework this to match same behavior common.yaml, so expect the multi-led
node to reference the leds-class-multicolor.yaml.  Fixing allows to add
unevaluatedProperties:false.

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Reviewed-by: Rob Herring <robh@kernel.org>
Signed-off-by: Pavel Machek <pavel@ucw.cz>
Stable-dep-of: 609bc99a4452 ("dt-bindings: leds: class-multicolor: Fix path to color definitions")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../leds/cznic,turris-omnia-leds.yaml         |  2 ++
 .../bindings/leds/leds-class-multicolor.yaml  | 32 +++++++++----------
 .../devicetree/bindings/leds/leds-lp50xx.yaml |  2 ++
 .../bindings/leds/leds-pwm-multicolor.yaml    |  5 ++-
 .../bindings/leds/leds-qcom-lpg.yaml          |  2 ++
 5 files changed, 24 insertions(+), 19 deletions(-)

diff --git a/Documentation/devicetree/bindings/leds/cznic,turris-omnia-leds.yaml b/Documentation/devicetree/bindings/leds/cznic,turris-omnia-leds.yaml
index 9362b1ef9e88a..14bebe1ad8f8a 100644
--- a/Documentation/devicetree/bindings/leds/cznic,turris-omnia-leds.yaml
+++ b/Documentation/devicetree/bindings/leds/cznic,turris-omnia-leds.yaml
@@ -33,6 +33,8 @@ patternProperties:
   "^multi-led@[0-9a-b]$":
     type: object
     $ref: leds-class-multicolor.yaml#
+    unevaluatedProperties: false
+
     description:
       This node represents one of the RGB LED devices on Turris Omnia.
       No subnodes need to be added for subchannels since this controller only
diff --git a/Documentation/devicetree/bindings/leds/leds-class-multicolor.yaml b/Documentation/devicetree/bindings/leds/leds-class-multicolor.yaml
index f41d021ed6774..12693483231f7 100644
--- a/Documentation/devicetree/bindings/leds/leds-class-multicolor.yaml
+++ b/Documentation/devicetree/bindings/leds/leds-class-multicolor.yaml
@@ -19,22 +19,22 @@ description: |
   LED class.  Common LED nodes and properties are inherited from the common.yaml
   within this documentation directory.
 
-patternProperties:
-  "^multi-led(@[0-9a-f])?$":
-    type: object
-    description: Represents the LEDs that are to be grouped.
-    properties:
-      color:
-        description: |
-          For multicolor LED support this property should be defined as either
-          LED_COLOR_ID_RGB or LED_COLOR_ID_MULTI which can be found in
-          include/linux/leds/common.h.
-        enum: [ 8, 9 ]
-
-    $ref: "common.yaml#"
-
-    required:
-      - color
+properties:
+  $nodename:
+    pattern: "^multi-led(@[0-9a-f])?$"
+
+  color:
+    description: |
+      For multicolor LED support this property should be defined as either
+      LED_COLOR_ID_RGB or LED_COLOR_ID_MULTI which can be found in
+      include/linux/leds/common.h.
+    enum: [ 8, 9 ]
+
+required:
+  - color
+
+allOf:
+  - $ref: "common.yaml#"
 
 additionalProperties: true
 
diff --git a/Documentation/devicetree/bindings/leds/leds-lp50xx.yaml b/Documentation/devicetree/bindings/leds/leds-lp50xx.yaml
index f12fe5b53f30d..64d07fd20eab3 100644
--- a/Documentation/devicetree/bindings/leds/leds-lp50xx.yaml
+++ b/Documentation/devicetree/bindings/leds/leds-lp50xx.yaml
@@ -56,6 +56,8 @@ patternProperties:
   '^multi-led@[0-9a-f]$':
     type: object
     $ref: leds-class-multicolor.yaml#
+    unevaluatedProperties: false
+
     properties:
       reg:
         minItems: 1
diff --git a/Documentation/devicetree/bindings/leds/leds-pwm-multicolor.yaml b/Documentation/devicetree/bindings/leds/leds-pwm-multicolor.yaml
index 6625a528f7275..03fc14d1601f3 100644
--- a/Documentation/devicetree/bindings/leds/leds-pwm-multicolor.yaml
+++ b/Documentation/devicetree/bindings/leds/leds-pwm-multicolor.yaml
@@ -19,6 +19,8 @@ properties:
 
   multi-led:
     type: object
+    $ref: leds-class-multicolor.yaml#
+    unevaluatedProperties: false
 
     patternProperties:
       "^led-[0-9a-z]+$":
@@ -42,9 +44,6 @@ properties:
 required:
   - compatible
 
-allOf:
-  - $ref: leds-class-multicolor.yaml#
-
 additionalProperties: false
 
 examples:
diff --git a/Documentation/devicetree/bindings/leds/leds-qcom-lpg.yaml b/Documentation/devicetree/bindings/leds/leds-qcom-lpg.yaml
index 336bd8e10efd3..6df2838d5f5b3 100644
--- a/Documentation/devicetree/bindings/leds/leds-qcom-lpg.yaml
+++ b/Documentation/devicetree/bindings/leds/leds-qcom-lpg.yaml
@@ -57,6 +57,8 @@ properties:
   multi-led:
     type: object
     $ref: leds-class-multicolor.yaml#
+    unevaluatedProperties: false
+
     properties:
       "#address-cells":
         const: 1
-- 
2.39.5



