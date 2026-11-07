Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061014;
	b=t2+P/icxcrxjuD7Yb4jWLTAWBMBbxTV9a09SRsIoYG3+p4tpjcePpK7zCkNdYdarf3SJ
	 LwrjZp9zgUetKfbhTUMSXr0H/yjhxKgaJ8zvBUyjHFnQmcAvwrePs49eUsG6r+BfRPr0W
	 IuLIjndWcnyevi4TsPglEqvGJBN0nJ0el7wz0ySYWFKWJxoKWLhA0UEWFP3eyrkwr9Asy
	 CTPFQnDK/ga4ZFWSYGZWRfXEcc3Wg2weSmQ2tuvM3+J2ySWWVUPgje5k/me/QrA8WcAdM
	 eJsHQEsG5yCq8a4FYMW/VVyda/qVXwhPYzyNLjRkLhLqa4C6tss0ZCjUOAH8CxKkBFQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061014;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rT7RXQFHJWBYdAudgObgoURTzci2CZOPRXiN3R+L/PE=;
	b=M2aFG0yqydXkIR09OyLcM1eFoeO560Q0k+EG3rx7Y99x/wyrO6+SvzjqsZe4IXDqAN/7
	 RIVFfxZZuJi8D5ArMcTSpuMDWCO56XxCKKyu9OYURAgYpHrAyf5sDGH4yEH2gWGgXQlea
	 ZPxVQzg6ug7EIi4Db5CWJi0dU2bI7mhf7Ke2SrlTjDToJ/xNCCqUDmbD74q9+Q7hS74R4
	 JMhv3PYmKPdJj2+uJNsjTkkD56YN845G3RffCABAyGqU/vRi3v/TBm+wNg03TSiB4Qd/r
	 GIc0AGTlUSMOCaTDoU8k6Haq19SSa3rop1pgDBXvowlQKAys4ob7ONKydcbicdeCUEQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NJVZlKLt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6548C606D80E;
	Sat,  7 Nov 2026 14:16:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NJVZlKLt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D9241F0089F;
	Sat,  7 Nov 2026 14:16:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061014;
	bh=rT7RXQFHJWBYdAudgObgoURTzci2CZOPRXiN3R+L/PE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NJVZlKLtZ0BSZTmmDxx5CLMVHNfd5Kv5wPmrdsRJJHdUDk4I4x69XsOFzbz3/M8Dk
	 TZ2ZIGlIFBpESBOfgq624mgDOPXPnQ+vs9Alg2EdU5T6A8KNAoM1bunE9asoSrJMxh
	 Riroq6IPsWCAD4zTQgPcmv5H5eGwMdRQO9rBL98I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Coddington <bcodding@hammerspace.com>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0356/1536] pNFS: honor clora_changed when recalling a layout
Date: Sat,  7 Nov 2026 08:39:32 -0500
Message-ID: <20261107135007.661864531@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Benjamin Coddington <ben.coddington@hammerspace.com>

[ Upstream commit aceaa5991bdf744e9c3fa1e5ad73405b1801eaab ]

When the metadata server recalls a layout with clora_changed FALSE, the
layout is not changing and the client may complete its modified writes to
the storage devices before returning the layout (RFC 8881, Section
20.3.3).  Only when clora_changed is TRUE -- the server is restriping, or
a storage device has failed -- should the client stop writing to the
storage devices and redirect through the metadata server.

