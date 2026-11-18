Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020096;
	b=xlt/NYejrkH20kqcQcGmZyue7vgMmnQOP/CHb1KLsm0uCdfjYpTyGTvFc/3IyxeOv6uC
	 E2VIAg5bEqs5sUjOtn0FWJzv4TSWdSaxO1bGs47eH3F35+bVKBDLzML3QYh0NcD5pcCSg
	 Ki8Fzr/6FgFuqBxeaorSntMAzyihIgjq3B0AAO8QvvEdF4eMLEIz6UHrt8xBWPrKQjdzO
	 a4W+4seeLkeMKEcYMeo6djt9Hl1cJ1UY/6VatiLYcu1IlT+b2G0ur5wGqVF9A/zRSpFSV
	 5mXZyPx7jnASTUklMPlvltMAzuiZgBzyiP4IW4TZFts10RGcSGwL1Sji94RG9xIMcZA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020096;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=EEYsYurgcWX332YPDNlQPyHh3E91nWJBrnEzvVCRemE=;
	b=35GfEBu8miAnoa/n2WyGRqMwFjqSdwo0CSx/5WMUgQr2awlWlvn7Dhi8sTnad9mm+C+5
	 rYi7OsUg4wDc9F6AKvQ9uZhgqqdBfMliqqVqcMWpOfJArgPbi10096YCaNL4whLKSVf8v
	 xIhw+qjivt9nqJv9vbcc0skUAqN2X+uOUlQR0iuKJeIusKECSyAtD2KhYfTNg37Mmj9rC
	 LuJuAyidjgJGIU7+MxMezyHn9za7dwvqpWPsobiN+ctMvHliEVVq9DK/u0q8Yr//Enw9P
	 Fvd6JaxALrQ1tP+z/8U8/ITVv6ptkSvz8yOIgmVxs2khd45cv1J+YjP35dxCTsqhYuA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JvFaB3tw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A4F2606A333;
	Wed, 18 Nov 2026 16:41:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JvFaB3tw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80A581F000C6;
	Wed, 18 Nov 2026 16:41:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020096;
	bh=EEYsYurgcWX332YPDNlQPyHh3E91nWJBrnEzvVCRemE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JvFaB3twxzpJhzETuDhHPdFmOq86d8Z9Hfl6FcaTpd+h99678lEFgHsXjd9hnTazD
	 WPSVXSEBUj/7kUTN8Ujf5Oj2E9m8few78Tz4LIPMuNbbmvCRmeKgZwEpbwoi76RSPJ
	 5x5Sx8SaEs8JAYc//CRo6ekWPtfs+znhfSgetvA4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ronald Claveau <linux-kernel-dev@aliel.fr>,
	Daniel Lezcano <daniel.lezcano@kernel.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1828/2651] dt-bindings: thermal: amlogic: describe bus clock for t7-thermal
Date: Wed, 18 Nov 2026 15:51:08 +0100
Message-ID: <20261118150352.946545031@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ronald Claveau <linux-kernel-dev@aliel.fr>

[ Upstream commit 8195b945794ca3a917131b8a5368bb61e687c927 ]

The t7 thermal sensor needs a bus clock, in addition to the existing
functional clock, to gate register access to the sensor. This bus
clock is specific to each sensor, unlike the functional clock which
is shared between sensors. The current binding only describes a
single unnamed clock and therefore cannot represent this hardware
requirement, so add a second clock entry and clock-names for clarity.
Make the second clock mandatory for the t7-thermal compatible only,
via an additional if/then/else, to avoid breaking other Amlogic SoCs
that still use a single clock. Update the t7 example to match.

Fixes: b1c8ccdbd4e9 ("dt-bindings: thermal: amlogic: Add support for T7")
Signed-off-by: Ronald Claveau <linux-kernel-dev@aliel.fr>
Signed-off-by: Daniel Lezcano <daniel.lezcano@kernel.org>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Link: https://patch.msgid.link/20260923-fix-t7-thermal-clock-v2-1-bff7a09eb487@aliel.fr
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../bindings/thermal/amlogic,thermal.yaml     | 29 +++++++++++++++++--
 1 file changed, 27 insertions(+), 2 deletions(-)

diff --git a/Documentation/devicetree/bindings/thermal/amlogic,thermal.yaml b/Documentation/devicetree/bindings/thermal/amlogic,thermal.yaml
index 8cfa44dcda58c..e72cb39ac635d 100644
--- a/Documentation/devicetree/bindings/thermal/amlogic,thermal.yaml
+++ b/Documentation/devicetree/bindings/thermal/amlogic,thermal.yaml
@@ -32,7 +32,15 @@ properties:
     maxItems: 1
 
   clocks:
-    maxItems: 1
+    minItems: 1
+    items:
+      - description: Bus clock, gates register access to the sensor.
+      - description: Functional clock of the temperature sensor, shared between sensors.
+
+  clock-names:
+    items:
+      - const: bus
+      - const: core
 
   power-domains:
     maxItems: 1
@@ -72,6 +80,22 @@ allOf:
     else:
       required:
         - amlogic,secure-monitor
+  - if:
+      properties:
+        compatible:
+          contains:
+            const: amlogic,t7-thermal
+    then:
+      properties:
+        clocks:
+          minItems: 2
+      required:
+        - clock-names
+    else:
+      properties:
+        clocks:
+          maxItems: 1
+        clock-names: false
 
 unevaluatedProperties: false
 
@@ -94,7 +118,8 @@ examples:
         compatible = "amlogic,t7-thermal";
         reg = <0x20000 0x50>;
         interrupts = <GIC_SPI 31 IRQ_TYPE_LEVEL_HIGH>;
-        clocks = <&clkc_periphs CLKID_TS>;
+        clocks = <&clkc_periphs CLKID_SYS_TS_A73>, <&clkc_periphs CLKID_TS>;
+        clock-names = "bus", "core";
         #thermal-sensor-cells = <0>;
         amlogic,secure-monitor = <&sm 1>;
     };
-- 
2.53.0



