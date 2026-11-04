Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829070;
	b=5nO/7t32IroOjGb26FAxryhE/+GXIU2FNwBgB82FFvgTKd7uqMSqOxujqW16Zj7Ads0F
	 7aV4tQG3jItv6fg/BhyERU6E82XHt0vKJPSDq8qq/twTyg1jr7gpqQ9nY0uVJhqd5TUaq
	 EgKJjePxSZ8aItzitdmOgJasjBNnYW1AZksIA2XN1iDmkmSPIDJUHoqfFyHV3VLcQvgRc
	 fXpu1a88n1YglFfpuxrubwrUooevsm10A7/e68XUhVjl/M5nIb3W2sWfuNhYRQJeqsO03
	 A8q6kgCeXQmRBmZuJa4TNvbrryAomEHGv2VkBSSs3LnTHMlybnixQPcDkuoPC6JQQ2w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829070;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/zkviN4IfINOrYkEuFY6NyXve89PDelXfoYglmu3LwE=;
	b=jH4C3eeY04UNseFzAPL5WgMer3jjJTMgiLzXrzKz/2NJciW7BmX2sDA7r00wjXgdbgeS
	 wVpUrM9rTLfGjxBX7KyDgYN0HRbCp90ljuRnntX+kl4liD3EeU5yxmI+LTNplexmVg/uy
	 dIte6BpQpuCgKtlD0QAKV5vCNaTcaPeUzx8Kc5Pe+2ZmmoUfPOL+hZxtVZdfq7vcth1Zm
	 YlvmwqOvKGMx84QEg5f3yhOZrJi7RF/h3VgmgsxEYF+GS9tzw3ZVTRIB2n4lMh7W+iTkm
	 gtBFcoj6sD0ewoDfd/E1QgGZTvRVjkxgYiPSmE1jvM4MFRKVG6s2mm+rj9HJeBB3xVA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gVGsX1Yc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C5F6607075A;
	Wed,  4 Nov 2026 21:51:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gVGsX1Yc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C09BB1F00A17;
	Wed,  4 Nov 2026 21:51:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829070;
	bh=/zkviN4IfINOrYkEuFY6NyXve89PDelXfoYglmu3LwE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gVGsX1Ycx0BwdjCdkX/wETHBEElQEhgJSef7PfWupkfDYhWi6WfRws+JUxiW6fE21
	 tkf/hxtSYTpb7cu5KpoNAGXFpqFQKEhDaTueA9Ng5FkvjZlqjBfFzhLDP3ztT4uDAy
	 jcC1NsTHfxvpR9NY2LV7VNMtwMehaCPCLYxNv+pk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <cel@kernel.org>
Subject: [PATCH 7.3 424/547] NFSD: map fh_verify() status codes for NFS_ACLv3 replies
Date: Wed,  4 Nov 2026 16:10:08 -0500
Message-ID: <20261104211050.390074368@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
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

commit b1eb9f1aea88a0d7ec8116a70c33b7b31ad0a3eb upstream.

The NFS_ACLv3 protocol shares its status code space with NFSv3,
which has NFS3ERR_BADHANDLE but no NFSERR_NOFILEHANDLE. An
NFS_ACLv3 GETACL or SETACL request that carries an empty file
handle gets a reply with status 10020, a value the client cannot
interpret.

Commit 1459ad57673b ("nfsd: Move error code mapping to per-version
proc code.") made fh_verify() return nfserr_nofilehandle for an
empty handle regardless of protocol version. The NFSv3 procedures
gained nfsd3_map_status() in exchange, but the NFS_ACLv3 procedures
did not, so the unmapped status reaches the encoder.

Add the same mapping to the NFS_ACLv3 procedures.

Fixes: 1459ad57673b ("nfsd: Move error code mapping to per-version proc code.")
Cc: stable@vger.kernel.org
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Link: https://patch.msgid.link/20260916004240.141975-2-cel@kernel.org
Signed-off-by: Chuck Lever <cel@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/nfs3acl.c |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

--- a/fs/nfsd/nfs3acl.c
+++ b/fs/nfsd/nfs3acl.c
@@ -13,6 +13,19 @@
 #include "xdr3.h"
 #include "vfs.h"
 
+static __be32 nfsd3_map_status(__be32 status)
+{
+	switch (status) {
+	case nfserr_nofilehandle:
+		status = nfserr_badhandle;
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
@@ -71,6 +84,7 @@ static __be32 nfsd3_proc_getacl(struct s
 
 	/* resp->acl_{access,default} are released in nfs3svc_release_getacl. */
 out:
+	resp->status = nfsd3_map_status(resp->status);
 	return rpc_success;
 
 fail:
@@ -124,6 +138,7 @@ out_errno:
 	resp->status = nfserrno(error);
 out:
 	/* argp->acl_{access,default} are released in nfs3svc_release_setacl. */
+	resp->status = nfsd3_map_status(resp->status);
 	return rpc_success;
 }
 


