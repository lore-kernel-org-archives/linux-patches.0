Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795040076;
	b=gBRYXTSp9wYh4HVxtoXTIqvrukpJksQJrizAX2ABOVps8M7TFaX+eaJXXH7vq1uAkFdv
	 JI4JVX3bMFv0SqT5rYqla4dYw0eHUiNeA+KcYrUxdwUHfP8lkRDV3jl05YTjfizTdiOEE
	 DJK78INHoa4jyMuCVWyWhunmcxFb3ryRvo4eF5Y9S7VsDgegS/7g2/4FZTQZNYps7y7V0
	 zS1QaJ/Iv8XiAk1T/yo+SRd44I4dB9O6LFUXZUU2+cEvcFQJPOZhTketQESd1rFphOY7Y
	 QhClCn0xP8knwLJMy1Uoyod1jfOR0cBYG/XYXwPm0bLpXsKevD8A/INwS746zLZwNlQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795040076;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=42EcRA4P/DYTbEdbeNbSP8lX7bMDPnQHw9IAHpv9ux0=;
	b=K6Pdg/zWsq7eIDtoIb1UJ+nJ+ZQl0JhdcBPhpKWY3i4vF3BX7pfAqvmYGWAFpjnobLXN
	 NIJE5wvM3mxWooi0gZzw2Iahm4uIMFoYWVZR3mGjQym8JYI+HdKu1qCGUaiobNd52YbLa
	 RmNcnwhJoeBEgdvjoC/nbD32sCkw5Jhah3N6Makwgg9jZujWn90pLk/OAkTJZ9MIdlL+i
	 wrVIguImXu0vuJYUhAdCB9jYKR/UV4l1euFmUxmB7vFXN1d1lmFf61C2/2BAQEQgdfARf
	 AzLXdNcT6vPWW23e1lexpf4ZR0rBCL3qmhdSjZMATZf8L8d0IT9k+fLrgS2vF3lL+5Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=W1gK53CE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DA62606A325;
	Wed, 18 Nov 2026 22:14:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=W1gK53CE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEF3D1F000C4;
	Wed, 18 Nov 2026 22:14:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795040076;
	bh=42EcRA4P/DYTbEdbeNbSP8lX7bMDPnQHw9IAHpv9ux0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=W1gK53CEjEs0+AcLczoVpCbXgZZs8H9eO/HbUwzeyoXicOMIUUEBCSwXOE5YzEr8B
	 6VAKhaKpJVY/nNi71zYOXbR5bwX1kXcJ/XFAG6vz1Q7n4QTrBxzp2NTqaHqEjWjqeQ
	 +cO6EsVA01tE4C/nbc3hXRPZCH1Q9FO+r1wH+B+c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Conor Dooley <conor.dooley@microchip.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2329/3318] dt-bindings: Add vendor prefixes
Date: Wed, 18 Nov 2026 15:49:11 +0100
Message-ID: <20261118150431.523137139@linuxfoundation.org>
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
 Documentation/devicetree/bindings/vendor-prefixes.yaml |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

--- a/Documentation/devicetree/bindings/vendor-prefixes.yaml
+++ b/Documentation/devicetree/bindings/vendor-prefixes.yaml
@@ -59,6 +59,8 @@ patternProperties:
     description: AD Holdings Plc.
   "^adi,.*":
     description: Analog Devices, Inc.
+  "^adieng,.*":
+    description: ADI Engineering, Inc.
   "^advantech,.*":
     description: Advantech Corporation
   "^aeroflexgaisler,.*":
@@ -127,6 +129,8 @@ patternProperties:
     description: Arasan Chip Systems
   "^archermind,.*":
     description: ArcherMind Technology (Nanjing) Co., Ltd.
+  "^arcom,.*":
+    description: Arcom Controllers
   "^arctic,.*":
     description: Arctic Sand
   "^arcx,.*":
@@ -486,6 +490,8 @@ patternProperties:
     description: FocalTech Systems Co.,Ltd
   "^forlinx,.*":
     description: Baoding Forlinx Embedded Technology Co., Ltd.
+  "^freecom,.*":
+    description: Freecom Gmbh
   "^frida,.*":
     description: Shenzhen Frida LCD Co., Ltd.
   "^friendlyarm,.*":
@@ -498,6 +504,8 @@ patternProperties:
     description: FX Technology Ltd.
   "^gardena,.*":
     description: GARDENA GmbH
+  "^gateway,.*":
+    description: Gateway Communications
   "^gateworks,.*":
     description: Gateworks Corporation
   "^gcw,.*":
@@ -512,6 +520,8 @@ patternProperties:
     description: GE Fanuc Intelligent Platforms Embedded Systems, Inc.
   "^gemei,.*":
     description: Gemei Digital Technology Co., Ltd.
+  "^gemtek,.*":
+    description: Gemtek Technology Co., Ltd.
   "^genesys,.*":
     description: Genesys Logic, Inc.
   "^geniatech,.*":
@@ -534,6 +544,8 @@ patternProperties:
     description: Shenzhen Huiding Technology Co., Ltd.
   "^google,.*":
     description: Google, Inc.
+  "^goramo,.*":
+    description: Goramo Gorecki
   "^gplus,.*":
     description: GPLUS
   "^grinn,.*":
@@ -1454,6 +1466,8 @@ patternProperties:
     description: United Radiant Technology Corporation
   "^usi,.*":
     description: Universal Scientific Industrial Co., Ltd.
+  "^usr,.*":
+    description: U.S. Robotics Corporation
   "^utoo,.*":
     description: Aigo Digital Technology Co., Ltd.
   "^v3,.*":


