Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55C3643E06C;
	Thu, 17 Sep 2026 19:03:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789671792; cv=none; b=DFAZ8yiMlaWQhRdejQB+nWesDvVNygQmgbshxwOvKf4dPToLAuw+7wYg3uePuH9+gk+U5SfbSiiwBr3+vqDxEYq8EumNSTRdgh+q11PUe0tcXIKtPbQHshRvpq+2V1kd9qApZcyfL9Df2z6ypmqQDks9YfGE3zXQ6WVht1getZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789671792; c=relaxed/simple;
	bh=KPh+eze34D2we9hPR3KE0MBp3vZYuXJawbVJNsJCFw8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AiZ3rojwFp80Uof3PegBmmek7j1CJNB717BQbzFQR9RpPlnzpxfbj6UIcCGwFL6w+Ea9KxSOSAn395SnOayv21CuKSbe6I/Qxl2/32jjKKEJ+oCYK2SdCgk2xU+pIDR9jHOpzwarkB7Ylh3ZBlV9aiUlBQgAYnVykBoT0uafn7c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OrX1lith; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OrX1lith"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFD011F000FF;
	Thu, 17 Sep 2026 19:03:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789671791;
	bh=npIilqSeM0IBMhzzsPZINQTgCNAOAtoVG/Cw//V9M7E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OrX1lithrZ6X/jz0bTqbFCFp4RYuojeDrAJiD1yO24X1CTTbAQCEIaHHSXZgCyRY/
	 LaVuH7hJALJ6U9eu+TMkPGQPVOGpS+BSxfPAgQLB72d7TEfbpxWqgoGaI5J0u//A7q
	 bmjze7SBy8LYcAXxS0Sg3iTXAiIiz2LKVc9QoW6Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1044/1102] btrfs: update include and forward declarations in headers
Date: Thu, 17 Sep 2026 16:16:27 +0100
Message-ID: <20260917151607.002986963@linuxfoundation.org>
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

From: David Sterba <dsterba@suse.com>

[ Upstream commit 6149c82bdaff63203e58a4910d9245468d281f39 ]

Pass over all header files and add missing forward declarations,
includes or fix include types.

Signed-off-by: David Sterba <dsterba@suse.com>
Stable-dep-of: 15f7c86215e8 ("btrfs: do not overwrite NODATASUM flag when removing NODATACOW flag")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/accessors.h        |    1 +
 fs/btrfs/acl.h              |    2 ++
 fs/btrfs/ctree.h            |    2 +-
 fs/btrfs/delayed-ref.h      |    2 ++
 fs/btrfs/dir-item.h         |    1 +
 fs/btrfs/direct-io.h        |    2 ++
 fs/btrfs/discard.h          |    1 +
 fs/btrfs/extent-tree.h      |    1 -
 fs/btrfs/file-item.h        |    2 ++
 fs/btrfs/file.h             |    2 ++
 fs/btrfs/fs.c               |    1 -
 fs/btrfs/ioctl.h            |    2 ++
 fs/btrfs/locking.c          |    1 -
 fs/btrfs/ordered-data.h     |    1 +
 fs/btrfs/print-tree.h       |    2 ++
 fs/btrfs/props.h            |    1 +
 fs/btrfs/qgroup.h           |    3 +++
 fs/btrfs/raid-stripe-tree.h |    1 +
 fs/btrfs/send.c             |    1 -
 fs/btrfs/space-info.c       |    2 +-
 fs/btrfs/subpage.c          |    1 -
 fs/btrfs/sysfs.h            |    1 +
 fs/btrfs/volumes.h          |    4 ++++
 fs/btrfs/xattr.h            |    2 ++
 24 files changed, 32 insertions(+), 7 deletions(-)

--- a/fs/btrfs/accessors.h
+++ b/fs/btrfs/accessors.h
@@ -12,6 +12,7 @@
 #include <linux/string.h>
 #include <linux/mm.h>
 #include <uapi/linux/btrfs_tree.h>
+#include "extent_io.h"
 
 struct extent_buffer;
 
--- a/fs/btrfs/acl.h
+++ b/fs/btrfs/acl.h
@@ -3,6 +3,8 @@
 #ifndef BTRFS_ACL_H
 #define BTRFS_ACL_H
 
