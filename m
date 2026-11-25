Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795625637;
	b=z8Z4aWGRfnWc4L0LPIcbCRwqibMjefx2LM/3Xz+BJn+0cx2221BMl4xe8pjU4UuaCmCo
	 2qklk7ZaHZScqrSMJGijyRbFehXu21wVhjaciMRG85Kk6BLjrNHb4RfkuVK00emRWfY/3
	 A+Ob5vE0Pwbol/2UTE7vxn/Rbz9GspTWpcNl9Rbl0xwS2aAUDxecuemOsbHHysVEUV2G0
	 H/VhtB4q/dPEa3Z8ZmChPUZnhqhJF0rK60wJxTqEH0gecA4wnFc1yCHSp12qOiOgSXqzE
	 2mI8JUptsIXDvqOtpAlvhpSQa+lPXTg4uabU3KpbvWQfY62g/lUYhrk/u3mbrWmauqg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795625637;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=jTcVFcMWhCjfd7+GwUPRiwGAgp5e64uxP7+s1YHGLX0=;
	b=utUn9gOrLQqDAv6qj17hLpJmHIKi2n1Oa3TxSBieaSjY3L7SfA7TtMqQGZWjJoSaLg9R
	 bxf3RiLjWw/HwTDOZjk2pMsKNot/EDk7X8wSuSEuBNfLi7YJNvjv37tN8Uf8Kxx6Yl/gi
	 1uv/H5ckSasvepdgXUmVYBJToysGTKW8GtWPX2IS9lJlBaXuh19KSx2vsbagnho5u94pJ
	 MMFQ/4lg+NXWB0Pt0cBVifbQn82jrpmt2WCxFquhczgD8rrV0pXW7d/kt+wbC434dBLgT
	 5mtnM0rsw8x8cmr4jd3dyvfoFb1ZmfIxjCpwU2dYoEogR6/ESJIbIK2edLzFap6M7/Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DqXlJ3sE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9ACA606A31E;
	Wed, 25 Nov 2026 16:53:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DqXlJ3sE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 755321F000C0;
	Wed, 25 Nov 2026 16:53:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795625637;
	bh=jTcVFcMWhCjfd7+GwUPRiwGAgp5e64uxP7+s1YHGLX0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DqXlJ3sEYgoHK/MGH6fhphTlD0SISfhiRyR54L734taX3iCQiHJ4ax7/v0w8ri1t4
	 GLGGn2Pf/sKomhN4/LgbCL7jsYIYCzingT6JInTr/ZD/TYgSoy4xtxLt/qC2oGdb/o
	 Ko2Qpft91ZjjNX72KRqtes+cXcLLzfldLcD6sq58=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Luk=C3=A1=C5=A1=20Lalinsk=C3=BD?= <lukas@lalinsky.com>,
	Jens Axboe <axboe@kernel.dk>,
	Dave Miller <davem@davem-thinkpadp1gen8.ibmlond.csb>
Subject: [PATCH 6.12 582/816] net: leave O_NONBLOCK to the sendmsg and recvmsg syscalls
Date: Wed, 25 Nov 2026 15:35:30 +0100
Message-ID: <20261125143902.651027364@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2611,8 +2611,6 @@ static int ____sys_sendmsg(struct socket
 	flags &= ~MSG_INTERNAL_SENDMSG_FLAGS;
 	msg_sys->msg_flags = flags;
 
-	if (sock->file->f_flags & O_NONBLOCK)
-		msg_sys->msg_flags |= MSG_DONTWAIT;
 	/*
 	 * If this is sendmmsg() and current destination address is same as
 	 * previously succeeded address, omit asking LSM's decision.
@@ -2676,6 +2674,9 @@ static int ___sys_sendmsg(struct socket
 
 	msg_sys->msg_name = &address;
 
+	if (sock->file->f_flags & O_NONBLOCK)
+		flags |= MSG_DONTWAIT;
+
 	err = sendmsg_copy_msghdr(msg_sys, msg, flags, &iov);
 	if (err < 0)
 		return err;
@@ -2840,9 +2841,6 @@ static int ____sys_recvmsg(struct socket
 	/* We assume all kernel code knows the size of sockaddr_storage */
 	msg_sys->msg_namelen = 0;
 
-	if (sock->file->f_flags & O_NONBLOCK)
-		flags |= MSG_DONTWAIT;
-
 	if (unlikely(nosec))
 		err = sock_recvmsg_nosec(sock, msg_sys, flags);
 	else
@@ -2884,6 +2882,9 @@ static int ___sys_recvmsg(struct socket
 	struct sockaddr __user *uaddr;
 	ssize_t err;
 
+	if (sock->file->f_flags & O_NONBLOCK)
+		flags |= MSG_DONTWAIT;
+
 	err = recvmsg_copy_msghdr(msg_sys, msg, flags, &uaddr, &iov);
 	if (err < 0)
 		return err;


