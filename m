Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585989;
	b=EBL2T8Tsn6Ydpd13Wmutz0T9rI13sPV9N+MVvuJ1F/w7SXhkcVtl3F3Oqq+HL+7bBh4W
	 Ldh6x5C6DeOVjWZ0MsjJdnojGITdUKqjbo32b9qHDI4muAnua2iSM7l+Gm9V5/yqJ85V3
	 h7tz2731HR7e4/BN9v6yTQf5eCWcu7Oy5nQRKrTyzCexeXBhthh99KF7LfcB1r1jYFoDh
	 sDx0jjrnLRZupz10Uf2vL1qbk03YCcn1CRAfGsmgSuqfwmSshOXCkA97xvspGvFJeCwQ5
	 XHMuvYikS1NLN1X1guKagkQyBu4tnwtVZVPLqw7QvPyPwLKcEvfoJxN6kP2Vj3d1bXQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585989;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=IZa6wHnUX6PLilMyNGbp6zbhuFmARXaopfxDghSVzfE=;
	b=ECDm8GPube/UKX2DOlZbsYfXU/joCv88PdzOHLgmt5OYJHgotVglY6bZZX7Z1S5qX/Es
	 cPEdbMkAoZkHYP419mdS6W4W2X735klwfI4qxTFFailQRceFlN8+C6zV5AgxzOTUyhekQ
	 WfLx4Q6IuRhfgQa3FWnRj5M2RB+PzKU5yvfKwj8udXFguqWhCpK7LqCgykSArUbkomxEs
	 l6ZNgWlAEm54QmZ4YMIu9Jj7b5agIQpq7/ci1PbQdH4mLGEBEuIBdg71nFC0OFfurEyD7
	 LotiuhDFadRYHXD0kTnkunOHIMWpFB5peozgaHn5vTiFuBikRSOFHCRfnmpnITMg+ew==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nYMBIwlF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BCEA6072336;
	Fri, 13 Nov 2026 16:06:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nYMBIwlF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 365EF1F000C6;
	Fri, 13 Nov 2026 16:06:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585989;
	bh=IZa6wHnUX6PLilMyNGbp6zbhuFmARXaopfxDghSVzfE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nYMBIwlF8w8lHYRn12OGYNKnsrscVQwyb6371MDeTX+cHuvCyj/cO4C+tmWme/PyP
	 xoDktbvxYUL1l0ODB2+MgiQDsXk5rlwHzV5y9104xFmRoYAX4+SplxjeVY3eqriNJI
	 jC1fOg/ER4AQohqFDJqa/ZyCeKnLMrVnjifIM2+8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <cel@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 033/686] NFSD: Replace nfsd_write()s "stable" argument with "iocb_flags"
Date: Fri, 13 Nov 2026 10:42:46 -0500
Message-ID: <20261113153822.106965600@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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

From: Chuck Lever <cel@kernel.org>

[ Upstream commit 7f7dde9a45dfd9b3c9f35cb24aff9e45669071cc ]

The current nfsd_write() API is not NFS version-agnostic, as it
relies on callers to pass an NFSv3 stable_how value to determine
the persistence of the requested WRITE. NFSv2 does not use a
stable-how value on the wire, and NFSv4 has its own stable_how4
(though stable_how and stable_how4 happen to share the same
numeric values).

To remove the dependence on NFSv3-specific XDR values from NFSD's
generic VFS APIs, replace nfsd_write()'s stable argument with an
argument that passes a set of IOCB flags instead of an XDR-defined
value.

The NFSv4 WRITE and COPY paths had been borrowing the NFSv3
stable_how constants for their own on-the-wire stable values,
relying on the numeric coincidence noted above. Convert those
sites to the stable_how4 enumerators so the v4 code expresses
its own protocol's values directly, with no change in behavior.

While here, bound-check the decoded NFSv3 WRITE stable value, as
the NFSv4 WRITE decoder already does, and make the nfsd3_writeargs
stable field unsigned to suit.

The larger benefit is one less NFSv4 dependency on nfs3.h.

