Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048420;
	b=ydQe0hnYTqku63MY/uVFCOeR/kN9/jpPrwP1XTZ9LTSyVqCDWIgzea70PEptN984zU2E
	 RXAun9gWu8JIftl15pT8Vem883mGI7v227M3swMlUIHwQZIAjqLJqBWhKshoiSYM9CZBV
	 +n6R5ZnybBc1bT2jitxIF7HXB/v52CvJ2ZJxf9YB1g2kb707tEZioukJSgUwRdzctU4Q4
	 Eb7Ey0I7//L2GgdZJF+V9kHAORvtVB5yLyzUsNQjs43L1zV5pTHSIrPMZ1nT35rAVON5T
	 oWBaf9SbucpTBjW8xAl+qVLvhgrnxHQ3eOm/n9ycfvIueHvYCw4vYKm8yBA7KtJd1hw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048420;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=WaRnXNvmaLk6iXEHCLqT5ryExlu/z4ViAWNtQwHPEMM=;
	b=xtBNYYwdcp2GfF0Xx8XbxxIcoifJ+u7XhJBDxgK3Akyc0rgbD9oLNl3i4nTW+8rzAZpj
	 oO4H2hDWv5Be8srLil/F2wuiwgyaKiolhuRkr05+iAzO4X9mwa7dVG52cQulUnMK8bAgW
	 FB0CKv5Vv18iFoFXwrGvWLjksd1mIq3+75P9OY/Yr5BRLF3rrjirK2fYEeG23JNrF36vg
	 cvHNkGTwt7VDMWYCVxiYJyxtYMZTnq43u+i2UEOAjggeD22YmasIOh7GYWFuZnNMxSp0w
	 JqCNwvmXRG3Z/zMbkNm87ilJsIUGq51D/m0v1aeQR1PmHxY26eH8RuVkFdfrla+GJWA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ePaKoba8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DA46606A32A;
	Thu, 19 Nov 2026 00:33:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ePaKoba8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E9A81F000C4;
	Thu, 19 Nov 2026 00:33:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048420;
	bh=WaRnXNvmaLk6iXEHCLqT5ryExlu/z4ViAWNtQwHPEMM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ePaKoba84ozku4v43r4evJwhKfNL65A5BoLnin8C1o6UvrKGIDjylSg+FboC4eByM
	 tpVHXKvWP7VMO/BmLYXZRMsfdGnHgv5dwSCttv7eO/6OX7iBzZLHnrIm9NLD/EoIYE
	 AJRJ2rSsXMs6tbsI3fTN9mwdTincHYMUxIPkyOm0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Rob Herring <robh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1986/2857] dt-bindings: vendor-prefixes: sort entries alphabetically
Date: Wed, 18 Nov 2026 15:50:20 +0100
Message-ID: <20261118150312.885914114@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

[ Upstream commit 5fa9f7292b17bcd66da93226fc28fe1f755af154 ]

Sort entries alphabetically.  This was a semi manual job with help of:

  cat Documentation/devicetree/bindings/vendor-prefixes.yaml | grep '":' > old
  cat old | sort > new
  diff -ubB old new

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Link: https://lore.kernel.org/r/20221202110536.22230-1-krzysztof.kozlowski@linaro.org
Signed-off-by: Rob Herring <robh@kernel.org>
Stable-dep-of: cb81a22504f4 ("dt-bindings: vendor-prefixes: Add vendor prefix for Teclast")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../devicetree/bindings/vendor-prefixes.yaml  | 64 +++++++++----------
 1 file changed, 32 insertions(+), 32 deletions(-)

diff --git a/Documentation/devicetree/bindings/vendor-prefixes.yaml b/Documentation/devicetree/bindings/vendor-prefixes.yaml
index 2da6ca65e722f..7fa835c6a9a50 100644
--- a/Documentation/devicetree/bindings/vendor-prefixes.yaml
+++ b/Documentation/devicetree/bindings/vendor-prefixes.yaml
@@ -196,10 +196,10 @@ patternProperties:
     description: Bosch Sensortec GmbH
   "^boundary,.*":
     description: Boundary Devices Inc.
-  "^broadmobi,.*":
-    description: Shanghai Broadmobi Communication Technology Co.,Ltd.
   "^brcm,.*":
     description: Broadcom Corporation
