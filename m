Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08DFB4F218;
	Thu, 12 Dec 2024 15:34:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734017658; cv=none; b=k5n+y2Uz2ljCqGJcM0RLZOuxLwafn2D0As6l1RymBRgvFT9aSISAdMNUNTXw7winMJFXIH0UcRBCPP7u6/X/Ik49AGrufRRsurfQRIv05fwbwUNf2DJejAsv10O4Tny/dZojHzafuSg1atwjpVQjjKC/TJ+2bjU0LMCs0NQD5CU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734017658; c=relaxed/simple;
	bh=JWKkrGywqFocVhK7AiOt+ybllWMiq8uyw3uJAZ74t90=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MG7xomah28wYIbyHHLcXGWAV5jqJvCSPQyoz5QIsGjoQncBKIte1XT/X37fLVQuqynvG9YGaT79t1dg9O0JWQtDMhUln9qg4rhKcd2UpF6/lZEPKZOsYG1hb2ldi2McKPlV3m8DNNzc0M3bSyvhceO2hsty1hAQlwMcth1eszAo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eYYwfI1U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eYYwfI1U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AD21C4CECE;
	Thu, 12 Dec 2024 15:34:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734017657;
	bh=JWKkrGywqFocVhK7AiOt+ybllWMiq8uyw3uJAZ74t90=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eYYwfI1Uqut0Fb8ZPua2GpCPJ3rXzYVK3uyhF9nBR+gfx0+pWjhX/89sLdlhNAlNZ
	 r3K3uLxG0+dCmi2enwitIwSKhZ8PoNzCD9OwqsOkUPvTtd75pVnh7uv7JySwGzAJJT
	 WN3JH4tyk+ZpSursI4vVew/q1dlB/J1k9U6MenII=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Herve Codina <herve.codina@bootlin.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 075/356] soc: fsl: cpm1: qmc: Fix blank line and spaces
Date: Thu, 12 Dec 2024 15:56:34 +0100
Message-ID: <20241212144247.591135851@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144244.601729511@linuxfoundation.org>
References: <20241212144244.601729511@linuxfoundation.org>
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

From: Herve Codina <herve.codina@bootlin.com>

[ Upstream commit f06ab938bcddcb3c3a0b458b03a827c701919c9e ]

checkpatch.pl raises the following issues
  CHECK: Please don't use multiple blank lines
  CHECK: Alignment should match open parenthesis

Fix them.

Signed-off-by: Herve Codina <herve.codina@bootlin.com>
Reviewed-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Link: https://lore.kernel.org/r/20240808071132.149251-20-herve.codina@bootlin.com
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Stable-dep-of: cb3daa51db81 ("soc: fsl: cpm1: qmc: Set the ret error code on platform_get_irq() failure")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/fsl/qe/qmc.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/soc/fsl/qe/qmc.c b/drivers/soc/fsl/qe/qmc.c
index 2312152a44b3e..f22d1d85d1021 100644
--- a/drivers/soc/fsl/qe/qmc.c
+++ b/drivers/soc/fsl/qe/qmc.c
@@ -253,7 +253,6 @@ static inline void qmc_setbits32(void __iomem *addr, u32 set)
 	qmc_write32(addr, qmc_read32(addr) | set);
 }
 
-
 int qmc_chan_get_info(struct qmc_chan *chan, struct qmc_chan_info *info)
 {
 	struct tsa_serial_info tsa_info;
@@ -1093,7 +1092,7 @@ static int qmc_setup_chan(struct qmc *qmc, struct qmc_chan *chan)
 		qmc_write32(chan->s_param + QMC_SPE_ZDSTATE, 0x00000080);
 		qmc_write16(chan->s_param + QMC_SPE_MFLR, 60);
 		qmc_write16(chan->s_param + QMC_SPE_CHAMR,
-			QMC_SPE_CHAMR_MODE_HDLC | QMC_SPE_CHAMR_HDLC_IDLM);
+			    QMC_SPE_CHAMR_MODE_HDLC | QMC_SPE_CHAMR_HDLC_IDLM);
 	}
 
 	/* Do not enable interrupts now. They will be enabled later */
@@ -1286,7 +1285,6 @@ static int qmc_probe(struct platform_device *pdev)
 	if (IS_ERR(qmc->scc_regs))
 		return PTR_ERR(qmc->scc_regs);
 
-
 	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "scc_pram");
 	if (!res)
 		return -EINVAL;
@@ -1332,7 +1330,7 @@ static int qmc_probe(struct platform_device *pdev)
 	 */
 	qmc->bd_size = (nb_chans * (QMC_NB_TXBDS + QMC_NB_RXBDS)) * sizeof(cbd_t);
 	qmc->bd_table = dmam_alloc_coherent(qmc->dev, qmc->bd_size,
-		&qmc->bd_dma_addr, GFP_KERNEL);
+					    &qmc->bd_dma_addr, GFP_KERNEL);
 	if (!qmc->bd_table) {
 		dev_err(qmc->dev, "Failed to allocate bd table\n");
 		ret = -ENOMEM;
@@ -1345,7 +1343,7 @@ static int qmc_probe(struct platform_device *pdev)
 	/* Allocate the interrupt table */
 	qmc->int_size = QMC_NB_INTS * sizeof(u16);
 	qmc->int_table = dmam_alloc_coherent(qmc->dev, qmc->int_size,
-		&qmc->int_dma_addr, GFP_KERNEL);
+					     &qmc->int_dma_addr, GFP_KERNEL);
 	if (!qmc->int_table) {
 		dev_err(qmc->dev, "Failed to allocate interrupt table\n");
 		ret = -ENOMEM;
@@ -1393,7 +1391,7 @@ static int qmc_probe(struct platform_device *pdev)
 
 	/* Enable interrupts */
 	qmc_write16(qmc->scc_regs + SCC_SCCM,
-		SCC_SCCE_IQOV | SCC_SCCE_GINT | SCC_SCCE_GUN | SCC_SCCE_GOV);
+		    SCC_SCCE_IQOV | SCC_SCCE_GINT | SCC_SCCE_GUN | SCC_SCCE_GOV);
 
 	ret = qmc_finalize_chans(qmc);
 	if (ret < 0)
-- 
2.43.0



