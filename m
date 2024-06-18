Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DA24157A59;
	Tue, 18 Jun 2024 13:05:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718715915; cv=none; b=tDfqDZO7OznSeEJEEsA1mEfJWDOmi3/eRR20Ct3uFitMwiXwqNDaVU6ErJeO6h6PxIDp1tV2ouvcvW+Fz+qJIgXlaxnCQ7My60RmPQKzsk8rs1vTi7Iyg5I65sYEbJvnPAs8cz6Z5AlkhYD130bzupBEfJJe7udR8NlXf4sbmfk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718715915; c=relaxed/simple;
	bh=HDSql7oIo14R/jxGLsZtudPAVxnGtPjIyoe+KnQCAhs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZxDHW9HxGYygudbwgt2VUMIXm9c9PeWJydU1p5KAeB/K63G4vJ67ctNKu5oFmQ1AO23rbpzO+5Tyt9i63HVMMbbpGsMF0vP66Nszj1xU4TvGysYo0B42zDPhQzm5NkOsrvBBMr2yJKVsj7o3Jsosyh55Xlod30OVVG2Mz6Y7dHM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qOId2P3l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qOId2P3l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68875C3277B;
	Tue, 18 Jun 2024 13:05:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718715914;
	bh=HDSql7oIo14R/jxGLsZtudPAVxnGtPjIyoe+KnQCAhs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qOId2P3lRDHlGGXyD3N6pOX5qcWPPwidct0vqN8ANEGgIdcyhDQ2OSvgbaK7al2sS
	 SAo+iprDGvlJQA4veZUy77AHqVVjr5d7D1ros84ShW52Kz7QUw7bN5JTuszYS9+CnH
	 Hd0748C8uC5gYN/DeGX71NbeKFcXilGDwFKGynbU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 469/770] NFSD: Deprecate NFS_OFFSET_MAX
Date: Tue, 18 Jun 2024 14:35:22 +0200
Message-ID: <20240618123425.419262284@linuxfoundation.org>
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

[ Upstream commit c306d737691ef84305d4ed0d302c63db2932f0bb ]

NFS_OFFSET_MAX was introduced way back in Linux v2.3.y before there
was a kernel-wide OFFSET_MAX value. As a clean up, replace the last
few uses of it with its generic equivalent, and get rid of it.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs3xdr.c   | 2 +-
 fs/nfsd/nfs4xdr.c   | 2 +-
 include/linux/nfs.h | 8 --------
 3 files changed, 2 insertions(+), 10 deletions(-)

diff --git a/fs/nfsd/nfs3xdr.c b/fs/nfsd/nfs3xdr.c
index 2e47a07029f1d..0293b8d65f10f 100644
--- a/fs/nfsd/nfs3xdr.c
+++ b/fs/nfsd/nfs3xdr.c
@@ -1060,7 +1060,7 @@ svcxdr_encode_entry3_common(struct nfsd3_readdirres *resp, const char *name,
 		return false;
 	/* cookie */
 	resp->cookie_offset = dirlist->len;
-	if (xdr_stream_encode_u64(xdr, NFS_OFFSET_MAX) < 0)
+	if (xdr_stream_encode_u64(xdr, OFFSET_MAX) < 0)
 		return false;
 
 	return true;
diff --git a/fs/nfsd/nfs4xdr.c b/fs/nfsd/nfs4xdr.c
index be0995bb9459a..a7b9c3faf7a79 100644
--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -3495,7 +3495,7 @@ nfsd4_encode_dirent(void *ccdv, const char *name, int namlen,
 	p = xdr_reserve_space(xdr, 3*4 + namlen);
 	if (!p)
 		goto fail;
-	p = xdr_encode_hyper(p, NFS_OFFSET_MAX);    /* offset of next entry */
+	p = xdr_encode_hyper(p, OFFSET_MAX);        /* offset of next entry */
 	p = xdr_encode_array(p, name, namlen);      /* name length & name */
 
 	nfserr = nfsd4_encode_dirent_fattr(xdr, cd, name, namlen);
diff --git a/include/linux/nfs.h b/include/linux/nfs.h
index 0dc7ad38a0da4..b06375e88e589 100644
--- a/include/linux/nfs.h
+++ b/include/linux/nfs.h
@@ -36,14 +36,6 @@ static inline void nfs_copy_fh(struct nfs_fh *target, const struct nfs_fh *sourc
 	memcpy(target->data, source->data, source->size);
 }
 
-
-/*
- * This is really a general kernel constant, but since nothing like
- * this is defined in the kernel headers, I have to do it here.
- */
-#define NFS_OFFSET_MAX		((__s64)((~(__u64)0) >> 1))
-
-
 enum nfs3_stable_how {
 	NFS_UNSTABLE = 0,
 	NFS_DATA_SYNC = 1,
-- 
2.43.0