+#include <linux/types.h>
+
 struct posix_acl;
 struct inode;
 struct btrfs_trans_handle;
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -6,7 +6,7 @@
 #ifndef BTRFS_CTREE_H
 #define BTRFS_CTREE_H
 
-#include "linux/cleanup.h"
+#include <linux/cleanup.h>
 #include <linux/spinlock.h>
 #include <linux/rbtree.h>
 #include <linux/mutex.h>
--- a/fs/btrfs/delayed-ref.h
+++ b/fs/btrfs/delayed-ref.h
@@ -14,6 +14,8 @@
 #include <linux/spinlock.h>
 #include <linux/slab.h>
 #include <uapi/linux/btrfs_tree.h>
+#include "fs.h"
+#include "messages.h"
 
 struct btrfs_trans_handle;
 struct btrfs_fs_info;
--- a/fs/btrfs/dir-item.h
+++ b/fs/btrfs/dir-item.h
@@ -10,6 +10,7 @@ struct fscrypt_str;
 struct btrfs_fs_info;
 struct btrfs_key;
 struct btrfs_path;
+struct btrfs_inode;
 struct btrfs_root;
 struct btrfs_trans_handle;
 
--- a/fs/btrfs/direct-io.h
+++ b/fs/btrfs/direct-io.h
@@ -5,6 +5,8 @@
 
 #include <linux/types.h>
 
+struct kiocb;
+
 int __init btrfs_init_dio(void);
 void __cold btrfs_destroy_dio(void);
 
--- a/fs/btrfs/discard.h
+++ b/fs/btrfs/discard.h
@@ -3,6 +3,7 @@
 #ifndef BTRFS_DISCARD_H
 #define BTRFS_DISCARD_H
 
+#include <linux/types.h>
 #include <linux/sizes.h>
 
 struct btrfs_fs_info;
--- a/fs/btrfs/extent-tree.h
+++ b/fs/btrfs/extent-tree.h
@@ -4,7 +4,6 @@
 #define BTRFS_EXTENT_TREE_H
 
 #include <linux/types.h>
-#include "misc.h"
 #include "block-group.h"
 #include "locking.h"
 
--- a/fs/btrfs/file-item.h
+++ b/fs/btrfs/file-item.h
@@ -3,8 +3,10 @@
 #ifndef BTRFS_FILE_ITEM_H
 #define BTRFS_FILE_ITEM_H
 
+#include <linux/blk_types.h>
 #include <linux/list.h>
 #include <uapi/linux/btrfs_tree.h>
+#include "ctree.h"
 #include "accessors.h"
 
 struct extent_map;
--- a/fs/btrfs/file.h
+++ b/fs/btrfs/file.h
@@ -9,6 +9,8 @@ struct file;
 struct extent_state;
 struct kiocb;
 struct iov_iter;
+struct inode;
+struct folio;
 struct page;
 struct btrfs_ioctl_encoded_io_args;
 struct btrfs_drop_extents_args;
--- a/fs/btrfs/fs.c
+++ b/fs/btrfs/fs.c
@@ -1,7 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0
 
 #include "messages.h"
-#include "ctree.h"
 #include "fs.h"
 #include "accessors.h"
 
--- a/fs/btrfs/ioctl.h
+++ b/fs/btrfs/ioctl.h
@@ -9,6 +9,8 @@ struct file;
 struct dentry;
 struct mnt_idmap;
 struct fileattr;
+struct inode;
+struct io_uring_cmd;
 struct btrfs_fs_info;
 struct btrfs_ioctl_balance_args;
 
--- a/fs/btrfs/locking.c
+++ b/fs/btrfs/locking.c
@@ -9,7 +9,6 @@
 #include <linux/page-flags.h>
 #include <asm/bug.h>
 #include <trace/events/btrfs.h>
-#include "misc.h"
 #include "ctree.h"
 #include "extent_io.h"
 #include "locking.h"
--- a/fs/btrfs/ordered-data.h
+++ b/fs/btrfs/ordered-data.h
@@ -17,6 +17,7 @@
 struct inode;
 struct page;
 struct extent_state;
