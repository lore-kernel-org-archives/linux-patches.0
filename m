Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590021;
	b=SviAG+tifske3SYi6ycryhqzeM/4IWNXIVXd1vNdjXo9FBHvyO10FfpCuTvBiAfHP2PC
	 ujjBIdCmq2lqLf2w4qAQ3PHEPp2+hJYQhIW14AYa6oZYOiq2CoRlF3nqxuWTL2nRQuJV1
	 a15hTsf8ZByxDRb0Us4FsLxHfyGOKvxYXTODzRuYzyKqR/3Jxy7L67VH6cDcq7ejTDok5
	 J0W8p32NBXHDz/3bJhQee6fB8A99Hb2kVhbGg4hQVbfihunQuHFQKTWOCYTQ3kmAgkrmV
	 7RFlKS6j/dlz/wRJOSsN/Aygmt4ER/rSzBQPS8oBm8LuUmq7yz6KvhXAYLkVkg63ecw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590021;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=e/hhQX9xxXjN4HVqrD2kNHJuUC3JoyGRrIQQHAnVzGo=;
	b=TUrTCGiYCSmJxxjt3ihJHk9/AmhBIhFiS9gdk1yW1H76NjcMCd29w9a+d34nh7G4bBZG
	 auctw8bjN/mtT1n2+46v8pEsV7Bb4OCgdmH8U6SU8clbUdkNhsQQavwm6z4h1A+6QK5A8
	 Ch6eEfkkSZn/IM2U7oHnk1rlasZyl7hLykDwQNO9/UdEiZNLay2e7XdXuV7A7Auibmjgl
	 l182vgJmfjYq13IOwnikbZwmNyqHTYgPSJzSqOTRJGP9/DfO79Q2Beo5C0fMDx5VBb/SA
	 2esDpj/v/aREUdJrs5v4wz3A0aJUNiDheDVaYrTcLL0uVwYNCdsr4abWuy+Ydbg9QIQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oH54jiWF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53960606A8B2;
	Fri, 13 Nov 2026 17:13:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oH54jiWF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0048E1F000C4;
	Fri, 13 Nov 2026 17:13:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590021;
	bh=e/hhQX9xxXjN4HVqrD2kNHJuUC3JoyGRrIQQHAnVzGo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oH54jiWFG654oI/iihhcuyQyYp9GT/cpGLV0U7oX19kJeLUYSCxx8t3KD/b9Hw/kG
	 FQ7WDIlUVbYQlw+fNTFCT1kZj25rPuurI/7F3Z+2Nymsqym2AJLASG59FA1dShhRAk
	 de8FerjAZD5r/mm7Iu4y/XQ597FTWUUTfwQLkRds=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+675af112519ca34f5502@syzkaller.appspotmail.com,
	Shuai Liu <847807867@qq.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 062/686] io_uring/sqpoll: dont set IO_SQ_THREAD_SHOULD_STOP on thread exit
Date: Fri, 13 Nov 2026 10:43:15 -0500
Message-ID: <20261113153823.040716567@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shuai Liu <847807867@qq.com>

Commit fca3ff9e2eee7d285585daf51942e0b5e2be354a upstream.

io_sq_thread_stop() carries a WARN_ON_ONCE() asserting that
IO_SQ_THREAD_SHOULD_STOP isn't set yet, i.e. that stopping the SQPOLL
thread is never attempted twice. Since commit 22d9db9fd64a
("io_uring/sqpoll: don't attach to a thread that is canceling"), the
SQPOLL thread itself sets that bit on its way out, so that
io_sq_offload_create() won't attach a new ring to a thread that is
canceling.

When the thread exits on a fatal signal, the bit is thus set before the
ring teardown gets to io_sq_thread_stop(), which now triggers the
warning on every such exit:

  WARNING: io_uring/sqpoll.c:88 at io_sq_thread_stop
  Workqueue: iou_exit io_ring_exit_work
  Call Trace:
   io_put_sq_data
   io_sq_thread_finish
   io_ring_ctx_free
   io_ring_exit_work

Introduce a separate IO_SQ_THREAD_EXITING bit for the thread marking
itself as on its way out, and check it in io_sq_offload_create() along
with IO_SQ_THREAD_SHOULD_STOP. IO_SQ_THREAD_SHOULD_STOP regains its
original meaning, "a stop has been requested", and the WARN_ON_ONCE()
holds again.

Reproduced with an SQPOLL ring and an immediate fatal signal: the
warning fires on v7.3.0+ (22d9db9fd64a present) and is gone with this
change.

Reported-by: syzbot+675af112519ca34f5502@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=675af112519ca34f5502
Fixes: 22d9db9fd64a ("io_uring/sqpoll: don't attach to a thread that is canceling")
Signed-off-by: Shuai Liu <847807867@qq.com>
Link: https://patch.msgid.link/tencent_BB08960D79E0261B5C1EB1E589787734E907@qq.com
[axboe: trim excessive comment]
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/sqpoll.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/io_uring/sqpoll.c b/io_uring/sqpoll.c
index 1c7f84192c0af..1d31a4b1a9aaa 100644
--- a/io_uring/sqpoll.c
+++ b/io_uring/sqpoll.c
@@ -28,6 +28,7 @@
 enum {
 	IO_SQ_THREAD_SHOULD_STOP = 0,
 	IO_SQ_THREAD_SHOULD_PARK,
+	IO_SQ_THREAD_EXITING,
 };
 
 void io_sq_thread_unpark(struct io_sq_data *sqd)
@@ -441,9 +442,10 @@ static int io_sq_thread(void *data)
 	/*
 	 * Cancelation drops sqd->lock while it waits, and a ring could attach
 	 * to a thread that is on its way out. A fatal signal doesn't set the
-	 * bit, so set it here for io_sq_offload_create() to see.
+	 * stop bit, so mark the thread as exiting here for
+	 * io_sq_offload_create() to see.
 	 */
-	set_bit(IO_SQ_THREAD_SHOULD_STOP, &sqd->state);
+	set_bit(IO_SQ_THREAD_EXITING, &sqd->state);
 	io_uring_cancel_generic(true, sqd);
 	rcu_assign_pointer(sqd->thread, NULL);
 	put_task_struct(current);
@@ -514,7 +516,8 @@ __cold int io_sq_offload_create(struct io_ring_ctx *ctx,
 		/* don't attach to a dying SQPOLL thread, would be racy */
 		ret = 0;
 		if (attached && (!sqd->thread ||
-		    test_bit(IO_SQ_THREAD_SHOULD_STOP, &sqd->state)))
+		    test_bit(IO_SQ_THREAD_SHOULD_STOP, &sqd->state) ||
+		    test_bit(IO_SQ_THREAD_EXITING, &sqd->state)))
 			ret = -ENXIO;
 		io_sq_thread_unpark(sqd);
 
-- 
2.53.0



