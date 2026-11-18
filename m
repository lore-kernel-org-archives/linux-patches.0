Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048625;
	b=mmCKNYLvz8aYj9scfPe878Xlzj/H6yJo1uW9e7nFbb6m7QrE2yAgRSgVNBmbvK0hq9UU
	 gTTwqx4y86sNOB4Y4dE1aFb8jtnwkyrxJIL0+0VrTnOoSTz1hm8WHfwQsKJWw7TJLC8dD
	 aENRciI0TTApoEWcP20KbZ7S55UYqw3ocnve3G86NEEdf6SwYNCb+dhR97D8j1AxdbLWR
	 QiPcETRYJZi6wvcWK9cZe//+ATT/THDW1MRgW/f/iG60Ygg18jPrMsybBRjnz/wGzWwwQ
	 d9vlnw17LlFivtuBRaF0rryEFAmr1q4wNcckC1FP8UFPkCl8W5Nk//BXjInn15Tbt7g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048625;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zv59IRhwp/2QBZY6imU4QFVYsHHZSFKNC5S8i+ifVJM=;
	b=UYHuL8IgX3AywYm3Pu9Can+krd7MQRe7hl9scHkcZ1wBBH+C/HreNefsUWsN9bP4ouJt
	 1Yb3B2CbpKBL3LtIrhHqKlH/V6xaJbV41KMtv+/rnLAe+P5HAS9Ey/KA5UV4qMgguTXxc
	 LF49J9K8cYHZ7piRP8x/nSyhk/fPpDtcxGMyuiUA1Bwzodk7jGIzB4wceRX8gsGTgPPOC
	 NqpKyIJGHTnhPCStPMIiHPapqti6fnuYkvLWy2oZHOLzm04PF9XxqJZ0XoVKOivJZ5CVQ
	 Rb3xpIa2f+lafZ5vwldJ0KPaohl9JLn3Pf8Bs7iV0DmGPgOIhl4PMnHDhDz6vMi0nqQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZI7+Qvsr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0FBF606A325;
	Thu, 19 Nov 2026 00:37:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZI7+Qvsr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 430991F000C4;
	Thu, 19 Nov 2026 00:37:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048624;
	bh=zv59IRhwp/2QBZY6imU4QFVYsHHZSFKNC5S8i+ifVJM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZI7+QvsrUOtoGgz4lDp/v851FU12yk8c5BQB3QfPc2o2C2eNk0bGMGqdORR0fbnrA
	 2inke/A6ir2phFGs3r0H9mFbf41rLXeqsb1zqkCns/Wxo+/nu1MpBUIaD3dQ0oPewu
	 0gm+QEUbm8CqdresOE/cJcjsGsx7PFa7AL21l4G8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Conor Dooley <conor.dooley@microchip.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2034/2857] dt-bindings: Add vendor prefixes
Date: Wed, 18 Nov 2026 15:51:08 +0100
Message-ID: <20261118150314.644130078@linuxfoundation.org>
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
@@ -57,6 +57,8 @@ patternProperties:
     description: AD Holdings Plc.
   "^adi,.*":
     description: Analog Devices, Inc.
+  "^adieng,.*":
+    description: ADI Engineering, Inc.
   "^advantech,.*":
     description: Advantech Corporation
   "^aeroflexgaisler,.*":
@@ -121,6 +123,8 @@ patternProperties:
     description: Arasan Chip Systems
   "^archermind,.*":
     description: ArcherMind Technology (Nanjing) Co., Ltd.
+  "^arcom,.*":
+    description: Arcom Controllers
   "^arctic,.*":
     description: Arctic Sand
   "^arcx,.*":
@@ -464,6 +468,8 @@ patternProperties:
     description: FocalTech Systems Co.,Ltd
   "^forlinx,.*":
     description: Baoding Forlinx Embedded Technology Co., Ltd.
+  "^freecom,.*":
+    description: Freecom Gmbh
   "^frida,.*":
     description: Shenzhen Frida LCD Co., Ltd.
   "^friendlyarm,.*":
@@ -476,6 +482,8 @@ patternProperties:
     description: FX Technology Ltd.
   "^gardena,.*":
     description: GARDENA GmbH
+  "^gateway,.*":
+    description: Gateway Communications
   "^gateworks,.*":
     description: Gateworks Corporation
   "^gcw,.*":
@@ -490,6 +498,8 @@ patternProperties:
     description: GE Fanuc Intelligent Platforms Embedded Systems, Inc.
   "^gemei,.*":
     description: Gemei Digital Technology Co., Ltd.
+  "^gemtek,.*":
+    description: Gemtek Technology Co., Ltd.
   "^genesys,.*":
     description: Genesys Logic, Inc.
   "^geniatech,.*":
@@ -508,6 +518,8 @@ patternProperties:
     description: Shenzhen Huiding Technology Co., Ltd.
   "^google,.*":
     description: Google, Inc.
+  "^goramo,.*":
+    description: Goramo Gorecki
   "^gplus,.*":
     description: GPLUS
   "^grinn,.*":
@@ -1378,6 +1390,8 @@ patternProperties:
     description: United Radiant Technology Corporation
   "^usi,.*":
     description: Universal Scientific Industrial Co., Ltd.
+  "^usr,.*":
+    description: U.S. Robotics Corporation
   "^utoo,.*":
     description: Aigo Digital Technology Co., Ltd.
   "^v3,.*":