Link: https://patch.msgid.link/20260723182043.990391-3-cel@kernel.org
Signed-off-by: Chuck Lever <cel@kernel.org>
Stable-dep-of: ccfc4db5ab74 ("NFSD: map fh_verify() status codes for NFS_ACLv2 replies")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs3proc.c   | 17 ++++++++++++++++-
 fs/nfsd/nfs3xdr.c    |  2 ++
 fs/nfsd/nfs4proc.c   | 18 ++++++++++++++++--
 fs/nfsd/nfs4xdr.c    |  2 +-
 fs/nfsd/nfsproc.c    |  2 +-
 fs/nfsd/vfs.c        | 30 ++++++++++--------------------
 fs/nfsd/vfs.h        |  6 ++++--
 fs/nfsd/xdr3.h       |  2 +-
 include/linux/nfs4.h |  6 ++++++
 9 files changed, 57 insertions(+), 28 deletions(-)

diff --git a/fs/nfsd/nfs3proc.c b/fs/nfsd/nfs3proc.c
index fbf573c317193..b71c869aaea7c 100644
--- a/fs/nfsd/nfs3proc.c
+++ b/fs/nfsd/nfs3proc.c
@@ -48,6 +48,20 @@ static bool nfsd3_time_in_range(const struct iattr *iap)
 	return true;
 }
 
