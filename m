Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BAD930C374;
	Mon, 13 Oct 2025 15:21:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760368916; cv=none; b=RKUemlF5+SePdDgN4cwH2EKoSaxmja4lLCOselbmdZHl33Y9yAXMAab8gDzrov8RnC4rvvJef1aoVsac7KZbj6ZhqIj9QT/zUK2eT8tXJ9M1tOtqMr+hq2gl3wKgtDfZgBHkDBptQ9ppgMtbQ7sZN8bPBQJFr2sbvdoB3NjSzEE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760368916; c=relaxed/simple;
	bh=MvsJh+uhTHGC3WrOsMHx8/cXqitLtHfwlEMvd2hLC+Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tBA77V8YEUPvweTeRwJqcN7tiTgBYSLWnichHEXIrCdeIcj00sDusKaaQ/G2xc18cr9RXXb+mibbcvYlU40/EwLxtqwqyb9nxjDqX2VOcKvlKSK7q0H2yxFuz/kIbmuiCHjkurnjakU0wdAxQCC6K+Wv9HLd5rk5A44+CyroNgM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HLkPUsZI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HLkPUsZI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0E16C4CEE7;
	Mon, 13 Oct 2025 15:21:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760368916;
	bh=MvsJh+uhTHGC3WrOsMHx8/cXqitLtHfwlEMvd2hLC+Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HLkPUsZIa53zcuBFWp1IMaMDiRdaZYzWDBvv5NcYUh9fOdLcY81G+C3DiQovAG0es
	 2VR8LBBUvGdFKHY+0GXYfNyWZTse6t560kTr9Ck6glJ/OmRNt8RYwtKenwW386ZknI
	 W0uLJoBLxEU3LyajCKATkDRk/IhCwLHVd8pMi/7U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joy Zou <joy.zou@nxp.com>,
	Peng Fan <peng.fan@nxp.com>,
	Frank Li <Frank.Li@nxp.com>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 064/563] arm64: dts: imx95: Correct the lpuart7 and lpuart8 srcid
Date: Mon, 13 Oct 2025 16:38:45 +0200
Message-ID: <20251013144413.608656816@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joy Zou <joy.zou@nxp.com>

[ Upstream commit 6fdaf3b1839c861931db0dd11747c056a76b68f9 ]

According to the imx95 RM, the lpuart7 rx and tx DMA's srcid are 88 and 87,
and the lpuart8 rx and tx DMA's srcid are 90 and 89. So correct them.

Fixes: 915fd2e127e8 ("arm64: dts: imx95: add edma[1..3] nodes")
Signed-off-by: Joy Zou <joy.zou@nxp.com>
Signed-off-by: Peng Fan <peng.fan@nxp.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx95.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/freescale/imx95.dtsi b/arch/arm64/boot/dts/freescale/imx95.dtsi
index 8296888bce594..4521da02d1695 100644
--- a/arch/arm64/boot/dts/freescale/imx95.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx95.dtsi
@@ -913,7 +913,7 @@ lpuart7: serial@42690000 {
 				interrupts = <GIC_SPI 68 IRQ_TYPE_LEVEL_HIGH>;
 				clocks = <&scmi_clk IMX95_CLK_LPUART7>;
 				clock-names = "ipg";
-				dmas = <&edma2 26 0 FSL_EDMA_RX>, <&edma2 25 0 0>;
+				dmas = <&edma2 88 0 FSL_EDMA_RX>, <&edma2 87 0 0>;
 				dma-names = "rx", "tx";
 				status = "disabled";
 			};
@@ -925,7 +925,7 @@ lpuart8: serial@426a0000 {
 				interrupts = <GIC_SPI 69 IRQ_TYPE_LEVEL_HIGH>;
 				clocks = <&scmi_clk IMX95_CLK_LPUART8>;
 				clock-names = "ipg";
-				dmas = <&edma2 28 0 FSL_EDMA_RX>, <&edma2 27 0 0>;
+				dmas = <&edma2 90 0 FSL_EDMA_RX>, <&edma2 89 0 0>;
 				dma-names = "rx", "tx";
 				status = "disabled";
 			};
-- 
2.51.0



