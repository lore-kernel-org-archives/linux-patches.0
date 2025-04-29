Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42E67221D92;
	Tue, 29 Apr 2025 18:08:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745950086; cv=none; b=AHP1UV8VWDLMvzElgrNLijSY5UoFfHvvbYLPyYleKLLm36weLcLVyXNS0NTsoQayc+zPUJPqBQwLfYorc8/LiNTJ+LxzFlOZyJCKwRhtN1b8KBlCNXOkZtDM9P97syosyffXjLAfx7gR/jnOQ4noacDqr9TyAxNJxYwf7vTWSkk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745950086; c=relaxed/simple;
	bh=NnRJ1/0rh7gym2r57mgFeM1kHe0Sgp3NiaSze3HH+Jg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fJblBry9iFa6j68JbgHLKhoIPS8ALSgp8Vn9LgLj4/tbOPCoHN0smhHEUdjyL99EotGqnq6uX1facwcy5ituZLrS5ZwqNJjFd3bfYatkH0wyIYw9TnJNOWxmUaE5wkv0Z3GBzt3936lzehOr+87H7iN0ndydA7uEuEa5dRv7O14=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OrH1z/Wf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OrH1z/Wf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D7E6C4CEE9;
	Tue, 29 Apr 2025 18:08:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745950086;
	bh=NnRJ1/0rh7gym2r57mgFeM1kHe0Sgp3NiaSze3HH+Jg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OrH1z/WfY4Ggr2B/ObKoT7j9ujlec8yWfCbvITV0RKg+6vXg9rQDT2XFU3Pm2sABe
	 8zPqPcZUEhzPIshPbvQRHazIjFcgC5bweZNclCXM13khWL5WgoV9Z/u0sbBWYW33o3
	 nmNsguPn0Jh5dxL+rwrMnNqlXuVKsXPFlrsMYYpM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dave Kleikamp <dave.kleikamp@oracle.com>,
	Manas Ghandat <ghandatmanas@gmail.com>,
	syzbot+7cb897779f3c479d0615@syzkaller.appspotmail.com,
	syzbot+6b1d79dad6cc6b3eef41@syzkaller.appspotmail.com,
	syzbot+67f714a53ce18d5b542e@syzkaller.appspotmail.com,
	syzbot+e829cfdd0de521302df4@syzkaller.appspotmail.com,
	Aditya Dutt <duttaditya18@gmail.com>
Subject: [PATCH 6.1 151/167] jfs: define xtree root and page independently
Date: Tue, 29 Apr 2025 18:44:19 +0200
Message-ID: <20250429161057.830369930@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161051.743239894@linuxfoundation.org>
References: <20250429161051.743239894@linuxfoundation.org>
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

From: Dave Kleikamp <dave.kleikamp@oracle.com>

commit a779ed754e52d582b8c0e17959df063108bd0656 upstream.

In order to make array bounds checking sane, provide a separate
definition of the in-inode xtree root and the external xtree page.

Signed-off-by: Dave Kleikamp <dave.kleikamp@oracle.com>
Tested-by: Manas Ghandat <ghandatmanas@gmail.com>
Closes: https://syzkaller.appspot.com/bug?extid=7cb897779f3c479d0615
Closes: https://syzkaller.appspot.com/bug?extid=6b1d79dad6cc6b3eef41
Closes: https://syzkaller.appspot.com/bug?extid=67f714a53ce18d5b542e
Closes: https://syzkaller.appspot.com/bug?extid=e829cfdd0de521302df4
Reported-by: syzbot+7cb897779f3c479d0615@syzkaller.appspotmail.com
Reported-by: syzbot+6b1d79dad6cc6b3eef41@syzkaller.appspotmail.com
Reported-by: syzbot+67f714a53ce18d5b542e@syzkaller.appspotmail.com
Reported-by: syzbot+e829cfdd0de521302df4@syzkaller.appspotmail.com
Signed-off-by: Aditya Dutt <duttaditya18@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/jfs/jfs_dinode.h |    2 +-
 fs/jfs/jfs_imap.c   |    6 +++---
 fs/jfs/jfs_incore.h |    2 +-
 fs/jfs/jfs_txnmgr.c |    4 ++--
 fs/jfs/jfs_xtree.c  |    4 ++--
 fs/jfs/jfs_xtree.h  |   37 +++++++++++++++++++++++--------------
 6 files changed, 32 insertions(+), 23 deletions(-)

