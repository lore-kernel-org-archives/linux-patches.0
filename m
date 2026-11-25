Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795624449;
	b=TYbWUC8izMvdqg3slhEbE545HW3dO/pBFt/xePQ1687kb71KbZm0GAjMDY7+gUoRnqFO
	 i1uZiiv7icCg3/Z0DYqoGJpXznDkGNIczQqhsBE/Vw6vkXGP2pfB5SnYEZmZmz6GRq4aA
	 pWzLQr2gqMXJGdkKvpU61X7Cf1qFwmIB4Wt09ItAsAZYf9AbcjGVtGFxx07nc+tP+TcFy
	 2EcLIzX/rFmnUzGhK4rUs+ClCWyYpxLmRd8UNrd0MID78MQsr0RP6xEF8PMtvUSxa5AzH
	 gPb04mFTyJVkdGh/C4gXCzAuLQN/IrHtrvEJ5MSCjtrpSekL8YId8yCzFSvDX/N546Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795624449;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jmDuWCjdZKe194zdxC1fdVxqry8cMkkgXapcbZNEack=;
	b=2YfB9n2+0Aj3i3pi4RP8nfG9S4g63tgxAGUf03loFEZagQcWvgLTbWPcv/Y2FABqUnBh
	 xoK/sKumz54f+un98OEPxJfYicCjA7UXX7XzLfG0WZAcmO9783ApkBfFP3zq6xkIJ8Xf9
	 yDIC21dxQSg13U5mhlYhC94FQCYspAIOK+ZDY3Vl1iwqh/IgY7XWuO8Tib0uyobownAWs
	 by9tQXNhGnlCTEwG7KUPkR9JlMjiYoIQC2Zvp49L+EMH52I79U+4edIRYf7q2Bg/3kvIr
	 To7MU/VwMWTK1CUasIuHPFr7ViHIbM+K9wvMjtDHJN1AV3Dm/TSdi3eDqK1/JrIVbFg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="uU1pl9/m";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEF76606A33C;
	Wed, 25 Nov 2026 16:34:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uU1pl9/m
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E4F21F000C0;
	Wed, 25 Nov 2026 16:34:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795624449;
	bh=jmDuWCjdZKe194zdxC1fdVxqry8cMkkgXapcbZNEack=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uU1pl9/mraUoD11Dj6VFjSltvCa0pMKZ76kqhdwEJdW2qj01iz/NgsX9J/OK31ed6
	 O2gvjyxoT0MxVotbY0afd++aFRISPqM4YJXXN0WGAutpN0zOqNAKDDErDOr4Icbv4p
	 gaBe2UGNHCMP1G0/10cfCSKzaaqTpEoP6oqxtQbY=
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
Subject: [PATCH 6.12 196/816] nvmet-rdma: take a device off the list last
Date: Wed, 25 Nov 2026 15:29:04 +0100
Message-ID: <20261125143853.730077447@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 7db9812c4e16b..cff39abc4f981 100644
--- a/drivers/nvme/target/rdma.c
+++ b/drivers/nvme/target/rdma.c
@@ -1198,13 +1198,18 @@ static void nvmet_rdma_free_dev(struct kref *ref)
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



