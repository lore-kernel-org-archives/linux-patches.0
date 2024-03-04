Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7911A1EB5A;
	Mon,  4 Mar 2024 21:50:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709589031; cv=none; b=KgKf58vL6AiJ/eYGwpLRg7eMqiNOhciZca+DcSFu/0zIXCEzuXhF1OcO+57cjp52HnU7gWY+yhn9FrfPw6JcFgxFk0nKuHdXwv/DxchGli2c1h+r211vr4iHIAe73E/9OpKCGp1m8JeROqyNwT2Xmo0vFDODO6qhx5o1mIrTFfg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709589031; c=relaxed/simple;
	bh=34P5cIwMxr3yMBrrVLvy7Aw26Y82VyTiVLqWyoDJvRw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NBUFyz9dHWYV7+sob3u3QaVpA4wBPy1kQaC1p3b0ciXU59axfE0Gb4C8p2zwnBXGkS1SI1NMMHclKDY26rNBBm58kc5Y4NYwvsWnaI4FIqxGtgdFcfg1UpB9fUVL8uCWZ6NditrZ8HBeF7LyznvaBvrvWlbK+He2Zbrcalv3pNI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z1fSh4fi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z1fSh4fi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 036D0C433F1;
	Mon,  4 Mar 2024 21:50:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709589031;
	bh=34P5cIwMxr3yMBrrVLvy7Aw26Y82VyTiVLqWyoDJvRw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z1fSh4ficGUcdjUjGuok1iXNky+srkCAxDONkOhNRl2xfpQdMOzrsw+9BPahObz1I
	 WB3Lf9C9tkwdlf/+Wod+0OoFDJDdwRAQs8xkdm0zBvSgZeIWQIZMzIjhH/8h/bwnGZ
	 ceOwCpJjUeJ2IOKuvj82R4t74N1V5yr0K28BV9ak=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Jeff Layton <jlayton@kernel.org>,
	NeilBrown <neilb@suse.de>
Subject: [PATCH 6.1 150/215] NFSD: Clean up nfs4_preprocess_stateid_op() call sites
Date: Mon,  4 Mar 2024 21:23:33 +0000
Message-ID: <20240304211601.782486054@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211556.993132804@linuxfoundation.org>
References: <20240304211556.993132804@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit eeff73f7c1c583f79a401284f46c619294859310 ]

Remove the lame-duck dprintk()s around nfs4_preprocess_stateid_op()
call sites.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Tested-by: Jeff Layton <jlayton@kernel.org>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Reviewed-by: NeilBrown <neilb@suse.de>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/nfs4proc.c |   31 +++++++------------------------
 1 file changed, 7 insertions(+), 24 deletions(-)

--- a/fs/nfsd/nfs4proc.c
+++ b/fs/nfsd/nfs4proc.c
@@ -943,12 +943,7 @@ nfsd4_read(struct svc_rqst *rqstp, struc
 	status = nfs4_preprocess_stateid_op(rqstp, cstate, &cstate->current_fh,
 					&read->rd_stateid, RD_STATE,
 					&read->rd_nf, NULL);
-	if (status) {
-		dprintk("NFSD: nfsd4_read: couldn't process stateid!\n");
-		goto out;
-	}
-	status = nfs_ok;
-out:
+
 	read->rd_rqstp = rqstp;
 	read->rd_fhp = &cstate->current_fh;
 	return status;
@@ -1117,10 +1112,8 @@ nfsd4_setattr(struct svc_rqst *rqstp, st
 		status = nfs4_preprocess_stateid_op(rqstp, cstate,
 				&cstate->current_fh, &setattr->sa_stateid,
 				WR_STATE, NULL, NULL);
-		if (status) {
-			dprintk("NFSD: nfsd4_setattr: couldn't process stateid!\n");
+		if (status)
 			return status;
-		}
 	}
 	err = fh_want_write(&cstate->current_fh);
 	if (err)
@@ -1170,10 +1163,8 @@ nfsd4_write(struct svc_rqst *rqstp, stru
 			       write->wr_offset, cnt);
 	status = nfs4_preprocess_stateid_op(rqstp, cstate, &cstate->current_fh,
 						stateid, WR_STATE, &nf, NULL);
-	if (status) {
-		dprintk("NFSD: nfsd4_write: couldn't process stateid!\n");
+	if (status)
 		return status;
-	}
 
 	write->wr_how_written = write->wr_stable_how;
 
@@ -1204,17 +1195,13 @@ nfsd4_verify_copy(struct svc_rqst *rqstp
 
 	status = nfs4_preprocess_stateid_op(rqstp, cstate, &cstate->save_fh,
 					    src_stateid, RD_STATE, src, NULL);
-	if (status) {
-		dprintk("NFSD: %s: couldn't process src stateid!\n", __func__);
+	if (status)
 		goto out;
-	}
 
 	status = nfs4_preprocess_stateid_op(rqstp, cstate, &cstate->current_fh,
 					    dst_stateid, WR_STATE, dst, NULL);
-	if (status) {
-		dprintk("NFSD: %s: couldn't process dst stateid!\n", __func__);
+	if (status)
 		goto out_put_src;
-	}
 
 	/* fix up for NFS-specific error code */
 	if (!S_ISREG(file_inode((*src)->nf_file)->i_mode) ||
@@ -1935,10 +1922,8 @@ nfsd4_fallocate(struct svc_rqst *rqstp,
 	status = nfs4_preprocess_stateid_op(rqstp, cstate, &cstate->current_fh,
 					    &fallocate->falloc_stateid,
 					    WR_STATE, &nf, NULL);
-	if (status != nfs_ok) {
-		dprintk("NFSD: nfsd4_fallocate: couldn't process stateid!\n");
+	if (status != nfs_ok)
 		return status;
-	}
 
 	status = nfsd4_vfs_fallocate(rqstp, &cstate->current_fh, nf->nf_file,
 				     fallocate->falloc_offset,
@@ -1994,10 +1979,8 @@ nfsd4_seek(struct svc_rqst *rqstp, struc
 	status = nfs4_preprocess_stateid_op(rqstp, cstate, &cstate->current_fh,
 					    &seek->seek_stateid,
 					    RD_STATE, &nf, NULL);
-	if (status) {
-		dprintk("NFSD: nfsd4_seek: couldn't process stateid!\n");
+	if (status)
 		return status;
-	}
 
 	switch (seek->seek_whence) {
 	case NFS4_CONTENT_DATA:


