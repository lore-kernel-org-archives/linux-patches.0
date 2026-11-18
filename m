Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795042560;
	b=GlcH/jLqBfkhw44KrCMD0UqQe/ZIu5KQBrJfOsXybjdOy7iTZXWPeyhVQZy6Fa5rqdkc
	 bnjMk/UKswrA4R+Bv0+DJCrP7GSDwqghPAxQ7/T7zvu/ZjDbQ78uKVBtqxD9Iao2PR3x2
	 LotsBPq6qgT5kc8g4Dv+O+62XYeVFn7xTpWV4QKGkrUObtlw/ByQBLn3T+eK/WLrRmiZ5
	 p7osPITqZpw+tCT50yBCo4vGhmRvu8J/8giai0/SISfAbhbrUzAZ23r+2lmIN9i6cmGzU
	 cPXz5DdRFalfFhSiGTk3wPVtTwraZ6vPG56CVNqtRHQIq/VkjDNLJvs04np5e8C+gQg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795042560;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=T05c/WZyP1UAqP0EYMSrFD3qPvegqSJ0Yz/ZnUfj0vg=;
	b=AGf0jAfs13HzFfb4JCyOlFLi0maZqyfxVFhnn05XGBD0n/Aa38AvICNVddPunbDNwGak
	 xALL0SsM/NoGZk0rbFKyJ5Vhuxqtu7RZ/Yjqypg5iwIUdWd3cI3wOpwFemeenLbuZmXY+
	 XFS/rei2TOyi5P6HSRKSeWt9h25b01hclBeNh0hkG3yO7Bq7h6Eqc/31tDlG1Fk5YDcBt
	 NdPUcyxCORjo4Yw9m41a4+zHQqTdpwKpL2pAthnU4VjTm1CGjBT0EPNchWn9VWgIQ5CoI
	 dYOdQSMn2EbVbVXJOxEZ/tuSVViZHxP5PxO0loIjFW1/EzdLYb1z4sFQ2PL8ZjpDOnA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pUSE+z4e;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85609606A31C;
	Wed, 18 Nov 2026 22:56:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pUSE+z4e
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA4941F000C4;
	Wed, 18 Nov 2026 22:55:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795042560;
	bh=T05c/WZyP1UAqP0EYMSrFD3qPvegqSJ0Yz/ZnUfj0vg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pUSE+z4es/ueNVoNSL1UOCxSQoWpEO0bU2Mw7fYXBPld+rSxsNX8jX9QQGD4mIF4P
	 XwiTaadO8IyS2K5XkVCKqAa0K0VlxxmT30Zb9EKKZgQXPJfgEqkdHe1db/BqnL5kya
	 55+h9z1+jkkgGlp9mqwusYzeKRJdKHCMI8Ax+ccU=
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
Subject: [PATCH 6.6 3215/3318] nvmet: ignore discard return value
Date: Wed, 18 Nov 2026 16:03:57 +0100
Message-ID: <20261118150456.192477820@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index c7fa910128b42..aa8976a2e6284 100644
--- a/drivers/nvme/target/io-cmd-bdev.c
+++ b/drivers/nvme/target/io-cmd-bdev.c
@@ -359,29 +359,14 @@ u16 nvmet_bdev_flush(struct nvmet_req *req)
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
@@ -389,9 +374,10 @@ static void nvmet_bdev_execute_discard(struct nvmet_req *req)
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



