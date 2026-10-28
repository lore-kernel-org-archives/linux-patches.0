Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208830;
	b=4h1lKLCY3S3M59dqZ8TynlvrqxncFfj9dqdpCyvuSdV1PxXI252hnOxOr/xrT6BfPjAn
	 MDv9HigEkhpkNxJao943V3zUd3J5kjRoMrCqGJEzvXPTUI/D4j2NCrRfoPCBFJT7RuRIT
	 TYwwSxhDbQJw/S+GfD4/O3WBa2JTBxQaKgv1S6zUUuHGtpf24QoylNTb4M+029dt8BIVg
	 QFzpRuoRYqtZKOMvHCWBlpJy5WN5l1ts6/+Sw88FqAGEqz7Aa7EDGrTpSWodGTYoOjy2A
	 a1ZFr4ShKnmlVdmPdf2ZWgYfCrdVElj9IF7ISkHmJ79bUDXRa7cw2O/5nrkTNnk6iyA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208830;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=BI7Zm7rDGH1AUb7RavtUjmZkndQKXP/utk4w53pZdBA=;
	b=2pxKPJBX3XhG+NnAdxKqM9tYQrBFIcGhHCy+3z3uawL5K09d9TjG6M8cC2lZa0cu0zb6
	 /bQRwlQMBfoij7keakxeNiJyrqENShGI+S2n5NoCxm1v2z3Udt1NEj+2NvTVzYK9VNM7A
	 2mtSKqo1I9OuvHBpsFOpzjCctmih/DT5eGlfOwCL9A5yrQZ0u/xB6YagFbQNf1HCtEj53
	 6UJCgxcsu/t5z9qWL2imgwL2kxtWHx6519kQlU8q+lxPaikrKMMpFmXXLPraAb0sE3P3W
	 zkCloE9Yt6KtSwF6vHR5XYINBgsghkGDjfigSU5GhkxPhGOwvxuj4E6R9oHwuLHfPcg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nYRzNweg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F9F2606A323;
	Wed, 28 Oct 2026 17:33:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nYRzNweg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 414E61F01825;
	Wed, 28 Oct 2026 17:33:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208829;
	bh=BI7Zm7rDGH1AUb7RavtUjmZkndQKXP/utk4w53pZdBA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nYRzNweg9eRzOdsZTvrtZpGqxpNcztfIK3dqBttDrR3hzkUd49Z0W5OBTm1kl2xVp
	 KFgOi8WhTU0eu9MqE30WnXtG8RVuGN2tqwUvKLDVktuOyyycVRGT6Nv6QmiFAaZNX0
	 Jw6XzkseLDzIdFJFRa8YJEp6mPhpydws5UmbyL+Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chengchang Tang <tangchengchang@huawei.com>,
	Junxian Huang <huangjunxian6@hisilicon.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	Roman Demidov <roman.demidov.nn@gmail.com>
Subject: [PATCH 5.10 257/516] RDMA/hns: Fix WQ_MEM_RECLAIM warning
Date: Wed, 28 Oct 2026 17:56:49 +0100
Message-ID: <20261028170009.581249693@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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

From: Chengchang Tang <tangchengchang@huawei.com>

commit c0a26bbd3f99b7b03f072e3409aff4e6ec8af6f6 upstream.

When sunrpc is used, if a reset triggered, our wq may lead the
following trace:

workqueue: WQ_MEM_RECLAIM xprtiod:xprt_rdma_connect_worker [rpcrdma]
is flushing !WQ_MEM_RECLAIM hns_roce_irq_workq:flush_work_handle
[hns_roce_hw_v2]
WARNING: CPU: 0 PID: 8250 at kernel/workqueue.c:2644 check_flush_dependency+0xe0/0x144
Call trace:
  check_flush_dependency+0xe0/0x144
  start_flush_work.constprop.0+0x1d0/0x2f0
  __flush_work.isra.0+0x40/0xb0
  flush_work+0x14/0x30
  hns_roce_v2_destroy_qp+0xac/0x1e0 [hns_roce_hw_v2]
  ib_destroy_qp_user+0x9c/0x2b4
  rdma_destroy_qp+0x34/0xb0
  rpcrdma_ep_destroy+0x28/0xcc [rpcrdma]
  rpcrdma_ep_put+0x74/0xb4 [rpcrdma]
  rpcrdma_xprt_disconnect+0x1d8/0x260 [rpcrdma]
  xprt_rdma_connect_worker+0xc0/0x120 [rpcrdma]
  process_one_work+0x1cc/0x4d0
  worker_thread+0x154/0x414
  kthread+0x104/0x144
  ret_from_fork+0x10/0x18

Since QP destruction frees memory, this wq should have the WQ_MEM_RECLAIM.

Fixes: ffd541d45726 ("RDMA/hns: Add the workqueue framework for flush cqe handler")
Signed-off-by: Chengchang Tang <tangchengchang@huawei.com>
Signed-off-by: Junxian Huang <huangjunxian6@hisilicon.com>
Link: https://patch.msgid.link/20260104064057.1582216-2-huangjunxian6@hisilicon.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Roman Demidov <roman.demidov.nn@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -6087,7 +6087,8 @@ static int hns_roce_v2_init_eq_table(str
 		goto err_request_irq_fail;
 	}
 
-	hr_dev->irq_workq = alloc_ordered_workqueue("hns_roce_irq_workq", 0);
+	hr_dev->irq_workq = alloc_ordered_workqueue("hns_roce_irq_workq",
+						    WQ_MEM_RECLAIM);
 	if (!hr_dev->irq_workq) {
 		dev_err(dev, "Create irq workqueue failed!\n");
 		ret = -ENOMEM;


