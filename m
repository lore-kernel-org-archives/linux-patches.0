Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3073011703
	for <patches@lists.linux.dev>; Mon, 21 Aug 2023 19:56:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78040C433C7;
	Mon, 21 Aug 2023 19:56:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1692647794;
	bh=962olrkhxR8zvRZyjaLYihQ5Me6g+cM6ToYxfuij8hE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uw094H7KjTgJrVVF1YzO+vqxsDBL/MCNbZQiIB4T8TjKyZnKWUhIbPMWWTI6PBqVF
	 wJCkKfDAqyz1BGHg/P+yobRoarsVpQJ6adPCAGuwUiurtPmfVrSWUzp+H6/sFXDRq4
	 ZLPpXnp6xyXJG6M4esBJu//f6Yg2ui45XDzyNu+s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fabio Estevam <festevam@denx.de>,
	Marek Vasut <marex@denx.de>,
	Marco Felsch <m.felsch@pengutronix.de>,
	Adam Ford <aford173@gmail.com>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 141/194] arm64: dts: imx8mm: Drop CSI1 PHY reference clock configuration
Date: Mon, 21 Aug 2023 21:42:00 +0200
Message-ID: <20230821194128.897335637@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230821194122.695845670@linuxfoundation.org>
References: <20230821194122.695845670@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Fabio Estevam <festevam@denx.de>

[ Upstream commit f02b53375e8f14b4c27a14f6e4fb6e89914fdc29 ]

The CSI1 PHY reference clock is limited to 125 MHz according to:
i.MX 8M Mini Applications Processor Reference Manual, Rev. 3, 11/2020
Table 5-1. Clock Root Table (continued) / page 307
Slice Index n = 123 .

Currently the IMX8MM_CLK_CSI1_PHY_REF clock is configured to be
fed directly from 1 GHz PLL2 , which overclocks them. Instead, drop
the configuration altogether, which defaults the clock to 24 MHz REF
clock input, which for the PHY reference clock is just fine.

Based on a patch from Marek Vasut for the imx8mn.

Fixes: e523b7c54c05 ("arm64: dts: imx8mm: Add CSI nodes")
Signed-off-by: Fabio Estevam <festevam@denx.de>
Reviewed-by: Marek Vasut <marex@denx.de>
Reviewed-by: Marco Felsch <m.felsch@pengutronix.de>
Reviewed-by: Adam Ford <aford173@gmail.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx8mm.dtsi | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/boot/dts/freescale/imx8mm.dtsi b/arch/arm64/boot/dts/freescale/imx8mm.dtsi
index 420ba0d6f1343..12c82bb1bb7aa 100644
--- a/arch/arm64/boot/dts/freescale/imx8mm.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mm.dtsi
@@ -1145,10 +1145,9 @@
 				compatible = "fsl,imx8mm-mipi-csi2";
 				reg = <0x32e30000 0x1000>;
 				interrupts = <GIC_SPI 17 IRQ_TYPE_LEVEL_HIGH>;
-				assigned-clocks = <&clk IMX8MM_CLK_CSI1_CORE>,
-						  <&clk IMX8MM_CLK_CSI1_PHY_REF>;
-				assigned-clock-parents = <&clk IMX8MM_SYS_PLL2_1000M>,
-							  <&clk IMX8MM_SYS_PLL2_1000M>;
+				assigned-clocks = <&clk IMX8MM_CLK_CSI1_CORE>;
+				assigned-clock-parents = <&clk IMX8MM_SYS_PLL2_1000M>;
+
 				clock-frequency = <333000000>;
 				clocks = <&clk IMX8MM_CLK_DISP_APB_ROOT>,
 					 <&clk IMX8MM_CLK_CSI1_ROOT>,
-- 
2.40.1



