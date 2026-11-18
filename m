Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061202;
	b=sf+WSou6ELpmilOha2hXVLYYrefKTUDZoN+wI9Kvbvn2XzhSabTeyxiH/MeVQFBeg71I
	 uBQ/ueq+rmYC/CNKg0hVltBffgxnUAqtrkhGY89XoXwOLnyhQ24OdWSqHRkIdvuRFqxlb
	 6D5BstXO76C88D+cLpqZgoBxL+OYqQllP827948nuAX3iEL/SLR1meXzy4sD1gTNG5CNd
	 kxIm46U61CdHSSx4CvbGoFQHc/079fPO1TiMJmjrrIfP+6/I2KQ1vpnRIaFsUitG7cYRS
	 vDnBn8NhvFiqcYkjinZieCUR97lL9Q6B3YRI1C5F6RP1lO190Wt7s2b5LV4oadR842g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061202;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0PHH+xEkzMWRR5K8aieCCU/0R4SJZiokrDJZcllRRkw=;
	b=KykiuAjklb3UmZCVXi7di1VLRop6L6K32HZSmLYwZBx7b4wvzYzjHZvme4Ck8b3kjz8a
	 BLmLOlC6hnyezVmDx7rRS4FSZJ594deoQLVZZnMPXDy/29WPDdrkMTSXN2V9vjYkkrg7x
	 C01VtqkfyJEjgov+L893S9QVqjK9dfU1o/HXPNktmKUQnrp67kZZW6qUMB2R/xqN6GTxP
	 zgk+Be2mL8oqKZDbtPm0TxeIV3lQkI4Yzj7zNdpczp7mm/L1PxmPBKdbxyBmYMVIcSB8C
	 FcwW2SPAqTJxS9ylIwIeDvqf6XCfpB3+LW6sh+6F5GXh03PzQ2K1qrMyJU/GlPXr5mw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=W9gGqsD4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C0CD606A320;
	Thu, 19 Nov 2026 04:06:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=W9gGqsD4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3A8E1F000C4;
	Thu, 19 Nov 2026 04:06:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061201;
	bh=0PHH+xEkzMWRR5K8aieCCU/0R4SJZiokrDJZcllRRkw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=W9gGqsD4dG/4IhZlxV5Vi8kalG2Yu+8d7JCv61K4LU03ac09E89Vr7+n4Dpfa/fv0
	 ZaQB51dT4u9/FbP+uobaTeg+TUwmXeziviaQaq0bwdkANDIIx0Nrog6jMSvTQfhK7M
	 cmWGm98ajdye7HWqoHnMYLd769Oia7OAjuGEvqWk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guo Ren <guoren@kernel.org>,
	Conor Dooley <conor.dooley@microchip.com>,
	Chao Wei <chao.wei@sophgo.com>,
	Chen Wang <unicorn_wang@outlook.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1417/1848] dt-bindings: vendor-prefixes: add milkv/sophgo
Date: Wed, 18 Nov 2026 15:57:35 +0100
Message-ID: <20261118150018.815832215@linuxfoundation.org>
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
index a29d31cf7d078..307700c3b2aaa 100644
--- a/Documentation/devicetree/bindings/vendor-prefixes.yaml
+++ b/Documentation/devicetree/bindings/vendor-prefixes.yaml
@@ -705,6 +705,8 @@ patternProperties:
     description: MikroElektronika d.o.o.
   "^mikrotik,.*":
     description: MikroTik
+  "^milkv,.*":
+    description: MilkV Technology Co., Ltd
   "^miniand,.*":
     description: Miniand Tech
   "^minix,.*":
@@ -1052,6 +1054,8 @@ patternProperties:
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



