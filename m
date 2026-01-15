Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73D063BF2EF;
	Thu, 15 Jan 2026 16:55:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768496120; cv=none; b=dc0CuJ8Zpajtp4sJGm66Jsn8hXnteC6/YiMqGa0stx78qVCEQat1bVD8D9Qx/luDKOgF8dQdv0FexZyUq5lXXC80fn8XjVWcVfMS7ox/JTA1J2Au8pxM6PFPz5qyH7rbx2MEOeudPEd6xJkNCxHLT46p4bkoK6TE1sIZYCPvg8c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768496120; c=relaxed/simple;
	bh=FNqC3S33neonoHjP5hUyNEs2CgxgkzGj1gwxgWn0LLc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MES3BGLFLpZpFrP7u4Mfiw0W2jJ5BQ2I2N8cSnfQJnrt/A1dS04lp+iqbXgh1g2oZvU7s0qEZapS6sErj83efU1t+imn0eNyDYjkKkBgF4GcQ04nqKsqd+rYXQD92VFHHa+qEnTit0Uxa9GNVOQiAOTkKOYaPPWnJMDdWGbl7HM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KCCAtZpe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KCCAtZpe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9996EC116D0;
	Thu, 15 Jan 2026 16:55:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768496120;
	bh=FNqC3S33neonoHjP5hUyNEs2CgxgkzGj1gwxgWn0LLc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KCCAtZpe6x6WbJphNeWnu9BlL4FgF6vtRSz/KiH6CN7oxdMEbebWSf1vRRels0FS/
	 cCqXOvL1jC7lkEKrK84WeRxLnohaiQG5Yddn+C4Wm8w69yBvDvDBC0eQbZVWPBOqmS
	 Kt5+EQAGU0Shx8KN0QCivS/qeYFgs2ksWgfPwJNE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sherry Sun <sherry.sun@nxp.com>,
	Frank Li <Frank.Li@nxp.com>,
	Alexander Stein <alexander.stein@ew.tq-group.com>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 085/181] arm64: dts: imx8qm-ss-dma: correct the dma channels of lpuart
Date: Thu, 15 Jan 2026 17:47:02 +0100
Message-ID: <20260115164205.394114669@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164202.305475649@linuxfoundation.org>
References: <20260115164202.305475649@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sherry Sun <sherry.sun@nxp.com>

[ Upstream commit a988caeed9d918452aa0a68de2c6e94d86aa43ba ]

The commit 616effc0272b5 ("arm64: dts: imx8: Fix lpuart DMA channel
order") swap uart rx and tx channel at common imx8-ss-dma.dtsi. But miss
update imx8qm-ss-dma.dtsi.

The commit 5a8e9b022e569 ("arm64: dts: imx8qm-ss-dma: Pass lpuart
dma-names") just simple add dma-names as binding doc requirement.

Correct lpuart0 - lpuart3 dma rx and tx channels, and use defines for
the FSL_EDMA_RX flag.

Fixes: 5a8e9b022e56 ("arm64: dts: imx8qm-ss-dma: Pass lpuart dma-names")
Signed-off-by: Sherry Sun <sherry.sun@nxp.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Reviewed-by: Alexander Stein <alexander.stein@ew.tq-group.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx8qm-ss-dma.dtsi | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/boot/dts/freescale/imx8qm-ss-dma.dtsi b/arch/arm64/boot/dts/freescale/imx8qm-ss-dma.dtsi
index d4856b8590e0c..e186c31bfd482 100644
--- a/arch/arm64/boot/dts/freescale/imx8qm-ss-dma.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8qm-ss-dma.dtsi
@@ -171,25 +171,25 @@ &flexcan3 {
 
 &lpuart0 {
 	compatible = "fsl,imx8qm-lpuart", "fsl,imx8qxp-lpuart";
-	dmas = <&edma2 13 0 0>, <&edma2 12 0 1>;
+	dmas = <&edma2 12 0 FSL_EDMA_RX>, <&edma2 13 0 0>;
 	dma-names = "rx","tx";
 };
 
 &lpuart1 {
 	compatible = "fsl,imx8qm-lpuart", "fsl,imx8qxp-lpuart";
-	dmas = <&edma2 15 0 0>, <&edma2 14 0 1>;
+	dmas = <&edma2 14 0 FSL_EDMA_RX>, <&edma2 15 0 0>;
 	dma-names = "rx","tx";
 };
 
 &lpuart2 {
 	compatible = "fsl,imx8qm-lpuart", "fsl,imx8qxp-lpuart";
-	dmas = <&edma2 17 0 0>, <&edma2 16 0 1>;
+	dmas = <&edma2 16 0 FSL_EDMA_RX>, <&edma2 17 0 0>;
 	dma-names = "rx","tx";
 };
 
 &lpuart3 {
 	compatible = "fsl,imx8qm-lpuart", "fsl,imx8qxp-lpuart";
-	dmas = <&edma2 19 0 0>, <&edma2 18 0 1>;
+	dmas = <&edma2 18 0 FSL_EDMA_RX>, <&edma2 19 0 0>;
 	dma-names = "rx","tx";
 };
 
-- 
2.51.0



