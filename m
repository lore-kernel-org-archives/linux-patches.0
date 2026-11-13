Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585990;
	b=hhzMYeQmA0kZWQLgnZV6lzB8pG1gd4M+3YKTIutVzVoDUqE8oUiux03Dnd+sooQDs/Fr
	 Q2aSSYIYQcBZxWid8wsO/eyJmZclvsCl8spZh/X7YSqW1MxG9cvsPD+rNukJjQJNrvDCO
	 CLXEt0bRFwrW44JmicOoWyCZqpzsV3TSAilq5y6R+mXVk0+OoC33XfCZc+GiK7XRC/9Wl
	 9+v2WtcZyRVlH0KxvG7CdCP03jbAx+8JLwjYGYZH2jzF5WqwvfWzcwUUydCGGZVBB57Y9
	 etnRSK3/C09hyvILMz+j7Cpm/5BEIA+aNfAhTk/1RpQ0iyPyMnmaymEVoNP54bryrgQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585990;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=OWXk8wJaDPu+CLWTFhdyAO0aijmWCrzYNcisQtcQh1I=;
	b=DcZkMtjklZd8KNrO3jnZ4PuLf7kY05yM8mTqEpzPAI77dz2BRZrLCUDEmxWgXrv8HLkN
	 is0yFAkViZemHsiGiiyhX3haJA29U5dLqjkCKyAsFeB2t1TVpVgcvKMtNf71Ids6XpTVe
	 qMdJiO6kk3/ppgwaBG14sHQXwZuX2DggMKoaT7tXTBJLaLNB9+v6FgJ+lqjxjxVCEUALC
	 znCdDVRWKKC34Gl5V4paTEcdb6RWDU0c/gTtXRTGhholHJP7my07aWPV7USMjr2S3zMUU
	 5vfR7v08lRmxrO8LFrmMe1HPX6SeTBsxahyzYA5SmUtG0HFKyTjcUGsRrOJRMs+gXpQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EityH5+E;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6754607233F;
	Fri, 13 Nov 2026 16:06:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EityH5+E
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 718691F000C6;
	Fri, 13 Nov 2026 16:06:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585990;
	bh=OWXk8wJaDPu+CLWTFhdyAO0aijmWCrzYNcisQtcQh1I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EityH5+E6a3UzeshAYCdSJ+HO0XT8R8g5FafMFbRYlh49/mKwSe6ZBW05bLTUtrN8
	 4ZgdOgTftUVUfkEwcl/qVsq6OBcCmTWfst1nk9PZLo8Pc4toEE0vJyHolQbZaLrGXe
	 pOzHVa3LOqxDN+o8zgfL8YDQ2I5AbOHJsOpNbIiA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <cel@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 034/686] NFSD: Move version-specific ACCESS maps into per-version code
Date: Fri, 13 Nov 2026 10:42:47 -0500
Message-ID: <20261113153822.138564669@linuxfoundation.org>
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

[ Upstream commit 3423b5f91d80d3a76424e1c9f1d0f95d4dd80101 ]

nfsd_access() owns three static tables that map on-the-wire ACCESS
bits to NFSD_MAY flags, and every NFS version shares them. That puts
protocol-version specifics in the version-agnostic VFS layer. The
NFSv4.2 extended-attribute bits are wedged into the NFSv3 tables
under CONFIG_NFSD_V4.

Give each version its own tables in its proc code and pass the
matching set into nfsd_access() as a new argument.

Splitting the tables also stops the NFSv2-ACL and NFSv3 ACCESS paths
from answering for the NFSv4.2 extended-attribute bits. Both use the
NFSv4-augmented table whenever CONFIG_NFSD_V4 is set, so an NFSv3
request that sets an xattr bit has it echoed back in the reply even
though those bits are undefined for v3.

Reviewed-by: Jeff Layton <jlayton@kernel.org>
Link: https://patch.msgid.link/20260810141900.33846-2-cel@kernel.org
Signed-off-by: Chuck Lever <cel@kernel.org>
Stable-dep-of: ccfc4db5ab74 ("NFSD: map fh_verify() status codes for NFS_ACLv2 replies")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs2acl.c  | 46 ++++++++++++++++++++++++++-
 fs/nfsd/nfs3proc.c | 41 +++++++++++++++++++++++-
 fs/nfsd/nfs4proc.c | 42 +++++++++++++++++++++++--
 fs/nfsd/vfs.c      | 78 ++++++++++------------------------------------
 fs/nfsd/vfs.h      | 15 ++++++++-
 5 files changed, 155 insertions(+), 67 deletions(-)

