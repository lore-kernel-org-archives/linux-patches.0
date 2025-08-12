Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8312D2F4A0A;
	Tue, 12 Aug 2025 18:32:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755023542; cv=none; b=USGXdfH9k2J+7iDz1mdH2Q82U3y6TJuVccUTxXEa9Vw92j+AaQocmxkaeT8t8E26DuP1x7asaF958xGJXve/8W/5da7hdLmCmONgRXs1c24HU/y66XeYRGLnazWy9eXJtdMNjm8owlYcG5O3s+Vsclep1tNqDUUW9ge6WNEWOks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755023542; c=relaxed/simple;
	bh=Hq+3MPcyeoA8DKrLphVrU5aSCzNOKRa14cYJoSiMoA4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cB7Hi4DI400ekTgZP7C91iH4kmTMs29Z/XF8Uqp385VG+oD0XYJmsfYpEeDPNfNp8tWumtg89awqZG62mRr5uGyMwfWoFdkSs9HcqVlPiL/HbthCIvlVUPHfrdaxiAESAeQ+JZYx7l+RkTb/SHIulqh9G+mzZg4kbnp+V7dowU8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2CF6fCSS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2CF6fCSS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6C78C4CEF6;
	Tue, 12 Aug 2025 18:32:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755023542;
	bh=Hq+3MPcyeoA8DKrLphVrU5aSCzNOKRa14cYJoSiMoA4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2CF6fCSSidpLrocF9Mtoo9Cv6QZCr2/TDdhBMqeeeUrc9HKVKlHYuHzKUasXehR9s
	 Q/JBlGwNrhWeyhc3iLNRArIjujge5dh22M5SUDVF+5LJX2tjKY4agR2MLFKWVmb+sk
	 +XbcEz5uLh8JotnbTJLRYwasEOM6NSIaA2AA8LeE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonas Karlman <jonas@kwiboo.se>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 111/627] arm64: dts: rockchip: Fix UART DMA support for RK3528
Date: Tue, 12 Aug 2025 19:26:46 +0200
Message-ID: <20250812173423.534508943@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jonas Karlman <jonas@kwiboo.se>

[ Upstream commit ae019f0bdfbef3e0671e7b954321e92fc24c7e54 ]

Trying to use UART2 DMA for Bluetooth on ArmSoM Sige1 result in tx
timeout when using dma-names = "tx", "rx" as required by the dt-binding:

  Bluetooth: hci0: command 0x0c03 tx timeout
  Bluetooth: hci0: BCM: Reset failed (-110)

Change the dmas order to fix UART DMA support on RK3528.

With this fixed Bluetooth can be loaded using DMA on ArmSoM Sige1:

  Bluetooth: hci0: BCM: chip id 159
  Bluetooth: hci0: BCM: features 0x0f
  Bluetooth: hci0: BCM4362A2
  Bluetooth: hci0: BCM4362A2 (000.017.017) build 0000
  Bluetooth: hci0: BCM4362A2 'brcm/BCM4362A2.hcd' Patch
  Bluetooth: hci0: BCM: features 0x0f
  Bluetooth: hci0: BCM43752A2 UART 37.4MHz Ampak AP6398 sLNA iLNA CL1 [Version: 1091.1173]
  Bluetooth: hci0: BCM4362A2 (000.017.017) build 1173

