Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022212;
	b=qj+OoajBR0EHPdo/3G6NOUpILjS+sH/ozvTtNc56lr65wnK8h+4Sg8ZUTm+YfGBAuDCe
	 kjswqItWMunLApzZdizXL4GIpDKqMqv7XOWSC6/rxHE/wnMaR23l66o7n0uxHQthZ1uYb
	 079jQY/yqsH+snNHgLDBgvZKYBOYF2U1PBEtE/bD0a9O4L/kWsvzQIYIi1nZQ+rUp6o4F
	 LHGfPNSU7OjsUmjyxcuQZDiZ9PlX3rUXMNPfGFD49jwltpwS8iLdE2quTUW5tN796bNZg
	 R++g29TQjJednoKX9P/2Fo1ofWAwcTg3nOHIue6CAw2yTqntxjHvBTyGFIIpJwgmHZQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022212;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4mTUcfR62Ts/uZmcKzGeb6PoTJInJlw6OfRMnOCWuug=;
	b=dgp1SNGit401548qr4xXG2S7+KoZ3GENksB46T3twAhpu5RXveSWaLxOPyd01A6KV+bJ
	 odk4ladH3tyE51Y0kPzI0+txTWJlSk9REyRGcomBIvkQeVdukDfuZJsl3F6QHvY8BMp8J
	 uQ0O3ysK5C48vQ3Ljru6ywUaaNqiH9xoQWXA8eUQ202SVyXiqgz8bIfSxMdsJIEoNeIBY
	 ljvC372+DwvuMg4XvjK4uPOW5JJZWULXmZLU/vXeSBSMPPTQYpunKMHq+936ICHRT59SO
	 GZGdBxH2+Y29DC1s6qwWV+1q9Ar9Mcz4ZB6Suqove7opaBUAfKRALNB5iHG04INnl+Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=j0rlHWD3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9561606A32C;
	Wed, 18 Nov 2026 17:16:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=j0rlHWD3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DF6B1F000C5;
	Wed, 18 Nov 2026 17:16:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795022212;
	bh=4mTUcfR62Ts/uZmcKzGeb6PoTJInJlw6OfRMnOCWuug=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=j0rlHWD3ZCP55OKBuvx3RXiyUJOjtb2bZYh2xWDwjcp5gRe4Yx0K8hxjuvRjOL5zh
	 CAhPlXW0ak0YQgiqGLqcrI63fcKMnt+Poy5cpQdKtMUpCK4nPZS43ayTssPz4nI1er
	 wZ9k/18EtMDXFCKKIE7xQi1+pTbTKJtDtFKbdZ3A=
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
Subject: [PATCH 7.3 2541/2651] nvmet-rdma: flush nvmet-wq on module exit
Date: Wed, 18 Nov 2026 16:03:01 +0100
Message-ID: <20261118150416.034281489@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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
index ebf4a7bde524b..ed11263ea93f4 100644
--- a/drivers/nvme/target/rdma.c
+++ b/drivers/nvme/target/rdma.c
@@ -2151,6 +2151,12 @@ static void __exit nvmet_rdma_exit(void)
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



