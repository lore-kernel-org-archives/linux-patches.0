Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E05CC1514DC;
	Tue,  2 Jul 2024 17:27:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719941263; cv=none; b=rFD+TXxvvKN1a5wt0Mb3jKGmJA/nB7a9k2qd6YoxHFpWaZIGmLq71qYTckGg447jveG3E00vcvvAEPsJ9OZVZ3ggMPc35s2GQ9UWkisM/QvgGRrrvTIhRYJV2rkhBH5gM+dgQt1y0WOVx4i7T5CruqkrjK90BGKTQwRJI6hNOU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719941263; c=relaxed/simple;
	bh=zJHX+i+WFyHfjYn3keIzFTnnY9jVC44zcUqWxe1kuwk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YasR3NLsIUDeD3fpqW6Edk4erK9/7pJ1RCJGIXQm67R5CsDUh1nl+w2MRQxSk7hrD8XoNg1XGCpzrdnONJhqNMGNTJQjISg4xJb/MORavJ8Ass5WQ2wgeNy9UepYKZNZNVWg5nZeH71NGckAMldt35u8JTBq3iveZ01RE1IoatM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZNz6ME3/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZNz6ME3/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D6ECC116B1;
	Tue,  2 Jul 2024 17:27:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719941262;
	bh=zJHX+i+WFyHfjYn3keIzFTnnY9jVC44zcUqWxe1kuwk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZNz6ME3/zCTIE497DwKt8EMfRJx3KketLc5g6Pz9R8D9COxvyywdOkCfj5lWiNHiq
	 xdo/S2UtMhQGgM7JLiaMDV9siyQ2bkZjf6WDdmVSOXyAl9AE5thV5bBl2/0haqB6yZ
	 EyfY1OzBC7/D5DIputGIzhvhCfS62O3zzkGa2d7k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Nicolas Ferre <nicolas.ferre@microchip.com>,
	Alain Volmat <alain.volmat@foss.st.com>,
	Wolfram Sang <wsa@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 013/128] dt-bindings: i2c: Drop unneeded quotes
Date: Tue,  2 Jul 2024 19:03:34 +0200
Message-ID: <20240702170226.735963571@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170226.231899085@linuxfoundation.org>
References: <20240702170226.231899085@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rob Herring <robh@kernel.org>

[ Upstream commit fc114c75680da73c3815512d880f69cecc9a9b87 ]

Cleanup bindings dropping unneeded quotes. Once all these are fixed,
checking for this can be enabled in yamllint.

Signed-off-by: Rob Herring <robh@kernel.org>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Reviewed-by: Nicolas Ferre <nicolas.ferre@microchip.com>
Reviewed-by: Alain Volmat <alain.volmat@foss.st.com>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Stable-dep-of: d4e001ffeccf ("dt-bindings: i2c: atmel,at91sam: correct path to i2c-controller schema")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/devicetree/bindings/i2c/amlogic,meson6-i2c.yaml | 4 ++--
 Documentation/devicetree/bindings/i2c/apple,i2c.yaml          | 4 ++--
 Documentation/devicetree/bindings/i2c/atmel,at91sam-i2c.yaml  | 2 +-
 Documentation/devicetree/bindings/i2c/cdns,i2c-r1p10.yaml     | 4 ++--
 Documentation/devicetree/bindings/i2c/i2c-mux-gpio.yaml       | 4 ++--
 Documentation/devicetree/bindings/i2c/qcom,i2c-geni-qcom.yaml | 4 ++--
 Documentation/devicetree/bindings/i2c/st,stm32-i2c.yaml       | 2 +-
 .../devicetree/bindings/i2c/xlnx,xps-iic-2.00.a.yaml          | 4 ++--
 8 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/Documentation/devicetree/bindings/i2c/amlogic,meson6-i2c.yaml b/Documentation/devicetree/bindings/i2c/amlogic,meson6-i2c.yaml
index 199a354ccb970..26bed558c6b87 100644
--- a/Documentation/devicetree/bindings/i2c/amlogic,meson6-i2c.yaml
+++ b/Documentation/devicetree/bindings/i2c/amlogic,meson6-i2c.yaml
@@ -2,8 +2,8 @@
 # Copyright 2019 BayLibre, SAS
 %YAML 1.2
 ---
-$id: "http://devicetree.org/schemas/i2c/amlogic,meson6-i2c.yaml#"
-$schema: "http://devicetree.org/meta-schemas/core.yaml#"
+$id: http://devicetree.org/schemas/i2c/amlogic,meson6-i2c.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
 
 title: Amlogic Meson I2C Controller
 
diff --git a/Documentation/devicetree/bindings/i2c/apple,i2c.yaml b/Documentation/devicetree/bindings/i2c/apple,i2c.yaml
index 4ac61fec90e26..243da7003cec5 100644
--- a/Documentation/devicetree/bindings/i2c/apple,i2c.yaml
+++ b/Documentation/devicetree/bindings/i2c/apple,i2c.yaml
@@ -1,8 +1,8 @@
 # SPDX-License-Identifier: (GPL-2.0 OR BSD-2-Clause)
 %YAML 1.2
 ---
-$id: "http://devicetree.org/schemas/i2c/apple,i2c.yaml#"
-$schema: "http://devicetree.org/meta-schemas/core.yaml#"
+$id: http://devicetree.org/schemas/i2c/apple,i2c.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
 
 title: Apple/PASemi I2C controller
 
