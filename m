Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795622939;
	b=Qz6pSwOU6ByGZkMl2imR/7PKlO4Yr2UsJABtLEC5LVl3R8gEw1cw39YaZqr0X1G5d94w
	 f75cLSM3hNGfmNGqZRkxPNh1QdCQ8/hqOi+Wa4TWVc1zJVq0X+Aqhax5KZhL97WO20rhQ
	 4Fe8aJ7jGpaIVjNoWP5TSs7YaY7Ib1/xr69rLZkfBmUibwMoRpfKaeg4NvC3IWCfYkbyu
	 C/UU9QzAroHb2FJvOPvOF35RqjhReynooLYOPmx8wVTChM2/ZiwxRWkdDv3eXLbabwUrO
	 9JPwUXY7IcPeo2LFx6FGYgjFmUF5igWP4JEWoDjJTfcI7foNAhbr71BBh29b92+rp3A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795622939;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=bUaCwV8WNr2miwkPSpeiVbmnC0ijq2zqKlxPI+/PVBE=;
	b=Zyo4viYu60a8sA9shpwAwj7QfQ+nVfvypwtKd9e0Nz0o5FXf8Ahp88k9uJajTjRAGeEq
	 tNTHJvKbPSf/PBQ/ZHXkVx1dEPNIUwAJHeb8ckdxHDSzs1CCAzgWYhWHFVekqmXcSdqII
	 JOLH9OvjkajdJoQITNtmYzT4VMi5bUNv0BYO/2zrotRoaxqm6QPoJ02sQ5xm2wshttNUO
	 l/x0PxAz3/94xMGa1iW4RAV7kpyHtqsjclCE2PWp2IjFYzccjwGQPoDu8K/4v7dg9JnNu
	 5+nFTA63tTRq0D5cyzy7MZu/eMF1h0NV4h6JxRjWgKo4tVowJ0QcBUOH91ZIIWmCB0Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lxHao61w;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEE4C606A31E;
	Wed, 25 Nov 2026 16:08:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lxHao61w
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BF711F000D1;
	Wed, 25 Nov 2026 16:08:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795622939;
	bh=bUaCwV8WNr2miwkPSpeiVbmnC0ijq2zqKlxPI+/PVBE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lxHao61wykIPwqjCKXI8fyUk/Tb36Hpk5CI2CU5Y7HVR+BjGjv5Ou3Ig3PL06QWKu
	 zz+zRnvtkn6o/vjjpNX+yIRNtxdkoV50OriXDowCXYthmO6AggWrADq7cjEeLdHSTD
	 aNlGMN0T9txImtiqwnqz3v3s2i08E/iVbOE4ptug=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Luk=C3=A1=C5=A1=20Lalinsk=C3=BD?= <lukas@lalinsky.com>,
	Jens Axboe <axboe@kernel.dk>,
	Dave Miller <davem@davem-thinkpadp1gen8.ibmlond.csb>
Subject: [PATCH 6.18 699/990] net: leave O_NONBLOCK to the sendmsg and recvmsg syscalls
Date: Wed, 25 Nov 2026 15:34:26 +0100
Message-ID: <20261125143838.458658328@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2613,8 +2613,6 @@ static int ____sys_sendmsg(struct socket
 	flags &= ~MSG_INTERNAL_SENDMSG_FLAGS;
 	msg_sys->msg_flags = flags;
 
-	if (sock->file->f_flags & O_NONBLOCK)
-		msg_sys->msg_flags |= MSG_DONTWAIT;
 	/*
 	 * If this is sendmmsg() and current destination address is same as
 	 * previously succeeded address, omit asking LSM's decision.
@@ -2678,6 +2676,9 @@ static int ___sys_sendmsg(struct socket
 
 	msg_sys->msg_name = &address;
 
+	if (sock->file->f_flags & O_NONBLOCK)
+		flags |= MSG_DONTWAIT;
+
 	err = sendmsg_copy_msghdr(msg_sys, msg, flags, &iov);
 	if (err < 0)
 		return err;
@@ -2842,9 +2843,6 @@ static int ____sys_recvmsg(struct socket
 	/* We assume all kernel code knows the size of sockaddr_storage */
 	msg_sys->msg_namelen = 0;
 
-	if (sock->file->f_flags & O_NONBLOCK)
-		flags |= MSG_DONTWAIT;
-
 	if (unlikely(nosec))
 		err = sock_recvmsg_nosec(sock, msg_sys, flags);
 	else
@@ -2886,6 +2884,9 @@ static int ___sys_recvmsg(struct socket
 	struct sockaddr __user *uaddr;
 	ssize_t err;
 
+	if (sock->file->f_flags & O_NONBLOCK)
+		flags |= MSG_DONTWAIT;
+
 	err = recvmsg_copy_msghdr(msg_sys, msg, flags, &uaddr, &iov);
 	if (err < 0)
 		return err;


