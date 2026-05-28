Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E954D2F691F;
	Thu, 28 May 2026 20:06:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779998790; cv=none; b=c8z48yKzjj45EnNeS1lctSfu6PAHSyhkPpcZ48h0W2fl/1T011O8f5RgJ2VG4PqrqyqsEEBEYnO1CE/3XvWd9plt6UtSUAm2IMK41WAb1dGV3R8QCeZT4/KlCf99hKNkN68+1mp+WvstQCxQX0suEuLZ0TdyDgtPmB6Sb1YO8KU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779998790; c=relaxed/simple;
	bh=fRj0fDpIfc7foOS6/KK71ATk48VpJEcJOt41bLL+c34=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hyx0EPSg+ReD5G0WYlzoZKZn/18HFkF2QljX/jkIPM5TUeZpmS2AsrJpN5fND+QCOhzHx/KhuMfvWGKlIRZXE0W2q3NcLURbqwVN+50yRoiLdtTCwRsWltTqRHqzHCtal9ps65YCAt9oa+AISAQP1Di2DfCfAtBxQdwBAKveu0o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YC6cUClN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YC6cUClN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58CBD1F00A3A;
	Thu, 28 May 2026 20:06:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779998788;
	bh=kj4LpTRarkGr+tAR+erZaapdw0CYlurGV4qWoPMNcOs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YC6cUClN/Xw4TaIAADqOSZMwyVafWtb+FIyJTDpKNN/FZlXIVTJPm9my+0e658SAK
	 cGZ+ssF6DwW3L61YBxLnEdzVWpCR/c779yS1EwWUt9KEWDvykwoO5rinlRSLjGaP1R
	 C3D/GsZufFvfMh+VViYBcW1lIzZjGOZ00U73FJSg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	Hannes Reinecke <hare@suse.de>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Christoph Hellwig <hch@lst.de>,
	Bart Van Assche <bvanassche@acm.org>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 298/461] block: rename struct gendisk zone_wplugs_lock field
Date: Thu, 28 May 2026 21:47:07 +0200
Message-ID: <20260528194655.854889620@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194646.819809818@linuxfoundation.org>
References: <20260528194646.819809818@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Damien Le Moal <dlemoal@kernel.org>

[ Upstream commit b7cbc30e93e3a64ea058230f6d0c764d6d80276f ]

Rename struct gendisk zone_wplugs_lock field to zone_wplugs_hash_lock to
clearly indicates that this is the spinlock used for manipulating the
hash table of zone write plugs.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Stable-dep-of: 836efd35c472 ("block: fix handling of dead zone write plugs")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-zoned.c      | 23 ++++++++++++-----------
 include/linux/blkdev.h |  2 +-
 2 files changed, 13 insertions(+), 12 deletions(-)

diff --git a/block/blk-zoned.c b/block/blk-zoned.c
index a4d82342e37ac..2fa7f7b5f4c80 100644
--- a/block/blk-zoned.c
+++ b/block/blk-zoned.c
@@ -520,10 +520,11 @@ static bool disk_insert_zone_wplug(struct gendisk *disk,
 	 * are racing with other submission context, so we may already have a
 	 * zone write plug for the same zone.
 	 */
-	spin_lock_irqsave(&disk->zone_wplugs_lock, flags);
+	spin_lock_irqsave(&disk->zone_wplugs_hash_lock, flags);
 	hlist_for_each_entry_rcu(zwplg, &disk->zone_wplugs_hash[idx], node) {
 		if (zwplg->zone_no == zwplug->zone_no) {
-			spin_unlock_irqrestore(&disk->zone_wplugs_lock, flags);
+			spin_unlock_irqrestore(&disk->zone_wplugs_hash_lock,
+					       flags);
 			return false;
 		}
 	}
@@ -535,7 +536,7 @@ static bool disk_insert_zone_wplug(struct gendisk *disk,
 	 * necessarilly in the active condition.
 	 */
 	zones_cond = rcu_dereference_check(disk->zones_cond,
-				lockdep_is_held(&disk->zone_wplugs_lock));
+				lockdep_is_held(&disk->zone_wplugs_hash_lock));
 	if (zones_cond)
 		zwplug->cond = zones_cond[zwplug->zone_no];
 	else
@@ -543,7 +544,7 @@ static bool disk_insert_zone_wplug(struct gendisk *disk,
 
 	hlist_add_head_rcu(&zwplug->node, &disk->zone_wplugs_hash[idx]);
 	atomic_inc(&disk->nr_zone_wplugs);
-	spin_unlock_irqrestore(&disk->zone_wplugs_lock, flags);
+	spin_unlock_irqrestore(&disk->zone_wplugs_hash_lock, flags);
 
 	return true;
 }
@@ -596,13 +597,13 @@ static void disk_free_zone_wplug(struct blk_zone_wplug *zwplug)
 	WARN_ON_ONCE(zwplug->flags & BLK_ZONE_WPLUG_PLUGGED);
 	WARN_ON_ONCE(!bio_list_empty(&zwplug->bio_list));
 
-	spin_lock_irqsave(&disk->zone_wplugs_lock, flags);
+	spin_lock_irqsave(&disk->zone_wplugs_hash_lock, flags);
 	blk_zone_set_cond(rcu_dereference_check(disk->zones_cond,
-				lockdep_is_held(&disk->zone_wplugs_lock)),
+				lockdep_is_held(&disk->zone_wplugs_hash_lock)),
 			  zwplug->zone_no, zwplug->cond);
 	hlist_del_init_rcu(&zwplug->node);
 	atomic_dec(&disk->nr_zone_wplugs);
-	spin_unlock_irqrestore(&disk->zone_wplugs_lock, flags);
+	spin_unlock_irqrestore(&disk->zone_wplugs_hash_lock, flags);
 
 	call_rcu(&zwplug->rcu_head, disk_free_zone_wplug_rcu);
 }
@@ -1749,7 +1750,7 @@ static void blk_zone_wplug_bio_work(struct work_struct *work)
 
 void disk_init_zone_resources(struct gendisk *disk)
 {
-	spin_lock_init(&disk->zone_wplugs_lock);
+	spin_lock_init(&disk->zone_wplugs_hash_lock);
 }
 
 /*
@@ -1839,10 +1840,10 @@ static void disk_set_zones_cond_array(struct gendisk *disk, u8 *zones_cond)
 {
 	unsigned long flags;
 
-	spin_lock_irqsave(&disk->zone_wplugs_lock, flags);
+	spin_lock_irqsave(&disk->zone_wplugs_hash_lock, flags);
 	zones_cond = rcu_replace_pointer(disk->zones_cond, zones_cond,
-				lockdep_is_held(&disk->zone_wplugs_lock));
-	spin_unlock_irqrestore(&disk->zone_wplugs_lock, flags);
+				lockdep_is_held(&disk->zone_wplugs_hash_lock));
+	spin_unlock_irqrestore(&disk->zone_wplugs_hash_lock, flags);
 
 	kfree_rcu_mightsleep(zones_cond);
 }
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index d463b9b5a0a59..6890900237707 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -200,7 +200,7 @@ struct gendisk {
 	u8 __rcu		*zones_cond;
 	unsigned int		zone_wplugs_hash_bits;
 	atomic_t		nr_zone_wplugs;
-	spinlock_t		zone_wplugs_lock;
+	spinlock_t		zone_wplugs_hash_lock;
 	struct mempool		*zone_wplugs_pool;
 	struct hlist_head	*zone_wplugs_hash;
 	struct workqueue_struct *zone_wplugs_wq;
-- 
2.53.0



