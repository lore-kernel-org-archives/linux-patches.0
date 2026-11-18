Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061058;
	b=HubaT0mGeW7tarKv/9tFIqOSjq7hfErRQerQDxSX6rY2iBnmyGGtmECtvsYY3OhIl4u7
	 PKPsjNqYxFuRsG68UWyLuzZn0r1PnHYxNVHrLwAl98d4ZvjpKu/QuJnm6AJN6sARhRtka
	 DuWoNEFQTWbWpCIQvJbI2K2/oY5g0ZJeIO8tkalT/HY25HvtaA9vvhHJKmC4GuyJleqIi
	 WSO7TzuZsCYMrQpE9VzA+PUh58nZJGbH0XB+gY3IMEU4fxppuiIHjNE4FW640KNI54+Jw
	 KnG50sYoZvLu2Jz14LaifPfmd3zjYjZyRDT956oaepYvm3W5dn0Mz5q1TWXcSDYhXWw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061058;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=lwSh29mFbKgvdBvcUzTyfpAlJgrUgSMBrFF7XgLvroY=;
	b=R+U0JqXNd2XDDyMNUCYaxVE3aRRHRhUBASNGRz8AW/XqHni+Vlz/Ug3u3chXYgj9TkO8
	 8TFArWII90nV5RAfZ8+dXj9EVQIpxtS0kjOHLP/K9EvsIN+qsyG57tFE5bz2Y9PG3Dg36
	 9/dGU9H2sC2cGw5pMkY7YYnAug1Hdb1n+6Y/UI6BmZ1BD+Q8P/GYXAajyXMOTcUUMV5JD
	 Lx3VsW0BdklrQPCKyhZF0RuWWvss/T2/w7SYl/te1YMF69muevPHERdftiwXFWQPRmCpv
	 WidipGUmiPttb2Uskn73HwbHaaHq8R2s7W8f5d9cPohNwawKF0XaOFV+6LxZ6eshwAQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GXvnTBSq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26DB6606A326;
	Thu, 19 Nov 2026 04:04:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GXvnTBSq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FDE71F000C5;
	Thu, 19 Nov 2026 04:04:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061058;
	bh=lwSh29mFbKgvdBvcUzTyfpAlJgrUgSMBrFF7XgLvroY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GXvnTBSqm9+OvxiCkogkViZ10Wo9wtFLCyoU97aH1ljAHygfg1H+mDtCoeV2LR2Nl
	 J8AX5ZWwzs9FvehR1gus1g4tBZQ7omhnu/WClYza7pTmADdETN2RHFcxyUUN1mQF5K
	 eOX26+ePj3E3QGVHbkF6KVfSGph8y4lKAy6aox4w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Icenowy Zheng <uwu@icenowy.me>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Jernej Skrabec <jernej.skrabec@gmail.com>,
	Andre Przywara <andre.przywara@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1416/1848] dt-bindings: vendor-prefixes: add Source Parts and Lctech names
Date: Wed, 18 Nov 2026 15:57:34 +0100
Message-ID: <20261118150018.765339805@linuxfoundation.org>
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

From: Icenowy Zheng <uwu@icenowy.me>

[ Upstream commit eef696356f58a4f5c17ec5d7cb1d495f75edf62e ]

Source Parts Inc. [1] is a company that makes a series of SBCs, SoMs,
etc under a brand called Popcorn Computer [2].
Shenzen LC Technology [3] makes various boards and related products
around IoT and AI technology. They used the "Cherry Pi" brand name before.

Add both companies' names to the vendor prefixes list.

[1] https://source.parts/
[2] https://popcorncomputer.com/
[3] http://www.chinalctech.com

Signed-off-by: Icenowy Zheng <uwu@icenowy.me>
Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Acked-by: Jernej Skrabec <jernej.skrabec@gmail.com>
Signed-off-by: Andre Przywara <andre.przywara@arm.com>
Link: https://lore.kernel.org/r/20230319212936.26649-4-andre.przywara@arm.com
Signed-off-by: Jernej Skrabec <jernej.skrabec@gmail.com>
Stable-dep-of: 538f8ec6b9c7 ("dt-bindings: vendor-prefixes: Add Sophos")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/devicetree/bindings/vendor-prefixes.yaml | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/Documentation/devicetree/bindings/vendor-prefixes.yaml b/Documentation/devicetree/bindings/vendor-prefixes.yaml
index 79bd9ede837fc..a29d31cf7d078 100644
--- a/Documentation/devicetree/bindings/vendor-prefixes.yaml
+++ b/Documentation/devicetree/bindings/vendor-prefixes.yaml
@@ -599,6 +599,8 @@ patternProperties:
     description: Lantiq Semiconductor
   "^lattice,.*":
     description: Lattice Semiconductor
+  "^lctech,.*":
+    description: Shenzen LC Technology Co., Ltd.
   "^leadtek,.*":
     description: Shenzhen Leadtek Technology Co., Ltd.
   "^leeco,.*":
@@ -1050,6 +1052,8 @@ patternProperties:
     description: Solomon Systech Limited
   "^sony,.*":
     description: Sony Corporation
+  "^sourceparts,.*":
+    description: Source Parts Inc.
   "^spansion,.*":
     description: Spansion Inc.
   "^sprd,.*":
-- 
2.53.0



