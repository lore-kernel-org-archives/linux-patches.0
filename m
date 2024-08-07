Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53A9981AB6;
	Wed,  7 Aug 2024 15:08:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723043325; cv=none; b=CcXdsF4URwbk3pbWMxpQHSS4A07H+iFJm3g3+yQM5u7yudMgQhaU7MIkXW7s7UlqqZ59I6Yu0RkbwRDlyb8er7tginRfkC20mE7Bcjo+TffJOAPFanQgulopdmdv3abwDlvv9VHC3bzFJhn0lXgXkeOgdBUJsqaQi1P036ZK0xw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723043325; c=relaxed/simple;
	bh=KKQ/q0YWVdsYLVfgL73yCzFw26k4tal1NStdJG4xgJ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LCE4gZ6D/DrrVUYxvdQT6l3johlipxunzbOOd8XohFEs4aS6sOQZMwezp3QjMEq+ahsEvTr1g14Yw44S3fx4aoTv9hW+sZuKfNpLDVvXZjCt3SAdSDBBMcJPohVNmMGNGRHNvJIbD3T9FXz5pzXi4j9xbV5wx1QxXFziaBrzdwA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W+tog37A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W+tog37A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9921C32781;
	Wed,  7 Aug 2024 15:08:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723043325;
	bh=KKQ/q0YWVdsYLVfgL73yCzFw26k4tal1NStdJG4xgJ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W+tog37AyGcys3cRmOx5uIwAmju8F9G0LdDR5MP7X3BqDRF4Se63LEi0LKoA8JhNM
	 YxpUsa6kvxlcQ5hqnDR22+HLBuNf0Df1xBz68cpKvQTX9N5HeUfokd6+Hp7g01SaeB
	 PphPc7Oz/gfhfHCj6Cb1HfPKdaUpDWdQ2LEdeQ+A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiaxun Yang <jiaxun.yang@flygoat.com>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 048/121] MIPS: dts: loongson: Fix liointc IRQ polarity
Date: Wed,  7 Aug 2024 16:59:40 +0200
Message-ID: <20240807150020.978631361@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240807150019.412911622@linuxfoundation.org>
References: <20240807150019.412911622@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiaxun Yang <jiaxun.yang@flygoat.com>

[ Upstream commit dbb69b9d6234aad23b3ecd33e5bc8a8ae1485b7d ]

All internal liointc interrupts are high level triggered.

Fixes: b1a792601f26 ("MIPS: Loongson64: DeviceTree for Loongson-2K1000")
Cc: stable@vger.kernel.org
Signed-off-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../boot/dts/loongson/loongson64-2k1000.dtsi  | 42 +++++++++----------
 1 file changed, 21 insertions(+), 21 deletions(-)

