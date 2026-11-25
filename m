Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795618401;
	b=gBJ8/DxYwtFmuHvNTreABXGXhPolUyKmemsbJ88K0wtugbq86gAkUuD8x5Mj+7+CR1in
	 FHyuoc/TXWPouyySw+oCut51Qr8CoUv71I0TvBJ66bwf2td0++tb0fxTZTpPzFp0B7tmV
	 4sE5etqytuhfg4Dy+2Nd4YZQqEfnCxjg07qm0n+CU7Nm0kpwbwzbdvVU1TKNA9hODnoP0
	 x+Uamrqdzx9591BALszKJd98ykiD7ZfQNIV5w8Ef7CG5rgGyWcaL9xVIv+txvjqQvASo/
	 anEX0Eo18KxezVC+Socr5LBtpbCD/BnFqYzq/D1HCdiZWHbaVTzSDtXzYPi1RHRsYnQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795618401;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=XW8x7JWJjosEiRNAQoDPH6we+pFSDoAfXVu7olGFj+Q=;
	b=pYzo1+lDFfWLlBi3aKN9S66KYo4Ceq1I9xMH59qeroz2SzvZDJ8r6zi4/weRUK4rOAuv
	 iwaECSHVIgGhCQV45er7GiANm2ekLfYA3Nr4mKRI93vtbN0769CGewJ3Zj6+2hiZUlKKY
	 EGwFvqg1aD+5Y5Zde9CVyaJvVrRcMYte3XmpxUp+LRYRTqNFaf6gRKr5eHWNnxQxJe0ZX
	 bGi6Ocy7zXE3JKnHUFn0lMs+zo6B/IAu+mkTNa1B2oM5IYlkAUquBc8KX9C4zOm3O9zRr
	 03IRyG49NdV3G2hZMXJPi7XJJp0CXlLt38Sk6k+UEt7z7E+ZE62ixzXb8lirdim9tfw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=B8cJUnwt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45D4A606A31E;
	Wed, 25 Nov 2026 14:53:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=B8cJUnwt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 553451F000EE;
	Wed, 25 Nov 2026 14:53:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795618400;
	bh=XW8x7JWJjosEiRNAQoDPH6we+pFSDoAfXVu7olGFj+Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=B8cJUnwttOERWCEh0NgMrBrieQy3YpZycb3YLeTMsy1ie744EC/YFrnyFrArMgoji
	 TByq2+8t43GeVRvlzEBovxauDZVG7/fe/AKOnAXD+9YOxObROA+nYkcX4ZdLvLOOxl
	 s9rjlcMtV4p8WLB+6ukwg9r1y6MhKc7aVWpYpecE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Sagi Grimberg <sagi@grimberg.me>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Chris Mason <mason@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0261/1005] nvmet-rdma: queue the release work under the mutex
Date: Wed, 25 Nov 2026 15:26:39 +0100
Message-ID: <20261125143827.852866240@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chris Mason <mason@kernel.org>

[ Upstream commit 80095787f776967361cca76357f19e5445e0cd75 ]

nvmet_rdma_remove_one() takes the queue mutex, unlists each queue of
the device and queues its release work, then flushes nvmet-wq. So a
queue that still holds objects on the device must either be on the
list or have its release work queued. nvmet_rdma_queue_disconnect()
breaks that: it unlists the queue under the mutex, drops it, and only
then calls __nvmet_rdma_queue_disconnect() to queue the work. A device
removal in that window finds nothing to wait for, and the release work
then destroys the QP and CQ share on a freed device.

Queue the work before dropping the mutex, as nvmet_rdma_remove_one()
itself does. That's safe now that rdma_disconnect() no longer sleeps on
an iWARP event that needs the same mutex.

Fixes: f1d4ef7d8883 ("nvmet-rdma: register ib_client to not deadlock in device removal")
Cc: Christoph Hellwig <hch@lst.de>
Cc: Sagi Grimberg <sagi@grimberg.me>
Cc: Chaitanya Kulkarni <kch@nvidia.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Chris Mason <mason@kernel.org>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/rdma.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/nvme/target/rdma.c b/drivers/nvme/target/rdma.c
index a1914f9a1b30f..e7dbfa383c57d 100644
--- a/drivers/nvme/target/rdma.c
+++ b/drivers/nvme/target/rdma.c
@@ -1745,17 +1745,17 @@ static void __nvmet_rdma_queue_disconnect(struct nvmet_rdma_queue *queue)
 
 static void nvmet_rdma_queue_disconnect(struct nvmet_rdma_queue *queue)
 {
-	bool disconnect = false;
-
+	/*
+	 * Queue the release work with &nvmet_rdma_queue_mutex held, so that
+	 * nvmet_rdma_remove_one() either finds the queue on the list or the
+	 * work has already been queued.
+	 */
 	mutex_lock(&nvmet_rdma_queue_mutex);
 	if (!list_empty(&queue->queue_list)) {
 		list_del_init(&queue->queue_list);
-		disconnect = true;
+		__nvmet_rdma_queue_disconnect(queue);
 	}
 	mutex_unlock(&nvmet_rdma_queue_mutex);
-
-	if (disconnect)
-		__nvmet_rdma_queue_disconnect(queue);
 }
 
 static void nvmet_rdma_queue_connect_fail(struct rdma_cm_id *cm_id,
-- 
2.53.0



