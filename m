Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795050635;
	b=jExzF01VgxQrHj5kf8utBC9UQiE6iWb2LzszKrzFKW1NfnstEe12s8B21xRW1S1cz88y
	 HQjTc2Icou2kPTVBoPASAAr5AFC8z6sshdj8m0vsI08gOj5lc0Cm55E//g65Ekzt3q7Nf
	 L+3XtunwdcFU6ivTYUqXD5K0u6z/ChG5kP8o9YOWDCZAT71qeV2ECiBRm+pUA8gJHGE72
	 61yRNLTQvuKZVDaiyemp2fWyi7xcG3Q0Izc1iyEz2zke82+gytoj/4WmX490FCRkNJJlO
	 w7ZmzMW5+VVU353gPYKYtLshdBohQ4+PzINFKW0rbOblUZsPmDUJrjPA0bZNr0CV9Tg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795050635;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4wq3CEBv6tF6YCXI6xkMXf58W+xDAeXaUQOReol3xb8=;
	b=f7sjVWJgJql658zFWnX/al7OulPW44goHdANh4SIzvC8gbxCNXY4fkiNGAwbcx8V1TXx
	 3k/2jTVheoWJMdwjwTsKAcRZZdKjIljFoSzW7Sv/sSiSlp5GxQoL+iU7V82MhmR18uFLZ
	 eoWvTX5W69GV/6NKX1/ALD3QG4uwh585oXMEz0Ny3vsN3yWkTS/6SESkHKSrhizrZVxFj
	 twtrGOHDzQ8potLRbQeOrkKusoSONO80e9WYPANvqyICF+nkxmqpcUy/8E88Jk51fBbuq
	 dJWGnKYCP/QzASoB1q5LxGcvMXNImMcH+qO2DhogQXTmLON84npwNl1PKaInb3UaR6g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hRmBz9d2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64BDA606A31C;
	Thu, 19 Nov 2026 01:10:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hRmBz9d2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCA0A1F000C4;
	Thu, 19 Nov 2026 01:10:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795050635;
	bh=4wq3CEBv6tF6YCXI6xkMXf58W+xDAeXaUQOReol3xb8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hRmBz9d21P45U4I0vTTG2FyZra/VHwOPctyRX3uhtHWtcZqS7ruDIxjGwISn8xYZM
	 oP3wD14atya2atuvl6P9uUeIYY5IluiWU8gdygFsGv7kQWzbMuNNX1Ob1OlRO8bsFX
	 IILF97xXDdwN8JkCgNvZ36SobE/IjIpWPhrOezsY=
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
Subject: [PATCH 6.1 2778/2857] nvmet-rdma: disable interrupts under rsp_wr_wait_lock
Date: Wed, 18 Nov 2026 16:03:32 +0100
Message-ID: <20261118150341.628480317@linuxfoundation.org>
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
index ab74f9d800e03..84ed94dbf9701 100644
--- a/drivers/nvme/target/rdma.c
+++ b/drivers/nvme/target/rdma.c
@@ -514,7 +514,9 @@ static int nvmet_rdma_post_recv(struct nvmet_rdma_device *ndev,
 
 static void nvmet_rdma_process_wr_wait_list(struct nvmet_rdma_queue *queue)
 {
-	spin_lock(&queue->rsp_wr_wait_lock);
+	unsigned long flags;
+
+	spin_lock_irqsave(&queue->rsp_wr_wait_lock, flags);
 	while (!list_empty(&queue->rsp_wr_wait_list)) {
 		struct nvmet_rdma_rsp *rsp;
 		bool ret;
@@ -523,16 +525,16 @@ static void nvmet_rdma_process_wr_wait_list(struct nvmet_rdma_queue *queue)
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
@@ -980,6 +982,7 @@ static bool nvmet_rdma_execute_command(struct nvmet_rdma_rsp *rsp)
 static void nvmet_rdma_handle_command(struct nvmet_rdma_queue *queue,
 		struct nvmet_rdma_rsp *cmd)
 {
+	unsigned long flags;
 	u16 status;
 
 	ib_dma_sync_single_for_cpu(queue->dev->device,
@@ -998,9 +1001,9 @@ static void nvmet_rdma_handle_command(struct nvmet_rdma_queue *queue,
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



