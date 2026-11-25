Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795624412;
	b=2qo6WGa1OmaDbUa3ASVy5sJY8B4XVjWRLASDKq/iPZBl8dF8j0z5flqyG/15K9fM4P+A
	 ouBolcRv0KSfVkdiTiisZs6ZFeqJ7lriYP/PUoZre/r6XkIeFvRJl6kpu9T0LbvzSgNmf
	 nTrzRnA4EzhHjnizznd3D1X3ohG321vgC7Q4yQUgB+FeXZqQ/7JKaywq3DZqMZ2l3DOPV
	 6mrIw93HyRCufjOkxYT8sqW9ZwFKtO0JQFPx5soNJyXvojarvwNoN4nvu+oiol9kROERv
	 1a+K3VpIcCMIC/v4XYqmSEb98CqNfhXCJNX6m9EWbB/tR1U3QhAT1/zQvS5BUzgIwAA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795624412;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9J/Rfe8FvLzH7iq1f/XVONEF+KdH13IA6kqEr8mWYmQ=;
	b=t7rys7u75qxRuWSwisM89xrcfbANrIQaZGL8jME2+exWhkdtEhei9vYuqOH2f3w9hj9C
	 jj78G6JayjF6ZLccG4H3hawjOzsbbZffHTKfY29mYDbWdAlJu7sspcddypnSNopGNR/NV
	 6Ilj5dBoxsS44KZamod34hlCqGm1BR279p9ZguQsLCmfA/2QAED5tjKgRbdnmTZArtutV
	 CBYwgc6l0nTMFDtPtC1LqzKXC135JAuyxYNiTnCwfZF/kWHGN561N7kLRrRHuunHx2pj3
	 1cL/DFH7N2KsNKcBWZZhlQn7gb2llKuDIHiZk3xEzv5ye8YjoOssR6J/jdEcIA6QccQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RbdFnvHI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0A7F606A687;
	Wed, 25 Nov 2026 16:33:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RbdFnvHI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78C1D1F000CF;
	Wed, 25 Nov 2026 16:33:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795624412;
	bh=9J/Rfe8FvLzH7iq1f/XVONEF+KdH13IA6kqEr8mWYmQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RbdFnvHIGDglxP4IOJMfDIvIiJ5iLqSE+ZqSnzRXZl/tyt4b6rPTRBDXy8WDyT9na
	 fEfiNT/kbh2LiJFItvRbjrzqxFJtGEWREyXZagNazxd+oUveLFwW604bUaqOWpTOUn
	 yP7IjUKS12SmHjOaYJTyNCzUZjk9vyb9Njv45oxQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	zhangguopeng <zhangguopeng@kylinos.cn>,
	Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 185/816] block: Replace sprintf() with sysfs_emit()
Date: Wed, 25 Nov 2026 15:28:53 +0100
Message-ID: <20261125143853.480308439@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

From: zhangguopeng <zhangguopeng@kylinos.cn>

[ Upstream commit 8e71afb94d6ed59055b67dadbc423c70104f21a9 ]

Per Documentation/filesystems/sysfs.rst, show() should only use
sysfs_emit() or sysfs_emit_at() when formatting the value to be
returned to user space.

No functional change intended.

Signed-off-by: zhangguopeng <zhangguopeng@kylinos.cn>
Suggested-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Link: https://lore.kernel.org/r/20241107104258.29742-1-zhangguopeng@kylinos.cn
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Stable-dep-of: 2516f0413f87 ("block: report the correct discard alignment in sysfs")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-sysfs.c | 24 ++++++++++++------------
 block/genhd.c     | 30 +++++++++++++++---------------
 2 files changed, 27 insertions(+), 27 deletions(-)

diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
index d53ffff112ff2..f21de1898ff15 100644
--- a/block/blk-sysfs.c
+++ b/block/blk-sysfs.c
@@ -32,7 +32,7 @@ struct queue_sysfs_entry {
 static ssize_t
 queue_var_show(unsigned long var, char *page)
 {
-	return sprintf(page, "%lu\n", var);
+	return sysfs_emit(page, "%lu\n", var);
 }
 
 static ssize_t
@@ -123,7 +123,7 @@ QUEUE_SYSFS_LIMIT_SHOW(atomic_write_unit_max)
 #define QUEUE_SYSFS_LIMIT_SHOW_SECTORS_TO_BYTES(_field)			\
 static ssize_t queue_##_field##_show(struct gendisk *disk, char *page)	\
 {									\
-	return sprintf(page, "%llu\n",					\
+	return sysfs_emit(page, "%llu\n",				\
 		(unsigned long long)disk->queue->limits._field <<	\
 			SECTOR_SHIFT);					\
 }
@@ -146,7 +146,7 @@ QUEUE_SYSFS_LIMIT_SHOW_SECTORS_TO_KB(max_hw_sectors)
 #define QUEUE_SYSFS_SHOW_CONST(_name, _val)				\
 static ssize_t queue_##_name##_show(struct gendisk *disk, char *page)	\
 {									\
-	return sprintf(page, "%d\n", _val);				\
+	return sysfs_emit(page, "%d\n", _val);				\
 }
 
 /* deprecated fields */
@@ -221,7 +221,7 @@ static ssize_t queue_feature_store(struct gendisk *disk, const char *page,
 #define QUEUE_SYSFS_FEATURE(_name, _feature)				\
 static ssize_t queue_##_name##_show(struct gendisk *disk, char *page)	\
 {									\
-	return sprintf(page, "%u\n",					\
+	return sysfs_emit(page, "%u\n",					\
 		!!(disk->queue->limits.features & _feature));		\
 }									\
 static int queue_##_name##_store(struct gendisk *disk,			\
@@ -238,7 +238,7 @@ QUEUE_SYSFS_FEATURE(stable_writes, BLK_FEAT_STABLE_WRITES);
 #define QUEUE_SYSFS_FEATURE_SHOW(_name, _feature)			\
 static ssize_t queue_##_name##_show(struct gendisk *disk, char *page)	\
 {									\
-	return sprintf(page, "%u\n",					\
+	return sysfs_emit(page, "%u\n",					\
 		!!(disk->queue->limits.features & _feature));		\
 }
 
@@ -256,8 +256,8 @@ static ssize_t queue_poll_show(struct gendisk *disk, char *page)
 static ssize_t queue_zoned_show(struct gendisk *disk, char *page)
 {
 	if (blk_queue_is_zoned(disk->queue))
-		return sprintf(page, "host-managed\n");
-	return sprintf(page, "none\n");
+		return sysfs_emit(page, "host-managed\n");
+	return sysfs_emit(page, "none\n");
 }
 
 static ssize_t queue_nr_zones_show(struct gendisk *disk, char *page)
@@ -342,7 +342,7 @@ static ssize_t queue_poll_store(struct gendisk *disk, const char *page,
 
 static ssize_t queue_io_timeout_show(struct gendisk *disk, char *page)
 {
-	return sprintf(page, "%u\n", jiffies_to_msecs(disk->queue->rq_timeout));
+	return sysfs_emit(page, "%u\n", jiffies_to_msecs(disk->queue->rq_timeout));
 }
 
 static ssize_t queue_io_timeout_store(struct gendisk *disk, const char *page,
@@ -363,8 +363,8 @@ static ssize_t queue_io_timeout_store(struct gendisk *disk, const char *page,
 static ssize_t queue_wc_show(struct gendisk *disk, char *page)
 {
 	if (blk_queue_write_cache(disk->queue))
-		return sprintf(page, "write back\n");
-	return sprintf(page, "write through\n");
+		return sysfs_emit(page, "write back\n");
+	return sysfs_emit(page, "write through\n");
 }
 
 static int queue_wc_store(struct gendisk *disk, const char *page,
@@ -495,9 +495,9 @@ static ssize_t queue_wb_lat_show(struct gendisk *disk, char *page)
 		return -EINVAL;
 
 	if (wbt_disabled(disk->queue))
-		return sprintf(page, "0\n");
+		return sysfs_emit(page, "0\n");
 
-	return sprintf(page, "%llu\n",
+	return sysfs_emit(page, "%llu\n",
 		div_u64(wbt_get_min_lat(disk->queue), 1000));
 }
 
diff --git a/block/genhd.c b/block/genhd.c
index 4063ee78c27bd..f5d082b39fd12 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -772,7 +772,7 @@ static ssize_t disk_badblocks_show(struct device *dev,
 	struct gendisk *disk = dev_to_disk(dev);
 
 	if (!disk->bb)
-		return sprintf(page, "\n");
+		return sysfs_emit(page, "\n");
 
 	return badblocks_show(disk->bb, page, 0);
 }
@@ -932,7 +932,7 @@ static ssize_t disk_range_show(struct device *dev,
 {
 	struct gendisk *disk = dev_to_disk(dev);
 
-	return sprintf(buf, "%d\n", disk->minors);
+	return sysfs_emit(buf, "%d\n", disk->minors);
 }
 
 static ssize_t disk_ext_range_show(struct device *dev,
@@ -940,7 +940,7 @@ static ssize_t disk_ext_range_show(struct device *dev,
 {
 	struct gendisk *disk = dev_to_disk(dev);
 
-	return sprintf(buf, "%d\n",
+	return sysfs_emit(buf, "%d\n",
 		(disk->flags & GENHD_FL_NO_PART) ? 1 : DISK_MAX_PARTS);
 }
 
@@ -949,7 +949,7 @@ static ssize_t disk_removable_show(struct device *dev,
 {
 	struct gendisk *disk = dev_to_disk(dev);
 
-	return sprintf(buf, "%d\n",
+	return sysfs_emit(buf, "%d\n",
 		       (disk->flags & GENHD_FL_REMOVABLE ? 1 : 0));
 }
 
@@ -958,7 +958,7 @@ static ssize_t disk_hidden_show(struct device *dev,
 {
 	struct gendisk *disk = dev_to_disk(dev);
 
-	return sprintf(buf, "%d\n",
+	return sysfs_emit(buf, "%d\n",
 		       (disk->flags & GENHD_FL_HIDDEN ? 1 : 0));
 }
 
@@ -967,13 +967,13 @@ static ssize_t disk_ro_show(struct device *dev,
 {
 	struct gendisk *disk = dev_to_disk(dev);
 
-	return sprintf(buf, "%d\n", get_disk_ro(disk) ? 1 : 0);
+	return sysfs_emit(buf, "%d\n", get_disk_ro(disk) ? 1 : 0);
 }
 
 ssize_t part_size_show(struct device *dev,
 		       struct device_attribute *attr, char *buf)
 {
-	return sprintf(buf, "%llu\n", bdev_nr_sectors(dev_to_bdev(dev)));
+	return sysfs_emit(buf, "%llu\n", bdev_nr_sectors(dev_to_bdev(dev)));
 }
 
 ssize_t part_stat_show(struct device *dev,
@@ -990,7 +990,7 @@ ssize_t part_stat_show(struct device *dev,
 		part_stat_unlock();
 	}
 	part_stat_read_all(bdev, &stat);
-	return sprintf(buf,
+	return sysfs_emit(buf,
 		"%8lu %8lu %8llu %8u "
 		"%8lu %8lu %8llu %8u "
 		"%8u %8u %8u "
@@ -1032,14 +1032,14 @@ ssize_t part_inflight_show(struct device *dev, struct device_attribute *attr,
 	else
 		part_in_flight_rw(bdev, inflight);
 
-	return sprintf(buf, "%8u %8u\n", inflight[0], inflight[1]);
+	return sysfs_emit(buf, "%8u %8u\n", inflight[0], inflight[1]);
 }
 
 static ssize_t disk_capability_show(struct device *dev,
 				    struct device_attribute *attr, char *buf)
 {
 	dev_warn_once(dev, "the capability attribute has been deprecated.\n");
-	return sprintf(buf, "0\n");
+	return sysfs_emit(buf, "0\n");
 }
 
 static ssize_t disk_alignment_offset_show(struct device *dev,
@@ -1048,7 +1048,7 @@ static ssize_t disk_alignment_offset_show(struct device *dev,
 {
 	struct gendisk *disk = dev_to_disk(dev);
 
-	return sprintf(buf, "%d\n", bdev_alignment_offset(disk->part0));
+	return sysfs_emit(buf, "%d\n", bdev_alignment_offset(disk->part0));
 }
 
 static ssize_t disk_discard_alignment_show(struct device *dev,
@@ -1057,7 +1057,7 @@ static ssize_t disk_discard_alignment_show(struct device *dev,
 {
 	struct gendisk *disk = dev_to_disk(dev);
 
-	return sprintf(buf, "%d\n", bdev_alignment_offset(disk->part0));
+	return sysfs_emit(buf, "%d\n", bdev_alignment_offset(disk->part0));
 }
 
 static ssize_t diskseq_show(struct device *dev,
@@ -1065,13 +1065,13 @@ static ssize_t diskseq_show(struct device *dev,
 {
 	struct gendisk *disk = dev_to_disk(dev);
 
-	return sprintf(buf, "%llu\n", disk->diskseq);
+	return sysfs_emit(buf, "%llu\n", disk->diskseq);
 }
 
 static ssize_t partscan_show(struct device *dev,
 		struct device_attribute *attr, char *buf)
 {
-	return sprintf(buf, "%u\n", disk_has_partscan(dev_to_disk(dev)));
+	return sysfs_emit(buf, "%u\n", disk_has_partscan(dev_to_disk(dev)));
 }
 
 static DEVICE_ATTR(range, 0444, disk_range_show, NULL);
@@ -1093,7 +1093,7 @@ static DEVICE_ATTR(partscan, 0444, partscan_show, NULL);
 ssize_t part_fail_show(struct device *dev,
 		       struct device_attribute *attr, char *buf)
 {
-	return sprintf(buf, "%d\n",
+	return sysfs_emit(buf, "%d\n",
 		       bdev_test_flag(dev_to_bdev(dev), BD_MAKE_IT_FAIL));
 }
 
-- 
2.53.0



