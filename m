Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECCA7279915;
	Tue, 12 Aug 2025 17:47:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755020870; cv=none; b=mDtS61MerbK1maORJYcBFB6aEwP75hkRuNHJ6L5rAyiMZr7SZ7wBrq0A6o+uy6+Fp3+RrklIDy3hcz7draZbqeGJ27X1JtZxH/UewSl0GU0Uvwgjo28FWr8IlytByeAEk+8E3Dm6NcHNvPVZwgDp1UbgLPak9unrl4vWt4nhXK8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755020870; c=relaxed/simple;
	bh=Q8Z9vGzVdEy2WpLEUDDW0g1am+foy8VXZAMJdxreWEY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FYkXGZH5WlwFsOMiTZylx7YeMpWT7TK8BGGV/y8dT/foVNtwKAhXsmrVUGL6gKHdjCaQRs3wjRhTgaydRh0baKHwzcgmWIsNEZgfiRjK8Dp139HqyiFB1+zXhImwr1X+9/oIO/lyBkbDOQB6tRmhPes+0gB3GgUUcDJXqKjRhjU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u1MBd+xp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u1MBd+xp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72441C4CEF0;
	Tue, 12 Aug 2025 17:47:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755020869;
	bh=Q8Z9vGzVdEy2WpLEUDDW0g1am+foy8VXZAMJdxreWEY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u1MBd+xpYGXTqiCQ9LMr/JEyKqRw2x7Z1JgK0X2uZV5INiLwx/92HwxFzRnW5kTAt
	 +Lei5qZzGvuv1a0rPIunYPa2DtXDXOjqeU++KDqKp0vWOc0HcUHiTIoo8Rm6R2T97i
	 2B8dC9yJVq2QDV6peKi4LrP6rFnp6R5zafYC3tag=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zixun LI <admin@hifiphile.com>,
	Ada Couprie Diaz <ada.coupriediaz@arm.com>,
	Balamanikandan Gunasundar <balamanikandan.gunasundar@microchip.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 180/253] mtd: rawnand: atmel: set pmecc data setup time
Date: Tue, 12 Aug 2025 19:29:28 +0200
Message-ID: <20250812172956.423278059@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812172948.675299901@linuxfoundation.org>
References: <20250812172948.675299901@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



