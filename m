Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061560;
	b=geak5ukvH0w3wph8qNpdPsCD/XwJvrZkhiafWTWZFoFqlYpNZGx7l7bKJy4EiJqUnKM1
	 FZrk5j/bH+TnoiGvo2QJc6HJxAgcShAno5jvLJ3KgmBxMng6Rv3cIGBrPcVWYkhRXA4q1
	 sOiti48Iy11OkkrDVeC9tt+h3tkVC7kt7hXlZruc/Tw88yrjM5Z8FR7CgmzFTd61OibSE
	 WJR6YJL9MldCd/yCOSVwCCCMKh/KNCraeOH0/V3vh+W1dt+vMVe8sh+uezgsxf/ilKXoA
	 XZlE/OTCCWVyAuRoEJpdqWxGpU5UOwWUtNJwfQ3+MD92lyz0Hxu5Ne8nDYwo6Va3TaA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061560;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=YdsvwhUAkxbBeCfTcIuKhYXz3v1/u90t5p5xWXSAgF0=;
	b=ayQoRvwi8/MESZbbiMKBKp4WgiKZ05u3lRZFXd+h240OLUcUosDU5xOoUwV1B17OoFmC
	 pnuQb7jnpE9+ZgZYA+X3qv3WXy4fFWlAUyKIgLyg0jR2doRZW750nWwhicWvWML3BpPiy
	 A1sLkJwzBW2mHrgEhtGO596c5ExbLbI300O0lJfZlHSdn46mx+TE9r3pepq7KlJFHfX9a
	 t1UHBQevnf5zt5n7nT1qXp39XE6jZ2EJvTg8AOgqL3fPR7myuYAVVL4pRRHxIFihjehjm
	 Is2gBrrz7Xe6OGvvwKY/fBgBZlMgTbj+B7EzaSBNoeUdiw9ytzFkbRTUcmmi5y+M16Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rcw296TW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 662D0606A32E;
	Sat,  7 Nov 2026 14:26:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rcw296TW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BBFD1F008A1;
	Sat,  7 Nov 2026 14:26:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061560;
	bh=YdsvwhUAkxbBeCfTcIuKhYXz3v1/u90t5p5xWXSAgF0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rcw296TWL36I5OOu+t0ofzJQJ66nu3oVBcN0J4xFmNiq8WJxjXAq4ZdYiE8RHUhLV
	 HLjnQdArp5RIEcCA2WqOx072lUGerPgxvBlUpSXC97XXUbaulhsoslQaqQlHk/w9oy
	 k1kjT5mG+lgbPyEW083rEhFGgPilRBUiNqk+2gDs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kyle Zeng <kylebot@openai.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.12 0641/1536] io_uring/io-wq: save worker type before dropping its reference
Date: Sat,  7 Nov 2026 08:44:17 -0500
Message-ID: <20261107135015.536875685@linuxfoundation.org>
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

From: Kyle Zeng <kylebot@openai.com>

commit 37e425460b7c41687e51e3254b1eb1d799da9614 upstream.

io_wq_cancel_tw_create() inspects cb->func after calling
io_worker_cancel_cb(). For an existing worker, that call can drop the
last worker reference and wake io_worker_exit(). If the canceling task
is preempted, the worker can be unlinked and freed by kfree_rcu() before
the callback function is inspected. KASAN reports a slab-use-after-free
read in this path.

Save whether the callback belongs to an unpublished continuation worker
while its reference is still held, then use the saved result for the
conditional free. This preserves the existing accounting and frees only
the worker allocated for the canceled continuation.

Fixes: e6db6f9398da ("io_uring/io-wq: only free worker if it was allocated for creation")
Cc: stable@vger.kernel.org
Signed-off-by: Kyle Zeng <kylebot@openai.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/io-wq.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/io_uring/io-wq.c
+++ b/io_uring/io-wq.c
@@ -1328,14 +1328,16 @@ static void io_wq_cancel_tw_create(struc
 
 	while ((cb = task_work_cancel_match(wq->task, io_task_work_match, wq)) != NULL) {
 		struct io_worker *worker;
+		bool free_worker;
 
 		worker = container_of(cb, struct io_worker, create_work);
-		io_worker_cancel_cb(worker);
 		/*
 		 * Only the worker continuation helper has worker allocated and
-		 * hence needs freeing.
+		 * hence needs freeing. Save this before dropping its reference.
 		 */
-		if (cb->func == create_worker_cont)
+		free_worker = cb->func == create_worker_cont;
+		io_worker_cancel_cb(worker);
+		if (free_worker)
 			kfree(worker);
 	}
 }


