Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795618883;
	b=yi7A+kNy3kgcZRAB9dBcojXBqI2SwgVKqcP1V3GyKtH9TcnORT8jBZh0XIfvnZ3V+kMG
	 7k2T4M1nuEZ32F9wxW9eHbTROgACieh54UGn1mGA9NRJCAU/qeM3UNcFELUZjuCPoqsnx
	 KtadYDUURJWosRe/2hFhAtwhXdY9vRkHDl1CNE4efF0kjitTD9PQqCGpBFpGGw0oJm1B6
	 hdTJnUIP71z2bJjpai4C0da67OEuCnTwNhl4AgtxQCvoyIotLxbDLOxJco0lcXTa+dIiX
	 +EJTZCk0sq/UzDADRy2sOMMgFXL5341v4XehiP3VPUBfT84JZust4dX+ZKUTS/bZTpw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795618883;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=vO6YCwiLoyYQIiF0CFCUgHmOpdGF0wOB3p+JxMD7hMQ=;
	b=gdLZoevmKGJhM6Yu5P33Mgbm8nEyAhevSwMz/ijmVMF+FVJVA+Y29sJSDYL0KIpGPKje
	 Hk+7fo14aJXB2tPTFOW+71uPF+D/X6crL+Zh+t0AF9+uiWgekahO6WlNjAsM76gGFq2yk
	 cY6m7DeAwFyV9I+CyHO6tJtbmTdAo9N0LNvnmUByio2w09a/qiJIaQPgQ90g1q6X13rWq
	 yd3U4N+wqtEDM7b3KXbxJmA9LCq88Jlv0t+kAjOzx6acfg7P/fCKpOoHhOTlgil16PrfO
	 uU/AeksbL47vff9Ynh0oZ2lk3Fj/XnVCG0mno57vJz2k8rcvo33UgQk7Gx8pBX8Jisw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=P9QcivY7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0F42606A32A;
	Wed, 25 Nov 2026 15:01:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=P9QcivY7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE3821F000C4;
	Wed, 25 Nov 2026 15:01:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795618883;
	bh=vO6YCwiLoyYQIiF0CFCUgHmOpdGF0wOB3p+JxMD7hMQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=P9QcivY7ZXdWUQWmK9kdXnSazqockHG6Ld0/eBd0hiclayvF2cp1S1H7u5eRcELr3
	 qJz1W2Z2x4sTJTvq+MTXXQoCAM6p1wIYXP0t40ll0sX8dQZn806pg7npSrJwudOtqT
	 b++p+rzxciMeOz4Ad6okMCXbiO+dlhYxNQO4ZagY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Vacek <neelx@suse.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0420/1005] btrfs: zoned: requeue block group if zone reset bails out
Date: Wed, 25 Nov 2026 15:29:18 +0100
Message-ID: <20261125143831.592743370@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Thumshirn <johannes.thumshirn@wdc.com>

[ Upstream commit c5f878eefdd4f559422a68bf49b6f59e7c10e70e ]

btrfs_reset_unused_block_groups() drops the block-group from
fs_info->unused_bgs before performing the work that can actually fail,
the actual submission of a REQ_OP_ZONE_RESET.

Every failed operation after this leaves the block-group dangling,
physically reset, but the in-memory structures aren't and it is not
requeued to be reset on fs_info->unused_bgs.

Instead of bailing out, re-add this block-group to fs_info->unused_bgs
list.

Fixes: 453a73c3069a ("btrfs: zoned: reclaim unused zone by zone resetting")
Reviewed-by: Daniel Vacek <neelx@suse.com>
Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/zoned.c | 28 ++++++++++++++++++++++------
 1 file changed, 22 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
index a63ae60d7ba0d..fbde21946a36d 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -3141,6 +3141,8 @@ int btrfs_reset_unused_block_groups(struct btrfs_space_info *space_info, u64 num
 {
 	struct btrfs_fs_info *fs_info = space_info->fs_info;
 	const sector_t zone_size_sectors = fs_info->zone_size >> SECTOR_SHIFT;
+	LIST_HEAD(retry_list);
+	int ret = 0;
 
 	if (!btrfs_is_zoned(fs_info))
 		return 0;
@@ -3182,11 +3184,10 @@ int btrfs_reset_unused_block_groups(struct btrfs_space_info *space_info, u64 num
 		}
 		if (!found) {
 			spin_unlock(&fs_info->unused_bgs_lock);
-			return 0;
+			goto out;
 		}
 
 		list_del_init(&bg->bg_list);
-		btrfs_put_block_group(bg);
 		spin_unlock(&fs_info->unused_bgs_lock);
 
 		/*
@@ -3200,7 +3201,6 @@ int btrfs_reset_unused_block_groups(struct btrfs_space_info *space_info, u64 num
 		for (int i = 0; i < map->num_stripes; i++) {
 			struct btrfs_io_stripe *stripe = &map->stripes[i];
 			unsigned int nofs_flags;
-			int ret;
 
 			nofs_flags = memalloc_nofs_save();
 			ret = blkdev_zone_mgmt(stripe->dev->bdev, REQ_OP_ZONE_RESET,
@@ -3210,7 +3210,7 @@ int btrfs_reset_unused_block_groups(struct btrfs_space_info *space_info, u64 num
 
 			if (ret) {
 				up_read(&fs_info->dev_replace.rwsem);
-				return ret;
+				goto requeue;
 			}
 		}
 		up_read(&fs_info->dev_replace.rwsem);
@@ -3221,7 +3221,7 @@ int btrfs_reset_unused_block_groups(struct btrfs_space_info *space_info, u64 num
 		if (bg->ro) {
 			spin_unlock(&bg->lock);
 			spin_unlock(&space_info->lock);
-			continue;
+			goto requeue;
 		}
 
 		reclaimed = bg->alloc_offset;
@@ -3250,12 +3250,28 @@ int btrfs_reset_unused_block_groups(struct btrfs_space_info *space_info, u64 num
 		btrfs_return_free_space(space_info, reclaimed);
 		spin_unlock(&space_info->lock);
 
+		btrfs_put_block_group(bg);
+
 		if (num_bytes <= reclaimed)
 			break;
 		num_bytes -= reclaimed;
+		continue;
+
+requeue:
+		list_add_tail(&bg->bg_list, &retry_list);
+
+		if (ret)
+			goto out;
 	}
 
-	return 0;
+out:
+	if (!list_empty(&retry_list)) {
+		spin_lock(&fs_info->unused_bgs_lock);
+		list_splice_tail(&retry_list, &fs_info->unused_bgs);
+		spin_unlock(&fs_info->unused_bgs_lock);
+	}
+
+	return ret;
 }
 
 void btrfs_show_zoned_stats(struct btrfs_fs_info *fs_info, struct seq_file *seq)
-- 
2.53.0



