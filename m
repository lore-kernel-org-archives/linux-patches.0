Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064484;
	b=pXsgoxJxanUqvOGI5oVxVj3fH6iIoZVGrROouMXvlUNZIkKdBxjSYwWOrYfaCUtCWX68
	 /WUBCKh+J5q2dXgCysE4mtOf/jDACuLeZHOcLZfZ4sgroeZmHYFMTQZRutZxjJBACoYym
	 fme4Wc0pEmiORvQRsj9s4EpFxMM+so93b0FMHcrAOk7xzlChc82DsD4YaDkyr6poFr8oi
	 C6Q+52fthL6+EplAD7GZvDiH/kKsIz7ZIU3e/suiwlAfl6+kKNAGNdVPXwIB/eLRPdabJ
	 imB49maXbZWYT7e2Mc3uNIdC9/WTkACAc5AluVKHwSQ88Xq43ZKgicNdSBlGpYfwSDA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064484;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2XrVixnvYviCzcaEqMKzZghUOYezXb0tM1QuRknX6AE=;
	b=0ATysatrJFHHu5hye+MFiKjhO8N30eT3X12GH5D7tml6977WsglkWnG9EJrVqHa37PgM
	 6fIddvU/bFAZKY2G+tggJBQG4trLDet8rePJ7V3K+mXTr441mp5Gx5LHBHgRcEuaTfhXl
	 UUSZJ2r1fJz2+VcmQO9PhvtQSiPNjtAhkX3ipRhpWivQmlZ0vMY7MSQQQUxbP0BPhTqjt
	 HwYTSvYpGOX44OT9gYddEg0PrzlDTrE2kj9FPmLYCY5z0nAkAloAAzu5kI0SZOR2lKkn+
	 AvyM8Orf2FX2tYsYvulkUXQwUZfJSC7d42EvpTJeQgTYcgfWutSLuu3Gqf+te9BEd1g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CFFhfIiP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BE86606A9F0;
	Sat,  7 Nov 2026 15:14:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CFFhfIiP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF3011F0089F;
	Sat,  7 Nov 2026 15:14:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064484;
	bh=2XrVixnvYviCzcaEqMKzZghUOYezXb0tM1QuRknX6AE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CFFhfIiP/ijZIN4c4ZINUwnJ7DVMZR2YuHbEGY/QtB8OsOU9W1XHv7FNyQaR85ShG
	 f8tP4+7XhQJiM/j4bhf4iqV40uI6jr2tZM+kqpFSSGZrcOsdIKpqbYczrnn1sxQr2u
	 u0vlVW9Ht9pdwHMu2gQ/DGs/hISRCimuA0UDoh4s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
	Andrew Morton <akpm@linux-foundation.org>,
	syzbot+e64c6472a3d96a75172a@syzkaller.appspotmail.com,
	syzbot+26461e903494e689c24f@syzkaller.appspotmail.com,
	Yemu Lu <prcups@krgm.moe>,
	Ren Wei <n05ec@lzu.edu.cn>,
	Yuan Tan <yuantan098@gmail.com>,
	Yifan Wu <yifanwucs@gmail.com>,
	Juefei Pu <tomapufckgml@gmail.com>,
	Xin Liu <bird@lzu.edu.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0521/1257] fat: fix fat_ent_write() for reverting the value
Date: Sat,  7 Nov 2026 08:46:57 -0500
Message-ID: <20261107134953.817267713@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>

[ Upstream commit 63c4b67ee163b2a67a7561314bf2106d6c79c53c ]

