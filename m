Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E7F334A325;
	Tue, 26 Aug 2025 14:24:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756218268; cv=none; b=jDQTTLUpow0l2Fn7ehs3dbvwGeMxbV8+UUywDwcKob33eccGf4WBO8fZSB1sLijzN8QlrYWzjO59zUal8Jj9n+3S+ep+VgXMSUUYy8Wzc6769xhEjuna+mmekEA3RMsbnhF/1Z0z06eHEoT1VA96A1pHlJ7qbKInGJmkqaTsCgg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756218268; c=relaxed/simple;
	bh=RuCyxreiVNR45pVurQgwPkssSpGKoCRrCKswga1hrXI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sjIYiwDI6FJ5te0TIi46/BUCZXvhVD3Hw74s+s7uzfXJFrDDX1SAxh1dDXcsREUZVpHzbGFIQ2qUmrEib7c/Hul4xMajbqBje67guYb7BSKO7ZLdx3G10jPqOPfx+adwvvzEDPE0FXlSAxssapFUfY/tiFKPqQudw9ecErrhAPQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UlPzlloF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UlPzlloF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0219CC4CEF1;
	Tue, 26 Aug 2025 14:24:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756218268;
	bh=RuCyxreiVNR45pVurQgwPkssSpGKoCRrCKswga1hrXI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UlPzlloF6xv1Ct2XxXLWmuHaiJuyVlibr90Uunxep6A/C1I1eZRlSW0pj/ae8wbDm
	 C6ZClJebA9f/YJroZCCmkdLfFqqz6OE9JoOz2TrgPdIbWlz6V8Rub4TsM5HwrE7vdf
	 aDE4x8yLGU5gATLt2qptCsIyQQGOtpaWiP1EjJ1Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anna Schumaker <Anna.Schumaker@Netapp.com>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 457/523] NFS: Create an nfs4_server_set_init_caps() function
Date: Tue, 26 Aug 2025 13:11:07 +0200
Message-ID: <20250826110935.719454645@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110924.562212281@linuxfoundation.org>
References: <20250826110924.562212281@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anna Schumaker <Anna.Schumaker@Netapp.com>

[ Upstream commit 01dde76e471229e3437a2686c572f4980b2c483e ]

And call it before doing an FSINFO probe to reset to the baseline
capabilities before probing.

Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Stable-dep-of: b01f21cacde9 ("NFS: Fix the setting of capabilities when automounting a new filesystem")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfs/internal.h   |    1 +
 fs/nfs/nfs4client.c |   33 +++++++++++++++++++--------------
 fs/nfs/nfs4proc.c   |    2 ++
 3 files changed, 22 insertions(+), 14 deletions(-)

--- a/fs/nfs/internal.h
+++ b/fs/nfs/internal.h
@@ -222,6 +222,7 @@ extern struct nfs_client *
 nfs4_find_client_sessionid(struct net *, const struct sockaddr *,
 				struct nfs4_sessionid *, u32);
 extern struct nfs_server *nfs_create_server(struct fs_context *);
+extern void nfs4_server_set_init_caps(struct nfs_server *);
 extern struct nfs_server *nfs4_create_server(struct fs_context *);
 extern struct nfs_server *nfs4_create_referral_server(struct fs_context *);
 extern int nfs4_update_server(struct nfs_server *server, const char *hostname,
--- a/fs/nfs/nfs4client.c
+++ b/fs/nfs/nfs4client.c
@@ -1025,6 +1025,24 @@ static void nfs4_session_limit_xasize(st
 #endif
 }
 
+void nfs4_server_set_init_caps(struct nfs_server *server)
+{
+	/* Set the basic capabilities */
+	server->caps |= server->nfs_client->cl_mvops->init_caps;
+	if (server->flags & NFS_MOUNT_NORDIRPLUS)
+			server->caps &= ~NFS_CAP_READDIRPLUS;
+	if (server->nfs_client->cl_proto == XPRT_TRANSPORT_RDMA)
+		server->caps &= ~NFS_CAP_READ_PLUS;
+
+	/*
+	 * Don't use NFS uid/gid mapping if we're using AUTH_SYS or lower
+	 * authentication.
+	 */
+	if (nfs4_disable_idmapping &&
+			server->client->cl_auth->au_flavor == RPC_AUTH_UNIX)
+		server->caps |= NFS_CAP_UIDGID_NOMAP;
+}
+
 static int nfs4_server_common_setup(struct nfs_server *server,
 		struct nfs_fh *mntfh, bool auth_probe)
 {
@@ -1044,20 +1062,7 @@ static int nfs4_server_common_setup(stru
 	if (error < 0)
 		goto out;
 
-	/* Set the basic capabilities */
-	server->caps |= server->nfs_client->cl_mvops->init_caps;
-	if (server->flags & NFS_MOUNT_NORDIRPLUS)
-			server->caps &= ~NFS_CAP_READDIRPLUS;
-	if (server->nfs_client->cl_proto == XPRT_TRANSPORT_RDMA)
-		server->caps &= ~NFS_CAP_READ_PLUS;
-	/*
-	 * Don't use NFS uid/gid mapping if we're using AUTH_SYS or lower
-	 * authentication.
-	 */
-	if (nfs4_disable_idmapping &&
-			server->client->cl_auth->au_flavor == RPC_AUTH_UNIX)
-		server->caps |= NFS_CAP_UIDGID_NOMAP;
-
+	nfs4_server_set_init_caps(server);
 
 	/* Probe the root fh to retrieve its FSID and filehandle */
 	error = nfs4_get_rootfh(server, mntfh, auth_probe);
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -3934,6 +3934,8 @@ int nfs4_server_capabilities(struct nfs_
 		.interruptible = true,
 	};
 	int err;
+
+	nfs4_server_set_init_caps(server);
 	do {
 		err = nfs4_handle_exception(server,
 				_nfs4_server_capabilities(server, fhandle),


