Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795040499;
	b=uYG4rhX0uSHVl736PwlKTjy89xb6JQDi/AFlCLBueM2o2Ty92Bf4dhgSSFmXC3jdYXig
	 U3qDHMW6WKvgInjyntDWIU1lCF0WvkAjV1JBUgb2jOf1GSeD05X5P0QYEpJppr3EmkyHW
	 /TpQVje6IvT4ijpQ1+X5GLKtKqUV6gA2NTFNIUoy6D0yviE5g9dQBDKFts9F0+G0VNFM4
	 r+E3HtAOkzF3R5GFSYq4C69jFqbA0+nSk4R9DEUoWQ/obvaWC2OsnvKVTDlyRbGO4biG7
	 vSofI2gQI1r1jUgLVGOVFeAVy1PxI01zAudOhP1zTbOEqU4pHWiztOqbqYvruB3urIQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795040499;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zl6OZnw8AZtdYQRB9XscGloJQg1Y4cKvz0lBE+0lSh0=;
	b=ALbPztnUMb3D8Xu0MobPAzwsNlEMuALOr3eM7iyuX0wycXLHrGdIDqXW1q9Cudy7j0E0
	 l4AmXjpNI1gxA3+Q8MWanrMg+EJHGsIoXzJB5P5bQT1tqV1sYCoSDSmm9CwWGroVqRdL8
	 eBa5/APOWt6G6kZ9Q7kJR/+EZF6fBzGUgbnE4ZuHx0H9nQqkJTc+I/ySV2HZkWzbTZZ7J
	 YzUYBLiX2fljKnBe8QFhDlpJ/ZNlXrkkJOstFAU+Sn/0HRR3fQeQ0bxhpxRcbhakTLgFS
	 8giNRqpPkioidGaNYbHSu4SbrMYJyItEwn6eVnsf1xOcQrQK22jNN0h2nJt81BMAP2Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uDx7bTKx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B018606A31C;
	Wed, 18 Nov 2026 22:21:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uDx7bTKx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 001101F000C4;
	Wed, 18 Nov 2026 22:21:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795040499;
	bh=zl6OZnw8AZtdYQRB9XscGloJQg1Y4cKvz0lBE+0lSh0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uDx7bTKxkdLI239U6XRMn6jSzeWFAMqbB5GQ8mSXnPGKEHnik55yrTYWMUWhMrEDL
	 LwWzaCc/Eb7c9c49TXdyd7OTeFd/A6CNwxLW+c4x2mUEiw1Y3quXWjO/VMtRecv69P
	 GGxabyZFxp2oie5p80iZn24ngxpt3s5Ro0uDH1rA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guo Ren <guoren@kernel.org>,
	Conor Dooley <conor.dooley@microchip.com>,
	Chao Wei <chao.wei@sophgo.com>,
	Chen Wang <unicorn_wang@outlook.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2478/3318] dt-bindings: vendor-prefixes: add milkv/sophgo
Date: Wed, 18 Nov 2026 15:51:40 +0100
Message-ID: <20261118150435.741099412@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 7877494c9c4df..4ae5becd175e8 100644
--- a/Documentation/devicetree/bindings/vendor-prefixes.yaml
+++ b/Documentation/devicetree/bindings/vendor-prefixes.yaml
@@ -889,6 +889,8 @@ patternProperties:
     description: MikroElektronika d.o.o.
   "^mikrotik,.*":
     description: MikroTik
+  "^milkv,.*":
+    description: MilkV Technology Co., Ltd
   "^miniand,.*":
     description: Miniand Tech
   "^minix,.*":
@@ -1307,6 +1309,8 @@ patternProperties:
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



