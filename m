Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B40E460DCF;
	Fri, 17 Oct 2025 14:58:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760713131; cv=none; b=pumR3yzv1PzkUMdrd6d/t+SyR3KrrMj89fN/N3fx9aPf6y29UPZHyp+GUPC3m+HDJ80iEO3IuD+bmM3P2HiG5uDZCfwrGzGCnoxdzXpuqWHH/YEwTqnVeAwRbx9gzCLsF9/ygmEVDw7BrctpKXOTqAd95Q5fPwSPnrK4gcCD+W0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760713131; c=relaxed/simple;
	bh=TVK7QLnMrEeWUKB/NUvYhEhCv2pzgxPk0FlT8t2GZYA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UJhwJiQj3hOvhYmiM55utCKpdA6k4N0gLKfa0QrE+73fYMQ7W60uMDI4iFg/7pNWI1SuPWeVlWNIXJAxUrzOthDmVjFiBonUdL2R9GQlr63aqL4Ayz9+Ao8M+p6xNYTFjasGBkUqP3XwMzg4sUyy8LhBqS+IKS+H7aNOHwTuCBA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HCBIUeHC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HCBIUeHC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8195C4CEE7;
	Fri, 17 Oct 2025 14:58:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760713131;
	bh=TVK7QLnMrEeWUKB/NUvYhEhCv2pzgxPk0FlT8t2GZYA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HCBIUeHCaEReHOAh4Trl5b9CEuDKPKe55/5GsZi5I6bUhxqFi28hqWpXS67U0RLbO
	 1azePozHWBgwA+1qkYb1+B3lG2V/Z6GGphiCM1kEUlWupcTdE0swrSV6X8unK32KO3
	 2OHNbp4YBk9LNTNELlFwnszcQQ9vS1/Fs/8oX0Ps=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Garry <john.garry@huawei.com>,
	Damien Le Moal <damien.lemoal@opensource.wdc.com>,
	Hannes Reinecke <hare@suse.de>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 025/168] scsi: mvsas: Delete mvs_tag_init()
Date: Fri, 17 Oct 2025 16:51:44 +0200
Message-ID: <20251017145129.946011722@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145129.000176255@linuxfoundation.org>
References: <20251017145129.000176255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: John Garry <john.garry@huawei.com>

[ Upstream commit ffc9f9bf3f14876d019f67ef17d41138802529a8 ]

All mvs_tag_init() does is zero the tag bitmap, but this is already done
with the kzalloc() call to alloc the tags, so delete this unneeded
function.

Signed-off-by: John Garry <john.garry@huawei.com>
Link: https://lore.kernel.org/r/1666091763-11023-7-git-send-email-john.garry@huawei.com
Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Stable-dep-of: 60cd16a3b743 ("scsi: mvsas: Fix use-after-free bugs in mvs_work_queue")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/mvsas/mv_init.c | 2 --
 drivers/scsi/mvsas/mv_sas.c  | 7 -------
 drivers/scsi/mvsas/mv_sas.h  | 1 -
 3 files changed, 10 deletions(-)

diff --git a/drivers/scsi/mvsas/mv_init.c b/drivers/scsi/mvsas/mv_init.c
index 2fde496fff5f7..c85fb812ad437 100644
--- a/drivers/scsi/mvsas/mv_init.c
+++ b/drivers/scsi/mvsas/mv_init.c
@@ -286,8 +286,6 @@ static int mvs_alloc(struct mvs_info *mvi, struct Scsi_Host *shost)
 	}
 	mvi->tags_num = slot_nr;
 
-	/* Initialize tags */
-	mvs_tag_init(mvi);
 	return 0;
 err_out:
 	return 1;
diff --git a/drivers/scsi/mvsas/mv_sas.c b/drivers/scsi/mvsas/mv_sas.c
index 1275f3be530f7..82a308840b117 100644
--- a/drivers/scsi/mvsas/mv_sas.c
+++ b/drivers/scsi/mvsas/mv_sas.c
@@ -51,13 +51,6 @@ inline int mvs_tag_alloc(struct mvs_info *mvi, u32 *tag_out)
 	return 0;
 }
 
-void mvs_tag_init(struct mvs_info *mvi)
-{
-	int i;
-	for (i = 0; i < mvi->tags_num; ++i)
-		mvs_tag_clear(mvi, i);
-}
-
 static struct mvs_info *mvs_find_dev_mvi(struct domain_device *dev)
 {
 	unsigned long i = 0, j = 0, hi = 0;
diff --git a/drivers/scsi/mvsas/mv_sas.h b/drivers/scsi/mvsas/mv_sas.h
index 509d8f32a04ff..fe57665bdb505 100644
--- a/drivers/scsi/mvsas/mv_sas.h
+++ b/drivers/scsi/mvsas/mv_sas.h
@@ -428,7 +428,6 @@ void mvs_tag_clear(struct mvs_info *mvi, u32 tag);
 void mvs_tag_free(struct mvs_info *mvi, u32 tag);
 void mvs_tag_set(struct mvs_info *mvi, unsigned int tag);
 int mvs_tag_alloc(struct mvs_info *mvi, u32 *tag_out);
-void mvs_tag_init(struct mvs_info *mvi);
 void mvs_iounmap(void __iomem *regs);
 int mvs_ioremap(struct mvs_info *mvi, int bar, int bar_ex);
 void mvs_phys_reset(struct mvs_info *mvi, u32 phy_mask, int hard);
-- 
2.51.0