+  "^broadmobi,.*":
+    description: Shanghai Broadmobi Communication Technology Co.,Ltd.
   "^bsh,.*":
     description: BSH Hausgeraete GmbH
   "^bticino,.*":
@@ -543,6 +543,8 @@ patternProperties:
     description: Hitex Development Tools
   "^holt,.*":
     description: Holt Integrated Circuits, Inc.
+  "^holtek,.*":
+    description: Holtek Semiconductor, Inc.
   "^honestar,.*":
     description: Honestar Technologies Co., Ltd.
   "^honeywell,.*":
@@ -555,8 +557,6 @@ patternProperties:
     description: Hewlett Packard Enterprise
   "^hsg,.*":
     description: HannStar Display Co.
-  "^holtek,.*":
-    description: Holtek Semiconductor, Inc.
   "^huawei,.*":
     description: Huawei Technologies Co., Ltd.
   "^hugsun,.*":
@@ -599,12 +599,10 @@ patternProperties:
     description: Infineon Technologies
   "^inforce,.*":
     description: Inforce Computing
-  "^ingrasys,.*":
-    description: Ingrasys Technology Inc.
-  "^ivo,.*":
-    description: InfoVision Optoelectronics Kunshan Co. Ltd.
   "^ingenic,.*":
     description: Ingenic Semiconductor
+  "^ingrasys,.*":
+    description: Ingrasys Technology Inc.
   "^injoinic,.*":
     description: Injoinic Technology Corp.
   "^innolux,.*":
@@ -639,6 +637,8 @@ patternProperties:
     description: ITEAD Intelligent Systems Co.Ltd
   "^itian,.*":
     description: ITian Corporation
+  "^ivo,.*":
+    description: InfoVision Optoelectronics Kunshan Co. Ltd.
   "^iwave,.*":
     description: iWave Systems Technologies Pvt. Ltd.
   "^jdi,.*":
@@ -889,6 +889,8 @@ patternProperties:
     description: Shenzhen Netxeon Technology CO., LTD
   "^neweast,.*":
     description: Guangdong Neweast Optoelectronics CO., LTD
+  "^newhaven,.*":
+    description: Newhaven Display International
   "^newvision,.*":
     description: New Vision Display (Shenzhen) Co., Ltd.
   "^nexbox,.*":
@@ -897,8 +899,6 @@ patternProperties:
     description: Nexperia B.V.
   "^nextthing,.*":
     description: Next Thing Co.
-  "^newhaven,.*":
-    description: Newhaven Display International
   "^ni,.*":
     description: National Instruments
   "^nintendo,.*":
@@ -1045,10 +1045,10 @@ patternProperties:
     description: QEMU, a generic and open source machine emulator and virtualizer
   "^qi,.*":
     description: Qi Hardware
-  "^qihua,.*":
-    description: Chengdu Kaixuan Information Technology Co., Ltd.
   "^qiaodian,.*":
     description: QiaoDian XianShi Corporation
+  "^qihua,.*":
+    description: Chengdu Kaixuan Information Technology Co., Ltd.
   "^qishenglong,.*":
     description: Shenzhen QiShenglong Industrialist Co., Ltd.
   "^qnap,.*":
@@ -1075,22 +1075,22 @@ patternProperties:
     description: reMarkable AS
   "^renesas,.*":
     description: Renesas Electronics Corporation
-  "^rex,.*":
-    description: iMX6 Rex Project
   "^rervision,.*":
     description: Shenzhen Rervision Technology Co., Ltd.
   "^revotics,.*":
     description: Revolution Robotics, Inc. (Revotics)
+  "^rex,.*":
+    description: iMX6 Rex Project
   "^richtek,.*":
     description: Richtek Technology Corporation
   "^ricoh,.*":
     description: Ricoh Co. Ltd.
   "^rikomagic,.*":
     description: Rikomagic Tech Corp. Ltd
-  "^riscv,.*":
-    description: RISC-V Foundation
   "^riot,.*":
     description: Embest RIoT
+  "^riscv,.*":
+    description: RISC-V Foundation
   "^rockchip,.*":
     description: Fuzhou Rockchip Electronics Co., Ltd
   "^rocktech,.*":
@@ -1153,6 +1153,8 @@ patternProperties:
     description: Si-En Technology Ltd.
   "^si-linux,.*":
     description: Silicon Linux Corporation
