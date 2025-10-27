Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61580325493;
	Mon, 27 Oct 2025 18:57:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761591431; cv=none; b=XVKaqf9FaBZvbQ4BIJTOL8oT91hWARMHP3qugxaa0MS8rFk/9j77RnfKbmnnkyLqffmsui8vMnkXGhRosZ+G3cSQnJ6FUNo2Ph4b4U/ZLY24dYrD5DV/WXZE/uz6YuR/4QEu/OXdObx14vC8TFPYtriOJI/6FHTZkNVavKTE6jA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761591431; c=relaxed/simple;
	bh=cGRvibBMuBCOSCjPrC6I++jhvhwFiKfZ6U70QuD29M8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZLIAOaK9aL4gs5CFhKe+T2l0wzHkGp0eN63gz2hg8fG1kjdSIYowESqwc4oNVtkyqvNQ5CvTq02ruSu3hIvsmS8Acc9ZkuVZxbtwya0mjqE3Mcip7lNs6CZ/K8A6xiB6jBhTkFN91aJtNz7xufowlpdTrw17hCqP3gpODnrgM8Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rgf0Bl8u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rgf0Bl8u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA9E2C4CEF1;
	Mon, 27 Oct 2025 18:57:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761591431;
	bh=cGRvibBMuBCOSCjPrC6I++jhvhwFiKfZ6U70QuD29M8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rgf0Bl8uY2oA1+QKBh9xU/VUwKKP0KxuVdL7aWOI3gXoiMFcrM7qzLCYlI7awUVM2
	 yGJwci+s20witFg1bH9W+3W2FvcyApK+/Di+KW49vMz9v+FBL4R/DUejKm9InvDJDx
	 3jPXehVwCqGtOpMjuwVgoIoYW9Ud1aN5Ox/r0LeM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	David Sterba <dsterba@suse.com>,
	Eliav Farber <farbere@amazon.com>
Subject: [PATCH 5.10 195/332] btrfs: remove duplicated in_range() macro
Date: Mon, 27 Oct 2025 19:34:08 +0100
Message-ID: <20251027183529.850039237@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183524.611456697@linuxfoundation.org>
References: <20251027183524.611456697@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Thumshirn <johannes.thumshirn@wdc.com>

[ Upstream commit cea628008fc8c6c9c7b53902f6659e040f33c790 ]

The in_range() macro is defined twice in btrfs' source, once in ctree.h
and once in misc.h.

Remove the definition in ctree.h and include misc.h in the files depending
on it.

Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Eliav Farber <farbere@amazon.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/ctree.h     |    2 --
 fs/btrfs/extent_io.c |    1 +
 fs/btrfs/file-item.c |    1 +
 fs/btrfs/raid56.c    |    1 +
 4 files changed, 3 insertions(+), 2 deletions(-)

--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -3597,8 +3597,6 @@ static inline int btrfs_defrag_cancelled
 	return signal_pending(current);
 }
 
-#define in_range(b, first, len) ((b) >= (first) && (b) < (first) + (len))
-
 /* Sanity test specific functions */
 #ifdef CONFIG_BTRFS_FS_RUN_SANITY_TESTS
 void btrfs_test_destroy_inode(struct inode *inode);
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -13,6 +13,7 @@
 #include <linux/pagevec.h>
 #include <linux/prefetch.h>
 #include <linux/cleancache.h>
+#include "misc.h"
 #include "extent_io.h"
 #include "extent-io-tree.h"
 #include "extent_map.h"
--- a/fs/btrfs/file-item.c
+++ b/fs/btrfs/file-item.c
@@ -9,6 +9,7 @@
 #include <linux/highmem.h>
 #include <linux/sched/mm.h>
 #include <crypto/hash.h>
+#include "misc.h"
 #include "ctree.h"
 #include "disk-io.h"
 #include "transaction.h"
--- a/fs/btrfs/raid56.c
+++ b/fs/btrfs/raid56.c
@@ -13,6 +13,7 @@
 #include <linux/list_sort.h>
 #include <linux/raid/xor.h>
 #include <linux/mm.h>
+#include "misc.h"
 #include "ctree.h"
 #include "disk-io.h"
 #include "volumes.h"


