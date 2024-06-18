Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8AD313AA46;
	Tue, 18 Jun 2024 13:16:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718716581; cv=none; b=n91Cl2EHM8HypV0UflL57sA0xQZzLHlKH3AVnO1NMe1sfGXw64rWp+E9Q0DTAIAJN62WgxQolNC48OqjvCzHrj7g9gRaQLXPss/UuGwB4PFjXPfmI+tBxRm18lHbZ94a0nQVVvcz9/4j4VZ23iAIdNZWJzwfrUE7ygnV9EePXOs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718716581; c=relaxed/simple;
	bh=ZDdaNJr5LZj810GTvBMyNnLgts8E0VLlDK199WLYzZg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dQYSwodgqwTe0lkZiJ0dNNLVbI7J0iJZDoIRsu/vZVJNu5Ufoh6ga4rX+NfNliQe/hYhtEggMIiuFLt0uOtrCdvqOScjCREEaEjypRJLuSJy5rQN9bHHlJSw65fUMGiiFHYU1BCZdYSYw51Wi3Y/qWXMqLNc/83G+J2CGGxRrQY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dOw76+NB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dOw76+NB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48E90C3277B;
	Tue, 18 Jun 2024 13:16:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718716581;
	bh=ZDdaNJr5LZj810GTvBMyNnLgts8E0VLlDK199WLYzZg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dOw76+NBQNvHKegU6xsOJXtolL2+2zS1g3oXhhjBGq09CYGeObGb67X+a8F/aZV6Q
	 Fl1ibdYeDvJY5a9SM4CZx+VioxIxxsjroepvI9Q/DN+uQVb32BSQ2DbnWtgbt9vxc8
	 SC1eQ4TWugh/8iUt5YZv155jvtHS1G4oLfig7AL0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Jeff Layton <jlayton@kernel.org>,
	NeilBrown <neilb@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 694/770] NFSD: Clean up nfs4_preprocess_stateid_op() call sites
Date: Tue, 18 Jun 2024 14:39:07 +0200
Message-ID: <20240618123434.064798104@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240618123407.280171066@linuxfoundation.org>
References: <20240618123407.280171066@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4proc.c | 31 +++++++------------------------
 1 file changed, 7 insertions(+), 24 deletions(-)

diff --git a/fs/nfsd/nfs4proc.c b/fs/nfsd/nfs4proc.c
index 3fe1966ed7358..32fccca7de185 100644
--- a/fs/nfsd/nfs4proc.c
+++ b/fs/nfsd/nfs4proc.c
@@ -943,12 +943,7 @@ nfsd4_read(struct svc_rqst *rqstp, struct nfsd4_compound_state *cstate,
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
@@ -1117,10 +1112,8 @@ nfsd4_setattr(struct svc_rqst *rqstp, struct nfsd4_compound_state *cstate,
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
@@ -1168,10 +1161,8 @@ nfsd4_write(struct svc_rqst *rqstp, struct nfsd4_compound_state *cstate,
 			       write->wr_offset, cnt);
 	status = nfs4_preprocess_stateid_op(rqstp, cstate, &cstate->current_fh,
 						stateid, WR_STATE, &nf, NULL);
-	if (status) {
-		dprintk("NFSD: nfsd4_write: couldn't process stateid!\n");
+	if (status)
 		return status;
-	}
 
 	write->wr_how_written = write->wr_stable_how;
 
@@ -1202,17 +1193,13 @@ nfsd4_verify_copy(struct svc_rqst *rqstp, struct nfsd4_compound_state *cstate,
 
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
@@ -1949,10 +1936,8 @@ nfsd4_fallocate(struct svc_rqst *rqstp, struct nfsd4_compound_state *cstate,
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
@@ -2008,10 +1993,8 @@ nfsd4_seek(struct svc_rqst *rqstp, struct nfsd4_compound_state *cstate,
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
-- 
2.43.0



