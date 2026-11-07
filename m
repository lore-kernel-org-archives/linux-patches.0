Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061727;
	b=D0aMI6hpjPxOpcj8CvitxP8pft0tGB/NlKttlARwLjuRXI8yGIR0IhL71xRKrVG4k0Xh
	 5NUs2xCMIlvaP8IFftjTSyJOaUbjbCIHtlxrsp0gCb9NDrftIJ+LrSI3MNl+mN641yQQP
	 K6MEOJQtEn+NzcoX71JDOk+0K2TmSlpAFfOjmsUdrCFv4FS74pl6aB+jtWBqJ+w0RB+JT
	 bavb0Fb9uFY4UpWuJkt78Qb2y/22IrupuBnzfz47BE2DPAKpZ+SRThZtTFXHZLtecE0ll
	 4joGooCjPeWMRsxXuukoWdP7uopOMiWvtlsvsM4rLQ+pTR/YvfpZ6Apb5Q3MK6PPT3g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061727;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=UDlr7kQOYSAgq8jWldG8eXjRo8q1V9mHUt1agHjvMEo=;
	b=Ohdoz1SjZIkyjrznuD2eJ2ytDD2B9dH6UwONcHg1T5Az4d9CI0Koe0zlFu9QoOgdx0su
	 JsaXsEfcJLlESBtP6O4v2qEo0eEx/fJAVLTbuU4m/xJVCUdi/ap70QZtqUMhXM+0pva9u
	 DAJ89L2mjnPqC36RfKGEW7RZ3xFQo08arQFHjr9kPBbyG1043nViawBtliT701vyI+8Lc
	 TsRmIQ7R8JdFl2dJMOPYOVc/7qfMfZABPGZ6QxP2/uMMIzCSn33NxTuCuSct3aV20yfX8
	 iTwK1uKRrm3GmwoCSWvSYKd9r6K6dO0jsss4Q1YNE1bzSozKKD6b8BvOP9X+W/flxcQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ufr79oFB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6D04606A326;
	Sat,  7 Nov 2026 14:28:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ufr79oFB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 750731F0089F;
	Sat,  7 Nov 2026 14:28:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061726;
	bh=UDlr7kQOYSAgq8jWldG8eXjRo8q1V9mHUt1agHjvMEo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ufr79oFBIEr4xI3Zlbgct7LFUlvYTn3anlLOHTx+ojo998syoF2/WXt2S4iTvpR+D
	 QIQCI+LQAvoWGVo/9blBt3ewqD97jxQAPA0mKtWaOTXYVUSsJNbrl3iOOFXzrMqtX2
	 pXjgpmCEb/ym6+veM0BmFlnQCq+obVTzYl4twNig=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <cel@kernel.org>
Subject: [PATCH 6.12 0770/1536] NFSD: map fh_verify() status codes for NFS_ACLv3 replies
Date: Sat,  7 Nov 2026 08:46:26 -0500
Message-ID: <20261107135019.159663851@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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
 


