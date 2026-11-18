Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795060786;
	b=ypgFgNIPeutg8NHpXze7R8EkVR/v7M+U/zQNrMNJXJH9CGLFY9fB9hc0U2jhAKZV0KMH
	 YgvMQSNSmmUw6kueZqNHdvUChtRXcib0Suuh1KG5laIgucFFWOhsCBIcmgME6lIPyeZ7k
	 S+dov+zrT30AuTlVkiFpPGfniVs6aV2ivoYv5lXi6YD893om3deN/sDktlmhJEVXWHmxz
	 mgkj9SzBquPFo5HOtQbiB5w2Y1lQlc/WVNCaC9mEC9e7adQ2+KNRmaWhVcjGR26dtg1Go
	 8rjIOCDyK34Y7qiEeIA5S1OHrmBey/1hVfvSRmyiFW89xZ/9jYiNlaFKMpFJXgHHsCA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795060786;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=q7DMY3IDccI4bXI4JxGkBl7Xa89GzXpYnKql+CkJUB0=;
	b=3EJ6eakgBNxnWak+wO+ud0YyFByTfT8JdaxZcYe7FtB3FmnzYAlH9/AvrYBUjNhfk4Td
	 GuNFv6kC1Ei9RZ0urcThDeUdOpuspE7Xc9uO+Oczo3wTOMRibybuP64M2FyU+ti0n1J5i
	 cEWdV5Ex1dg4qaXLRvhtQ47k0JUM6RGOuzpuS6/zfQVjctqerGUKmd6X1utWf4k/VlHJE
	 /83M/CMjlkdU2BtbzA59ocmjUY/k6p+DqY7eBB1+P2w5feNXqtsmk1a0vfzyq99lRvBPB
	 5YXfti2lqXev/ieiHANari8gOZkut8NB6m4D6+xF1a4bthBWVplk9+QpwRQiweUujUQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bYzTLFTP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8083F606A32C;
	Thu, 19 Nov 2026 03:59:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bYzTLFTP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D566D1F000C4;
	Thu, 19 Nov 2026 03:59:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795060786;
	bh=q7DMY3IDccI4bXI4JxGkBl7Xa89GzXpYnKql+CkJUB0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bYzTLFTP12u0XHjDxUvv70mI2SMNRWzFxbqWeCjMOXnk7CORWBFJsQii7DuCef89/
	 ChoqKV2Y63HbwoNcrg98ABQUtUERcq1M0iHDCQbOxU8Qyk5SrwJAQEL62AODjvDCM1
	 HIOxIGZ2ox6/mBYNQZOV2hjD4Gj2Eoy3S+rAu1vg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Conor Dooley <conor.dooley@microchip.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1323/1848] dt-bindings: Add vendor prefixes
Date: Wed, 18 Nov 2026 15:56:01 +0100
Message-ID: <20261118150015.084509197@linuxfoundation.org>
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
index 9d872844d0f26..487b4e9d42542 100644
--- a/Documentation/devicetree/bindings/vendor-prefixes.yaml
+++ b/Documentation/devicetree/bindings/vendor-prefixes.yaml
@@ -49,6 +49,8 @@ patternProperties:
     description: AD Holdings Plc.
   "^adi,.*":
     description: Analog Devices, Inc.
+  "^adieng,.*":
+    description: ADI Engineering, Inc.
   "^advantech,.*":
     description: Advantech Corporation
   "^aeroflexgaisler,.*":
@@ -99,6 +101,8 @@ patternProperties:
     description: Arasan Chip Systems
   "^archermind,.*":
     description: ArcherMind Technology (Nanjing) Co., Ltd.
+  "^arcom,.*":
+    description: Arcom Controllers
   "^arctic,.*":
     description: Arctic Sand
   "^arcx,.*":
@@ -385,6 +389,8 @@ patternProperties:
     description: FocalTech Systems Co.,Ltd
   "^forlinx,.*":
     description: Baoding Forlinx Embedded Technology Co., Ltd.
+  "^freecom,.*":
+    description: Freecom Gmbh
   "^frida,.*":
     description: Shenzhen Frida LCD Co., Ltd.
   "^friendlyarm,.*":
@@ -395,6 +401,8 @@ patternProperties:
     description: Fujitsu Ltd.
   "^gardena,.*":
     description: GARDENA GmbH
+  "^gateway,.*":
+    description: Gateway Communications
   "^gateworks,.*":
     description: Gateworks Corporation
   "^gcw,.*":
@@ -409,6 +417,8 @@ patternProperties:
     description: GE Fanuc Intelligent Platforms Embedded Systems, Inc.
   "^gemei,.*":
     description: Gemei Digital Technology Co., Ltd.
+  "^gemtek,.*":
+    description: Gemtek Technology Co., Ltd.
   "^genesys,.*":
     description: Genesys Logic, Inc.
   "^geniatech,.*":
@@ -427,6 +437,8 @@ patternProperties:
     description: Shenzhen Huiding Technology Co., Ltd.
   "^google,.*":
     description: Google, Inc.
+  "^goramo,.*":
+    description: Goramo Gorecki
   "^gplus,.*":
     description: GPLUS
   "^grinn,.*":
@@ -1142,6 +1154,8 @@ patternProperties:
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



