Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590816;
	b=JFEA3V8fE5P1BNMNXYSfjdCChe09k+88Bmc5JIuS0g0RLX9Kf6uSDAnB1yJ9buVyw31t
	 JJYVfoAw5SGSb+ljaQ0V+oq16UW5UEAunHjqC4lpVSAampk3uWq+/LLONOJn6oemUxzk+
	 8h2CYRWti779FKQn1RSYSnYGJPvf+CJYOzpEAOWNjWCJe9m78H8OHBJNXKj00+lJ65U1G
	 Djsd2RN2tJVGUfZHBurftqS2D/PzRQbR0+imddrxqC/1fIWLFiwhFebwd57WM0bainaTP
	 N0jjq/m6yXkdifkXfY+Gvz9n8CQP6VyjSHZAitf8XqkFBrxjqqs3Z8rm/8/kHB1KfgQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590816;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=TG1hydabuqGhhlohfz4UNtqW0iizX2fE48qRn7PQ4eo=;
	b=BDWVKuTcUvGRPRVopRGZIGYgNr7NPL/PD29V3+CUsWdLZ4bb26fbpx8tw8rz8DEb0xSf
	 MKIoX4bGQoqnaIBjBmrwt3aFMOr8lbG1u+ePran0GWrz1E9iPbGZBOe0Kf/oSiz0i9kKw
	 6/1sgFsZYmr5U/ob+EWJt+wkq63wl3Wkrmsa1mPWNDkhoIeRx7/fQLSlEDX+lfaMNVf9g
	 ATepYpjNERXmXD0Y50D/bCrMC103TzTImhWTgCHYRAhh7ebKm/jY/iPXpdmXnsH1lUvek
	 PiyXTF4avnb/QqVgucnGnKd96OQXrBx+NKN1UW3GmTxt17MyuomxDATXLWLeaY2bH5w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ksuiW4vP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59346607E049;
	Fri, 13 Nov 2026 17:26:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ksuiW4vP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B65021F000C4;
	Fri, 13 Nov 2026 17:26:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590815;
	bh=TG1hydabuqGhhlohfz4UNtqW0iizX2fE48qRn7PQ4eo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ksuiW4vPx6oz1gUbaTK5+OIBA2ns61R6M7s3x/lPaY9InGeSoxLbGvsNwY0bmZOLG
	 Ew6J4B/JUGKpVP9R+K4vagUOtl1QxcUDFKpVir73GOuCVRphdmbIFWVoG4USPC2eeX
	 dMb8sZvIk5FPRqXt0/2shg245gSiM1UfikpH6k3g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <cel@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 024/670] NFSD: map fh_verify() status codes for NFS_ACLv2 replies
Date: Fri, 13 Nov 2026 10:43:08 -0500
Message-ID: <20261113153812.004800140@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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
[ sashal: Placed nfsacld_map_status() before the NULL handler because the upstream access-map declarations are absent. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs2acl.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/fs/nfsd/nfs2acl.c b/fs/nfsd/nfs2acl.c
index 2998640f259de..cf92e1f8df7d2 100644
--- a/fs/nfsd/nfs2acl.c
+++ b/fs/nfsd/nfs2acl.c
@@ -15,6 +15,20 @@
 
 #define NFSDDBG_FACILITY		NFSDDBG_PROC
 
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
@@ -79,6 +93,7 @@ static __be32 nfsacld_proc_getacl(struct svc_rqst *rqstp)
 
 	/* resp->acl_{access,default} are released in nfssvc_release_getacl. */
 out:
+	resp->status = nfsacld_map_status(resp->status);
 	return rpc_success;
 
 fail:
@@ -137,6 +152,7 @@ static __be32 nfsacld_proc_setacl(struct svc_rqst *rqstp)
 
 out:
 	/* argp->acl_{access,default} are released in nfsaclsvc_release_setacl. */
+	resp->status = nfsacld_map_status(resp->status);
 	return rpc_success;
 
 out_drop_lock:
@@ -163,6 +179,7 @@ static __be32 nfsacld_proc_getattr(struct svc_rqst *rqstp)
 		goto out;
 	resp->status = fh_getattr(&resp->fh, &resp->stat);
 out:
+	resp->status = nfsacld_map_status(resp->status);
 	return rpc_success;
 }
 
@@ -185,6 +202,7 @@ static __be32 nfsacld_proc_access(struct svc_rqst *rqstp)
 		goto out;
 	resp->status = fh_getattr(&resp->fh, &resp->stat);
 out:
+	resp->status = nfsacld_map_status(resp->status);
 	return rpc_success;
 }
 
-- 
2.53.0



