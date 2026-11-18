Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795049016;
	b=1vCy/vaNGF5JYOzvVbGqTbC2qUxWzLjqg7odsBzm7jJQOipWjXPcGkKeKf/I2H+4M/jN
	 2eLmRa3tlBvrS0+ID7asxxTjYE/vm4LnPZcu8wZ9P7UpFRw+jksaAEodf5+v9g3lbd8yh
	 HlVDcNZBEynuSW6Z8J7dUuhqYe14BmhrGGWuCewrih9A2Imj9oddtHnD5BiXcHjDS9boq
	 VpKgHy8NnUTpjn2lwnt7U+GqtxqUsysTxeS0jYEJmoGTJkCQGZOYMUfllsmH6PrdY/Fc0
	 C+Ik/BClC9xXxLljXnFHKf6sncKq2F3IKlvWzdkwEtKGbduK/S+9KOltfCn5Zo0qYfQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795049016;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Zc/xBFw5HJQBapFcYJAbTFZ0cuTbHDZtc4kZSm0bTew=;
	b=5Jeud5A1+1POTjJHtbJ5Q6M4J7hF5G1gbTZDmE3utL+U3dw/+iDxglm6a+nPfK/FvdAW
	 hfhc6ZuTgIk3ud3314GRgDmd/SNIaNPdc3GPQ+eIm35kYm7yMLbElMhJcTglg955J7cPo
	 cLwBWWl1+0UNDlX+cLLLN67oQTU54yY/rQtZ5tYIWv3I0BouPTWN6HsoOpKcTWl7Yw1PP
	 ooqXpeKXsn9I5Hv6jBYHmndJEFfjcdkrqGGvD6xUwiUheGPWfqa0LlhCD8A6UwDQdAZsk
	 MpL6DkDfrytGE6hkAvU3aCxHscCzX+P3IhcgRtRsedJtYBnlEfYQVlRVqp2UV+oggvw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BoE9naXa;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0E0B606A320;
	Thu, 19 Nov 2026 00:43:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BoE9naXa
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 095D71F000C5;
	Thu, 19 Nov 2026 00:43:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795049016;
	bh=Zc/xBFw5HJQBapFcYJAbTFZ0cuTbHDZtc4kZSm0bTew=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BoE9naXaDKPcG8tZolSRNTvARMhbY5uVeEwGAg488Ps8J08tN+WyXhvCSNzYvIX/W
	 Kw6IcL8t1HbmiqONEKfzs9Sd1imSZF+S0O73wfFjBSAGxaj5AV7K8OgnTd7CEOcCvx
	 UOQszzRVhPG3pK8rFyvzGrZlH7xuH4r0HDVCvL4g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jernej Skrabec <jernej.skrabec@gmail.com>,
	"Rob Herring (Arm)" <robh@kernel.org>,
	Chen-Yu Tsai <wens@kernel.org>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2202/2857] dt-bindings: media: sun4i-a10-video-engine: Fix IOMMU count for H6
Date: Wed, 18 Nov 2026 15:53:56 +0100
Message-ID: <20261118150320.715526248@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chen-Yu Tsai <wens@kernel.org>

[ Upstream commit ca9a67831805dc788407a05f276abb6b86b1174d ]

On the H6 SoC, the Video Engine has two memory ports, thus two IOMMU
connections. The secondary one that is missing is likely used for
reading reference frames. The newer H616 is the same. On the other
hand, the D1 only has one memory port.

Add the missing IOMMU connection for the Video Engine.

Fixes: 62a8ccf3a248 ("arm64: dts: allwinner: h6: Fix Cedrus IOMMU usage")
Reviewed-by: Jernej Skrabec <jernej.skrabec@gmail.com>
Acked-by: Rob Herring (Arm) <robh@kernel.org>
Signed-off-by: Chen-Yu Tsai <wens@kernel.org>
Signed-off-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../allwinner,sun4i-a10-video-engine.yaml     | 21 ++++++++++++++++++-
 1 file changed, 20 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/media/allwinner,sun4i-a10-video-engine.yaml b/Documentation/devicetree/bindings/media/allwinner,sun4i-a10-video-engine.yaml
index 01f2afa023f04..932043d7f0cc4 100644
--- a/Documentation/devicetree/bindings/media/allwinner,sun4i-a10-video-engine.yaml
+++ b/Documentation/devicetree/bindings/media/allwinner,sun4i-a10-video-engine.yaml
@@ -55,7 +55,10 @@ properties:
     description: Phandle to the device SRAM
 
   iommus:
-    maxItems: 1
+    minItems: 1
+    items:
+      - description: VE port on IOMMU
+      - description: VE_R port on IOMMU
 
   memory-region:
     maxItems: 1
@@ -82,6 +85,22 @@ required:
   - resets
   - allwinner,sram
 
+allOf:
+  - if:
+      properties:
+        compatible:
+          contains:
+            enum:
+              - allwinner,sun50i-h6-video-engine
+    then:
+      properties:
+        iommus:
+          minItems: 2
+    else:
+      properties:
+        iommus:
+          maxItems: 1
+
 additionalProperties: false
 
 examples:
-- 
2.53.0



