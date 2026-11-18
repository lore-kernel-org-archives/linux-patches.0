Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795046050;
	b=ysUijYrn3qKBvIAziwOfCl0P6Ovg8yE0gRZuWSUUqEDw9xJuBvnYR1glWQ12gFvha3oz
	 grqvjov2NvufSkJhWDbA9DCBsk2S12nBTcUIoKj2+vG8hvpbEoaBO1QMwb4lbulMKJl9E
	 D3RlD0YaXFh5XTbuMLolOekLjPlN6rnwmTmCK2RkC4kUMH3M3UA7JcWCwOngGhRFlyP+n
	 4Sp4W0jY2osxSnvhwLk0H9Zkiprfo7WhFyCDXnpv28InQgLPb1D67X2WTSjXAaupUjY78
	 845CFN7ZB7JMQddfOJkEvUxXMuqN+dpEwrTISqqWEqC3QK9FJIJWL4ugosL3tY6x6hQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795046050;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=xQaWigHxksZDoM+yf/yq+lnf/OhaN4gpGkRXfrAycQg=;
	b=FddSKo79JH/IvyUBGpoeDNU57rh4wYo/JzC3WL3xMGnt4ZXTzzlNBveXvPZ5s7z0ufqS
	 QxZSl6r+D2ih7l++WxM296gjY9u4E531k7dzfFX3PZg3ib+47j95y5vfQFOqFHhAOFETD
	 4eAXgwKxMzwMnNieJQq6R0Q4MgAObHxUA1DKHkCFvmpg5WIiFz2nj4sqYFwZEcJYRjANk
	 YE5hxrVGeMKx0TM6qc1b1jRGFsruRBFTUWKs0p/Zn25IZLIc6Bt1omBaUB5wToz/p4hgf
	 nC0Rm8b9ZAcyP956mVLrSuRNi9CUvV9iwVm1WDUef11B4ndPoO5EPcdV4NK3DO1/ogQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pgpqehKp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7491606A31C;
	Wed, 18 Nov 2026 23:54:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pgpqehKp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D9BA1F000C4;
	Wed, 18 Nov 2026 23:54:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795046050;
	bh=xQaWigHxksZDoM+yf/yq+lnf/OhaN4gpGkRXfrAycQg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pgpqehKp1KVSHdbNntLK4xbPeOKT38vfBA9JnAAs8plaEFOU8uB7ET7vjP8Eo7t/8
	 K09MFOICgIpv8NcPwshIP1pSVQt4ovW737islRT0Fw4kYLWZYXP0pBBBMdQh9SRCfV
	 7kOqEW88Uf0bm/wYin3woGzgYkbmWYWBYmJ95xEM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Luk=C3=A1=C5=A1=20Lalinsk=C3=BD?= <lukas@lalinsky.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1143/2857] io_uring/poll: dont poll a writer for a read side hangup
Date: Wed, 18 Nov 2026 15:36:17 +0100
Message-ID: <20261118150242.739716678@linuxfoundation.org>
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
[axboe: 6.1 passes the wake function to io_init_poll_iocb()]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/poll.c | 18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff --git a/io_uring/poll.c b/io_uring/poll.c
index 2b4c3550c455f..aa7ffce3a2958 100644
--- a/io_uring/poll.c
+++ b/io_uring/poll.c
@@ -164,13 +164,25 @@ static void io_poll_tw_hash_eject(struct io_kiocb *req, bool *locked)
 	}
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
 static void io_init_poll_iocb(struct io_poll *poll, __poll_t events,
 			      wait_queue_func_t wake_func)
 {
 	poll->head = NULL;
-#define IO_POLL_UNMASK	(EPOLLERR|EPOLLHUP|EPOLLNVAL|EPOLLRDHUP)
 	/* mask in events that we always want/need */
-	poll->events = events | IO_POLL_UNMASK;
+	poll->events = events | io_poll_unmask(events);
 	INIT_LIST_HEAD(&poll->wait.entry);
 	init_waitqueue_func_entry(&poll->wait, wake_func);
 }
@@ -1116,7 +1128,7 @@ int io_poll_remove(struct io_kiocb *req, unsigned int issue_flags)
 
 			poll->events &= ~0xffff;
 			poll->events |= poll_update->events & 0xffff;
-			poll->events |= IO_POLL_UNMASK;
+			poll->events |= io_poll_unmask(poll->events);
 		}
 		if (poll_update->update_user_data)
 			preq->cqe.user_data = poll_update->new_user_data;
-- 
2.53.0