Fixes: ab6fcb58aedf ("arm64: dts: rockchip: Add UART DMA support for RK3528")
Signed-off-by: Jonas Karlman <jonas@kwiboo.se>
Link: https://lore.kernel.org/r/20250709210831.3170458-1-jonas@kwiboo.se
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/rk3528.dtsi | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/boot/dts/rockchip/rk3528.dtsi b/arch/arm64/boot/dts/rockchip/rk3528.dtsi
index d1c72b52aa4e..7f78409cb558 100644
--- a/arch/arm64/boot/dts/rockchip/rk3528.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3528.dtsi
@@ -445,7 +445,7 @@ uart0: serial@ff9f0000 {
 			clocks = <&cru SCLK_UART0>, <&cru PCLK_UART0>;
 			clock-names = "baudclk", "apb_pclk";
 			interrupts = <GIC_SPI 40 IRQ_TYPE_LEVEL_HIGH>;
-			dmas = <&dmac 8>, <&dmac 9>;
+			dmas = <&dmac 9>, <&dmac 8>;
 			reg-io-width = <4>;
 			reg-shift = <2>;
 			status = "disabled";
@@ -457,7 +457,7 @@ uart1: serial@ff9f8000 {
 			clocks = <&cru SCLK_UART1>, <&cru PCLK_UART1>;
 			clock-names = "baudclk", "apb_pclk";
 			interrupts = <GIC_SPI 41 IRQ_TYPE_LEVEL_HIGH>;
-			dmas = <&dmac 10>, <&dmac 11>;
+			dmas = <&dmac 11>, <&dmac 10>;
 			reg-io-width = <4>;
 			reg-shift = <2>;
 			status = "disabled";
@@ -469,7 +469,7 @@ uart2: serial@ffa00000 {
 			clocks = <&cru SCLK_UART2>, <&cru PCLK_UART2>;
 			clock-names = "baudclk", "apb_pclk";
 			interrupts = <GIC_SPI 42 IRQ_TYPE_LEVEL_HIGH>;
-			dmas = <&dmac 12>, <&dmac 13>;
+			dmas = <&dmac 13>, <&dmac 12>;
 			reg-io-width = <4>;
 			reg-shift = <2>;
 			status = "disabled";
@@ -481,7 +481,7 @@ uart3: serial@ffa08000 {
 			clocks = <&cru SCLK_UART3>, <&cru PCLK_UART3>;
 			clock-names = "baudclk", "apb_pclk";
 			interrupts = <GIC_SPI 43 IRQ_TYPE_LEVEL_HIGH>;
-			dmas = <&dmac 14>, <&dmac 15>;
+			dmas = <&dmac 15>, <&dmac 14>;
 			reg-io-width = <4>;
 			reg-shift = <2>;
 			status = "disabled";
@@ -493,7 +493,7 @@ uart4: serial@ffa10000 {
 			clocks = <&cru SCLK_UART4>, <&cru PCLK_UART4>;
 			clock-names = "baudclk", "apb_pclk";
 			interrupts = <GIC_SPI 44 IRQ_TYPE_LEVEL_HIGH>;
-			dmas = <&dmac 16>, <&dmac 17>;
+			dmas = <&dmac 17>, <&dmac 16>;
 			reg-io-width = <4>;
 			reg-shift = <2>;
 			status = "disabled";
@@ -505,7 +505,7 @@ uart5: serial@ffa18000 {
 			clocks = <&cru SCLK_UART5>, <&cru PCLK_UART5>;
 			clock-names = "baudclk", "apb_pclk";
 			interrupts = <GIC_SPI 45 IRQ_TYPE_LEVEL_HIGH>;
-			dmas = <&dmac 18>, <&dmac 19>;
+			dmas = <&dmac 19>, <&dmac 18>;
 			reg-io-width = <4>;
 			reg-shift = <2>;
 			status = "disabled";
@@ -517,7 +517,7 @@ uart6: serial@ffa20000 {
 			clocks = <&cru SCLK_UART6>, <&cru PCLK_UART6>;
 			clock-names = "baudclk", "apb_pclk";
 			interrupts = <GIC_SPI 46 IRQ_TYPE_LEVEL_HIGH>;
-			dmas = <&dmac 20>, <&dmac 21>;
+			dmas = <&dmac 21>, <&dmac 20>;
 			reg-io-width = <4>;
 			reg-shift = <2>;
 			status = "disabled";
@@ -529,7 +529,7 @@ uart7: serial@ffa28000 {
 			clocks = <&cru SCLK_UART7>, <&cru PCLK_UART7>;
 			clock-names = "baudclk", "apb_pclk";
 			interrupts = <GIC_SPI 47 IRQ_TYPE_LEVEL_HIGH>;
-			dmas = <&dmac 22>, <&dmac 23>;
+			dmas = <&dmac 23>, <&dmac 22>;
 			reg-io-width = <4>;
 			reg-shift = <2>;
 			status = "disabled";
-- 
2.39.5



