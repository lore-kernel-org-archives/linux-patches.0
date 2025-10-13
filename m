Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8F26310647;
	Mon, 13 Oct 2025 15:07:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760368064; cv=none; b=G1G+1NS/mMgDK1eFJ8Sl1cnkiUVT3GciLf9q1rrIFYTocWYIgqHUu5DsLj9/ESEYJadYCBMCV+fW8fXHMqklJosHg3LV48fGKItrhNO5HdAR0uy6gvlEFOKJP+jXd3uvcu52Z7mtDY6RRBwIXC7kBT8AHDv0ohgBceNcjEkNFw4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760368064; c=relaxed/simple;
	bh=QKMRw0exnscM1HOXI4E66Jr0Fg94jPioH3jr9XL7T84=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qc/yWlRR2H5x+YPI1MPV6Fa0W583A8gh/z4jg+3rDDQJGR8F5ItU1VoGuOhdeXYqshlOiQ84+gHF4x0Nr5/Xp/WzB1upXlv8b8hxa1JVauD0EciUDsM0HJcHcpBNkN3uhKBvaecWFG1WpfrTbQceQiBlihTXzzQeLh+NB5f/R0o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dUhYjyQ/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dUhYjyQ/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46755C4CEE7;
	Mon, 13 Oct 2025 15:07:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760368064;
	bh=QKMRw0exnscM1HOXI4E66Jr0Fg94jPioH3jr9XL7T84=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dUhYjyQ/wJm8iD4LSdgAh8YWo8sfIPwH61StLR4CVT+xmHCiXp+Q2328DnIuBsV2L
	 dyvtPq87jGYH3UkdZBdJ5qdc+VxjA5J8LCl4PPexpKpEVT9g4bRV8BsqoRgPDAh7mG
	 6h6C4BpOBEHRmvGBuMw5biBkJZgjyIdBhTW7Hx1U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joy Zou <joy.zou@nxp.com>,
	Peng Fan <peng.fan@nxp.com>,
	Frank Li <Frank.Li@nxp.com>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 030/262] arm64: dts: imx95: Correct the lpuart7 and lpuart8 srcid
Date: Mon, 13 Oct 2025 16:42:52 +0200
Message-ID: <20251013144327.218597090@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144326.116493600@linuxfoundation.org>
References: <20251013144326.116493600@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 7365d6538a733..ddbc94c375e0c 100644
--- a/arch/arm64/boot/dts/freescale/imx95.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx95.dtsi
@@ -822,7 +822,7 @@ lpuart7: serial@42690000 {
 				interrupts = <GIC_SPI 68 IRQ_TYPE_LEVEL_HIGH>;
 				clocks = <&scmi_clk IMX95_CLK_LPUART7>;
 				clock-names = "ipg";
-				dmas = <&edma2 26 0 FSL_EDMA_RX>, <&edma2 25 0 0>;
+				dmas = <&edma2 88 0 FSL_EDMA_RX>, <&edma2 87 0 0>;
 				dma-names = "rx", "tx";
 				status = "disabled";
 			};
@@ -834,7 +834,7 @@ lpuart8: serial@426a0000 {
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



