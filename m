Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFB4323B62C;
	Mon, 23 Mar 2026 14:52:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774277539; cv=none; b=ERbbfMxV6dvrU4fLvxxnMq7PfyEiYp/KdmTSzAvbmy2qKzB7p3LaP8ULYvrWi+to1aXLHmbCB/VH7pYBV2jtYXEKGbXfMYfP4XStgJN446Kjhx7rW9Gila7+BAwyZSiRfXXc9i5u25I8WFWpZ/4jHndFuFYuhEwjxl3Q2B640EA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774277539; c=relaxed/simple;
	bh=OPkzWhV50w1j6dvubLraBzqiy5peUF/SZNnIw9BBOhM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cLhBEqzwmXS73kfIeqMXrHhEp7+6j15dNq2c0pXW7pVefDqv8WCSxX7iTrqtIt2iAOXdUx1k5HGla0AORcxhJ2xdDKA6mRsQqbq/5qRnUSo2Dgi4VWkIGBbEsv3j8ihxqdDATz9ONR+NqLl9K8Y00yvl3ycLRV1femIDlDJAoPw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Cp6uQ/ey; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Cp6uQ/ey"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6568AC2BCB3;
	Mon, 23 Mar 2026 14:52:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774277538;
	bh=OPkzWhV50w1j6dvubLraBzqiy5peUF/SZNnIw9BBOhM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Cp6uQ/eyq2l2dRhcvU9NNKnc5ktc88oKs79Uc4Rff5TNgA4mijDWwmom+6cF/OK0h
	 GpXg628QIijeHbWj+d9A5my5W+l3p0eD7rDQzsIXiTycb5OVkARTt1rra34vsGcEgS
	 AIP4l6awa1mTolNo9uYKX7U3SpSHEpXnc/13gikg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Anand Jain <anand.jain@oracle.com>,
	Josef Bacik <josef@toxicpanda.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 017/567] btrfs: move btrfs_extref_hash into inode-item.h
Date: Mon, 23 Mar 2026 14:38:57 +0100
Message-ID: <20260323134534.192225007@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134533.749096647@linuxfoundation.org>
References: <20260323134533.749096647@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josef Bacik <josef@toxicpanda.com>

[ Upstream commit 98e4f060c4f565a3b62e8cdfe6b89f59167312b6 ]

Ideally this would be un-inlined, but that is a cleanup for later.  For
now move this into inode-item.h, which is where the extref code lives.

Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Reviewed-by: Anand Jain <anand.jain@oracle.com>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Stable-dep-of: 511dc8912ae3 ("btrfs: fix incorrect key offset in error message in check_dev_extent_item()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/ctree.h      | 9 ---------
 fs/btrfs/inode-item.h | 7 +++++++
 2 files changed, 7 insertions(+), 9 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 11691c70ba791..1743aa21fa6e5 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -477,15 +477,6 @@ static inline u64 btrfs_name_hash(const char *name, int len)
        return crc32c((u32)~1, name, len);
 }
 
-/*
- * Figure the key offset of an extended inode ref
- */
-static inline u64 btrfs_extref_hash(u64 parent_objectid, const char *name,
-                                   int len)
-{
-       return (u64) crc32c(parent_objectid, name, len);
-}
-
 static inline gfp_t btrfs_alloc_write_mask(struct address_space *mapping)
 {
 	return mapping_gfp_constraint(mapping, ~__GFP_FS);
diff --git a/fs/btrfs/inode-item.h b/fs/btrfs/inode-item.h
index d43633d5620f2..0f1730dabce6d 100644
--- a/fs/btrfs/inode-item.h
+++ b/fs/btrfs/inode-item.h
@@ -4,6 +4,7 @@
 #define BTRFS_INODE_ITEM_H
 
 #include <linux/types.h>
+#include <linux/crc32c.h>
 
 struct btrfs_trans_handle;
 struct btrfs_root;
@@ -76,6 +77,12 @@ static inline void btrfs_inode_split_flags(u64 inode_item_flags,
 	*ro_flags = (u32)(inode_item_flags >> 32);
 }
 
+/* Figure the key offset of an extended inode ref. */
+static inline u64 btrfs_extref_hash(u64 parent_objectid, const char *name, int len)
+{
+       return (u64)crc32c(parent_objectid, name, len);
+}
+
 int btrfs_truncate_inode_items(struct btrfs_trans_handle *trans,
 			       struct btrfs_root *root,
 			       struct btrfs_truncate_control *control);
-- 
2.51.0



