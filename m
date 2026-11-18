Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795046053;
	b=Sp4UsrEp3Il+/D4HVU0OB+RXYk8Cb92aeZgwXG2XFJnyo0vVsmYQU2GfeGfbifirDpX6
	 T5O4HUhW3sJ2rUFNCt0kwBc6HCdZ60gJ2T3kbU3e3rgSA0rGGy7DxUPvPZnOFGh9p3x0E
	 9EjMdAcjJn52X8Hv3cxrUQCcz0GC3x4JHFjU5tyC7otI3WSzz5tl8pgJP/OGN7spXTcVB
	 zUooAfmi5AXHPy0bPbBGFpWnzb42UBI1C09o/yGVGDdBBL0ElmNNY36zkFi3YQrM/q9oJ
	 ezhE224Nv1a1ObyuTWcXvz/eJiy5AMbu/RyTIJ9QRB+kn+Dl5lMVc4LhIwfXTtLwyww==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795046053;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=Snjn+kwRnOoAjrRQJ6grqg4aImFzBGmdt1d87S9pD6E=;
	b=2noKLJD921AKbHQYuHZjL7eVRpZ0CxMAnVsljRK8eQoUcK0D4Mgx1riBRt0ZYLk7uvyK
	 r3o+ZvXXFuL2nRacU9706eytw7I4FrQYLRKMBjxaVtB5JF5zqW8hGw+Wo4DTl0h82KFJq
	 GTwuINCvoBzD9iBT3q+NpP79QDZh9K4eq8HNg+e15oJmNQpKmT7x4spN7Pgh6P+hWoMXN
	 pPfSxCB/+KX53g3SkofLUX7J94wGO7ajiMPVKd2zHmjqjohcUKhbXESLieNSe5vuFXFzq
	 g07Sfhi9h5NGiSPGwkN3RuEYqyvz7DxmW4JTb+pBj6MVy4Tx15i5/bwXYhg7t5Cwueg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=g8iaB8pw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA718606A31C;
	Wed, 18 Nov 2026 23:54:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=g8iaB8pw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF1401F000C5;
	Wed, 18 Nov 2026 23:54:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795046053;
	bh=Snjn+kwRnOoAjrRQJ6grqg4aImFzBGmdt1d87S9pD6E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=g8iaB8pwRFIMdFcp/MCc8BVNviYjAxQCoV8vk6Ip5rdN6IuNJ7/KOG8XCyRdezwxA
	 8HwIaVl23dtMPlsGw+MMTHyA9/hb5jIE6oDT8tTVNkYbyxsx8gYZGUHuEZHKF04+xX
	 08wyEYNLlneBzhKQOTzX13msRC/rMrCl/tJQ3BAA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Luk=C3=A1=C5=A1=20Lalinsk=C3=BD?= <lukas@lalinsky.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1144/2857] io_uring/poll: dont poll a writer for urgent data
Date: Wed, 18 Nov 2026 15:36:18 +0100
Message-ID: <20261118150242.773234412@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jens Axboe <axboe@kernel.dk>

Commit edeac4546a71b6c1db4ba006a2dbf7c863f54e9a upstream.

io_arm_poll_handler() starts the mask of every async poll with EPOLLPRI,
for a reader and a writer alike. A TCP socket reports EPOLLPRI for as
long as urgent data sits unread, so once the peer has sent a byte with
MSG_OOB, the async poll of a send that waits for buffer space is ready
on every re-arm. The request spins through task_work and
__io_arm_poll_handler() until APOLL_MAX_RETRY is used up and io-wq takes
it, the same spin that EPOLLRDHUP caused for a half-closed peer.

While it spins, the request is neither in the poll hash nor in io-wq. A
cancel issued right after the send gets -ENOENT and the send stays
pending, until a later cancel finds it in io-wq.

Only add EPOLLPRI for polls that want to read. Urgent data is an event
for a recv, not for a writer.

Fixes: d7718a9d25a6 ("io_uring: use poll driven retry for files that support it")
Reported-by: Lukáš Lalinský <lukas@lalinsky.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
[axboe: 6.1 sets up the mask in io_arm_poll_handler() itself, with
EPOLLET]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/poll.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/io_uring/poll.c b/io_uring/poll.c
index aa7ffce3a2958..10786e84b3725 100644
--- a/io_uring/poll.c
+++ b/io_uring/poll.c
@@ -753,7 +753,7 @@ int io_arm_poll_handler(struct io_kiocb *req, unsigned issue_flags)
 	const struct io_op_def *def = &io_op_defs[req->opcode];
 	struct async_poll *apoll;
 	struct io_poll_table ipt;
-	__poll_t mask = POLLPRI | POLLERR | EPOLLET;
+	__poll_t mask = POLLERR | EPOLLET;
 	int ret;
 
 	/*
@@ -770,7 +770,8 @@ int io_arm_poll_handler(struct io_kiocb *req, unsigned issue_flags)
 		mask |= EPOLLONESHOT;
 
 	if (def->pollin) {
-		mask |= EPOLLIN | EPOLLRDNORM;
+		/* urgent data is an event for a reader only */
+		mask |= EPOLLIN | EPOLLRDNORM | EPOLLPRI;
 
 		/* If reading from MSG_ERRQUEUE using recvmsg, ignore POLLIN */
 		if (req->flags & REQ_F_CLEAR_POLLIN)
-- 
2.53.0



