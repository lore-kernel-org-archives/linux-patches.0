Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3883430EF83;
	Mon, 13 Oct 2025 15:23:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760368982; cv=none; b=j2YQnIG1ATIlCV2EKFx0z8e3+0c69THczj1zIcC4YIPzjiFcbN6njBwIeaiqfmSWYDIG/Nyv0LmclB3YI3T8u0bnCAvYQWkpguCQMLaoTp1Hu4F+/FixxMdzdFhs9qKFq9R4NUnrD29aR3ItGKrEeho+tqh4XRdrYQ2tre76ysc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760368982; c=relaxed/simple;
	bh=WEODit6pVOKFK5Pt8CfqbIVWSCREg9Ahen5r1I36wWo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DF5W01o3UWu0LmndVpgL2Hi1kiifCdqmHs7ZCH/1eOAmtF+RZDM0mFfET5tQfvslmB/ofzfWHBtYaihDdVpI7/88xd1J/yBeIw9pldpv1fwBukDbcYxAyO72UVeyztKbi8q9X6rBIIyihMTwFjyfJg3cg8uiUlbSY+z5Y0OH240=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ft0Mwx5R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ft0Mwx5R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20DD0C4CEE7;
	Mon, 13 Oct 2025 15:23:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760368981;
	bh=WEODit6pVOKFK5Pt8CfqbIVWSCREg9Ahen5r1I36wWo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ft0Mwx5RxjKD1GS47GSTTXBI/rualz8ZNs6I7eLFkyYPBgu4DSSHXKqypUB0DxCRw
	 ZAJwMA3gXggR2f8FfXtWASU25kv5NZtk07hFweS8CmxBAX0oJVsuxHq6TNa83KpL5N
	 RQnXlc46ZIp2j3hIx3SXuMH7D6Wq6ei0XbxI7Kwc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rob Herring (Arm)" <robh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 085/563] dt-bindings: vendor-prefixes: Add undocumented vendor prefixes
Date: Mon, 13 Oct 2025 16:39:06 +0200
Message-ID: <20251013144414.376057512@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rob Herring (Arm) <robh@kernel.org>

[ Upstream commit 4ed46073274a5b23baf0b992c459762e28faf549 ]

Add various vendor prefixes which are in use in compatible strings
already. These were found by modifying vendor-prefixes.yaml into a
schema to check compatible strings.

The added prefixes doesn't include various duplicate prefixes in use
such as "lge".

Link: https://lore.kernel.org/r/20250821222136.1027269-1-robh@kernel.org
Signed-off-by: Rob Herring (Arm) <robh@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../devicetree/bindings/vendor-prefixes.yaml  | 50 +++++++++++++++++++
 1 file changed, 50 insertions(+)

diff --git a/Documentation/devicetree/bindings/vendor-prefixes.yaml b/Documentation/devicetree/bindings/vendor-prefixes.yaml
index 9ec8947dfcad2..ed7fec614473d 100644
--- a/Documentation/devicetree/bindings/vendor-prefixes.yaml
+++ b/Documentation/devicetree/bindings/vendor-prefixes.yaml
@@ -86,6 +86,8 @@ patternProperties:
     description: Allegro DVT
   "^allegromicro,.*":
     description: Allegro MicroSystems, Inc.
+  "^alliedtelesis,.*":
+    description: Allied Telesis, Inc.
   "^alliedvision,.*":
     description: Allied Vision Technologies GmbH
   "^allo,.*":
@@ -229,6 +231,8 @@ patternProperties:
     description: Bitmain Technologies
   "^blaize,.*":
     description: Blaize, Inc.
+  "^bluegiga,.*":
+    description: Bluegiga Technologies Ltd.
   "^blutek,.*":
     description: BluTek Power
   "^boe,.*":
@@ -247,6 +251,8 @@ patternProperties:
     description: Bticino International
   "^buffalo,.*":
     description: Buffalo, Inc.
+  "^buglabs,.*":
+    description: Bug Labs, Inc.
   "^bur,.*":
     description: B&R Industrial Automation GmbH
   "^bytedance,.*":
@@ -325,6 +331,8 @@ patternProperties:
     description: Conexant Systems, Inc.
   "^colorfly,.*":
     description: Colorful GRP, Shenzhen Xueyushi Technology Ltd.
+  "^compal,.*":
+    description: Compal Electronics, Inc.
   "^compulab,.*":
     description: CompuLab Ltd.
   "^comvetia,.*":
@@ -353,6 +361,8 @@ patternProperties:
     description: Guangzhou China Star Optoelectronics Technology Co., Ltd
   "^csq,.*":
     description: Shenzen Chuangsiqi Technology Co.,Ltd.
+  "^csr,.*":
+    description: Cambridge Silicon Radio
   "^ctera,.*":
     description: CTERA Networks Intl.
   "^ctu,.*":
@@ -455,6 +465,8 @@ patternProperties:
     description: Emtop Embedded Solutions
   "^eeti,.*":
     description: eGalax_eMPIA Technology Inc
+  "^egnite,.*":
+    description: egnite GmbH
   "^einfochips,.*":
     description: Einfochips
   "^eink,.*":
@@ -485,8 +497,12 @@ patternProperties:
     description: Empire Electronix
   "^emtrion,.*":
     description: emtrion GmbH
+  "^enbw,.*":
+    description: Energie Baden-Württemberg AG
   "^enclustra,.*":
     description: Enclustra GmbH
