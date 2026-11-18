Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033045;
	b=0weXCJi5j1aicyzprO4F6/49Gw3gGxG5CydsrNqRPGHcH9wVQqK49FdOeoRCQlHlRbIR
	 uOxdoWXKqyLX2K1TLbmatptCKNiH9mTM/8rQBTHK6bLmrMQ5nwAQdvqgTlBvX7TXgPf81
	 eNy5G4QQga0DYHGqF4SLjoMeMd2NEOx7vcPY+dpAHcKks7j9DOFQCrXuo2aPCuxEwgHJ0
	 PpVGWLNvFfvTwndhEpPuZYfZX0xUeAJbGdW2H/HMSSEeOM++detUJ1TywVrTf6b3y5mWY
	 MCRQ4aVhlBSpdbodkpZcf8TkbwueQVhHPF7QrwDHh4Xx3l7Czb6KQtLG4LWKMZzfFtA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033045;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ueKJuzyKn1zh24LXgmKjZg4nJWBJtsQ8s0iYDgqVcCo=;
	b=XbUPYh3QHqSJXaOFqfRI4wXwQCfhijQ2aGP/1nJNC8/Mm1dPYe1o//HtJKUnYPuPywZj
	 qQsagwj+g1iOrqlVEevu1c1LuVPmr4tEvqJv1IucOpVx3pymp/L1y7TQat4s3LuWtzlXL
	 c9Heowtn4H/pLMSN9TBsf7n694Z5pYIMMLBCufPceVIBDKn3+8XDVL297LJENfJ5H+UCB
	 4youL73glsWtRZIOU3d5Z54GIz9WDCa1igkzGNqJNNws04LOwNUmKaigjtAUEecIe3ljc
	 RXKnHcOGKsHSSiTXTUF08rKvFHufmyJBziuA7hslrKwD/knE8VrwrtC3zEIuvDtPoIw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GgHdzm3h;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E8E360A261D;
	Wed, 18 Nov 2026 20:17:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GgHdzm3h
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85E0B1F000C7;
	Wed, 18 Nov 2026 20:17:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033045;
	bh=ueKJuzyKn1zh24LXgmKjZg4nJWBJtsQ8s0iYDgqVcCo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GgHdzm3hCM/By+dQoJ/6/Gxi4DWvzVfkQbzUb3npujPDOIbSLEGCFiRipJRBOY9/R
	 YjcHB4TdAwFyltcOOoIP24k4jC8EHu/6+RErFK6QwPRXMm+ud/27a3lCS/KcCGC9zx
	 8qZaetUr1toGLMV2BMjxHtQaJLfVVnhT7zWmy+EQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Christoph Hellwig <hch@lst.de>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1628/1756] nvmet: ignore discard return value
Date: Wed, 18 Nov 2026 16:02:35 +0100
Message-ID: <20261118150114.614329334@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chaitanya Kulkarni <kch@nvidia.com>

[ Upstream commit 38d12f15c4772b5383b1249b2afb0d206a430f0f ]

__blkdev_issue_discard() always returns 0, making the error checking
in nvmet_bdev_discard_range() dead code.

Kill the function nvmet_bdev_discard_range() and call
__blkdev_issue_discard() directly from nvmet_bdev_execute_discard(),
since no error handling is needed anymore for __blkdev_issue_discard()
call.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Chaitanya Kulkarni <kch@nvidia.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Stable-dep-of: 424bd0e98ca4 ("nvmet: don't truncate the length of big discards")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/io-cmd-bdev.c | 28 +++++++---------------------
 1 file changed, 7 insertions(+), 21 deletions(-)

diff --git a/drivers/nvme/target/io-cmd-bdev.c b/drivers/nvme/target/io-cmd-bdev.c
index 3b081f421c81d..fea45ce033d3e 100644
--- a/drivers/nvme/target/io-cmd-bdev.c
+++ b/drivers/nvme/target/io-cmd-bdev.c
@@ -357,29 +357,14 @@ u16 nvmet_bdev_flush(struct nvmet_req *req)
 	return 0;
 }
 
-static u16 nvmet_bdev_discard_range(struct nvmet_req *req,
-		struct nvme_dsm_range *range, struct bio **bio)
-{
-	struct nvmet_ns *ns = req->ns;
-	int ret;
-
-	ret = __blkdev_issue_discard(ns->bdev,
-			nvmet_lba_to_sect(ns, range->slba),
-			le32_to_cpu(range->nlb) << (ns->blksize_shift - 9),
-			GFP_KERNEL, bio);
-	if (ret && ret != -EOPNOTSUPP) {
-		req->error_slba = le64_to_cpu(range->slba);
-		return errno_to_nvme_status(req, ret);
-	}
-	return NVME_SC_SUCCESS;
-}
-
 static void nvmet_bdev_execute_discard(struct nvmet_req *req)
 {
+	struct nvmet_ns *ns = req->ns;
 	struct nvme_dsm_range range;
 	struct bio *bio = NULL;
+	sector_t nr_sects;
 	int i;
-	u16 status;
+	u16 status = NVME_SC_SUCCESS;
 
 	for (i = 0; i <= le32_to_cpu(req->cmd->dsm.nr); i++) {
 		status = nvmet_copy_from_sgl(req, i * sizeof(range), &range,
@@ -387,9 +372,10 @@ static void nvmet_bdev_execute_discard(struct nvmet_req *req)
 		if (status)
 			break;
 
-		status = nvmet_bdev_discard_range(req, &range, &bio);
-		if (status)
-			break;
+		nr_sects = le32_to_cpu(range.nlb) << (ns->blksize_shift - 9);
+		__blkdev_issue_discard(ns->bdev,
+				nvmet_lba_to_sect(ns, range.slba), nr_sects,
+				GFP_KERNEL, &bio);
 	}
 
 	if (bio) {
-- 
2.53.0



