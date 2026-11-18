Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795025601;
	b=0784edpqz9MhplXlmIRxjZ3FLLPCmBy9Tbtw9/59ZcFUmHCwQ/MCRwnrtggJAxku1DLK
	 BRcHim6zFKKIqDOMzFF0K2UsIR4LLmOzHPkf3zvU66660KEyyGNTkMt/39cY8WAYytIwa
	 hFKc/U/CzOk4l8ECfc5G6A0CCSwmKSm7IQ8zS7B5PDCap3qPkLlee+lhhVa84VGyzNf9+
	 XOZdeep8N4AfqyhrgwYJjN1H6dKBkw27Pn2uZYJp1kpzqAWeaBxX65jD8b2USWI2w37iH
	 rFSlkn5P5l8ipI6uOcAVscOyKE0NkotY+rvOhNv4Q1XjqcH4MziBxoga2yDLn+IJM4A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795025601;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=uwOSKZmXZAZxsp2pFjnBwsfQkws6/BUy2IB5MnUSHFM=;
	b=sV+ioEZK8UtystXTBrdEouBotbLMqNXbrDERW5EQ7eYDhfspfmibAf1yd0l1nJ6O+GJJ
	 S9lzTF63xCRqYN+rENyD0O2LdR3WIqGG/U6iuRzW+azfBZdzdEnVYqYyuz2d3BJAt5xo7
	 2AxVTdb947wqSLWSGMTpOmI2JAnvGTsVmQCmHhlp50rVeF5QqIlcY+tJqBU/liqTqO1k2
	 bBxHvsqjmPjU7FJ7ZPqDLDlbAq23obWMrDnZ3uqY8J4w1eNbebAytOWRCKchd9VnYLp6F
	 ddj9o9J/gKqXZOyTtD68sO+YM80J6eY4YI6iHrygDDeSVsIJIzQwapbNe7zYTM0s9nA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ImOR63Tt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB548606A320;
	Wed, 18 Nov 2026 18:13:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ImOR63Tt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 372BB1F000C4;
	Wed, 18 Nov 2026 18:13:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795025601;
	bh=uwOSKZmXZAZxsp2pFjnBwsfQkws6/BUy2IB5MnUSHFM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ImOR63TtoJtbFhmpaaFFuk8L7IXPRRJV4K0TVQH94ahd3wT+A2P14MztvxDZXrSaJ
	 XnFwkqyogCjsF16Hk2AxN5kmDuKEmKbkTBY74CoCg8Al/wkL7+lwZh61HvcXV1yhQD
	 IpxITsgGk8yM7fq2f4/ybvsqRIvuog4kAh1BiLyU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mike Snitzer <snitzer@kernel.org>,
	Anna Schumaker <anna.schumaker@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1136/2151] pNFS/flexfiles: honor FF_FLAGS_NO_IO_THRU_MDS over the mdsthreshold hint
Date: Wed, 18 Nov 2026 15:47:51 +0100
Message-ID: <20261118150203.604404545@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 7af81b4cf9a14..b5e1f506b4c75 100644
--- a/fs/nfs/flexfilelayout/flexfilelayout.c
+++ b/fs/nfs/flexfilelayout/flexfilelayout.c
@@ -638,9 +638,12 @@ ff_layout_alloc_lseg(struct pnfs_layout_hdr *lh,
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
index 8d0d238b7f881..0285cc7bf3fd5 100644
--- a/fs/nfs/internal.h
+++ b/fs/nfs/internal.h
@@ -544,6 +544,35 @@ static inline bool nfs_file_io_is_buffered(struct nfs_inode *nfsi)
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
index 7fe272c6a8671..3d2d219a24e47 100644
--- a/fs/nfs/pnfs.c
+++ b/fs/nfs/pnfs.c
@@ -1992,7 +1992,9 @@ pnfs_find_lseg(struct pnfs_layout_hdr *lo,
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
@@ -2013,6 +2015,14 @@ static bool pnfs_within_mdsthreshold(struct nfs_open_context *ctx,
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



