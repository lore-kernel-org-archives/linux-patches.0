Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795028104;
	b=drTLJE7wlx7NJE0YBBUaVRuJIAIVEf+Mwh3Zm3AgAkpE9Wg6LcQBPxmZnAFKYYVWDNpB
	 yXFNPcW+6LW2yBz0RPA2PQHC3XzzfguZgHxNpzbHr7HIplfyUxg1M6QRIpKgvX2JOqASi
	 +a+FAl5AbnHzFrN8JwpWWJ8JF6diKIr4DO+qA3sHoaDOXQDTZjT0+NerOC7LrdEyprcKn
	 SSVHUeMRMJ8kYSIgewNOoW4q9VlzrVeNP0X50CCh/zsEDVvQieHCfYufdvP6y0VwY0nfo
	 bwSLzb7StmsLMK28FSvCNXQVkjR23/wZEcqWSj86N7mka9GTS3jpt0VsWxj/J5uCfig==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795028104;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Vs2G7scQtVilfSuSTvEtCbIQ+NnnRJgjhqRaeHlgNRU=;
	b=eRWBugBBvoZoQPkhlLMofhHrhIFfM1H77HrBYoZjEcvhiguPyFJmYJ8+zxvHPyG2jtNv
	 +KT7pwjOtmjrD2Ppr3QO3HhANyz7+dbIz3jliuCcecEfDdPwimOC7ZRg6aHlAh1J/XkQO
	 DeUCJ6PpmIzCrTr1VOb+p0m2d/P1+CLa895HWLwy+/l4E4xVYagV6b0tcpvcRNYZgfWNJ
	 ifxEqjNsfogjwRGasoF7GAaA76Xw3fhX/GX+tw+ft/doLmsHHU0Q2Dk5LiPgXPrlu9jWy
	 75iG5rhkweyIBbuswJgo3Icoe3h1h70FUyVKGh91W9Pgcw2s/2FWNLTt/M0BcdmEIOg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DGeUAxLx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18F59606A31C;
	Wed, 18 Nov 2026 18:55:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DGeUAxLx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F2951F000C4;
	Wed, 18 Nov 2026 18:55:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795028104;
	bh=Vs2G7scQtVilfSuSTvEtCbIQ+NnnRJgjhqRaeHlgNRU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DGeUAxLxvZJ8GB03ZVteA/8Ko0oiZSVex3OvvELGkIyFKlDLxJMpEJb4w8LQ58hu/
	 FLb6YdLbzqSceLkD9hMb5TS9EmiL8KKyshuF0ZXfVV/zbnT3L2yeUpbF6Skg73zNv7
	 IeufaYq+ZehOh7Z1PL6JT9tJ4BlWtv0bKwKL/6Fs=
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
Subject: [PATCH 6.18 2026/2151] nvmet: ignore discard return value
Date: Wed, 18 Nov 2026 16:02:41 +0100
Message-ID: <20261118150235.540876559@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 160364cc8c980..02150f698f216 100644
--- a/drivers/nvme/target/io-cmd-bdev.c
+++ b/drivers/nvme/target/io-cmd-bdev.c
@@ -364,29 +364,14 @@ u16 nvmet_bdev_flush(struct nvmet_req *req)
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
@@ -394,9 +379,10 @@ static void nvmet_bdev_execute_discard(struct nvmet_req *req)
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



