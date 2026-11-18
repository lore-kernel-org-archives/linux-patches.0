Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018449;
	b=KnQ9BmdQf/Lc0klhZbooUY+mQWlIewj/U/v5hdCtpQRIVgoDSOjCphWTQPa0raRHezko
	 ztdb44YjE3d9Bq+ceYGGq95EMxO5btT3r7C7pB6hzEIGYpMfl5WOk1wz5TZFd7mYI7R3g
	 8YJ9QQcyQaqlMyZ/5XF8gkJxbHeDDpwW2TRmtS7oEiLDkwwLae9JeRVohanQBSMZDbM86
	 CZNwvgENDQkfTWY6iDLPNwubWHw+KUWYY+cQJjCK4z36nUybqRdnshgaPeEbpUlwnHKZH
	 WXKi4Ms4ayGNhuv96rkFN8elcczq/6kyAHfT4OjwQLmNQXF0stzqi41FUjDDgK4qRhg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018449;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=kO/zWNORkbwYizlVyArLOWdgaYAmVfznuqxUck0DrRA=;
	b=XSCC90ENI6SlkZImK+KFdg/6kTsxGo2tqsOqA+0QsyEpuN6AlcFzZ1RDBRdzE4jQXtQy
	 zhl2QWmyQWbRnd9JarYAXcsCFPCMm6aJTQUpSQxpastaPhrbw/C5rgyzRMNwhYruSf0ON
	 WBVax2Dp4bXgo1o0cp1aCkzdZu0mVr7OzTmWW9irLfeCy4WhgNIlyKRu3RscGTtmM+79I
	 Sw+1lBI1V3yKeGD74ILbmk270F1rj9fL3BpH+VNeJ6H91PYovAiTVDUVESmxAy4rOByYA
	 v5iv7AqHzTTlYugEYu+Of2qK2Zgaij4wG7BwxUXkQJjJCWxCnmQ4U82anQ0VUNdQRZA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=V1BQMsMj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F3C1606A320;
	Wed, 18 Nov 2026 16:14:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=V1BQMsMj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A6781F000C4;
	Wed, 18 Nov 2026 16:14:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018449;
	bh=kO/zWNORkbwYizlVyArLOWdgaYAmVfznuqxUck0DrRA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=V1BQMsMjDa4pAsBdCv54rRqtDKcBQ666iZC7TBf3hAeNNHUQvM/F0B0sjcZ3BnX6i
	 Dkmmzh+HvO0Tv2HDigb+x3kj9EtLytbJ82I9xAidBJFACQ//IMVsE5Ob/KxYMdDKB+
	 xeZXUEn9nvjGv6s01rc1AjqnnLdf/dNj6Evjoy1M=
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
Subject: [PATCH 7.3 1244/2651] dt-bindings: media: sun4i-a10-video-engine: Fix IOMMU count for H6
Date: Wed, 18 Nov 2026 15:41:24 +0100
Message-ID: <20261118150332.775792801@linuxfoundation.org>
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



