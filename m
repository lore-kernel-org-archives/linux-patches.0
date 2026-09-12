Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00F86247280;
	Sat, 12 Sep 2026 11:29:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789212579; cv=none; b=tAduY+wBjrteDxHMxG03UgAcmuJikwgJky5ohG2nCKHScGD5J+mXdX4Thr+E4E0xXOQctLcOxXcgUJh6z2h9rWBJ5+iCSQMlY80ramb0gxc2nb+YKcmwTzk9xcpMOkK7k8h/rjjUIyz0Ro9pDiOKPgU4EarEjXqGZNN87CvtLtE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789212579; c=relaxed/simple;
	bh=1J1WkpfY2IPoQuKID1wjNEWTsoAZXulIJQZS0ZnQT1w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ShVgCiUoMqEySUerxNh1M8say6dkoG6kuWJowfBrot9H/f2mbNZTRaokN8c1rwSKn7SQqiwMKdqmKIaKuKKb7ws/xzRezNFUa7R7dbMgeoDZ2XZi3t/0ROjkrJHLSPoiL8FmlAu0hW8/CnHcuPUgxbHQzogHr840r9BTcTILYpU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QFEZFqwA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QFEZFqwA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 651631F000FF;
	Sat, 12 Sep 2026 11:29:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789212577;
	bh=vwlHwfpn/jrqK4Vw70UW2jpQ768IBdrSn/T32eqv0SY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QFEZFqwAjW+yPsq58VOh2BykQeEuZEhO3tHMQdN+3qI07cgmRC1u5ZOdYcaWOfHKt
	 I3PeDgKF5/UCgUCneB5dgGR5XpwhXI6dE2m8SC9L0scvd/ohim3F+OJy1OBJjTo6MF
	 R0lI0XY9GLkNYtDOTLrsGTkf1rnuee5Rl4X6Gy6M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Miquel Raynal (DAVE)" <miquel.raynal@bootlin.com>,
	Michal Simek <michal.simek@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1463/1518] mtd: rawnand: pl353: Fix debug prints
Date: Sat, 12 Sep 2026 09:00:32 +0200
Message-ID: <20260912065656.650348633@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

From: Miquel Raynal (DAVE) <miquel.raynal@bootlin.com>

[ Upstream commit 2b7baaddf1bc3e39206a0354449fdc349945b86b ]

They are partially incorrect since "software" engine does not mean
hamming, the "none" cae is also falling into this print, and on-die
means there is some kind of hardware support; we prefer to use the
wording on-host vs. on-die.

Fix all those prints.

Fixes: 1e06dbfdfb85 ("mtd: rawnand: pl353: Add message about ECC mode")
Signed-off-by: Miquel Raynal (DAVE) <miquel.raynal@bootlin.com>
Acked-by: Michal Simek <michal.simek@amd.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/nand/raw/pl35x-nand-controller.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/mtd/nand/raw/pl35x-nand-controller.c b/drivers/mtd/nand/raw/pl35x-nand-controller.c
index 7d43506b1654d..12b9e0936c8f1 100644
--- a/drivers/mtd/nand/raw/pl35x-nand-controller.c
+++ b/drivers/mtd/nand/raw/pl35x-nand-controller.c
@@ -972,17 +972,19 @@ static int pl35x_nand_attach_chip(struct nand_chip *chip)
 
 	switch (chip->ecc.engine_type) {
 	case NAND_ECC_ENGINE_TYPE_ON_DIE:
-		dev_dbg(nfc->dev, "Using on-die ECC\n");
+		dev_dbg(nfc->dev, "Using on-die hardware ECC\n");
 		/* Keep these legacy BBT descriptors for ON_DIE situations */
 		chip->bbt_td = &bbt_main_descr;
 		chip->bbt_md = &bbt_mirror_descr;
 		fallthrough;
 	case NAND_ECC_ENGINE_TYPE_NONE:
+		dev_dbg(nfc->dev, "Using no ECC engine\n");
+		break;
 	case NAND_ECC_ENGINE_TYPE_SOFT:
-		dev_dbg(nfc->dev, "Using software ECC (Hamming 1-bit/512B)\n");
+		dev_dbg(nfc->dev, "Using software ECC\n");
 		break;
 	case NAND_ECC_ENGINE_TYPE_ON_HOST:
-		dev_dbg(nfc->dev, "Using hardware ECC\n");
+		dev_dbg(nfc->dev, "Using on-host hardware ECC\n");
 		ret = pl35x_nand_init_hw_ecc_controller(nfc, chip);
 		if (ret)
 			return ret;
-- 
2.53.0



