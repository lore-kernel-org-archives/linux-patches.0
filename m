Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214575;
	b=s9cF+R4Zs2Q5lWPaIc8cSXcGx/Qt97/uxd2GYDq7EUGfYp1aglNBAZo0LNxCvLBna5tY
	 MYx+cEpN2hGufiUcSKTIGRdI3lCftUtliSNyOKNC9fpD9mc6ruQuBw8U3nVZevw3shnU5
	 yf6FDNw8xkzdT/B2FjelJAsT0fkPE1evZz4F7fITxTxMSqO1vAqlH/Bd8saXz+sluEyrA
	 GN2rlyF924zDSlQT6QBvOych0aBQmOyP9n1c/jO5jIO+65GpsyO/d6S1qBkR6HezE3t9+
	 i3N0mZ3HHLRjGcQ3gShQa4WnRcDh4KZzcCMPNg06odHxP3dF8mipLjsr3nclLK0qRTA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214575;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=W0y/5ZNIx01TFQRvbZeNG8fyo1gtBeoqRyfoGCLQ+G0=;
	b=sIH1izZ/ZLmDtj9N/qOeAvfgju2mcYzHXMXPstLtNOcUyQeSELswa80uQP8ZzGineTJ2
	 Ja5rytK2YUIG/wMbPUmmtpVivkdOkY57svGgEihovrh3WvJJ7B/c8juXDkgLInhzYwlP5
	 qcBnHWe8yyeNJ8GsBjHP18b32ybFTEy0C+eb/6aeluWla1J2At4JjwkSGDpnDIHUU0Dko
	 8FbyQ/sr2YgXhRf+y6x4OzXIUqc7TKSNqp63uhb0bG7eZ2gi3uAcWnuP50E/z9CUoDiMl
	 uf5vk4Z0XX7bOfqMPgkV6aTZ3LsTiv8wN1mQ15gvvDyQmiF+97ZSnnbbdALfEWfIGZQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zaFRmWfE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8685760A2624;
	Wed, 28 Oct 2026 19:09:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zaFRmWfE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8DD81F01829;
	Wed, 28 Oct 2026 19:09:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214575;
	bh=W0y/5ZNIx01TFQRvbZeNG8fyo1gtBeoqRyfoGCLQ+G0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zaFRmWfEqdpoUpgesWtz1uWiWJMPWd+p9vQYKIGGKeo2+UWdTapR6RSwAoaMpbOn4
	 Oa9n7D0dNY173stbaa5CCwuI3DnPMWsVG+kl9bCrxmC4SuVGZObaAAhxkDbNZvzVlb
	 a8Nf1QsRKYUHlPv/rHk4JLSpDuZyHIbc+Q8ZUJ9c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qianchang Zhao <pioooooooooip@gmail.com>,
	Zhitong Liu <liuzhitong1993@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0900/1887] ksmbd: vfs: fix race on m_flags in vfs_cache
Date: Wed, 28 Oct 2026 17:49:56 +0100
Message-ID: <20261028170519.898856883@linuxfoundation.org>
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

From: Qianchang Zhao <pioooooooooip@gmail.com>

[ Upstream commit 991f8a79db99b14c48d20d2052c82d65b9186cad ]

ksmbd maintains delete-on-close and pending-delete state in
ksmbd_inode->m_flags. In vfs_cache.c this field is accessed under
inconsistent locking: some paths read and modify m_flags under
ci->m_lock while others do so without taking the lock at all.

Examples:

 - ksmbd_query_inode_status() and __ksmbd_inode_close() use
   ci->m_lock when checking or updating m_flags.
 - ksmbd_inode_pending_delete(), ksmbd_set_inode_pending_delete(),
   ksmbd_clear_inode_pending_delete() and ksmbd_fd_set_delete_on_close()
   used to read and modify m_flags without ci->m_lock.

This creates a potential data race on m_flags when multiple threads
open, close and delete the same file concurrently. In the worst case
delete-on-close and pending-delete bits can be lost or observed in an
inconsistent state, leading to confusing delete semantics (files that
stay on disk after delete-on-close, or files that disappear while still
in use).

Fix it by:

 - Making ksmbd_query_inode_status() look at m_flags under ci->m_lock
   after dropping inode_hash_lock.
 - Adding ci->m_lock protection to all helpers that read or modify
   m_flags (ksmbd_inode_pending_delete(), ksmbd_set_inode_pending_delete(),
   ksmbd_clear_inode_pending_delete(), ksmbd_fd_set_delete_on_close()).
 - Keeping the existing ci->m_lock protection in __ksmbd_inode_close(),
   and moving the actual unlink/xattr removal outside the lock.

This unifies the locking around m_flags and removes the data race while
preserving the existing delete-on-close behaviour.

Reported-by: Qianchang Zhao <pioooooooooip@gmail.com>
Reported-by: Zhitong Liu <liuzhitong1993@gmail.com>
Signed-off-by: Qianchang Zhao <pioooooooooip@gmail.com>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/vfs_cache.c | 86 +++++++++++++++++++++++++++------------
 1 file changed, 61 insertions(+), 25 deletions(-)

