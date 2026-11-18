Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055321;
	b=HQAfXR81dJMvsxhJuWkB+OmBrp63E7qqXHAEvhvGi6XLTwxOMAIEi/l7ta6MqeLTKrxL
	 CybMwtlgd2pjTznwxqMweJrxDDBw4ceDLb9V1AI1jy2r94UlicFdyveN9zn8nYTIpeR+e
	 +8YGJFZRVtHKOPmOTiVRbtspOgasVRIiFCKn7Nuc/Nz39znloLuV/SavXb3t7N/uCa5sE
	 2hIlifn4NwZ4q7TY5WnR7UdAnQ2EB75+vuKjNtN9FUHcrz6CF5mRG2H+D5vEvOlypDLgT
	 LQrVoR2zfaqCnGJjxFdtp1C8lvKumuampQvpVLwxCwR0aQ1dYxlH2C8Y9DX8+J/+nBw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055321;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=32QhNZqm1Fak+Vi3T2Nl4d9d9ierB3JO7PBY7KviSJA=;
	b=0Rc6dctXA7pYDBodXTXyKMnOsBenEmcqHGl24WwYn6Wdny3+x4NP1sOcohYm/q60bDG1
	 RfoLLVZdCbpNAt+ZiUl7L6ZViF7zjNjDmgygyBBZwUHOQ6HiyLSA+3TKlzkIdJIA+weAq
	 0OwPzflcekQdQn0a68fukJaW65UA7q6PSPzyZuNimlX6h99VyD8sOYnq1fV2g5Wvx6qub
	 k9fpOu8DeejmtzJ6ca4DkFoM8U+83l6+maesLOdaDuvFPEXHtrGDqQkKySZ7FD5LBHBkt
	 cUxlToPXUpb1WpE347vX4QEgYh3hrVoFWbBaM+ZV7+vrCkwkyN3G/5qY1WeQ+o3mIqw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KCnugBDA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45540606A333;
	Thu, 19 Nov 2026 02:28:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KCnugBDA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C1CC1F000C4;
	Thu, 19 Nov 2026 02:28:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055321;
	bh=32QhNZqm1Fak+Vi3T2Nl4d9d9ierB3JO7PBY7KviSJA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KCnugBDACH91n8ATPT4Cb6fQXn5W5IQBGTijJxDRhwjwhZQ9u1l2Ze4vg/YwfOBea
	 ORFs9Vb/BdH4+6en87zdo27wbLaecCoSjlbNmDI3vIXuNK0AfkqeSRksEXQth2r0lH
	 STL7bW/Y/IVGitDPIZV81ha1gmUG+1qR7Ow9UXQ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Conor Dooley <conor.dooley@microchip.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1588/2214] dt-bindings: Add vendor prefixes
Date: Wed, 18 Nov 2026 15:54:24 +0100
Message-ID: <20261118150115.520211539@linuxfoundation.org>
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

From: Linus Walleij <linus.walleij@linaro.org>

[ Upstream commit 714ff69c331c005c9cd05d69d3c6fe9da20ef687 ]

These vendor prefixes are used by some routers supported
by e.g. OpenWrt.

- ADI Engineering is a US telecom equipment company.

- Arcom Controllers is a US manufacturer of repeaters.

- Freecom Gmbh is a german telecom equipment company.

- Gemtek Technology is a Taiwan telecom company.

- Gateway Communications was a telecommunication company,
  now acquired by HKT Limited/PCCW.

- Goramo Gorecki is a privately owned Polish telecom
  company.

- U.S. Robotics Corporation, known through their brand name
  USRobotics is generally referred to as "USR" so use this
  prefix for the company's device tree bindings.

Acked-by: Conor Dooley <conor.dooley@microchip.com>
Link: https://lore.kernel.org/r/20231007-ixp4xx-usr8200-v3-1-ec46edd1ff0e@linaro.org
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Stable-dep-of: aa906abf611c ("dt-bindings: vendor-prefixes: add Free Mobile")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../devicetree/bindings/vendor-prefixes.yaml       | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/Documentation/devicetree/bindings/vendor-prefixes.yaml b/Documentation/devicetree/bindings/vendor-prefixes.yaml
index 7dc90c24d5261..d68bfde3b28d0 100644
--- a/Documentation/devicetree/bindings/vendor-prefixes.yaml
+++ b/Documentation/devicetree/bindings/vendor-prefixes.yaml
@@ -53,6 +53,8 @@ patternProperties:
     description: AD Holdings Plc.
   "^adi,.*":
     description: Analog Devices, Inc.
+  "^adieng,.*":
+    description: ADI Engineering, Inc.
   "^advantech,.*":
     description: Advantech Corporation
   "^aeroflexgaisler,.*":
@@ -113,6 +115,8 @@ patternProperties:
     description: Arasan Chip Systems
   "^archermind,.*":
     description: ArcherMind Technology (Nanjing) Co., Ltd.
+  "^arcom,.*":
+    description: Arcom Controllers
   "^arctic,.*":
     description: Arctic Sand
   "^arcx,.*":
@@ -421,6 +425,8 @@ patternProperties:
     description: FocalTech Systems Co.,Ltd
   "^forlinx,.*":
     description: Baoding Forlinx Embedded Technology Co., Ltd.
+  "^freecom,.*":
+    description: Freecom Gmbh
   "^frida,.*":
     description: Shenzhen Frida LCD Co., Ltd.
   "^friendlyarm,.*":
@@ -431,6 +437,8 @@ patternProperties:
     description: Fujitsu Ltd.
   "^gardena,.*":
     description: GARDENA GmbH
+  "^gateway,.*":
+    description: Gateway Communications
   "^gateworks,.*":
     description: Gateworks Corporation
   "^gcw,.*":
@@ -445,6 +453,8 @@ patternProperties:
     description: GE Fanuc Intelligent Platforms Embedded Systems, Inc.
   "^gemei,.*":
     description: Gemei Digital Technology Co., Ltd.
+  "^gemtek,.*":
+    description: Gemtek Technology Co., Ltd.
   "^genesys,.*":
     description: Genesys Logic, Inc.
   "^geniatech,.*":
@@ -463,6 +473,8 @@ patternProperties:
     description: Shenzhen Huiding Technology Co., Ltd.
   "^google,.*":
     description: Google, Inc.
+  "^goramo,.*":
+    description: Goramo Gorecki
   "^gplus,.*":
     description: GPLUS
   "^grinn,.*":
@@ -1248,6 +1260,8 @@ patternProperties:
     description: United Radiant Technology Corporation
   "^usi,.*":
     description: Universal Scientific Industrial Co., Ltd.
+  "^usr,.*":
+    description: U.S. Robotics Corporation
   "^utoo,.*":
     description: Aigo Digital Technology Co., Ltd.
   "^v3,.*":
-- 
2.53.0



