Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2A5A1E87B;
	Mon, 23 Jun 2025 13:18:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750684684; cv=none; b=mCQmLBv013y/hZsJshrUJbGCKnThhaw3iHnE5jXcaeRLEFy9EEyICJuB2p8M/YC0cxZ6vhAfLMmYY1Wn1e/MjJl3l8z7tWMq38sEnUAmN5MbhNvePnFjTLouLibiRDo1SEv07avGche7vxmCmtwv40byZjUcr4CtvwjwuXRN1wM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750684684; c=relaxed/simple;
	bh=Up7SILJf0cbG1gW7OGAv9p8hSJZV9ZPYGBv3HfuX6MA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KEmRKiwz4I4xT95lZKyIrPusXpiCH0P1q+yYqdVR1Vk46Rshp7piaP1e1ZKmcsHoFsTBLTEsFuhKenXdSTLSb2YV4Bj+/VAOfguUI2fLzu2E80o84MgP/Bw1JsJWcM3W0myOPz1gmalMMloyACzCUwWGQLCONOdLE7DLujdfdiE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CFg/3cb0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CFg/3cb0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10F21C4CEEA;
	Mon, 23 Jun 2025 13:18:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750684684;
	bh=Up7SILJf0cbG1gW7OGAv9p8hSJZV9ZPYGBv3HfuX6MA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CFg/3cb0iLm4Of889755EibiXhNTAW3/RZDEIXpbMWOxlHW5uDVBPSI9VxQe6eBPP
	 8YnDC3CDOUZd3xU4RWzeiPqtGmuoWEi3JEDItHXwnx+Cst7LmnmkN8tGJnlb1cxHv7
	 bALYe4/qPP33uLZrMiQ/L9FE1PKXD4FRuiN7YFaE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lakshmi Sowjanya D <quic_laksd@quicinc.com>,
	Md Sadre Alam <quic_mdalam@quicinc.com>,
	Mark Brown <broonie@kernel.org>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Gabor Juhos <j4g8y7@gmail.com>
Subject: [PATCH 6.15 153/592] mtd: rawnand: qcom: Pass 18 bit offset from NANDc base to BAM base
Date: Mon, 23 Jun 2025 15:01:51 +0200
Message-ID: <20250623130703.921474852@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Md Sadre Alam <quic_mdalam@quicinc.com>

commit ee000969f28bf579d3772bf7c0ae8aff86586e20 upstream.

The BAM command descriptor provides only 18 bits to specify the BAM
register offset. Additionally, in the BAM command descriptor, the BAM
register offset is supposed to be specified as "(NANDc base - BAM base)
+ reg_off". Since, the BAM controller expecting the value in the form of
"NANDc base - BAM base", so that added a new field 'bam_offset' in the NAND
properties structure and use it while preparing the command descriptor.

Previously, the driver was specifying the NANDc base address in the BAM
command descriptor.

Cc: stable@vger.kernel.org
Fixes: 8d6b6d7e135e ("mtd: nand: qcom: support for command descriptor formation")
Tested-by: Lakshmi Sowjanya D <quic_laksd@quicinc.com>
Signed-off-by: Md Sadre Alam <quic_mdalam@quicinc.com>
Acked-by: Mark Brown <broonie@kernel.org>
Tested-by: Gabor Juhos <j4g8y7@gmail.com> # on IPQ9574
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mtd/nand/qpic_common.c       |    8 ++++----
 drivers/mtd/nand/raw/qcom_nandc.c    |    4 ++++
 drivers/spi/spi-qpic-snand.c         |    1 +
 include/linux/mtd/nand-qpic-common.h |    4 +---
 4 files changed, 10 insertions(+), 7 deletions(-)