diff --git a/fs/smb/server/vfs_cache.c b/fs/smb/server/vfs_cache.c
index 4b35e4f960694..d10cd67d6793c 100644
--- a/fs/smb/server/vfs_cache.c
+++ b/fs/smb/server/vfs_cache.c
@@ -104,40 +104,62 @@ int ksmbd_query_inode_status(struct dentry *dentry)
 
 	read_lock(&inode_hash_lock);
 	ci = __ksmbd_inode_lookup(dentry);
-	if (ci) {
-		ret = KSMBD_INODE_STATUS_OK;
-		if (ci->m_flags & (S_DEL_PENDING | S_DEL_ON_CLS))
-			ret = KSMBD_INODE_STATUS_PENDING_DELETE;
-		atomic_dec(&ci->m_count);
-	}
 	read_unlock(&inode_hash_lock);
+	if (!ci)
+		return ret;
+
+	read_lock(&ci->m_lock);
+	if (ci->m_flags & (S_DEL_PENDING | S_DEL_ON_CLS))
+		ret = KSMBD_INODE_STATUS_PENDING_DELETE;
+	else
+		ret = KSMBD_INODE_STATUS_OK;
+	read_unlock(&ci->m_lock);
+
+	atomic_dec(&ci->m_count);
 	return ret;
 }
 
 bool ksmbd_inode_pending_delete(struct ksmbd_file *fp)
 {
-	return (fp->f_ci->m_flags & (S_DEL_PENDING | S_DEL_ON_CLS));
+	struct ksmbd_inode *ci = fp->f_ci;
+	int ret;
+
+	read_lock(&ci->m_lock);
+	ret = (ci->m_flags & (S_DEL_PENDING | S_DEL_ON_CLS));
+	read_unlock(&ci->m_lock);
+
+	return ret;
 }
 
 void ksmbd_set_inode_pending_delete(struct ksmbd_file *fp)
 {
-	fp->f_ci->m_flags |= S_DEL_PENDING;
+	struct ksmbd_inode *ci = fp->f_ci;
+
+	write_lock(&ci->m_lock);
+	ci->m_flags |= S_DEL_PENDING;
+	write_unlock(&ci->m_lock);
 }
 
 void ksmbd_clear_inode_pending_delete(struct ksmbd_file *fp)
 {
-	fp->f_ci->m_flags &= ~S_DEL_PENDING;
+	struct ksmbd_inode *ci = fp->f_ci;
+
+	write_lock(&ci->m_lock);
+	ci->m_flags &= ~S_DEL_PENDING;
+	write_unlock(&ci->m_lock);
 }
 
 void ksmbd_fd_set_delete_on_close(struct ksmbd_file *fp,
 				  int file_info)
 {
-	if (ksmbd_stream_fd(fp)) {
-		fp->f_ci->m_flags |= S_DEL_ON_CLS_STREAM;
-		return;
-	}
+	struct ksmbd_inode *ci = fp->f_ci;
 
-	fp->f_ci->m_flags |= S_DEL_ON_CLS;
+	write_lock(&ci->m_lock);
+	if (ksmbd_stream_fd(fp))
+		ci->m_flags |= S_DEL_ON_CLS_STREAM;
+	else
+		ci->m_flags |= S_DEL_ON_CLS;
+	write_unlock(&ci->m_lock);
 }
 
 static void ksmbd_inode_hash(struct ksmbd_inode *ci)
@@ -249,26 +271,40 @@ static void __ksmbd_inode_close(struct ksmbd_file *fp)
 	struct file *filp;
 
 	filp = fp->filp;
-	if (ksmbd_stream_fd(fp) && (ci->m_flags & S_DEL_ON_CLS_STREAM)) {
-		ci->m_flags &= ~S_DEL_ON_CLS_STREAM;
-		err = ksmbd_vfs_remove_xattr(file_mnt_user_ns(filp),
-					     &filp->f_path,
-					     fp->stream.name);
-		if (err)
-			pr_err("remove xattr failed : %s\n",
-			       fp->stream.name);
+
+	if (ksmbd_stream_fd(fp)) {
+		bool remove_stream_xattr = false;
+
+		write_lock(&ci->m_lock);
+		if (ci->m_flags & S_DEL_ON_CLS_STREAM) {
+			ci->m_flags &= ~S_DEL_ON_CLS_STREAM;
+			remove_stream_xattr = true;
+		}
+		write_unlock(&ci->m_lock);
+
+		if (remove_stream_xattr) {
+			err = ksmbd_vfs_remove_xattr(file_mnt_user_ns(filp),
+						     &filp->f_path,
+						     fp->stream.name);
+			if (err)
+				pr_err("remove xattr failed : %s\n",
+				       fp->stream.name);
+		}
 	}
 
 	if (atomic_dec_and_test(&ci->m_count)) {
+		bool do_unlink = false;
+
 		write_lock(&ci->m_lock);
 		if (ci->m_flags & (S_DEL_ON_CLS | S_DEL_PENDING)) {
 			ci->m_flags &= ~(S_DEL_ON_CLS | S_DEL_PENDING);
-			write_unlock(&ci->m_lock);
-			ksmbd_vfs_unlink(filp);
-			write_lock(&ci->m_lock);
+			do_unlink = true;
 		}
 		write_unlock(&ci->m_lock);
 
+		if (do_unlink)
+			ksmbd_vfs_unlink(filp);
+
 		ksmbd_inode_free(ci);
 	}
 }
-- 
2.53.0