diff --git a/fs/nfsd/nfs2acl.c b/fs/nfsd/nfs2acl.c
index 2998640f259de..537097ce8c767 100644
--- a/fs/nfsd/nfs2acl.c
+++ b/fs/nfsd/nfs2acl.c
@@ -15,6 +15,48 @@
 
 #define NFSDDBG_FACILITY		NFSDDBG_PROC
 
+/*
+ * These maps are identical to the NFSv3 maps (nfs3proc.c). This enables
+ * the behavior of the two versions to diverge if needed.
+ */
+static const struct nfsd_access_map nfsd2_regaccess[] = {
+	{ NFS3_ACCESS_READ,	NFSD_MAY_READ				},
+	{ NFS3_ACCESS_EXECUTE,	NFSD_MAY_EXEC				},
+	{ NFS3_ACCESS_MODIFY,	NFSD_MAY_WRITE|NFSD_MAY_TRUNC		},
+	{ NFS3_ACCESS_EXTEND,	NFSD_MAY_WRITE				},
+	{ 0,			0					}
+};
+
+static const struct nfsd_access_map nfsd2_diraccess[] = {
+	{ NFS3_ACCESS_READ,	NFSD_MAY_READ				},
+	{ NFS3_ACCESS_LOOKUP,	NFSD_MAY_EXEC				},
+	{ NFS3_ACCESS_MODIFY,	NFSD_MAY_EXEC|NFSD_MAY_WRITE|NFSD_MAY_TRUNC },
+	{ NFS3_ACCESS_EXTEND,	NFSD_MAY_EXEC|NFSD_MAY_WRITE		},
+	{ NFS3_ACCESS_DELETE,	NFSD_MAY_REMOVE				},
+	{ 0,			0					}
+};
+
+/*
+ * Some clients - Solaris 2.6 at least, make an access call to the NFS
+ * server to check for access for things like /dev/null (which really,
+ * NFSD doesn't care about).  So NFSD provides simple access checking
+ * for those objects, looking mainly at mode bits, ignoring read-only
+ * filesystem checks.
+ */
+static const struct nfsd_access_map nfsd2_otheraccess[] = {
+	{ NFS3_ACCESS_READ,	NFSD_MAY_READ				},
+	{ NFS3_ACCESS_EXECUTE,	NFSD_MAY_EXEC				},
+	{ NFS3_ACCESS_MODIFY,	NFSD_MAY_WRITE|NFSD_MAY_LOCAL_ACCESS	},
+	{ NFS3_ACCESS_EXTEND,	NFSD_MAY_WRITE|NFSD_MAY_LOCAL_ACCESS	},
+	{ 0,			0					}
+};
+
+static const struct nfsd_access_maps nfsd2_access_maps = {
+	.regular	= nfsd2_regaccess,
+	.directory	= nfsd2_diraccess,
+	.other		= nfsd2_otheraccess,
+};
+
 /*
  * NULL call.
  */
@@ -180,7 +222,9 @@ static __be32 nfsacld_proc_access(struct svc_rqst *rqstp)
 
 	fh_copy(&resp->fh, &argp->fh);
 	resp->access = argp->access;
-	resp->status = nfsd_access(rqstp, &resp->fh, &resp->access, NULL);
+
+	resp->status = nfsd_access(rqstp, &resp->fh, &nfsd2_access_maps,
+				   &resp->access, NULL);
 	if (resp->status != nfs_ok)
 		goto out;
 	resp->status = fh_getattr(&resp->fh, &resp->stat);
diff --git a/fs/nfsd/nfs3proc.c b/fs/nfsd/nfs3proc.c
index b71c869aaea7c..87c5e766133c8 100644
--- a/fs/nfsd/nfs3proc.c
+++ b/fs/nfsd/nfs3proc.c
@@ -48,6 +48,44 @@ static bool nfsd3_time_in_range(const struct iattr *iap)
 	return true;
 }
 
