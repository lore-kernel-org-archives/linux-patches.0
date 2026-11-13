Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590028;
	b=b8e2dR0VIC87OIQJ/edu5xsH+uY2lhI9kEHqF5dPyfkTvIewHowArJr9JJtQphyY3Nyc
	 aL7XU4GKtQpuRfXmeF5f4BAVqiVCMRFQoKoUjYdyoFo8vEs3jXq2khnbfmucTRPgEvKHd
	 kM+owTg2jMAO84OAHKGJLvLbEvDchrcIYHVTz5cS++wP9CMStyCx2hIBbfQDPuG/QvzqR
	 83KSPIGavy9kdYSjK92io8wmWN/dSiBs0kZxnn1yxg17aP9bPJPntA6Pe1INTGq2klGEc
	 eUi3klZHi6ADbqTuxOoFSGAsjLjJiIKO1E+YmFEoOE8yR0/8YiQNDhXLh4Sm6zbETQQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590028;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=KCmEWRrMxEdh0XwbSbrpZuB40RVnk1l3oz7IFjqtbvM=;
	b=sNduBRmHKVqFdyeqBf+lNJ5QNed+BkH+MzUWRIL3JXlWKNQmXoo7CtCoV2vQXeESIMVp
	 6WEFL1P56rw2RrHlFLpZULCGWlYPfJo6XSkBcaskXKspcF/nHScOK5uQ2jrxn/XsUfsji
	 CYwsnvd6oMMkN+xAh6stID/eAVFzl8vFY0gbm7V81y/c/VWAwmTUZNmVdYl8ppDvDgjrm
	 6hPXCgaU2gIIQJmOS33eNjfOOEukZcch0AfI9SpnF1NKLc7WCpJlc3isFQOEKMmrCBPZy
	 7HIRpDnLSOBsyQ9VS/HI+FEiqXhwLyem5gLYfVsAeDEdPcXkjgq0ArIEpCfE6L0dD9Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ruKGSb4m;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B190360A3804;
	Fri, 13 Nov 2026 17:13:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ruKGSb4m
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E3CE1F000C4;
	Fri, 13 Nov 2026 17:13:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590028;
	bh=KCmEWRrMxEdh0XwbSbrpZuB40RVnk1l3oz7IFjqtbvM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ruKGSb4mRUPZeeN37jqIQF/m0zo56mYB1UEOBQx1WNL2VF3ApnPgFdJq7222SV4AJ
	 TmztAj3L9mWzUB3HvXZDq4GnJpXFuOTydcozyTmq7bhQ4lxeIAJR8BL5vKo0LRbGAB
	 KvvH6rUPso+BNg4i/71zMsuXONFkcpuwrvuOVkPo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Luk=C3=A1=C5=A1=20Lalinsk=C3=BD?= <lukas@lalinsky.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 067/686] io_uring/poll: dont poll a writer for urgent data
Date: Fri, 13 Nov 2026 10:43:20 -0500
Message-ID: <20261113153823.196961226@linuxfoundation.org>
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
index 3239bc3039fb3..2594c1f04e705 100644
--- a/io_uring/poll.c
+++ b/io_uring/poll.c
@@ -736,7 +736,7 @@ int io_arm_apoll(struct io_kiocb *req, unsigned issue_flags, __poll_t mask)
 int io_arm_poll_handler(struct io_kiocb *req, unsigned issue_flags)
 {
 	const struct io_issue_def *def = &io_issue_defs[req->opcode];
-	__poll_t mask = POLLPRI | POLLERR;
+	__poll_t mask = EPOLLERR;
 
 	if (!def->pollin && !def->pollout)
 		return IO_APOLL_ABORTED;
@@ -744,7 +744,8 @@ int io_arm_poll_handler(struct io_kiocb *req, unsigned issue_flags)
 		return IO_APOLL_ABORTED;
 
 	if (def->pollin) {
-		mask |= EPOLLIN | EPOLLRDNORM;
+		/* urgent data is an event for a reader only */
+		mask |= EPOLLIN | EPOLLRDNORM | EPOLLPRI;
 
 		/* If reading from MSG_ERRQUEUE using recvmsg, ignore POLLIN */
 		if (req->flags & REQ_F_CLEAR_POLLIN)
-- 
2.53.0



