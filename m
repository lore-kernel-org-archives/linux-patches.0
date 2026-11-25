Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795619539;
	b=M0y3gBhT12iVSC3RrXiWWGFyatGsBRrMDc333BI+zFQqZFFANed/fmjkDoooGWG+aRlc
	 zPhaJxN+SfV/UEGCM0/5fUi5EqQgcNfq1dX8O+v5aBRjuF0/HC9wNxHkotVBB+rUdbzZt
	 ForsGk+kiiKY+etyVcAfwfeigQlxqwoXsY/gIzbDWmCn+LM80wCwqljVqU5iOer7awT+X
	 XoFV74h9AHtN9Ytsw7DMekNgbBXUVM7EIfRhV34tTyFbCX5u/mCEyDZsZ3B38gVnCSZkS
	 CYQQ2X0SPCMVJ9Dnjx7JIhE5pOoAgO+QGcm8c0tuYsbZtKKrDOJmG7Y+wUJMJgurznQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795619539;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=HL9SFN/cEbZN0ieAaEfkPLrte+QuficBbgEpKFZdcXI=;
	b=ZBvSqJSOSTYHwF2aRKA4VRG+0TKR2JGVXJOLDZBh9p8iOnxiYFBss16Ld3nBWwfpb1Sp
	 FdzEbTTuAyR0zqhqSprdntSWgeB3KbF0uwq1/bEbAhaF5ArdMmuUdJdfv3neVKB7gRopr
	 kelFd4qRkvaKQQ9OYymCHMg0IZAaCvJk29U2h/8GAVCDstS48omDRShZIlaK87J4ULHKM
	 zIJD8BKvpq1BdhtLV1+dDDdUTaIDeZLHR5AKzFafSGAXlBhGG6+qkLLnGehPQeU2HhHPi
	 FWE0iLZLMDvjXhkeYG0M9G2LrJmdESGA8VOiRC6d2kYaXHHT44lu78JKfCkx9aPGnWA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qM0fz323;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0BB9606A323;
	Wed, 25 Nov 2026 15:12:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qM0fz323
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEC1C1F000E0;
	Wed, 25 Nov 2026 15:12:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795619538;
	bh=HL9SFN/cEbZN0ieAaEfkPLrte+QuficBbgEpKFZdcXI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qM0fz3239FL6998r3ePN0Rio8IowY9eQ0U0mt2YZ5RS11ar9mvxyPE03myfQr1E4t
	 zZdMJ2J37KZMFrUuHMJ1BqcoY1mVTbvfPsyZ66minty6eLwBy6AdHwwpBGRRts/jsu
	 J4hHH4erX1P7+KZ4CZKPukiBbFKxy0hzBIvIUq9k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Luk=C3=A1=C5=A1=20Lalinsk=C3=BD?= <lukas@lalinsky.com>,
	Jens Axboe <axboe@kernel.dk>,
	Dave Miller <davem@davem-thinkpadp1gen8.ibmlond.csb>
Subject: [PATCH 7.3 0628/1005] net: leave O_NONBLOCK to the sendmsg and recvmsg syscalls
Date: Wed, 25 Nov 2026 15:32:46 +0100
Message-ID: <20261125143836.457908604@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jens Axboe <axboe@kernel.dk>

commit bdc350ddbcbe4788158019d4d8e8e9345cb16235 upstream.

____sys_sendmsg() and ____sys_recvmsg() turn O_NONBLOCK on the socket
into MSG_DONTWAIT. That is right for the system calls, but io_uring uses
__sys_sendmsg_sock() and __sys_recvmsg_sock() for a blocking attempt
from io-wq as well, after the non-blocking attempts with MSG_DONTWAIT
have failed. On an O_NONBLOCK socket that attempt can't block either and
the request completes with -EAGAIN, unlike IORING_OP_SEND and RECV,
which call sock_sendmsg() and sock_recvmsg() directly and don't look at
O_NONBLOCK at all.

Move the O_NONBLOCK handling to ___sys_sendmsg() and ___sys_recvmsg(),
which the sendmsg, sendmmsg, recvmsg and recvmmsg system calls go
through. The io_uring helpers then pass the flags the caller asked for.

Cc: stable@vger.kernel.org
Fixes: 0fa03c624d8f ("io_uring: add support for sendmsg()")
Fixes: aa1fa28fc73e ("io_uring: add support for recvmsg()")
Link: https://lore.kernel.org/io-uring/a5589b66-9a20-4b1c-a0f1-1b5b31af3667@app.fastmail.com/
Reported-by: Lukáš Lalinský <lukas@lalinsky.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Dave Miller <davem@davem-thinkpadp1gen8.ibmlond.csb>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/socket.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

--- a/net/socket.c
+++ b/net/socket.c
@@ -2695,8 +2695,6 @@ static int ____sys_sendmsg(struct socket
 	flags &= ~MSG_INTERNAL_SENDMSG_FLAGS;
 	msg_sys->msg_flags = flags;
 
-	if (sock->file->f_flags & O_NONBLOCK)
-		msg_sys->msg_flags |= MSG_DONTWAIT;
 	/*
 	 * If this is sendmmsg() and current destination address is same as
 	 * previously succeeded address, omit asking LSM's decision.
@@ -2760,6 +2758,9 @@ static int ___sys_sendmsg(struct socket
 
 	msg_sys->msg_name = &address;
 
+	if (sock->file->f_flags & O_NONBLOCK)
+		flags |= MSG_DONTWAIT;
+
 	err = sendmsg_copy_msghdr(msg_sys, msg, flags, &iov);
 	if (err < 0)
 		return err;
@@ -2924,9 +2925,6 @@ static int ____sys_recvmsg(struct socket
 	/* We assume all kernel code knows the size of sockaddr_storage */
 	msg_sys->msg_namelen = 0;
 
-	if (sock->file->f_flags & O_NONBLOCK)
-		flags |= MSG_DONTWAIT;
-
 	if (unlikely(nosec))
 		err = sock_recvmsg_nosec(sock, msg_sys, flags);
 	else
@@ -2968,6 +2966,9 @@ static int ___sys_recvmsg(struct socket
 	struct sockaddr __user *uaddr;
 	ssize_t err;
 
+	if (sock->file->f_flags & O_NONBLOCK)
+		flags |= MSG_DONTWAIT;
+
 	err = recvmsg_copy_msghdr(msg_sys, msg, flags, &uaddr, &iov);
 	if (err < 0)
 		return err;


