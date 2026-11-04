Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831521;
	b=czZm6XC7xdeskZc5mGISjacvTI7uFlyKx/Cas9Belh88YXgLHOSV9Mm/q3mrL8ww1Loj
	 Ch301oksWWoTj12rw0NqoiP/RIKtGmh8zB1b6b0baeiJTz26HAUz203vSp+IkgvCC+N91
	 +ehv5mpLVGKjpmH6Y1aGZS3M7bUZ94XSfaD0OJRgqQK+Zl6U56HxwrirsMAOUOUcRlW+l
	 FXBq8KO8tTxKOAuh92KVSwcth80kXbsBJDUVeZFuQ6ieLcQfqcQdy44/NmKJE4TmYLLw2
	 53YVyuK4g7AKPo5XkW+5rMNnkdBZN5tCe9JbuHtcHD+9Ta4w2ujx4AJ7UN0QLdz6RUQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831521;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=HMMYbKnePe6SVVg/8nHHoGLOzCMxMr6/LIU2hsDOsao=;
	b=oZBde2IZKP6srn+z7EGD/yuJZaigHFRhHcK7Jn0KxFmhmtgCCpfHhqV/k0HIFrFYdvEK
	 qyJWqy5Yuv27Bmpd27nVnbeTEVQCfkB3R5vWzqFdHwscyr9qbIcv8UZ27DOkqbSUG6QMd
	 brqipyPGtZfl/L/TT4j+Scv5jEK+uMIIrD+A3nujX7sMVuRCkhFJRCkvdeLXrH9Gd7UZj
	 T/kpqUxHmtqzOldizEDNZmHSajUCcmmie9GXlgI/b8XFLcPPRrFBAiBW/GZN6iAm8c9hN
	 +W7x8YTStYblaa4BgH+Hnq3QdXynMLSi1k3Hu+Gyq0ilHrkdWLoRusLWKF1kSHmsGaw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CO2qJGSl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E57D1606D839;
	Wed,  4 Nov 2026 22:32:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CO2qJGSl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E93E1F0093A;
	Wed,  4 Nov 2026 22:32:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831520;
	bh=HMMYbKnePe6SVVg/8nHHoGLOzCMxMr6/LIU2hsDOsao=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CO2qJGSl2jiwhn6dvqcheFwC1ZuKvv9o4aC7m5d1u2fPvrNzruUpYAVsHEe0LvGkH
	 mx3fwhSbN+cVXSh/CiUry8+ydVMTNAQTora7w1ae/BxU5Ggt6SbefNDnX90ObW1Qv6
	 1rqsv0kVTyuQlSmaaYNFP4GLVL3IGCagmRXUrhIs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kyle Zeng <kylebot@openai.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.18 0717/1005] io_uring/io-wq: save worker type before dropping its reference
Date: Wed,  4 Nov 2026 16:07:30 -0500
Message-ID: <20261104211103.618838937@linuxfoundation.org>
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
@@ -1420,14 +1420,16 @@ static void io_wq_cancel_tw_create(struc
 
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


