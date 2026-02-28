Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A35F4359A63
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:13:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302415; cv=none; b=eO5xKM/BuJgLX0CpU304jpBmZaS5F/PlBpjAE/hG8A1OzslAFJ+EZrtWBulPUkZnWov4dLNQSFt/OiDoSfwvCefi8pyOk4yEg4OS/t9WvauH4ImBwVko8UTDePkXYHyPU3zg+Qe2ngBt1wT0nFwRpdJrJvwg33giYDs9GFpls8c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302415; c=relaxed/simple;
	bh=7m7VUizayImpAPHNzqh6973nSdsi3t3LoCUE7CWix9k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UWOS/e+SeGdFSe1Kdy789oLBKtGvSYiVhfXhgp9CJm+wmkoM2Gq85TnsahL5br2h8/Byplp0VG1dz5jpmnTDhewxYbSZl/PB7KmsB/UEsIVJEk6buCJxRYz6jigsGPZZ2YbzlAn9sng7nV9nK2IpJRmSWYDZS5Sc9Vrb8c6eX8o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HVQAyJZ+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HVQAyJZ+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4034C19424;
	Sat, 28 Feb 2026 18:13:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302415;
	bh=7m7VUizayImpAPHNzqh6973nSdsi3t3LoCUE7CWix9k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HVQAyJZ+XB/WaBo3swGxaGf4Fn06ZHyYa2ZsPDD23cQJDla3zyt5EHru7sN3zBU6D
	 KA3UHq0nHvp4bZkk+yNU9hN6lF/jHHNb41TWntLvE4Qbl4XdURwg93i+5/AZt0M0cN
	 YvYMZd4s/2VxWVe+FAsZ1GMzYYy8vODAEHQvvEAT1WMp0VIpFB4reQmqpTwYDmHjzB
	 bGpZHAPSPrQuOVt0ds8r0gQK0BSB+RuQ0ra2HCTdvDTYI7pScqU9+RAIhUMYCbSgoh
	 Kub7wSlW6JmmBFW+AAfapmka0vexFq1P5rEhvgn/fd98DnygO0T4RV+xJWPdmFgjtG
	 nvGrUkP5qcy6A==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Alok Tiwari <alok.a.tiwari@oracle.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 149/232] mtd: rawnand: cadence: Fix return type of CDMA send-and-wait helper
Date: Sat, 28 Feb 2026 13:10:02 -0500
Message-ID: <20260228181127.1592657-149-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181127.1592657-1-sashal@kernel.org>
References: <20260228181127.1592657-1-sashal@kernel.org>
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
index 5623bf5c34618..3a28ac5254289 100644
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

