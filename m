Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795056919;
	b=HpISFPGAv9IiCg/mvUqobqgzNKvExX8FAn9CpAtFEnOlJoUrTqqJnyE1fCmSQmMuqxL7
	 tmmxKc7ttZcLsoKEDuhJf+yfcJMoWwoiRO67uj58GNlS2Rkv3qjgnAa2UqprLpBxC/3VZ
	 LpAcb3+EvwkhZhfjX10ar79jjmX/mKtcU/GT2mAO5DLODqfk/Cn2naj9ivzSNH3xx+9U8
	 1i9mfHg7sxHY/19kFRzpjIVQ06isxPMXtmnVvR6dVfrdmWmEC9L/TAZhR/FprhIREP5Q1
	 hHbqBJ/hxEyQsCI3OoEgp8qQYdFndZ7Yi8XUIphLpvyuH6kWWpuldkqZFX8uOx9KpqA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056919;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=mzoB7bkGLt0++dOnWWaqlZ39uplwQ0ml60BjuB7u5ek=;
	b=Rrr5vMKvsX2bCkHwWDKDrLXVdoekHjdisve3gxHmEPkah2tSPKBAZG84x37EcpTYX/s7
	 yvOOJRWQepc0pCdDTSKHX6OxNRJWwQqiU4VzqV/J6/zZxHSgrQTGWJlrHMXTDJtBOQLbu
	 r9Q1wEmJz86NIn0twGmnHCsP4FvQ1AGAL8hPcorXfXele38dDtM29ZtlQXk8plZ5/VJJ5
	 x9DxCniE19OatAiDLt4Vuq4KUC/7j/KaoYbJ6yodDh9fdhRW6hZWO2TB4fwasdTvDcD4P
	 OxB3mkYU2dlBNLJOlgV4HKrZ1DeDPdBjKA+mzdPcstcG4vy2ok1OXnRX7UOn9IinOnQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="GDV/8Gbf";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AA8E606A32C;
	Thu, 19 Nov 2026 02:55:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GDV/8Gbf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0A511F000C4;
	Thu, 19 Nov 2026 02:55:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795056919;
	bh=mzoB7bkGLt0++dOnWWaqlZ39uplwQ0ml60BjuB7u5ek=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GDV/8GbfpQ6Z4W622sA2ZaZj1hTFeWTfwlt8wcSzetlVPo4Gz4Zjv8mOTR1GSu2GV
	 ZMiL7fN0cgjdNWPKzg5up2reNa53zdjhByP8Kar0+ifGtXcCgvRZSBVYYzGh4RNlCi
	 PGVW4NHTdV69ZBF//8Act5DkrjfpuABZXfSfowJA=
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
Subject: [PATCH 5.15 2158/2214] nvmet-rdma: flush nvmet-wq on module exit
Date: Wed, 18 Nov 2026 16:03:54 +0100
Message-ID: <20261118150136.778711087@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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
index 4be96ca0ef5de..a321df21c2a61 100644
--- a/drivers/nvme/target/rdma.c
+++ b/drivers/nvme/target/rdma.c
@@ -2122,6 +2122,12 @@ static void __exit nvmet_rdma_exit(void)
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