+  "^endian,.*":
+    description: Endian SRL
   "^endless,.*":
     description: Endless Mobile, Inc.
   "^ene,.*":
@@ -554,6 +570,8 @@ patternProperties:
     description: FocalTech Systems Co.,Ltd
   "^forlinx,.*":
     description: Baoding Forlinx Embedded Technology Co., Ltd.
+  "^foxlink,.*":
+    description: Foxlink Group
   "^freebox,.*":
     description: Freebox SAS
   "^freecom,.*":
@@ -642,6 +660,10 @@ patternProperties:
     description: Haoyu Microelectronic Co. Ltd.
   "^hardkernel,.*":
     description: Hardkernel Co., Ltd
+  "^hce,.*":
+    description: HCE Engineering SRL
+  "^headacoustics,.*":
+    description: HEAD acoustics
   "^hechuang,.*":
     description: Shenzhen Hechuang Intelligent Co.
   "^hideep,.*":
@@ -725,6 +747,8 @@ patternProperties:
     description: Shenzhen INANBO Electronic Technology Co., Ltd.
   "^incircuit,.*":
     description: In-Circuit GmbH
+  "^incostartec,.*":
+    description: INCOstartec GmbH
   "^indiedroid,.*":
     description: Indiedroid
   "^inet-tek,.*":
@@ -933,6 +957,8 @@ patternProperties:
     description: Maxim Integrated Products
   "^maxlinear,.*":
     description: MaxLinear Inc.
+  "^maxtor,.*":
+    description: Maxtor Corporation
   "^mbvl,.*":
     description: Mobiveil Inc.
   "^mcube,.*":
@@ -1096,6 +1122,8 @@ patternProperties:
     description: Nordic Semiconductor
   "^nothing,.*":
     description: Nothing Technology Limited
+  "^novatech,.*":
+    description: NovaTech Automation
   "^novatek,.*":
     description: Novatek
   "^novtech,.*":
@@ -1191,6 +1219,8 @@ patternProperties:
     description: Pervasive Displays, Inc.
   "^phicomm,.*":
     description: PHICOMM Co., Ltd.
+  "^phontech,.*":
+    description: Phontech
   "^phytec,.*":
     description: PHYTEC Messtechnik GmbH
   "^picochip,.*":
@@ -1275,6 +1305,8 @@ patternProperties:
     description: Ramtron International
   "^raspberrypi,.*":
     description: Raspberry Pi Foundation
+  "^raumfeld,.*":
+    description: Raumfeld GmbH
   "^raydium,.*":
     description: Raydium Semiconductor Corp.
   "^rda,.*":
@@ -1313,6 +1345,8 @@ patternProperties:
     description: ROHM Semiconductor Co., Ltd
   "^ronbo,.*":
     description: Ronbo Electronics
+  "^ronetix,.*":
+    description: Ronetix GmbH
   "^roofull,.*":
     description: Shenzhen Roofull Technology Co, Ltd
   "^roseapplepi,.*":
@@ -1339,8 +1373,12 @@ patternProperties:
     description: Schindler
   "^schneider,.*":
     description: Schneider Electric
+  "^schulercontrol,.*":
+    description: Schuler Group
   "^sciosense,.*":
     description: ScioSense B.V.
+  "^sdmc,.*":
+    description: SDMC Technology Co., Ltd
   "^seagate,.*":
     description: Seagate Technology PLC
   "^seeed,.*":
@@ -1379,6 +1417,8 @@ patternProperties:
     description: Si-En Technology Ltd.
   "^si-linux,.*":
     description: Silicon Linux Corporation
+  "^sielaff,.*":
+    description: Sielaff GmbH & Co.
   "^siemens,.*":
     description: Siemens AG
   "^sifive,.*":
@@ -1447,6 +1487,8 @@ patternProperties:
     description: SolidRun
   "^solomon,.*":
     description: Solomon Systech Limited
+  "^somfy,.*":
+    description: Somfy Systems Inc.
   "^sony,.*":
     description: Sony Corporation
   "^sophgo,.*":
@@ -1517,6 +1559,8 @@ patternProperties:
   "^synopsys,.*":
     description: Synopsys, Inc. (deprecated, use snps)
     deprecated: true
+  "^taos,.*":
+    description: Texas Advanced Optoelectronic Solutions Inc.
   "^tbs,.*":
     description: TBS Technologies
   "^tbs-biometrics,.*":
@@ -1547,6 +1591,8 @@ patternProperties:
     description: Teltonika Networks
   "^tempo,.*":
     description: Tempo Semiconductor
+  "^tenda,.*":
+    description: Shenzhen Tenda Technology Co., Ltd.
   "^terasic,.*":
     description: Terasic Inc.
   "^tesla,.*":
@@ -1650,6 +1696,8 @@ patternProperties:
     description: V3 Semiconductor
   "^vaisala,.*":
     description: Vaisala
+  "^valve,.*":
+    description: Valve Corporation
   "^vamrs,.*":
     description: Vamrs Ltd.
   "^variscite,.*":
@@ -1750,6 +1798,8 @@ patternProperties:
     description: Extreme Engineering Solutions (X-ES)
   "^xiaomi,.*":
     description: Xiaomi Technology Co., Ltd.
+  "^xicor,.*":
+    description: Xicor Inc.
   "^xillybus,.*":
     description: Xillybus Ltd.
   "^xingbangda,.*":
-- 
2.51.0