diff --git a/arch/mips/boot/dts/loongson/loongson64-2k1000.dtsi b/arch/mips/boot/dts/loongson/loongson64-2k1000.dtsi
index c1d3092fdd870..eec8243be6499 100644
--- a/arch/mips/boot/dts/loongson/loongson64-2k1000.dtsi
+++ b/arch/mips/boot/dts/loongson/loongson64-2k1000.dtsi
@@ -100,7 +100,7 @@ rtc0: rtc@1fe07800 {
 			compatible = "loongson,ls2k1000-rtc";
 			reg = <0 0x1fe07800 0 0x78>;
 			interrupt-parent = <&liointc0>;
-			interrupts = <60 IRQ_TYPE_LEVEL_LOW>;
+			interrupts = <60 IRQ_TYPE_LEVEL_HIGH>;
 		};
 
 		uart0: serial@1fe00000 {
@@ -108,7 +108,7 @@ uart0: serial@1fe00000 {
 			reg = <0 0x1fe00000 0 0x8>;
 			clock-frequency = <125000000>;
 			interrupt-parent = <&liointc0>;
-			interrupts = <0 IRQ_TYPE_LEVEL_LOW>;
+			interrupts = <0 IRQ_TYPE_LEVEL_HIGH>;
 			no-loopback-test;
 		};
 
@@ -131,8 +131,8 @@ gmac@3,0 {
 						   "pciclass0c03";
 
 				reg = <0x1800 0x0 0x0 0x0 0x0>;
-				interrupts = <12 IRQ_TYPE_LEVEL_LOW>,
-					     <13 IRQ_TYPE_LEVEL_LOW>;
+				interrupts = <12 IRQ_TYPE_LEVEL_HIGH>,
+					     <13 IRQ_TYPE_LEVEL_HIGH>;
 				interrupt-names = "macirq", "eth_lpi";
 				interrupt-parent = <&liointc0>;
 				phy-mode = "rgmii-id";
@@ -155,8 +155,8 @@ gmac@3,1 {
 						   "loongson, pci-gmac";
 
 				reg = <0x1900 0x0 0x0 0x0 0x0>;
-				interrupts = <14 IRQ_TYPE_LEVEL_LOW>,
-					     <15 IRQ_TYPE_LEVEL_LOW>;
+				interrupts = <14 IRQ_TYPE_LEVEL_HIGH>,
+					     <15 IRQ_TYPE_LEVEL_HIGH>;
 				interrupt-names = "macirq", "eth_lpi";
 				interrupt-parent = <&liointc0>;
 				phy-mode = "rgmii-id";
@@ -178,7 +178,7 @@ ehci@4,1 {
 						   "pciclass0c03";
 
 				reg = <0x2100 0x0 0x0 0x0 0x0>;
-				interrupts = <18 IRQ_TYPE_LEVEL_LOW>;
+				interrupts = <18 IRQ_TYPE_LEVEL_HIGH>;
 				interrupt-parent = <&liointc1>;
 			};
 
@@ -189,7 +189,7 @@ ohci@4,2 {
 						   "pciclass0c03";
 
 				reg = <0x2200 0x0 0x0 0x0 0x0>;
-				interrupts = <19 IRQ_TYPE_LEVEL_LOW>;
+				interrupts = <19 IRQ_TYPE_LEVEL_HIGH>;
 				interrupt-parent = <&liointc1>;
 			};
 
@@ -200,7 +200,7 @@ sata@8,0 {
 						   "pciclass0106";
 
 				reg = <0x4000 0x0 0x0 0x0 0x0>;
-				interrupts = <19 IRQ_TYPE_LEVEL_LOW>;
+				interrupts = <19 IRQ_TYPE_LEVEL_HIGH>;
 				interrupt-parent = <&liointc0>;
 			};
 
@@ -215,10 +215,10 @@ pcie@9,0 {
 				#size-cells = <2>;
 				device_type = "pci";
 				#interrupt-cells = <1>;
-				interrupts = <0 IRQ_TYPE_LEVEL_LOW>;
+				interrupts = <0 IRQ_TYPE_LEVEL_HIGH>;
 				interrupt-parent = <&liointc1>;
 				interrupt-map-mask = <0 0 0 0>;
-				interrupt-map = <0 0 0 0 &liointc1 0 IRQ_TYPE_LEVEL_LOW>;
+				interrupt-map = <0 0 0 0 &liointc1 0 IRQ_TYPE_LEVEL_HIGH>;
 				ranges;
 				external-facing;
 			};
@@ -234,10 +234,10 @@ pcie@a,0 {
 				#size-cells = <2>;
 				device_type = "pci";
 				#interrupt-cells = <1>;
-				interrupts = <1 IRQ_TYPE_LEVEL_LOW>;
+				interrupts = <1 IRQ_TYPE_LEVEL_HIGH>;
 				interrupt-parent = <&liointc1>;
 				interrupt-map-mask = <0 0 0 0>;
-				interrupt-map = <0 0 0 0 &liointc1 1 IRQ_TYPE_LEVEL_LOW>;
+				interrupt-map = <0 0 0 0 &liointc1 1 IRQ_TYPE_LEVEL_HIGH>;
 				ranges;
 				external-facing;
 			};
@@ -253,10 +253,10 @@ pcie@b,0 {
 				#size-cells = <2>;
 				device_type = "pci";
 				#interrupt-cells = <1>;
-				interrupts = <2 IRQ_TYPE_LEVEL_LOW>;
+				interrupts = <2 IRQ_TYPE_LEVEL_HIGH>;
 				interrupt-parent = <&liointc1>;
 				interrupt-map-mask = <0 0 0 0>;
-				interrupt-map = <0 0 0 0 &liointc1 2 IRQ_TYPE_LEVEL_LOW>;
+				interrupt-map = <0 0 0 0 &liointc1 2 IRQ_TYPE_LEVEL_HIGH>;
 				ranges;
 				external-facing;
 			};
@@ -272,10 +272,10 @@ pcie@c,0 {
 				#size-cells = <2>;
 				device_type = "pci";
 				#interrupt-cells = <1>;
-				interrupts = <3 IRQ_TYPE_LEVEL_LOW>;
+				interrupts = <3 IRQ_TYPE_LEVEL_HIGH>;
 				interrupt-parent = <&liointc1>;
 				interrupt-map-mask = <0 0 0 0>;
-				interrupt-map = <0 0 0 0 &liointc1 3 IRQ_TYPE_LEVEL_LOW>;
+				interrupt-map = <0 0 0 0 &liointc1 3 IRQ_TYPE_LEVEL_HIGH>;
 				ranges;
 				external-facing;
 			};
@@ -291,10 +291,10 @@ pcie@d,0 {
 				#size-cells = <2>;
 				device_type = "pci";
 				#interrupt-cells = <1>;
-				interrupts = <4 IRQ_TYPE_LEVEL_LOW>;
+				interrupts = <4 IRQ_TYPE_LEVEL_HIGH>;
 				interrupt-parent = <&liointc1>;
 				interrupt-map-mask = <0 0 0 0>;
-				interrupt-map = <0 0 0 0 &liointc1 4 IRQ_TYPE_LEVEL_LOW>;
+				interrupt-map = <0 0 0 0 &liointc1 4 IRQ_TYPE_LEVEL_HIGH>;
 				ranges;
 				external-facing;
 			};
@@ -310,10 +310,10 @@ pcie@e,0 {
 				#size-cells = <2>;
 				device_type = "pci";
 				#interrupt-cells = <1>;
-				interrupts = <5 IRQ_TYPE_LEVEL_LOW>;
+				interrupts = <5 IRQ_TYPE_LEVEL_HIGH>;
 				interrupt-parent = <&liointc1>;
 				interrupt-map-mask = <0 0 0 0>;
-				interrupt-map = <0 0 0 0 &liointc1 5 IRQ_TYPE_LEVEL_LOW>;
+				interrupt-map = <0 0 0 0 &liointc1 5 IRQ_TYPE_LEVEL_HIGH>;
 				ranges;
 				external-facing;
 			};
-- 
2.43.0