+static int nfsd3_iocb_flags(enum nfs3_stable_how how)
+{
+	switch (how) {
+	case NFS_FILE_SYNC:
+		/* persist data and timestamps */
+		return IOCB_DSYNC | IOCB_SYNC;
+	case NFS_DATA_SYNC:
+		/* persist data only */
+		return IOCB_DSYNC;
+	default:
+		return 0;
+	}
+}
+
 static __be32 nfsd3_map_status(__be32 status)
 {
 	switch (status) {
@@ -260,7 +274,8 @@ nfsd3_proc_write(struct svc_rqst *rqstp)
 	resp->committed = argp->stable;
 	resp->status = nfsd_write(rqstp, &resp->fh, argp->offset,
 				  &argp->payload, &cnt,
-				  resp->committed, resp->verf);
+				  nfsd3_iocb_flags(resp->committed),
+				  resp->verf);
 	resp->count = cnt;
 	resp->status = nfsd3_map_status(resp->status);
 	return rpc_success;
diff --git a/fs/nfsd/nfs3xdr.c b/fs/nfsd/nfs3xdr.c
index ef4971d71ac4b..067ae1c8aaa5a 100644
--- a/fs/nfsd/nfs3xdr.c
+++ b/fs/nfsd/nfs3xdr.c
@@ -556,6 +556,8 @@ nfs3svc_decode_writeargs(struct svc_rqst *rqstp, struct xdr_stream *xdr)
 		return false;
 	if (xdr_stream_decode_u32(xdr, &args->stable) < 0)
 		return false;
+	if (args->stable > NFS_FILE_SYNC)
+		return false;
 
 	/* opaque data */
 	if (xdr_stream_decode_u32(xdr, &args->len) < 0)
diff --git a/fs/nfsd/nfs4proc.c b/fs/nfsd/nfs4proc.c
index 1bf4a84d6a19c..161208b972be2 100644
--- a/fs/nfsd/nfs4proc.c
+++ b/fs/nfsd/nfs4proc.c
@@ -68,6 +68,20 @@ MODULE_PARM_DESC(nfsd4_ssc_umount_timeout,
 
 #define NFSDDBG_FACILITY		NFSDDBG_PROC
 
+static int nfsd4_iocb_flags(enum stable_how4 how)
+{
+	switch (how) {
+	case FILE_SYNC4:
+		/* persist data and timestamps */
+		return IOCB_DSYNC | IOCB_SYNC;
+	case DATA_SYNC4:
+		/* persist data only */
+		return IOCB_DSYNC;
+	default:
+		return 0;
+	}
+}
+
 static u32 nfsd_attrmask[] = {
 	NFSD_WRITEABLE_ATTRS_WORD0,
 	NFSD_WRITEABLE_ATTRS_WORD1,
@@ -1302,7 +1316,7 @@ nfsd4_write(struct svc_rqst *rqstp, struct nfsd4_compound_state *cstate,
 	write->wr_how_written = write->wr_stable_how;
 	status = nfsd_vfs_write(rqstp, &cstate->current_fh, nf,
 				write->wr_offset, &write->wr_payload,
-				&cnt, write->wr_how_written,
+				&cnt, nfsd4_iocb_flags(write->wr_how_written),
 				(__be32 *)write->wr_verifier.data);
 	nfsd_file_put(nf);
 
@@ -1826,7 +1840,7 @@ static void nfsd4_init_copy_res(struct nfsd4_copy *copy, bool sync)
 {
 	copy->cp_res.wr_stable_how =
 		test_bit(NFSD4_COPY_F_COMMITTED, &copy->cp_flags) ?
-			NFS_FILE_SYNC : NFS_UNSTABLE;
+			FILE_SYNC4 : UNSTABLE4;
 	nfsd4_copy_set_sync(copy, sync);
 }
 
diff --git a/fs/nfsd/nfs4xdr.c b/fs/nfsd/nfs4xdr.c
index 2fe4767dca5b5..7b243d9d71733 100644
--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -1458,7 +1458,7 @@ nfsd4_decode_write(struct nfsd4_compoundargs *argp, union nfsd4_op_u *u)
 		return nfserr_bad_xdr;
 	if (xdr_stream_decode_u32(argp->xdr, &write->wr_stable_how) < 0)
 		return nfserr_bad_xdr;
-	if (write->wr_stable_how > NFS_FILE_SYNC)
+	if (write->wr_stable_how > FILE_SYNC4)
 		return nfserr_bad_xdr;
 	if (xdr_stream_decode_u32(argp->xdr, &write->wr_buflen) < 0)
 		return nfserr_bad_xdr;
diff --git a/fs/nfsd/nfsproc.c b/fs/nfsd/nfsproc.c
index c561d7014b49f..aab68a65ad563 100644
--- a/fs/nfsd/nfsproc.c
+++ b/fs/nfsd/nfsproc.c
@@ -280,7 +280,7 @@ nfsd_proc_write(struct svc_rqst *rqstp)
 
 	fh_copy(&resp->fh, &argp->fh);
 	resp->status = nfsd_write(rqstp, &resp->fh, argp->offset,
-				  &argp->payload, &cnt, NFS_DATA_SYNC, NULL);
+				  &argp->payload, &cnt, IOCB_DSYNC, NULL);
 	if (resp->status == nfs_ok)
 		resp->status = fh_getattr(&resp->fh, &resp->stat);
 	else if (resp->status == nfserr_jukebox)
diff --git a/fs/nfsd/vfs.c b/fs/nfsd/vfs.c
index 53b55ee4e00ee..a126da5c3e8e3 100644
--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -1185,7 +1185,7 @@ static int wait_for_concurrent_writes(struct file *file)
  * @offset: Byte offset of start
  * @payload: xdr_buf containing the write payload
  * @cnt: IN: number of bytes to write, OUT: number of bytes actually written
- * @stable: An NFS stable_how value
+ * @iocb_flags: VFS IOCB_* flags expressing the requested write stability
  * @verf: NFS WRITE verifier
  *
  * Upon return, caller must invoke fh_put on @fhp.
@@ -1197,7 +1197,7 @@ __be32
 nfsd_vfs_write(struct svc_rqst *rqstp, struct svc_fh *fhp,
 	       struct nfsd_file *nf, loff_t offset,
 	       const struct xdr_buf *payload, unsigned long *cnt,
-	       int stable, __be32 *verf)
+	       int iocb_flags, __be32 *verf)
 {
 	struct nfsd_net		*nn = net_generic(SVC_NET(rqstp), nfsd_net_id);
 	struct file		*file = nf->nf_file;
@@ -1234,21 +1234,11 @@ nfsd_vfs_write(struct svc_rqst *rqstp, struct svc_fh *fhp,
 	exp = fhp->fh_export;
 
 	if (!EX_ISSYNC(exp))
-		stable = NFS_UNSTABLE;
+		iocb_flags = 0;
 	init_sync_kiocb(&kiocb, file);
 	kiocb.ki_pos = offset;
-	if (likely(!fhp->fh_use_wgather)) {
-		switch (stable) {
-		case NFS_FILE_SYNC:
-			/* persist data and timestamps */
-			kiocb.ki_flags |= IOCB_DSYNC | IOCB_SYNC;
-			break;
-		case NFS_DATA_SYNC:
-			/* persist data only */
-			kiocb.ki_flags |= IOCB_DSYNC;
-			break;
-		}
-	}
+	if (likely(!fhp->fh_use_wgather))
+		kiocb.ki_flags |= iocb_flags;
 
 	nvecs = xdr_buf_to_bvec(rqstp->rq_bvec, rqstp->rq_maxpages, payload);
 	if (nvecs < 0) {
@@ -1284,7 +1274,7 @@ nfsd_vfs_write(struct svc_rqst *rqstp, struct svc_fh *fhp,
 		goto out_nfserr;
 	}
 
-	if (stable && fhp->fh_use_wgather) {
+	if (iocb_flags && fhp->fh_use_wgather) {
 		host_err = wait_for_concurrent_writes(file);
 		if (host_err < 0)
 			commit_reset_write_verifier(nn, rqstp, host_err);
@@ -1375,7 +1365,7 @@ __be32 nfsd_read(struct svc_rqst *rqstp, struct svc_fh *fhp,
  * @offset: Byte offset of start
  * @payload: xdr_buf containing the write payload
  * @cnt: IN: number of bytes to write, OUT: number of bytes actually written
- * @stable: An NFS stable_how value
+ * @iocb_flags: VFS IOCB_* flags expressing the requested write stability
  * @verf: NFS WRITE verifier
  *
  * Upon return, caller must invoke fh_put on @fhp.
@@ -1385,8 +1375,8 @@ __be32 nfsd_read(struct svc_rqst *rqstp, struct svc_fh *fhp,
  */
 __be32
 nfsd_write(struct svc_rqst *rqstp, struct svc_fh *fhp, loff_t offset,
-	   const struct xdr_buf *payload, unsigned long *cnt, int stable,
-	   __be32 *verf)
+	   const struct xdr_buf *payload, unsigned long *cnt,
+	   int iocb_flags, __be32 *verf)
 {
 	struct nfsd_file *nf;
 	__be32 err;
@@ -1398,7 +1388,7 @@ nfsd_write(struct svc_rqst *rqstp, struct svc_fh *fhp, loff_t offset,
 		goto out;
 
 	err = nfsd_vfs_write(rqstp, fhp, nf, offset, payload, cnt,
-			     stable, verf);
+			     iocb_flags, verf);
 	nfsd_file_put(nf);
 out:
 	trace_nfsd_write_done(rqstp, fhp, offset, *cnt);
diff --git a/fs/nfsd/vfs.h b/fs/nfsd/vfs.h
index 1dd3ae3ceb3a8..2f589c4f0248c 100644
--- a/fs/nfsd/vfs.h
+++ b/fs/nfsd/vfs.h
@@ -131,11 +131,13 @@ __be32		nfsd_read(struct svc_rqst *rqstp, struct svc_fh *fhp,
 				u32 *eof);
 __be32		nfsd_write(struct svc_rqst *rqstp, struct svc_fh *fhp,
 				loff_t offset, const struct xdr_buf *payload,
-				unsigned long *cnt, int stable, __be32 *verf);
+				unsigned long *cnt, int iocb_flags,
+				__be32 *verf);
 __be32		nfsd_vfs_write(struct svc_rqst *rqstp, struct svc_fh *fhp,
 				struct nfsd_file *nf, loff_t offset,
 				const struct xdr_buf *payload,
-				unsigned long *cnt, int stable, __be32 *verf);
+				unsigned long *cnt, int iocb_flags,
+				__be32 *verf);
 __be32		nfsd_readlink(struct svc_rqst *, struct svc_fh *,
 				char *, int *);
 __be32		nfsd_symlink(struct svc_rqst *, struct svc_fh *,
diff --git a/fs/nfsd/xdr3.h b/fs/nfsd/xdr3.h
index 522067b7fd755..7b5e3e3bac006 100644
--- a/fs/nfsd/xdr3.h
+++ b/fs/nfsd/xdr3.h
@@ -38,7 +38,7 @@ struct nfsd3_writeargs {
 	svc_fh			fh;
 	__u64			offset;
 	__u32			count;
-	int			stable;
+	__u32			stable;
 	__u32			len;
 	struct xdr_buf		payload;
 };
diff --git a/include/linux/nfs4.h b/include/linux/nfs4.h
index e947af6a3684a..7c5ab7ae7b532 100644
--- a/include/linux/nfs4.h
+++ b/include/linux/nfs4.h
@@ -390,6 +390,12 @@ enum why_no_delegation4 { /* new to v4.1 */
 	WND4_IS_DIR = 8,
 };
 
+enum stable_how4 {
+	UNSTABLE4	= 0,
+	DATA_SYNC4	= 1,
+	FILE_SYNC4	= 2,
+};
+
 enum lock_type4 {
 	NFS4_UNLOCK_LT = 0,
 	NFS4_READ_LT = 1,
-- 
2.53.0



