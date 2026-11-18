Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055706;
	b=IDGQEPzRM4k3d9WFzo4tnHOeoIF82emMxb8FxZM9f1sRvL1JQNZ29SXXcTJMnRcPokaR
	 MaeFivN3JpQomaiXAJLZ/iJfIc1ya1fzg+zae8asZwCOnQVpkFMbPLMT7FD02i8xTAKw5
	 wAL5UOl8g2lGYJuOztnXk+rYc+RieUx2ECVcnZRMGqfmLurah27pv23F/5QDGlKOJAEjo
	 hpil7EkTft3y1BIOJyAr0c5yqeObhY1u1gm1XhylHQHjDhJ+ibeCpclbUExY/lypKfn9z
	 cw7FE5gw2Xgtf0cVhG0+uQu3r/Y0vilxK4VNxAhtiUlhy8xF5DAi7xncaUep8ajlFoA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055706;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=MD5nbL5dXPJvp16Wp/sq6wBn08jbF2K1Qj+X49YNNDs=;
	b=e25VOvci777mjMj5e49009uHaCM5vGwQ8XsB9vn3FjHMS3AZdsgKpdXf2emZPMMqgu/I
	 Pyf9EAq7gxWjA6faO+9kNi3yJfwUM50UJJ+OKt0a+YaQ1ww5xPVqxfFU8tRtyZBXMkVRf
	 5mrmzeWpiYzQT1Ri+JkSwISlGtNLDofIQBv/sxeCv41OFwJYqea5fzLo4H+HyIIRjwzNa
	 V6GQoMwz3ysYEckg8OjyI6PAWOIKSlxknrMTWrOt0FH3h7a+wGvztzmXcxd4bcg5rv/4D
	 GLhdYOuDQWx6bkN1yU14FOsZWzOiNFIjRKtKxKV0Qg6htwIW41JWl+KMPhI0psoMElQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=njj8ubTU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CE0A606A31C;
	Thu, 19 Nov 2026 02:35:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=njj8ubTU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6F621F000C4;
	Thu, 19 Nov 2026 02:35:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055706;
	bh=MD5nbL5dXPJvp16Wp/sq6wBn08jbF2K1Qj+X49YNNDs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=njj8ubTUsKil87WDNTQRITvR6Qc9Vd8Q9LkLTcK/IN9eECFzJRXKfF/ZEe6t/NqKW
	 I30McP4HKOll6RXHYKFSE1tOTnMMN9+qSBzorDu8lBy0h0bc7WB6OudCgGgCiYoKaS
	 SfOqXzwM0uB9zTm6bEnsSgj80e+mLpY8cl1/KTpo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Icenowy Zheng <uwu@icenowy.me>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Jernej Skrabec <jernej.skrabec@gmail.com>,
	Andre Przywara <andre.przywara@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1685/2214] dt-bindings: vendor-prefixes: add Source Parts and Lctech names
Date: Wed, 18 Nov 2026 15:56:01 +0100
Message-ID: <20261118150119.239919997@linuxfoundation.org>
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
index afe41204f4a56..42e6bb3df8d8e 100644
--- a/Documentation/devicetree/bindings/vendor-prefixes.yaml
+++ b/Documentation/devicetree/bindings/vendor-prefixes.yaml
@@ -649,6 +649,8 @@ patternProperties:
     description: Lantiq Semiconductor
   "^lattice,.*":
     description: Lattice Semiconductor
+  "^lctech,.*":
+    description: Shenzen LC Technology Co., Ltd.
   "^leadtek,.*":
     description: Shenzhen Leadtek Technology Co., Ltd.
   "^leeco,.*":
@@ -1132,6 +1134,8 @@ patternProperties:
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



