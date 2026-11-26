Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795705224;
	b=G4DPRfaL5dL+7Zmu+eZwsOqScaq0qUILWt7T6aGxwZ4b7KkIzAjBnBBWhB4/SAms8FEh
	 udhXuwPv9orw5oo6JvpG7XyTV9eqZUi72V6QaCcvHxV3POKgaPdSG99v2fJDdIpqKhLk9
	 OvD/TgcuVxG0edh2+Ld6IaHezgYafsdbOeP2LJHyRjSSc1c8vghukyOq3UnUfoeE8lnWd
	 LHq2Bdf3OiFMXKjawofiTA4/uUKJCfMA3uX0Ec4gPJz0eAR75KgBuYxOoq905aSpJW9t0
	 9nvF8XiLTwrnqRXmOcE8A0XVtcVIZ4An9IX7NOq5+k6D8SKULhQWpuwAKmNEaV/SbAQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795705224;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qAv8QdswW4v04C54HTVRXQJC6VyRgMRp0xjuMBbL+GI=;
	b=G0c24Ws7DNIMxtAFXxjmc8DKVU8S0jSJouPdV//nDbGNy7NKzHX9wyeLouU9B9BabXF2
	 5LHsLDWSxk2XxaGQZac09Tk5ABl9z3qwDXSEDp7rkRlHlFWO3XCDMkNOTmQkymNO8DPzo
	 1wjfsLw1Xl2rEAyAv1cSv82mpumDtMbezXQw9kZtytQJm1H6K27+bjHTVJnjwqWOUUkEV
	 Vg7sm+FOBgCBorrT+qw5YtbKG0CxRwdDU8xN0/hPjlwRMaQMVglAjIfxQyyhN5ZomKeNd
	 h7cRH0+q8bv3SpH8eYigiJdyJ7sg/BtRI+4WAk31m+yny91IdDjl9OMqPBVi40jHAOg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wkO028bv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4B0A606A329;
	Thu, 26 Nov 2026 15:00:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wkO028bv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 177591F000D8;
	Thu, 26 Nov 2026 15:00:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795705224;
	bh=qAv8QdswW4v04C54HTVRXQJC6VyRgMRp0xjuMBbL+GI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wkO028bvM62l/n6a2qJB5ryEFy0voyz20hArZrQ9GSyiR/5y+u7AYOkVVxj02o5y6
	 CecQDlMsl3Qh3sbVTGXJcUHw55RdgsCjZbSgOPJqudFmUdhbasqN0YAfPKN1c5Rfsj
	 GuyAH5QiZnSsTdngd/TQM7AdW0Aliv4+mLG4VuWI=
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
Subject: [PATCH 5.15 081/319] nvmet-rdma: take a device off the list last
Date: Thu, 26 Nov 2026 15:37:29 +0100
Message-ID: <20261126144008.571437778@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126144006.732901931@linuxfoundation.org>
References: <20261126144006.732901931@linuxfoundation.org>
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
index d9ca9510dac5f..995e2c112cc6d 100644
--- a/drivers/nvme/target/rdma.c
+++ b/drivers/nvme/target/rdma.c
@@ -1199,13 +1199,18 @@ static void nvmet_rdma_free_dev(struct kref *ref)
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



