Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0CDD34252D;
	Sat, 12 Sep 2026 07:33:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789198420; cv=none; b=dnMnhUkTAFQ3oRdvNRPjcpvD9qUgj0vBns4RakJvuhDS1pBJeWmGQ3ss1My8hcZYvbG7My0q/HbZvVd5LHT/o+YbuIgp2u1H6UssAgpUIrnhSdLjslMBNzJ+Baz4fiJK8exWYmVwbb39TgUSLEJHZGaGQVCFVhI7vU5CT2qZZbQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789198420; c=relaxed/simple;
	bh=gyEEoXq1dO0eeLfu8ZwAb+vh+lww+lXZQoVNXMgLrO8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MF/0O/obMeam4D3NPE1gPguQg9pVjBEYf729/x2V1ZgzZvESuO0XwCVQZisdOMxgH7axCQXpj5aSWGaGecSE29rLQg5h+jCnQJCqZjPUWROsfesH5gqO2oN54puebNblXanXEs3h/pVwv2SgNjuFBvBa2mNPos0CEXOpr6UpZfQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=adXKVWXO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="adXKVWXO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DF6E1F000FF;
	Sat, 12 Sep 2026 07:33:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789198418;
	bh=S0UG3nzRympwwmY4uUU9iG6Lqz1xXrIKlI2ILk6K18k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=adXKVWXOGdenAEVdo+AKnLqo1KGv2ZSWnhfu2JaAnIf7Ok2NDty4rkPIQfJdDal6k
	 pHTr6fr58vkIuxBxjjEw4qJTFCFW2BifzmdgrWRwyt8qcT5uzB9S7yhUhZBOxzl62N
	 l1URQv3VaA6EOVnkqmQLzVhu+JE/aoRT4W8haDSY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0377/1815] arm64: dts: renesas: rzt2h-n2h-evk: Remove unused MII/GMII pins
Date: Sat, 12 Sep 2026 08:35:27 +0200
Message-ID: <20260912065657.752437918@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>

[ Upstream commit c49ad13019771d5161290dc0eacb3ff6186c0953 ]

Remove the unused TXER, RXER, CRS, and COL pinmux configurations from the
gmac1 (ETH3) and gmac2 (ETH2) pin groups.

The Ethernet interfaces on both the RZ/T2H and RZ/N2H EVK boards operate
in RGMII mode, which does not utilize these extra MII/GMII sideband signal
pins. Update the board switch configuration comments to accurately reflect
the pin ranges that are actually in use.

Fixes: b272b94fd2239 ("arm64: dts: renesas: rzt2h-n2h-evk: Enable Ethernet support")
Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://patch.msgid.link/20260528134752.79813-2-prabhakar.mahadev-lad.rj@bp.renesas.com
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../boot/dts/renesas/r9a09g077m44-rzt2h-evk.dts   | 14 ++------------
 .../boot/dts/renesas/r9a09g087m44-rzn2h-evk.dts   | 15 ++-------------
 2 files changed, 4 insertions(+), 25 deletions(-)

