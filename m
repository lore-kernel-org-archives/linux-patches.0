Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795042580;
	b=31SsRLrhn25Hn4OFPwnZwW0sj+/7DOyYPIJvJikoqqxc/zhukefzxLwrKWVRRwAdjpht
	 l9essaO5DENKFjDj+qc94Q3poYb3pn869TbhE2F5Q+QSX37Xcryt3lBJ+0eH1rz3phfQZ
	 vdwhi+BeTJbi65KN9HJM2K0aJFKODG2fk4Te36FrktZUdoxIFt09pZcbYkgDKS8Gq3kKj
	 UZmAzIgYKzeTG7w5khXeKf+7LxQlAkNoGOgyT32R9cFdm1uD9Tasq5+zjOWY3x5LB6MOy
	 4MGnBDIt67Mn+qpRe+uSRf4r2KFlGQRCys+P87zdcU+o7f71KxuEweqv2ieKhv6jW4g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795042580;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=nGjGa6jglm9/xALvC4s3Tbvd2kml+2x5N2+JGLqnKPY=;
	b=ODkwCK7dEPsngGGOmIchcgGxdzww3+qz2t89V1rJGw3jwxU5gBFdjU/CgbWTnZ0zKEaK
	 nuKd9/3SouJpnYKPsBhNFozYfE0wtNRL10UglHiPtyrc79bSgC4V7Dgfs4UHjmhR6mvy7
	 TQ7urK4OVZPjStnzDVKFWxIJ31SBeTw9EES1v5ppbP5qBPyDXNXhyJWf4kkPC4j6nOx3D
	 mUQCQBTx4Z5kdVa6eyjKSPW2O9zN+BreIbb378CJWHvjauWgKkTSoEs0X4Na4rC+t4HbF
	 gm66G4Nlyg/XD4Lv0dE2HV4q4ShqsgiAQuDULgUYZvkj/YpWuJQRu/ueZ2nBnM8a9JQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DTlOJSSh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAF32606A31C;
	Wed, 18 Nov 2026 22:56:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DTlOJSSh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D9911F000C4;
	Wed, 18 Nov 2026 22:56:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795042579;
	bh=nGjGa6jglm9/xALvC4s3Tbvd2kml+2x5N2+JGLqnKPY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DTlOJSShAD6PUIfj8LYfADLlFBQkUiA0MHNaAH4iNRSNWkTYh7AJF3ObLNBbwIzgA
	 9Hg7tUna4M8blL2specwuIWy6Wb519iIwVBhzOrs+t83QbJ/09yLGv4HmSYVVvjrPO
	 egEE1p7SH3TdW8p47Wg9HXvr9jt7rRrgRvkiwKRA=
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
Subject: [PATCH 6.6 3221/3318] nvmet-rdma: flush nvmet-wq on module exit
Date: Wed, 18 Nov 2026 16:04:03 +0100
Message-ID: <20261118150456.355258751@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 629081e4c37c7..ab74f9d800e03 100644
--- a/drivers/nvme/target/rdma.c
+++ b/drivers/nvme/target/rdma.c
@@ -2130,6 +2130,12 @@ static void __exit nvmet_rdma_exit(void)
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



