Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795044409;
	b=rDOGxEnA7Vkr1CXHZWK0yivLOrDheKwTHlHgOBjsVEVXZ+curbTSQptXqtLK0p2klVZ5
	 3DBgxqQs28RRiMZNUCm7n/FzuFmviV0OqHYiepfbehP5/FeZ+SEOzzb84+ZULx4FWPZ2M
	 XezTGSytOvCXgyJSb9l9s0zR4QtPoYaANb3h2TaFq6/Ou3o22/dHykWr0NiNpTzYIBZat
	 tKyWSQC2OUBb2JQtqY+NRIzNqa8iatxiqZ0wKuTqtiCXvbjHCfWJVnWv1cNmKCdb/qOHB
	 H84/VHiHvChk8bLs0wwte4RBbpaiI2XcKcUwbzy9fDA2XFMm0Z60/bDO7l72Yp8yLdg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044409;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=f2MUV8FJ0C1BvIzG0tn5ZrW2TU8bRzEJFRw7oHCTr1A=;
	b=0qnUGOrl8ORSfejDzH83OgrnRjRTT+fYhUvdSxdiRgWUhD6cCTOdKMO0WBI6H60S4+ai
	 CkxYNyMgmgsRznv2z37yvo2ZhA6aqqrQNsPAPoBjDYHE1ENmByXpWQcpI8zSmi5OWgMFV
	 rDFOH+SeNVqs6ROtcRdJ36a6CxdAq+ZgXTaq1jGtgWj1ppLR2YQW1+F084rzVny7OZIAD
	 D9tnCzYQwsmEt9Jc2B2JDxmLiZWZJa4KIkuwL5S411c0TUUDB/ZaEhayWkrmadg/iqgMN
	 JMpXGKAH22oqbhJEANtIoTjKW5xHHQN9NugVq+ES3eOq1CxXUd429OD0rSFJTaz6+/Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OsX6l4aB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6645606A320;
	Wed, 18 Nov 2026 23:26:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OsX6l4aB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7B8E1F000C4;
	Wed, 18 Nov 2026 23:26:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795044409;
	bh=f2MUV8FJ0C1BvIzG0tn5ZrW2TU8bRzEJFRw7oHCTr1A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OsX6l4aBhlzxDmMaUMNapadSxlzWkU5XgIt3mFZwXskyKCsFdGHBB4Na61gW/AjeG
	 fLRC5pt6VgTImpP8pbfIwuFA77c86b4Vx4fM0yQU+k5qT2yEDrOOgxv6yo2xjfGLXt
	 yywFzJ7viTg6lZNu3eqSVT3d0n+WliCytLUSL48E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kyle Zeng <kylebot@openai.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.1 0556/2857] io_uring/io-wq: save worker type before dropping its reference
Date: Wed, 18 Nov 2026 15:26:30 +0100
Message-ID: <20261118150221.509957881@linuxfoundation.org>
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
@@ -1343,14 +1343,16 @@ static void io_wq_cancel_tw_create(struc
 
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


