Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795037373;
	b=PWTt86bp2TD9wXcm9Lp+7EyfOkyecpo/F4zzxqIPDMQyiOZxgmZvHcF/CkFQ+RCUmSzp
	 9AW5JqNuYmrrx9B/RgBiSOFvRvfSu1M+RYqkqJoiLCL7dX7eEcM4axSmBkrood5kJfINW
	 ZJPsKdkrx9SC4RXmav44yLnVUJxYH7nHmhq/4oDKT7SsmMbz52i51Et/sMwpfn31FlDtW
	 HF1cYUspprCusmLi2wTEp4grtFuP/TU3w1TPdCIl2pppCGhNo/4omnG9ioOJQ7aJ5PCEh
	 A6LP+ASCvqPv9JCvfxCsCP1Nw1wIrtN14Z2oIBmo8aAViNyC8jn410I1/WylTgwQ0pA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795037373;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=443P3sobtBYxmNxAcpeovwLUm1Upc1B4u8k/cu9IN8E=;
	b=3gSCPkuXrgqKWjyi5G56og6euivAjvwn29J/8kkPgpKbZY/3LlWYOoUEkNIBKjRmNJ7+
	 KVvta6cloY6Xd9+43RTgV4csLCvuJnAxamuqp7vLGLMdSWAhSo6RROJxAUIjXjmXSS1Fa
	 fR7Ny6Vy1plPA16Vqz4R+LdHlwj0bgz0D3EWejviGQ/1lrXaOdR1nLdR/neG7oc4RunoN
	 FDT4+2Jb2UwIlrZq5j7gMnJIB1xp+3yev568KlLcadpAk5PsqtXBbeYC84qESUvxVTrEy
	 UX4lDhK3xIoqWcrJ9psCVOKIzuU6q6Uv4gXOeH/vWJvQRf9oZi64vjK846iYNVWs7sA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZTcaUafR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E410606A32C;
	Wed, 18 Nov 2026 21:29:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZTcaUafR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 982E11F000C5;
	Wed, 18 Nov 2026 21:29:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795037373;
	bh=443P3sobtBYxmNxAcpeovwLUm1Upc1B4u8k/cu9IN8E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZTcaUafRMaibU62edK3ntMCqqORZ5C2tcsgSK+FQhVuLGY6SN/vaqHZ+uQK65lFcS
	 T2BkLMcGyaKTYdZ5w619QPy0/aV9/tvqG26sN2aOXpniYgKQB1LBVFdM61XMqXh+hw
	 XcAbeMiRLhV7GSERCfALJ/ZZzx08/lB/KVLhaAd8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+675af112519ca34f5502@syzkaller.appspotmail.com,
	Shuai Liu <847807867@qq.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1339/3318] io_uring/sqpoll: dont set IO_SQ_THREAD_SHOULD_STOP on thread exit
Date: Wed, 18 Nov 2026 15:32:41 +0100
Message-ID: <20261118150400.532254263@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index d0f4f05397b13..75065de8d7d3c 100644
--- a/io_uring/sqpoll.c
+++ b/io_uring/sqpoll.c
@@ -23,6 +23,7 @@
 enum {
 	IO_SQ_THREAD_SHOULD_STOP = 0,
 	IO_SQ_THREAD_SHOULD_PARK,
+	IO_SQ_THREAD_EXITING,
 };
 
 void io_sq_thread_unpark(struct io_sq_data *sqd)
@@ -348,9 +349,10 @@ static int io_sq_thread(void *data)
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
 	sqd->thread = NULL;
 	list_for_each_entry(ctx, &sqd->ctx_list, sqd_list)
@@ -426,7 +428,8 @@ __cold int io_sq_offload_create(struct io_ring_ctx *ctx,
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