+static const struct nfsd_access_map nfsd3_regaccess[] = {
+	{ NFS3_ACCESS_READ,	NFSD_MAY_READ				},
+	{ NFS3_ACCESS_EXECUTE,	NFSD_MAY_EXEC				},
+	{ NFS3_ACCESS_MODIFY,	NFSD_MAY_WRITE|NFSD_MAY_TRUNC		},
+	{ NFS3_ACCESS_EXTEND,	NFSD_MAY_WRITE				},
+	{ 0,			0					}
+};
+
+static const struct nfsd_access_map nfsd3_diraccess[] = {
+	{ NFS3_ACCESS_READ,	NFSD_MAY_READ				},
+	{ NFS3_ACCESS_LOOKUP,	NFSD_MAY_EXEC				},
+	{ NFS3_ACCESS_MODIFY,	NFSD_MAY_EXEC|NFSD_MAY_WRITE|NFSD_MAY_TRUNC },
+	{ NFS3_ACCESS_EXTEND,	NFSD_MAY_EXEC|NFSD_MAY_WRITE		},
+	{ NFS3_ACCESS_DELETE,	NFSD_MAY_REMOVE				},
+	{ 0,			0					}
+};
+
+/*
+ * Some clients - Solaris 2.6 at least, make an access call to the NFS
+ * server to check for access for things like /dev/null (which really,
+ * NFSD doesn't care about).  So NFSD provides simple access checking
+ * for those objects, looking mainly at mode bits, ignoring read-only
+ * filesystem checks.
+ */
+static const struct nfsd_access_map nfsd3_otheraccess[] = {
+	{ NFS3_ACCESS_READ,	NFSD_MAY_READ				},
+	{ NFS3_ACCESS_EXECUTE,	NFSD_MAY_EXEC				},
+	{ NFS3_ACCESS_MODIFY,	NFSD_MAY_WRITE|NFSD_MAY_LOCAL_ACCESS	},
+	{ NFS3_ACCESS_EXTEND,	NFSD_MAY_WRITE|NFSD_MAY_LOCAL_ACCESS	},
+	{ 0,			0					}
+};
+
+static const struct nfsd_access_maps nfsd3_access_maps = {
+	.regular	= nfsd3_regaccess,
+	.directory	= nfsd3_diraccess,
+	.other		= nfsd3_otheraccess,
+};
+
 static int nfsd3_iocb_flags(enum nfs3_stable_how how)
 {
 	switch (how) {
@@ -185,7 +223,8 @@ nfsd3_proc_access(struct svc_rqst *rqstp)
 
 	fh_copy(&resp->fh, &argp->fh);
 	resp->access = argp->access;
-	resp->status = nfsd_access(rqstp, &resp->fh, &resp->access, NULL);
+	resp->status = nfsd_access(rqstp, &resp->fh, &nfsd3_access_maps,
+				   &resp->access, NULL);
 	resp->status = nfsd3_map_status(resp->status);
 	return rpc_success;
 }
diff --git a/fs/nfsd/nfs4proc.c b/fs/nfsd/nfs4proc.c
index 161208b972be2..6c33eebd1a144 100644
--- a/fs/nfsd/nfs4proc.c
+++ b/fs/nfsd/nfs4proc.c
@@ -68,6 +68,43 @@ MODULE_PARM_DESC(nfsd4_ssc_umount_timeout,
 
 #define NFSDDBG_FACILITY		NFSDDBG_PROC
 
+static const struct nfsd_access_map nfsd4_regaccess[] = {
+	{ NFS4_ACCESS_READ,	NFSD_MAY_READ				},
+	{ NFS4_ACCESS_EXECUTE,	NFSD_MAY_EXEC				},
+	{ NFS4_ACCESS_MODIFY,	NFSD_MAY_WRITE|NFSD_MAY_TRUNC		},
+	{ NFS4_ACCESS_EXTEND,	NFSD_MAY_WRITE				},
+	{ NFS4_ACCESS_XAREAD,	NFSD_MAY_READ				},
+	{ NFS4_ACCESS_XAWRITE,	NFSD_MAY_WRITE				},
+	{ NFS4_ACCESS_XALIST,	NFSD_MAY_READ				},
+	{ 0,			0					}
+};
+
+static const struct nfsd_access_map nfsd4_diraccess[] = {
+	{ NFS4_ACCESS_READ,	NFSD_MAY_READ				},
+	{ NFS4_ACCESS_LOOKUP,	NFSD_MAY_EXEC				},
+	{ NFS4_ACCESS_MODIFY,	NFSD_MAY_EXEC|NFSD_MAY_WRITE|NFSD_MAY_TRUNC },
+	{ NFS4_ACCESS_EXTEND,	NFSD_MAY_EXEC|NFSD_MAY_WRITE		},
+	{ NFS4_ACCESS_DELETE,	NFSD_MAY_REMOVE				},
+	{ NFS4_ACCESS_XAREAD,	NFSD_MAY_READ				},
+	{ NFS4_ACCESS_XAWRITE,	NFSD_MAY_WRITE				},
+	{ NFS4_ACCESS_XALIST,	NFSD_MAY_READ				},
+	{ 0,			0					}
+};
+
+static const struct nfsd_access_map nfsd4_otheraccess[] = {
+	{ NFS4_ACCESS_READ,	NFSD_MAY_READ				},
+	{ NFS4_ACCESS_EXECUTE,	NFSD_MAY_EXEC				},
+	{ NFS4_ACCESS_MODIFY,	NFSD_MAY_WRITE|NFSD_MAY_LOCAL_ACCESS	},
+	{ NFS4_ACCESS_EXTEND,	NFSD_MAY_WRITE|NFSD_MAY_LOCAL_ACCESS	},
+	{ 0,			0					}
+};
+
+static const struct nfsd_access_maps nfsd4_access_maps = {
+	.regular	= nfsd4_regaccess,
+	.directory	= nfsd4_diraccess,
+	.other		= nfsd4_otheraccess,
+};
+
 static int nfsd4_iocb_flags(enum stable_how4 how)
 {
 	switch (how) {
@@ -764,10 +801,9 @@ nfsd4_access(struct svc_rqst *rqstp, struct nfsd4_compound_state *cstate,
 
 	if (access->ac_req_access & ~access_full)
 		return nfserr_inval;
-
 	access->ac_resp_access = access->ac_req_access;
-	return nfsd_access(rqstp, &cstate->current_fh, &access->ac_resp_access,
-			   &access->ac_supported);
+	return nfsd_access(rqstp, &cstate->current_fh, &nfsd4_access_maps,
+			   &access->ac_resp_access, &access->ac_supported);
 }
 
 static __be32
diff --git a/fs/nfsd/vfs.c b/fs/nfsd/vfs.c
index a126da5c3e8e3..7094902ca93a8 100644
--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -753,64 +753,21 @@ __be32 nfsd4_vfs_fallocate(struct svc_rqst *rqstp, struct svc_fh *fhp,
 }
 #endif /* defined(CONFIG_NFSD_V4) */
 
-/*
- * Check server access rights to a file system object
+/**
+ * nfsd_access - Check caller's access rights to a file system object
+ * @rqstp: RPC transaction context
+ * @fhp: target NFS filehandle
+ * @maps: tables mapping on-the-wire access bits to NFSD_MAY flags
+ * @access: requested access bits on entry, permitted bits on return
+ * @supported: optional output of the access bits the server supports
+ *
+ * Return: nfs_ok on success, otherwise an nfserr status code
  */
-struct accessmap {
-	u32		access;
-	int		how;
-};
-static struct accessmap	nfs3_regaccess[] = {
-    {	NFS3_ACCESS_READ,	NFSD_MAY_READ			},
-    {	NFS3_ACCESS_EXECUTE,	NFSD_MAY_EXEC			},
-    {	NFS3_ACCESS_MODIFY,	NFSD_MAY_WRITE|NFSD_MAY_TRUNC	},
-    {	NFS3_ACCESS_EXTEND,	NFSD_MAY_WRITE			},
-
-#ifdef CONFIG_NFSD_V4
-    {	NFS4_ACCESS_XAREAD,	NFSD_MAY_READ			},
-    {	NFS4_ACCESS_XAWRITE,	NFSD_MAY_WRITE			},
-    {	NFS4_ACCESS_XALIST,	NFSD_MAY_READ			},
-#endif
-
-    {	0,			0				}
-};
-
-static struct accessmap	nfs3_diraccess[] = {
-    {	NFS3_ACCESS_READ,	NFSD_MAY_READ			},
-    {	NFS3_ACCESS_LOOKUP,	NFSD_MAY_EXEC			},
-    {	NFS3_ACCESS_MODIFY,	NFSD_MAY_EXEC|NFSD_MAY_WRITE|NFSD_MAY_TRUNC},
-    {	NFS3_ACCESS_EXTEND,	NFSD_MAY_EXEC|NFSD_MAY_WRITE	},
-    {	NFS3_ACCESS_DELETE,	NFSD_MAY_REMOVE			},
-
-#ifdef CONFIG_NFSD_V4
-    {	NFS4_ACCESS_XAREAD,	NFSD_MAY_READ			},
-    {	NFS4_ACCESS_XAWRITE,	NFSD_MAY_WRITE			},
-    {	NFS4_ACCESS_XALIST,	NFSD_MAY_READ			},
-#endif
-
-    {	0,			0				}
-};
-
-static struct accessmap	nfs3_anyaccess[] = {
-	/* Some clients - Solaris 2.6 at least, make an access call
-	 * to the server to check for access for things like /dev/null
-	 * (which really, the server doesn't care about).  So
-	 * We provide simple access checking for them, looking
-	 * mainly at mode bits, and we make sure to ignore read-only
-	 * filesystem checks
-	 */
-    {	NFS3_ACCESS_READ,	NFSD_MAY_READ			},
-    {	NFS3_ACCESS_EXECUTE,	NFSD_MAY_EXEC			},
-    {	NFS3_ACCESS_MODIFY,	NFSD_MAY_WRITE|NFSD_MAY_LOCAL_ACCESS	},
-    {	NFS3_ACCESS_EXTEND,	NFSD_MAY_WRITE|NFSD_MAY_LOCAL_ACCESS	},
-
-    {	0,			0				}
-};
-
-__be32
-nfsd_access(struct svc_rqst *rqstp, struct svc_fh *fhp, u32 *access, u32 *supported)
+__be32 nfsd_access(struct svc_rqst *rqstp, struct svc_fh *fhp,
+		   const struct nfsd_access_maps *maps,
+		   u32 *access, u32 *supported)
 {
-	struct accessmap	*map;
+	const struct nfsd_access_map *map;
 	struct svc_export	*export;
 	struct dentry		*dentry;
 	u32			query, result = 0, sresult = 0;
@@ -824,12 +781,11 @@ nfsd_access(struct svc_rqst *rqstp, struct svc_fh *fhp, u32 *access, u32 *suppor
 	dentry = fhp->fh_dentry;
 
 	if (d_is_reg(dentry))
-		map = nfs3_regaccess;
+		map = maps->regular;
 	else if (d_is_dir(dentry))
-		map = nfs3_diraccess;
+		map = maps->directory;
 	else
-		map = nfs3_anyaccess;
-
+		map = maps->other;
 
 	query = *access;
 	for  (; map->access; map++) {
@@ -839,7 +795,7 @@ nfsd_access(struct svc_rqst *rqstp, struct svc_fh *fhp, u32 *access, u32 *suppor
 			sresult |= map->access;
 
 			err2 = nfsd_permission(&rqstp->rq_cred, export,
-					       dentry, map->how);
+					       dentry, map->may);
 			switch (err2) {
 			case nfs_ok:
 				result |= map->access;
diff --git a/fs/nfsd/vfs.h b/fs/nfsd/vfs.h
index 2f589c4f0248c..7f6b90b6272d1 100644
--- a/fs/nfsd/vfs.h
+++ b/fs/nfsd/vfs.h
@@ -38,6 +38,17 @@
 #define NFSD_MAY_CREATE		(NFSD_MAY_EXEC|NFSD_MAY_WRITE)
 #define NFSD_MAY_REMOVE		(NFSD_MAY_EXEC|NFSD_MAY_WRITE|NFSD_MAY_TRUNC)
 
+struct nfsd_access_map {
+	u32		access;
+	int		may;
+};
+
+struct nfsd_access_maps {
+	const struct nfsd_access_map	*regular;
+	const struct nfsd_access_map	*directory;
+	const struct nfsd_access_map	*other;
+};
+
 struct nfsd_file;
 
 /*
@@ -96,7 +107,9 @@ __be32		nfsd_create_locked(struct svc_rqst *, struct svc_fh *,
 __be32		nfsd_create(struct svc_rqst *, struct svc_fh *,
 				char *name, int len, struct nfsd_attrs *attrs,
 				int type, dev_t rdev, struct svc_fh *res);
-__be32		nfsd_access(struct svc_rqst *, struct svc_fh *, u32 *, u32 *);
+__be32		nfsd_access(struct svc_rqst *rqstp, struct svc_fh *fhp,
+				const struct nfsd_access_maps *maps,
+				u32 *access, u32 *supported);
 __be32		nfsd_create_setattr(struct svc_rqst *rqstp, struct svc_fh *fhp,
 				struct svc_fh *resfhp, struct nfsd_attrs *iap);
 __be32		nfsd_commit(struct svc_rqst *rqst, struct svc_fh *fhp,
-- 
2.53.0



