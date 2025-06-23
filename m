Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7D2B4315A;
	Mon, 23 Jun 2025 21:41:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750714894; cv=none; b=HWxWIGle3ITQI+eX7Rq44R6QaoFBVvFhZd+Gu/X225cSpD/+k2X/+lx/6z0Ot6oUX4wWTAbO0mZytvbGCif8BrH4vMRzUnRqr8l0eStG1KCvhFWOMMGR26PHwL0JxBP7q/F+CIm5lmN2fbVs8dUBGk75e38BtlT94hKqnK9o0oY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750714894; c=relaxed/simple;
	bh=hlU/T9GUKmnlIh3vc54XNHs36T/afl2zHPCPgggcwqw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z2e9+lwKY49zb6lshcXeN/GJ4RrdpTjM0WZYwGfPDcIjORawkY/MYUVYRxz6NqcVFoFgVGiIiihr7VnTossYoVIVPmmCvy+WfVqvZ035QrBLkM+SIXGlRUjjfZlpPUZtLQ62o5Hy6Bg3BHlqE8uOKYcILDX21m/blwD/iCIcwd8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VBt0SBvJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VBt0SBvJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FF6CC4CEEA;
	Mon, 23 Jun 2025 21:41:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750714894;
	bh=hlU/T9GUKmnlIh3vc54XNHs36T/afl2zHPCPgggcwqw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VBt0SBvJeG/JjkDYEKs5tis1YOCZnz/ulMO9dEEqEx7aL5Fx7iRV6fYcYwObNKmeg
	 bZ+SdE/t7l7eKT3swcMIfQSheYcKOB/ixk6O25oDyv7jAjNKF9aRLv/94KG7v3fAth
	 IRLmPwr5wUza9LdyFMgDdN9s0SBkpDZu9Ni5UdO0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Leah Rumancik <leah.rumancik@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 202/508] xfs: declare xfs_file.c symbols in xfs_file.h
Date: Mon, 23 Jun 2025 15:04:07 +0200
Message-ID: <20250623130650.239519930@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130645.255320792@linuxfoundation.org>
References: <20250623130645.255320792@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Darrick J. Wong <djwong@kernel.org>

[ Upstream commit 00acb28d96746f78389f23a7b5309a917b45c12f ]

Move the two public symbols in xfs_file.c to xfs_file.h.  We're about to
add more public symbols in that source file, so let's finally create the
header file.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
Acked-by: "Darrick J. Wong" <djwong@kernel.org>
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
index 821cb86a83bd5..6f7522977f7f7 100644
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
index 0000000000000..7d39e3eca56dc
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
index c7cb496dc3458..1afb1b1b831ea 100644
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
index 6fbdc0a19e54c..9ca1b8bf1f053 100644
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
index e570dcb5df8d5..73ff92355eaa7 100644
--- a/fs/xfs/xfs_iops.h
+++ b/fs/xfs/xfs_iops.h
@@ -8,9 +8,6 @@
 
 struct xfs_inode;
 
-extern const struct file_operations xfs_file_operations;
-extern const struct file_operations xfs_dir_file_operations;
-
 extern ssize_t xfs_vn_listxattr(struct dentry *, char *data, size_t size);
 
 int xfs_vn_setattr_size(struct user_namespace *mnt_userns,
-- 
2.39.5



