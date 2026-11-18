Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018879;
	b=g/YdXtSn3r77pQ+PX1F8jAlgCaJ80ZarKJ01gK1PutP1dmjZX8Ne2NgNal3lYe+ufaq6
	 SHzL0IWQMv5THniIvnelJt2RDqoNzW4DiNuwyOUEONihJ5tOndSaaAPjIHSt6j/KaHe/v
	 ukIqQ+p9itK+lBqReKiXbFR+j3v6fSlw44oFxTZydbWCg4i4hmxXaqLB+6gF2dSj6wVEk
	 o0XQ/LyJYGTYF59XvExCSQCYUr8iS8GE4YY2yPYzY7JMhdoMFg5UqzIzHjgKpYig1pBJE
	 wocii5QLAdVj860zqrEEg3Av1xTOiYploOMYIMuG8SJdxymdEbLJAvbad/xrKMA14eg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018879;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=mRTth9rFzSFx+GtRispCdMT/RnKaBDDOrn0gpMi+0b0=;
	b=nuXw6DxpHEidvIbinb7VZUR3HG1Y3CwvdXwMQW0SLX83f2g1GSJ6/ZoHzXzx6dcw8Efw
	 i/4d85ouuRAE9NYfniOyBOxm55yG9TApmpr3Rg9nsPD8MFT00DQdKNtbvpJAj4d4z8kCy
	 rUt1u9OCqKDH/jiUAASiKAioWHGsr+TtlJldgwZ6CRaSb+2/PWCmegLlm6NZNNMzQbgUf
	 qH0cwyJnfzkABu2k5u4Toqxxfjji3lQ1sYDlH3r9lc7FPIWiFZJOLLFvHRgeWLflAz4FJ
	 lrcMUiGmWVwwjVQemDsq4xqJ3joZXJWoEylm3fr12BojJ4v5WWuwhTDOEHlUdStwWwg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iMUJypSl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7304F606A31C;
	Wed, 18 Nov 2026 16:21:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iMUJypSl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5FB71F000C4;
	Wed, 18 Nov 2026 16:21:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018879;
	bh=mRTth9rFzSFx+GtRispCdMT/RnKaBDDOrn0gpMi+0b0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iMUJypSlmwPG+jL+xch2yDWUVN+z5OGgrPubc6DwatzJDjf+wqtQ8g8U3CN6YM/fy
	 vEuqGDn4HtqADi/esPW44E/lAIT+mVsCPy4TM8gUMA9U9W/OHcqy0XbebTYVORluVW
	 +s/hluDRxVjl7UvnJxQO8skF8dB11mB1QunNYQCw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mike Snitzer <snitzer@kernel.org>,
	Anna Schumaker <anna.schumaker@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1356/2651] pNFS/flexfiles: honor FF_FLAGS_NO_IO_THRU_MDS over the mdsthreshold hint
Date: Wed, 18 Nov 2026 15:43:16 +0100
Message-ID: <20261118150336.843250934@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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
index 15980d9dad8ea..bbe2ceec55bdb 100644
--- a/fs/nfs/flexfilelayout/flexfilelayout.c
+++ b/fs/nfs/flexfilelayout/flexfilelayout.c
@@ -636,9 +636,12 @@ ff_layout_alloc_lseg(struct pnfs_layout_hdr *lh,
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
index abc81f5ae5780..18e19fe390719 100644
--- a/fs/nfs/internal.h
+++ b/fs/nfs/internal.h
@@ -545,6 +545,35 @@ static inline bool nfs_file_io_is_buffered(struct nfs_inode *nfsi)
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
index c5d1951d54001..0d51be32b6380 100644
--- a/fs/nfs/pnfs.c
+++ b/fs/nfs/pnfs.c
@@ -2004,7 +2004,9 @@ pnfs_find_lseg(struct pnfs_layout_hdr *lo,
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
@@ -2025,6 +2027,14 @@ static bool pnfs_within_mdsthreshold(struct nfs_open_context *ctx,
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



