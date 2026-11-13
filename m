Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585360;
	b=ty8YsT+WjG8ym8g6y455NogtictSpPGS6nqSXOmQJ7dAPkCRFyA+32mMCvoom9Ql6Thx
	 5UbFUxFScwXuW4GSTZjMcMx2181ZmAVOwXHtNPvJtEGeHdGM/FGLAPLSE6SOE5BHOo6rv
	 n30NohuWdbJ/u3savLiVFUmX+6gn86BxlAjpk41NvqzV7zuWYQHPJ92WILmxee2wU/1vu
	 9r8wG22Jb5qSGYqC/VTPI76BgtNj6jaKV3itPVfb/B83jMDOPM0V1zB9AyKjC85sceT78
	 gmJ/P5N0skYRitXYHSG6Z5nI87q6mYalXz4TOSZyyb9kjhUuwTqqWNvLcxUpNPQ90cQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585360;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6BT0I1agMmD5yUR9xiRMvwdCZKnneR+l7pxOSJr1sjU=;
	b=pCt2UubWsofgMQHDuoqK0/WjUmh8afXa2ZqTWipj3Vla3IpN3mmyudNMCEyM2+xnPKXM
	 s+RigSaCqGLXtkrYtbW3jLrWVz/VTqXc9jA+jCDhyvKVFXRAPFHE2DcfFX9iR7xuUwMyb
	 x6BfcZ/6ei+pCxv17R01c8wIqNiYmQB/+2RNqwzzd2MBkmwqinaUN8WEQbZqbMdmZoRYm
	 7JaWkBXPB8YpEUN6mxfUtGZuLIp9njN2p23jQGPCLrfOsLHL5Ih67YbZMfc0pRW73r70c
	 qeaoNFpgcuO8w+FihQ9tDj/z4Sl7J1B+EwniXLV33kG18Vus4f+jHLPoT/TY43f6ASQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="Ay/TZ/CV";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 836B660A6F55;
	Fri, 13 Nov 2026 15:56:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ay/TZ/CV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CFBC1F000C6;
	Fri, 13 Nov 2026 15:56:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585360;
	bh=6BT0I1agMmD5yUR9xiRMvwdCZKnneR+l7pxOSJr1sjU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ay/TZ/CVZmWW9EH1v09ILh9fkvymnfKw8J+XN5K4TvpJ2so5QicnlRZe85I0+ecVv
	 HsRi6jvRgVopHkCBHAVzq5QUoY7yyAAR7SR0yhCBZ6+g1KmYpZgSEVwlYveZq4Pz3g
	 j/Sr7czgT72CZGzGa8ojzKAHghaSSInmo7bSL+Xw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <cel@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 012/507] NFSD: map fh_verify() status codes for NFS_ACLv2 replies
Date: Fri, 13 Nov 2026 10:45:16 -0500
Message-ID: <20261113153753.801154552@linuxfoundation.org>
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

[ Upstream commit ccfc4db5ab740175b9958ea0cf5986957bf4e659 ]

The NFS_ACL v2 protocol shares its status code space with NFSv2,
which has no NFSERR_BADHANDLE and no NFSERR_NOFILEHANDLE. An
NFS_ACLv2 GETACL, SETACL, GETATTR, or ACCESS request that carries a
malformed or empty file handle gets a reply with status 10001 or
10020, values the client cannot interpret.

Commit 1459ad57673b ("nfsd: Move error code mapping to per-version
proc code.") removed the version check from fh_verify() that turned
those codes into NFSERR_STALE for any version 2 program. The NFSv2
procedures gained nfsd_map_status() in exchange, but the NFS_ACL v2
procedures did not, so the unmapped status reaches the encoder.

Add the same mapping to the NFS_ACL v2 procedures.

Fixes: 1459ad57673b ("nfsd: Move error code mapping to per-version proc code.")
Cc: stable@vger.kernel.org
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Link: https://patch.msgid.link/20260916004240.141975-1-cel@kernel.org
Signed-off-by: Chuck Lever <cel@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs2acl.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/fs/nfsd/nfs2acl.c b/fs/nfsd/nfs2acl.c
index f978aa2be36aa..113ec827ae061 100644
--- a/fs/nfsd/nfs2acl.c
+++ b/fs/nfsd/nfs2acl.c
@@ -57,6 +57,20 @@ static const struct nfsd_access_maps nfsd2_access_maps = {
 	.other		= nfsd2_otheraccess,
 };
 
+static __be32 nfsacld_map_status(__be32 status)
+{
+	switch (status) {
+	case nfserr_nofilehandle:
+	case nfserr_badhandle:
+		status = nfserr_stale;
+		break;
+	case nfserr_wrongsec:
+		status = nfserr_acces;
+		break;
+	}
+	return status;
+}
+
 /*
  * NULL call.
  */
@@ -121,6 +135,7 @@ static __be32 nfsacld_proc_getacl(struct svc_rqst *rqstp)
 
 	/* resp->acl_{access,default} are released in nfssvc_release_getacl. */
 out:
+	resp->status = nfsacld_map_status(resp->status);
 	return rpc_success;
 
 fail:
@@ -179,6 +194,7 @@ static __be32 nfsacld_proc_setacl(struct svc_rqst *rqstp)
 
 out:
 	/* argp->acl_{access,default} are released in nfsaclsvc_release_setacl. */
+	resp->status = nfsacld_map_status(resp->status);
 	return rpc_success;
 
 out_drop_lock:
@@ -205,6 +221,7 @@ static __be32 nfsacld_proc_getattr(struct svc_rqst *rqstp)
 		goto out;
 	resp->status = fh_getattr(&resp->fh, &resp->stat);
 out:
+	resp->status = nfsacld_map_status(resp->status);
 	return rpc_success;
 }
 
@@ -229,6 +246,7 @@ static __be32 nfsacld_proc_access(struct svc_rqst *rqstp)
 		goto out;
 	resp->status = fh_getattr(&resp->fh, &resp->stat);
 out:
+	resp->status = nfsacld_map_status(resp->status);
 	return rpc_success;
 }
 
-- 
2.53.0



