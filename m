Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061809;
	b=LQdI+kYLPvSrSEyi7KzkflnCOp9N08chk4qj3P2bMDKZXB3vsqWk9bhlkHPBEb4957PX
	 LDyGJePi9AVJGki1Nd2aRo6H+hJzyUWnnyANzT/pvl5Q2tnL5PNBvXa55Sbxbpxwnt8Wb
	 c0cIf+mdY1WuFGX/JXYrQShD4Z/kHplaxnIDu2SCa6ZaYzjC5KQsaftbADbMlIYM96rka
	 leN0u9uFKr1CvdlrmkvY793iXEJ+71Oi/IFfOHmSqm6TjgR5sI9kiIvRoTcTtIocfcpBW
	 Eti0JdGvjBzqlfhLojhpezgvB3KDIofxClBR7d5pMATf4jc1p3K0+G9KJ1dTXvWU/vw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061809;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=F1gt/RQAJDX1iOrPpish8Mey6zSX+TMYVueJOZ13cfs=;
	b=hnzfeyTxnjUcLoDHmMAfbfW+Rsya7JQIaqJiNzgF8+wNsODgUvngB9A5kE65lnEQ8y0i
	 NM4BgDN1gvfX9waSJOIfL4qwEya/D1Uuvt11X0C/PfhLeSYYrc5YzDbxls3O7SRaYCriz
	 OpuUy/2Ohj8feayGtU29Za8nMiQx9FMx+1maxKHLi8/YNzQZAgSsJvrOgcJV4fIE7QqwI
	 irfHkQM5D1wRLyG2lN9TFFQ6lshi9NbMAjo9kGrQvymEW+xxy8bxi2eqdnKgJetbfiFZn
	 Q8UdxTStPQSWYZ2LvUFaiZ8YDpWYiBHA3z0TTGGgEXytuBPaBMiFLeFrZR7v0CI/68w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fVeqPbMi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40019606A332;
	Sat,  7 Nov 2026 14:30:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fVeqPbMi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D31FC1F0089F;
	Sat,  7 Nov 2026 14:30:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061809;
	bh=F1gt/RQAJDX1iOrPpish8Mey6zSX+TMYVueJOZ13cfs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fVeqPbMi7qN4JF4qgc+3+7mnDdqWaDmlhiYcG/gD+6/gqtyj69xTbTc3CcuU/+tLC
	 Z75e8WydmR1agf7WQcvRmrYxHxKcO0P+ILSwgupt6xYjjFovEr0ceY58kBfTWZ1Wmi
	 L8cUZbmxmW/aTTHpnypkPM/B+nfvNd9+tBZmINRM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cheng Yongkang <teel4res@gmail.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.12 0836/1536] io_uring/timeout: count cancelled timeouts in cq_timeouts
Date: Sat,  7 Nov 2026 08:47:32 -0500
Message-ID: <20261107135021.028469506@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
[axboe: 6.12 uses a regular spinlock for ->timeout_lock]
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/timeout.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/io_uring/timeout.c
+++ b/io_uring/timeout.c
@@ -303,6 +303,9 @@ int io_timeout_cancel(struct io_ring_ctx
 
 	spin_lock_irq(&ctx->timeout_lock);
 	req = io_timeout_extract(ctx, cd);
+	if (!IS_ERR(req))
+		atomic_set(&ctx->cq_timeouts,
+			   atomic_read(&ctx->cq_timeouts) + 1);
 	spin_unlock_irq(&ctx->timeout_lock);
 
 	if (IS_ERR(req))


