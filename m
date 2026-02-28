Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8751B33A6F2
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:09:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302183; cv=none; b=atHzICNlpscN8Tobh+XCceSkcAmH/Myn7QoYQJ6aDSR+aSgrTSbrHxwuLHTOD92tbOOggObyjTVD/v4efB6kOX2RN0H2RW6FeFQ7wUsIY+cwF3htgWFhTWrw8vVKLMLxpBfBZ8VErnbLyIujW2iu22NGJTtU7csphlTeo3HGeQM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302183; c=relaxed/simple;
	bh=3VAg1yRkVShfs4ZY3Vh2YrxhZj4P87a+i1HAnxuMSxw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X4Nq9SOunH/GQWLVjVZnqY8R5g2SyIHkXPO0dQu8JCoHWuoDxjbv5DSXCj1YFLShCMMR7RuOv39WdAyC0dayyudrBtHA1uMCoP4CLv430Dxv5jrT++N4yueDkc+zAw7fpz7OXu651778w/Vhl/Qogc9oXMtYUJ3o4xfk3l0Or7g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pOQRiJJu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pOQRiJJu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBE93C19424;
	Sat, 28 Feb 2026 18:09:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302183;
	bh=3VAg1yRkVShfs4ZY3Vh2YrxhZj4P87a+i1HAnxuMSxw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pOQRiJJu+kM/5ZgD24b85zxlSDeVei61rK84GDPwEcqWK1oCczZ/E9Pneo/iHUJ0M
	 7X9oW+c5vJ4YpdYRuAZc+lYP/4xtk9HQWV/JNq3rTPI6COoVQmO+vyaZdoGjVmaKOW
	 i02qrnuA0hdBMu2MfPbTsVQHDVLi4oeKLLPg53vdkZ5V3MZwUpwZn/CNyVrSpZkpsj
	 8K0WHaHQsM/Pj52p0CkPVkZKMK00hEdW1rKckHp+R2CsHne3USYOsxfcZkIFsdCiLk
	 Iw7lDPlh0GlFARurZxg6BajhalBP+IrUWOLitHcIZH2sG6TRMHxPSGjWwA3Y8/uAQa
	 B+e67kXdrx55A==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Alok Tiwari <alok.a.tiwari@oracle.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 184/283] mtd: rawnand: cadence: Fix return type of CDMA send-and-wait helper
Date: Sat, 28 Feb 2026 13:05:26 -0500
Message-ID: <20260228180709.1583486-184-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180709.1583486-1-sashal@kernel.org>
References: <20260228180709.1583486-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Alok Tiwari <alok.a.tiwari@oracle.com>

[ Upstream commit 6d8226cbbf124bb5613b532216b74c886a4361b7 ]

cadence_nand_cdma_send_and_wait() propagates negative errno values
from cadence_nand_cdma_send(), returns -ETIMEDOUT on failure and -EIO
when the CDMA engine reports a command failure.

However, it is declared as u32, causing error codes to wrap.
Change the return type to int to correctly propagate errors.

Fixes: ec4ba01e894d ("mtd: rawnand: Add new Cadence NAND driver to MTD subsystem")
Signed-off-by: Alok Tiwari <alok.a.tiwari@oracle.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/nand/raw/cadence-nand-controller.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mtd/nand/raw/cadence-nand-controller.c b/drivers/mtd/nand/raw/cadence-nand-controller.c
index 202b4fc064fa3..0831feb58e13d 100644
--- a/drivers/mtd/nand/raw/cadence-nand-controller.c
+++ b/drivers/mtd/nand/raw/cadence-nand-controller.c
@@ -1018,7 +1018,7 @@ static int cadence_nand_cdma_send(struct cdns_nand_ctrl *cdns_ctrl,
 }
 
 /* Send SDMA command and wait for finish. */
-static u32
+static int
 cadence_nand_cdma_send_and_wait(struct cdns_nand_ctrl *cdns_ctrl,
 				u8 thread)
 {
-- 
2.51.0

