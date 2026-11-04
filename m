Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831958;
	b=u3dQsw1TdCL7eN3M2qZLB0y65nrZfcaNzeESfMAsT4ca3I3+KpDegmhQ7Blq7fCd99cV
	 hKUz+BRafcqvb2baEDC9/Nj9kYrjGEl8qK5i0uht09bue83LgT1Hn9tdzlTQ8sTK5C/eq
	 PqS6x7r/QQQboTF+GTKGhzMUaOzipigEGvY76HCa4QjFjdv6yrpafwlEv8K/WlHM8/mdX
	 9ouCH6ZLo7LdFyqBhPMEAY95fkix1nEhj7hh082thdboTw9L+aydKPdFzDgfLyLsAb280
	 Hcfjv8IkZBAKO3qAtPKKkLw4ye8CJR9KsRz7sKxQjdBupuMIeMJFz0phYrNVp8YOeRA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831958;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=aG/5cyztFOcH8kUAr04I+lttdSBH/iBHDUsg2Kddaz0=;
	b=wxyyVZyz9UZlPlYIypVn8Y2kjSSeVgew405wcwSr4uqS53rmskKcVx/TyiiJnnTXqt6e
	 Y0kq68XvpgYCNPgumCrfaA2uXPWh0KoN0wSOMEdDWqd1HpsnavGWmAuFwHR2t2jV7VYbU
	 47A2lpdpA2jI5LpKSOqF0h/rQLXe8PDdvIuvOXxzjLiglDPOS3p1ZZrFCxyF4E0H14ilB
	 0UC4N7gUTfMrytOpYSBw+UrQMXuXipouFFwQnKxmxtQlO6/mYt8JTnlbMh9ITKqRfIWr/
	 dY1W9m3YSDqpmlrop9E6izaXuFuiYw2Ijxez9v033jg0RnJPb5yH2QOVKxM0lA24bPQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=D3ZD+G45;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF3A1606A850;
	Wed,  4 Nov 2026 22:39:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=D3ZD+G45
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A17A1F000C1;
	Wed,  4 Nov 2026 22:39:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831957;
	bh=aG/5cyztFOcH8kUAr04I+lttdSBH/iBHDUsg2Kddaz0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=D3ZD+G45kiUKNalNn1rsSp1782EDf8Yl33Te+uPDU1cpF8HA8MBNlLa1KrBUWIQjg
	 ufSWYSty8KXnaMUJm01qSxPnnFPz7YEABB1sishYsGsAyOdnKYgwntN77/wnNgJaRH
	 /PoAGZA/uBOCXTBYJ4OO0kOGMUr2nYdQJ2INz5RI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cheng Yongkang <teel4res@gmail.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.18 0980/1005] io_uring/timeout: count cancelled timeouts in cq_timeouts
Date: Wed,  4 Nov 2026 16:11:53 -0500
Message-ID: <20261104211110.494623841@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

From: Cheng Yongkang <teel4res@gmail.com>

Commit 1c8b49851543f41fc8bb18bcd1f15cc93d14b530 upstream.

io_timeout_cancel() posts the cancelled timeout's -ECANCELED CQE without
advancing ctx->cq_timeouts.  io_timeout_fn() and io_kill_timeout()
advance it for every timeout CQE they post, and io_flush_timeouts()
computes the number of non-timeout completions as

    seq = cached_cq_tail - cq_timeouts

to compare against each off timeout's target_seq.  The cancelled
timeout's CQE is therefore counted as a regular completion, so every
cancellation makes an already armed off timeout fire one completion
early.

A ring with a keep-alive timeout of off=4 completes it after two NOPs
when one off=100 victim is cancelled through IORING_OP_ASYNC_CANCEL, and
before any NOP when two victims are cancelled.  The cancel CQE should
count, but the cancelled timeouts' -ECANCELED CQEs must not: the
expected counts are three and two NOPs respectively.

Advance cq_timeouts when io_timeout_extract() succeeds, under
timeout_lock and before the -ECANCELED completion is queued, matching
io_timeout_fn() and io_kill_timeout().  The -ENOENT and -EALREADY paths
post no new timeout CQE and keep their accounting.  Both the
ASYNC_CANCEL and the TIMEOUT_REMOVE path go through io_timeout_cancel().

Fixes: bfe68a221905 ("io_uring: off timeouts based only on completions")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Cheng Yongkang <teel4res@gmail.com>
Link: https://patch.msgid.link/179328314078.648427.13761781546953594668@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/timeout.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/io_uring/timeout.c
+++ b/io_uring/timeout.c
@@ -327,6 +327,9 @@ int io_timeout_cancel(struct io_ring_ctx
 
 	raw_spin_lock_irq(&ctx->timeout_lock);
 	req = io_timeout_extract(ctx, cd);
+	if (!IS_ERR(req))
+		atomic_set(&ctx->cq_timeouts,
+			   atomic_read(&ctx->cq_timeouts) + 1);
 	raw_spin_unlock_irq(&ctx->timeout_lock);
 
 	if (IS_ERR(req))


