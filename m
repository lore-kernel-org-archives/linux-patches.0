Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEE78168C4;
	Mon, 27 May 2024 19:26:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716838004; cv=none; b=XAakwwzkhbpnUUesn/sTH7J/NfUma6WcU0M7bAPcGLKOvk4aJn0qBZ5dx90Gv8NlMryrXG49RUHkYGPU9rW6TAwatKoO4XJTQRO1xQuBougjpi2xdEfqG4q2czfEc8C09H4TCXEYsfQlcAle/1QilT532afU8RiFmULfkP1d2/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716838004; c=relaxed/simple;
	bh=3nWvy4Nai+a9wIYG8eYIBBKm+Sc6XBVO1n3i7TNrUJo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gim0y9AJhSF45XT5ayKkSL9gB9Xojn4OF/9JtVV/ysbEZOg4SafcDyPhTSEy8FzWOufZJ2GTmPtO+0VFe+ciX/83M0FcU5Aaur5T5WU06eVutYNeVTG9Yr48VgQDXlmgmtVsWqnUzod2gEFEyd2/A2iPlksVs71WsqTG8d+Pl5g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qjF0IMpG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qjF0IMpG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82F14C2BBFC;
	Mon, 27 May 2024 19:26:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716838003;
	bh=3nWvy4Nai+a9wIYG8eYIBBKm+Sc6XBVO1n3i7TNrUJo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qjF0IMpGMMYXeKNtMa/bbkVv0vTGG6uVQIkUZiwpRi4I6SW1JuBAnunJLa2onsAWq
	 uUZXSqdU5wiPmZUSwfo5CkVAZX2pn88c3JdPo1KR1L6WtpdKv+9O54PB9pf7akJSu6
	 sk11jtelvtM0tlaoLi3D6dTw5ujr7Mhmy3W0lqM8=
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
Subject: [PATCH 6.8 230/493] dt-bindings: thermal: loongson,ls2k-thermal: Fix incorrect compatible definition
Date: Mon, 27 May 2024 20:53:52 +0200
Message-ID: <20240527185637.825374967@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185626.546110716@linuxfoundation.org>
References: <20240527185626.546110716@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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



