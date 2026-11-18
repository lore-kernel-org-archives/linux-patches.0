Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795040716;
	b=bNQSk7m+Xj+edKsT5xko6MYx66WLhx5h6q8yeLU3a6GGvJrUPkMAzG4m4Kc+rzcjkwVd
	 Yy8zQrRPUroFSVYjqbOy7XNVefMNY1H2+JPNzMTv3jFEfpBPY/T3oePXskbn6olbnGc1K
	 yCX5dmbCfTN+/YxP+SKXWmWnAd1iR8fnSWpN11Ze0SNtwwyqUA9eigZb04/EQaJecVROl
	 bQGyX4aX1msCQPxmKVzalA4qnfD6xDJ2tgimAkHHiG12U7flHwZJq9sp7vpD2VtNVdW+G
	 SKwXR06cy6wDnn0mfRd+dtbglL/FLPYttPiMG4r2x/TSWy+nWJZLIbnp+w/5QGdGk0g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795040716;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=FzWllHUS+K910NdO9Ltkt0DYTUNLPiHWcMdGTLpqpdk=;
	b=eI/fY0nVAbqG2z3wNnfHiBh1Re6Ge1MCf7T3YkK1lwTw7d0jg44qSEd/uWkZ05onC7T2
	 469QAAeUGPkpz0R+5Pykx1gIv6MYgb8RqrnDgaSWerH4/Kspqo9wyvpjpmsDN0KqYqvLT
	 MrOqLjyNAw/PTEXW7HTchtVpNVAulqt9WMo/vRTyvGZnxAJi+DwL3R7rx2LqyWvP29yvi
	 DJBvws8liwVr1GE1700AcywpJcCBzmXsF6JQzhf1oBrJPzcCcjiY378/oJlGNRduOnE8y
	 aOc8x6t0uadeFDQFXc6sV0cXREO1M5P7q7Pf/vOuqEW1LnknjONpmGPHGyr3CxlCicA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="lpsSQYj/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2075606A325;
	Wed, 18 Nov 2026 22:25:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lpsSQYj/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F369A1F000C4;
	Wed, 18 Nov 2026 22:25:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795040716;
	bh=FzWllHUS+K910NdO9Ltkt0DYTUNLPiHWcMdGTLpqpdk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lpsSQYj/SzleUSKDfUuIswYXsX+6b+NbT3RHB/Z3++azVj75MLJvSzP71LAB2nN4Z
	 Sc7kjNnOHQMi0dHrykbajwoM5wLwRDw4InOewoDrfTBpHhAjCE83BpiN6HTGpNgw9o
	 a+1oMqO7uoa7jShbHIHdUvslse5pHdz3+msKw3v8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	Linus Walleij <linusw@kernel.org>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2539/3318] dt-bindings: power: supply: ab8500: Add AB8505 charger
Date: Wed, 18 Nov 2026 15:52:41 +0100
Message-ID: <20261118150437.486661705@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



