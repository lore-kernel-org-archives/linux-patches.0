Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1A1A37524F
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:16:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302598; cv=none; b=rJ0DfbPVd6aYHfEG4EJh6zaNfjEskvVF/1RNkES7eyA1VG8D+1/nP38lHvIX+7H077nm1BWMwQidTgWC0hMFuvq3LkdMrUhWNMCjM6sT1TxrpzRbew0y6RD7Bk2Ih2JclAk0yuS72Tand5/h7DCNe5dIECFfihTeQv2lbtPiDY0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302598; c=relaxed/simple;
	bh=cGfUnpC9sghwyXmbicDeqT5DUjlzWul5BcEtfGLvd7g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LizhWpepNe4qXB86OdLOi87cOX4KFq7Q6oeIyFP0AyLS44cO9Smg2vsm8o6Dn/xGMoey/VgJnGsU5tFt55d75yowl1CXKO9GKROxOB1LzQd32AKz7eQhbeKsMIz6RNv2v8vYE1CkYe9eN73ccWHR3xAUIIBn8eeUzygPc8HWH1c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=d5HezFVS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="d5HezFVS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F24FC116D0;
	Sat, 28 Feb 2026 18:16:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302598;
	bh=cGfUnpC9sghwyXmbicDeqT5DUjlzWul5BcEtfGLvd7g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d5HezFVSWjxdAkqURv0N2O17o1oW8dUcX1dcjGy7OZrIt2clS1ngGjmPy3B4s01u2
	 2dlJGn6BdPUXTqToNqJC1DjRH1inIAhJ5eUdwuWnHhJzSc0fswRPTIHiDlUduiWYdO
	 zC/CobAf6XzZ7wC4lNePLywd9f3Y942NjA6R5I49VHJAAFVE6hBsY84Q4coD9HGBnY
	 bHDySJMG8gd3ft7gHKHc4ip26CtQekjEG50J25CXXmhrlbd67p0Z0xPHrX0jZ3MODY
	 wfGeqiZFRCtLdHrTVcQjoKrgqh01bsDLgcaXmOp7yk653IP25XC1ap19vDEQPO4eGE
	 /9s5HHvMHzDBQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Alok Tiwari <alok.a.tiwari@oracle.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 111/164] mtd: rawnand: cadence: Fix return type of CDMA send-and-wait helper
Date: Sat, 28 Feb 2026 13:14:10 -0500
Message-ID: <20260228181505.1600663-111-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181505.1600663-1-sashal@kernel.org>
References: <20260228181505.1600663-1-sashal@kernel.org>
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
index 8c8d21af1d9b7..6ba4601681cef 100644
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

