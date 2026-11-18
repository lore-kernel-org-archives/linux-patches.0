Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795044701;
	b=CgZdnvkPEqbcT4GHle0xdDxakObIOiAr26ViUxF0X4NWz80qX7Ywg9dEOHlC1dWBKvB+
	 861/mYGOMUErptXxGpb4f6XIQ/ymJI54qVauIT8tC9ZSdcnTmLTUYHm1fsxUIQu7LkQmM
	 hmlwPQm0Qy+hhPUzGsXwJIQN9zwHpqTZKewAgFkuyKOXMFl7YQFvGVxW7B6xfjHoveHNG
	 oiSfzwrXlCYew+zU2VmSXVunMgjo2oQHaXxP3ng85dBEwN7oWcMuiXGHcV8kKUvYb5chm
	 /JkzPS4nF+1QQUKeIgZe+zVihiEIuYKDsOUD+6mGCI/QwMc9xfNxpanUbG6Lyaa/iIw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044701;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/rNfSYOXg93pwZnkiRcG72gPVQokZJYMdwqRNINCEHM=;
	b=sVkR/+2WWd25hZ9MDfdexJHiYd1XooqGFZDH1pl1ng9yQs/Nlnc/IOUf/odKGGzqaABp
	 2scyEQmjAvhld9y8EulNFiheO1s5D8mJ4c/NZCjcHKFlFjSElLJcCODxuIcZS1Oi1c/3d
	 fSP7cDLo/anpK2qLpaQ23ApflttwC51/xj6v/R3JEDBlYHncIpU1/ueQQFhSXYhJlJ64b
	 wptHv+MVnGQjKZGr711sCmYBZfYCK5DuA8rYrpgplvWc4mlyT0pFqNM36NmbXjcR05GBa
	 XxkxpkxeSCv5wlOK7fPtZvDQiPBcTjNZjhx7GNMGAp2ZDKtS2VV6OIp/VoCW//RoIFw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Qt4ouwPA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05670606A31C;
	Wed, 18 Nov 2026 23:31:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Qt4ouwPA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A6801F000C4;
	Wed, 18 Nov 2026 23:31:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795044700;
	bh=/rNfSYOXg93pwZnkiRcG72gPVQokZJYMdwqRNINCEHM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Qt4ouwPA+wmqWfmXYejkCW27vQKC1VbA8+hOGBLiu4tTph+DrUrckEt0OgtU+bqn2
	 LtCUDdDDhSyyIw1lEeOjKughxRq8q9Je9g3aUltGmd1WnQpR7cX/nKBcam4Nrfns8j
	 ydKVx4T3lfmBB9L80j/duU/vQjspA6jPoWfUNXdM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cheng Yongkang <teel4res@gmail.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.1 0660/2857] io_uring/timeout: count cancelled timeouts in cq_timeouts
Date: Wed, 18 Nov 2026 15:28:14 +0100
Message-ID: <20261118150225.318685445@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

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
[axboe: 6.1 uses a regular spinlock for ->timeout_lock]
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/timeout.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/io_uring/timeout.c
+++ b/io_uring/timeout.c
@@ -267,6 +267,9 @@ int io_timeout_cancel(struct io_ring_ctx
 
 	spin_lock_irq(&ctx->timeout_lock);
 	req = io_timeout_extract(ctx, cd);
+	if (!IS_ERR(req))
+		atomic_set(&ctx->cq_timeouts,
+			   atomic_read(&ctx->cq_timeouts) + 1);
 	spin_unlock_irq(&ctx->timeout_lock);
 
 	if (IS_ERR(req))


