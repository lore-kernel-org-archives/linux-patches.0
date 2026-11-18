Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795028129;
	b=ZveTAV/1lrj97pOAU/mFu07+sUPffkr0SjDgqtRTPdeTljfuYND61MkUHql1CwMCiUzz
	 ZgXO+iIiYeH9Zy/HG98vLzDHti1RrA0qu7xqziDdKL7OayNXxyCTqpYNv5QgzXNixcB3R
	 nNGJBoxs+d8BumNxqWSi8ZKRaw426WCP3crka4/eFURsBlSWNxx0gKHkUzeaN7FfHnAOf
	 EJNEVre+i9LmHdm8KH9d7+3I4z8sjQhKSrvwPn/+0CtKyh/L6avuKNObp9HRfhr9S/2ZZ
	 JFy8+Lyk3AHRCL2uwwVlH1XJzwXX9ZclggHTpjXBJqZoLZWlqf0liEtyHdHC5ASJvSg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795028129;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7zZIakuwZtnlH48YfQRIIoGtOXMHvM1Q3wofGfEEybw=;
	b=BwEB7KhJBLwYuKGW77QHiNWTHSm+t+cHrkb5JMDykXNYBKa7dWMDSRCB89rUhcLMgzIt
	 RQoHuKDvBMOZoEucc/FbmyyF4nufCeQkVj4z3PL6rGaFzIsd+LOnRfemZR6vvqbYZ1c8N
	 RjH9RZjvdAw7E1J3G3LpaFA2tOYtq3Gyb2LqT5sIdg5gjZ2ddQgGDe+HF31RxvYZMj07i
	 BE0fhKFzebUY2lByrQgxOn1uT5lPGtzlTXqZlx4AWaNAo9nLimgbp8ndg7tukWaIuaFNi
	 fyQxiWFqXrWHaufOnOXKp8M/wn9bv+i9Yuw2h/c/wa1Rt+e5X/+wjxFora8qTRoJ+Rw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="iBVrX/gv";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE041606A339;
	Wed, 18 Nov 2026 18:55:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iBVrX/gv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 082121F000C4;
	Wed, 18 Nov 2026 18:55:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795028128;
	bh=7zZIakuwZtnlH48YfQRIIoGtOXMHvM1Q3wofGfEEybw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iBVrX/gvSs2o2RHOnlYe4dTLWomFkyhCbDHRaddpffYNUSKdibXjPwmfCd9uzYWak
	 ueiyF84EBh5TEZFf6l8MkklXD06ITQtnXKtM5E6nE+5CJ1NXTUwr/Jh4QJ5aa8T9GC
	 NYnz9/69A+4f70w6XYDRNruYIquj0Xzq95Hnrh0w=
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
Subject: [PATCH 6.18 2034/2151] nvmet-rdma: flush nvmet-wq on module exit
Date: Wed, 18 Nov 2026 16:02:49 +0100
Message-ID: <20261118150235.828904902@linuxfoundation.org>
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
index ae44a0ff34d74..039bf56a00eea 100644
--- a/drivers/nvme/target/rdma.c
+++ b/drivers/nvme/target/rdma.c
@@ -2148,6 +2148,12 @@ static void __exit nvmet_rdma_exit(void)
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



