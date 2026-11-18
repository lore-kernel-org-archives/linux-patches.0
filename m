Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795037383;
	b=RAFhsvgHmKQbHb2Va7TLw4ya20egkwjcwiMCEDenFdUPZ2t8N36G1UObPaZB7bFprDQ+
	 tFeWSwhfNMw4e3we8j6R7ECuPmAYX8NmUovFx5j6wUMTNjOYqdkS2b63oC+jAarOCSc97
	 yhtM3sjTL2hUF45lzNqVVQuNXptnFt4GtBUJuNygE0RjcITxmStMarWPIDgry3R8X/ODx
	 P2UMxh6YyCoN/DqvgUWZJ6QDCJvOg4Akvlja+x1kgqfwDb34kQeT5AQM2ml7CZ3pbcwae
	 7nvHrjNV4XCqcYQ6fzRv4GMliy5uyc4Ud/nNt7I5F0GmEgsK+BowAwyd50YIq7XfYdA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795037383;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=QJzQmRA9EAmMtb+9wy6TAVc5ZFGg6uAj+RxdHk1ab1M=;
	b=wjUfD0YmXNYJ796GacxWmf5weN1MblY6iMMYaW9xoGROwoc7G0uJhsNRzGt6Sq8Irmqz
	 qiYZgozDGBsjKESf3BLZNxsoWNh3DYjAlGfyjAD5mNUou8JSx76XpZE2GiyjOqV6XCuZW
	 nUQKFJhnG7hHgFVLRedzviD/gVKzGlwpdpO9qe70CIo0UlC4ewPez00qVzSbKMHjBdZQD
	 L6EEynabVG7Y/AGBo69DHcurrvS98VUcacVv3Wdegma05NUzqOAhNTFV9/BhCHhTDMmU9
	 TQCFU8dx1ajxqZdTgGqqgT2JXEEQTOjbuamE2rzo90Kw47Yox4eneFxVJ8nApWZUM0A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="eB3B/OeX";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACB23606A32A;
	Wed, 18 Nov 2026 21:29:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eB3B/OeX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF70F1F000C4;
	Wed, 18 Nov 2026 21:29:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795037383;
	bh=QJzQmRA9EAmMtb+9wy6TAVc5ZFGg6uAj+RxdHk1ab1M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eB3B/OeXjc0iNCP3wsfDXAuO8QzActC2TakPUR7dY8SQ7gBENzoI6HXL55Pu3Ymim
	 uYdyZVgEKkuN7HyaYsdsf5EYMVgOlRA5mYAxMt9yPCkB0TA1PvIvEiSPVnhRdvqN+T
	 miQDYKnZ5SC1eQkI04z0y/YbvH1c5ICBsswh2Lm4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Luk=C3=A1=C5=A1=20Lalinsk=C3=BD?= <lukas@lalinsky.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1342/3318] io_uring/poll: dont poll a writer for urgent data
Date: Wed, 18 Nov 2026 15:32:44 +0100
Message-ID: <20261118150400.632548376@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

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
[axboe: 6.6 sets up the mask in io_arm_poll_handler() itself, with
EPOLLET]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/poll.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/io_uring/poll.c b/io_uring/poll.c
index de7da2bd283a8..2a4b575dbdbbb 100644
--- a/io_uring/poll.c
+++ b/io_uring/poll.c
@@ -742,7 +742,7 @@ int io_arm_poll_handler(struct io_kiocb *req, unsigned issue_flags)
 	const struct io_issue_def *def = &io_issue_defs[req->opcode];
 	struct async_poll *apoll;
 	struct io_poll_table ipt;
-	__poll_t mask = POLLPRI | POLLERR | EPOLLET;
+	__poll_t mask = POLLERR | EPOLLET;
 	int ret;
 
 	/*
@@ -759,7 +759,8 @@ int io_arm_poll_handler(struct io_kiocb *req, unsigned issue_flags)
 		mask |= EPOLLONESHOT;
 
 	if (def->pollin) {
-		mask |= EPOLLIN | EPOLLRDNORM;
+		/* urgent data is an event for a reader only */
+		mask |= EPOLLIN | EPOLLRDNORM | EPOLLPRI;
 
 		/* If reading from MSG_ERRQUEUE using recvmsg, ignore POLLIN */
 		if (req->flags & REQ_F_CLEAR_POLLIN)
-- 
2.53.0



