Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212172;
	b=1MNhM0oQqy0xaoUYQ2P9xi1MkYe4fpVKnSdTDLxnO35qfnq39mS8nI6E5n0LFfLq8LAi
	 oHO6IwVWcZloroU/ndwM5GVcwUP/F4cAt5xUFhiMt9ixdTS4KSuNtdxcL97PGf9XUxdyO
	 Ydnd0+kQcq8pYkvQ9tYNGTIRD0iLkcf1T5mZql1FIpNCjIhXDZZI3uCDg7UCvVMUCMBKv
	 2C8sfZ3rY9VV1pqlTt6ACgfJ/ZWW8mhnkLQw6UtQlCxelnIPDMJ+zi60z0bIVIhKga6Ch
	 KfMpXxLOjakg3axoF23Y74VZE1dmI7Btl8BNYYH8VZHPs/E2ouJW4uQM6GKYuXHT1Fg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212172;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=OzMs6HDTSJ9H/blTx5lTVgeOEPoF7abor0WCzHNvE34=;
	b=G4lf+5dV1FiUWnmZF0Be41LUw8hIv5cto0CsXFdO9/TwRr5M2MkdWH6f4xw7z6ees+ii
	 89isSBBijKQKWaoukXLmdMFAxoaqB7I3qUjyk7Ws8ouHhyVqU17QrEKdBxEeyBYyFdvAV
	 43gTJtbaME5qxExTdZCGWbmCNoXNEjCAHPb0RLFb6AdPQ4Yv/klz7S/sMREFSFodlBed6
	 SvZGzjnrc7kKhRkjX9k9pT/JBW2M9ZDCJNCxiTmcfLzdFmI/hgF4GNuTnQNAfOLwYqyah
	 Vey/AoCALvO6iRklpqILC07KroFRD6m3E5ik4e69w9lkXpm+BAn6TpZ7Tc2gvS65KOg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WuMMFMiI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CB0E606A31A;
	Wed, 28 Oct 2026 18:29:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WuMMFMiI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F76D1F01825;
	Wed, 28 Oct 2026 18:29:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212172;
	bh=OzMs6HDTSJ9H/blTx5lTVgeOEPoF7abor0WCzHNvE34=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WuMMFMiIyS6F24XDHeHByiLuNSq5lpmf0/StyD0eKo/4IH44Zacexiq4bbPVe/rUx
	 J30hsbTBjG3qvw8k0PCKsqa4+qXVGJ3ekXkxj7m67pnOUUEu3XcjFuIFGqrXW+7wkW
	 7TEus67sibVdVVjZGqq375zjCA9Dz7Pz2mzSaXWM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.1 0019/1887] io_uring/timeout: dont put a sequence target behind the last flush
Date: Wed, 28 Oct 2026 17:35:15 +0100
Message-ID: <20261028170459.658484789@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

From: Jens Axboe <axboe@kernel.dk>

Commit fdfce905a58edea053ee7b68b5bd4348dd1b36e0 upstream.

io_timeout_fn() and io_kill_timeout() bump ->cq_timeouts when a timeout
fires, but its CQE is only posted later from task_work. Until then the
sequence io_timeout() computes is one below the last flush per fired
timeout. Now that ->cq_last_tm_flush is kept while sequence timeouts are
pending, a timeout armed in that window with a small offset gets a target
behind the base. Its distance from the base wraps, and it's never
completed by events, only by its timer. With DEFER_TASKRUN that window
is as wide as the application makes it, as submission runs before the
local task_work.

Nothing but those in flight CQEs separates the two, so use the last
flush as the base for the target when the sequence is behind it.

Fixes: c6c0b3eba88c ("io_uring/timeout: don't skip over reached sequences")
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/timeout.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

--- a/io_uring/timeout.c
+++ b/io_uring/timeout.c
@@ -551,7 +551,6 @@ int io_timeout(struct io_kiocb *req, uns
 	}
 
 	tail = data_race(ctx->cached_cq_tail) - atomic_read(&ctx->cq_timeouts);
-	timeout->target_seq = tail + off;
 
 	/*
 	 * Update the last seq here in case io_flush_timeouts() hasn't, it only
@@ -566,6 +565,15 @@ int io_timeout(struct io_kiocb *req, uns
 	base = ctx->cq_last_tm_flush;
 
 	/*
+	 * A fired timeout bumps ->cq_timeouts before its CQE is posted, which
+	 * leaves the sequence behind the last flush until it is. Nothing else
+	 * separates the two then, so count from the flush.
+	 */
+	if ((s32)(tail - base) < 0)
+		tail = base;
+	timeout->target_seq = tail + off;
+
+	/*
 	 * Insertion sort, ensuring the first entry in the list is always
 	 * the one we need first.
 	 */


