Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590910;
	b=qG2xwZj5orP+OItzvcZa2bhol5iI3SyEMTDzIj/5KFjAihNUmI6LjImJAS7032+ZhzWV
	 W+IPz6EcHypaatJxVQAV5R21Dn18p3tCtp/HYoYjzmF8IJvd3ExVrPev9pHlOTNsjda9B
	 II5GupessasaWy5N0a6i7qhX3a+upC+0bDQKaT84qF+IuVGlDla1cZmHMqjhz1MAGKb4P
	 1pXZ/SKUy3fWcg48SPbpIHRim7BTrgFdS+eSnu+3dPtf7Jy4DL92aB/04GSNVLOXQqBvX
	 69szr+gFOwE0Swz5Tw4OvCx8dww3xJ6X2MXi4Ap/U0SkCTYYaD47yFIiqv/cVReHZ1g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590910;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=X0RL+Ft0aOZi1WXvpxfDH84wiMutg1uuC2aFwaN1hZM=;
	b=fzelgRshtVrr8nMwTgflB+ygDPnukda3h6Z8gRLKn/Fnyz7Rt8MJNsrZlXICUDUqAxIH
	 VqYlriYOvZGA+RO3oG+OI+Z3ZHCfoBOzaz5z+M+MBy09UmPxRk65DVMjjRx4Fwt/M+yFf
	 NTSeoALkqa3cXXXwXe1RFrKuECJzL+FcUfW2NH6gb0ne99oUIBfPhoOMheNHVpMLvQl90
	 7RrbHYVkVpat1O5i/hhbeYioQwnjkXn5K7xu9UYkRzEIF9H9J94XQWJtP0/ClgizjO1E2
	 Gq3+aW1Bhk3b6d1Z4t8lPeLoFl5GmRL1fj7McqJvUZ7VTnwOUsX0EH+jvnjs60Qg1Vw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iDZxvOy3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A198606A334;
	Fri, 13 Nov 2026 17:28:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iDZxvOy3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AF2A1F000C4;
	Fri, 13 Nov 2026 17:28:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590909;
	bh=X0RL+Ft0aOZi1WXvpxfDH84wiMutg1uuC2aFwaN1hZM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iDZxvOy3rXUsm9FmikbkAB+saNK2vzKdIXbIJ99Kmeie7PH4VdbEhw2UbyZiTRRzw
	 ZFiSEyhQaFwWXu5CWnMXuFhSZLzv9jIt5zkzQDohZWeSyyxY1UmtiCCNLkk3cmdD4j
	 mN7/YmsToSDQT+7pHmtlGCebcqZI8TZ/UtU6tr+U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Luk=C3=A1=C5=A1=20Lalinsk=C3=BD?= <lukas@lalinsky.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 057/670] io_uring/poll: dont poll a writer for urgent data
Date: Fri, 13 Nov 2026 10:43:41 -0500
Message-ID: <20261113153813.457211086@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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
[axboe: 6.12 sets up the mask in io_arm_poll_handler() itself, with
EPOLLET]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/poll.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/io_uring/poll.c b/io_uring/poll.c
index 7884ea7b23c5a..c1a9f697a0231 100644
--- a/io_uring/poll.c
+++ b/io_uring/poll.c
@@ -757,7 +757,7 @@ int io_arm_poll_handler(struct io_kiocb *req, unsigned issue_flags)
 	const struct io_issue_def *def = &io_issue_defs[req->opcode];
 	struct async_poll *apoll;
 	struct io_poll_table ipt;
-	__poll_t mask = POLLPRI | POLLERR | EPOLLET;
+	__poll_t mask = POLLERR | EPOLLET;
 	int ret;
 
 	/*
@@ -774,7 +774,8 @@ int io_arm_poll_handler(struct io_kiocb *req, unsigned issue_flags)
 		mask |= EPOLLONESHOT;
 
 	if (def->pollin) {
-		mask |= EPOLLIN | EPOLLRDNORM;
+		/* urgent data is an event for a reader only */
+		mask |= EPOLLIN | EPOLLRDNORM | EPOLLPRI;
 
 		/* If reading from MSG_ERRQUEUE using recvmsg, ignore POLLIN */
 		if (req->flags & REQ_F_CLEAR_POLLIN)
-- 
2.53.0



