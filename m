Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D70652E7BD4;
	Tue, 12 Aug 2025 18:50:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755024652; cv=none; b=MPyTQNrbSi9LxihMoqmj/DlxGDOu/+yP4iqCaTfYXVDprbf+znHGQBRxDwWZIcct0NcsOZOS9B4fkKeeGMmjfFmvU2BJPcyu/6c1f6CA1X38kkk6B1i+EnGFqaT5MSlJ9DcMFW6/polT9MYzr1t/YQ3yRNFORu2MqrNcgxEPNrQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755024652; c=relaxed/simple;
	bh=sQGG2/4kihwD2NPxxOuuexiy70aXnEpPdJpDp/yDFmM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SZC1PwESQPlE3R85nXkQYC5LU8dW9AnWbMvQckmQM7sm9FHSCxTxws5P/T3wmXDgSTMTyHSZsmHKpkH64Yimq1fcvUiGWh+P3buVyD4MozLsmOzu+BOKwlBG1cB3n37TibAqcDUuBb8M8Ovb9XWafTM2IkzSVkTDTRYpmYs7/18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yxtKHqXN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yxtKHqXN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B8E0C4CEF0;
	Tue, 12 Aug 2025 18:50:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755024652;
	bh=sQGG2/4kihwD2NPxxOuuexiy70aXnEpPdJpDp/yDFmM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yxtKHqXNt/EOXEIn+1/fbn/T9dYTbxqw2dAYOt0oMrM+NAiX8mfvtlWqNywxMb9d1
	 MfPN/hsFB+kanhtKS19F7FRQFxd2C2PKkoSjUf5snAsSUl3wggMC13R1g9fpiAy5Sq
	 9aDoqZ9Bafjc8G2LX9wsX6GzozvzENf19fYMFuZc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zixun LI <admin@hifiphile.com>,
	Ada Couprie Diaz <ada.coupriediaz@arm.com>,
	Balamanikandan Gunasundar <balamanikandan.gunasundar@microchip.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 436/627] mtd: rawnand: atmel: set pmecc data setup time
Date: Tue, 12 Aug 2025 19:32:11 +0200
Message-ID: <20250812173435.862997298@linuxfoundation.org>
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

From: Balamanikandan Gunasundar <balamanikandan.gunasundar@microchip.com>

[ Upstream commit f552a7c7e0a14215cb8a6fd89e60fa3932a74786 ]

Setup the pmecc data setup time as 3 clock cycles for 133MHz as recommended
by the datasheet.

Fixes: f88fc122cc34 ("mtd: nand: Cleanup/rework the atmel_nand driver")
Reported-by: Zixun LI <admin@hifiphile.com>
Closes: https://lore.kernel.org/all/c015bb20-6a57-4f63-8102-34b3d83e0f5b@microchip.com
Suggested-by: Ada Couprie Diaz <ada.coupriediaz@arm.com>
Signed-off-by: Balamanikandan Gunasundar <balamanikandan.gunasundar@microchip.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/nand/raw/atmel/pmecc.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/mtd/nand/raw/atmel/pmecc.c b/drivers/mtd/nand/raw/atmel/pmecc.c
index 3c7dee1be21d..0b402823b619 100644
--- a/drivers/mtd/nand/raw/atmel/pmecc.c
+++ b/drivers/mtd/nand/raw/atmel/pmecc.c
@@ -143,6 +143,7 @@ struct atmel_pmecc_caps {
 	int nstrengths;
 	int el_offset;
 	bool correct_erased_chunks;
+	bool clk_ctrl;
 };
 
 struct atmel_pmecc {
@@ -843,6 +844,10 @@ static struct atmel_pmecc *atmel_pmecc_create(struct platform_device *pdev,
 	if (IS_ERR(pmecc->regs.errloc))
 		return ERR_CAST(pmecc->regs.errloc);
 
+	/* pmecc data setup time */
+	if (caps->clk_ctrl)
+		writel(PMECC_CLK_133MHZ, pmecc->regs.base + ATMEL_PMECC_CLK);
+
 	/* Disable all interrupts before registering the PMECC handler. */
 	writel(0xffffffff, pmecc->regs.base + ATMEL_PMECC_IDR);
 	atmel_pmecc_reset(pmecc);
@@ -896,6 +901,7 @@ static struct atmel_pmecc_caps at91sam9g45_caps = {
 	.strengths = atmel_pmecc_strengths,
 	.nstrengths = 5,
 	.el_offset = 0x8c,
+	.clk_ctrl = true,
 };
 
 static struct atmel_pmecc_caps sama5d4_caps = {
-- 
2.39.5



