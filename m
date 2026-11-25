Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795621885;
	b=JFofZ9apMLj+6DHoqcakYD0g/wPkW6UlL+Lm4ux4AJO8nkRbYJ98ypnhfcHHOQ6S/uSx
	 K83zDGBdLXZf8Th6L4DJTg+ILFQae8zOmVhP1V3czY+9kfgLp1my+P/EqNyqlUZfPzzsc
	 yjN+kV5fMPobL9DR0euYrHrz5G7wqXI/5oBHvNFFkq7rXUPbFZsie7L5aLrUZOYbbxHqd
	 bH3ZrrooKN33nSTSqzCeiHKbh1sTsPleUtaS0yAC4R8IUAnjACx8dtG2yLNhW6ntNcpVT
	 prcUfgTcHcbBI2bSjH7JnVotQBKM0lpD7QUEbFMX6XNrdGaK7iuLXsQtiFJgjMOSuwg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795621885;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rbciyg4PgozQ53GSsB6+w5lTXsgxz8FXKoJKbUGoOpw=;
	b=wvIPUbWafxO2vmC+lWnV2MJYaZ8uUS7pmNDlq3OCHpPRWuuHRNTFmETtlfXQO2ZuDxMo
	 q3fMjcQmeEryXbvX2FCfrDml8WgR9Yf2Meg+ik+qI7Cbx1Vfh0bFF8Imw7qebKkUOincw
	 T7TUnLMXNKxsRuHGCZYyThkxHFXZ7XSfbAFsgKIcMCAs/pjWWKQeHq4vP1yHAsoe/+e41
	 tFHBwAotGn1TnD9Fzn32giF54nGEOM37CLygD6YOtm2If7oIV+Y8//AczRHzTtnPXxl5c
	 YqDTYUXeU30FpEsZNCWnhF2IsTazP945EbTjSQKHdrfZXr8EHB5uv6DmLwFLbvGH81A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JKEkUk2l;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E95D1606A32D;
	Wed, 25 Nov 2026 15:51:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JKEkUk2l
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E34001F000D1;
	Wed, 25 Nov 2026 15:51:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795621884;
	bh=rbciyg4PgozQ53GSsB6+w5lTXsgxz8FXKoJKbUGoOpw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JKEkUk2luAvqbyhlTOwB4YFTYaxpDG9bHGSB8kpSRU/UmQQMwm8dEXp9CH6Bg8S4o
	 fb9icsZlMJx+7KX65KF2q73kg088qrBNd5mzDinL4CIOqaXWbLajTXLaEZsY0SXt0A
	 0zNuV9WEzpRZrHXw7vSiRFf8Tst2UGIWfuykTT1U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Vacek <neelx@suse.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 365/990] btrfs: zoned: only change active zone counter on successful (de)activation
Date: Wed, 25 Nov 2026 15:28:52 +0100
Message-ID: <20261125143830.642554812@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 69ede4e4d0c20..0ff693fea47c3 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -1126,11 +1126,13 @@ u64 btrfs_find_allocatable_zones(struct btrfs_device *device, u64 hole_start,
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
@@ -1142,23 +1144,29 @@ static bool btrfs_dev_set_active_zone(struct btrfs_device *device, u64 pos)
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
@@ -2384,6 +2392,7 @@ bool btrfs_zone_activate(struct btrfs_block_group *block_group)
 	u64 physical;
 	const bool is_data = (block_group->flags & BTRFS_BLOCK_GROUP_DATA);
 	bool ret;
+	bool new;
 	int i;
 
 	if (!btrfs_is_zoned(block_group->fs_info))
@@ -2434,12 +2443,12 @@ bool btrfs_zone_activate(struct btrfs_block_group *block_group)
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
 
@@ -2486,6 +2495,7 @@ static int call_zone_finish(struct btrfs_block_group *block_group,
 	struct btrfs_device *device = stripe->dev;
 	const u64 physical = stripe->physical;
 	struct btrfs_zoned_device_info *zinfo = device->zone_info;
+	bool cleared;
 	int ret;
 
 	if (!device->bdev)
@@ -2507,9 +2517,9 @@ static int call_zone_finish(struct btrfs_block_group *block_group,
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