--- a/fs/jfs/jfs_dinode.h
+++ b/fs/jfs/jfs_dinode.h
@@ -96,7 +96,7 @@ struct dinode {
 #define di_gengen	u._file._u1._imap._gengen
 
 			union {
-				xtpage_t _xtroot;
+				xtroot_t _xtroot;
 				struct {
 					u8 unused[16];	/* 16: */
 					dxd_t _dxd;	/* 16: */
--- a/fs/jfs/jfs_imap.c
+++ b/fs/jfs/jfs_imap.c
@@ -673,7 +673,7 @@ int diWrite(tid_t tid, struct inode *ip)
 		 * This is the special xtree inside the directory for storing
 		 * the directory table
 		 */
-		xtpage_t *p, *xp;
+		xtroot_t *p, *xp;
 		xad_t *xad;
 
 		jfs_ip->xtlid = 0;
@@ -687,7 +687,7 @@ int diWrite(tid_t tid, struct inode *ip)
 		 * copy xtree root from inode to dinode:
 		 */
 		p = &jfs_ip->i_xtroot;
-		xp = (xtpage_t *) &dp->di_dirtable;
+		xp = (xtroot_t *) &dp->di_dirtable;
 		lv = ilinelock->lv;
 		for (n = 0; n < ilinelock->index; n++, lv++) {
 			memcpy(&xp->xad[lv->offset], &p->xad[lv->offset],
@@ -716,7 +716,7 @@ int diWrite(tid_t tid, struct inode *ip)
 	 *	regular file: 16 byte (XAD slot) granularity
 	 */
 	if (type & tlckXTREE) {
-		xtpage_t *p, *xp;
+		xtroot_t *p, *xp;
 		xad_t *xad;
 
 		/*
--- a/fs/jfs/jfs_incore.h
+++ b/fs/jfs/jfs_incore.h
@@ -66,7 +66,7 @@ struct jfs_inode_info {
 	lid_t	xtlid;		/* lid of xtree lock on directory */
 	union {
 		struct {
-			xtpage_t _xtroot;	/* 288: xtree root */
+			xtroot_t _xtroot;	/* 288: xtree root */
 			struct inomap *_imap;	/* 4: inode map header	*/
 		} file;
 		struct {
--- a/fs/jfs/jfs_txnmgr.c
+++ b/fs/jfs/jfs_txnmgr.c
@@ -783,7 +783,7 @@ struct tlock *txLock(tid_t tid, struct i
 			if (mp->xflag & COMMIT_PAGE)
 				p = (xtpage_t *) mp->data;
 			else
-				p = &jfs_ip->i_xtroot;
+				p = (xtpage_t *) &jfs_ip->i_xtroot;
 			xtlck->lwm.offset =
 			    le16_to_cpu(p->header.nextindex);
 		}
@@ -1676,7 +1676,7 @@ static void xtLog(struct jfs_log * log,
 
 	if (tlck->type & tlckBTROOT) {
 		lrd->log.redopage.type |= cpu_to_le16(LOG_BTROOT);
-		p = &JFS_IP(ip)->i_xtroot;
+		p = (xtpage_t *) &JFS_IP(ip)->i_xtroot;
 		if (S_ISDIR(ip->i_mode))
 			lrd->log.redopage.type |=
 			    cpu_to_le16(LOG_DIR_XTREE);
--- a/fs/jfs/jfs_xtree.c
+++ b/fs/jfs/jfs_xtree.c
@@ -1213,7 +1213,7 @@ xtSplitRoot(tid_t tid,
 	struct xtlock *xtlck;
 	int rc;
 
-	sp = &JFS_IP(ip)->i_xtroot;
+	sp = (xtpage_t *) &JFS_IP(ip)->i_xtroot;
 
 	INCREMENT(xtStat.split);
 
@@ -2098,7 +2098,7 @@ int xtAppend(tid_t tid,		/* transaction
  */
 void xtInitRoot(tid_t tid, struct inode *ip)
 {
-	xtpage_t *p;
+	xtroot_t *p;
 
 	/*
 	 * acquire a transaction lock on the root
--- a/fs/jfs/jfs_xtree.h
+++ b/fs/jfs/jfs_xtree.h
@@ -65,24 +65,33 @@ struct xadlist {
 #define XTPAGEMAXSLOT	256
 #define XTENTRYSTART	2
 
+struct xtheader {
+	__le64 next;	/* 8: */
+	__le64 prev;	/* 8: */
+
+	u8 flag;	/* 1: */
+	u8 rsrvd1;	/* 1: */
+	__le16 nextindex;	/* 2: next index = number of entries */
+	__le16 maxentry;	/* 2: max number of entries */
+	__le16 rsrvd2;	/* 2: */
+
+	pxd_t self;	/* 8: self */
+};
+
 /*
- *	xtree page:
+ *	xtree root (in inode):
  */
 typedef union {
-	struct xtheader {
-		__le64 next;	/* 8: */
-		__le64 prev;	/* 8: */
-
-		u8 flag;	/* 1: */
-		u8 rsrvd1;	/* 1: */
-		__le16 nextindex;	/* 2: next index = number of entries */
-		__le16 maxentry;	/* 2: max number of entries */
-		__le16 rsrvd2;	/* 2: */
-
-		pxd_t self;	/* 8: self */
-	} header;		/* (32) */
-
+	struct xtheader header;
 	xad_t xad[XTROOTMAXSLOT];	/* 16 * maxentry: xad array */
+} xtroot_t;
+
+/*
+ *	xtree page:
+ */
+typedef union {
+	struct xtheader header;
+	xad_t xad[XTPAGEMAXSLOT];	/* 16 * maxentry: xad array */
 } xtpage_t;
 
 /*


