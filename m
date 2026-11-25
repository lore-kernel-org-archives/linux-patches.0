Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795618878;
	b=nKobqBiRAG7G2ylHe9hLB6Z9pzmRXHIYcnPYCahnWCkE1m1EDmFNol/fagldaeyYzquN
	 0f2+coY9WwVtSgf8JUMBi4XS32Sl0yJz0Iyq9TCklRGB5nPg+RAg3KDxWfj2htq3nAFQ0
	 3kVMOzPC+8C9tnpRRHYMpjsdgLh2wcRuKKY0bQi0e/jRLwby7hh0K2ZzPmsl91j+NJfaR
	 83XqB6I5egBd5jWkmsrYFn0TyX8Lfv+f1C7UNxmRJnZiyosk8ibsAshP8jx0pyaNjFd7u
	 dMFGMas1teDDVJwhbGBRbAh6I3aRqNirxjX5uYBa18Hgh1gDNevuOnCX7KG21tJHSEw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795618878;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Y6BG3mhxuWiFbRkHxGjNC4qQQhN4gtL455qgN1F/XqM=;
	b=xN8OGufUGxq19bndfdIA9KkFxkYp9xvAFhGVNwk6+aYwyZtFsslvL8QuZrF5RxK8edJE
	 2r4P5k4S8aJI6MSQU2DCM6UFTIk+qHZMwS/NY6lmcYfvaxThS2keijwHJATlZpqWxkOrz
	 cKnLdZ7zqTOCtwzoFABz8bLEvwnlzPNs9QlecVBh/e7JV0NkNYamb6CTRcG9lMjfThTAT
	 ksO+dtoDfRERz0Fohj26t8FcRYW6Pnk8ggdBMm+KGsKJUJ/8jpV+Vit+E/b4CP0/k2JwW
	 TKZkbDt755w9u+JJNBQOywcBs7v7YCMEfPwYwM1D4gt7mivlCEUdk6UmPLN7o0U6xLA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GpU6dCl3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04DCC606A327;
	Wed, 25 Nov 2026 15:01:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GpU6dCl3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D63581F000CA;
	Wed, 25 Nov 2026 15:01:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795618877;
	bh=Y6BG3mhxuWiFbRkHxGjNC4qQQhN4gtL455qgN1F/XqM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GpU6dCl3vm4FLTVEOON5wdZtZzxk2vMXuIw8Xgq8KZ0xUClamlkHf995257F4m+4E
	 BHV+P6StYhPzSVkzliMZCoxLon2heIKKwYEidA8VRYTFLIPpeRKat8tbHDgdbnfkyF
	 WX7mSKqED3QzdQ3WVBQEN2n6u04wkjPynARv3l60=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Vacek <neelx@suse.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0418/1005] btrfs: zoned: only change active zone counter on successful (de)activation
Date: Wed, 25 Nov 2026 15:29:16 +0100
Message-ID: <20261125143831.545450362@linuxfoundation.org>
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
index a64af9d5d2376..232892b8542cf 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -1131,11 +1131,13 @@ u64 btrfs_find_allocatable_zones(struct btrfs_device *device, u64 hole_start,
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
@@ -1147,23 +1149,29 @@ static bool btrfs_dev_set_active_zone(struct btrfs_device *device, u64 pos)
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
@@ -2416,6 +2424,7 @@ bool btrfs_zone_activate(struct btrfs_block_group *block_group)
 	u64 physical;
 	const bool is_data = (block_group->flags & BTRFS_BLOCK_GROUP_DATA);
 	bool ret;
+	bool new;
 	int i;
 
 	if (!btrfs_is_zoned(block_group->fs_info))
@@ -2469,12 +2478,12 @@ bool btrfs_zone_activate(struct btrfs_block_group *block_group)
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
 
@@ -2521,6 +2530,7 @@ static int call_zone_finish(struct btrfs_block_group *block_group,
 	struct btrfs_device *device = stripe->dev;
 	const u64 physical = stripe->physical;
 	struct btrfs_zoned_device_info *zinfo = device->zone_info;
+	bool cleared;
 	int ret;
 
 	if (!device->bdev)
@@ -2542,9 +2552,9 @@ static int call_zone_finish(struct btrfs_block_group *block_group,
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



