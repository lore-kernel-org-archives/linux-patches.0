Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795618549;
	b=QitdGeSTCQ1GgN+qAaOd+sHZAAYz3PsppeKAacN4xtfqo/M0fXhJLofE82kN6WnoBh/f
	 7j/kvQpl1TT4NmbmNDASqwjPcS0u6rjU+SifC3ElMqcqLnPdyA4sxuIXNgqsjJhNYdEcT
	 dL3fs4uQAizXvIBjFJiD2whxneCLvNOpfjbgsKIXebUk5G/gtDYkljFxJqNZ3jr8etXfF
	 5l9tawdatFdaYC3GJ41CDxc7kM229tKc4kHih2yKgRftNWbRxbCOFg/0VG+qGQjYX1+sL
	 tmTj92mvkgmOuPpVBcgnFl/zxTcEfmXqM+oPVSkKPhg1j/p7Uqo39BW4MpjIjdPvDSA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795618549;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Ky5/DVWCT+V55W5t+UNuzapzNswg5TrugYch6+vkafU=;
	b=o6sUiDZgrItQRZKVflwpxZUF6BB9zTnOp7/W5xeAKDsLzRp8TIaAZIv8zXyEbNKqAag/
	 g/mnDK+ACd8Q8Aqc3gLyk580hhH/8lqp1j9hqzjQVFC2Lr0Yu1F1LQcHfTSp6ci7IlQSG
	 XZe/WMHRENNjisMBbZEjkZ4fQ4DJ32TjDf30X9mylBFeCFbDGwCoGdBSq1RoHjzvZGeGq
	 wlHufuLrrqHyWUtMu0pg3C4AM9pwKssKO+OtjGoSoa2//0M5XXTcC76Md78DsBrqmt4j4
	 9EexcOQtz6t6EGzvJv25tBYCZcHzBU4HAZOu8e86LkPuOE1QXxDwoJBKCGlT2DM4chw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="Fx/WzDNG";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78376606A32A;
	Wed, 25 Nov 2026 14:55:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Fx/WzDNG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD0D81F000EF;
	Wed, 25 Nov 2026 14:55:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795618549;
	bh=Ky5/DVWCT+V55W5t+UNuzapzNswg5TrugYch6+vkafU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Fx/WzDNG3X/d0xVmaMpHdj4w2d6DWtr9aKUamSwUAZZ3wR2/JY7Yr2rYFSuBimy4Z
	 YpRzoMn93tdeHYp8C3QDUivOpXoYwtiv2C/FSRyJo1OGEauu29W31hzzLZQbnxLxJr
	 Uidwaap+YCnGlOpF7fDs9OrCvF7Ib9eB7Qm6ziWc=
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
Subject: [PATCH 7.3 0260/1005] nvmet-rdma: take a device off the list last
Date: Wed, 25 Nov 2026 15:26:38 +0100
Message-ID: <20261125143827.829205570@linuxfoundation.org>
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
index aab43d2aa0485..a1914f9a1b30f 100644
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



