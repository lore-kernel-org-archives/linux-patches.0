Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795619054;
	b=z/lUPvS+IqBTomh554ZWn0+y5h6jTnJxeSe16qWonH5Z+6buNYAWirVLA2tt79zFOuZk
	 Ko1TidHek/rzrWzuY4KfCbuTkNDhEQDieeSGLoWl5/4rjplfDS7uIsG3aS+Fa0mH3ra+m
	 D6CnspAc2NJVJ77hDindv/YZWPggaRvA8X3xct5++HuLeNA7P1qF03zMUJHztHfjkUNyV
	 gWw97VW58zYRx9dfTWCFF4eRo6zJxtdltJigeGOtzWYCTHWW0NTGqO5CBosoz69dDHLl+
	 GSnDeqLDlPSY3vVf/DiwyOBKJ2YFrQdj/s8IyRk56H/9jaPMBNNzsef9+afBB6CfquQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795619054;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=SeozmJAaA0fyG7J5cWVcsqw6sZ9kv32DXujQy6RnFn4=;
	b=et94IHtPndijZl92oE9rdBTtEXfaVuTK+0GeJvItRr7GOJfCaGHPK1L6YEt2acn8GwcW
	 phxLw8s/bzNZFJkcI7do/N5rrNuXzz2ErgXzwIYTv9kB8CH9dsK9Ll2cLd5Ics7Ca6NfE
	 CObfTSB3GXVmXIjiGIIdoYXtzPt+rMMgW0suX514daE9xAVYYwy2utpESU4OMOwhcTec3
	 U4ODZP29xdRRcDU9RBgGI4ySSEa9xB6u+b6eYyQpBEj67rJ/RfnbTXyvtvP8E9osjsr8p
	 95bDIct1k9hOFt85Ox3vAlrfFj5ATzVmfJaPy9u6cqh8LxM+U8GoGOfHCzqFvYUYE5A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=f8blvY7o;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 215B1606A31E;
	Wed, 25 Nov 2026 15:04:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=f8blvY7o
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 726231F000C4;
	Wed, 25 Nov 2026 15:04:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795619054;
	bh=SeozmJAaA0fyG7J5cWVcsqw6sZ9kv32DXujQy6RnFn4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=f8blvY7oSLA+xCv1w3Zgshvh4YVv4AmgVvCrUM8dNRhs7TUeYpYBFxQ5SCcVSmIzP
	 uToLFq4oDuxdG3yGbcGER7dmPPkrsEjZpXHkHZ3xuU0PbJRMw3NNBM9lKSIPBmy4pM
	 Lk7sLmyEHAfo1H7/yAD49fLqehRXssf5cms/HKKo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Anna Schumaker <anna.schumaker@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0474/1005] NFS: stamp after the servers ctime when truncating under delegated times
Date: Wed, 25 Nov 2026 15:30:12 +0100
Message-ID: <20261125143832.850667294@linuxfoundation.org>
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

[ Upstream commit f13110f9cfb95a09d286eee561adc96c6a02664f ]

A size-changing SETATTR always has the server stamp c/mtime
(__nfsd_setattr(), per RFC 5661 section 18.30.4). With delegated
timestamps the client discards the reply's ctime and stamps its own in
nfs_vmtruncate(), clamped only against its cached ctime. A coarse client
stamp can still land before the server's, which then won't move ctime
back when the holder returns its times, so ctime changes after
DELEGRETURN.

- Raise the cached ctime to the reply's before nfs_vmtruncate() stamps,
  so the delegated stamp lands after the server's.
- Stamp before nfs_vmtruncate() drops i_lock for truncate_pagecache(),
  not after. A delegation return starting in that window made the stamp
  a no-op, and DELEGRETURN sent the pre-truncate mtime, which the server
  could apply over its own truncate stamp.

Fixes: e12912d94137 ("NFSv4: Add support for delegated atime and mtime attributes")
Signed-off-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Anna Schumaker <anna.schumaker@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/inode.c | 23 ++++++++++++++++++++++-
 1 file changed, 22 insertions(+), 1 deletion(-)

diff --git a/fs/nfs/inode.c b/fs/nfs/inode.c
index c07e56c313903..24ad11d71ec5c 100644
--- a/fs/nfs/inode.c
+++ b/fs/nfs/inode.c
@@ -641,6 +641,21 @@ static struct timespec64 nfs_delegated_stamp(struct inode *inode)
 	return now;
 }
 
+/*
+ * The server stamped c/mtime itself (e.g. for a size change). Raise the
+ * cached ctime to the server's so that the next delegated stamp lands
+ * after it.
+ */
+static void nfs_delegated_ctime_raise(struct inode *inode,
+				      const struct nfs_fattr *fattr)
+{
+	struct timespec64 ctime = inode_get_ctime(inode);
+
+	if ((fattr->valid & NFS_ATTR_FATTR_CTIME) &&
+	    timespec64_compare(&fattr->ctime, &ctime) > 0)
+		inode_set_ctime_to_ts(inode, fattr->ctime);
+}
+
 static void nfs_set_timestamps_to_ts(struct inode *inode, struct iattr *attr)
 {
 	unsigned int cache_flags = 0;
@@ -814,10 +829,14 @@ static int nfs_vmtruncate(struct inode * inode, loff_t offset)
 		nfs_ooo_clear(NFS_I(inode));
 	}
 	NFS_I(inode)->cache_validity &= ~NFS_INO_INVALID_SIZE;
+	/*
+	 * Stamp in the same i_lock section that checked the delegation and
+	 * raised ctime, before a delegation return can start.
+	 */
+	nfs_update_delegated_mtime_locked(inode);
 
 	spin_unlock(&inode->i_lock);
 	truncate_pagecache(inode, offset);
-	nfs_update_delegated_mtime_locked(inode);
 	spin_lock(&inode->i_lock);
 out:
 	return err;
@@ -843,6 +862,8 @@ void nfs_setattr_update_inode(struct inode *inode, struct iattr *attr,
 	if ((attr->ia_valid & ATTR_SIZE) != 0) {
 		if (!nfs_have_delegated_mtime(inode))
 			nfs_set_cache_invalid(inode, NFS_INO_INVALID_MTIME);
+		else
+			nfs_delegated_ctime_raise(inode, fattr);
 		nfs_set_cache_invalid(inode, NFS_INO_INVALID_BLOCKS);
 		nfs_inc_stats(inode, NFSIOS_SETATTRTRUNC);
 		nfs_vmtruncate(inode, attr->ia_size);
-- 
2.53.0



