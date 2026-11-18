Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795032498;
	b=aG3+SQPSfW1ZyFD6EfxeiwZN8umipOEiEXOU5piaHBSwYzhdxwwCLYUoW483KGM3T0HU
	 aKYsVS6HILMFxzy3P9MNqiwqnycMsXSBMRv65Qea3AR9SLoLS8PWsse6SsxMoriYHaE2X
	 MNPBIZlpFuwsO1y1ETOXqIA/h12g1iJg+NnMnPbSzcHgP5oVgxjmkk3K511nL19q9/aum
	 3PDLsj29WAkX02jok3gd4E2J+4s1+fHwYTkwNm3kRInD/4rKrZMgrUY5yDt3cgMgd803X
	 ulvI49yMJBWSYM0gLywtteHA0zIYXcU1LwtTFECHUn+p1r1zVGXqwu0O3NYUcDABWSA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795032498;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=fQHsMSQduUjmK3ik3bhpJftgymTDy80DUA/WOZK8/7s=;
	b=OcLwoNco+7B4mnhwlZrBLxF2PKShaqiO7N20fPcErCUK/BRYxWVmYVu2DaLOHKbMSHyw
	 jmG03xksu+RZptsHgv+dCJ33ghOt0KqK2aatbitmk+z6+A0NoLOPCgu5KqctnZe4XOrpk
	 uOBi9WbRc9V2xszHIDYlufimkpI2QZKOSWF9dOyTpB1XIN+gnQyCAFFR7Ylp5IZMlbBdH
	 auLgr/uTI8raSNfvxw1E+eHVMNwhWy1xTlpgPnG6kpc7A/NgPLgLRlZHhgn54/BuD8HW+
	 y9B5Fmpz181Mh6ABtokleuPjJRFYAmEnB8PLCsQGjEYDZYMfNQOaUxmiZ5mi1A9Jqtw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="W/LBop9+";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20531606A86D;
	Wed, 18 Nov 2026 20:08:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=W/LBop9+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75BF01F000C4;
	Wed, 18 Nov 2026 20:08:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795032498;
	bh=fQHsMSQduUjmK3ik3bhpJftgymTDy80DUA/WOZK8/7s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=W/LBop9+8DfHNmxc1VSBS+gjnGbq8/HVM5qmeT41Zol0bC3Awsjtn6bqwRbKazkVh
	 JCunGTYtfGZPqlIYZNw4VMYGl/ZzdC7XyFgLDgpEufmqO5BCeLuf1C3dr8SQeylNET
	 dBqFtQujYuagrTDRsYQbjiuPOVSD3rRp8FVnFoE4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tigran Mkrtchyan <tigran.mkrtchyan@desy.de>,
	Anna Schumaker <anna.schumaker@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1416/1756] nfsv4/pnfs: use the MDS authflavor for data server connections
Date: Wed, 18 Nov 2026 15:59:03 +0100
Message-ID: <20261118150105.557393706@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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
index ea0524be7c743..55479eb6c5299 100644
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
index 9311944a47f58..ab0659a808135 100644
--- a/fs/nfs/nfs4client.c
+++ b/fs/nfs/nfs4client.c
@@ -238,8 +238,12 @@ struct nfs_client *nfs4_alloc_client(const struct nfs_client_initdata *cl_init)
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
@@ -999,6 +1003,7 @@ struct nfs_client *nfs4_set_ds_client(struct nfs_server *mds_srv,
 			.cert_serial = TLS_NO_CERT,
 			.privkey_serial = TLS_NO_PRIVKEY,
 		},
+		.authflavor = mds_clp->cl_rpcclient->cl_auth->au_flavor,
 	};
 	char buf[INET6_ADDRSTRLEN + 1];
 
-- 
2.53.0