diff --git a/Documentation/devicetree/bindings/i2c/atmel,at91sam-i2c.yaml b/Documentation/devicetree/bindings/i2c/atmel,at91sam-i2c.yaml
index ea2303c0e1431..6adedd3ec399b 100644
--- a/Documentation/devicetree/bindings/i2c/atmel,at91sam-i2c.yaml
+++ b/Documentation/devicetree/bindings/i2c/atmel,at91sam-i2c.yaml
@@ -75,7 +75,7 @@ required:
   - clocks
 
 allOf:
-  - $ref: "i2c-controller.yaml"
+  - $ref: i2c-controller.yaml
   - if:
       properties:
         compatible:
diff --git a/Documentation/devicetree/bindings/i2c/cdns,i2c-r1p10.yaml b/Documentation/devicetree/bindings/i2c/cdns,i2c-r1p10.yaml
index 2e95cda7262ad..7a675aa08c442 100644
--- a/Documentation/devicetree/bindings/i2c/cdns,i2c-r1p10.yaml
+++ b/Documentation/devicetree/bindings/i2c/cdns,i2c-r1p10.yaml
@@ -1,8 +1,8 @@
 # SPDX-License-Identifier: (GPL-2.0 OR BSD-2-Clause)
 %YAML 1.2
 ---
-$id: "http://devicetree.org/schemas/i2c/cdns,i2c-r1p10.yaml#"
-$schema: "http://devicetree.org/meta-schemas/core.yaml#"
+$id: http://devicetree.org/schemas/i2c/cdns,i2c-r1p10.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
 
 title: Cadence I2C controller
 
diff --git a/Documentation/devicetree/bindings/i2c/i2c-mux-gpio.yaml b/Documentation/devicetree/bindings/i2c/i2c-mux-gpio.yaml
index 6e0a5686af048..f34cc7ad5a00e 100644
--- a/Documentation/devicetree/bindings/i2c/i2c-mux-gpio.yaml
+++ b/Documentation/devicetree/bindings/i2c/i2c-mux-gpio.yaml
@@ -45,7 +45,7 @@ properties:
 
   i2c-parent:
     description: phandle of the I2C bus that this multiplexer's master-side port is connected to
-    $ref: "/schemas/types.yaml#/definitions/phandle"
+    $ref: /schemas/types.yaml#/definitions/phandle
 
   mux-gpios:
     description: list of GPIOs used to control the muxer
@@ -55,7 +55,7 @@ properties:
   idle-state:
     description: Value to set the muxer to when idle. When no value is given, it defaults to the
       last value used.
-    $ref: "/schemas/types.yaml#/definitions/uint32"
+    $ref: /schemas/types.yaml#/definitions/uint32
 
 allOf:
   - $ref: i2c-mux.yaml
diff --git a/Documentation/devicetree/bindings/i2c/qcom,i2c-geni-qcom.yaml b/Documentation/devicetree/bindings/i2c/qcom,i2c-geni-qcom.yaml
index 0e7ed00562e21..5a44fdcbdd59b 100644
--- a/Documentation/devicetree/bindings/i2c/qcom,i2c-geni-qcom.yaml
+++ b/Documentation/devicetree/bindings/i2c/qcom,i2c-geni-qcom.yaml
@@ -1,8 +1,8 @@
 # SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
 %YAML 1.2
 ---
-$id: "http://devicetree.org/schemas/i2c/qcom,i2c-geni-qcom.yaml#"
-$schema: "http://devicetree.org/meta-schemas/core.yaml#"
+$id: http://devicetree.org/schemas/i2c/qcom,i2c-geni-qcom.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
 
 title: Qualcomm Geni based QUP I2C Controller
 
diff --git a/Documentation/devicetree/bindings/i2c/st,stm32-i2c.yaml b/Documentation/devicetree/bindings/i2c/st,stm32-i2c.yaml
index bf396e9466aaf..94b75d9f66cdb 100644
--- a/Documentation/devicetree/bindings/i2c/st,stm32-i2c.yaml
+++ b/Documentation/devicetree/bindings/i2c/st,stm32-i2c.yaml
@@ -90,7 +90,7 @@ properties:
   st,syscfg-fmp:
     description: Use to set Fast Mode Plus bit within SYSCFG when Fast Mode
       Plus speed is selected by slave.
-    $ref: "/schemas/types.yaml#/definitions/phandle-array"
+    $ref: /schemas/types.yaml#/definitions/phandle-array
     items:
       - items:
           - description: phandle to syscfg
diff --git a/Documentation/devicetree/bindings/i2c/xlnx,xps-iic-2.00.a.yaml b/Documentation/devicetree/bindings/i2c/xlnx,xps-iic-2.00.a.yaml
index 8d241a703d855..f3b53ecae5625 100644
--- a/Documentation/devicetree/bindings/i2c/xlnx,xps-iic-2.00.a.yaml
+++ b/Documentation/devicetree/bindings/i2c/xlnx,xps-iic-2.00.a.yaml
@@ -1,8 +1,8 @@
 # SPDX-License-Identifier: (GPL-2.0 OR BSD-2-Clause)
 %YAML 1.2
 ---
-$id: "http://devicetree.org/schemas/i2c/xlnx,xps-iic-2.00.a.yaml#"
-$schema: "http://devicetree.org/meta-schemas/core.yaml#"
+$id: http://devicetree.org/schemas/i2c/xlnx,xps-iic-2.00.a.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
 
 title: Xilinx IIC controller
 
-- 
2.43.0



