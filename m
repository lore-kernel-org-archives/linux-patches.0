Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795621489;
	b=PKJhkbUFDhMfkzzMw01yEfWBzqiw+QAT7KPyLDTh0CplowOOh2ISNGVWuB7/Yg0z+V9S
	 kpuNptP5iqtxdXoqC2y+C7d5giIZWt2urAacgmPnvB0ulXDjZ+yu/GXiQBxrRzrnDvdO1
	 sK3/bge4bPkNOI9bHrsHz+JD0Ob5Sd8UfkByxSWf6nSGNNPoCPVGdd0lBjhRdt0B3KM7H
	 nDSxePhqyzbPvMfWdgXA7JBEkt33BrflZkNke+pUDJHlRP+JwvEekLKGXyKWwrGsyPmZn
	 uyYP9m3D2YsDLRSppdsuQDgFWBkT6kvX5JT/FKx4cDt/QhHFae9BhbPDLwWbJYzYRvQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795621489;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=vy3Qskot+6zT8PgtKMvhB6OGA5H4mbQu04PkG6uT9RM=;
	b=FrO9ibukPc6fs2Kvh6kxog92hdgP52qJv++4BnHd3viwxL6qcJ1cO9LhlCv+bbscsFHs
	 s4OGoXSrqFFgqnJZtFejEB/MwgWLPU/MUCosj3dmPd4+hZ29LRLAeEV7CifOYbxJgMjLg
	 TaYD2cR9lrgCqZr8q+5ajrnChkug7VcSXsyX+dkSDwXQdR0kxKsmKeQkD22kSyppvMhpW
	 X8wRYhHaF8vsdmKq6lcRzZbCDY6rWe0OJXv1MEWVZG2mrS3eKJR2OzIRXW5BXG3bi5X9Z
	 l7ndcbDIGxQ4u8GBOYUrSHvcxz+xWNdl9VHKwDNxn+rAKwJD/w2Y2+obnHxT8pp07kQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZaKCP+bB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CAF4606A323;
	Wed, 25 Nov 2026 15:44:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZaKCP+bB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA2D91F000C0;
	Wed, 25 Nov 2026 15:44:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795621489;
	bh=vy3Qskot+6zT8PgtKMvhB6OGA5H4mbQu04PkG6uT9RM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZaKCP+bBN0RK+geKA7M66tRNZr7jsIL3P3QkR+8lCE91P/eV+QOsNHTNoOFIILyxB
	 zEMErJSK60GCYkump5YLkZqagZNHFzwfp4zNvWt0eXwezvNrPHL3GnbN2tmN36FNGR
	 3GeNnJug0Nw2sn9Et3EXyg0PQmP/YHI4hTR0VebE=
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
Subject: [PATCH 6.18 240/990] nvmet-rdma: take a device off the list last
Date: Wed, 25 Nov 2026 15:26:47 +0100
Message-ID: <20261125143827.712222048@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

[ Upstream commit 86ae3841aea4e29d7ac08d5614ca3823dc8dfbc9 ]

nvmet_rdma_remove_one() disconnects the queues of a device and flushes
nvmet-wq, but since commit a3dd7d0022c3 it returns right away if the
device isn't on device_list. nvmet_rdma_free_dev(), run by the release
work of the last queue, takes the device off that list first and frees
the SRQs and the PD afterwards. A device removal in between finds
nothing on the list, returns, and the RDMA core frees the device under
ib_dealloc_pd().

Free the SRQs and the PD first and unlist the device last, so the
remove callback finds it and its flush waits for the release work.

Fixes: a3dd7d0022c3 ("nvmet-rdma: Don't flush system_wq by default during remove_one")
Cc: Christoph Hellwig <hch@lst.de>
Cc: Sagi Grimberg <sagi@grimberg.me>
Cc: Chaitanya Kulkarni <kch@nvidia.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Chris Mason <mason@kernel.org>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/rdma.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/nvme/target/rdma.c b/drivers/nvme/target/rdma.c
index 338933d15b38e..816ad550d1fc8 100644
--- a/drivers/nvme/target/rdma.c
+++ b/drivers/nvme/target/rdma.c
@@ -1197,13 +1197,18 @@ static void nvmet_rdma_free_dev(struct kref *ref)
 	struct nvmet_rdma_device *ndev =
 		container_of(ref, struct nvmet_rdma_device, ref);
 
+	nvmet_rdma_destroy_srqs(ndev);
+	ib_dealloc_pd(ndev->pd);
+
+	/*
+	 * Only delete from the device list once all RDMA resources are torn
+	 * down because nvmet_rdma_remove_one waits for the release work only
+	 * if the device still is on the list.
+	 */
 	mutex_lock(&device_list_mutex);
 	list_del(&ndev->entry);
 	mutex_unlock(&device_list_mutex);
 
-	nvmet_rdma_destroy_srqs(ndev);
-	ib_dealloc_pd(ndev->pd);
-
 	kfree(ndev);
 }
 
-- 
2.53.0



