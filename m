Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BA4D350835;
	Tue, 26 Aug 2025 14:10:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756217443; cv=none; b=fnffy3zSd55zCUJSx11Ek82H6Nq2LlndWXx6bmezNTsZtzx4PZGYAxjcr6sz/EGhIBZmxx7tTMEzrLyLjoE0IqV0iKHJAIlP4dCQt/eL5aAMEByXiVPsPppehdHvcEVur+Fu8IcVOWPiJ7j1M/eCRAodebT7a4Q9wpgyD3OXJVo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756217443; c=relaxed/simple;
	bh=+oKXSN0UPAHggYW0B7cyww5V6ZBCscwdlt1gSi1sCII=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZcNd6szRDOnAQJFABpuy6M9ZreKVPrE5GiPb68Q5vBcwAGVbG5+ESmvNzdELMzUIeJYWyOdQCCXRN58tAi89ptjrvljZc8aecR86/RpIg7oyCVz0i0z37UpRelZy3rmRMm6ioisCU+ioMeSgClyJeE+c70Z7eGy72sc4r5TO/sw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LIWQkyVz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LIWQkyVz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33BC6C113D0;
	Tue, 26 Aug 2025 14:10:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756217442;
	bh=+oKXSN0UPAHggYW0B7cyww5V6ZBCscwdlt1gSi1sCII=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LIWQkyVzxnVajcYl0o7YKUW3BKIDoZCnYhlFozfqZrLSxpRCYNhXWXBECfgBkJGN/
	 VDf3+5uR3YilSQGAGSwOwU6W5m9fRqcaErfVqRecj9B+vm37vWI8jwSGpl9EaI2xQf
	 g10S9fN3A5dBasJJlxsKiFcgAQkC7Dqu2Pdsw6ZE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zixun LI <admin@hifiphile.com>,
	Ada Couprie Diaz <ada.coupriediaz@arm.com>,
	Balamanikandan Gunasundar <balamanikandan.gunasundar@microchip.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 145/523] mtd: rawnand: atmel: set pmecc data setup time
Date: Tue, 26 Aug 2025 13:05:55 +0200
Message-ID: <20250826110928.067366811@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110924.562212281@linuxfoundation.org>
References: <20250826110924.562212281@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index d1ed5878b3b1..28ed65dd3d43 100644
--- a/drivers/mtd/nand/raw/atmel/pmecc.c
+++ b/drivers/mtd/nand/raw/atmel/pmecc.c
@@ -143,6 +143,7 @@ struct atmel_pmecc_caps {
 	int nstrengths;
 	int el_offset;
 	bool correct_erased_chunks;
+	bool clk_ctrl;
 };
 
 struct atmel_pmecc {
@@ -846,6 +847,10 @@ static struct atmel_pmecc *atmel_pmecc_create(struct platform_device *pdev,
 	if (IS_ERR(pmecc->regs.errloc))
 		return ERR_CAST(pmecc->regs.errloc);
 
+	/* pmecc data setup time */
+	if (caps->clk_ctrl)
+		writel(PMECC_CLK_133MHZ, pmecc->regs.base + ATMEL_PMECC_CLK);
+
 	/* Disable all interrupts before registering the PMECC handler. */
 	writel(0xffffffff, pmecc->regs.base + ATMEL_PMECC_IDR);
 	atmel_pmecc_reset(pmecc);
@@ -899,6 +904,7 @@ static struct atmel_pmecc_caps at91sam9g45_caps = {
 	.strengths = atmel_pmecc_strengths,
 	.nstrengths = 5,
 	.el_offset = 0x8c,
+	.clk_ctrl = true,
 };
 
 static struct atmel_pmecc_caps sama5d4_caps = {
-- 
2.39.5



