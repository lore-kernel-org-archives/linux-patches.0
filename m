Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795028131;
	b=iRhjcyabV6ahwSDR9eRLB/+mRRr4j8oylxL6TpVyVr4i9B6ek62P7Hd/Py25weAevjW8
	 NG8YkgTLJ2vHY0oEqsQr+vzonmm0FQVXHwsBlHtY6ILKBM5NAoh+s8j5LmLDesDTGhCKm
	 eCxXAqCrVXlSutxWR0N94Icri1/FttmX4qrvpeawSDILA6vOun3D1VSFh1U0Jdn/0gV/9
	 fZhfihUQZ5+5J1jFGJKTpGQTp4E3kIKLD9jmliaXDuin93oZvQxaOf7Yl4Bd5aLrxuyzB
	 hF8rd2h6Mdrembl2R22O0FMtC1tJfmrQoQPVgQMBZTmod3Mf/vKtwjGPGpwqcIvZENw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795028131;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=chfBcE0+kmYADn6p/K09l+9MJoaMAVmRwVXfO/D+kNg=;
	b=aQ3q8GF8/Q4jmjtM0O0FK8biWf1oeKv4+Kjq1neea4Wzt8llISeFaCwk9CMs7Nf4wndB
	 kaEyMfCfzqugqouk8J2Pm8qzdySN53qmMb7DJH+lkFdwQ2kLS6r8NHxWpZ+i9sZaU/15J
	 zQZE1pWAFfCn2nZCCvsnCPvN8xlS/VeP7HGAOZAmpSD+oVcnetRAVgoiCaNCaGD985+WT
	 lnYnidfGUvN0sdVRlNWPg3zEKuhz9Gt+C6ZA0GvbYU8d0j0If0ADa8KT2I24LHHngGI5O
	 lF4DwoBOnB1g1oJReWXAL+lQKldzhPsC+dP0DBAabbmTf+kHD/zbUFTjKBkKuCo9ZZw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xKhWed03;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C402606A334;
	Wed, 18 Nov 2026 18:55:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xKhWed03
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7C181F000C4;
	Wed, 18 Nov 2026 18:55:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795028131;
	bh=chfBcE0+kmYADn6p/K09l+9MJoaMAVmRwVXfO/D+kNg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xKhWed03kPoyA3hojzIHb7TFvD3YD0iWBZBZgMxgS4+WOyG+/f7o5zWiQpwFcLKkc
	 0pRkIddroF8G/UJEJG7v3aKWTYZTCuPrZh1Dtl+ixN2DXoNc8vhZ2BSkUbHxUjBawu
	 fuZJEtkzUDJ4GajCz4hiPqOXtzxjnx6Npw8GsS/4=
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
Subject: [PATCH 6.18 2035/2151] nvmet-rdma: disable interrupts under rsp_wr_wait_lock
Date: Wed, 18 Nov 2026 16:02:50 +0100
Message-ID: <20261118150235.866256206@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

From: Chris Mason <mason@kernel.org>

[ Upstream commit 14e4e09443ac2b5cd90c1e313ee3c0bdd4928e0d ]

rsp_wr_wait_lock protects the list of commands waiting for room in the
send queue, and it's taken with plain spin_lock(). But
nvmet_rdma_queue_response() calls nvmet_rdma_release_rsp() directly if
ib_post_send() fails, and that processes the wait list. The call chain
starts in nvmet_req_complete(), which for a block device namespace runs
from the bio end_io callback, which can be in hard interrupt context.
An interrupt that completes a command on a CPU holding the lock for the
same queue spins forever. Lockdep over siw with a null_blk namespace:

  inconsistent {HARDIRQ-ON-W} -> {IN-HARDIRQ-W} usage

Use spin_lock_irqsave() for both takers. The processing loop still
drops the lock, and restores the caller's interrupt state, around
nvmet_rdma_execute_command().

Fixes: 8f000cac6e7a ("nvmet-rdma: add a NVMe over Fabrics RDMA target driver")
Cc: Christoph Hellwig <hch@lst.de>
Cc: Sagi Grimberg <sagi@grimberg.me>
Cc: Chaitanya Kulkarni <kch@nvidia.com>
Signed-off-by: Chris Mason <mason@kernel.org>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/rdma.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/nvme/target/rdma.c b/drivers/nvme/target/rdma.c
index 039bf56a00eea..d1b47e6287581 100644
--- a/drivers/nvme/target/rdma.c
+++ b/drivers/nvme/target/rdma.c
@@ -513,7 +513,9 @@ static int nvmet_rdma_post_recv(struct nvmet_rdma_device *ndev,
 
 static void nvmet_rdma_process_wr_wait_list(struct nvmet_rdma_queue *queue)
 {
-	spin_lock(&queue->rsp_wr_wait_lock);
+	unsigned long flags;
+
+	spin_lock_irqsave(&queue->rsp_wr_wait_lock, flags);
 	while (!list_empty(&queue->rsp_wr_wait_list)) {
 		struct nvmet_rdma_rsp *rsp;
 		bool ret;
@@ -522,16 +524,16 @@ static void nvmet_rdma_process_wr_wait_list(struct nvmet_rdma_queue *queue)
 				struct nvmet_rdma_rsp, wait_list);
 		list_del(&rsp->wait_list);
 
-		spin_unlock(&queue->rsp_wr_wait_lock);
+		spin_unlock_irqrestore(&queue->rsp_wr_wait_lock, flags);
 		ret = nvmet_rdma_execute_command(rsp);
-		spin_lock(&queue->rsp_wr_wait_lock);
+		spin_lock_irqsave(&queue->rsp_wr_wait_lock, flags);
 
 		if (!ret) {
 			list_add(&rsp->wait_list, &queue->rsp_wr_wait_list);
 			break;
 		}
 	}
-	spin_unlock(&queue->rsp_wr_wait_lock);
+	spin_unlock_irqrestore(&queue->rsp_wr_wait_lock, flags);
 }
 
 static u16 nvmet_rdma_check_pi_status(struct ib_mr *sig_mr)
@@ -977,6 +979,7 @@ static bool nvmet_rdma_execute_command(struct nvmet_rdma_rsp *rsp)
 static void nvmet_rdma_handle_command(struct nvmet_rdma_queue *queue,
 		struct nvmet_rdma_rsp *cmd)
 {
+	unsigned long flags;
 	u16 status;
 
 	ib_dma_sync_single_for_cpu(queue->dev->device,
@@ -994,9 +997,9 @@ static void nvmet_rdma_handle_command(struct nvmet_rdma_queue *queue,
 		goto out_err;
 
 	if (unlikely(!nvmet_rdma_execute_command(cmd))) {
-		spin_lock(&queue->rsp_wr_wait_lock);
+		spin_lock_irqsave(&queue->rsp_wr_wait_lock, flags);
 		list_add_tail(&cmd->wait_list, &queue->rsp_wr_wait_list);
-		spin_unlock(&queue->rsp_wr_wait_lock);
+		spin_unlock_irqrestore(&queue->rsp_wr_wait_lock, flags);
 	}
 
 	return;
-- 
2.53.0



