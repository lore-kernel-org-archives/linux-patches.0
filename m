Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585992;
	b=eYogbLuEBkiJYXI7yi3HenrFthYY/RJzo4BQvVDTdwgiZ63wT2hSB/H0UBemO/fiBzCW
	 jEdtmDbdhFQAgu2WYYmGsFcRJUJtufA3Xnf2E+u0sXAH203RsEq5lQCvXFu4mdupLddww
	 ZnJWTZXk/v1iHKxGNZBU4bQiSvtidevmL9EbBmKug/T5bL2WC9LrUPMgtk+t0EyldI0D4
	 0m5HFKoOqXKyRDTR3GcV61m2Uf5OtLCrsqbgGkaYBMFZf0R3PsIb2RGSUgeIbJ3mvd0tn
	 TXRcADM1W9gG8ygXrsp2cHA3DBT6EV5xV0nAyREAvBw3hNwSM/sKrP7qtMIYDGYB9Yg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585992;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=SKdLdzF/hqIu0zm1XGl7WYyhGtISYqJPqzOTWn8SkHo=;
	b=rTK1+STb8Hi5YGOOxWoezpoBd2uFWBzN3xMLmuCXwg1pFejLnl67XtNVP2+hHyRVSjxy
	 4CRxTVlN22v43iIEdCV6+j/reS148dL0qKbCZlGSUkNIp0deMojZtgsa0++x6f/pTI8Bs
	 HTqUgwfu2vmoWftxMsCbI6YCHh+8M0iJPs/MIFVxXn5+4J63fp3ZeI0qSs3zKsqh+f7vg
	 l0kYbkn5EmN0DysEJtxjN8il/vtO5D0BUChLl6gOUQvZZX1iMHqFx6Hi8ZYAsK+w3Kdh6
	 FZ5UyMrI0VffJjU6v7FSkZwWXj6uCffcfucnilwCDWwvXNGM3j5XRY0y5xjCAzC4yEQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="Ou/x7mWD";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 113976076E2F;
	Fri, 13 Nov 2026 16:06:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ou/x7mWD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B096D1F000C4;
	Fri, 13 Nov 2026 16:06:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585991;
	bh=SKdLdzF/hqIu0zm1XGl7WYyhGtISYqJPqzOTWn8SkHo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ou/x7mWDAklQzU+LZ2ttCEaRzO2qoLCcL2orK+5RmngL0dHyxOYgjNQUkGYl07pH4
	 08z1yEebr4cRJFTcYDRJEvl906kWKRRZZdPTz2iRxCInyBsE4AMcFiJ9BG+mNecj76
	 mzLrOhiH/dm3J0sXfj60QZBJ5vprVWsC55NpwBik=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <cel@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 035/686] NFSD: map fh_verify() status codes for NFS_ACLv2 replies
Date: Fri, 13 Nov 2026 10:42:48 -0500
Message-ID: <20261113153822.168808695@linuxfoundation.org>
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
index 537097ce8c767..87269be93d0f6 100644
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



