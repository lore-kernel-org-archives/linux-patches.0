Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795040905;
	b=jmbuf5vuwntbXn38U0fjaJx325H9x7IfzpQVe2pskZebHcBqMva4RTvYz8d4ZW1nGoGT
	 fqlsv8J0Y4S43jxsIjqE6xwOf1fOSUc8ogX+F49PIp9Z5vDp7Crv6fmBj9nqr+dIQHDE1
	 0fWjthjIt6EFj6AjE0C/vN9K4DQFIQp17emaIbL3YswqP7TYgYGTsctfrYXF3kXO/bKXm
	 eUX46QphVHUWTZMYs0wtfMmV44p4MBRC94elpNXaCpQQDhOrhzaI1WxYNvjTxKVMDyadN
	 2HbCGIRKxSnXM8MIfdwUTTW7wlygtgaysD9+qJVUs6TWXwB0juuLF8KFvZtFEXsBOCA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795040905;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/I8sQkg3mzCzYCtRzOvXHMz0ku8r2MeH46aIxROaNMg=;
	b=AwkdpJdFARKyox9hh83IQTxwkshQ6hj4dEHnQywFo3c5697LoVRASHf2FbTQG5fR7WtY
	 5TisbDmf8CHupuVVEOtTfuKrwI/lEc7TzySf9Yp6tPrGa3ufv+lS8BgOpPeIcTEPrdn9L
	 RPdTWosgjfZMBLks2/DdZSARoBOHyulP5vdZ6He3xWR26Ck6Lic7YVVDGko4nWcc9UxnU
	 Xnzlhktwv63T5YWmS5iF+mNvIPRhjhmgzrrMmZQPwDq3godw5cQazlbxWYuZsjZ8YD1hV
	 Fg0ZLqPG/SI+oN40Atljy9Vn+uhY3QXecuAhREOv0G70fLPL6yl7fAaskQQTox3P8Og==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=F+bt5vmH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FDEF606A325;
	Wed, 18 Nov 2026 22:28:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=F+bt5vmH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B48FE1F000C4;
	Wed, 18 Nov 2026 22:28:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795040905;
	bh=/I8sQkg3mzCzYCtRzOvXHMz0ku8r2MeH46aIxROaNMg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=F+bt5vmHbITt744TTET8CBzqly9Ox9d6kP9o3Nx8y+jWIgXnfEbptvdObHyPhvwLa
	 Oh6GBk7cFYpu7LRHUiidnxvAWuA2lXQzIsZ7wNYeafWieW4fc02D+wVwwrftsTiGxk
	 /3kt1Rz9Njmwtlhrj7843d9h+sHOj79mvCdEpm8E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mike Snitzer <snitzer@kernel.org>,
	Anna Schumaker <anna.schumaker@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2621/3318] pNFS/flexfiles: honor FF_FLAGS_NO_IO_THRU_MDS over the mdsthreshold hint
Date: Wed, 18 Nov 2026 15:54:03 +0100
Message-ID: <20261118150439.741381395@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mike Snitzer <snitzer@kernel.org>

[ Upstream commit 78422f623c1e150e3cdfe62598c6e352a2dcfc5f ]

A flexfiles layout may carry FF_FLAGS_NO_IO_THRU_MDS, which tells the
client that this file's data must not be read or written through the
metadata server.

The RFC 5661 mdsthreshold hint pulls the other way.  When a server returns
one, pnfs_within_mdsthreshold() answers "use MDS I/O" for every I/O below
the threshold, pnfs_update_layout() then hands back no segment, and
ff_layout_pg_init_read() reads through the MDS - the very thing the
layout forbids.  A server that sets both is asking for two incompatible
things; the layout flag is the stronger statement, and the one whose
violation the client cannot recover from.

Record the policy on the inode, where it outlives the layout hdr that
carried it, and consult it before the hint:

 - ff_layout_alloc_lseg() sets NFS_INO_NO_IO_THRU_MDS beside the existing
   sticky hdr-level NFS4_FF_HDR_NO_IO_THRU_MDS bit.

 - pnfs_within_mdsthreshold() returns false at once for such an inode, so
   no I/O is diverted to the MDS on the strength of the hint.

The bit is never cleared for the life of the in-core inode.  Servers are
assumed to be consistent in their no-fallback policy per file, which is
the assumption ff_layout_hdr_no_fallback_to_mds() already makes; a server
that was not would lose the effect of its mdsthreshold hint - a SHOULD -
on an inode that is already in core, and nothing else.

Fixes: 260074cd8413 ("pNFS/flexfiles: Add support for FF_FLAGS_NO_IO_THRU_MDS")
Assisted-by: Claude:claude-opus-5[1m]
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
Signed-off-by: Anna Schumaker <anna.schumaker@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/flexfilelayout/flexfilelayout.c |  5 ++++-
 fs/nfs/internal.h                      | 29 ++++++++++++++++++++++++++
 fs/nfs/pnfs.c                          | 12 ++++++++++-
 3 files changed, 44 insertions(+), 2 deletions(-)