commit 64d9183203ee ("fat: restore original value when fat_ent_write
failed") try to revert the fatent value to old value when got the error on
mirror FAT.

However it didn't work if the error is when writing the fatent bh.  In
that case, the bh is cleared the uptodate flag, so reuse bh is invalid.

Fix this by reverting the fatent only if got the error on mirror FAT.

Link: https://lore.kernel.org/87ik4yz9fv.fsf_-_@mail.parknet.co.jp
Fixes: 64d9183203ee ("fat: restore original value when fat_ent_write failed")
Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reported-by: syzbot+e64c6472a3d96a75172a@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=e64c6472a3d96a75172a
Reported-by: syzbot+26461e903494e689c24f@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=26461e903494e689c24f
Cc: Yemu Lu <prcups@krgm.moe>
Cc: Ren Wei <n05ec@lzu.edu.cn>
Cc: Yuan Tan <yuantan098@gmail.com>
Cc: Yifan Wu <yifanwucs@gmail.com>
Cc: Juefei Pu <tomapufckgml@gmail.com>
Cc: Xin Liu <bird@lzu.edu.cn>
Cc: <stable@vger.kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/fat/fat.h    |  2 +-
 fs/fat/fatent.c | 21 ++++++++++++++++++---
 fs/fat/file.c   |  3 ++-
 fs/fat/misc.c   |  6 ++----
 4 files changed, 23 insertions(+), 9 deletions(-)

diff --git a/fs/fat/fat.h b/fs/fat/fat.h
index 61338413d9f3e..fbd207c55859e 100644
--- a/fs/fat/fat.h
+++ b/fs/fat/fat.h
@@ -392,7 +392,7 @@ extern void fat_ent_access_init(struct super_block *sb);
 extern int fat_ent_read(struct inode *inode, struct fat_entry *fatent,
 			int entry);
 extern int fat_ent_write(struct inode *inode, struct fat_entry *fatent,
-			 int new, int wait);
+			 int new, int old, int wait);
 extern int fat_alloc_clusters(struct inode *inode, int *cluster,
 			      int nr_cluster);
 extern int fat_free_clusters(struct inode *inode, int cluster);
diff --git a/fs/fat/fatent.c b/fs/fat/fatent.c
index f0801d99dd62a..df23fc85f3130 100644
--- a/fs/fat/fatent.c
+++ b/fs/fat/fatent.c
@@ -413,7 +413,7 @@ static int fat_mirror_bhs(struct super_block *sb, struct buffer_head **bhs,
 }
 
 int fat_ent_write(struct inode *inode, struct fat_entry *fatent,
-		  int new, int wait)
+		  int new, int old, int wait)
 {
 	struct super_block *sb = inode->i_sb;
 	const struct fatent_operations *ops = MSDOS_SB(sb)->fatent_ops;
@@ -422,10 +422,25 @@ int fat_ent_write(struct inode *inode, struct fat_entry *fatent,
 	ops->ent_put(fatent, new);
 	if (wait) {
 		err = fat_sync_bhs(fatent->bhs, fatent->nr_bhs);
-		if (err)
+		if (err) {
+			/*
+			 * bhs are not uptodate after I/O error. So we
+			 * can't simply re-dirty to revert. And it
+			 * would not have value to write again on I/O
+			 * error.
+			 */
 			return err;
+		}
 	}
-	return fat_mirror_bhs(sb, fatent->bhs, fatent->nr_bhs);
+
+	err = fat_mirror_bhs(sb, fatent->bhs, fatent->nr_bhs);
+	if (err) {
+		/* Try to revert if got the error on mirror FAT */
+		ops->ent_put(fatent, old);
+		if (wait)
+			fat_sync_bhs(fatent->bhs, fatent->nr_bhs);
+	}
+	return err;
 }
 
 static inline int fat_ent_next(struct msdos_sb_info *sbi,
diff --git a/fs/fat/file.c b/fs/fat/file.c
index 1c835ca5f21a5..6c475c53334c6 100644
--- a/fs/fat/file.c
+++ b/fs/fat/file.c
@@ -363,7 +363,8 @@ static int fat_free(struct inode *inode, int skip)
 				     __func__, MSDOS_I(inode)->i_pos);
 			ret = -EIO;
 		} else if (ret > 0) {
-			err = fat_ent_write(inode, &fatent, FAT_ENT_EOF, wait);
+			err = fat_ent_write(inode, &fatent, FAT_ENT_EOF, ret,
+					    wait);
 			if (err)
 				ret = err;
 		}
diff --git a/fs/fat/misc.c b/fs/fat/misc.c
index e79762cf19754..c44296756eae6 100644
--- a/fs/fat/misc.c
+++ b/fs/fat/misc.c
@@ -133,11 +133,9 @@ int fat_chain_add(struct inode *inode, int new_dclus, int nr_cluster)
 		ret = fat_ent_read(inode, &fatent, last);
 		if (ret >= 0) {
 			int wait = inode_needs_sync(inode);
-			int old = ret;
 
-			ret = fat_ent_write(inode, &fatent, new_dclus, wait);
-			if (ret < 0)
-				fat_ent_write(inode, &fatent, old, wait);
+			ret = fat_ent_write(inode, &fatent, new_dclus, ret,
+					    wait);
 			fatent_brelse(&fatent);
 		}
 		if (ret < 0)
-- 
2.53.0



