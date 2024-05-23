Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87D1714A634;
	Thu, 23 May 2024 13:22:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716470567; cv=none; b=Vqrs7remERvu1iXT6IzXaDPXSMrn/EEzWWWY4i9Ij03Cl1uD6tlCHagK7ATC1UG7alDJf8zPmbSiLP6R0jBZEA2C/GEt1IS6ggC78M0BnmcifPWbTBJ9VrQvyTQDUy9F+Tdl1PxGHX6YYs0cU8WT50+kCugKBGZOJCv6nrH4t6c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716470567; c=relaxed/simple;
	bh=ztGmeoKAEGdDm5Ff2G4XSKEy4g/pDR7d2keGr9iRtfI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jk7YBbeiRqMtHk023POIGDVejuZML3LL6po8Y37j3qb85xIGEZLneFJApUMK8Kws6Q0Wh4klhYEB1KLTIgzlX4jYiVqCi0r8V8T4is665ZIXkvzTMv+DVe2+8Y7V10HiFReVn6ZOl8/WsN8Nr6BSMUmOvjr1uBWY5mi7DRXP0Ow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bvOiQO+i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bvOiQO+i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1184BC3277B;
	Thu, 23 May 2024 13:22:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716470567;
	bh=ztGmeoKAEGdDm5Ff2G4XSKEy4g/pDR7d2keGr9iRtfI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bvOiQO+iZPSnvOus9bdmW2qSQFcJuMb1kONHFCCYcb35TzN9sxzaa85SXn9H0W8k7
	 V9auyo2mUkwoMCNhx+kHck//eIwcU44Gmra/2XNGli3VMJ0ttbwPr6835IkL0uE8ZZ
	 zUhhcAdpoulPe/cKQ90g3ycRtw3HhasO/D6EOaKA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pierre Mariani <pierre.mariani@gmail.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 012/102] smb: client: Fix minor whitespace errors and warnings
Date: Thu, 23 May 2024 15:12:37 +0200
Message-ID: <20240523130342.927260629@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240523130342.462912131@linuxfoundation.org>
References: <20240523130342.462912131@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pierre Mariani <pierre.mariani@gmail.com>

[ Upstream commit 0108ce08aed195d200ffbad74c1948bbaefe6625 ]

Fixes no-op checkpatch errors and warnings.

Signed-off-by: Pierre Mariani <pierre.mariani@gmail.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/connect.c | 25 +++++++++++++++++--------
 1 file changed, 17 insertions(+), 8 deletions(-)

diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
index cb3bed8364e07..2466b28379ff8 100644
--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -501,6 +501,7 @@ static int reconnect_target_unlocked(struct TCP_Server_Info *server, struct dfs_
 static int reconnect_dfs_server(struct TCP_Server_Info *server)
 {
 	struct dfs_cache_tgt_iterator *target_hint = NULL;
+
 	DFS_CACHE_TGT_LIST(tl);
 	int num_targets = 0;
 	int rc = 0;
@@ -763,6 +764,7 @@ cifs_read_from_socket(struct TCP_Server_Info *server, char *buf,
 {
 	struct msghdr smb_msg = {};
 	struct kvec iov = {.iov_base = buf, .iov_len = to_read};
+
 	iov_iter_kvec(&smb_msg.msg_iter, ITER_DEST, &iov, 1, to_read);
 
 	return cifs_readv_from_socket(server, &smb_msg);
@@ -1418,11 +1420,13 @@ cifs_match_ipaddr(struct sockaddr *srcaddr, struct sockaddr *rhs)
 	case AF_INET: {
 		struct sockaddr_in *saddr4 = (struct sockaddr_in *)srcaddr;
 		struct sockaddr_in *vaddr4 = (struct sockaddr_in *)rhs;
+
 		return (saddr4->sin_addr.s_addr == vaddr4->sin_addr.s_addr);
 	}
 	case AF_INET6: {
 		struct sockaddr_in6 *saddr6 = (struct sockaddr_in6 *)srcaddr;
 		struct sockaddr_in6 *vaddr6 = (struct sockaddr_in6 *)rhs;
+
 		return (ipv6_addr_equal(&saddr6->sin6_addr, &vaddr6->sin6_addr)
 			&& saddr6->sin6_scope_id == vaddr6->sin6_scope_id);
 	}
@@ -2607,8 +2611,8 @@ cifs_get_tcon(struct cifs_ses *ses, struct smb3_fs_context *ctx)
 			rc = -EOPNOTSUPP;
 			goto out_fail;
 		} else {
-			cifs_dbg(VFS, "Check vers= mount option. SMB3.11 "
-				"disabled but required for POSIX extensions\n");
+			cifs_dbg(VFS,
+				"Check vers= mount option. SMB3.11 disabled but required for POSIX extensions\n");
 			rc = -EOPNOTSUPP;
 			goto out_fail;
 		}
@@ -2751,7 +2755,6 @@ cifs_put_tlink(struct tcon_link *tlink)
 	if (!IS_ERR(tlink_tcon(tlink)))
 		cifs_put_tcon(tlink_tcon(tlink));
 	kfree(tlink);
-	return;
 }
 
 static int
@@ -2892,6 +2895,7 @@ static inline void
 cifs_reclassify_socket4(struct socket *sock)
 {
 	struct sock *sk = sock->sk;
+
 	BUG_ON(!sock_allow_reclassification(sk));
 	sock_lock_init_class_and_name(sk, "slock-AF_INET-CIFS",
 		&cifs_slock_key[0], "sk_lock-AF_INET-CIFS", &cifs_key[0]);
@@ -2901,6 +2905,7 @@ static inline void
 cifs_reclassify_socket6(struct socket *sock)
 {
 	struct sock *sk = sock->sk;
+
 	BUG_ON(!sock_allow_reclassification(sk));
 	sock_lock_init_class_and_name(sk, "slock-AF_INET6-CIFS",
 		&cifs_slock_key[1], "sk_lock-AF_INET6-CIFS", &cifs_key[1]);
@@ -2935,15 +2940,18 @@ static int
 bind_socket(struct TCP_Server_Info *server)
 {
 	int rc = 0;
+
 	if (server->srcaddr.ss_family != AF_UNSPEC) {
 		/* Bind to the specified local IP address */
 		struct socket *socket = server->ssocket;
+
 		rc = kernel_bind(socket,
 				 (struct sockaddr *) &server->srcaddr,
 				 sizeof(server->srcaddr));
 		if (rc < 0) {
 			struct sockaddr_in *saddr4;
 			struct sockaddr_in6 *saddr6;
+
 			saddr4 = (struct sockaddr_in *)&server->srcaddr;
 			saddr6 = (struct sockaddr_in6 *)&server->srcaddr;
 			if (saddr6->sin6_family == AF_INET6)
@@ -3173,6 +3181,7 @@ void reset_cifs_unix_caps(unsigned int xid, struct cifs_tcon *tcon,
 
 	if (!CIFSSMBQFSUnixInfo(xid, tcon)) {
 		__u64 cap = le64_to_cpu(tcon->fsUnixInfo.Capability);
+
 		cifs_dbg(FYI, "unix caps which server supports %lld\n", cap);
 		/*
 		 * check for reconnect case in which we do not
@@ -3698,7 +3707,7 @@ CIFSTCon(const unsigned int xid, struct cifs_ses *ses,
 	smb_buffer_response = smb_buffer;
 
 	header_assemble(smb_buffer, SMB_COM_TREE_CONNECT_ANDX,
-			NULL /*no tid */ , 4 /*wct */ );
+			NULL /*no tid */, 4 /*wct */);
 
 	smb_buffer->Mid = get_next_mid(ses->server);
 	smb_buffer->Uid = ses->Suid;
@@ -3717,12 +3726,12 @@ CIFSTCon(const unsigned int xid, struct cifs_ses *ses,
 	if (ses->server->sign)
 		smb_buffer->Flags2 |= SMBFLG2_SECURITY_SIGNATURE;
 
-	if (ses->capabilities & CAP_STATUS32) {
+	if (ses->capabilities & CAP_STATUS32)
 		smb_buffer->Flags2 |= SMBFLG2_ERR_STATUS;
-	}
-	if (ses->capabilities & CAP_DFS) {
+
+	if (ses->capabilities & CAP_DFS)
 		smb_buffer->Flags2 |= SMBFLG2_DFS;
-	}
+
 	if (ses->capabilities & CAP_UNICODE) {
 		smb_buffer->Flags2 |= SMBFLG2_UNICODE;
 		length =
-- 
2.43.0