diff --git a/fs/nfs/flexfilelayout/flexfilelayout.c b/fs/nfs/flexfilelayout/flexfilelayout.c
index 254ae2d45ee28..a1fbbba591a9a 100644
--- a/fs/nfs/flexfilelayout/flexfilelayout.c
+++ b/fs/nfs/flexfilelayout/flexfilelayout.c
@@ -539,9 +539,12 @@ ff_layout_alloc_lseg(struct pnfs_layout_hdr *lh,
 	if (!p)
 		goto out_sort_mirrors;
 	fls->flags = be32_to_cpup(p);
-	if (fls->flags & FF_FLAGS_NO_IO_THRU_MDS)
+	if (fls->flags & FF_FLAGS_NO_IO_THRU_MDS) {
 		set_bit(NFS4_FF_HDR_NO_IO_THRU_MDS,
 			&FF_LAYOUT_FROM_HDR(lh)->flags);
+		/* Outlives this layout hdr; see NFS_INO_NO_IO_THRU_MDS */
+		nfs_set_no_io_thru_mds(lh->plh_inode);
+	}
 
 	p = xdr_inline_decode(&stream, 4);
 	if (!p)
diff --git a/fs/nfs/internal.h b/fs/nfs/internal.h
index 2290433451ce9..700e93ebddf9b 100644
--- a/fs/nfs/internal.h
+++ b/fs/nfs/internal.h
@@ -474,6 +474,35 @@ static inline bool nfs_file_io_is_buffered(struct nfs_inode *nfsi)
 	return test_bit(NFS_INO_ODIRECT, &nfsi->flags) == 0;
 }
 
+/*
+ * Module-private nfs_inode->flags bit (not in <linux/nfs_fs.h>, so no
+ * exported layout changes): set, and never cleared for the life of the
+ * in-core inode, once a layout driver has seen the server forbid I/O
+ * through the MDS for this file (flexfiles sets it from
+ * FF_FLAGS_NO_IO_THRU_MDS in ff_layout_alloc_lseg()).  The RFC 5661
+ * mdsthreshold hint must not be acted on for such a file, since the only
+ * thing pnfs_within_mdsthreshold() can ask for is the one thing the
+ * layout forbids.  Servers are assumed to be consistent in their
+ * no-fallback policy per file, the same assumption
+ * ff_layout_hdr_no_fallback_to_mds() already makes; if one were not, the
+ * only effect is that its mdsthreshold hint - a SHOULD - stops being
+ * honored for an inode that is already in core.
+ */
+#define NFS_INO_NO_IO_THRU_MDS	(30)
+
+static inline void nfs_set_no_io_thru_mds(struct inode *inode)
+{
+	struct nfs_inode *nfsi = NFS_I(inode);
+
+	if (!test_bit(NFS_INO_NO_IO_THRU_MDS, &nfsi->flags))
+		set_bit(NFS_INO_NO_IO_THRU_MDS, &nfsi->flags);
+}
+
+static inline bool nfs_no_io_thru_mds(struct inode *inode)
+{
+	return test_bit(NFS_INO_NO_IO_THRU_MDS, &NFS_I(inode)->flags);
+}
+
 /* Must be called with exclusively locked inode->i_rwsem */
 static inline void nfs_file_block_o_direct(struct nfs_inode *nfsi)
 {
diff --git a/fs/nfs/pnfs.c b/fs/nfs/pnfs.c
index 58afe95c4706e..6c322f4804589 100644
--- a/fs/nfs/pnfs.c
+++ b/fs/nfs/pnfs.c
@@ -1870,7 +1870,9 @@ pnfs_find_lseg(struct pnfs_layout_hdr *lo,
  * is set to IOMODE_READ for a READ request, and set to IOMODE_RW for a
  * WRITE request.
  *
- * A return of true means use MDS I/O.
+ * A return of true means use MDS I/O, so for a file whose layout forbids
+ * that (see NFS_INO_NO_IO_THRU_MDS) the hint is not evaluated at all:
+ * there is no answer it could give that this client may act on.
  *
  * From rfc 5661:
  * If a file's size is smaller than the file size threshold, data accesses
@@ -1891,6 +1893,14 @@ static bool pnfs_within_mdsthreshold(struct nfs_open_context *ctx,
 	if (t == NULL)
 		return ret;
 
+	/*
+	 * The server has told a layout driver that this file's I/O may not
+	 * go through the MDS (flexfiles FF_FLAGS_NO_IO_THRU_MDS).  Honor
+	 * that over its own mdsthreshold hint.
+	 */
+	if (nfs_no_io_thru_mds(ino))
+		return ret;
+
 	dprintk("%s bm=0x%x rd_sz=%llu wr_sz=%llu rd_io=%llu wr_io=%llu\n",
 		__func__, t->bm, t->rd_sz, t->wr_sz, t->rd_io_sz, t->wr_io_sz);
 
-- 
2.53.0



