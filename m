Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055843;
	b=eJGBjdqQei6GQL3GjleGzIbu1ODu4PADTyovnW2MenFcVefuC36d9GBHCxP8jh68rlmw
	 We4D1XuUyxdfG+thE7VKF6P7I+rQTH0C7Dhm/eNg5C7SC5kcCHUzcXfj4U0crjATx0T6k
	 qxfPmGd96Pov+JpOEqANP0Tl6rO10lxmQ8baDH3XWMp5NDwI6wPX0HK7Wfghi4gjaBIGK
	 HKiezaRJDMEX8gEmeIz0XmoROkTk/TWggcD9XJLiY4EKKh03S71FE+RagVSNExnD2kyOS
	 pKQbC4gKa75SbKUCNb3mKj/UOmvwVbA1Zy50OBoTNWbAz4hpeXUf6ipVslXFxdm+CnA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055843;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=oMShWSyV645xPBLADv0e9pD/jZ7z6Bjsm4hPKQZnr2I=;
	b=XYUsdhWNo785+n2aSTq+nVWmM/Jy6+2AjyjXux8MaP6UqDdXtAGhxEr33UJUhRF24LkT
	 5ivja27DjADLUwyiZetj5Cf8czLB/pSMuA4t7EdoOJcBijfxvk9fDQ3YIKTMaHl3T2arn
	 tDUaXJsnrcjzDmdmVxNCyqHruMlenVV5IeNRDMND72/lppgAND+rFWuEHrSXRurLb8xNf
	 F6jBp1T+JiuG7ukifR4xUrPvTFugcyLhr2mPIGm1W5/ccWYGxjoyXnHwphy4Ctyb2G2zU
	 +sBRkxLMi6e93kcKmc7kM1ArgvzEfAZFL4G3UtBtJRBzRPVYYBCLGuL4LulyBrztWLg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qt5g2ucd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A727606A320;
	Thu, 19 Nov 2026 02:37:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qt5g2ucd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D70961F000C4;
	Thu, 19 Nov 2026 02:37:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055843;
	bh=oMShWSyV645xPBLADv0e9pD/jZ7z6Bjsm4hPKQZnr2I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qt5g2ucd9QaE6CD73soK1cGBe9Sgp73mKTluXOcUVKpGSlkLYITUpoLtF14n8WhUh
	 Q3hgW74ubWB0GpmBvD+Io1hHC5Ry4xPsejcURkZ0J2N2nSENb+fCvIU+zw2+sAaDBa
	 JbY9tiS24zmZdkzQBKlYaGn4j73QHWck/9p2N0UM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	Linus Walleij <linusw@kernel.org>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1724/2214] dt-bindings: power: supply: ab8500: Add AB8505 charger
Date: Wed, 18 Nov 2026 15:56:40 +0100
Message-ID: <20261118150120.682364804@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linus Walleij <linusw@kernel.org>

[ Upstream commit 80d28539c1f9baab72210501729d67e3d9daa4b8 ]

AB8500 and AB8505 expose different charger interrupt sets. Add a unique
AB8505 charger compatible with the AB8500 compatible as its fallback.
Use the variant-specific string to require the fourteen main and USB
charger interrupts on AB8500 and the nine USB charger interrupts on
AB8505.

Also clarify that autopower_cfg describes the AB8500 facility, since the
corresponding AB8505 register bit is reserved.

Fixes: eb917497734c ("dt-bindings: power: supply: ab8500: Convert to DT schema format")
Assisted-by: LLM
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Signed-off-by: Linus Walleij <linusw@kernel.org>
Link: https://patch.msgid.link/20260925-ab8500-charger-dt-v3-1-f80b8d295e2d@kernel.org
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../supply/stericsson,ab8500-charger.yaml     | 76 ++++++++++++++-----
 1 file changed, 56 insertions(+), 20 deletions(-)

diff --git a/Documentation/devicetree/bindings/power/supply/stericsson,ab8500-charger.yaml b/Documentation/devicetree/bindings/power/supply/stericsson,ab8500-charger.yaml
index e13305afea693..1578b7a559dac 100644
--- a/Documentation/devicetree/bindings/power/supply/stericsson,ab8500-charger.yaml
+++ b/Documentation/devicetree/bindings/power/supply/stericsson,ab8500-charger.yaml
@@ -10,12 +10,13 @@ title: AB8500 Charger
 maintainers:
   - Sebastian Reichel <sre@kernel.org>
 
-allOf:
-  - $ref: power-supply.yaml#
-
 properties:
   compatible:
-    const: stericsson,ab8500-charger
+    oneOf:
+      - const: stericsson,ab8500-charger
+      - items:
+          - const: stericsson,ab8505-charger
+          - const: stericsson,ab8500-charger
 
   battery:
     $ref: /schemas/types.yaml#/definitions/phandle
@@ -26,27 +27,15 @@ properties:
 
   autopower_cfg:
     type: boolean
-    description: automatic poweron after powerloss
+    description: AB8500 automatic poweron after powerloss
 
   interrupts:
+    minItems: 9
     maxItems: 14
 
   interrupt-names:
-    items:
-      - const: MAIN_CH_UNPLUG_DET
-      - const: MAIN_CHARGE_PLUG_DET
-      - const: MAIN_EXT_CH_NOT_OK
-      - const: MAIN_CH_TH_PROT_R
-      - const: MAIN_CH_TH_PROT_F
-      - const: VBUS_DET_F
-      - const: VBUS_DET_R
-      - const: USB_LINK_STATUS
-      - const: USB_CH_TH_PROT_R
-      - const: USB_CH_TH_PROT_F
-      - const: USB_CHARGER_NOT_OKR
-      - const: VBUS_OVV
-      - const: CH_WD_EXP
-      - const: VBUS_CH_DROP_END
+    minItems: 9
+    maxItems: 14
 
   io-channels:
     minItems: 2
@@ -73,6 +62,53 @@ required:
   - io-channels
   - io-channel-names
 
+allOf:
+  - $ref: power-supply.yaml#
+  - if:
+      properties:
+        compatible:
+          contains:
+            const: stericsson,ab8505-charger
+    then:
+      properties:
+        interrupts:
+          minItems: 9
+          maxItems: 9
+
+        interrupt-names:
+          items:
+            - const: VBUS_DET_F
+            - const: VBUS_DET_R
+            - const: USB_LINK_STATUS
+            - const: USB_CH_TH_PROT_R
+            - const: USB_CH_TH_PROT_F
+            - const: USB_CHARGER_NOT_OKR
+            - const: VBUS_OVV
+            - const: CH_WD_EXP
+            - const: VBUS_CH_DROP_END
+    else:
+      properties:
+        interrupts:
+          minItems: 14
+          maxItems: 14
+
+        interrupt-names:
+          items:
+            - const: MAIN_CH_UNPLUG_DET
+            - const: MAIN_CHARGE_PLUG_DET
+            - const: MAIN_EXT_CH_NOT_OK
+            - const: MAIN_CH_TH_PROT_R
+            - const: MAIN_CH_TH_PROT_F
+            - const: VBUS_DET_F
+            - const: VBUS_DET_R
+            - const: USB_LINK_STATUS
+            - const: USB_CH_TH_PROT_R
+            - const: USB_CH_TH_PROT_F
+            - const: USB_CHARGER_NOT_OKR
+            - const: VBUS_OVV
+            - const: CH_WD_EXP
+            - const: VBUS_CH_DROP_END
+
 additionalProperties: false
 
 examples:
-- 
2.53.0



