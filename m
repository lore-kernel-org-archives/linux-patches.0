Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DC6F332ECB;
	Wed, 25 Feb 2026 06:59:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772002797; cv=none; b=Lh+/+dE8Q9zc7AsB0N10/XMMDqZnKC63daMfeBWmEkkDh47OwikFSA90wYuvgaT46JErpTnvLRE+okR0K4fKIkHoCcZSJA0JV/2jGg/NQjPJjpwl/0tP6BzlEgUj9ww+7lg7oVr3NYQpEiknOtiagGNrOGFjkgsX466UMhkekos=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772002797; c=relaxed/simple;
	bh=6D+VY7t02IedMrrds+M6X4ZBOa/L4Cdf+x+fTNzjHU0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bd96fE6kLFDeyrPULrr2mfM6TlHCsbowdy6tD+E5oXOY3qEkkMfk/t/o7BKtAnRxJEn4wm8ppEHxbNSaWsA+zeNdVvUJEV4k4U0p3NjuqNeGll/qgacGugpSvd4TKfddOkghfaqfPcSkcMO5HPir3GzABzJbZm31cRG/6R4bxLc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lHSpiETd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lHSpiETd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 554A1C116D0;
	Wed, 25 Feb 2026 06:59:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1772002797;
	bh=6D+VY7t02IedMrrds+M6X4ZBOa/L4Cdf+x+fTNzjHU0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lHSpiETd5VJ7FRefUS4Antp5amEFf4YSYN6QQsdFTQaSkEhZUznPSWfRdwamTwk9b
	 u4coYXex2QodRcMqdeoviMGdzzqDK58W8HNhN6YYejg9cuKfWwqvSO3eZvT2UES0zU
	 fSXOxMajj/XUv093mZ+ZAHJ3RpKGdCXw8zmPPv9U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Anand Jain <asj@kernel.org>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 602/641] btrfs: remove fs_info argument from btrfs_try_granting_tickets()
Date: Tue, 24 Feb 2026 17:25:28 -0800
Message-ID: <20260225012403.102124966@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Filipe Manana <fdmanana@suse.com>

[ Upstream commit e3df6408b13a75cf73e543e53453f28261874c6f ]

We don't need it since we can grab fs_info from the given space_info.
So remove the fs_info argument.

Reviewed-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Reviewed-by: Anand Jain <asj@kernel.org>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Stable-dep-of: 5870ec7c8fe5 ("btrfs: reset block group size class when it becomes empty")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/block-group.c |  4 ++--
 fs/btrfs/block-rsv.c   |  2 +-
 fs/btrfs/space-info.c  | 14 +++++++-------
 fs/btrfs/space-info.h  |  5 ++---
 4 files changed, 12 insertions(+), 13 deletions(-)

diff --git a/fs/btrfs/block-group.c b/fs/btrfs/block-group.c
index 8bf501fbcc0be..035b04e7658d1 100644
--- a/fs/btrfs/block-group.c
+++ b/fs/btrfs/block-group.c
@@ -3836,7 +3836,7 @@ int btrfs_add_reserved_bytes(struct btrfs_block_group *cache,
 	 * that happens.
 	 */
 	if (num_bytes < ram_bytes)
-		btrfs_try_granting_tickets(cache->fs_info, space_info);
+		btrfs_try_granting_tickets(space_info);
 out:
 	spin_unlock(&cache->lock);
 	spin_unlock(&space_info->lock);
@@ -3874,7 +3874,7 @@ void btrfs_free_reserved_bytes(struct btrfs_block_group *cache, u64 num_bytes,
 		cache->delalloc_bytes -= num_bytes;
 	spin_unlock(&cache->lock);
 
-	btrfs_try_granting_tickets(cache->fs_info, space_info);
+	btrfs_try_granting_tickets(space_info);
 	spin_unlock(&space_info->lock);
 }
 
diff --git a/fs/btrfs/block-rsv.c b/fs/btrfs/block-rsv.c
index 5ad6de738aee0..75cd35570a287 100644
--- a/fs/btrfs/block-rsv.c
+++ b/fs/btrfs/block-rsv.c
@@ -387,7 +387,7 @@ void btrfs_update_global_block_rsv(struct btrfs_fs_info *fs_info)
 		num_bytes = block_rsv->reserved - block_rsv->size;
 		btrfs_space_info_update_bytes_may_use(sinfo, -num_bytes);
 		block_rsv->reserved = block_rsv->size;
-		btrfs_try_granting_tickets(fs_info, sinfo);
+		btrfs_try_granting_tickets(sinfo);
 	}
 
 	block_rsv->full = (block_rsv->reserved == block_rsv->size);
