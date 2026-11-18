Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055709;
	b=3RYShel6pnZKC1C4pSLWM6xmhiHEGfyoWC3pi7M36cO9jcy0j8yqbSD+tnkHBv3HgGlb
	 QePUfjxnq1XhsjnVw5l9SgDAvNp+SwA9ZoRpGdUJF/gu1fDMVHJLfppbcSCbLbCokmzJQ
	 AYv6H8D4bYFKe9y6vVdsDQBqtcLEgpt0Yh6Dn5WeNIlb0R1dFBl8x57OlqJyKjTb1TN01
	 PTgiNzK9PTQJEYsa3h8qLow/SSNWBBl0H7Z3s7s05eg+Dcw0D0tFHafxBO1maDmBtzIcu
	 HQru8j8To6ckXFmtIzZ0o7xGOvQ/hmjOPvpHM+ECwe8VmOh7TgE9TifZCYchnZmH0Ow==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055709;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=XTONmO+r7YBjS+CxrQBLPVroBhnPSUAkcPV+5m14Z8o=;
	b=jew/dxucovwBQcrThkixAixMts24+jhcYjVJc4dq3LwuBe1q4hjCVnKg18SLUGNlz5Sh
	 7+jfcyK3wscRoFfVjMi1K5SB77T40rrWHYqY4bHXJHe5lsoZXGXdcpaaQyUwoqhT/94xI
	 IYP/98OSrXNMbfOx0oSZ07rHKw+Jghdqm0tQ/EqU6aSaIF2TKx7O40sp2K8km/TwA3jG7
	 2rw7sBJO8yA844blguNCVOHhNPBWKgqUKLqPOh0IyREOL/GZfaYkWWG9EhVkw4BXUjCNS
	 Dn1EyGlnmVTiQgMfkMb00aMIQxExNQmjPWtYF0+iF8Ke05sVuL9+MILBAgdOAjuSfjA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=U39KpLOI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F536606A31C;
	Thu, 19 Nov 2026 02:35:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=U39KpLOI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FE811F000C4;
	Thu, 19 Nov 2026 02:35:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055709;
	bh=XTONmO+r7YBjS+CxrQBLPVroBhnPSUAkcPV+5m14Z8o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=U39KpLOIbLYz+tHKvxUbS5k/roDVI2eJMS4nH/jKbjdm4mu9RADq8KSyBFhg0ozZr
	 bAPSVBmGs4BBUzkMT4gW2q5ufgyfWGuikL2TYuu8A+xJSZoiPk79P4q6UGhY8l7eb3
	 z7i3myAGcvLg0JrdiMJxgwcV4QckBzVebTG2CIv8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guo Ren <guoren@kernel.org>,
	Conor Dooley <conor.dooley@microchip.com>,
	Chao Wei <chao.wei@sophgo.com>,
	Chen Wang <unicorn_wang@outlook.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1686/2214] dt-bindings: vendor-prefixes: add milkv/sophgo
Date: Wed, 18 Nov 2026 15:56:02 +0100
Message-ID: <20261118150119.274377519@linuxfoundation.org>
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

From: Chen Wang <unicorn_wang@outlook.com>

[ Upstream commit 07f9b764062904f0c0fd6e54e58535f34ac3ac6f ]

Add new vendor strings to dt bindings.
These new vendor strings are used by
- SOPHGO's SG2042 SoC [1]
- Milk-V Pioneer board [2], which uses SG2042 chip.

Link: https://en.sophgo.com/product/introduce/sg2042.html [1]
Link: https://milkv.io/pioneer [2]

Reviewed-by: Guo Ren <guoren@kernel.org>
Reviewed-by: Conor Dooley <conor.dooley@microchip.com>
Acked-by: Chao Wei <chao.wei@sophgo.com>
Signed-off-by: Chen Wang <unicorn_wang@outlook.com>
Signed-off-by: Conor Dooley <conor.dooley@microchip.com>
Stable-dep-of: 538f8ec6b9c7 ("dt-bindings: vendor-prefixes: Add Sophos")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/devicetree/bindings/vendor-prefixes.yaml | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/Documentation/devicetree/bindings/vendor-prefixes.yaml b/Documentation/devicetree/bindings/vendor-prefixes.yaml
index 42e6bb3df8d8e..22f0da9bb3bda 100644
--- a/Documentation/devicetree/bindings/vendor-prefixes.yaml
+++ b/Documentation/devicetree/bindings/vendor-prefixes.yaml
@@ -763,6 +763,8 @@ patternProperties:
     description: MikroElektronika d.o.o.
   "^mikrotik,.*":
     description: MikroTik
+  "^milkv,.*":
+    description: MilkV Technology Co., Ltd
   "^miniand,.*":
     description: Miniand Tech
   "^minix,.*":
@@ -1134,6 +1136,8 @@ patternProperties:
     description: Solomon Systech Limited
   "^sony,.*":
     description: Sony Corporation
+  "^sophgo,.*":
+    description: Sophgo Technology Inc.
   "^sourceparts,.*":
     description: Source Parts Inc.
   "^spansion,.*":
-- 
2.53.0



