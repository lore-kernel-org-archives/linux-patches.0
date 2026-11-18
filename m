Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795050364;
	b=Gd8YKdqGBVbNggsREssLJYPeRSihXE6mNzQmoiW1X4lzkVghSHmC68Mh72UVwthwp4YT
	 Q9bX61y0gIhduODLdNoiHra0XdjpHL54v7jGasvrpT0N+mQ4+wPe3hZI9hbw4xWat0k7N
	 ILtmIuGGfjKQXGU0zEyRPKnx1bGWbAdZa+PDMywXb+casnZklzX9Y2t2y9uyiTkYhrcRj
	 wmm9APw35Iwkgh6QXJzLjKYLkbiyDkvdoWNy3qHuv+Q30j5k7UM7U8J3/Jts9ceYDGsne
	 DdtzPvY+Kfs3AZJ6sOkS+wRCVpMzzO0u2eajI1L8ya5PpnJaVsfg07amHsn4/h9IIHA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795050364;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=SQXw4kv/NzOhQJ0j2L5tuSqx8XOf5PY8T+6luf4EZ5k=;
	b=ogPsfbZaPYWxzg9hUqMVb2zYMvlbKUlbVvqmOgl7ZNRm30U0lcqiHEGizaNwvmS2Uq+m
	 +LT6avJacG2+7D1y1pCYL/zsUueZ5PPOFRCyoXmosym7Z2sHqUap2pBhnGdtau/mNBGJX
	 RDOdgk3HVCCPA6TFWSp0NV7A8tYIo0dClDPPndItOOPxMTqPS0SYrYT8n2tK+mPnOjUM7
	 fwMyt+b6fVfJeLs7Nz8tsUGNP1dD1UTE5hmfH8omZulwzUomyuHZ/+LczMBQP/nossScA
	 qQ8yLkaTJ5SrTots5LyHj82q1qforD6CRggR38knBe3/ujS55yK7SnnMG5nfoiDwyiw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1k1N1mEh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9E0F606A32A;
	Thu, 19 Nov 2026 01:06:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1k1N1mEh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27B371F000C4;
	Thu, 19 Nov 2026 01:06:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795050364;
	bh=SQXw4kv/NzOhQJ0j2L5tuSqx8XOf5PY8T+6luf4EZ5k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1k1N1mEhsCrdyUIeAMChuUOJBn0TuMqBYbpRD4eccOoX0N3sFXF9Q7egYyieq/SdU
	 QmA8zUGf07JfVn79DOSOFjIaaWu1HCuHpdQXV3i+da4uURPC5jvrV4CdXOImA2K5wl
	 V/uwfn1ObMobelXbBCqHRGCByqVNLe26IXMGBFqw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sagi Grimberg <sagi@grimberg.me>,
	Keith Busch <kbusch@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2683/2857] blk-mq-rdma: remove queue mapping helper for rdma devices
Date: Wed, 18 Nov 2026 16:01:57 +0100
Message-ID: <20261118150338.182976581@linuxfoundation.org>
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

From: Sagi Grimberg <sagi@grimberg.me>

[ Upstream commit edde9e70bb48301c853299f1bd7c0aa0745a38ea ]

No rdma device exposes its irq vectors affinity today. So the only
mapping that we have left, is the default blk_mq_map_queues, which
we fallback to anyways. Also fixup the only consumer of this helper
(nvme-rdma).

Remove this now dead code.

Signed-off-by: Sagi Grimberg <sagi@grimberg.me>
Acked-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Stable-dep-of: 9588769af5fc ("nvme-fabrics: reset io_queues before computing the queue mapping")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/Kconfig               |  5 -----
 block/Makefile              |  1 -
 block/blk-mq-rdma.c         | 44 -------------------------------------
 drivers/nvme/host/rdma.c    |  7 ++----
 include/linux/blk-mq-rdma.h | 11 ----------
 5 files changed, 2 insertions(+), 66 deletions(-)
 delete mode 100644 block/blk-mq-rdma.c
 delete mode 100644 include/linux/blk-mq-rdma.h

diff --git a/block/Kconfig b/block/Kconfig
index 444c5ab3b67e2..107c27eceb62c 100644
--- a/block/Kconfig
+++ b/block/Kconfig
@@ -216,11 +216,6 @@ config BLK_MQ_VIRTIO
 	depends on VIRTIO
 	default y
 
-config BLK_MQ_RDMA
-	bool
-	depends on INFINIBAND
-	default y
-
 config BLK_PM
 	def_bool PM
 