diff --git a/fs/btrfs/space-info.c b/fs/btrfs/space-info.c
index e5c18a29eb7e6..474ed47095ba7 100644
--- a/fs/btrfs/space-info.c
+++ b/fs/btrfs/space-info.c
@@ -378,7 +378,7 @@ void btrfs_add_bg_to_space_info(struct btrfs_fs_info *info,
 	btrfs_space_info_update_bytes_zone_unusable(space_info, block_group->zone_unusable);
 	if (block_group->length > 0)
 		space_info->full = false;
-	btrfs_try_granting_tickets(info, space_info);
+	btrfs_try_granting_tickets(space_info);
 	spin_unlock(&space_info->lock);
 
 	block_group->space_info = space_info;
@@ -528,9 +528,9 @@ static void remove_ticket(struct btrfs_space_info *space_info,
  * This is for space we already have accounted in space_info->bytes_may_use, so
  * basically when we're returning space from block_rsv's.
  */
-void btrfs_try_granting_tickets(struct btrfs_fs_info *fs_info,
-				struct btrfs_space_info *space_info)
+void btrfs_try_granting_tickets(struct btrfs_space_info *space_info)
 {
+	struct btrfs_fs_info *fs_info = space_info->fs_info;
 	struct list_head *head;
 	enum btrfs_reserve_flush_enum flush = BTRFS_RESERVE_NO_FLUSH;
 
@@ -1129,7 +1129,7 @@ static bool maybe_fail_all_tickets(struct btrfs_fs_info *fs_info,
 		 * the list.
 		 */
 		if (!aborted)
-			btrfs_try_granting_tickets(fs_info, space_info);
+			btrfs_try_granting_tickets(space_info);
 	}
 	return (tickets_id != space_info->tickets_id);
 }
@@ -1549,7 +1549,7 @@ static void priority_reclaim_metadata_space(struct btrfs_fs_info *fs_info,
 	 * ticket in front of a smaller ticket that can now be satisfied with
 	 * the available space.
 	 */
-	btrfs_try_granting_tickets(fs_info, space_info);
+	btrfs_try_granting_tickets(space_info);
 	spin_unlock(&space_info->lock);
 }
 
@@ -1577,7 +1577,7 @@ static void priority_reclaim_data_space(struct btrfs_fs_info *fs_info,
 
 	ticket->error = -ENOSPC;
 	remove_ticket(space_info, ticket);
-	btrfs_try_granting_tickets(fs_info, space_info);
+	btrfs_try_granting_tickets(space_info);
 	spin_unlock(&space_info->lock);
 }
 
@@ -2200,5 +2200,5 @@ void btrfs_return_free_space(struct btrfs_space_info *space_info, u64 len)
 grant:
 	/* Add to any tickets we may have. */
 	if (len)
-		btrfs_try_granting_tickets(fs_info, space_info);
+		btrfs_try_granting_tickets(space_info);
 }
diff --git a/fs/btrfs/space-info.h b/fs/btrfs/space-info.h
index a846f63585c95..596a1e923ddfe 100644
--- a/fs/btrfs/space-info.h
+++ b/fs/btrfs/space-info.h
@@ -283,8 +283,7 @@ int btrfs_reserve_metadata_bytes(struct btrfs_fs_info *fs_info,
 				 struct btrfs_space_info *space_info,
 				 u64 orig_bytes,
 				 enum btrfs_reserve_flush_enum flush);
-void btrfs_try_granting_tickets(struct btrfs_fs_info *fs_info,
-				struct btrfs_space_info *space_info);
+void btrfs_try_granting_tickets(struct btrfs_space_info *space_info);
 int btrfs_can_overcommit(struct btrfs_fs_info *fs_info,
 			 const struct btrfs_space_info *space_info, u64 bytes,
 			 enum btrfs_reserve_flush_enum flush);
@@ -295,7 +294,7 @@ static inline void btrfs_space_info_free_bytes_may_use(
 {
 	spin_lock(&space_info->lock);
 	btrfs_space_info_update_bytes_may_use(space_info, -num_bytes);
-	btrfs_try_granting_tickets(space_info->fs_info, space_info);
+	btrfs_try_granting_tickets(space_info);
 	spin_unlock(&space_info->lock);
 }
 int btrfs_reserve_data_bytes(struct btrfs_space_info *space_info, u64 bytes,
-- 
2.51.0



