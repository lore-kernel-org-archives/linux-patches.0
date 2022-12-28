Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A236C1863
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 15:02:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2830BC433EF;
	Wed, 28 Dec 2022 15:02:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672239772;
	bh=NM7+/03/Ofmj9VSJlLDbfWwJTWwmxRfjZeorAgHJtnE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pO2meCd6deEg+3NYsauoavurdifztGsUjpX+HkYSV8JgGr+MApZuMISH6bTaTVuyv
	 lJqoBRSO8phqXkhjLdxhkaGDJTP845zdxMMJinrqwOW6R5dGubFc1iG6jRJPT2JZNM
	 AY6qOfV2rOFNcWOxa0xLTPUbnOIVWZ9B9axQdp84=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0041/1146] arm64: dts: renesas: r8a779f0: Fix SCIF "brg_int" clock
Date: Wed, 28 Dec 2022 15:26:20 +0100
Message-Id: <20221228144331.279576270@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Wolfram Sang <wsa+renesas@sang-engineering.com>

[ Upstream commit 64416ef0b0c4d73349035d1b3206eed3d2047ee0 ]

As serial communication requires a clean clock signal, the Serial
Communication Interfaces with FIFO (SCIF) are clocked by a clock that is
not affected by Spread Spectrum or Fractional Multiplication.

Hence change the clock input for the SCIF Baud Rate Generator internal
clock from the S0D3_PER clock to the SASYNCPERD1 clock (which has the
same clock rate), cfr. R-Car S4-8 Hardware User's Manual rev. 0.81.

Fixes: c62331e8222f ("arm64: dts: renesas: Add Renesas R8A779F0 SoC support")
Fixes: 40753144256b ("arm64: dts: renesas: r8a779f0: Add SCIF nodes")
Reported-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Link: https://lore.kernel.org/r/20221103143440.46449-5-wsa+renesas@sang-engineering.com
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/renesas/r8a779f0.dtsi | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/boot/dts/renesas/r8a779f0.dtsi b/arch/arm64/boot/dts/renesas/r8a779f0.dtsi
index 3be577dc9a93..4092c0016035 100644
--- a/arch/arm64/boot/dts/renesas/r8a779f0.dtsi
+++ b/arch/arm64/boot/dts/renesas/r8a779f0.dtsi
@@ -657,7 +657,7 @@ scif0: serial@e6e60000 {
 			reg = <0 0xe6e60000 0 64>;
 			interrupts = <GIC_SPI 249 IRQ_TYPE_LEVEL_HIGH>;
 			clocks = <&cpg CPG_MOD 702>,
-				 <&cpg CPG_CORE R8A779F0_CLK_S0D3_PER>,
+				 <&cpg CPG_CORE R8A779F0_CLK_SASYNCPERD1>,
 				 <&scif_clk>;
 			clock-names = "fck", "brg_int", "scif_clk";
 			dmas = <&dmac0 0x51>, <&dmac0 0x50>,
@@ -674,7 +674,7 @@ scif1: serial@e6e68000 {
 			reg = <0 0xe6e68000 0 64>;
 			interrupts = <GIC_SPI 250 IRQ_TYPE_LEVEL_HIGH>;
 			clocks = <&cpg CPG_MOD 703>,
-				 <&cpg CPG_CORE R8A779F0_CLK_S0D3_PER>,
+				 <&cpg CPG_CORE R8A779F0_CLK_SASYNCPERD1>,
 				 <&scif_clk>;
 			clock-names = "fck", "brg_int", "scif_clk";
 			dmas = <&dmac0 0x53>, <&dmac0 0x52>,
@@ -691,7 +691,7 @@ scif3: serial@e6c50000 {
 			reg = <0 0xe6c50000 0 64>;
 			interrupts = <GIC_SPI 252 IRQ_TYPE_LEVEL_HIGH>;
 			clocks = <&cpg CPG_MOD 704>,
-				 <&cpg CPG_CORE R8A779F0_CLK_S0D3_PER>,
+				 <&cpg CPG_CORE R8A779F0_CLK_SASYNCPERD1>,
 				 <&scif_clk>;
 			clock-names = "fck", "brg_int", "scif_clk";
 			dmas = <&dmac0 0x57>, <&dmac0 0x56>,
@@ -708,7 +708,7 @@ scif4: serial@e6c40000 {
 			reg = <0 0xe6c40000 0 64>;
 			interrupts = <GIC_SPI 253 IRQ_TYPE_LEVEL_HIGH>;
 			clocks = <&cpg CPG_MOD 705>,
-				 <&cpg CPG_CORE R8A779F0_CLK_S0D3_PER>,
+				 <&cpg CPG_CORE R8A779F0_CLK_SASYNCPERD1>,
 				 <&scif_clk>;
 			clock-names = "fck", "brg_int", "scif_clk";
 			dmas = <&dmac0 0x59>, <&dmac0 0x58>,
-- 
2.35.1