+  "^siemens,.*":
+    description: Siemens AG
   "^sifive,.*":
     description: SiFive, Inc.
   "^sigma,.*":
@@ -1175,8 +1177,8 @@ patternProperties:
     description: Siliconfile Technologies lnc.
   "^siliconmitus,.*":
     description: Silicon Mitus, Inc.
-  "^siemens,.*":
-    description: Siemens AG
+  "^silvaco,.*":
+    description: Silvaco, Inc.
   "^simtek,.*":
     description: Cypress Semiconductor Corporation (Simtek Corporation)
   "^sinlinx,.*":
@@ -1262,8 +1264,6 @@ patternProperties:
     description: Sun Microsystems, Inc
   "^supermicro,.*":
     description: Super Micro Computer, Inc.
-  "^silvaco,.*":
-    description: Silvaco, Inc.
   "^swir,.*":
     description: Sierra Wireless
   "^syna,.*":
@@ -1285,16 +1285,18 @@ patternProperties:
     description: Shenzhen City Tang Cheng Technology Co., Ltd.
   "^tdo,.*":
     description: Shangai Top Display Optoelectronics Co., Ltd
+  "^team-source-display,.*":
+    description: Shenzhen Team Source Display Technology Co., Ltd. (TSD)
   "^technexion,.*":
     description: TechNexion
   "^technologic,.*":
     description: Technologic Systems
+  "^techstar,.*":
+    description: Shenzhen Techstar Electronics Co., Ltd.
   "^teltonika,.*":
     description: Teltonika Networks
   "^tempo,.*":
     description: Tempo Semiconductor
-  "^techstar,.*":
-    description: Shenzhen Techstar Electronics Co., Ltd.
   "^terasic,.*":
     description: Terasic Inc.
   "^tesla,.*":
@@ -1348,10 +1350,6 @@ patternProperties:
     description: Tronsmart
   "^truly,.*":
     description: Truly Semiconductors Limited
-  "^visionox,.*":
-    description: Visionox
-  "^team-source-display,.*":
-    description: Shenzhen Team Source Display Technology Co., Ltd. (TSD)
   "^tsd,.*":
     description: Theobroma Systems Design und Consulting GmbH
   "^tyan,.*":
@@ -1360,10 +1358,10 @@ patternProperties:
     description: u-blox
   "^u-boot,.*":
     description: U-Boot bootloader
-  "^ucrobotics,.*":
-    description: uCRobotics
   "^ubnt,.*":
     description: Ubiquiti Networks
+  "^ucrobotics,.*":
+    description: uCRobotics
   "^udoo,.*":
     description: Udoo
   "^ugoos,.*":
@@ -1402,6 +1400,8 @@ patternProperties:
     description: Used for virtual device without specific vendor.
   "^vishay,.*":
     description: Vishay Intertechnology, Inc
+  "^visionox,.*":
+    description: Visionox
   "^vitesse,.*":
     description: Vitesse Semiconductor Corporation
   "^vivante,.*":
@@ -1416,6 +1416,8 @@ patternProperties:
     description: Vision Optical Technology Co., Ltd.
   "^vxt,.*":
     description: VXT Ltd
+  "^wanchanglong,.*":
+    description: Wanchanglong Electronics Technology（SHENZHEN）Co.，Ltd.
   "^wand,.*":
     description: Wandbord (Technexion)
   "^waveshare,.*":
@@ -1456,8 +1458,6 @@ patternProperties:
     description: Wondermedia Technologies, Inc.
   "^wobo,.*":
     description: Wobo
-  "^wanchanglong,.*":
-    description: Wanchanglong Electronics Technology（SHENZHEN）Co.，Ltd.
   "^x-powers,.*":
     description: X-Powers
   "^xen,.*":
@@ -1500,10 +1500,10 @@ patternProperties:
     description: Shenzhen Yashi Changhua Intelligent Technology Co., Ltd.
   "^ysoft,.*":
     description: Y Soft Corporation a.s.
-  "^zealz,.*":
-    description: Zealz
   "^zarlink,.*":
     description: Zarlink Semiconductor
+  "^zealz,.*":
+    description: Zealz
   "^zeitec,.*":
     description: ZEITEC Semiconductor Co., LTD.
   "^zidoo,.*":
-- 
2.53.0



