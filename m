Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048874;
	b=zoPSnoDUgeSw1C2vBuGtft7vzTajvmLZxOHWvNBnvlHODc3XcMo5PbXnVYFRDO7sCGKY
	 Ks67ck7/Y8z+PstqMCcZIE6vPByv6Q1yZpQNknLEMQy1frZgQTDOZLYxqBRuvVGrmL2DS
	 pDIjaQeAtUUEhkN1bg9IWfBS2xNk7ZS+pgpfil3hfjQffR9y6qf6K9bCe5y5YkOV4aQhY
	 qPGaHwDtsNju5DzLeEO+TFVOYIOGVa5eQXoviDsU+mN/cQOXXy8h/TsH/KrAoP9KlJT89
	 ZAAUFgHRQSUWiKKUWVDeKhyqOgKrS50kWYgLVBlQqkXI5GbzclMYWIUCUVFimXpE8+g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048874;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Ewrvrn5zDbAllt0RR8dfHYARgvLiur6emsYKwwZc8Qw=;
	b=3nntNoXP8Wf63sDQxa4vfsCNmZvISSr0r7jbo1LTPylXX6JEUiXaGvYTJyQSEXoLGE61
	 TtLeMdiS3R07FOgy2ca3m7JAH/wQtxX034X+sRqCJnNHjMLgX7IwTaWk1jU7ewqUfwUkX
	 hFZQlxDiFCxMRXC9kuO9Ontj+TUlSDJFz/0aGN1sm7xr6cki5RO22SybmnxtLw1/Hl5mT
	 er2rKG+/8wQR14Doq1e9ALmMsjbM4OegFu9h2ojEgzVYZ1pa4L8NHkqi9hkc26o2aOzf5
	 aNdOhPLD93n/2ULWjXhImW/9szncFrsrWYpyKYhGhbvzDXYIDYhEUpIo8Kyi/Iym+Zg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WBrrSweg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C03C606A31C;
	Thu, 19 Nov 2026 00:41:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WBrrSweg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB70A1F000C4;
	Thu, 19 Nov 2026 00:41:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048874;
	bh=Ewrvrn5zDbAllt0RR8dfHYARgvLiur6emsYKwwZc8Qw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WBrrSweg5ICtc0GpAnrQZbD4BdI00qcHvBAdX9sTHDbOnxoW50erBR3A5cGoLMe22
	 TaBGP6xWNpoCPzZGmvjjD5AP6JBUP904ZFBrHNYJVI6YUPCmNTyaYFQSfVMeEvSDd6
	 /rzFGHmFQ0xQPjs26pCbqy0WPaJVDSp377XMvzeA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Icenowy Zheng <uwu@icenowy.me>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Jernej Skrabec <jernej.skrabec@gmail.com>,
	Andre Przywara <andre.przywara@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2149/2857] dt-bindings: vendor-prefixes: add Source Parts and Lctech names
Date: Wed, 18 Nov 2026 15:53:03 +0100
Message-ID: <20261118150318.772194446@linuxfoundation.org>
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
index b07d3671865d6..3746f6e01aa75 100644
--- a/Documentation/devicetree/bindings/vendor-prefixes.yaml
+++ b/Documentation/devicetree/bindings/vendor-prefixes.yaml
@@ -721,6 +721,8 @@ patternProperties:
     description: Lantiq Semiconductor
   "^lattice,.*":
     description: Lattice Semiconductor
+  "^lctech,.*":
+    description: Shenzen LC Technology Co., Ltd.
   "^leadtek,.*":
     description: Shenzhen Leadtek Technology Co., Ltd.
   "^leeco,.*":
@@ -1245,6 +1247,8 @@ patternProperties:
     description: Solomon Systech Limited
   "^sony,.*":
     description: Sony Corporation
+  "^sourceparts,.*":
+    description: Source Parts Inc.
   "^spansion,.*":
     description: Spansion Inc.
   "^sparkfun,.*":
-- 
2.53.0



