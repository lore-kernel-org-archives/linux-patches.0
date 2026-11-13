Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590027;
	b=aztNSRawhnLxlSPlRN78UoUTaOkfdpt7Cfog9Vuww3uyGKdjrRgj3cinH39Ec4dHq9Zz
	 Nboc1xqBZOGv/4wfw+L9vy6veVmD+TYVeNG/RIbnC4GXiw5UZI3LKUM5J8zISx/of4r2y
	 1a6WzMcjN4a7nT2ZCyrpqSKCcN4zasoZshwQN6tG1wmIv7K4+CWfpu723fQtKux871ezN
	 kQdXAJeHP7vTPvsNLxJv+Dpa/POhchf7eWloI3BsqBEdiOekeJDX1oJ8MrJjLKSWn5Ptt
	 u9IObyOmJjMeUMUHPr91+zk6JeQLceDAWY69s0QBYPmBTYkLtViih9KvcuRn9fegJIg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590027;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=x9rQQhAZTsjVUs2FL+itzUhZSCGb8vsEQItV2+TkXH8=;
	b=QMpiXrOjoAJRgy0Pnq+eWzg9Xd4lz1Km1VlG9VimBvuYJEzVMQcIh4QOdhBIUyoNpTYh
	 jvoqC/HcPs8COl1b8lvUiLEYlyNED4DCFbq4rS3vj7KCJNO9t5e/GkQ6Ngjl3LUwKclYe
	 m7pqBYuX/ScUg/L/Rup/IifaFJzIL2R/NwD/mqO1yl64eoMH5gadZW0CVaKcHfRcP+smb
	 R5PDv/5uu27ZmL3C0M40dKURx4+cjQH0oc39yKi6iujTolH6++U4AiJ4fxbr0O/d9jL4n
	 c5Az3q5O1Zxj89wheDj6eoYWBupSIOCTBUo6oLFlUC71qK99NQuK7Wbh2pmGgpzSvqw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=paFepDfm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86D1B60A2602;
	Fri, 13 Nov 2026 17:13:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=paFepDfm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25BE91F000C5;
	Fri, 13 Nov 2026 17:13:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590027;
	bh=x9rQQhAZTsjVUs2FL+itzUhZSCGb8vsEQItV2+TkXH8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=paFepDfmmhZre+dy3WVmiCI1ARO5oCxErT0lrHoDYvj7YkQkXRkCv8ro3jo/bTsGV
	 BL2iC2NL9Qqazl/HxWsUkJYi/rpwLEHXiUNGhqZExjM5dqAJEBEb+d2FP4iYW3sTy+
	 2tharNj4Vw1fvPqAULsr2c2XN/ue9M4ISNBpeh+o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Luk=C3=A1=C5=A1=20Lalinsk=C3=BD?= <lukas@lalinsky.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 066/686] io_uring/poll: dont poll a writer for a read side hangup
Date: Fri, 13 Nov 2026 10:43:19 -0500
Message-ID: <20261113153823.166262863@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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

Commit 74c1f1048e4401d6a953ab2299b14ace1ad6a899 upstream.

io_init_poll_iocb() adds EPOLLRDHUP to every poll, including the async
poll of a send that waits for buffer space. Once the peer has shut down
its sending side, the socket keeps reporting EPOLLRDHUP, so each re-arm
in __io_arm_poll_handler() finds a ready mask and the request is issued
again. The send still can't make progress, the request burns through
APOLL_MAX_RETRY in a few milliseconds and ends up in io-wq.

A send in io-wq blocks until the peer reads, but sendmsg and writev go
through ____sys_sendmsg() and sock_write_iter(), which turn O_NONBLOCK
into MSG_DONTWAIT, and the application gets -EAGAIN for a request that
never asked for a non-blocking send.

Only add EPOLLRDHUP for polls that want to read. A peer that stopped
sending is no event for a writer, and a poll that asks for it explicitly
still gets it.

Fixes: 464dca612bc6 ("io_uring: mask in error/nval/hangup consistently for poll")
Reported-by: Lukáš Lalinský <lukas@lalinsky.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/poll.c | 18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff --git a/io_uring/poll.c b/io_uring/poll.c
index 6af64c7618e5a..3239bc3039fb3 100644
--- a/io_uring/poll.c
+++ b/io_uring/poll.c
@@ -128,12 +128,24 @@ static void io_poll_req_insert(struct io_kiocb *req)
 	hlist_add_head(&req->hash_node, &table->hbs[index].list);
 }
 
+#define IO_POLL_UNMASK	(EPOLLERR|EPOLLHUP|EPOLLNVAL)
+
+static __poll_t io_poll_unmask(__poll_t events)
+{
+	/*
+	 * A peer that stopped sending is an event for a reader, but a write
+	 * only poll must stay armed until the file is writable again.
+	 */
+	if (events & (EPOLLIN | EPOLLRDNORM | EPOLLRDBAND))
+		return IO_POLL_UNMASK | EPOLLRDHUP;
+	return IO_POLL_UNMASK;
+}
+
 static void io_init_poll_iocb(struct io_poll *poll, __poll_t events)
 {
 	poll->head = NULL;
-#define IO_POLL_UNMASK	(EPOLLERR|EPOLLHUP|EPOLLNVAL|EPOLLRDHUP)
 	/* mask in events that we always want/need */
-	poll->events = events | IO_POLL_UNMASK;
+	poll->events = events | io_poll_unmask(events);
 	INIT_LIST_HEAD(&poll->wait.entry);
 	init_waitqueue_func_entry(&poll->wait, io_poll_wake);
 }
@@ -1003,7 +1015,7 @@ int io_poll_remove(struct io_kiocb *req, unsigned int issue_flags)
 
 			poll->events &= ~0xffff;
 			poll->events |= poll_update->events & 0xffff;
-			poll->events |= IO_POLL_UNMASK;
+			poll->events |= io_poll_unmask(poll->events);
 		}
 		if (poll_update->update_user_data)
 			preq->cqe.user_data = poll_update->new_user_data;
-- 
2.53.0



