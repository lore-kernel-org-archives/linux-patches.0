Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 282FF197A75;
	Thu,  6 Jun 2024 14:13:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683237; cv=none; b=bx4OWDUB5VAN6bRnXW2dxNhkEnTPxTZ2thDUGKXRd9tr0eHcBIzp6TB+w3LWbEfRKQpwLEn1y47ZteNW3yDfIe9BVu8C4+0wrsA5unuOe23Uz9I1jzQFA+uEBTgXb3vKOV0DhIhFcFF3EUtsMoqoQVtgoGueOufuDj47HFNJYR0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683237; c=relaxed/simple;
	bh=1XSlR8qSHvwVbpEHzsVDkcpsYlupBYFAuO8Nrt0691k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HCsP0HSo7j7dDbeHj5znWUBpRvTH6cmLBK5aPQNQrwAKAbOhHm8hfPsu+xJx5y1+lrt6nvDTvKWU4amEXekN7SN/YYorzDpc1blaVoRO6Ys7EcJiEnWDDNrOI6LcUgz3L4c79vUE4c4eJQRHvark6gO0VWFTYIxTV8cnCLFc0E4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0kkZv/Fy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0kkZv/Fy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1AE3C32781;
	Thu,  6 Jun 2024 14:13:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683237;
	bh=1XSlR8qSHvwVbpEHzsVDkcpsYlupBYFAuO8Nrt0691k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0kkZv/Fy8iwcgjyXVWx7DoBwA4r9RwR7VIbG7vhOuQG8wQDyNTp6MiJJDPq7Tgs2T
	 vBuZewPCkDi+e0RnRcIRbGRM5N/RTGZsEtrKNFCVU0aYYDWnStkd2Y3kOmLS6ZYucb
	 zLXH+L4FFuhOTYHSI668nrAguZ3Vb8ANjDMjEpaA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yinbo Zhu <zhuyinbo@loongson.cn>,
	Binbin Zhou <zhoubinbin@loongson.cn>,
	Conor Dooley <conor.dooley@microchip.com>,
	Daniel Lezcano <daniel.lezcano@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 182/744] dt-bindings: thermal: loongson,ls2k-thermal: Fix binding check issues
Date: Thu,  6 Jun 2024 15:57:34 +0200
Message-ID: <20240606131738.269042332@linuxfoundation.org>
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

[ Upstream commit 88071e31e994ee23356674e0c5461b25e2a95cdc ]

Add the missing 'thermal-sensor-cells' property which is required for
every thermal sensor as it's used when using phandles.
And add the thermal-sensor.yaml reference.

In fact, it was a careless mistake when submitting the driver that
caused it to not work properly. So the fix is necessary, although it
will result in the ABI break.

Fixes: 72684d99a854 ("thermal: dt-bindings: add loongson-2 thermal")
Cc: Yinbo Zhu <zhuyinbo@loongson.cn>
Signed-off-by: Binbin Zhou <zhoubinbin@loongson.cn>
Reviewed-by: Conor Dooley <conor.dooley@microchip.com>
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Link: https://lore.kernel.org/r/6d69362632271ab0af9a5fbfa3bc46a0894f1d54.1700817227.git.zhoubinbin@loongson.cn
Stable-dep-of: c8c435368577 ("dt-bindings: thermal: loongson,ls2k-thermal: Fix incorrect compatible definition")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../bindings/thermal/loongson,ls2k-thermal.yaml        | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/thermal/loongson,ls2k-thermal.yaml b/Documentation/devicetree/bindings/thermal/loongson,ls2k-thermal.yaml
index 7538469997f9e..b634f57cd011d 100644
--- a/Documentation/devicetree/bindings/thermal/loongson,ls2k-thermal.yaml
+++ b/Documentation/devicetree/bindings/thermal/loongson,ls2k-thermal.yaml
@@ -10,6 +10,9 @@ maintainers:
   - zhanghongchen <zhanghongchen@loongson.cn>
   - Yinbo Zhu <zhuyinbo@loongson.cn>
 
+allOf:
+  - $ref: /schemas/thermal/thermal-sensor.yaml#
+
 properties:
   compatible:
     oneOf:
@@ -26,12 +29,16 @@ properties:
   interrupts:
     maxItems: 1
 
+  '#thermal-sensor-cells':
+    const: 1
+
 required:
   - compatible
   - reg
   - interrupts
+  - '#thermal-sensor-cells'
 
-additionalProperties: false
+unevaluatedProperties: false
 
 examples:
   - |
@@ -41,4 +48,5 @@ examples:
         reg = <0x1fe01500 0x30>;
         interrupt-parent = <&liointc0>;
         interrupts = <7 IRQ_TYPE_LEVEL_LOW>;
+        #thermal-sensor-cells = <1>;
     };
-- 
2.43.0



