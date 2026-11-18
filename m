Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033069;
	b=QYgiw+RCTVTI/zTiMniP5CaykiF5m2HmIgjbWeyvlKH49YR0Ra6M7QRmCEKpvwGuteyx
	 1BPgY4twGic/gHDk/ay1i3bm4f3UOzEI1AufiOmLPC9mOj3Nrmh/AMjkZ+ArGK9AasWUG
	 u03GHr6C67xIdG4fqAc3RfxX4odg3hja+JkBL4e3PIFwsEtnH4qqm6WGdIAv67CRDk+AP
	 bJAFahkBZDr/zmu6Nbct1i2Y0JDvTK9iW+S899/l7enkKX3xu4SCJl+iYClt9IdB0fUKS
	 9d9HF0i4z4pURfKWOCWPC8DUQ88HBdYb8uOWP53BozD/yA/qWSy2k2AOOdrvW1FVq9g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033069;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ETfP+QhI7/k4vtImuYtjuZ/k6VjXY+FR4mWFY1W5flM=;
	b=kfAjQpxo0PZQz98dRK+CCx5cP86LK/es5XFShcc+v5E8v2aND39Oq0VOP+bmNcX39Ii/
	 Itp2XRFIN6DJ8X6w+CagkPexRuEJuXGQb1izOpeWDm80RU276G3bBmPrHXpFE3e6yvkge
	 v/VoSEPDd1FBF4N0/t7Syv6SbGrMSHVVQcX77JIrwvHf4vXVPns7v7rMa6SNWLaJsNXpE
	 X8I8oGDq5qpo4Qdu1dGDvXHnsWGX7Y4NxOqFgRK9I5T4eQwrJUiJFTrl2r/SbUiWSCB5b
	 uCPKDoVFnHshdao8gMIsdY5VWYkeyUAjw8dQrc/ZduYcr4BmB8cEFDYRNlz7E3PaPdg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JINHADRR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F09E606A331;
	Wed, 18 Nov 2026 20:17:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JINHADRR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D723C1F000C4;
	Wed, 18 Nov 2026 20:17:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033069;
	bh=ETfP+QhI7/k4vtImuYtjuZ/k6VjXY+FR4mWFY1W5flM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JINHADRR8y25GvefA+RUEo4I1wkneeHsEtzbLdyvk80isz9e+6qYMubz7s6vEN19v
	 Jjmcx6OLf8yM7yvqzyQrPuKfKRaE2kRBh8eV52jcnWHjO0tZPzCuWBywAMraB4Wn7i
	 lm1Ab/h1sxefTBWqnWqdQUnYAgEWsHpch4tf1t4I=
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
Subject: [PATCH 6.12 1635/1756] nvmet-rdma: flush nvmet-wq on module exit
Date: Wed, 18 Nov 2026 16:02:42 +0100
Message-ID: <20261118150114.871375086@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

[ Upstream commit 2b646788ee24d895b8862514e12a95ce5d72d6cc ]

nvmet_rdma_exit() relies on ib_unregister_client() to flush nvmet-wq
through nvmet_rdma_remove_one(), but since commit a3dd7d0022c3 that
returns at once for a device no longer on device_list. The release work
of the last queue takes the device off the list in nvmet_rdma_free_dev()
and still has to drop the mutex, free the struct and return through
nvmet_rdma_release_queue_work(), so an rmmod in that window frees the
module code it's running.

Flush nvmet-wq after ib_unregister_client(). No release work can be
queued after that point.

Fixes: a3dd7d0022c3 ("nvmet-rdma: Don't flush system_wq by default during remove_one")
Cc: Christoph Hellwig <hch@lst.de>
Cc: Sagi Grimberg <sagi@grimberg.me>
Cc: Chaitanya Kulkarni <kch@nvidia.com>
Signed-off-by: Chris Mason <mason@kernel.org>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/rdma.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/nvme/target/rdma.c b/drivers/nvme/target/rdma.c
index 290b51fef0b98..4c16cc9aaaa00 100644
--- a/drivers/nvme/target/rdma.c
+++ b/drivers/nvme/target/rdma.c
@@ -2146,6 +2146,12 @@ static void __exit nvmet_rdma_exit(void)
 {
 	nvmet_unregister_transport(&nvmet_rdma_ops);
 	ib_unregister_client(&nvmet_rdma_ib_client);
+	/*
+	 * nvmet_rdma_remove_one() does not flush for a device that has left
+	 * device_list, and the release work that took it off still has to
+	 * return from nvmet_rdma_free_dev().
+	 */
+	flush_workqueue(nvmet_wq);
 	WARN_ON_ONCE(!list_empty(&nvmet_rdma_queue_list));
 	ida_destroy(&nvmet_rdma_queue_ida);
 }
-- 
2.53.0



