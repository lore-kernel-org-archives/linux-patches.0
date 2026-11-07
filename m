Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061753;
	b=FfaB6slqrxm4SXnCACEGM8z8qZ2yuRJngUt3P24nsUAr9c7SxN+4EUtKhIUOYoWYyOQI
	 j+B8cpT0hq76B3Ux0XrFFYKo6lbHdBIJFOTb0QFQEQ/r15rLlOPhx5kUdQgCX40JPqEBH
	 QFnHKmBNEEX1srknZkpqydI7iOFPZqh30vuOVzTGT+QozL0TbIP045ss0O6qe1DtFxFOK
	 OCrSnsco4hY5xngtJmoHLmkHqtjsy1S8tfqPXtuuUtAI6768S/dyQEezAxqSN5jPFJX+K
	 V8YpoLnM2ABUKy7JwsAEbVWHi+3oEqyw9keqm3/Ii97ctpGq+ZQmRwngmJPc7361Q+A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061753;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=T7fg7XhnvOHgFxRwcWxbYx9xafnOEJirI+I822fuTHY=;
	b=RJfYTiiciV3RKARmIwJBV3il2BK3fXgzLm0FAQI6dHE7ktv0DmAEydYl2JLjET+osy8M
	 L/+s3iUvhi/IGooHIJU/7Pyf4FyKjeMHrR82ntc1Mx16BTqd79xySZCPk3aOqHndP2ZZv
	 KgBoqhVUZgkoSvc9neuxmdpBcI3bBIxoVs6sGv/afLjjcwLfnOsW3460+RAj6tcau086d
	 y9U4yW2BTiqfSuiM5922I31nJDwi+/wOuzH5qNdi4KLABVU1PbZpK74RB2OGBr4EXmRok
	 EsOZdOGFqH9gFkMHHGvsc0Dv2jJl4aQHQds2tJXjlp/3EmT0izpceHUl6mIrYbRjHig==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MAKq2fWm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35BCF606A326;
	Sat,  7 Nov 2026 14:29:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MAKq2fWm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3F461F0089F;
	Sat,  7 Nov 2026 14:29:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061753;
	bh=T7fg7XhnvOHgFxRwcWxbYx9xafnOEJirI+I822fuTHY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MAKq2fWm/LLoOWcrSvBMu2XZVYZkqmqB4K6EAaWU2xoFP70iBYpnhdzVcCdXvuqkt
	 Iw5bdA8sS1d0PRWo2fQGIT1S64ul0/7jzOzP1scnaUm7CvA8VbrUxexwxNKmc+ozAG
	 J23Phr5AmExK4S834zlmZS3T+q3g04LmF10PWqzc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+54cdc566f64abf51b7f1@syzkaller.appspotmail.com,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <cel@kernel.org>
Subject: [PATCH 6.12 0784/1536] SUNRPC: Reject a socket that already has an svc_sock attached
Date: Sat,  7 Nov 2026 08:46:40 -0500
Message-ID: <20261107135019.562293322@linuxfoundation.org>
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

commit 0995447b8059c4d23853cdcddbe789c4a2b6bb88 upstream.

Writing the same socket descriptor to /proc/fs/nfsd/portlist twice
attaches a second svc_sock to one socket. svc_setup_socket() saves
the socket's callbacks before installing its own, so the second
attach records svc_write_space() as the old write_space callback.
svc_udp_init() invokes that callback by way of svc_sock_setbufsize(),
and svc_write_space() then calls itself until the kernel stack is
exhausted:

  BUG: TASK stack guard page was hit at ffffc900037d7ff8
   svc_write_space+0x90/0x2b0 net/sunrpc/svcsock.c:429
   svc_write_space+0xe6/0x2b0 net/sunrpc/svcsock.c:430
   ... 700 more ...
   svc_sock_setbufsize+0x18d/0x220 net/sunrpc/svcsock.c:386
   svc_udp_init net/sunrpc/svcsock.c:854 [inline]
   svc_setup_socket+0xb2f/0x1090 net/sunrpc/svcsock.c:1498
   svc_addsock+0x2fd/0x760 net/sunrpc/svcsock.c:1547
   __write_ports_addfd fs/nfsd/nfsctl.c:742 [inline]
   write_ports+0xa5b/0xcc0 fs/nfsd/nfsctl.c:861
   nfsctl_transaction_write+0x106/0x1a0 fs/nfsd/nfsctl.c:112

svc_data_ready() and svc_tcp_state_change() chain through their saved
callbacks the same way, so a TCP descriptor added twice recurses on
the next incoming segment instead. Reaching any of this takes a
writer on portlist, and the nfsd filesystem sets no FS_USERNS_MOUNT,
so the reproducer needs CAP_SYS_ADMIN in the initial user namespace.

Reject a socket that already carries sk_user_data. svc_setup_socket()
overwrites that field unconditionally, so a socket some other
consumer has claimed is one NFSD would corrupt whether or not the
callbacks recurse.

Fixes: b41b66d63c73 ("[PATCH] knfsd: allow sockets to be passed to nfsd via 'portlist'")
Cc: stable@vger.kernel.org
Reported-by: syzbot+54cdc566f64abf51b7f1@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=54cdc566f64abf51b7f1
Link: https://patch.msgid.link/20260815162844.8219-1-cel@kernel.org
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <cel@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sunrpc/svcsock.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/net/sunrpc/svcsock.c
+++ b/net/sunrpc/svcsock.c
@@ -1531,6 +1531,9 @@ int svc_addsock(struct svc_serv *serv, s
 	err = -EISCONN;
 	if (so->state > SS_UNCONNECTED)
 		goto out;
+	err = -EBUSY;
+	if (so->sk->sk_user_data)
+		goto out;
 	err = -ENOENT;
 	if (!try_module_get(THIS_MODULE))
 		goto out;


