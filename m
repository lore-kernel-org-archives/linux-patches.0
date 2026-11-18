Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061153;
	b=04GVnh358uTHtSbOtZ7Gzm53c9n7R1CKw63j4V4jD33ZF6eggUpZIwidyZ9i6PQRyUs/
	 DwM4cgimLA0eM9dDZdVKjwYs+8G7Aj1MJE+YDHUi8mzwcxDaxB6QJXHWly+vjk6plImDY
	 qoDPzg958EWq7z9BiE7D7qby+NuSv2VMUQ3oJ2Q24kWrfLLxpBQZTvYECx/fiZmJM6QdU
	 6Tv8hEtjruZEe0KgskWIEiOlOa59twnIW0ifnlP3fbSnApBEUjCBlRmoiFdUM14jRyhJJ
	 orUCUzyp7W2zvdxmxcGiiGH+EJCjHXEaZZJHoPwOZnA7lrVsAWaMTNKPSDXNqHKQtOw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061153;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=by+T7ye6QHnHEl9ggw9DhpKMepxTErejpaU9LSC333g=;
	b=ZylR4Vgld8VowWoRq82JUoowz7fLF3zVgrcWP6RX/MApTqMp0TcIrk6eQiLlDUw3gYyR
	 xxCvxEaa2UQaPs5Rio10+xHNv0i5iQrKND5ECFFvpyeAXhmgomVcrN6KNv8qZrDtI9cBx
	 rW6ZOCvEozA89d++O6nskBUNMSldIojni8L9VmhQlBBxMBpIYRIA4+1fP2H2LrrfPzrgj
	 Do/FDgRXASKcIMO4kPvnf4Fdoj1CIWt9y3I+FiODAIWBBxP40xbXTt540ijWy/C9cqNJq
	 BdjSBqL7mAucXMFNLAMWj0shhnsZ6VcGvcSlVm+pLBtp/9O/aV2WKtfMIYvNVRxs7cQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="k0IGNjU/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D61B7606A326;
	Thu, 19 Nov 2026 04:05:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=k0IGNjU/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 391AB1F000C4;
	Thu, 19 Nov 2026 04:05:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061153;
	bh=by+T7ye6QHnHEl9ggw9DhpKMepxTErejpaU9LSC333g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=k0IGNjU/YwkApenqqp+Wn5T5PS5JEgbjkZNd886hPDJM8KfCx25ylxPX2KeKGWoAD
	 1xZ+FluNAXlbPDmugxW5pJpI1Qg97B+493A0kzlP+U6nYBte9HSSPshareQSH2ArwU
	 T/0PdglfUpCB8szOyrrnkBPiXkc2kJ758Y4K1+as=
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
Subject: [PATCH 5.10 1450/1848] dt-bindings: media: sun4i-a10-video-engine: Fix IOMMU count for H6
Date: Wed, 18 Nov 2026 15:58:08 +0100
Message-ID: <20261118150020.127184001@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 4cc1a670c9860..74db54fc6a3ae 100644
--- a/Documentation/devicetree/bindings/media/allwinner,sun4i-a10-video-engine.yaml
+++ b/Documentation/devicetree/bindings/media/allwinner,sun4i-a10-video-engine.yaml
@@ -48,7 +48,10 @@ properties:
     description: Phandle to the device SRAM
 
   iommus:
-    maxItems: 1
+    minItems: 1
+    items:
+      - description: VE port on IOMMU
+      - description: VE_R port on IOMMU
 
   memory-region:
     description:
@@ -64,6 +67,22 @@ required:
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



