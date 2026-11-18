Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795027518;
	b=1KQpLkla8CJJCNQUPzZUfw3KFUK/YDi0Xp65Q68fPMuE0mBznbx51m+NuSd+bjVvd8q3
	 K/IYgJQcc5C0WtOmBE2PXGKlHB6+b+kgNQsGt/Ak5sqB8mS7b6gjUAlQYlHLIioTMeQV8
	 bbN6yhiG3SZZSvpOrWsL8MA/YTAASf8Z6zeJMBRYHLRxMh7G9u/jT5y0FvlM1xcW2ujZx
	 ma0gf+QygSsrIWvYEwREw4+IoPK0PO9NzITFRTYpcnSuM+JW6FmI1DFQPnm22ZPlXW51u
	 lWJpMOcoIHTRayIm5X5GTZ3CGLmalflD0HT71edA9HAievLAnJpVRHP4D2Ve29onrFA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795027518;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=56WfsFQAX/gf8vlVwC5FM31uT/rERzx2wkl8fOltNxw=;
	b=fRwTiW/7CsathOf4VUCVEcWaStMlJGWcIy3St3JiZ+RysXXXTIN90ExX/eQCObuy1pLL
	 VDMPJV49oBdKnTIL/dJiRO5uGNoYVKI0s9H+ttyunoHouZ63SQoLVYgrA/p+Zi/SwVC7B
	 9NfeKotYM8wrmFvaXh1bTrVqjmMMYy+E6S2pv2qiIBlPU6jNyRd+snKNJ3Ib9mmh0VheM
	 T4q7VPb2BeJliss11elgA7R605UbaTA2+f2O5rTCKf1LePEmhN/++lsp6U7RphC/7eU6y
	 UcvR0fM5aKC+/ndH6e7NkGe6GBnhw19iDdP3JLC1nc0KdCiYmDNaPtelwckLkvGxsPA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Wd8KdL53;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B35C60A2614;
	Wed, 18 Nov 2026 18:45:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Wd8KdL53
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A92821F000C6;
	Wed, 18 Nov 2026 18:45:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795027518;
	bh=56WfsFQAX/gf8vlVwC5FM31uT/rERzx2wkl8fOltNxw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Wd8KdL53es6XHLsTn2pNSCSV2gJbd1Wf78x4IkMhSfBMzCVNUdeMsutcDQc/EK5+B
	 GzbWSqqXSIcA+bYPAR8jlV+/WqYOXuXYGWOAryyn8FT4Yq4BwLKn8x4fBwMNP24nKf
	 oREoiHffBNm/LMG4O4y2CP4tOFmNTYTkLd9H/6KE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tigran Mkrtchyan <tigran.mkrtchyan@desy.de>,
	Anna Schumaker <anna.schumaker@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1781/2151] nfsv4/pnfs: use the MDS authflavor for data server connections
Date: Wed, 18 Nov 2026 15:58:36 +0100
Message-ID: <20261118150226.703959437@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

From: Tigran Mkrtchyan <tigran.mkrtchyan@desy.de>

[ Upstream commit 4b27670ea25b955b710021151471cb252240b1e0 ]

When a pNFS client connects to an NFSv4.1 data server, the EXCHANGE_ID
is always attempted with RPCSEC_GSS krb5i first, even if the auth flavor
with the MDS is AUTH_SYS. On a host that runs rpc.gssd but has no usable
machine credential, every first contact with a data server therefore
upcalls to rpc.gssd before falling back to AUTH_SYS.

As nfs4_discover_server_trunking is serialized by nfs_clid_init_mutex
such an extra upcall creates a backlog of DS connections when many files
accessed in parallel.

Pass the authflavor of the MDS lease to nfs4_alloc_client() and skip
the krb5i attempt if the MDS already ended up with AUTH_SYS. Nothing
changes for the MDS itself, or for data servers of an MDS whose lease
was established with krb5i.

Fixes: 4edaa308888b ("NFS: Use "krb5i" to establish NFSv4 state whenever possible")
Signed-off-by: Tigran Mkrtchyan <tigran.mkrtchyan@desy.de>
Signed-off-by: Anna Schumaker <anna.schumaker@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/internal.h   | 1 +
 fs/nfs/nfs4client.c | 7 ++++++-
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/fs/nfs/internal.h b/fs/nfs/internal.h
index 3214533b73c2c..b31824b1596cf 100644
--- a/fs/nfs/internal.h
+++ b/fs/nfs/internal.h
@@ -86,6 +86,7 @@ struct nfs_client_initdata {
 	struct xprtsec_parms xprtsec;
 	unsigned long connect_timeout;
 	unsigned long reconnect_timeout;
+	rpc_authflavor_t authflavor;		/* Auth flavor to use for DS connection */
 };
 
 /*
diff --git a/fs/nfs/nfs4client.c b/fs/nfs/nfs4client.c
index c0880a966b334..3f7eac321536a 100644
--- a/fs/nfs/nfs4client.c
+++ b/fs/nfs/nfs4client.c
@@ -240,8 +240,12 @@ struct nfs_client *nfs4_alloc_client(const struct nfs_client_initdata *cl_init)
 	/*
 	 * Set up the connection to the server before we add add to the
 	 * global list.
+	 *
+	 * Prefer krb5i unless the caller already knows AUTH_UNIX is required.
 	 */
-	err = nfs_create_rpc_client(clp, cl_init, RPC_AUTH_GSS_KRB5I);
+	err = -EINVAL;
+	if (cl_init->authflavor != RPC_AUTH_UNIX)
+		err = nfs_create_rpc_client(clp, cl_init, RPC_AUTH_GSS_KRB5I);
 	if (err == -EINVAL)
 		err = nfs_create_rpc_client(clp, cl_init, RPC_AUTH_UNIX);
 	if (err < 0)
@@ -990,6 +994,7 @@ struct nfs_client *nfs4_set_ds_client(struct nfs_server *mds_srv,
 			.cert_serial = TLS_NO_CERT,
 			.privkey_serial = TLS_NO_PRIVKEY,
 		},
+		.authflavor = mds_clp->cl_rpcclient->cl_auth->au_flavor,
 	};
 	char buf[INET6_ADDRSTRLEN + 1];
 
-- 
2.53.0



