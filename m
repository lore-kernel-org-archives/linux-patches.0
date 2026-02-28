Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0992C345CD8
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:04:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301849; cv=none; b=Dcb53f6smuqu50IHyQaadMlipx3t6pm/jloV6hrTZqer6ocTPRoh/AepUjkGix62YqHMehTJdi9Uysl+oFlipfOKmF9574Qgp2gyGovtDaCcNOeRFKL0upJDjSZwFqgZQ+Mg7OfhUmCx/yx9eE+66PQuUhREoh3fmfCEeKA14Ss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301849; c=relaxed/simple;
	bh=uW/csS8xMDGOVgSOb0uFRyoMgOM0zNSU+sC18B5KOwM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OmAlxxHnjZfaOG4KQONC83M+X/tp6RD0m4+IVQd51p61SdAtaf2twihgub9JCVpavpUdwl7k4YK9XNlG4T+acUjta4ncI7vU5DSXpqX6brTQFb4jzFwFbfky65a8/S8JTLab833hZ2rCRd38Q5S2wfFAQMuUZDmr4UznbZRlf4s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KyE1uZTG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KyE1uZTG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B533C19423;
	Sat, 28 Feb 2026 18:04:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301848;
	bh=uW/csS8xMDGOVgSOb0uFRyoMgOM0zNSU+sC18B5KOwM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KyE1uZTGi3PVbEaAfcnnSaylWWcFLSP7MuMXNsBGs6kEgDbavPfqS81u5IuXWrIU/
	 SlmjTyF9dLPiNPQgrTkRemM1MrYFwPrZjSjdv8ASXtV7A82dHzbG4AJUPyy0K3JJxf
	 dpbECsVrWrqaEr3Ji91bymfmFMmJO17ENMXRjO6KE2gseFBDK+EUV8ARtK3fubJu6y
	 ZxzSv57dlIEdAiXsvKcChX5DGi3BI+/KfMSqCOjd90CcvYyintSbOTyPPoFTiBsJCp
	 x6HscoZiJfzKCsD/0p8x798caSISlCcVfsY4ZM3lf1th6H6Gvadng96eNbRj5kmCYM
	 +69wZC8ZjYryg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Alok Tiwari <alok.a.tiwari@oracle.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 269/385] mtd: rawnand: cadence: Fix return type of CDMA send-and-wait helper
Date: Sat, 28 Feb 2026 12:58:11 -0500
Message-ID: <20260228180011.1568201-269-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180011.1568201-1-sashal@kernel.org>
References: <20260228180011.1568201-1-sashal@kernel.org>
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
index 443202b942e1f..5872f1dfe7016 100644
--- a/drivers/mtd/nand/raw/cadence-nand-controller.c
+++ b/drivers/mtd/nand/raw/cadence-nand-controller.c
@@ -1015,7 +1015,7 @@ static int cadence_nand_cdma_send(struct cdns_nand_ctrl *cdns_ctrl,
 }
 
 /* Send SDMA command and wait for finish. */
-static u32
+static int
 cadence_nand_cdma_send_and_wait(struct cdns_nand_ctrl *cdns_ctrl,
 				u8 thread)
 {
-- 
2.51.0

