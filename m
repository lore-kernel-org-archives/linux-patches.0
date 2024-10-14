Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3FF619E98B;
	Mon, 14 Oct 2024 15:26:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728919605; cv=none; b=o/qP0zwLxp3wEoa4l7c/DJY9vUvhUYBtRcYW07s/eRaUWZj7rhNkvk20SXuikhvu4eImOY0q4SRLvUURDQugVrvYACWcUoGeqcgLJR+biZuTx/2ENCObYVo67xRyM6CxdjEfV6ghZ3dPNoZy9Al0v1Wtqu2bvIpi5TaOdnosz9g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728919605; c=relaxed/simple;
	bh=6yjZbBK3T2HbJsV73tsSnmUNlCWw5+vv4P+RFm0kf/g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y+uWJvn7n40pxEk+Cadx0rM/uMTC8s045fpIvR7zUGfr+R/CVx24wiBLUQifVIZwWQsRu87a6xWBRXYNhoG0rLoxoa5ZWzqQdYPLVWiIyw/PfpDSEo2k1MY9O6LSpcUDpDRqAVx7VxbKeR3U3riUiHt1zDasX42/gKqufmIyNzE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1cNjZ6C/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1cNjZ6C/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2466BC4CEC3;
	Mon, 14 Oct 2024 15:26:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728919604;
	bh=6yjZbBK3T2HbJsV73tsSnmUNlCWw5+vv4P+RFm0kf/g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1cNjZ6C/ocSszgOFIgFqbz2rRq08F+pnk+NdlkYEtHT7nCcIJmOxzDjOK6th84tMp
	 BATB8I07Vuy88kfUjYuhW38MmQFYsub8EGx9icwZKIWtAy/pWG7kXb7te1rnXafI/P
	 PUzP1vrASLBuBwS4x4GcViwFhdAzhEUiCxnOj1l0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"linux-erofs@lists.ozlabs.org, LKML" <linux-kernel@vger.kernel.org>,
	Yue Hu <huyue2@coolpad.com>,
	Jingbo Xu <jefflexu@linux.alibaba.com>,
	Chao Yu <chao@kernel.org>,
	Gao Xiang <hsiangkao@linux.alibaba.com>
Subject: [PATCH 6.1 654/798] erofs: get rid of erofs_inode_datablocks()
Date: Mon, 14 Oct 2024 16:20:08 +0200
Message-ID: <20241014141243.744899671@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gao Xiang <hsiangkao@linux.alibaba.com>

commit 4efdec36dc9907628e590a68193d6d8e5e74d032 upstream.

erofs_inode_datablocks() has the only one caller, let's just get
rid of it entirely.  No logic changes.

Reviewed-by: Yue Hu <huyue2@coolpad.com>
Reviewed-by: Jingbo Xu <jefflexu@linux.alibaba.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Stable-dep-of: 9ed50b8231e3 ("erofs: fix incorrect symlink detection in fast symlink")
Link: https://lore.kernel.org/r/20230204093040.97967-1-hsiangkao@linux.alibaba.com
[ Gao Xiang: apply this to 6.6.y to avoid further backport twists
             due to obsoleted EROFS_BLKSIZ. ]
Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
Obsoleted EROFS_BLKSIZ impedes efforts to backport
 9ed50b8231e3 ("erofs: fix incorrect symlink detection in fast symlink")
 9e2f9d34dd12 ("erofs: handle overlapped pclusters out of crafted images properly")

To avoid further bugfix conflicts due to random EROFS_BLKSIZs
around the whole codebase, just backport the dependencies for 6.1.y.

 fs/erofs/internal.h |    6 ------
 fs/erofs/namei.c    |   18 +++++-------------
 2 files changed, 5 insertions(+), 19 deletions(-)

--- a/fs/erofs/internal.h
+++ b/fs/erofs/internal.h
@@ -347,12 +347,6 @@ static inline erofs_off_t erofs_iloc(str
 		(EROFS_I(inode)->nid << sbi->islotbits);
 }
 
-static inline unsigned long erofs_inode_datablocks(struct inode *inode)
-{
-	/* since i_size cannot be changed */
-	return DIV_ROUND_UP(inode->i_size, EROFS_BLKSIZ);
-}
-
 static inline unsigned int erofs_bitrange(unsigned int value, unsigned int bit,
 					  unsigned int bits)
 {
--- a/fs/erofs/namei.c
+++ b/fs/erofs/namei.c
@@ -5,7 +5,6 @@
  * Copyright (C) 2022, Alibaba Cloud
  */
 #include "xattr.h"
-
 #include <trace/events/erofs.h>
 
 struct erofs_qstr {
@@ -87,19 +86,13 @@ static struct erofs_dirent *find_target_
 	return ERR_PTR(-ENOENT);
 }
 
-static void *find_target_block_classic(struct erofs_buf *target,
-				       struct inode *dir,
-				       struct erofs_qstr *name,
-				       int *_ndirents)
+static void *erofs_find_target_block(struct erofs_buf *target,
+		struct inode *dir, struct erofs_qstr *name, int *_ndirents)
 {
-	unsigned int startprfx, endprfx;
-	int head, back;
+	int head = 0, back = DIV_ROUND_UP(dir->i_size, EROFS_BLKSIZ) - 1;
+	unsigned int startprfx = 0, endprfx = 0;
 	void *candidate = ERR_PTR(-ENOENT);
 
-	startprfx = endprfx = 0;
-	head = 0;
-	back = erofs_inode_datablocks(dir) - 1;
-
 	while (head <= back) {
 		const int mid = head + (back - head) / 2;
 		struct erofs_buf buf = __EROFS_BUF_INITIALIZER;
@@ -180,8 +173,7 @@ int erofs_namei(struct inode *dir, const
 	qn.end = name->name + name->len;
 
 	ndirents = 0;
-
-	de = find_target_block_classic(&buf, dir, &qn, &ndirents);
+	de = erofs_find_target_block(&buf, dir, &qn, &ndirents);
 	if (IS_ERR(de))
 		return PTR_ERR(de);
 


