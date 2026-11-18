Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795051889;
	b=OwVrsaipX6TN2BlqKP6MNzLCfzbJ7s+Jdqxa4iwlH1PvDm8InTKZtHJU1lXyGW0iO4Vt
	 4T+sPXlZw2LurKdWyC6gvKesUCrmzCfAuA28uXb4WpuU++ZUNrqNDlGUxN5ytSWXjqJoI
	 rssz5Aa4+tmTo4hOWIMTz/qKVbv9xnxK5KZJ4LICpuwNJzMLuEx7glWAk5VLOvyj3kYIG
	 lP3K7Mt48K7vPA6WSapHpM8HCWBXaGB1BtoLB00p20oHiZ2A7L+psBEw7ujQQ0gL7cE/A
	 xbUSridTzV7v6I+KiVMUiq1Gy863TrSb9xr17jsY843OpvlzdxOTg57XGU+C3ylXpgg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795051889;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Obcsg8drJxjX5o0lgMWbr5OtppAI8zIhfryK1iUhh/E=;
	b=hKxdSAPNMffb2+3QNXNTR6ezG9CI4C+Ks9IuchB4hBTMKps/skWo/XwrhMV1qZJmWZiO
	 ZODBg5mFPwwCdqWik1Et4X3K/J9kI1QRWprtb9yq5ZpbN8/23os8+aDRAxtL2G3cTSqj2
	 vzvT3/fqNn+LyiHqzOw3Lq1fMl9Piael4nI2NmQYEba3nxluLEgCGUhejditwOeoyTD5U
	 J0bIBWPypbZLZDz/qBrCgF7DW3tPyAuGnGygpiF6E6bZtc7NGhZ9UQeL8RXzWwOVTAMGy
	 Dfz66fKT5DagKyqvBDl8NsyRHkRDMAifS156FB+l00ofiM7Y8KICAza8C3QTEUzfl7Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Z3O31Z1t;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E25060A262A;
	Thu, 19 Nov 2026 01:31:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Z3O31Z1t
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CEB91F000C4;
	Thu, 19 Nov 2026 01:31:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795051889;
	bh=Obcsg8drJxjX5o0lgMWbr5OtppAI8zIhfryK1iUhh/E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Z3O31Z1tMvTeFy5MHA6x2AABU5Nm4WhBF8SXxtB0Y3UTaDEHNVD9rKOC54h3n1MtT
	 oBMQ+QDnRQUXwqyr1xaXeutZjS12B/bZ97Zl3M4/HKZGPbdGdU8tEN0Sr0tCvqpV8V
	 3iNY9He0KUeO0GAy6FXTcHBeir4/bSDBgWnM3/OI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kyle Zeng <kylebot@openai.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.15 0309/2214] io_uring/io-wq: save worker type before dropping its reference
Date: Wed, 18 Nov 2026 15:33:05 +0100
Message-ID: <20261118150022.518691066@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1234,14 +1234,16 @@ static void io_wq_cancel_tw_create(struc
 
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


