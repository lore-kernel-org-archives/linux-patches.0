Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FBE02FDC5D;
	Tue, 12 Aug 2025 17:39:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755020354; cv=none; b=HgpypNuTSlBlV/anR0tX2e3LOiVLB1/D2DurQCfN2VHUfCe8Yq0T5om1+Gh05cCR8pk1rSXnxW5NgTjvfKGGZbLTwMo6VqDmrBNDeAdzD8Pfd8nPqdSdIZn4qpnkVJNOOfOS7G5KSc/2cWGOGPv5wUCqkmuIWbyT35KMKFCa2CQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755020354; c=relaxed/simple;
	bh=TNUXxCloo26rcRt/pEk4jjGJxKRoJmXDgivNvPvUPgI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BRuJPX3STWeNDWugwNqCMrd7xqBGd84EhAedHrHSxtdIx2dZc5d+S2EXWGo87pExxAL6ql80YnHTVyhZMWd+pJSyjCkCGSnYK60rYZ7M6wy/asF0nm3LcDjLnLyqkATuA26LJGhVazAU2L0bJYHnStv1453WDc2GEOZ5Bb2SMh8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bR/OVvJL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bR/OVvJL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3185C4CEF0;
	Tue, 12 Aug 2025 17:39:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755020354;
	bh=TNUXxCloo26rcRt/pEk4jjGJxKRoJmXDgivNvPvUPgI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bR/OVvJLGCzWeHAAPxfGqSHLNMzTN7W+Dy++EUpjwO5kjAUdDnjKhpQetsMIBx9J2
	 eRyJBtxY3FhD18xsngrmOZvFdS9/vRAcx5DLP5LNTIs0sE9uQ+cR2b6bHgGqdTCjOB
	 +mO8833+cXbKOF+fZYs5VWVM9tPgTREpwq7o5XdI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yue Hu <huyue2@coolpad.com>,
	Jingbo Xu <jefflexu@linux.alibaba.com>,
	Chao Yu <chao@kernel.org>,
	Gao Xiang <hsiangkao@linux.alibaba.com>
Subject: [PATCH 6.1 054/253] erofs: get rid of debug_one_dentry()
Date: Tue, 12 Aug 2025 19:27:22 +0200
Message-ID: <20250812172951.026842414@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812172948.675299901@linuxfoundation.org>
References: <20250812172948.675299901@linuxfoundation.org>
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

From: Gao Xiang <hsiangkao@linux.alibaba.com>

commit e324eaa9790614577c93e819651e0a83963dac79 upstream.

Since erofsdump is available, no need to keep this debugging
functionality at all.

Also drop a useless comment since it's the VFS behavior.

Link: https://lore.kernel.org/r/20230114125746.399253-1-xiang@kernel.org
Reviewed-by: Yue Hu <huyue2@coolpad.com>
Reviewed-by: Jingbo Xu <jefflexu@linux.alibaba.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/erofs/dir.c |   17 -----------------
 1 file changed, 17 deletions(-)

--- a/fs/erofs/dir.c
+++ b/fs/erofs/dir.c
@@ -6,21 +6,6 @@
  */
 #include "internal.h"
 
-static void debug_one_dentry(unsigned char d_type, const char *de_name,
-			     unsigned int de_namelen)
-{
-#ifdef CONFIG_EROFS_FS_DEBUG
-	/* since the on-disk name could not have the trailing '\0' */
-	unsigned char dbg_namebuf[EROFS_NAME_LEN + 1];
-
-	memcpy(dbg_namebuf, de_name, de_namelen);
-	dbg_namebuf[de_namelen] = '\0';
-
-	erofs_dbg("found dirent %s de_len %u d_type %d", dbg_namebuf,
-		  de_namelen, d_type);
-#endif
-}
-
 static int erofs_fill_dentries(struct inode *dir, struct dir_context *ctx,
 			       void *dentry_blk, struct erofs_dirent *de,
 			       unsigned int nameoff, unsigned int maxsize)
@@ -52,10 +37,8 @@ static int erofs_fill_dentries(struct in
 			return -EFSCORRUPTED;
 		}
 
-		debug_one_dentry(d_type, de_name, de_namelen);
 		if (!dir_emit(ctx, de_name, de_namelen,
 			      le64_to_cpu(de->nid), d_type))
-			/* stopped by some reason */
 			return 1;
 		++de;
 		ctx->pos += sizeof(struct erofs_dirent);


