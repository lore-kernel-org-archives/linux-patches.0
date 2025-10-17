Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37296330B17;
	Fri, 17 Oct 2025 15:51:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760716299; cv=none; b=YsksGqpd+cMTQOJ8L9BOtjLjgSxXw0qvNp/y1hfj65o+IuNcVXZcqGH9B6DfgsJs0zg7nu9ORtsLlIlptHyF9MCl0Wp0d0bcNSR1UooGymul86EaNGy0609swG3hKpUlK9fYC7EyflzHfwKJ1ETo4QKEAqgqlKVY7RCHEiTj8xQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760716299; c=relaxed/simple;
	bh=gohRUfHNiaTEUbv233h7qPKQnZTslC00ZfLleEvnZpA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KueARIjQLGYWhGLbI3NlJMkwIRXlj+b+Tvr1eOPKeFY9hOBylYEskN3KjTy8VjDZq+v2Duqmpkplb4Ndqjcz0pLdxjJ1v0KTgFHse7FMkS8+sOE0CDnDsvhaiDssmauOdIC15ETc6w7QR8HIfvHdr8DSe5TrQTTDdHb6fvZ/nH0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G8qmtZsx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G8qmtZsx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B144DC4CEE7;
	Fri, 17 Oct 2025 15:51:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760716299;
	bh=gohRUfHNiaTEUbv233h7qPKQnZTslC00ZfLleEvnZpA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G8qmtZsxc3g8s++GlDl14gsuLgQ/QRHPvsulsH/rkcE4VzjxNEgRU6ASh2A2ZpPeR
	 2Hpp8WNo4nUbQLpAl98LojnThdBHKQpMCF35pVK+Lz2gEdvfLCOF0DJ+RU0NcwyLBT
	 zNyyK9ZxSxvNZSxSquQqnByhB5tePwF8XziJRn0g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Garry <john.garry@huawei.com>,
	Damien Le Moal <damien.lemoal@opensource.wdc.com>,
	Hannes Reinecke <hare@suse.de>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 141/276] scsi: mvsas: Delete mvs_tag_init()
Date: Fri, 17 Oct 2025 16:53:54 +0200
Message-ID: <20251017145147.629838658@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145142.382145055@linuxfoundation.org>
References: <20251017145142.382145055@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 1c98662db080f..e2093e7637d82 100644
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
index efd11fabff937..3b4576dba590e 100644
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
index fa654c73beeee..8dd30f8b478ec 100644
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



