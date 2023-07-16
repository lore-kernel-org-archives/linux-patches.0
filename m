Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D0B58F40
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:30:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00F2CC433C7;
	Sun, 16 Jul 2023 20:30:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689539453;
	bh=kKz/RfCcX02SUqhb/e9rVCXxsqGSIiIXhRZsJ5zvvfM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kXtGzWCj79hKzsxjS7ocWSFBWNT4KwNC+mawzy+un28008j7JEjDjPBlByARWQ1nn
	 0W6vmAGi9epOMkOwIvNd7MqiyY1c1CY6m4HMvyQ7MiQ6lBL4hk74yhGl520NKuc0eX
	 MMchLFECWOJgDOoJMclw8vJoAs+KxQzi55oMAZ08=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Pankaj Raghav <p.raghav@samsung.com>,
	Christoph Hellwig <hch@lst.de>,
	Damien Le Moal <dlemoal@kernel.org>,
	Hannes Reinecke <hare@suse.de>,
	Ming Lei <ming.lei@redhat.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 003/591] block: Fix the type of the second bdev_op_is_zoned_write() argument
Date: Sun, 16 Jul 2023 21:42:22 +0200
Message-ID: <20230716194923.955444077@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194923.861634455@linuxfoundation.org>
References: <20230716194923.861634455@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Bart Van Assche <bvanassche@acm.org>

[ Upstream commit 3ddbe2a7e0d4a155a805f69c906c9beed30d4cc4 ]

Change the type of the second argument of bdev_op_is_zoned_write() from
blk_opf_t into enum req_op because this function expects an operation
without flags as second argument.

Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Reviewed-by: Pankaj Raghav <p.raghav@samsung.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Cc: Ming Lei <ming.lei@redhat.com>
Fixes: 8cafdb5ab94c ("block: adapt blk_mq_plug() to not plug for writes that require a zone lock")
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Link: https://lore.kernel.org/r/20230517174230.897144-4-bvanassche@acm.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/blkdev.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 891f8cbcd0436..427e79ac72194 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1305,7 +1305,7 @@ static inline bool bdev_is_zoned(struct block_device *bdev)
 }
 
 static inline bool bdev_op_is_zoned_write(struct block_device *bdev,
-					  blk_opf_t op)
+					  enum req_op op)
 {
 	if (!bdev_is_zoned(bdev))
 		return false;
-- 
2.39.2