--- a/drivers/mtd/nand/qpic_common.c
+++ b/drivers/mtd/nand/qpic_common.c
@@ -236,21 +236,21 @@ int qcom_prep_bam_dma_desc_cmd(struct qc
 	int i, ret;
 	struct bam_cmd_element *bam_ce_buffer;
 	struct bam_transaction *bam_txn = nandc->bam_txn;
+	u32 offset;
 
 	bam_ce_buffer = &bam_txn->bam_ce[bam_txn->bam_ce_pos];
 
 	/* fill the command desc */
 	for (i = 0; i < size; i++) {
+		offset = nandc->props->bam_offset + reg_off + 4 * i;
 		if (read)
 			bam_prep_ce(&bam_ce_buffer[i],
-				    nandc_reg_phys(nandc, reg_off + 4 * i),
-				    BAM_READ_COMMAND,
+				    offset, BAM_READ_COMMAND,
 				    reg_buf_dma_addr(nandc,
 						     (__le32 *)vaddr + i));
 		else
 			bam_prep_ce_le32(&bam_ce_buffer[i],
-					 nandc_reg_phys(nandc, reg_off + 4 * i),
-					 BAM_WRITE_COMMAND,
+					 offset, BAM_WRITE_COMMAND,
 					 *((__le32 *)vaddr + i));
 	}
 
--- a/drivers/mtd/nand/raw/qcom_nandc.c
+++ b/drivers/mtd/nand/raw/qcom_nandc.c
@@ -2360,6 +2360,7 @@ static const struct qcom_nandc_props ipq
 	.supports_bam = false,
 	.use_codeword_fixup = true,
 	.dev_cmd_reg_start = 0x0,
+	.bam_offset = 0x30000,
 };
 
 static const struct qcom_nandc_props ipq4019_nandc_props = {
@@ -2367,6 +2368,7 @@ static const struct qcom_nandc_props ipq
 	.supports_bam = true,
 	.nandc_part_of_qpic = true,
 	.dev_cmd_reg_start = 0x0,
+	.bam_offset = 0x30000,
 };
 
 static const struct qcom_nandc_props ipq8074_nandc_props = {
@@ -2374,6 +2376,7 @@ static const struct qcom_nandc_props ipq
 	.supports_bam = true,
 	.nandc_part_of_qpic = true,
 	.dev_cmd_reg_start = 0x7000,
+	.bam_offset = 0x30000,
 };
 
 static const struct qcom_nandc_props sdx55_nandc_props = {
@@ -2382,6 +2385,7 @@ static const struct qcom_nandc_props sdx
 	.nandc_part_of_qpic = true,
 	.qpic_version2 = true,
 	.dev_cmd_reg_start = 0x7000,
+	.bam_offset = 0x30000,
 };
 
 /*
--- a/drivers/spi/spi-qpic-snand.c
+++ b/drivers/spi/spi-qpic-snand.c
@@ -1636,6 +1636,7 @@ static void qcom_spi_remove(struct platf
 
 static const struct qcom_nandc_props ipq9574_snandc_props = {
 	.dev_cmd_reg_start = 0x7000,
+	.bam_offset = 0x30000,
 	.supports_bam = true,
 };
 
--- a/include/linux/mtd/nand-qpic-common.h
+++ b/include/linux/mtd/nand-qpic-common.h
@@ -199,9 +199,6 @@
  */
 #define dev_cmd_reg_addr(nandc, reg) ((nandc)->props->dev_cmd_reg_start + (reg))
 
-/* Returns the NAND register physical address */
-#define nandc_reg_phys(chip, offset) ((chip)->base_phys + (offset))
-
 /* Returns the dma address for reg read buffer */
 #define reg_buf_dma_addr(chip, vaddr) \
 	((chip)->reg_read_dma + \
@@ -454,6 +451,7 @@ struct qcom_nand_controller {
 struct qcom_nandc_props {
 	u32 ecc_modes;
 	u32 dev_cmd_reg_start;
+	u32 bam_offset;
 	bool supports_bam;
 	bool nandc_part_of_qpic;
 	bool qpic_version2;


