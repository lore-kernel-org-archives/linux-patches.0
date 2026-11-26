Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795704279;
	b=ytawY7YkgL6Q8uHcVqE6LI/k1GeRG99j42AkbqxNPVvWmfbTaqIsfMjK2daW1uyVmUY8
	 Co9nBaeM6nltqa9o0CSt2wS+vz5CpyrKaOI16WbEgzgmRFgoxXas08+xEVfzI7X+w1Qfc
	 alWDi384gpTgUrldlcQ4IPh4gmxwu+NieBOLcojIl4YFMYzFFrNUr/6kIyqK4JSKhEpCT
	 ROksVq/bbLLY55jpUAN4k3sU3jd1FNHGlOPB5j4E+dnMBEIwjrHDjRNFT/4V/JUjWRIZp
	 3kDeNuOz3CseUsI1uNQ/7q4m0wf2NTNvOfojoHsFTEgwXoEecuPsMKza/S7dp+zrB8g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795704279;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=dn1NLUhzgfFjaLOjg//a+7N3rlh1+vSmNZVF/GUIk14=;
	b=xPP4CzvRaewhseuYOV3wv/59YYtgEGwTTuGuOEifB9OVchgcZNBGxAx/1o6hr9NwFQKK
	 F7l3GqcnLy+o4IoOFbP3xH05oPL1vNGRKZ+qa7ENAzRneQZwhTafxKz0dlaJl/efELEMo
	 IVLQHBHXDUVjaPacMc+qGxJAwxhEgkCoxO/7yF3R2iIeqkLAJHZ4VFCl4+t/CO1e5rvun
	 mnH/W87KOzO/uhlSOQfQM6NNh8wiUcBfGyl3F1x8n7MW/VujAV4R/C/84A67K0x69Q7yt
	 Yo0lZJqAs97PSDzhOzNRilaGRL/8Xp4v4zxx21qIj7IJ54XLpDxAUu6zFw9EB77tPPA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1tl27bxq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC5F5606A31E;
	Thu, 26 Nov 2026 14:44:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1tl27bxq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7004B1F000C6;
	Thu, 26 Nov 2026 14:44:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795704278;
	bh=dn1NLUhzgfFjaLOjg//a+7N3rlh1+vSmNZVF/GUIk14=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1tl27bxq5vJUAA95CiQFOZ8MGFV3APiNT4krpJNswWcWuyymQI02/+t4BWcgn1JgD
	 WOHyBJgclXcB3N2BLvskzJhHphYSbfJOnBkQnvSzF9xgwJ9WRHC/Lrjr7ppR7S33kM
	 evttRp7idvmTCZDbSzktP8sD0xsbHFC5WOYLyLas=
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
Subject: [PATCH 5.10 068/265] nvmet-rdma: take a device off the list last
Date: Thu, 26 Nov 2026 15:36:38 +0100
Message-ID: <20261126143609.841312883@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126143605.076581697@linuxfoundation.org>
References: <20261126143605.076581697@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 6f72d4fc9b87e..7a7aeac657819 100644
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



