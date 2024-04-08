Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5753881ABE;
	Mon,  8 Apr 2024 13:29:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712582982; cv=none; b=U9489q68x7gjifYyPWkHntw69lZW5Gr0TPCO0biA5pFeHiJZp7y2mQpDYBdyOgR1CZ11YMvUN+V4n5bRgR9DQ1qsfg42hw3vlDLvY/edO80OaBJb4hu0cjU2yGW+OJGo7icUfyDCan6lm362Y7oxP/Vd9ziu2vdHadL6XeW1R3o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712582982; c=relaxed/simple;
	bh=6P0sDAWc9fnBXTghOHbRcMT2BWvrkt3RkGwVmmk605Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KrJ5Ig5EgQTYCgeyfV916+9U2kpJvEBtv4xT51TR/9QbJ+gpFaSddTo+rbxJujapQp3jbOTiiQgFRXZXIlHQZetH7xR7JI+weSFx6zKaa8RNEJpLYlzcJ3Gqdzz6BY8+mLIdHoZa+zBKT1R6vkmO0wDDQvzKmrATOORSj4bi+34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Cbfv0+7Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Cbfv0+7Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D41B8C43390;
	Mon,  8 Apr 2024 13:29:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712582982;
	bh=6P0sDAWc9fnBXTghOHbRcMT2BWvrkt3RkGwVmmk605Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Cbfv0+7QvyZzit5kq2DA/iNiq74yk9tOJqP1FnSXoeq7WxOPJeXtPZsxSnStR0/yx
	 nuUPvkMtkozsUKRVYgALlFiHuRSAie0r4XnX/zeihjEgpBcNQoOml3YQuuh8l7ZnnH
	 0jOQWDIz2ikTzakS/P/5QmIbFYb/wC6n8+YD3x9M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Trond Myklebust <trond.myklebust@hammerspace.com>
Subject: [PATCH 5.15 195/690] NFS: Remove unnecessary TRACE_DEFINE_ENUM()s
Date: Mon,  8 Apr 2024 14:51:01 +0200
Message-ID: <20240408125406.621546589@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125359.506372836@linuxfoundation.org>
References: <20240408125359.506372836@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit 8e09650f5ec68858f4b8b67cdef9e2ece9b208f3 ]

Clean up: TRACE_DEFINE_ENUM is unnecessary because the target
symbols are all C macros, not enums.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/nfs/nfstrace.h | 68 -----------------------------------------------
 1 file changed, 68 deletions(-)

diff --git a/fs/nfs/nfstrace.h b/fs/nfs/nfstrace.h
index 8a224871be74c..589f32fdbe637 100644
--- a/fs/nfs/nfstrace.h
+++ b/fs/nfs/nfstrace.h
@@ -11,16 +11,6 @@
 #include <linux/tracepoint.h>
 #include <linux/iversion.h>
 
-TRACE_DEFINE_ENUM(DT_UNKNOWN);
-TRACE_DEFINE_ENUM(DT_FIFO);
-TRACE_DEFINE_ENUM(DT_CHR);
-TRACE_DEFINE_ENUM(DT_DIR);
-TRACE_DEFINE_ENUM(DT_BLK);
-TRACE_DEFINE_ENUM(DT_REG);
-TRACE_DEFINE_ENUM(DT_LNK);
-TRACE_DEFINE_ENUM(DT_SOCK);
-TRACE_DEFINE_ENUM(DT_WHT);
-
 #define nfs_show_file_type(ftype) \
 	__print_symbolic(ftype, \
 			{ DT_UNKNOWN, "UNKNOWN" }, \
@@ -33,24 +23,6 @@ TRACE_DEFINE_ENUM(DT_WHT);
 			{ DT_SOCK, "SOCK" }, \
 			{ DT_WHT, "WHT" })
 
-TRACE_DEFINE_ENUM(NFS_INO_INVALID_DATA);
-TRACE_DEFINE_ENUM(NFS_INO_INVALID_ATIME);
-TRACE_DEFINE_ENUM(NFS_INO_INVALID_ACCESS);
-TRACE_DEFINE_ENUM(NFS_INO_INVALID_ACL);
-TRACE_DEFINE_ENUM(NFS_INO_REVAL_PAGECACHE);
-TRACE_DEFINE_ENUM(NFS_INO_REVAL_FORCED);
-TRACE_DEFINE_ENUM(NFS_INO_INVALID_LABEL);
-TRACE_DEFINE_ENUM(NFS_INO_INVALID_CHANGE);
-TRACE_DEFINE_ENUM(NFS_INO_INVALID_CTIME);
-TRACE_DEFINE_ENUM(NFS_INO_INVALID_MTIME);
-TRACE_DEFINE_ENUM(NFS_INO_INVALID_SIZE);
-TRACE_DEFINE_ENUM(NFS_INO_INVALID_OTHER);
-TRACE_DEFINE_ENUM(NFS_INO_DATA_INVAL_DEFER);
-TRACE_DEFINE_ENUM(NFS_INO_INVALID_BLOCKS);
-TRACE_DEFINE_ENUM(NFS_INO_INVALID_XATTR);
-TRACE_DEFINE_ENUM(NFS_INO_INVALID_NLINK);
-TRACE_DEFINE_ENUM(NFS_INO_INVALID_MODE);
-
 #define nfs_show_cache_validity(v) \
 	__print_flags(v, "|", \
 			{ NFS_INO_INVALID_DATA, "INVALID_DATA" }, \
@@ -71,17 +43,6 @@ TRACE_DEFINE_ENUM(NFS_INO_INVALID_MODE);
 			{ NFS_INO_INVALID_NLINK, "INVALID_NLINK" }, \
 			{ NFS_INO_INVALID_MODE, "INVALID_MODE" })
 
