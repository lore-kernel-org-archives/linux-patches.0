Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06BF61170E
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:06:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D230C433C7;
	Mon, 11 Sep 2023 14:06:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694441205;
	bh=grXhUn627fa520HWo/0ZWGJMCU+xnhu4fpytFhEpN+w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tirEU6mG6hO3NllyLAHp9llrf7eXliE4MA6bBvERt6pjCRB0u6F7L9DPHi4Jg6/zm
	 vupnel1Zj+cEMVFeqA57NdeIfRsqizr8NEfYs6MVDjpu/5OSJVOOSIO9n+gq/BgpbL
	 HmxlmMOmDauVQw0SMS3alTIy9PuBa5Qy2d2j83es=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Jinyoung Choi <j-young.choi@samsung.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 331/739] block: make bvec_try_merge_hw_page() non-static
Date: Mon, 11 Sep 2023 15:42:10 +0200
Message-ID: <20230911134700.339622852@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.921299741@linuxfoundation.org>
References: <20230911134650.921299741@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jinyoung Choi <j-young.choi@samsung.com>

[ Upstream commit 7c8998f75d2d42ddefb172239b0f689392958309 ]

This will be used for multi-page configuration for integrity payload.

Cc: Christoph Hellwig <hch@lst.de>
Cc: Martin K. Petersen <martin.petersen@oracle.com>

Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Jinyoung Choi <j-young.choi@samsung.com>
Tested-by: "Martin K. Petersen" <martin.petersen@oracle.com>
Reviewed-by: "Martin K. Petersen" <martin.petersen@oracle.com>
Link: https://lore.kernel.org/r/20230803024827epcms2p838d9e9131492c86a159fff25d195658f@epcms2p8
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Stable-dep-of: 0ece1d649b6d ("bio-integrity: create multi-page bvecs in bio_integrity_add_page()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/bio.c | 2 +-
 block/blk.h | 4 ++++
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/block/bio.c b/block/bio.c
index 0766584563f6e..00ac4c233e3aa 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -934,7 +934,7 @@ static bool bvec_try_merge_page(struct bio_vec *bv, struct page *page,
  * size limit.  This is not for normal read/write bios, but for passthrough
  * or Zone Append operations that we can't split.
  */
-static bool bvec_try_merge_hw_page(struct request_queue *q, struct bio_vec *bv,
+bool bvec_try_merge_hw_page(struct request_queue *q, struct bio_vec *bv,
 		struct page *page, unsigned len, unsigned offset,
 		bool *same_page)
 {
diff --git a/block/blk.h b/block/blk.h
index 608c5dcc516b5..b0dbbc4055966 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -76,6 +76,10 @@ struct bio_vec *bvec_alloc(mempool_t *pool, unsigned short *nr_vecs,
 		gfp_t gfp_mask);
 void bvec_free(mempool_t *pool, struct bio_vec *bv, unsigned short nr_vecs);
 
+bool bvec_try_merge_hw_page(struct request_queue *q, struct bio_vec *bv,
+		struct page *page, unsigned len, unsigned offset,
+		bool *same_page);
+
 static inline bool biovec_phys_mergeable(struct request_queue *q,
 		struct bio_vec *vec1, struct bio_vec *vec2)
 {
-- 
2.40.1



