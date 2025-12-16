Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39FFB3314B4;
	Tue, 16 Dec 2025 11:35:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765884916; cv=none; b=dM4IPBYi/M96pZuc1BvO/E9aiVO9YagJWWvHjNlIlQCw0pmkDZf65lZveOxNQGB/5mLj3wgENE2qv3tp4Xgae1XhqlBQFq4EARbFYwMeZ2GsZbIhGDrRjP+fepCwSKUzjsTIUeVFECFKPqTedTKhYY2IjEUyB8Xsv3VBoqz7XLM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765884916; c=relaxed/simple;
	bh=lZZdmZmW+77EILlD8BqNZCBfMvcuSHpMg5xgz6Dk/qU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oGNz3dsOO14+/ZIWnu8XOsP8nC9to74P6BoDyws5y/v1JdgjVnt/9h6zzAt23jlhdBs5oP0ARpMHv8iwz8vU14PupZ6njSLJkpzsJVP0Fr2+qhTgNertjr90HoGWtdc1FN7lDmEmdnx5li8y9NwfDDndrjOEs6k56sfofv8vxy0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hYP63Dlw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hYP63Dlw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57696C4CEF1;
	Tue, 16 Dec 2025 11:35:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765884915;
	bh=lZZdmZmW+77EILlD8BqNZCBfMvcuSHpMg5xgz6Dk/qU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hYP63Dlw3SvQ87sE5KDyIKgdL2rIyhLymcVRWnYntmsvhZaWiBypovYilUXUWD5m1
	 toZM9Fk2GPMeM+eLqcq4V4kVnFQ2gH/cUZASIyveyotHtY44Ci4eDExZDslq2zEbNR
	 HOS71Cxb+ySfs6qRldBJyqDoPb9NYhRJkYjopwOU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	John Garry <john.g.garry@oracle.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 337/354] block: return unsigned int from queue_dma_alignment
Date: Tue, 16 Dec 2025 12:15:04 +0100
Message-ID: <20251216111333.117339143@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111320.896758933@linuxfoundation.org>
References: <20251216111320.896758933@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit ed5db174cf39374215934f21b04639a7a1513023 ]

The underlying limit is defined as an unsigned int, so return that from
queue_dma_alignment as well.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: John Garry <john.g.garry@oracle.com>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Link: https://lore.kernel.org/r/20241119160932.1327864-3-hch@lst.de
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Stable-dep-of: 2c38ec934ddf ("block: fix cached zone reports on devices with native zone append")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/blkdev.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index cd9c97f6f9484..11d0a1b8daa2c 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1450,7 +1450,7 @@ static inline bool bdev_is_zone_start(struct block_device *bdev,
 int blk_zone_issue_zeroout(struct block_device *bdev, sector_t sector,
 			   sector_t nr_sects, gfp_t gfp_mask);
 
-static inline int queue_dma_alignment(const struct request_queue *q)
+static inline unsigned int queue_dma_alignment(const struct request_queue *q)
 {
 	return q->limits.dma_alignment;
 }
-- 
2.51.0



