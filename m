Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795035132;
	b=uaRYq5a/aJA4iALuPk1xBYE4UKP6SAvDseS8/MNXHoSntK4DqwQtybhqHi5yGLQYLv+s
	 sVeqeo7Ifx5t48Mz67qnh3pkUJwXjR614S2M3SvijnIsI5Qth3yyTfW+7xVDP8F7+dIrE
	 GRl/dHmHE+KWvhFzojhVKvXMl56ITDVNF1pGVT7+t3C8RsiOQZr++qBAnIhMUxJKM3Okp
	 SYAsTswJAeC5uGQFthtM4TqoEBC7Bq3CqFDNUT4c394vJXNjQG/jYyXBCQoB06e8FiXiz
	 mGhfOgh2723iLeLcKAK5EKQ46xWwFuBQ3nt1KMdUmsKCzVdVemhg9zuAK4J6TmxARqw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795035132;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Ej+G/WiyeIq26gd1LCUSACeh7Wb63p+hhYp7VsaNw8w=;
	b=sMx9W9f73Jq6wITDvGj0U1vwwZ/9PXJWd3zd+5syOxWisXR+K6D8O5jdSexztBOz4Vet
	 gIs8kPrjNH8TsXjRQ7FNZoQGT+kGH6HL8xylI0YF9lcYSoeM15cJhDpwL/LyuNnrlEc/L
	 8LDwCpcMLXSMBj5BEDmt0vnIvfeUfOQvtVBgBMiKS4GYhDUazXIL1rftqiDkYrDakC0sc
	 DjLIwOKMl+W+mwxvpZOD79O/76DhdFoSBfP0m0dm6JANvfAdy9KYfE5/+ClGoPgepMMc/
	 qpzphWAEZuE3TfLN7y7lpUrfXt8cEZZBV294mBQlbtV2xDdS07IO7P33k/xRImNyoEg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KKhbr0Cr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A4EB606A31C;
	Wed, 18 Nov 2026 20:52:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KKhbr0Cr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C43ED1F000C4;
	Wed, 18 Nov 2026 20:52:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795035132;
	bh=Ej+G/WiyeIq26gd1LCUSACeh7Wb63p+hhYp7VsaNw8w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KKhbr0CrSBes0HqRLG7DUd4X9j3FaX68d3iyImImShWy4L9Gmyz3qnFrCvOin2W2h
	 vuAaq4NN0sC4V2nNyQUeZ0/JGhIMi6HHG/H9Pg4/Kxc655ylEKoYpQNzqi9Hj5m2NU
	 816+CLOkzvzw58QSV7oZlH8XFJebaZVO2OHmq23M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kyle Zeng <kylebot@openai.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.6 0617/3318] io_uring/io-wq: save worker type before dropping its reference
Date: Wed, 18 Nov 2026 15:20:39 +0100
Message-ID: <20261118150336.316074071@linuxfoundation.org>
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
@@ -1326,14 +1326,16 @@ static void io_wq_cancel_tw_create(struc
 
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


