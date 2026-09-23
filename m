Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 598E6535FBB;
	Wed, 23 Sep 2026 14:40:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790174432; cv=none; b=uUP5PmoK6JA1c6so4lyFXn4RVd9PzcSuDI3VCq9weA89sYrW31q6vHC1wpeXwnpjsTF7Pw4O2L8nicQoHdQv0lSIbDl4LKTAV+qBAGuWNj+ijamG23Hd7sB/G3CW8sq1juvJ11BByN6+x9Tc3BAOyNnab/xHHskjZC/3d7P3cK0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790174432; c=relaxed/simple;
	bh=BdVX4HxdrDTk49EDFgXTNiZbIv9+pq/2XkwqhrIUtOM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H32Kcl/v67x9t/xERpI5ZbFS1RwSx3vUD3eS1AuKxL91PRBoaZt56G1r4Ec6frioGrslLRt598OZ1+8v9wHj84ah6EChfG9YKWUSQ4F4yKF/NghGZoFyRKAgNfM2tz4vpq+/oYPEugeoklOfiSLc9XKfwgBvkEwwAYU1tVe6Ngc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1bnc0d8B; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1bnc0d8B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B165B1F000FF;
	Wed, 23 Sep 2026 14:40:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790174431;
	bh=BBGEd9F0xcIc7cq3MDLCN3nQGnNCq2+50K6DLcm59J8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1bnc0d8BaNf7qFjiOq0NzkW45DQBkOOOsnNX6Rk1PEaQRXqH/eGsoVfv1D86xctsx
	 D9FYxPJvTcnOA9cWNuJWJc5H4iX1Y+SbrE62VmtvrytEmUe5UlmnhNGtW3+iQcwrxY
	 AxcyOL+BIWtucotIp3jpvBQZ/bsWxDhiGc6qikoA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gabor Juhos <j4g8y7@gmail.com>,
	Md Sadre Alam <md.alam@oss.qualcomm.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 113/398] spi: spi-qpic-snand: avoid writing QPIC_EBI2_ECC_BUF_CFG register
Date: Wed, 23 Sep 2026 16:03:07 +0200
Message-ID: <20260923140646.374163564@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140643.441954610@linuxfoundation.org>
References: <20260923140643.441954610@linuxfoundation.org>
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

From: Gabor Juhos <j4g8y7@gmail.com>

[ Upstream commit 930a7312c946bf4731721cadd82bb9a2ada496ca ]

The description of commit bfb34eced559 ("mtd: rawnand: qcom: avoid writing
to obsolete register") says this:

  "QPIC_EBI2_ECC_BUF_CFG register got obsolete from QPIC V2.0 onwards.
  Avoid writing this register if QPIC version is V2.0 or newer."

Although the referenced commit is related to the 'qcom-nandc' driver,
however the hardware supported by the current driver is also based on
QPIC v2.0 so we should avoid writing that register here as well.

Remove the register writing code to avoid undefined behaviour.

Fixes: 7304d1909080 ("spi: spi-qpic: add driver for QCOM SPI NAND flash Interface")
Signed-off-by: Gabor Juhos <j4g8y7@gmail.com>
Reviewed-by: Md Sadre Alam <md.alam@oss.qualcomm.com>
Link: https://patch.msgid.link/20260909-qpic-snand-avoid-ebi2-reg-write-v1-1-9b1b1466cc75@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-qpic-snand.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/spi/spi-qpic-snand.c b/drivers/spi/spi-qpic-snand.c
index 42f8fb272fa68..222e4aa7ee488 100644
--- a/drivers/spi/spi-qpic-snand.c
+++ b/drivers/spi/spi-qpic-snand.c
@@ -740,8 +740,6 @@ static int qcom_spi_read_cw_raw(struct qcom_nand_controller *snandc, u8 *data_bu
 
 	qcom_write_reg_dma(snandc, &snandc->regs->addr0, NAND_ADDR0, 2, 0);
 	qcom_write_reg_dma(snandc, &snandc->regs->cfg0, NAND_DEV0_CFG0, 3, 0);
-	qcom_write_reg_dma(snandc, &snandc->regs->ecc_buf_cfg, NAND_EBI2_ECC_BUF_CFG, 1, 0);
-
 	qcom_write_reg_dma(snandc, &snandc->regs->erased_cw_detect_cfg_clr,
 			   NAND_ERASED_CW_DETECT_CFG, 1, 0);
 	qcom_write_reg_dma(snandc, &snandc->regs->erased_cw_detect_cfg_set,
@@ -1012,8 +1010,6 @@ static void qcom_spi_config_page_write(struct qcom_nand_controller *snandc)
 {
 	qcom_write_reg_dma(snandc, &snandc->regs->addr0, NAND_ADDR0, 2, 0);
 	qcom_write_reg_dma(snandc, &snandc->regs->cfg0, NAND_DEV0_CFG0, 3, 0);
-	qcom_write_reg_dma(snandc, &snandc->regs->ecc_buf_cfg, NAND_EBI2_ECC_BUF_CFG,
-			   1, NAND_BAM_NEXT_SGL);
 }
 
 static void qcom_spi_config_cw_write(struct qcom_nand_controller *snandc)
-- 
2.53.0