+struct btrfs_block_group;
 struct btrfs_inode;
 struct btrfs_root;
 struct btrfs_fs_info;
--- a/fs/btrfs/print-tree.h
+++ b/fs/btrfs/print-tree.h
@@ -6,6 +6,8 @@
 #ifndef BTRFS_PRINT_TREE_H
 #define BTRFS_PRINT_TREE_H
 
+#include <linux/types.h>
+
 /* Buffer size to contain tree name and possibly additional data (offset) */
 #define BTRFS_ROOT_NAME_BUF_LEN				48
 
--- a/fs/btrfs/props.h
+++ b/fs/btrfs/props.h
@@ -6,6 +6,7 @@
 #ifndef BTRFS_PROPS_H
 #define BTRFS_PROPS_H
 
+#include <linux/types.h>
 #include <linux/compiler_types.h>
 
 struct inode;
--- a/fs/btrfs/qgroup.h
+++ b/fs/btrfs/qgroup.h
@@ -22,6 +22,9 @@ struct btrfs_ioctl_quota_ctl_args;
 struct btrfs_trans_handle;
 struct btrfs_delayed_ref_root;
 struct btrfs_inode;
+struct btrfs_transaction;
+struct btrfs_block_group;
+struct btrfs_qgroup_swapped_blocks;
 
 /*
  * Btrfs qgroup overview
--- a/fs/btrfs/raid-stripe-tree.h
+++ b/fs/btrfs/raid-stripe-tree.h
@@ -9,6 +9,7 @@
 #include <linux/types.h>
 #include <uapi/linux/btrfs_tree.h>
 #include "fs.h"
+#include "accessors.h"
 
 #define BTRFS_RST_SUPP_BLOCK_GROUP_MASK    (BTRFS_BLOCK_GROUP_DUP |		\
 					    BTRFS_BLOCK_GROUP_RAID1_MASK |	\
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -17,7 +17,6 @@
 #include <linux/compat.h>
 #include <linux/crc32c.h>
 #include <linux/fsverity.h>
-
 #include "send.h"
 #include "ctree.h"
 #include "backref.h"
--- a/fs/btrfs/space-info.c
+++ b/fs/btrfs/space-info.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0
 
-#include "linux/spinlock.h"
+#include <linux/spinlock.h>
 #include <linux/minmax.h>
 #include "misc.h"
 #include "ctree.h"
--- a/fs/btrfs/subpage.c
+++ b/fs/btrfs/subpage.c
@@ -2,7 +2,6 @@
 
 #include <linux/slab.h>
 #include "messages.h"
-#include "ctree.h"
 #include "subpage.h"
 #include "btrfs_inode.h"
 
--- a/fs/btrfs/sysfs.h
+++ b/fs/btrfs/sysfs.h
@@ -7,6 +7,7 @@
 #include <linux/compiler_types.h>
 #include <linux/kobject.h>
 
+struct block_device;
 struct btrfs_fs_info;
 struct btrfs_device;
 struct btrfs_fs_devices;
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -7,6 +7,7 @@
 #define BTRFS_VOLUMES_H
 
 #include <linux/blk_types.h>
+#include <linux/blkdev.h>
 #include <linux/sizes.h>
 #include <linux/atomic.h>
 #include <linux/sort.h>
@@ -18,14 +19,17 @@
 #include <linux/completion.h>
 #include <linux/rbtree.h>
 #include <uapi/linux/btrfs.h>
+#include <uapi/linux/btrfs_tree.h>
 #include "messages.h"
 #include "rcu-string.h"
+#include "extent-io-tree.h"
 
 struct block_device;
 struct bdev_handle;
 struct btrfs_fs_info;
 struct btrfs_block_group;
 struct btrfs_trans_handle;
+struct btrfs_transaction;
 struct btrfs_zoned_device_info;
 
 #define BTRFS_MAX_DATA_CHUNK_SIZE	(10ULL * SZ_1G)
--- a/fs/btrfs/xattr.h
+++ b/fs/btrfs/xattr.h
@@ -6,6 +6,8 @@
 #ifndef BTRFS_XATTR_H
 #define BTRFS_XATTR_H
 
+#include <linux/types.h>
+
 struct dentry;
 struct inode;
 struct qstr;


