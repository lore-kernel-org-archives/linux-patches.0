Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795050613;
	b=tV08kwpgP6WVanU+Y3sq9kF4t6rfCC6KgKbZNsIIgx5pR4YtkWvqDxda1aneQWttCvWy
	 bjl+e9vcmO9oxTi5aUOn47U3KuptIENwH0PeOvrCgmVXsPnVsKmA880tq+ycRSxrnZuaj
	 tHnLZbuNAL7YkxW7sL+joYPmDpRFHbKmCUhr4HgjDGWtbN2lNGtVBivoWWbHQxR9ZU41I
	 pU580/DOqKlzFDD0nohsKQ8ZfqRFwkCEShBKVw8YbJXP5EzqLzmEkKD/NRhTcZ+2UYdee
	 es2C0X6wzLUwyh8Rsd4XhACghBPbJ5JsGotWNyIdFcEHCnbeNImh79cDY8kecv+mNFw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795050613;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=873SjyL0EcFFSvI3ywIBhiB2ERu9j3PFQEo97+Mgmq4=;
	b=k7yFyEpSHVroBCHdXx/GxUqCkUYmZPDfEBidbz35YBwKD+1/LMrnAXWohnKpO9T+FlLL
	 iXGmiriAX2BBQLYGMRBLFBnQz1HtXoTQaTADDqqXpwIEGz5lX0M07Ym5lHZuwMmTf7xi4
	 aYJAKdoKdwkcossD4Wt+UeJj/2HlBEoeCEUbFGxqbnPE62TTmQ6WWBOCq99ucujegr+bt
	 3zog6Rns9usX9diIWWF9EW1SRDXPpOCtjqbJPZVX2qN/jcMCZe54b5trsSDcu8KA095n2
	 lql8EbrveXubrVGv8jv8VUX0QVmJlqjVPQorG771hvKHlI8PqkrCcdflpZrKq7tg7Xw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1LXLsZ7c;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7913C606A31C;
	Thu, 19 Nov 2026 01:10:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1LXLsZ7c
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D32811F000C4;
	Thu, 19 Nov 2026 01:10:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795050613;
	bh=873SjyL0EcFFSvI3ywIBhiB2ERu9j3PFQEo97+Mgmq4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1LXLsZ7cg1rMAeR1A9IgMjMX33CIaqdBCTymHoAmoRjMxLWodmzUEq1jD/tjuC3CQ
	 Gi+ikdb+pOlTqJOKRh95G/bA7ONYc+JrHpLOtV46WgO7HX3t8ENksV+8ptVQoUPakx
	 EJ1t4YHk+k6onZvnGoJMNQXf5Ywvqq9Amc4AFbRQ=
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
Subject: [PATCH 6.1 2771/2857] nvmet: ignore discard return value
Date: Wed, 18 Nov 2026 16:03:25 +0100
Message-ID: <20261118150341.372299913@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index bb71ae68562ab..d6807fd0c09d9 100644
--- a/drivers/nvme/target/io-cmd-bdev.c
+++ b/drivers/nvme/target/io-cmd-bdev.c
@@ -360,29 +360,14 @@ u16 nvmet_bdev_flush(struct nvmet_req *req)
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
@@ -390,9 +375,10 @@ static void nvmet_bdev_execute_discard(struct nvmet_req *req)
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



