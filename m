Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585346;
	b=ILT0W2PmDt9DNnD5cNHAGwaU44KszpvEviG/5KEfwSM8SY4LIhAQPo8JfrvqvT1oelSZ
	 m5eefU0UzonDMcXk7ij6/1gmIsJbBZOpSz+W3ncAmLakaASpC7VxSk7gwbBGfEKbERGeN
	 gpTfBqqD1Ouyt2yXR0wJPq86Cociqi/l5OCuS4VWUc5SGfG6Nv3tXSncrtBan/FoiKRXD
	 fJo1OtK1NvlQowo4g7W77y1xgbqL3FcC9jKVbBwCnylfDjf1zdCwu3SXL+jNX19upW2Ao
	 EuWHh8DxksPRPaVd7sKxz5gtY18NWM1uCvTFawSAiQqpTUmcjdmgYEShVuY3MGRZ9FA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585346;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=aVeUZnGMHLgsqUtAlbx9WUEa6t96T2JMv4LX+2/UOKM=;
	b=zFy21/lB0iRvOfx4W440FaMCPX2s66DJPK8/uoBnZe7AMPYOHS5W732VPFsflerK3Ceh
	 7Aq4+FaJLiyvHMbCxM1siYEyiw5d+1amelrqhyLdVaTN5A4xUAqi0XI3b4Is6n++X6yZ8
	 HmKuXvTlA9xV0rzvGFsQb2TS7/47GRR407FjqhDGU3oQt2msulNvf1+WYlARZj+6FlndX
	 FbxvHBokkE94AiMRRXfBjWWKwcpI6H+UTiVRv41utnWcm3g0cE8ePsiWf8jMCK9ulDgSM
	 +XxQPoalMTzkRNT96Ntacq/GexyTkKcpHUJd8zvf0qr8A5hjCY6E6PE7/RrT8RBwQ1Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SNPdVfpf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 683E3606A89B;
	Fri, 13 Nov 2026 15:55:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SNPdVfpf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB4761F000D2;
	Fri, 13 Nov 2026 15:55:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585346;
	bh=aVeUZnGMHLgsqUtAlbx9WUEa6t96T2JMv4LX+2/UOKM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SNPdVfpfaHFqXlXnVn7mbPgi2JYM8WB7uPSlzpn7RrbYQzeGghmBTjiXjqK2UiCXx
	 3Mzs7gsG4cOlKLzUzUDjfJWncEcNFmKc09u4jz8dYpXABh/rqd37gh+YUkWBlnwS4S
	 rRIoCk/EvX/MV4bBQOsxNyV8/fUQLmisWOiXzusE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <cel@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 011/507] NFSD: Move version-specific ACCESS maps into per-version code
Date: Fri, 13 Nov 2026 10:45:15 -0500
Message-ID: <20261113153753.768005916@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
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
index 190f5a0019009..f978aa2be36aa 100644
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
index 7d8ddb7bfab0c..b3c6341907018 100644
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
index 9ee02a6d00868..f19d8ed80a9dd 100644
--- a/fs/nfsd/nfs4proc.c
+++ b/fs/nfsd/nfs4proc.c
@@ -69,6 +69,43 @@ MODULE_PARM_DESC(nfsd4_ssc_umount_timeout,
 
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
@@ -809,10 +846,9 @@ nfsd4_access(struct svc_rqst *rqstp, struct nfsd4_compound_state *cstate,
 
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
index fe27f6b404268..792c0b327755f 100644
--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -773,64 +773,21 @@ __be32 nfsd4_vfs_fallocate(struct svc_rqst *rqstp, struct svc_fh *fhp,
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
@@ -844,12 +801,11 @@ nfsd_access(struct svc_rqst *rqstp, struct svc_fh *fhp, u32 *access, u32 *suppor
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
@@ -859,7 +815,7 @@ nfsd_access(struct svc_rqst *rqstp, struct svc_fh *fhp, u32 *access, u32 *suppor
 			sresult |= map->access;
 
 			err2 = nfsd_permission(&rqstp->rq_cred, export,
-					       dentry, map->how);
+					       dentry, map->may);
 			switch (err2) {
 			case nfs_ok:
 				result |= map->access;
diff --git a/fs/nfsd/vfs.h b/fs/nfsd/vfs.h
index 5937bd78d4291..bdb58422a3fbd 100644
--- a/fs/nfsd/vfs.h
+++ b/fs/nfsd/vfs.h
@@ -37,6 +37,17 @@
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
@@ -100,7 +111,9 @@ __be32		nfsd_create_locked(struct svc_rqst *, struct svc_fh *,
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



