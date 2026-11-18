Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021066;
	b=qEZkIhV0fQzTk90ArHPrslmvGWGnfO9SDN8CRrgteMDuqYiVLCTdgWoq7ds/E7Yx7UGV
	 tO8FtYTF887cT/pZv7+qmhhEwTGTzOO+0BtCJfixYazijTFqRJHcvAzkrx/wLgsNqvP++
	 Cdj9T7O5dxk6rsRhuo3ni6pj50jU6X7CS5C+9aQL5PchdrEffWozocIu0gqbOvdSkXsaY
	 4pqTa2AQlDUqOrybJCNiW5Z/b/sYqez96fzIguBiAN/VRluXpKIixT2lsRyY4Dfh5a4ji
	 Qtq8ngtyAGwnfU9B8qoVKIBjM2Lsd2fDT8VWtQrIHBzh+zA9lR+BI90Vpjbr3KwSzBw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021066;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/eb8PbwzfBc4qHCkPLH+mp1mbZTJkg/47nFJsCfYAwQ=;
	b=FUvZiX1+7S81afqadbxZUhkdttTDTq+mE+BehM21FYneNB5JpYQo86xG8OLdaJ2yZpH8
	 57LaS4u5QiPRq/TyBisBxAu7/Q7NGR9pXX5UNvokX2lQGIo2pfnMtAdZBq+dwgjHJ+1wd
	 XeVXCFzAcRREjtojfxnuhRBDWKIUiO1zq22Bez8aFxsuqPQFt66e22N108hvr7cQXFFWv
	 meM+LB+qbP2YrYK20NzCN1y2DdlmZSZFM2yGDylk8FSWScMmmU6vZSMPQz0hKZ5IWlLMV
	 gctjJMf2v9DU7GJ3BBaz9Xv0BHOpVXED3aZWS00a7qjsu9uaxsrR4I9FjmJnudoO+5Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Oxsz00kv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D5EA606A32F;
	Wed, 18 Nov 2026 16:57:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Oxsz00kv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64A6E1F000C4;
	Wed, 18 Nov 2026 16:57:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795021065;
	bh=/eb8PbwzfBc4qHCkPLH+mp1mbZTJkg/47nFJsCfYAwQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Oxsz00kvLkrFWKHG0BEL9y9XWMHzcQiqBB7vGozGbhl6Ip/XIoXwfTJb+knwB7win
	 uss6uvXzJyF34b0Dpe5JHo7afLqXa3DfwxAESs4PPcI5NeAaw1d/1EYXa6Uv7V8uKz
	 fXmkRKbSRcM+UFIwIqClJvDTRzIkqN5FA4H7NYVw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tigran Mkrtchyan <tigran.mkrtchyan@desy.de>,
	Anna Schumaker <anna.schumaker@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2174/2651] nfsv4/pnfs: use the MDS authflavor for data server connections
Date: Wed, 18 Nov 2026 15:56:54 +0100
Message-ID: <20261118150404.064007091@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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
index 5a1967f9e319e..ec0b1289864f2 100644
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
index b661f446ea49e..e7b379f4b4d4b 100644
--- a/fs/nfs/nfs4client.c
+++ b/fs/nfs/nfs4client.c
@@ -229,8 +229,12 @@ struct nfs_client *nfs4_alloc_client(const struct nfs_client_initdata *cl_init)
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
@@ -812,6 +816,7 @@ struct nfs_client *nfs4_set_ds_client(struct nfs_server *mds_srv,
 			.cert_serial = TLS_NO_CERT,
 			.privkey_serial = TLS_NO_PRIVKEY,
 		},
+		.authflavor = mds_clp->cl_rpcclient->cl_auth->au_flavor,
 	};
 	char buf[INET6_ADDRSTRLEN + 1];
 
-- 
2.53.0



