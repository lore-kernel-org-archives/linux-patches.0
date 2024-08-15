Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA9FA1714A1;
	Thu, 15 Aug 2024 13:56:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723730177; cv=none; b=aoftjercGHToAkp52/DHzSae5h/hXglqdh8zex7ZQSpm8y5Z0XfbSrnOzii/PzC7x97/uN7KiEfOtMIjWLHo+kZ08wsjxxMTiKeyAI3OKU7VF+eCHICgtoBXL9pWp3kMTczOAm1zjC+85xH8m67BGfg/rU7vnWS0sVXRsq/e2FU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723730177; c=relaxed/simple;
	bh=lCMnklAnMkNSaKxV2IIDH3k/WMraoEdWivccWiVd4jY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mMQ6J6I4ZQN3/+GL4a/kDpVpkm0GCJ+JY836IW+GfD+KM7+7VmwqI+mSVqwCFIgVNFPfXI3yQ9wXLiMB+UqOIr1p9uh3W5PmE0vRE/AvpU1tcLKmaUq4QY/twtIW/HrVYXlVvRz67JOYS8BUUx23Vu+gDbYEpp7lLGrvZJdXohw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sT87kbI5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sT87kbI5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 547BAC32786;
	Thu, 15 Aug 2024 13:56:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723730177;
	bh=lCMnklAnMkNSaKxV2IIDH3k/WMraoEdWivccWiVd4jY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sT87kbI54QEWbyu21J1Q/M8xMh4U5UeeAKAnYii2wUPSAUDYdaOoc7xGpB8ciN4N7
	 BnMXBbIi/4aRRVKN/ppFRN86fgxHG/rFukEb8l+FtteLFyP0UBp6jVYiotKDrh5vaJ
	 nmc5o8aQre0/IzQmfrUPxK02oBqWigRkuFCmq/kw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiaxun Yang <jiaxun.yang@flygoat.com>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 326/484] MIPS: dts: loongson: Fix liointc IRQ polarity
Date: Thu, 15 Aug 2024 15:23:04 +0200
Message-ID: <20240815131954.001077739@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131941.255804951@linuxfoundation.org>
References: <20240815131941.255804951@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 969e142584f28..6ad771768dae1 100644
--- a/arch/mips/boot/dts/loongson/loongson64-2k1000.dtsi
+++ b/arch/mips/boot/dts/loongson/loongson64-2k1000.dtsi
@@ -88,7 +88,7 @@ rtc0: rtc@1fe07800 {
 			compatible = "loongson,ls2k1000-rtc";
 			reg = <0 0x1fe07800 0 0x78>;
 			interrupt-parent = <&liointc0>;
-			interrupts = <60 IRQ_TYPE_LEVEL_LOW>;
+			interrupts = <60 IRQ_TYPE_LEVEL_HIGH>;
 		};
 
 		uart0: serial@1fe00000 {
@@ -96,7 +96,7 @@ uart0: serial@1fe00000 {
 			reg = <0 0x1fe00000 0 0x8>;
 			clock-frequency = <125000000>;
 			interrupt-parent = <&liointc0>;
-			interrupts = <0 IRQ_TYPE_LEVEL_LOW>;
+			interrupts = <0 IRQ_TYPE_LEVEL_HIGH>;
 			no-loopback-test;
 		};
 
@@ -119,8 +119,8 @@ gmac@3,0 {
 						   "pciclass0c03";
 
 				reg = <0x1800 0x0 0x0 0x0 0x0>;
-				interrupts = <12 IRQ_TYPE_LEVEL_LOW>,
-					     <13 IRQ_TYPE_LEVEL_LOW>;
+				interrupts = <12 IRQ_TYPE_LEVEL_HIGH>,
+					     <13 IRQ_TYPE_LEVEL_HIGH>;
 				interrupt-names = "macirq", "eth_lpi";
 				interrupt-parent = <&liointc0>;
 				phy-mode = "rgmii-id";
@@ -143,8 +143,8 @@ gmac@3,1 {
 						   "loongson, pci-gmac";
 
 				reg = <0x1900 0x0 0x0 0x0 0x0>;
-				interrupts = <14 IRQ_TYPE_LEVEL_LOW>,
-					     <15 IRQ_TYPE_LEVEL_LOW>;
+				interrupts = <14 IRQ_TYPE_LEVEL_HIGH>,
+					     <15 IRQ_TYPE_LEVEL_HIGH>;
 				interrupt-names = "macirq", "eth_lpi";
 				interrupt-parent = <&liointc0>;
 				phy-mode = "rgmii-id";
@@ -166,7 +166,7 @@ ehci@4,1 {
 						   "pciclass0c03";
 
 				reg = <0x2100 0x0 0x0 0x0 0x0>;
-				interrupts = <18 IRQ_TYPE_LEVEL_LOW>;
+				interrupts = <18 IRQ_TYPE_LEVEL_HIGH>;
 				interrupt-parent = <&liointc1>;
 			};
 
@@ -177,7 +177,7 @@ ohci@4,2 {
 						   "pciclass0c03";
 
 				reg = <0x2200 0x0 0x0 0x0 0x0>;
-				interrupts = <19 IRQ_TYPE_LEVEL_LOW>;
+				interrupts = <19 IRQ_TYPE_LEVEL_HIGH>;
 				interrupt-parent = <&liointc1>;
 			};
 
@@ -188,7 +188,7 @@ sata@8,0 {
 						   "pciclass0106";
 
 				reg = <0x4000 0x0 0x0 0x0 0x0>;
-				interrupts = <19 IRQ_TYPE_LEVEL_LOW>;
+				interrupts = <19 IRQ_TYPE_LEVEL_HIGH>;
 				interrupt-parent = <&liointc0>;
 			};
 
@@ -203,10 +203,10 @@ pcie@9,0 {
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
@@ -222,10 +222,10 @@ pcie@a,0 {
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
@@ -241,10 +241,10 @@ pcie@b,0 {
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
@@ -260,10 +260,10 @@ pcie@c,0 {
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
@@ -279,10 +279,10 @@ pcie@d,0 {
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
@@ -298,10 +298,10 @@ pcie@e,0 {
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



