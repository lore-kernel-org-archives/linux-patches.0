Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793213118;
	b=HYR0rZ2HEWwxaEmUXqjkxVImHtMnZUlG+hBFoKPVX02K/3SCCfnU7XVsEiRZLNyhEbre
	 lN8C8pyFfpbyoR+qSVhMFJL6OhYa+29yYta96ncQ5MJHlpdrYhED/z13tBrenyYPfuMfm
	 D5PlAZ+UXlRvRjAZgUkqReEj9Cjb36US1HB012DJto8bbsLLLDmasGaszFby4uxhSzLK6
	 tNAm/NBLGo2XtTOWvnnVVfQljZ9q0hPmorpICfJBhJ1p+bQ6q1bk1wD8tbo4+fj3uCY2T
	 q3x20aH4bDQJEWF6G9MKWJFC7nbIHU/u736DbKcbZI+UfJkd2rgxir8a0Lfkfsmkoxw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793213118;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2qzCrGKcAuJOUG5/lCfjIGSMovo+ZRfzC+46yVv1OXw=;
	b=dNFe+8tP8msCzJeZyycv5Xn2jR/t2XVKoLj4oylVQpKPfxWSLgG7Q22/fxdZWNR0j4EP
	 4uSt4BJ2vL2G7bgL8q0/vVhwuvadtkGK/KlKQ8DC9YcYXxx8L6K3jWNnvnJgJq5DoW5c+
	 XDBSwbYkN3mh5vcC8qTpbDpJmWaOzAQG2MrkdcGo1FOrB1y1sttd4iTuash+zRnEQVdIX
	 3vPdlM6pZ/pQsqsrqMR03cw7TQu42DXmJAGeacCI9n9Me8NuZhZmoQeQa6tZjO3x9TCQz
	 nDo95dZRAXN7tm3pMBYJFw60JLbIAPovFUjVltSvW7UvnGXWGel3IwvkjbE2mbyLqHg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YcrIWR3X;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67570606A31D;
	Wed, 28 Oct 2026 18:45:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YcrIWR3X
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8EE11F01825;
	Wed, 28 Oct 2026 18:45:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793213118;
	bh=2qzCrGKcAuJOUG5/lCfjIGSMovo+ZRfzC+46yVv1OXw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YcrIWR3XXYN3/lqIkz/YLlGXDLsVIlh40cmvXZjlZAvJoXgJygEis20wQpLkwAFxy
	 DJP6L35LwT4u7NmRswi4g+IRM8wCmQL3yuKSmGEb7Vw5++cBi6K8HitzpQUXiS0mS8
	 oN0Bafq0PwuEGUO30JKu+PPdKFwSxHG65BVv5hFs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+b974bd41515f770c608b@syzkaller.appspotmail.com,
	Aditya Dutt <duttaditya18@gmail.com>,
	Dave Kleikamp <dave.kleikamp@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0349/1887] jfs: fix array-index-out-of-bounds read in add_missing_indices
Date: Wed, 28 Oct 2026 17:40:45 +0100
Message-ID: <20261028170507.172015255@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aditya Dutt <duttaditya18@gmail.com>

[ Upstream commit 5dff41a86377563f7a2b968aae00d25b4ceb37c9 ]

stbl is s8 but it must contain offsets into slot which can go from 0 to
127.

Added a bound check for that error and return -EIO if the check fails.
Also make jfs_readdir return with error if add_missing_indices returns
with an error.

Reported-by: syzbot+b974bd41515f770c608b@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com./bug?extid=b974bd41515f770c608b
Signed-off-by: Aditya Dutt <duttaditya18@gmail.com>
Signed-off-by: Dave Kleikamp <dave.kleikamp@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/jfs/jfs_dtree.c | 18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff --git a/fs/jfs/jfs_dtree.c b/fs/jfs/jfs_dtree.c
index 93db6eec44655..ab11849cf9cc3 100644
--- a/fs/jfs/jfs_dtree.c
+++ b/fs/jfs/jfs_dtree.c
@@ -2613,7 +2613,7 @@ void dtInitRoot(tid_t tid, struct inode *ip, u32 idotdot)
  *	     fsck.jfs should really fix this, but it currently does not.
  *	     Called from jfs_readdir when bad index is detected.
  */
-static void add_missing_indices(struct inode *inode, s64 bn)
+static int add_missing_indices(struct inode *inode, s64 bn)
 {
 	struct ldtentry *d;
 	struct dt_lock *dtlck;
@@ -2622,7 +2622,7 @@ static void add_missing_indices(struct inode *inode, s64 bn)
 	struct lv *lv;
 	struct metapage *mp;
 	dtpage_t *p;
-	int rc;
+	int rc = 0;
 	s8 *stbl;
 	tid_t tid;
 	struct tlock *tlck;
@@ -2647,6 +2647,16 @@ static void add_missing_indices(struct inode *inode, s64 bn)
 
 	stbl = DT_GETSTBL(p);
 	for (i = 0; i < p->header.nextindex; i++) {
+		if (stbl[i] < 0) {
+			jfs_err("jfs: add_missing_indices: Invalid stbl[%d] = %d for inode %ld, block = %lld",
+				i, stbl[i], (long)inode->i_ino, (long long)bn);
+			rc = -EIO;
+
+			DT_PUTPAGE(mp);
+			txAbort(tid, 0);
+			goto end;
+		}
+
 		d = (struct ldtentry *) &p->slot[stbl[i]];
 		index = le32_to_cpu(d->index);
 		if ((index < 2) || (index >= JFS_IP(inode)->next_index)) {
@@ -2664,6 +2674,7 @@ static void add_missing_indices(struct inode *inode, s64 bn)
 	(void) txCommit(tid, 1, &inode, 0);
 end:
 	txEnd(tid);
+	return rc;
 }
 
 /*
@@ -3017,7 +3028,8 @@ int jfs_readdir(struct file *file, struct dir_context *ctx)
 		}
 
 		if (fix_page) {
-			add_missing_indices(ip, bn);
+			if ((rc = add_missing_indices(ip, bn)))
+				goto out;
 			page_fixed = 1;
 		}
 
-- 
2.53.0



