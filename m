Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585347;
	b=KK0dRX8siJH4sEaF4Loz50bBs7Wyg7bqo1a2kMmN0thyH7wBuXHNrNvaIGEAsurDqsk/
	 vnE1SH7dmgCduQriOtgcUPAWablQ8Rypw7DGbhhKal/Wns7h/cYFgkfs55ETxQyH10B3N
	 FX2IrMd9l0wII7tfWOiMZFtJpuWTJha1BAEXpGjYv3OhHtAqD+y4Aa/wsyYEckGGw12RX
	 6tnD2gUAe+jDSw3o0al9geDrphnZbQMAYe+pmL4kRkbH0XTfnQ5296ZxTBlF9C9AyWlk4
	 K+4UySrqUiYhYIKwWkInENKUX2iaKYFqZK2c0u3yWq02d6GHWUX/sHTSVYJqfeYPQgg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585347;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=HtozaLtVVk9WASVdLPl49liyZN2sXEZeY/rG5nMsasU=;
	b=4Hh0wVtKcmjz0gej1+1Mpf01p2grIBo1h44/U/dZUVU8xudj4vJH8LFTwWEssyq6VSkq
	 LQFjVJ/627F0BPvbtj7i8eg3N9zQz8Hp63Rf1POnOLYpsNZ53NiMonkhC7y4mO/xiUmzy
	 ErzUPV59RdFt3oukuqJilKV2pFs3ZC30X95EuwWbUKvxzoXaTlnIE/eUKS0girPwY86ds
	 kE5FgmZXPKFUB93aFGk8GEs6LhyH9lEK5lxPVCYgx+AM4k7C2eAS5i/0EFlvmWVLmMuOw
	 auUxHKMemv5+FLIGGQDb0/n0J5b5ZamCbN6T4A3UGdump0wrf2s5NYVv5yVaS6sMefw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xVPw1BSe;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E20560A3810;
	Fri, 13 Nov 2026 15:55:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xVPw1BSe
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32B671F00AE3;
	Fri, 13 Nov 2026 15:55:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585347;
	bh=HtozaLtVVk9WASVdLPl49liyZN2sXEZeY/rG5nMsasU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xVPw1BSeTOJWC/VBrBW2SCJk/sB2VPpD+N9XMTxG9XdToCMLyXWFn7dGx9FDNNhC4
	 9JQNquZf110mC1+r11S6wdSk+weU5R+acKwghl/9iO6HTFWSBo5WfRg734PGwrCqQI
	 aUwYekQ8aScA4IU0aW8o4qZ12K5fqpIP+DuOOwGo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Luk=C3=A1=C5=A1=20Lalinsk=C3=BD?= <lukas@lalinsky.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 029/507] io_uring/poll: dont poll a writer for urgent data
Date: Fri, 13 Nov 2026 10:45:33 -0500
Message-ID: <20261113153754.368167084@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/poll.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/io_uring/poll.c b/io_uring/poll.c
index 9703a2fdfb44a..fc1800c7097b5 100644
--- a/io_uring/poll.c
+++ b/io_uring/poll.c
@@ -739,7 +739,7 @@ int io_arm_apoll(struct io_kiocb *req, unsigned issue_flags, __poll_t mask)
 int io_arm_poll_handler(struct io_kiocb *req, unsigned issue_flags)
 {
 	const struct io_issue_def *def = &io_issue_defs[req->opcode];
-	__poll_t mask = POLLPRI | POLLERR;
+	__poll_t mask = EPOLLERR;
 
 	if (!def->pollin && !def->pollout)
 		return IO_APOLL_ABORTED;
@@ -747,7 +747,8 @@ int io_arm_poll_handler(struct io_kiocb *req, unsigned issue_flags)
 		return IO_APOLL_ABORTED;
 
 	if (def->pollin) {
-		mask |= EPOLLIN | EPOLLRDNORM;
+		/* urgent data is an event for a reader only */
+		mask |= EPOLLIN | EPOLLRDNORM | EPOLLPRI;
 
 		/* If reading from MSG_ERRQUEUE using recvmsg, ignore POLLIN */
 		if (req->flags & REQ_F_CLEAR_POLLIN)
-- 
2.53.0



