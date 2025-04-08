Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C435A276043;
	Tue,  8 Apr 2025 12:52:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744116728; cv=none; b=Nb4tsWzpSfhxnTvhu4wcpZfjvl1hQqdRkfiGByXBy+wPmSz8B7Ih4c+SiGD9AF3bJH4yZFG0Au0G03nmz5f1cxE2c/0i9FXHCnVk/surCa6iut55sK7Sbjf9M2Hl4YZZbk//jnG4aevjlZczArca3Jp041STWfZaXp+HGRf0PJ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744116728; c=relaxed/simple;
	bh=sS8LVyopP+RIrcZKVoDWiD2dJX5+JEgzAJTSDLjllXs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bHjQfixTaTZsWt1L9sM33zV+6KcY3LRDuWoTROrN0ARMNUC8suiG3u/dvo95+aalQHd4GHbl055tKmVvz0LOanU/SR1S1DrP2sRB/4rPkB+wiGEepn6AwXtmTUHapr99wogeWF6G/cEiwAkR2nFrteCSl+vYApzvQL63+zTRwuE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1xZRGDdO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1xZRGDdO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C91DC4CEE5;
	Tue,  8 Apr 2025 12:52:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744116728;
	bh=sS8LVyopP+RIrcZKVoDWiD2dJX5+JEgzAJTSDLjllXs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1xZRGDdO4WJYjuGm63NQaC8ICP2ZV/UxQH3/Q5YAFrbliOooUkdILHPRUivHh+ajc
	 dwOsXYrmqaIzu9JAMMXtOZzMWdEsufeAH/n845NzZ0s1SeCYyGigeReMbEZbOpWOi9
	 WfI9k0Q8O2q47Y7Hiim3BoKRc10+yB0qGWNUzac0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geetha sowjanya <gakula@marvell.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 246/423] octeontx2-af: Free NIX_AF_INT_VEC_GEN irq
Date: Tue,  8 Apr 2025 12:49:32 +0200
Message-ID: <20250408104851.462074216@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104845.675475678@linuxfoundation.org>
References: <20250408104845.675475678@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Geetha sowjanya <gakula@marvell.com>

[ Upstream commit 323d6db6dc7decb06f2545efb9496259ddacd4f4 ]

Due to the incorrect initial vector number in
rvu_nix_unregister_interrupts(), NIX_AF_INT_VEC_GEN is not
geeting free. Fix the vector number to include NIX_AF_INT_VEC_GEN
irq.

Fixes: 5ed66306eab6 ("octeontx2-af: Add devlink health reporters for NIX")
Signed-off-by: Geetha sowjanya <gakula@marvell.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20250327094054.2312-1-gakula@marvell.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/octeontx2/af/rvu_devlink.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_devlink.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_devlink.c
index 7498ab429963d..06f778baaeef2 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_devlink.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_devlink.c
@@ -207,7 +207,7 @@ static void rvu_nix_unregister_interrupts(struct rvu *rvu)
 		rvu->irq_allocated[offs + NIX_AF_INT_VEC_RVU] = false;
 	}
 
-	for (i = NIX_AF_INT_VEC_AF_ERR; i < NIX_AF_INT_VEC_CNT; i++)
+	for (i = NIX_AF_INT_VEC_GEN; i < NIX_AF_INT_VEC_CNT; i++)
 		if (rvu->irq_allocated[offs + i]) {
 			free_irq(pci_irq_vector(rvu->pdev, offs + i), rvu_dl);
 			rvu->irq_allocated[offs + i] = false;
-- 
2.39.5



