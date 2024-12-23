Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C84B813BC0C;
	Mon, 23 Dec 2024 16:10:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734970231; cv=none; b=nSJtYEPJRqJCXj2fW55Ci8JDuHSWNDt2DWww59F3y8wekbpKvhOYXvqdqTdRABKuJTguhDUkMzJuH9pEhX/QJd8EUV1EOqIys1VpGWjM39F026cNOpsJAMeSXkDGBFViQ5lZB+h8DeRcZwfuzsHpcpUp6DafGj4NRpwZH+CqOW8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734970231; c=relaxed/simple;
	bh=k4OQzXeYOi61151aLC3fjg+TDFOY9ReH/XcCveMmgE8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AT94C7F3QSB1ha45DZ0Pixsrb2BvEUwdc/kozVicoUusD5OHodg3Mh9LuAGDpplVmfAiIUKwxrhqi7bm+4frudkR1kO2uXTXicmbsQa8ZpJiWeKukEPG4/0+nWB99/og8FMts0rQhJzeyR8YtmVkG2xQO8UPiWDqh6lS0tZtQdI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zPn1CIG7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zPn1CIG7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30D75C4CED4;
	Mon, 23 Dec 2024 16:10:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734970231;
	bh=k4OQzXeYOi61151aLC3fjg+TDFOY9ReH/XcCveMmgE8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zPn1CIG71EYZ5sVJz1oW3EYbql1CWZl4EPHiwyQh/zUmBIZ7bQulnqinyUejmoZVv
	 wrdlld2El+QWHm29rl24ChkP0ywAULDi5l4Sec/hIdoFldNvPYd6Uc01t7Web8rWKP
	 Yg9Tckm6Zxz+NF1YJeBIyPF36gNmQRnamcTKbQ9o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Catherine Hoang <catherine.hoang@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 022/116] xfs: declare xfs_file.c symbols in xfs_file.h
Date: Mon, 23 Dec 2024 16:58:12 +0100
Message-ID: <20241223155400.424893516@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241223155359.534468176@linuxfoundation.org>
References: <20241223155359.534468176@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Darrick J. Wong <djwong@kernel.org>

commit 00acb28d96746f78389f23a7b5309a917b45c12f upstream.

[backport: dependency of d3b689d and f23660f]

Move the two public symbols in xfs_file.c to xfs_file.h.  We're about to
add more public symbols in that source file, so let's finally create the
header file.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/xfs_file.c  |  1 +
 fs/xfs/xfs_file.h  | 12 ++++++++++++
 fs/xfs/xfs_ioctl.c |  1 +
 fs/xfs/xfs_iops.c  |  1 +
 fs/xfs/xfs_iops.h  |  3 ---
 5 files changed, 15 insertions(+), 3 deletions(-)
 create mode 100644 fs/xfs/xfs_file.h

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 16769c22c070..8dcbcf965b2c 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -24,6 +24,7 @@
 #include "xfs_pnfs.h"
 #include "xfs_iomap.h"
 #include "xfs_reflink.h"
+#include "xfs_file.h"
 
 #include <linux/dax.h>
 #include <linux/falloc.h>
diff --git a/fs/xfs/xfs_file.h b/fs/xfs/xfs_file.h
new file mode 100644
index 000000000000..7d39e3eca56d
--- /dev/null
+++ b/fs/xfs/xfs_file.h
@@ -0,0 +1,12 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2000-2005 Silicon Graphics, Inc.
+ * All Rights Reserved.
+ */
+#ifndef __XFS_FILE_H__
+#define __XFS_FILE_H__
+
+extern const struct file_operations xfs_file_operations;
+extern const struct file_operations xfs_dir_file_operations;
+
+#endif /* __XFS_FILE_H__ */
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 535f6d38cdb5..df4bf0d56aad 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -38,6 +38,7 @@
 #include "xfs_reflink.h"
 #include "xfs_ioctl.h"
 #include "xfs_xattr.h"
+#include "xfs_file.h"
 
 #include <linux/mount.h>
 #include <linux/namei.h>
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index b8ec045708c3..f9466311dfea 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -25,6 +25,7 @@
 #include "xfs_error.h"
 #include "xfs_ioctl.h"
 #include "xfs_xattr.h"
+#include "xfs_file.h"
 
 #include <linux/posix_acl.h>
 #include <linux/security.h>
diff --git a/fs/xfs/xfs_iops.h b/fs/xfs/xfs_iops.h
index 7f84a0843b24..52d6d510a21d 100644
--- a/fs/xfs/xfs_iops.h
+++ b/fs/xfs/xfs_iops.h
@@ -8,9 +8,6 @@
 
 struct xfs_inode;
 
-extern const struct file_operations xfs_file_operations;
-extern const struct file_operations xfs_dir_file_operations;
-
 extern ssize_t xfs_vn_listxattr(struct dentry *, char *data, size_t size);
 
 int xfs_vn_setattr_size(struct mnt_idmap *idmap,
-- 
2.39.5



