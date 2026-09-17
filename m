Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A392C43F8D6;
	Thu, 17 Sep 2026 19:00:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789671672; cv=none; b=i5U/dQcndJgj0PJl3Z7IT/LgGYQFwXSzTnWZeIX9yZkx8yLHYfsFAz40FZCKNSOZ/DH5JAx/y2PcLN4FaqTeOhffZw+5HGKoelA9JbUUL3KxAOq3Iik8DMiBu9L8jpTkwguCExFPsBWp34Qxbv7pjA7FUTV2H6ERJd22lE6Xj04=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789671672; c=relaxed/simple;
	bh=i+ZrHX35SjYSbJBc20shrH3+Wz39fXALhF33UcWjcvo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Lm596UhPPUvWxtynXRYPIomZoj+mLXqw421uMMY+cgV6QUwkcOD9SZkjhjXxK5Sj9T0QMt/1dchxNqN+uhrQdEtzUNUVGrjtN6g5iMB++JJltsDmrx7uKc7Zu22bwZbuUNIYzI28IDEoysVt7H5Vq0Acla/Wrypa+3ei2St5cNs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZhxMkKXj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZhxMkKXj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5BB11F00893;
	Thu, 17 Sep 2026 19:00:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789671639;
	bh=P9xcsvUuS2UwgiIFeElHQOjU3XJt+fsTRxFFjYR/O5M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZhxMkKXjelkBOoRZne49UO107WxRxjopF4rIkBBw3YZNYOsjxvnxA/hZY2SX2Ef79
	 BT1jiycuBj9pbBATq86ZEetKsb0veeNapWjK+ox/C2CN33c3hmF+JR/lNPD9P5/mH3
	 jySnya4Jwzzd8JK1uvdKgdSb4jAHJW+smxnLJfkk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1041/1102] btrfs: move BTRFS_BYTES_TO_BLKS() into fs.h
Date: Thu, 17 Sep 2026 16:16:24 +0100
Message-ID: <20260917151606.924987168@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

From: Filipe Manana <fdmanana@suse.com>

[ Upstream commit a4545b74e2de98989c1d14bc48c52c2f9fa734b6 ]

Currently BTRFS_BYTES_TO_BLKS() is defined in ctree.h but it's not related
at all to the btree data structure, so move it into fs.h.

Reviewed-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Stable-dep-of: 15f7c86215e8 ("btrfs: do not overwrite NODATASUM flag when removing NODATACOW flag")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/ctree.h |    3 ---
 fs/btrfs/fs.h    |    2 ++
 2 files changed, 2 insertions(+), 3 deletions(-)

--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -506,9 +506,6 @@ static inline u32 BTRFS_MAX_XATTR_SIZE(c
 	return BTRFS_MAX_ITEM_SIZE(info) - sizeof(struct btrfs_dir_item);
 }
 
-#define BTRFS_BYTES_TO_BLKS(fs_info, bytes) \
-				((bytes) >> (fs_info)->sectorsize_bits)
-
 static inline gfp_t btrfs_alloc_write_mask(struct address_space *mapping)
 {
 	return mapping_gfp_constraint(mapping, ~__GFP_FS);
--- a/fs/btrfs/fs.h
+++ b/fs/btrfs/fs.h
@@ -959,6 +959,8 @@ static inline u64 btrfs_calc_metadata_si
 #define BTRFS_MAX_EXTENT_ITEM_SIZE(r) ((BTRFS_LEAF_DATA_SIZE(r->fs_info) >> 4) - \
 					sizeof(struct btrfs_item))
 
+#define BTRFS_BYTES_TO_BLKS(fs_info, bytes) ((bytes) >> (fs_info)->sectorsize_bits)
+
 static inline bool btrfs_is_zoned(const struct btrfs_fs_info *fs_info)
 {
 	return IS_ENABLED(CONFIG_BLK_DEV_ZONED) && fs_info->zone_size > 0;


