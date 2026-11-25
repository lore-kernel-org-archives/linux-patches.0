Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795619057;
	b=jNGXmyF6J5oZbZSQUa44z3Zc8rLFiUHl8OhnUZ+tQ5m0JXheIgSXbbipQ5ckcJDZ8FYE
	 q87reewrECgaPd9EASqP/uyA5Z74rGN5Mzwn/hkRB4XNE72zc5CTjp7I/ro9t6sM4pdb9
	 Iky3L8J0M6RxGHALTQEo4xVLI0sr5Oc2E7hxUzlHyeY8hZaICYRUB/cHYvoCijjKCcGEK
	 zqgyyw7dK0Wp8BK1s4grbiyQJGzjKmA86yV9HHiRLwbeBCcNiSutaHfyaw/myN06Dyp+B
	 GpBp/LmzoD3ZKfrgGVjflG19ml/TBfeJL1GZA19ncrxkIqcJ6h+Lg4D8TL9rRK0j1Cg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795619057;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=MDSgpjka6lrFZRCxg9h8eDNMyDPGkGMkfDz6Pi581T8=;
	b=upGawcUrI8IsbyRJvvcGaRjhlkaPzUhLXk3UgLbDggrRPjAWUwmcEJzZyfDQCn4Mjgw4
	 QNF8nlfoVnBS+y5QKD2pHjHQWwHV2Bp1XTAVjqQOhS3EsxtL8kFeAFb4/DYhVgj3IDNtS
	 +T8tzTOig2Hd+htUxY+i524z19aVHqn10ggVjB9LHXgxtf4r6zTs0JIf3c4ZfMdowoHXQ
	 t7ha/mGPxd18WX1/SwOzUxMuxV6I3jp6ryKQUoMeZQLMWw1A19Xf+pQTzkNUuLiTA5oTl
	 W5QBByGAUn+LW/hxN8Ra6RftjZgffZYAR30zVt4hyN9YQLuxdQV0Vux67IMdTdNSGDg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GK5aTiEo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED3EA606A321;
	Wed, 25 Nov 2026 15:04:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GK5aTiEo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AB491F000C0;
	Wed, 25 Nov 2026 15:04:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795619056;
	bh=MDSgpjka6lrFZRCxg9h8eDNMyDPGkGMkfDz6Pi581T8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GK5aTiEoWYvCRwjglqvk1gVTF4BKFtoifLrKM/hrhKqtAHjodlTMzOAYe3+27Hc30
	 GWczmjANYlobfhYCNYlxcAte322PKqA/bfnbkLAsiRfW1tXu0Z04hsFNU8Mi03p0FO
	 xLqPKJPXgW+7S/SzlVGJir1i/kkxdb7n53xhbyNA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Anna Schumaker <anna.schumaker@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0475/1005] NFS: stamp after the servers ctime following a CLONE
Date: Wed, 25 Nov 2026 15:30:13 +0100
Message-ID: <20261125143832.873662957@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

From: Jeff Layton <jlayton@kernel.org>

[ Upstream commit 23b9cf773211d536147aa53ade68a88d457838ac ]