Since commit b739a5bd9d9f ("NFSv4/flexfiles: Cancel I/O if the layout is
recalled or revoked") the client cancels in-flight I/O on every recall,
regardless of clora_changed.  For an unchanged recall this abandons
writes whose data may already have reached the storage device; such a
write can then land after the LAYOUTRETURN, which the server sees as a
write without a layout.

Pass the recall's clora_changed value through
pnfs_mark_matching_lsegs_return() and only cancel in-flight I/O when the
layout is actually changing.  When it is not, the existing deferred
return path waits for the in-flight writes to drain before sending the
LAYOUTRETURN.  Other callers, which are tearing down or returning the
layout for their own reasons, continue to cancel as before.

Signed-off-by: Benjamin Coddington <bcodding@hammerspace.com>
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/callback_proc.c |  3 ++-
 fs/nfs/pnfs.c          | 22 +++++++++++++---------
 fs/nfs/pnfs.h          |  2 +-
 3 files changed, 16 insertions(+), 11 deletions(-)

diff --git a/fs/nfs/callback_proc.c b/fs/nfs/callback_proc.c
index b70ae09aeac15..4e2dfecf2b948 100644
--- a/fs/nfs/callback_proc.c
+++ b/fs/nfs/callback_proc.c
@@ -288,7 +288,8 @@ static u32 initiate_file_draining(struct nfs_client *clp,
 	pnfs_set_layout_stateid(lo, &args->cbl_stateid, NULL, true);
 	switch (pnfs_mark_matching_lsegs_return(lo, &free_me_list,
 				&args->cbl_range,
-				be32_to_cpu(args->cbl_stateid.seqid))) {
+				be32_to_cpu(args->cbl_stateid.seqid),
+				args->cbl_layoutchanged)) {
 	case 0:
 	case -EBUSY:
 		/* There are layout segments that need to be returned */
diff --git a/fs/nfs/pnfs.c b/fs/nfs/pnfs.c
index 41081f393d393..c70d1dbf73b7d 100644
--- a/fs/nfs/pnfs.c
+++ b/fs/nfs/pnfs.c
@@ -434,7 +434,8 @@ bool nfs4_layout_refresh_old_stateid(nfs4_stateid *dst,
 			goto out;
 		}
 		/* Try to update the seqid to the most recent */
-		err = pnfs_mark_matching_lsegs_return(lo, &head, &range, 0);
+		err = pnfs_mark_matching_lsegs_return(lo, &head, &range, 0,
+						      true);
 		if (err != -EBUSY) {
 			dst->seqid = lo->plh_stateid.seqid;
 			*dst_range = range;
@@ -488,7 +489,7 @@ static int pnfs_mark_layout_stateid_return(struct pnfs_layout_hdr *lo,
 		.length = NFS4_MAX_UINT64,
 	};
 
-	return pnfs_mark_matching_lsegs_return(lo, lseg_list, &range, seq);
+	return pnfs_mark_matching_lsegs_return(lo, lseg_list, &range, seq, true);
 }
 
 static int
@@ -526,7 +527,7 @@ pnfs_layout_io_set_failed(struct pnfs_layout_hdr *lo, u32 iomode)
 
 	spin_lock(&inode->i_lock);
 	pnfs_layout_set_fail_bit(lo, pnfs_iomode_to_fail_bit(iomode));
-	pnfs_mark_matching_lsegs_return(lo, &head, &range, 0);
+	pnfs_mark_matching_lsegs_return(lo, &head, &range, 0, true);
 	spin_unlock(&inode->i_lock);
 	pnfs_free_lseg_list(&head);
 	dprintk("%s Setting layout IOMODE_%s fail bit\n", __func__,
@@ -1474,7 +1475,7 @@ _pnfs_return_layout(struct inode *ino)
 	}
 	valid_layout = pnfs_layout_is_valid(lo);
 	pnfs_clear_layoutcommit(ino, &tmp_list);
-	pnfs_mark_matching_lsegs_return(lo, &tmp_list, &range, 0);
+	pnfs_mark_matching_lsegs_return(lo, &tmp_list, &range, 0, true);
 
 
 	/* Don't send a LAYOUTRETURN if list was initially empty */
@@ -2603,7 +2604,7 @@ pnfs_layout_process(struct nfs4_layoutget *lgp)
 			.iomode = IOMODE_ANY,
 			.length = NFS4_MAX_UINT64,
 		};
-		pnfs_mark_matching_lsegs_return(lo, &free_me, &range, 0);
+		pnfs_mark_matching_lsegs_return(lo, &free_me, &range, 0, true);
 		goto out_forget;
 	} else {
 		/* We have a completely new layout */
@@ -2635,6 +2636,7 @@ pnfs_layout_process(struct nfs4_layoutget *lgp)
  * @tmp_list: list header to be used with pnfs_free_lseg_list()
  * @return_range: describe layout segment ranges to be returned
  * @seq: stateid seqid to match
+ * @cancel_io: signal io be cancelled
  *
  * This function is mainly intended for use by layoutrecall. It attempts
  * to free the layout segment immediately, or else to mark it for return
@@ -2649,7 +2651,7 @@ int
 pnfs_mark_matching_lsegs_return(struct pnfs_layout_hdr *lo,
 				struct list_head *tmp_list,
 				const struct pnfs_layout_range *return_range,
-				u32 seq)
+				u32 seq, bool cancel_io)
 {
 	struct pnfs_layout_segment *lseg, *next;
 	struct nfs_server *server = NFS_SERVER(lo->plh_inode);
@@ -2675,7 +2677,8 @@ pnfs_mark_matching_lsegs_return(struct pnfs_layout_hdr *lo,
 				continue;
 			remaining++;
 			set_bit(NFS_LSEG_LAYOUTRETURN, &lseg->pls_flags);
-			pnfs_lseg_cancel_io(server, lseg);
+			if (cancel_io)
+				pnfs_lseg_cancel_io(server, lseg);
 		}
 
 	if (remaining) {
@@ -2710,7 +2713,8 @@ pnfs_mark_layout_for_return(struct inode *inode,
 	 * segments at hand when sending layoutreturn. See pnfs_put_lseg()
 	 * for how it works.
 	 */
-	if (pnfs_mark_matching_lsegs_return(lo, &lo->plh_return_segs, range, 0) != -EBUSY) {
+	if (pnfs_mark_matching_lsegs_return(lo, &lo->plh_return_segs, range, 0,
+					    true) != -EBUSY) {
 		const struct cred *cred;
 		nfs4_stateid stateid;
 		enum pnfs_iomode iomode;
@@ -2825,7 +2829,7 @@ static int pnfs_layout_return_unused_byserver(struct nfs_server *server,
 		pnfs_get_layout_hdr(lo);
 		pnfs_set_plh_return_info(lo, range->iomode, 0);
 		if (pnfs_mark_matching_lsegs_return(lo, &lo->plh_return_segs,
-						    range, 0) != 0 ||
+						    range, 0, true) != 0 ||
 		    !pnfs_prepare_layoutreturn(lo, &stateid, &cred, &iomode)) {
 			spin_unlock(&inode->i_lock);
 			rcu_read_unlock();
diff --git a/fs/nfs/pnfs.h b/fs/nfs/pnfs.h
index 7b3ba2e64e6f3..14d2a91250f24 100644
--- a/fs/nfs/pnfs.h
+++ b/fs/nfs/pnfs.h
@@ -301,7 +301,7 @@ int pnfs_mark_matching_lsegs_invalid(struct pnfs_layout_hdr *lo,
 int pnfs_mark_matching_lsegs_return(struct pnfs_layout_hdr *lo,
 				struct list_head *tmp_list,
 				const struct pnfs_layout_range *recall_range,
-				u32 seq);
+				u32 seq, bool cancel_io);
 int pnfs_mark_layout_stateid_invalid(struct pnfs_layout_hdr *lo,
 		struct list_head *lseg_list);
 bool pnfs_roc(struct inode *ino, struct nfs4_layoutreturn_args *args,
-- 
2.53.0



