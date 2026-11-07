Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062640;
	b=xwuBFpub53QHSjEmn9zhSV0mg71USH5mnq81mG6NHyq5zH4tvtXtsTX3S5dM+r1Md2iD
	 0IN+1xooJV7XO7FKhOWkdVa6vfXBC0DguldnbQKy4QdAlZnxImMtNdyBhgV9snn86Zt6s
	 ci8Gjn3IzdbZ4vZWcmJiqNWIwbnFWiYhbD04Ce+1+duaaihnp4nlgP45BjKopn7QnK5I+
	 vNKjVzYu37E+qT6JiygdbRvQpOwUVJu5H959sZ+P3J356F/T0fqds9gTtA8bYGhbpDgRE
	 pr0LmaC39MMEuf5stvviPwlajzsULymJLlQEz3OtOHQFO+pTlY3x9zU6f9ND23WXZhQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062640;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xIfn/m8j2Tsos0vLVvB6fEEihBgRxKSA27XFtYMGux4=;
	b=zoRCkYIqadtHOFk61gOAGLMsxro59FqZuVsOlrzFJ8VyN0ODj2unWEMZP+YkpX9Z4dwe
	 mH2AjrhxH0EvN9DgHoHJZheqjW0v7ZGmwQ3KrrpCZambESG3N6z84gKYsMc3pUU9Bd5FE
	 UsEHmjq8JW3xgSolGdGuwvtD5NOk09dO0TSKS26e7ytqS6Xgin/0pBWMrHvaKFHJxwzJA
	 4v9OWwM1iF7V24J2o8LFNTxlH+vymrYMrAcgBbnAra7uf/UzUlHj6MZiLqVweROgZVEli
	 iwlBi+vR4xPjbffXvDDAHY5Hmsnt6XK8K5nXb8c9PNDepSwT5JGRXSqUeSMp7oFxwgg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=k8gcZwz3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E3AB606A334;
	Sat,  7 Nov 2026 14:44:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=k8gcZwz3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CED01F0089F;
	Sat,  7 Nov 2026 14:44:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062640;
	bh=xIfn/m8j2Tsos0vLVvB6fEEihBgRxKSA27XFtYMGux4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=k8gcZwz3BPA1dWkw1Z+QiOc722jwuz4SKQv4hnIwFyIJHXrWG3G8U7EriLH3/IoDZ
	 P8NQrAh/l/oiZTYjfz9WKQ9Fu7bZ1yun/Ra6hPC7gZwA7jKOSWJChCvdGLERAxSfoa
	 sCeFS1L47UQrPDTRN7gC0hrFdkz8dbCKZnQ8QhTA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	co+e015e82956da641b@bugs.sh,
	Christoph Hellwig <hch@lst.de>,
	Weiming Shi <bestswngs@gmail.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1508/1536] nvmet-rdma: reject short connection requests
Date: Sat,  7 Nov 2026 08:58:44 -0500
Message-ID: <20261107135040.217408895@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

From: Weiming Shi <bestswngs@gmail.com>

[ Upstream commit 635e760169a87abf03874cd4636cd91b580cb427 ]

nvmet_rdma_parse_cm_connect_req() treats RDMA-CM private data as a
struct nvme_rdma_cm_req but accepts any nonzero private_data_len.  The
iWARP path allocates exactly the peer-provided length, so a six-byte MPA
request reaches the parser and the hsqsize load reads two bytes past the
allocation.

Require the complete request structure before reading any of its fields.
The decoded KASAN report is:

  BUG: KASAN: slab-out-of-bounds in nvmet_rdma_cm_handler
    (drivers/nvme/target/rdma.c:1427 drivers/nvme/target/rdma.c:1475
     drivers/nvme/target/rdma.c:1614 drivers/nvme/target/rdma.c:1814)
  Read of size 2 at addr ff1100010459d366 by task kworker/u16:1/41
  Workqueue: iw_cm_wq cm_work_handler
  Call Trace:
   <TASK>
   dump_stack_lvl (lib/dump_stack.c:94 lib/dump_stack.c:120)
   print_report (mm/kasan/report.c:378 mm/kasan/report.c:482)
   kasan_report (mm/kasan/report.c:595)
   nvmet_rdma_cm_handler
    (drivers/nvme/target/rdma.c:1427 drivers/nvme/target/rdma.c:1475
     drivers/nvme/target/rdma.c:1614 drivers/nvme/target/rdma.c:1814)
   cma_cm_event_handler (drivers/infiniband/core/cma.c:2181)
   iw_conn_req_handler (drivers/infiniband/core/cma.c:2640)
   cm_work_handler
    (drivers/infiniband/core/cm.c:2502
     drivers/infiniband/core/cm.c:3858)
   process_one_work (kernel/workqueue.c:3396)
   worker_thread (kernel/workqueue.c:3479 kernel/workqueue.c:3560)
   kthread (kernel/kthread.c:436)
   ret_from_fork (arch/x86/kernel/process.c:158)
   ret_from_fork_asm (arch/x86/entry/entry_64.S:245)
   </TASK>

  Allocated by task 12:
   __kasan_kmalloc (mm/kasan/common.c:398 mm/kasan/common.c:415)
   __kmalloc_node_track_caller_noprof
    (mm/slub.c:5414 mm/slub.c:5545)
   kmemdup_noprof (mm/util.c:138)
   cm_event_handler
    (drivers/infiniband/core/iwcm.c:194
     drivers/infiniband/core/iwcm.c:1076)
   siw_cm_upcall (drivers/infiniband/sw/siw/siw_cm.c:408)
   siw_proc_mpareq (drivers/infiniband/sw/siw/siw_cm.c:750)
   siw_cm_work_handler (drivers/infiniband/sw/siw/siw_cm.c:1086)

  The buggy address is located 0 bytes to the right of
  allocated 6-byte region [ff1100010459d360, ff1100010459d366)

Cc: stable@vger.kernel.org
Fixes: 8f000cac6e7a ("nvmet-rdma: add a NVMe over Fabrics RDMA target driver")
Reported-by: <co+e015e82956da641b@bugs.sh>
Assisted-by: LLM
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Weiming Shi <bestswngs@gmail.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/rdma.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nvme/target/rdma.c b/drivers/nvme/target/rdma.c
index c5227d2670c4b..01b7722afb5e8 100644
--- a/drivers/nvme/target/rdma.c
+++ b/drivers/nvme/target/rdma.c
@@ -1410,7 +1410,7 @@ nvmet_rdma_parse_cm_connect_req(struct rdma_conn_param *conn,
 	struct nvme_rdma_cm_req *req;
 
 	req = (struct nvme_rdma_cm_req *)conn->private_data;
-	if (!req || conn->private_data_len == 0)
+	if (!req || conn->private_data_len < sizeof(*req))
 		return NVME_RDMA_CM_INVALID_LEN;
 
 	if (le16_to_cpu(req->recfmt) != NVME_RDMA_CM_FMT_1_0)
-- 
2.53.0