diff --git a/block/Makefile b/block/Makefile
index 4e01bb71ad6e0..b31b05390749a 100644
--- a/block/Makefile
+++ b/block/Makefile
@@ -30,7 +30,6 @@ obj-$(CONFIG_BLK_DEV_INTEGRITY) += bio-integrity.o blk-integrity.o
 obj-$(CONFIG_BLK_DEV_INTEGRITY_T10)	+= t10-pi.o
 obj-$(CONFIG_BLK_MQ_PCI)	+= blk-mq-pci.o
 obj-$(CONFIG_BLK_MQ_VIRTIO)	+= blk-mq-virtio.o
-obj-$(CONFIG_BLK_MQ_RDMA)	+= blk-mq-rdma.o
 obj-$(CONFIG_BLK_DEV_ZONED)	+= blk-zoned.o
 obj-$(CONFIG_BLK_WBT)		+= blk-wbt.o
 obj-$(CONFIG_BLK_DEBUG_FS)	+= blk-mq-debugfs.o
diff --git a/block/blk-mq-rdma.c b/block/blk-mq-rdma.c
deleted file mode 100644
index 29c1f4d6eb041..0000000000000
--- a/block/blk-mq-rdma.c
+++ /dev/null
@@ -1,44 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0
-/*
- * Copyright (c) 2017 Sagi Grimberg.
- */
-#include <linux/blk-mq.h>
-#include <linux/blk-mq-rdma.h>
-#include <rdma/ib_verbs.h>
-
-/**
- * blk_mq_rdma_map_queues - provide a default queue mapping for rdma device
- * @map:	CPU to hardware queue map.
- * @dev:	rdma device to provide a mapping for.
- * @first_vec:	first interrupt vectors to use for queues (usually 0)
- *
- * This function assumes the rdma device @dev has at least as many available
- * interrupt vetors as @set has queues.  It will then query it's affinity mask
- * and built queue mapping that maps a queue to the CPUs that have irq affinity
- * for the corresponding vector.
- *
- * In case either the driver passed a @dev with less vectors than
- * @set->nr_hw_queues, or @dev does not provide an affinity mask for a
- * vector, we fallback to the naive mapping.
- */
-void blk_mq_rdma_map_queues(struct blk_mq_queue_map *map,
-		struct ib_device *dev, int first_vec)
-{
-	const struct cpumask *mask;
-	unsigned int queue, cpu;
-
-	for (queue = 0; queue < map->nr_queues; queue++) {
-		mask = ib_get_vector_affinity(dev, first_vec + queue);
-		if (!mask)
-			goto fallback;
-
-		for_each_cpu(cpu, mask)
-			map->mq_map[cpu] = map->queue_offset + queue;
-	}
-
-	return;
-
-fallback:
-	blk_mq_map_queues(map);
-}
-EXPORT_SYMBOL_GPL(blk_mq_rdma_map_queues);
diff --git a/drivers/nvme/host/rdma.c b/drivers/nvme/host/rdma.c
index 4524315edd027..79b6c9d5d0ad5 100644
--- a/drivers/nvme/host/rdma.c
+++ b/drivers/nvme/host/rdma.c
@@ -12,7 +12,6 @@
 #include <linux/string.h>
 #include <linux/atomic.h>
 #include <linux/blk-mq.h>
-#include <linux/blk-mq-rdma.h>
 #include <linux/blk-integrity.h>
 #include <linux/types.h>
 #include <linux/list.h>
@@ -2164,10 +2163,8 @@ static void nvme_rdma_map_queues(struct blk_mq_tag_set *set)
 			ctrl->io_queues[HCTX_TYPE_DEFAULT];
 		set->map[HCTX_TYPE_READ].queue_offset = 0;
 	}
-	blk_mq_rdma_map_queues(&set->map[HCTX_TYPE_DEFAULT],
-			ctrl->device->dev, 0);
-	blk_mq_rdma_map_queues(&set->map[HCTX_TYPE_READ],
-			ctrl->device->dev, 0);
+	blk_mq_map_queues(&set->map[HCTX_TYPE_DEFAULT]);
+	blk_mq_map_queues(&set->map[HCTX_TYPE_READ]);
 
 	if (opts->nr_poll_queues && ctrl->io_queues[HCTX_TYPE_POLL]) {
 		/* map dedicated poll queues only if we have queues left */
diff --git a/include/linux/blk-mq-rdma.h b/include/linux/blk-mq-rdma.h
deleted file mode 100644
index 53b58c610e767..0000000000000
--- a/include/linux/blk-mq-rdma.h
+++ /dev/null
@@ -1,11 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0 */
-#ifndef _LINUX_BLK_MQ_RDMA_H
-#define _LINUX_BLK_MQ_RDMA_H
-
-struct blk_mq_tag_set;
-struct ib_device;
-
-void blk_mq_rdma_map_queues(struct blk_mq_queue_map *map,
-		struct ib_device *dev, int first_vec);
-
-#endif /* _LINUX_BLK_MQ_RDMA_H */
-- 
2.53.0



