Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795624740;
	b=W6EONMkE3ThjMOp7ONZHpjNX3nWlm0ajAIp4+BPehdu+4B0BMpLZuL/i146/h+Zw7xcq
	 kNLC+a1Ib3PuTEeJfXVxj+HhEQj46Y1ZMsifav3dhN+wQzOYyyTHqPimqmeVjM+mCXrhb
	 oweUI8qwwZYi8e4KzcjNdWbnzX0fEQpbg1mg5oLZvY2P2We5UK6CHB+QSIRVt9DI7sGkM
	 7KgS4GNV9b53irCDhKYvFUayV2gf4W6IKzKxn6btDfUCTIzz+sMVvbpzKYOERlIiJoPDh
	 fWud2M3v7xUCZb+Gwy2dL8P4pV/Dz76JSRHEc50Mves7EaThj8btHmyFZVNaf1MKHZQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795624740;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=OSn/qRqzaHWx27oq+MjyXgVR6Jcdd/BLNoOUgi3onOc=;
	b=B3UqnA+FgfNiY2rxe/g7+d/KvSgP7pQZ1pM10u4ohHeTQju134PpLSD3dS/lf1PUXyMK
	 nUZM7Lg+lYnk55B+2KPqHQGK9W9jBJ/APcru4MUyBOqvhS2aR5FJ42LHx+FNlwdTY8N8X
	 W8Yci3nGQpvhuoLVNbAsvyL6tLtGHXYcNdLMz8ZZ/TDkjmdd5127Rf1Rrp9yjsmsy+ugN
	 eDSPlTuOZBpKN1v+U/2hr4JlmwIFo+3ycK5xqqRGjUIKK751bG+2w8a6yLSmP79gwTs17
	 JDVhCavzqQ35aKlKrTjQ0iutRKY5QP+ZfLdk+XdmjmO+y/Mgl2Nk2jLxow1TbvqfhAQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CE0W5ps9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C38C4606A33B;
	Wed, 25 Nov 2026 16:39:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CE0W5ps9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9D791F000CF;
	Wed, 25 Nov 2026 16:38:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795624740;
	bh=OSn/qRqzaHWx27oq+MjyXgVR6Jcdd/BLNoOUgi3onOc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CE0W5ps9eFUJYSwqEFPH6fKgUpuGJvKd71IfSNicTVlfgRQDctC199cGP3HrzSyw4
	 c/gIyljqbV3rYrs6g8v+1EgUaIy+j9xLlBozt4LD+whCmbWvFfW6gtNQXQvu10NKQS
	 mzv6xdavysN1nWvy5CoZ2EOq1WPU4Ei/e/oQvW8A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Vacek <neelx@suse.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 292/816] btrfs: zoned: only change active zone counter on successful (de)activation
Date: Wed, 25 Nov 2026 15:30:40 +0100
Message-ID: <20261125143855.965154996@linuxfoundation.org>
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

From: Johannes Thumshirn <johannes.thumshirn@wdc.com>

[ Upstream commit 5e79f39fbeea78703ac389c67a810406fa09bc94 ]

btrfs_zone_activate() unconditionally decrements the reserved_active_zones
counter regardless if btrfs_dev_set_active_zone() fails to set the zone
active, i.e. because it raced with another call that already set the bit
in the bitmask, or not.

This can lead to a double decrement of the counter in case the bit has
already been set.

Only decrement the counter *iff* btrfs_dev_set_active_zone() successfully
marked the zone in the bitmap.

Mirror this behaviour when clearing the bit again.

Fixes: a7e1ac7bdc5a ("btrfs: zoned: reserve zones for an active metadata/system block group")
Reviewed-by: Daniel Vacek <neelx@suse.com>
Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/zoned.c | 26 ++++++++++++++++++--------
 1 file changed, 18 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
index b4bb02bd99ae5..e0917a37e4cc6 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -1095,11 +1095,13 @@ u64 btrfs_find_allocatable_zones(struct btrfs_device *device, u64 hole_start,
 	return pos;
 }
 
-static bool btrfs_dev_set_active_zone(struct btrfs_device *device, u64 pos)
+static bool btrfs_dev_set_active_zone(struct btrfs_device *device, u64 pos, bool *new)
 {
 	struct btrfs_zoned_device_info *zone_info = device->zone_info;
 	unsigned int zno = (pos >> zone_info->zone_size_shift);
 
+	*new = false;
+
 	/* We can use any number of zones */
 	if (zone_info->max_active_zones == 0)
 		return true;
@@ -1111,23 +1113,29 @@ static bool btrfs_dev_set_active_zone(struct btrfs_device *device, u64 pos)
 		if (test_and_set_bit(zno, zone_info->active_zones)) {
 			/* Someone already set the bit */
 			atomic_inc(&zone_info->active_zones_left);
+		} else {
+			*new = true;
 		}
 	}
 
 	return true;
 }
 
-static void btrfs_dev_clear_active_zone(struct btrfs_device *device, u64 pos)
+static bool btrfs_dev_clear_active_zone(struct btrfs_device *device, u64 pos)
 {
 	struct btrfs_zoned_device_info *zone_info = device->zone_info;
 	unsigned int zno = (pos >> zone_info->zone_size_shift);
 
 	/* We can use any number of zones */
 	if (zone_info->max_active_zones == 0)
-		return;
+		return false;
 
-	if (test_and_clear_bit(zno, zone_info->active_zones))
+	if (test_and_clear_bit(zno, zone_info->active_zones)) {
 		atomic_inc(&zone_info->active_zones_left);
+		return true;
+	}
+
+	return false;
 }
 
 int btrfs_reset_device_zone(struct btrfs_device *device, u64 physical,
@@ -2340,6 +2348,7 @@ bool btrfs_zone_activate(struct btrfs_block_group *block_group)
 	u64 physical;
 	const bool is_data = (block_group->flags & BTRFS_BLOCK_GROUP_DATA);
 	bool ret;
+	bool new;
 	int i;
 
 	if (!btrfs_is_zoned(block_group->fs_info))
@@ -2390,12 +2399,12 @@ bool btrfs_zone_activate(struct btrfs_block_group *block_group)
 			goto out_unlock;
 		}
 
-		if (!btrfs_dev_set_active_zone(device, physical)) {
+		if (!btrfs_dev_set_active_zone(device, physical, &new)) {
 			/* Cannot activate the zone */
 			ret = false;
 			goto out_unlock;
 		}
-		if (!is_data)
+		if (!is_data && new)
 			zinfo->reserved_active_zones--;
 	}
 
@@ -2454,6 +2463,7 @@ static int call_zone_finish(struct btrfs_block_group *block_group,
 	struct btrfs_device *device = stripe->dev;
 	const u64 physical = stripe->physical;
 	struct btrfs_zoned_device_info *zinfo = device->zone_info;
+	bool cleared;
 	int ret;
 
 	if (!device->bdev)
@@ -2475,9 +2485,9 @@ static int call_zone_finish(struct btrfs_block_group *block_group,
 			return ret;
 	}
 
-	if (!(block_group->flags & BTRFS_BLOCK_GROUP_DATA))
+	cleared = btrfs_dev_clear_active_zone(device, physical);
+	if (!(block_group->flags & BTRFS_BLOCK_GROUP_DATA) && cleared)
 		zinfo->reserved_active_zones++;
-	btrfs_dev_clear_active_zone(device, physical);
 
 	return 0;
 }
-- 
2.53.0