-TRACE_DEFINE_ENUM(NFS_INO_ADVISE_RDPLUS);
-TRACE_DEFINE_ENUM(NFS_INO_STALE);
-TRACE_DEFINE_ENUM(NFS_INO_ACL_LRU_SET);
-TRACE_DEFINE_ENUM(NFS_INO_INVALIDATING);
-TRACE_DEFINE_ENUM(NFS_INO_FSCACHE);
-TRACE_DEFINE_ENUM(NFS_INO_FSCACHE_LOCK);
-TRACE_DEFINE_ENUM(NFS_INO_LAYOUTCOMMIT);
-TRACE_DEFINE_ENUM(NFS_INO_LAYOUTCOMMITTING);
-TRACE_DEFINE_ENUM(NFS_INO_LAYOUTSTATS);
-TRACE_DEFINE_ENUM(NFS_INO_ODIRECT);
-
 #define nfs_show_nfsi_flags(v) \
 	__print_flags(v, "|", \
 			{ BIT(NFS_INO_ADVISE_RDPLUS), "ADVISE_RDPLUS" }, \
@@ -270,19 +231,6 @@ TRACE_EVENT(nfs_access_exit,
 		)
 );
 
-TRACE_DEFINE_ENUM(LOOKUP_FOLLOW);
-TRACE_DEFINE_ENUM(LOOKUP_DIRECTORY);
-TRACE_DEFINE_ENUM(LOOKUP_AUTOMOUNT);
-TRACE_DEFINE_ENUM(LOOKUP_PARENT);
-TRACE_DEFINE_ENUM(LOOKUP_REVAL);
-TRACE_DEFINE_ENUM(LOOKUP_RCU);
-TRACE_DEFINE_ENUM(LOOKUP_OPEN);
-TRACE_DEFINE_ENUM(LOOKUP_CREATE);
-TRACE_DEFINE_ENUM(LOOKUP_EXCL);
-TRACE_DEFINE_ENUM(LOOKUP_RENAME_TARGET);
-TRACE_DEFINE_ENUM(LOOKUP_EMPTY);
-TRACE_DEFINE_ENUM(LOOKUP_DOWN);
-
 #define show_lookup_flags(flags) \
 	__print_flags(flags, "|", \
 			{ LOOKUP_FOLLOW, "FOLLOW" }, \
@@ -392,22 +340,6 @@ DEFINE_NFS_LOOKUP_EVENT_DONE(nfs_lookup_exit);
 DEFINE_NFS_LOOKUP_EVENT(nfs_lookup_revalidate_enter);
 DEFINE_NFS_LOOKUP_EVENT_DONE(nfs_lookup_revalidate_exit);
 
-TRACE_DEFINE_ENUM(O_WRONLY);
-TRACE_DEFINE_ENUM(O_RDWR);
-TRACE_DEFINE_ENUM(O_CREAT);
-TRACE_DEFINE_ENUM(O_EXCL);
-TRACE_DEFINE_ENUM(O_NOCTTY);
-TRACE_DEFINE_ENUM(O_TRUNC);
-TRACE_DEFINE_ENUM(O_APPEND);
-TRACE_DEFINE_ENUM(O_NONBLOCK);
-TRACE_DEFINE_ENUM(O_DSYNC);
-TRACE_DEFINE_ENUM(O_DIRECT);
-TRACE_DEFINE_ENUM(O_LARGEFILE);
-TRACE_DEFINE_ENUM(O_DIRECTORY);
-TRACE_DEFINE_ENUM(O_NOFOLLOW);
-TRACE_DEFINE_ENUM(O_NOATIME);
-TRACE_DEFINE_ENUM(O_CLOEXEC);
-
 #define show_open_flags(flags) \
 	__print_flags(flags, "|", \
 		{ O_WRONLY, "O_WRONLY" }, \
-- 
2.43.0



