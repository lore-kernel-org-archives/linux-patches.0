Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795057928;
	b=FX5JlO8ErY0n4C4qOJ2Z/z+RUAZnXx6gghGf2Mlp7+FwHsr2y9Gr+ldOjIUTjvErTm47
	 S+QMqSCHhviBdK/aep8By2y2SlOzvZ/IykW5klda6Kf+U509r5o1JwZ5Ko5VEdcGfeXNP
	 zNHyV1qSJYE0QdFxQxChevvlYJDbBD+UImgkf1KSqdHf0+1xNpdpeqKFYJMqKsGIfQ6nS
	 NaXYo5jCYLwgba2DHGzqgCBf3imHhBkJxxJUS6wtRAgmmbkOuwGjepgGg1Bs1RQyZSXuP
	 IfgpFSVFHLb4bILzSs91fAJR5ci+5TR7rejAW6kJD8MSgbfedfIE8NZgge64mQu998g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795057928;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=g+CRRQFq+BfRAX2oq5poI1bSkp4z8OdpcyPpaehHGyg=;
	b=qEWMgVOuEQnbSUeSB5WS1yuf4esQ46FlPyy0jN4dNtGnuJpXjQpMAeg0RqSGdU1C9Zjj
	 A2msuZhc+GIuCClTbf9cR3yLiwNxe6eA1S1mLFa+/QZraUTtYAqJf9JQph/KEkfyyI9sT
	 6203I2wtuTGik35Vno5vg8bY6UK7I4S+7//eVkG0V+Sv9gYCIkuraISJm7r5iTP9N/MGf
	 iiNnf7QD3uUBQ6PBxQICkxposeNIQm6Xi56TGmawnXi55IiJnySF9JpAfDEFsF1w7uY88
	 jxgT3l1y2TefjNAQDuKWSYX3Psyy/ptvnsGpcGuXLi4FFG+PXTixhxqKCGbDdlMHf0A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oSqwfLih;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F30DE606A31C;
	Thu, 19 Nov 2026 03:12:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oSqwfLih
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 552941F000C4;
	Thu, 19 Nov 2026 03:12:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795057927;
	bh=g+CRRQFq+BfRAX2oq5poI1bSkp4z8OdpcyPpaehHGyg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oSqwfLihSY5w0qLv8qyQr0BxzPJ4pcaL//z573jWmmsnudSgBKzNlsnXvuGeHwz75
	 MKoUbkd7ysIZDNqc/n3ZoHXzES/shiDfKRY/zTbAaoyE7yRTm6Wi5uVKuzkqGs7FO+
	 Fm2CpuyMYXR+LtUCdYh5uMqfNrUaLy0VDANjk7/I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+54cdc566f64abf51b7f1@syzkaller.appspotmail.com,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <cel@kernel.org>
Subject: [PATCH 5.10 0302/1848] SUNRPC: Reject a socket that already has an svc_sock attached
Date: Wed, 18 Nov 2026 15:39:00 +0100
Message-ID: <20261118145924.800267711@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1380,6 +1380,9 @@ int svc_addsock(struct svc_serv *serv, s
 	err = -EISCONN;
 	if (so->state > SS_UNCONNECTED)
 		goto out;
+	err = -EBUSY;
+	if (so->sk->sk_user_data)
+		goto out;
 	err = -ENOENT;
 	if (!try_module_get(THIS_MODULE))
 		goto out;


