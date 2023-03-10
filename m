Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 294B3846C
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 14:33:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81EE7C433D2;
	Fri, 10 Mar 2023 14:33:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678458827;
	bh=/VHe2qtNXaP/T+goPpejHHQ+B36QSbIcxaP1paH7q4c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wQ5j/sgOYfihCXTa60TspFo3HeDiir3FXdXMorQasrDbaITIbhMnlBWLXHMsXCZIF
	 UP63Obp6DbKss9pQY1ahg1LrYB5TvI1aVGs6kARwVvvecNG/l0nCljQYAUUgpGI9Qj
	 Mxj6ct4o5rNG2Q7fwnx/Zrmq/Na0B0SiyMJLrBlU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Samuel Holland <samuel@sholland.org>,
	Dhruva Gole <d-gole@ti.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 150/357] mtd: rawnand: sunxi: Fix the size of the last OOB region
Date: Fri, 10 Mar 2023 14:37:19 +0100
Message-Id: <20230310133741.333308149@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133733.973883071@linuxfoundation.org>
References: <20230310133733.973883071@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Samuel Holland <samuel@sholland.org>

[ Upstream commit 34569d869532b54d6e360d224a0254dcdd6a1785 ]

The previous code assigned to the wrong structure member.

Fixes: c66811e6d350 ("mtd: nand: sunxi: switch to mtd_ooblayout_ops")
Signed-off-by: Samuel Holland <samuel@sholland.org>
Acked-By: Dhruva Gole <d-gole@ti.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/linux-mtd/20221229181526.53766-6-samuel@sholland.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/nand/raw/sunxi_nand.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mtd/nand/raw/sunxi_nand.c b/drivers/mtd/nand/raw/sunxi_nand.c
index 45c376fc571af..0f3bce3fb00b7 100644
--- a/drivers/mtd/nand/raw/sunxi_nand.c
+++ b/drivers/mtd/nand/raw/sunxi_nand.c
@@ -1587,7 +1587,7 @@ static int sunxi_nand_ooblayout_free(struct mtd_info *mtd, int section,
 	if (section < ecc->steps)
 		oobregion->length = 4;
 	else
-		oobregion->offset = mtd->oobsize - oobregion->offset;
+		oobregion->length = mtd->oobsize - oobregion->offset;
 
 	return 0;
 }
-- 
2.39.2



