Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795035435;
	b=IsXjreJt14F2D1lAfkkCMYk/4VLQklGTXgUhEXED99w6R9TcKVn8mrm7jA2sUyT/QMTt
	 TSP9dQbubYmsi+ddLmjASeH9V6WfbCIXlK8ml76S7ueX9HT+ZR0LlWoypkHY1XqC2hPzM
	 IlNfwi+BFhVMmHEEFn2X3Kn6cIi6L2lJWPdx+BKwg5tX0je/aWzGH9K8D5p3zC0lPvVjB
	 gRvqCD7nzFLoy4H1tCqLNgv0QxAEusU7Xvvnhpuh1xy/mx9dp8hP0DRWfGD00UmbWIr0r
	 kRDPXgihsZIO0GhB/hxuoSsmz9e4PFGV4WJmJXqkOlhWoXbkhT0bKMH9cXyvKoCNJjg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795035435;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=pKRXsMGIRwUMvCzyNN18fz9wU0V0NhYXNwooGxRJpbA=;
	b=lgsEZQEDSnofoT5s8qxrbE5/d60rwDkAFfy84xnPz5Z4UxA/oN8KTfKmIIJG1RSiI/xk
	 nqG1Aw11OnsK86sRtGEPlaipy5+yAm4ExqTOHuAqj2zXTNe6SCxEuhsXqWcnRcNFqqqUU
	 SleDwLmSqmosa6vTmXvBET1nWclSnBaXEscrY9nD7JQryVexygoFLZbjbPECSCbzcT8qN
	 jglBHlh4WrTXS2T7zdh5kS3aEZs47a4jz1YHjVixnqXhINchkVJs7vmdCHfpL0/aKlCSt
	 nKQ+Ajb71Ip2hGceHPgyVw2r5Fpc25z/21FTF8FP8blPRvfiJJOi1oN5fJdsdmrjJKA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FwUIB49a;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B064606A320;
	Wed, 18 Nov 2026 20:57:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FwUIB49a
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 611D81F000C5;
	Wed, 18 Nov 2026 20:57:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795035434;
	bh=pKRXsMGIRwUMvCzyNN18fz9wU0V0NhYXNwooGxRJpbA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FwUIB49atyDwje/1/cS/9iN+LUsGyVBl/lZygiUaG2obxoCP4iw+aDoN16GFZyH4a
	 wOqnEn0ek7N7z9OGAZS16Q+j7wZutZHmVb0F5klS91qNdXvp0Qd7AftJ2JybfVieBa
	 J9ihQJRPk05wuYcN47akHKFpIHLCucJO9MTXzWEg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+54cdc566f64abf51b7f1@syzkaller.appspotmail.com,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <cel@kernel.org>
Subject: [PATCH 6.6 0704/3318] SUNRPC: Reject a socket that already has an svc_sock attached
Date: Wed, 18 Nov 2026 15:22:06 +0100
Message-ID: <20261118150339.497720607@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1540,6 +1540,9 @@ int svc_addsock(struct svc_serv *serv, s
 	err = -EISCONN;
 	if (so->state > SS_UNCONNECTED)
 		goto out;
+	err = -EBUSY;
+	if (so->sk->sk_user_data)
+		goto out;
 	err = -ENOENT;
 	if (!try_module_get(THIS_MODULE))
 		goto out;


