Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A8CA2512C0;
	Tue, 29 Apr 2025 17:00:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745946006; cv=none; b=h6nbWu1/+VS8JvZVragOGCZDXmWeSvI65uSM4ui8NG4tixAIPScfUauLMUGGcUTo+RTo9OCJQ3AV5cUS7bYxQoXkb6bkPBkyFmvjLess0IkF9cN+oJBRKe9SBONocPeQuVHqg/3w4pF3iJqQOLwDMx8FL98iQ3654Qp3oPRlF9o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745946006; c=relaxed/simple;
	bh=C/SyIL3tkAGiUFJB4WuJnJGSbK5QXXjajqLmTP8L6kY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L/LfcCUwAY8sR0V/k0V8Lq5sMNtzQ/J5xRZPa+i7+neDHi1RdmlsdPx18gadEZdqT+OmfiI4G8XdDqK6btvWlr0tvtXh3nIJTc4CeUZYv9yURslVaM5lph6Gu/RKJpO9AifllrYakS9QxNKypcyItraQ2p3lCVAg5OdtB8omCv8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZEVFfS/o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZEVFfS/o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89A02C4CEE3;
	Tue, 29 Apr 2025 17:00:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745946006;
	bh=C/SyIL3tkAGiUFJB4WuJnJGSbK5QXXjajqLmTP8L6kY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZEVFfS/oxBTz+Sn0BxQi0YGrulZp1E/lI9HpMPU9rpaeT4OFnWuVZHsXZG+NWB0LG
	 VMKa1+odoCQt7oIftLT1/0oGcfzjQ6TWk6U3AjwevhHfsf07/ivxorPzDLhmmTHYEY
	 JKX5bRGPOYv7bhF/NgsdhaFj1X+WBNwY1ze5emA8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Christian Brauner <brauner@kernel.org>,
	Tejun Heo <tj@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 082/311] block: move blkdev_{get,put} _no_open prototypes out of blkdev.h
Date: Tue, 29 Apr 2025 18:38:39 +0200
Message-ID: <20250429161124.416020541@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161121.011111832@linuxfoundation.org>
References: <20250429161121.011111832@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit c63202140d4b411d27380805c4d68eb11407b7f2 ]

These are only to be used by block internal code.  Remove the comment
as we grew more users due to reworking block device node opening.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Christian Brauner <brauner@kernel.org>
Acked-by: Tejun Heo <tj@kernel.org>
Link: https://lore.kernel.org/r/20250423053810.1683309-2-hch@lst.de
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Stable-dep-of: 5f33b5226c9d ("block: don't autoload drivers on stat")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk.h            | 3 +++
 include/linux/blkdev.h | 4 ----
 2 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/block/blk.h b/block/blk.h
index 9cf9a0099416d..c0120a3d9dc57 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -94,6 +94,9 @@ static inline void blk_wait_io(struct completion *done)
 		wait_for_completion_io(done);
 }
 
+struct block_device *blkdev_get_no_open(dev_t dev);
+void blkdev_put_no_open(struct block_device *bdev);
+
 #define BIO_INLINE_VECS 4
 struct bio_vec *bvec_alloc(mempool_t *pool, unsigned short *nr_vecs,
 		gfp_t gfp_mask);
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index d37751789bf58..6aa67e9b2ec08 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1649,10 +1649,6 @@ int bd_prepare_to_claim(struct block_device *bdev, void *holder,
 		const struct blk_holder_ops *hops);
 void bd_abort_claiming(struct block_device *bdev, void *holder);
 
-/* just for blk-cgroup, don't use elsewhere */
-struct block_device *blkdev_get_no_open(dev_t dev);
-void blkdev_put_no_open(struct block_device *bdev);
-
 struct block_device *I_BDEV(struct inode *inode);
 struct block_device *file_bdev(struct file *bdev_file);
 bool disk_live(struct gendisk *disk);
-- 
2.39.5



