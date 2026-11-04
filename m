Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831788;
	b=cpK9O+zRfe1l/E69PMrynhoiJcVAHQc73jeSIcFyIXkAfXFXAHVs7VSZ+kbISzjMYxRu
	 JgSkUIa00dJ/aS4WCKMCBJ3cVd2DuXaCQQDQvx7XUSjaR8qZO57NH0elvoNBvNdS+SpG8
	 EiQ1sYfppsriI4/tJYOdpixPb4isbKJ902hXR5ZdWrb7u38uhSx6aZX2o378JhpLkRwa8
	 HIrNYebiMbo5yOk2/55cSp+Zx4S9Ia14yA4TRpr3Ce5YdIZoBXaS8c3Ze/IVYTCnbeUnf
	 oNAVR58PDHcZfBeNgOmdGs1K8fOBABNWszYkFFVkoVphtbxaHs3TNLTcFJchr/FzYNg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831788;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0Zbvvn56wF49Yjg5NQ2fu65IXu29rzWhYGdeRyyCXJ4=;
	b=K3IqQbRn59LNhv/mQiPob/IQ/rPxh8gKh6C0XavH41EhNINk2ZL+jGcU8cxzAo/2Ry1N
	 YIShLQn7w8iZ43O850+0bO2s2Wv2JHzfhAOHoRzR6bQr2CRPj5jqacrxTDyye4HAFKG7O
	 ReK+hoQfYTYHyKpSL995s5j3ct8xslE4EDiOVlDdHfeb5l9VpSCSwuwBQhrrJ9RdwuL/I
	 NXSAepPSQd1eVe1aHoANh720OeJYn8rtWteVLzyxefxq3JQ8YKMCw1zOUAOiyrJoFUwlF
	 r2xOTF1aARPljpdYSaFCcPcDcpJeAzxrrsVjAiQkBIEyEMjuNHREvFH7T/71DrKgsTQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=t6XV+YTF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2A21606AC37;
	Wed,  4 Nov 2026 22:36:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=t6XV+YTF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 095B51F000C1;
	Wed,  4 Nov 2026 22:36:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831787;
	bh=0Zbvvn56wF49Yjg5NQ2fu65IXu29rzWhYGdeRyyCXJ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=t6XV+YTFP6JGbGKgCViHukjTQhEqywIS7jOYHehp/+EY3ESWCgupFTJPOxlYSxzmn
	 LWDmOh8q74lrBTMU7uw51ZdERy4ndcXNxkKBjTeMNPkwITZsXOyFUXRCS7BS/sBXFY
	 o3othWpF+Yc/JGcmj3lkXPDhUs2ZXPGCUwdPhTOQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+54cdc566f64abf51b7f1@syzkaller.appspotmail.com,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <cel@kernel.org>
Subject: [PATCH 6.18 0912/1005] SUNRPC: Reject a socket that already has an svc_sock attached
Date: Wed,  4 Nov 2026 16:10:45 -0500
Message-ID: <20261104211108.711532275@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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
@@ -1550,6 +1550,9 @@ int svc_addsock(struct svc_serv *serv, s
 	err = -EISCONN;
 	if (so->state > SS_UNCONNECTED)
 		goto out;
+	err = -EBUSY;
+	if (so->sk->sk_user_data)
+		goto out;
 	err = -ENOENT;
 	if (!try_module_get(THIS_MODULE))
 		goto out;


