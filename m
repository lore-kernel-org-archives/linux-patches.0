Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98D671993B9;
	Thu,  6 Jun 2024 14:13:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683239; cv=none; b=C8t0Jgu/akrjQAh2Ib3BWOlzlrremwQi8Xv+/0gFyB62unQplFLXaMuMiwwzn9EoKY75tiJWbGKWBJlATUF2AMb/3sV9eaVreO4DI2nBHHvaxeoqGCrt2i+FcU1ZrTCJRpC+kETlsVAgOE+fe48vxJlNvFDduSSaU82IoC7hvRI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683239; c=relaxed/simple;
	bh=6nQshHvYmj38y391V34v2SLJ9EWHejAlvvb+wB1DJ7A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H9+9zqnS8DlW+dAInZ8l1VI30ehZmgldj/gABBNNIk6gGNGw2vHNHBEHS4VJ+L2Xy91NHwFoieHylTzaKe8d+rVdp+oANWNLAJnW/ZKJTacDeo6Z0UoJ7AZ0M33Y5voPXUw8gh7HeUwjd4ErHMgMHy/cw7QhgX8RfUN4cPNFgQM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k1P0BiDa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k1P0BiDa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AA9FC2BD10;
	Thu,  6 Jun 2024 14:13:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683239;
	bh=6nQshHvYmj38y391V34v2SLJ9EWHejAlvvb+wB1DJ7A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k1P0BiDaZrsvXWtiDjfLFsQW88Tpfmr82k5I0BnWLaQZyftWQ1+CK880N1JdKrDM1
	 YYo/g6t69aTFE6UhepnzzOT72o5k06b5UjH1q3lqjwJACM4qhJS59XYWsTF+XXsh0p
	 s8r/FEb9BV8wmhD1ITnhRrck3Iol7FkOzNAQSwuI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yinbo Zhu <zhuyinbo@loongson.cn>,
	Binbin Zhou <zhoubinbin@loongson.cn>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Huacai Chen <chenhuacai@loongson.cn>,
	Daniel Lezcano <daniel.lezcano@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 184/744] dt-bindings: thermal: loongson,ls2k-thermal: Fix incorrect compatible definition
Date: Thu,  6 Jun 2024 15:57:36 +0200
Message-ID: <20240606131738.328014677@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Binbin Zhou <zhoubinbin@loongson.cn>

[ Upstream commit c8c4353685778e75e186103411e9d01a4a3f2b90 ]

The temperature output register of the Loongson-2K2000 is defined in the
chip configuration domain, which is different from the Loongson-2K1000,
so it can't be fallbacked.

We need to use two groups of registers to describe it: the first group
is the high and low temperature threshold setting register; the second
group is the temperature output register.

It is true that this fix will cause ABI corruption, but it is necessary
otherwise the Loongson-2K2000 temperature sensor will not work properly.

Fixes: 72684d99a854 ("thermal: dt-bindings: add loongson-2 thermal")
Cc: Yinbo Zhu <zhuyinbo@loongson.cn>
Signed-off-by: Binbin Zhou <zhoubinbin@loongson.cn>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Acked-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Link: https://lore.kernel.org/r/5198999d679f1a1c3457385acb9fadfc85da1f1e.1713837379.git.zhoubinbin@loongson.cn
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../thermal/loongson,ls2k-thermal.yaml        | 23 +++++++++++++++++--
 1 file changed, 21 insertions(+), 2 deletions(-)

diff --git a/Documentation/devicetree/bindings/thermal/loongson,ls2k-thermal.yaml b/Documentation/devicetree/bindings/thermal/loongson,ls2k-thermal.yaml
index 9748a479dcd4d..ca81c8afba79c 100644
--- a/Documentation/devicetree/bindings/thermal/loongson,ls2k-thermal.yaml
+++ b/Documentation/devicetree/bindings/thermal/loongson,ls2k-thermal.yaml
@@ -18,14 +18,15 @@ properties:
     oneOf:
       - enum:
           - loongson,ls2k1000-thermal
+          - loongson,ls2k2000-thermal
       - items:
           - enum:
               - loongson,ls2k0500-thermal
-              - loongson,ls2k2000-thermal
           - const: loongson,ls2k1000-thermal
 
   reg:
-    maxItems: 1
+    minItems: 1
+    maxItems: 2
 
   interrupts:
     maxItems: 1
@@ -39,6 +40,24 @@ required:
   - interrupts
   - '#thermal-sensor-cells'
 
+if:
+  properties:
+    compatible:
+      contains:
+        enum:
+          - loongson,ls2k2000-thermal
+
+then:
+  properties:
+    reg:
+      minItems: 2
+      maxItems: 2
+
+else:
+  properties:
+    reg:
+      maxItems: 1
+
 unevaluatedProperties: false
 
 examples:
-- 
2.43.0



