Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055701;
	b=XjqmWnQQ5azTrpIBxrgmp2vGMpyoUST33GGZV0kFa1AW0oFQfsAWnC54S/ulKfemUtwQ
	 qiuK7gHfdSJOgWPLNN1YVGEUzCgXeK1iBRZFeWDsoCpfIfhRPAxqJmVnxQ8H/y6O7/Jin
	 1ubxNJVNQr4k+W0+RuVO+jYgtEikBxJBKsxz2ycve0vVZs5N3Ryl0oJbw7u1GCpxE6YW8
	 sPbskH7Xz++Ngjp1NbQzbMQpiNIkxwP58OfaLmVEm/KIU9AH3KC69VNVzQP7X6tEVZXel
	 EGqSFdDcQ1DFqj8ncg0iXl8mMnEZzawH2BNo4bKBxaDTo0dJeGbq8jjidyVisIKLqJA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055701;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=uZUxcvFTLu0MZKqyDqkDNwXKMdu3/9foKt6do0N5UU0=;
	b=LVjuGovLmKOMXbexKJ3G2IPj73eXgKG4scOcrX7tIDXBJJVaFpnxzD1/5IWduigeSrBQ
	 h2iNrUUeYAX5CBnqF9BpT964Jt7KU1dLYRJKLMNObhaGd65xhKUyaVo6/B2BUDGUPuHfj
	 WNm1lIUV1RHHQtdXfciTAcEImCU4BVoo1H/mt5KoQA+cY0JiMTSeYQ813gaq5i86uZO+V
	 liflhzY4lxvYu/atnJmgVlZkoBJj7gCQZjD6ah8kN9ne6dSStpZcpa8IOTUepvdBON3az
	 eLzIyhgHOhEVjCZWAjqJllxo5eEQDllo9VXQKYIMFIdY9x1iKko7oH+I0PYu9Hj/gyA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="z53/ioC3";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6C30606A335;
	Thu, 19 Nov 2026 02:35:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=z53/ioC3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D96A1F000C4;
	Thu, 19 Nov 2026 02:34:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055700;
	bh=uZUxcvFTLu0MZKqyDqkDNwXKMdu3/9foKt6do0N5UU0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=z53/ioC3GbHBW12wsLkTZljGnccKADTO407SLz7aybBZ1qM/YEQISIaCojd+mtPMs
	 m2Pn3pKuYTACAY8tz89DIvjeKuvNF43ZsSw6PFDG56XiM5ao+UgRG/SA9jWB/5sBxw
	 4kNKeMFeudHueNlGUHlqrfGbCFoQtbJyLlkDteyg=
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
Subject: [PATCH 5.15 1723/2214] dt-bindings: media: sun4i-a10-video-engine: Fix IOMMU count for H6
Date: Wed, 18 Nov 2026 15:56:39 +0100
Message-ID: <20261118150120.643066789@linuxfoundation.org>
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
index aed63743c6c69..f4e6c4a15012d 100644
--- a/Documentation/devicetree/bindings/media/allwinner,sun4i-a10-video-engine.yaml
+++ b/Documentation/devicetree/bindings/media/allwinner,sun4i-a10-video-engine.yaml
@@ -50,7 +50,10 @@ properties:
     description: Phandle to the device SRAM
 
   iommus:
-    maxItems: 1
+    minItems: 1
+    items:
+      - description: VE port on IOMMU
+      - description: VE_R port on IOMMU
 
   memory-region:
     maxItems: 1
@@ -77,6 +80,22 @@ required:
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



