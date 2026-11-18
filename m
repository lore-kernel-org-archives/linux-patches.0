Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030744;
	b=eQScek47DabAVa6hiepQhmUzmgXKuqSLHIUrN9RBnQDdV8rFLAjheRf9ICHVqiPH0X6o
	 nCZr1uOi0MKbst8bPjwN1fxQD+fwaPqchhC4cbxDDN3rpQl7sAQuxHOjeBCcIjzOAVqZA
	 6qKuLvLiOhGi/9ea4uC86Y+PbEr2ViC5uSZFT4i75YrZkUPHWP8M+Z0GNnw/XCbaG2DWZ
	 q1PfDn5/vxGDoPUHT3HzMkw/rdWfl+7TM3HDISGqXkuhPKMJi5JGnee55/3EDlRKDo/94
	 DmTDEZWEd7U2s5/9ae7EEQ4mJpyliz8xJlmJLf/ce6/0xXehoL41r2beqSDzwfHNt3A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030744;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qCd2p0zHsBHv8lXizxlZHkURjKg5Wk9fDZM6X23E+gk=;
	b=JJb6aG3Vvr1yv6ADNryQeiJPEfAlqvwuoNi9VDuVfZNon363vUQoKQSQJ3ndRW6uhK31
	 b9HbcjLQ8mRvs+5fJH/McbVoZ7i9Igt/4WG8ksx+BLtYHFjA8rU8R70hAOxslxQeZIvm8
	 33KmOfXOkfXo8wDjKAQBnQjcActny/RIiBTChkxkkuXcFVg3ZUizhdtiBTinfcve+M319
	 b21nHIEQGRcgpm2tpsnF8mfg05/XHwjT2QO9YlpihBS/d2cu6v8v2lOuRmXOzSKwH/kUT
	 Vrx65PBmZG3vwOEn8haxC/ETr/0iNnwUNRRta/zn82pCnB8DlI1W13jdUoyh3ABOWcg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zP1evwem;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA497606A918;
	Wed, 18 Nov 2026 19:39:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zP1evwem
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28FFA1F000C5;
	Wed, 18 Nov 2026 19:39:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795030744;
	bh=qCd2p0zHsBHv8lXizxlZHkURjKg5Wk9fDZM6X23E+gk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zP1evwemhy0A54+Woz5mo0xiBRhpHZGQ3d6m+EvdNzNSimLVHE0zpuhoPIhAW2i9f
	 G2RZkxT+T3CDrwrr7DJ7mZS8NGr2TZ64oBcgVdAV4D2wW2E2Z24Ris0ywdTLKFU+1e
	 lnHk3y66RmKpjIBZoS8AV3KDS780tbxWsjalHh5w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	Linus Walleij <linusw@kernel.org>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0813/1756] dt-bindings: power: supply: ab8500: Add AB8505 charger
Date: Wed, 18 Nov 2026 15:49:00 +0100
Message-ID: <20261118150041.974158546@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index e33329b3af619..b653fc9c45436 100644
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
 
   monitored-battery:
     $ref: /schemas/types.yaml#/definitions/phandle
@@ -30,27 +31,15 @@ properties:
 
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
@@ -77,6 +66,53 @@ required:
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