nfs42_copy_dest_done() stamps the client's own c/mtime when it holds
delegated timestamps. A server that stamps c/mtime on CLONE (as nfsd did
before "nfsd: mark the delegation written on COPY/CLONE instead of
stamping c/mtime", and as btrfs did before "btrfs: honor FMODE_NOCMTIME
when cloning") can end up with a ctime newer than the client's coarse
stamp, which it won't move back when the holder returns its times.

The stamp didn't survive anyway: nfs_post_op_update_inode() then marks
ctime invalid, so nfs_fattr_fixup_delegated() keeps the reply's ctime
and nfs_update_inode() writes it over the stamp. Against a server that
no longer stamps on CLONE, the client's ctime goes back to its old value
until DELEGRETURN.

- Pass the CLONE reply's attributes to nfs42_copy_dest_done() and raise
  the cached ctime to the server's before stamping. COPY returns no
  attributes, so it passes NULL.
- Stamp before dropping i_lock, so a concurrent refresh can't take the
  server's times while ctime and mtime are marked invalid.
- Under delegated timestamps, apply the reply with nfs_refresh_inode(),
  which doesn't mark ctime invalid.

Fixes: 6e7daa3dad29 ("NFSv4.2: fix CLONE/COPY attrs in presence of delegated attributes")
Signed-off-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Anna Schumaker <anna.schumaker@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/delegation.h |  2 ++
 fs/nfs/inode.c      |  6 ++++--
 fs/nfs/nfs42proc.c  | 25 ++++++++++++++++++++-----
 3 files changed, 26 insertions(+), 7 deletions(-)

diff --git a/fs/nfs/delegation.h b/fs/nfs/delegation.h
index fba4699952b81..cd6142939d34d 100644
--- a/fs/nfs/delegation.h
+++ b/fs/nfs/delegation.h
@@ -95,6 +95,8 @@ void nfs4_inode_make_writeable(struct inode *inode);
 void nfs_update_delegated_atime(struct inode *inode);
 void nfs_update_delegated_mtime(struct inode *inode);
 void nfs_update_delegated_mtime_locked(struct inode *inode);
+void nfs_delegated_ctime_raise(struct inode *inode,
+			       const struct nfs_fattr *fattr);
 
 static inline int nfs_have_read_or_write_delegation(struct inode *inode)
 {
diff --git a/fs/nfs/inode.c b/fs/nfs/inode.c
index 24ad11d71ec5c..beffa3a2968c8 100644
--- a/fs/nfs/inode.c
+++ b/fs/nfs/inode.c
@@ -646,8 +646,8 @@ static struct timespec64 nfs_delegated_stamp(struct inode *inode)
  * cached ctime to the server's so that the next delegated stamp lands
  * after it.
  */
-static void nfs_delegated_ctime_raise(struct inode *inode,
-				      const struct nfs_fattr *fattr)
+void nfs_delegated_ctime_raise(struct inode *inode,
+			       const struct nfs_fattr *fattr)
 {
 	struct timespec64 ctime = inode_get_ctime(inode);
 
@@ -655,6 +655,7 @@ static void nfs_delegated_ctime_raise(struct inode *inode,
 	    timespec64_compare(&fattr->ctime, &ctime) > 0)
 		inode_set_ctime_to_ts(inode, fattr->ctime);
 }
+EXPORT_SYMBOL_GPL(nfs_delegated_ctime_raise);
 
 static void nfs_set_timestamps_to_ts(struct inode *inode, struct iattr *attr)
 {
@@ -705,6 +706,7 @@ void nfs_update_delegated_mtime_locked(struct inode *inode)
 	    nfs_have_directory_delegation(inode))
 		nfs_update_mtime(inode);
 }
+EXPORT_SYMBOL_GPL(nfs_update_delegated_mtime_locked);
 
 void nfs_update_delegated_mtime(struct inode *inode)
 {
diff --git a/fs/nfs/nfs42proc.c b/fs/nfs/nfs42proc.c
index ab86246fc364f..09b4a6ecad880 100644
--- a/fs/nfs/nfs42proc.c
+++ b/fs/nfs/nfs42proc.c
@@ -380,6 +380,7 @@ static int process_copy_commit(struct file *dst, loff_t pos_dst,
  * @pos: destination offset
  * @len: copy length
  * @oldsize: length of the file prior to clone/copy
+ * @fattr: destination attributes from the reply, or NULL
  *
  * Punch a hole in the inode page cache, so that the NFS client will
  * know to retrieve new data.
@@ -387,7 +388,7 @@ static int process_copy_commit(struct file *dst, loff_t pos_dst,
  * invalid cached values for change attribute, ctime, mtime and space used.
  */
 static void nfs42_copy_dest_done(struct file *file, loff_t pos, loff_t len,
-				 loff_t oldsize)
+				 loff_t oldsize, const struct nfs_fattr *fattr)
 {
 	struct inode *inode = file_inode(file);
 	struct address_space *mapping = file->f_mapping;
@@ -405,8 +406,12 @@ static void nfs42_copy_dest_done(struct file *file, loff_t pos, loff_t len,
 					     NFS_INO_INVALID_CTIME |
 					     NFS_INO_INVALID_MTIME |
 					     NFS_INO_INVALID_BLOCKS);
+	/* The server may have stamped c/mtime; stamp after it */
+	if (fattr && nfs_have_delegated_mtime(inode))
+		nfs_delegated_ctime_raise(inode, fattr);
+	/* Before a refresh can see the times invalid and take the server's */
+	nfs_update_delegated_mtime_locked(inode);
 	spin_unlock(&inode->i_lock);
-	nfs_update_delegated_mtime(inode);
 }
 
 static ssize_t _nfs42_proc_copy(struct file *src,
@@ -506,7 +511,8 @@ static ssize_t _nfs42_proc_copy(struct file *src,
 			goto out;
 	}
 
-	nfs42_copy_dest_done(dst, pos_dst, res->write_res.count, oldsize_dst);
+	nfs42_copy_dest_done(dst, pos_dst, res->write_res.count, oldsize_dst,
+			     NULL);
 	nfs_invalidate_atime(src_inode);
 	status = res->write_res.count;
 out:
@@ -1311,8 +1317,17 @@ static int _nfs42_proc_clone(struct rpc_message *msg, struct file *src_f,
 		/* a zero-length count means clone to EOF in src */
 		if (count == 0 && res.dst_fattr->valid & NFS_ATTR_FATTR_SIZE)
 			count = nfs_size_to_loff_t(res.dst_fattr->size) - dst_offset;
-		nfs42_copy_dest_done(dst_f, dst_offset, count, oldsize_dst);
-		status = nfs_post_op_update_inode(dst_inode, res.dst_fattr);
+		nfs42_copy_dest_done(dst_f, dst_offset, count, oldsize_dst,
+				     res.dst_fattr);
+		/*
+		 * nfs_post_op_update_inode() would mark ctime invalid, so the
+		 * reply's ctime would overwrite the delegated stamp.
+		 */
+		if (nfs_have_delegated_mtime(dst_inode))
+			status = nfs_refresh_inode(dst_inode, res.dst_fattr);
+		else
+			status = nfs_post_op_update_inode(dst_inode,
+							  res.dst_fattr);
 	}
 
 	kfree(res.dst_fattr);
-- 
2.53.0