diff --git a/arch/arm64/boot/dts/renesas/r9a09g077m44-rzt2h-evk.dts b/arch/arm64/boot/dts/renesas/r9a09g077m44-rzt2h-evk.dts
index e9ed2de128f6f..987e44d0bf957 100644
--- a/arch/arm64/boot/dts/renesas/r9a09g077m44-rzt2h-evk.dts
+++ b/arch/arm64/boot/dts/renesas/r9a09g077m44-rzt2h-evk.dts
@@ -256,8 +256,7 @@ can0_pins: can0-pins {
 	/*
 	 * GMAC1 Pin Configuration:
 	 *
-	 * SW2[8] ON - use pins P33_2-P33_7, P34_0-P34_5, P34_7 and
-	 * P35_0-P35_2 for Ethernet port 3
+	 * SW2[8] ON - use pins P33_2-P33_7 and P34_0-P34_5 for Ethernet port 3
 	 */
 	gmac1_pins: gmac1-pins {
 		pinmux = <RZT2H_PORT_PINMUX(33, 2, 0xf)>, /* ETH3_TXCLK */
@@ -272,10 +271,6 @@ gmac1_pins: gmac1-pins {
 			 <RZT2H_PORT_PINMUX(34, 3, 0xf)>, /* ETH3_RXD2 */
 			 <RZT2H_PORT_PINMUX(34, 4, 0xf)>, /* ETH3_RXD3 */
 			 <RZT2H_PORT_PINMUX(34, 5, 0xf)>, /* ETH3_RXDV */
-			 <RZT2H_PORT_PINMUX(34, 7, 0xf)>, /* ETH3_TXER */
-			 <RZT2H_PORT_PINMUX(35, 0, 0xf)>, /* ETH3_RXER */
-			 <RZT2H_PORT_PINMUX(35, 1, 0xf)>, /* ETH3_CRS */
-			 <RZT2H_PORT_PINMUX(35, 2, 0xf)>, /* ETH3_COL */
 			 <RZT2H_PORT_PINMUX(26, 1, 0x10)>, /* GMAC1_MDC */
 			 <RZT2H_PORT_PINMUX(26, 2, 0x10)>, /* GMAC1_MDIO */
 			 <RZT2H_PORT_PINMUX(34, 6, 0x2)>, /* ETH3_REFCLK */
@@ -286,8 +281,7 @@ gmac1_pins: gmac1-pins {
 	 * GMAC2 Pin Configuration:
 	 *
 	 * SW2[6] OFF - connect MDC/MDIO of Ethernet port 2 to GMAC2
-	 * SW2[7] ON - use pins P29_1-P29_7, P30_0-P30_4, and P31_2-P31_5
-	 * for Ethernet port 2
+	 * SW2[7] ON - use pins P29_1-P29_7 and P30_0-P30_4 for Ethernet port 2
 	 */
 	gmac2_pins: gmac2-pins {
 		pinmux = <RZT2H_PORT_PINMUX(29, 1, 0xf)>, /* ETH2_TXCLK */
@@ -302,10 +296,6 @@ gmac2_pins: gmac2-pins {
 			 <RZT2H_PORT_PINMUX(30, 2, 0xf)>, /* ETH2_RXD2 */
 			 <RZT2H_PORT_PINMUX(30, 3, 0xf)>, /* ETH2_RXD3 */
 			 <RZT2H_PORT_PINMUX(30, 4, 0xf)>, /* ETH2_RXDV */
-			 <RZT2H_PORT_PINMUX(31, 2, 0xf)>, /* ETH2_TXER */
-			 <RZT2H_PORT_PINMUX(31, 3, 0xf)>, /* ETH2_RXER */
-			 <RZT2H_PORT_PINMUX(31, 4, 0xf)>, /* ETH2_CRS */
-			 <RZT2H_PORT_PINMUX(31, 5, 0xf)>, /* ETH2_COL */
 			 <RZT2H_PORT_PINMUX(30, 5, 0x10)>, /* GMAC2_MDC */
 			 <RZT2H_PORT_PINMUX(30, 6, 0x10)>, /* GMAC2_MDIO */
 			 <RZT2H_PORT_PINMUX(31, 0, 0x2)>, /* ETH2_REFCLK */
diff --git a/arch/arm64/boot/dts/renesas/r9a09g087m44-rzn2h-evk.dts b/arch/arm64/boot/dts/renesas/r9a09g087m44-rzn2h-evk.dts
index ef6cc7497c2c4..a66502d8d82bd 100644
--- a/arch/arm64/boot/dts/renesas/r9a09g087m44-rzn2h-evk.dts
+++ b/arch/arm64/boot/dts/renesas/r9a09g087m44-rzn2h-evk.dts
@@ -339,9 +339,7 @@ can1_pins: can1-pins {
 	/*
 	 * GMAC1 Pin Configuration:
 	 *
-	 * DSW5[8] ON - use pins P00_0-P00_2, P33_2-P33_7, P34_0-P34_6
-	 * for Ethernet port 3
-	 * DSW12[1] OFF; DSW12[2] ON - use pin P00_3 for Ethernet port 3
+	 * DSW5[8] ON - use pins P33_2-P33_7 and P34_0-P34_6 for Ethernet port 3
 	 */
 	gmac1_pins: gmac1-pins {
 		pinmux = <RZT2H_PORT_PINMUX(33, 2, 0xf)>, /* ETH3_TXCLK */
@@ -356,10 +354,6 @@ gmac1_pins: gmac1-pins {
 			 <RZT2H_PORT_PINMUX(34, 3, 0xf)>, /* ETH3_RXD2 */
 			 <RZT2H_PORT_PINMUX(34, 4, 0xf)>, /* ETH3_RXD3 */
 			 <RZT2H_PORT_PINMUX(34, 5, 0xf)>, /* ETH3_RXDV */
-			 <RZT2H_PORT_PINMUX(0, 0, 0xf)>, /* ETH3_TXER */
-			 <RZT2H_PORT_PINMUX(0, 1, 0xf)>, /* ETH3_RXER */
-			 <RZT2H_PORT_PINMUX(0, 2, 0xf)>, /* ETH3_CRS */
-			 <RZT2H_PORT_PINMUX(0, 3, 0xf)>, /* ETH3_COL */
 			 <RZT2H_PORT_PINMUX(26, 1, 0x10)>, /* GMAC1_MDC */
 			 <RZT2H_PORT_PINMUX(26, 2, 0x10)>, /* GMAC1_MDIO */
 			 <RZT2H_PORT_PINMUX(34, 6, 0x2)>, /* ETH3_REFCLK */
@@ -370,8 +364,7 @@ gmac1_pins: gmac1-pins {
 	 * GMAC2 Pin Configuration:
 	 *
 	 * DSW5[6] OFF - connect MDC/MDIO of Ethernet port 2 to GMAC2
-	 * DSW5[7] ON - use pins P29_1-P29_7, P30_0-P30_4, P30_7,
-	 * P31_2, P31_4 and P31_5 are used for Ethernet port 2
+	 * DSW5[7] ON - use pins P29_1-P29_7 and P30_0-P30_4 for Ethernet port 2
 	 * DSW13[7] OFF; DSW13[8] ON - use pin P13_7 for IRQ14
 	 */
 	gmac2_pins: gmac2-pins {
@@ -387,10 +380,6 @@ gmac2_pins: gmac2-pins {
 			 <RZT2H_PORT_PINMUX(30, 2, 0xf)>, /* ETH2_RXD2 */
 			 <RZT2H_PORT_PINMUX(30, 3, 0xf)>, /* ETH2_RXD3 */
 			 <RZT2H_PORT_PINMUX(30, 4, 0xf)>, /* ETH2_RXDV */
-			 <RZT2H_PORT_PINMUX(31, 2, 0xf)>, /* ETH2_TXER */
-			 <RZT2H_PORT_PINMUX(31, 1, 0xf)>, /* ETH2_RXER */
-			 <RZT2H_PORT_PINMUX(31, 4, 0xf)>, /* ETH2_CRS */
-			 <RZT2H_PORT_PINMUX(31, 5, 0xf)>, /* ETH2_COL */
 			 <RZT2H_PORT_PINMUX(30, 5, 0x10)>, /* GMAC2_MDC */
 			 <RZT2H_PORT_PINMUX(30, 6, 0x10)>, /* GMAC2_MDIO */
 			 <RZT2H_PORT_PINMUX(31, 0, 0x2)>, /* ETH2_REFCLK */
-- 
2.53.0



