Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214552;
	b=gM4+/DRVrdL5Up4O/H5SHP0smoGLu2Sp6VJQd8fZwcI/nE5mlCTodqsw+UjdaNpEiDv0
	 Gg6kySyL799yT07OQDXkpJqMCs7falYGaExTdOLGrPNjMk76Q2TvQRCT9VUT7R9T8z2NS
	 0b96IIOckmYKHmK5dUjzWjbF6MvzybUGiGFmwiHusPRQ8DSQ8uysuLHd8wfv6YROaCRW2
	 wfBrvmI6dn3AXm1yiEs6rwCAQLPrZVWtULlsHzeWOgze4s8tGYwxleSFV47bWqdSE9t5Y
	 WwmE4+bMwt6kiOgjq8g937kFOqQgXC8jWfe3V6CMZF4LbFGv/K6EAUcRn0LfXhodX/Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214552;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=fsFTmt9N9tOVWoi6uoQx+Ny4hzFq0hdhr8iNfz1T9oo=;
	b=LyMB8k5z22emsN/wfkG7MpaySkXAYAWQGnE2mGc7AMD1SwlzhUEZIuCqP6XNkf54vuep
	 G0niKTNhEuYYTcycHrKYz3u0k9UReyVzf5Uu33NeyN9jyoD+9itgq+Zt0O0lLal+xEk3+
	 MObKXQkDVHb/6fJ7cHwNL7/h21PZxstXN9sxzpr+8HFRScKxgzhecV++fLZpIue/+iVdi
	 0OQKR4qPoc50Jx61Tb3ZEb5fmYTMMw0l7xvEXdzYZQT3iuPOwd0rw2an4fL2FLkqmJgq/
	 NZlTDndFuhI0WN1v3OV7CfSOQUvTON693DWSFWvVw3uFIdztdRAjiW9Z61WHjBiCndA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Qiri2Qw9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0E1860A2600;
	Wed, 28 Oct 2026 19:09:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Qiri2Qw9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F06D01F01825;
	Wed, 28 Oct 2026 19:09:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214552;
	bh=fsFTmt9N9tOVWoi6uoQx+Ny4hzFq0hdhr8iNfz1T9oo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Qiri2Qw9EDyYaBGrpvlajS2Pb8kTjtIF0oNdMewj94oITHQsBlUy2HcksKRAFSU0s
	 2BPa0/1O/Dx/A5B+5LgKJuRu1okR1Ix6DbvhP0ehGFe9jVotPtXgFkCNrU/osSNw+9
	 GR9RKKK+y60vH3Ywg+NMPdOKHPus7wPeosZDN48g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liu Yi <asatsuyu.liu@gmail.com>,
	Zhu Yanjun <yanjun.zhu@linux.dev>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0897/1887] RDMA/rxe: Fix null deref on srq->rq.queue after resize failure
Date: Wed, 28 Oct 2026 17:49:53 +0100
Message-ID: <20261028170519.830870491@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhu Yanjun <yanjun.zhu@linux.dev>

[ Upstream commit 503a5e4690ae14c18570141bc0dcf7501a8419b0 ]

A NULL pointer dereference can occur in rxe_srq_chk_attr() when
ibv_modify_srq() is invoked twice in succession under certain error
conditions. The first call may fail in rxe_queue_resize(), which leads
rxe_srq_from_attr() to set srq->rq.queue = NULL. The second call then
triggers a crash (null deref) when accessing
srq->rq.queue->buf->index_mask.

Call Trace:
<TASK>
rxe_modify_srq+0x170/0x480 [rdma_rxe]
? __pfx_rxe_modify_srq+0x10/0x10 [rdma_rxe]
? uverbs_try_lock_object+0x4f/0xa0 [ib_uverbs]
? rdma_lookup_get_uobject+0x1f0/0x380 [ib_uverbs]
ib_uverbs_modify_srq+0x204/0x290 [ib_uverbs]
? __pfx_ib_uverbs_modify_srq+0x10/0x10 [ib_uverbs]
? tryinc_node_nr_active+0xe6/0x150
? uverbs_fill_udata+0xed/0x4f0 [ib_uverbs]
ib_uverbs_handler_UVERBS_METHOD_INVOKE_WRITE+0x2c0/0x470 [ib_uverbs]
? __pfx_ib_uverbs_handler_UVERBS_METHOD_INVOKE_WRITE+0x10/0x10 [ib_uverbs]
? uverbs_fill_udata+0xed/0x4f0 [ib_uverbs]
ib_uverbs_run_method+0x55a/0x6e0 [ib_uverbs]
? __pfx_ib_uverbs_handler_UVERBS_METHOD_INVOKE_WRITE+0x10/0x10 [ib_uverbs]
ib_uverbs_cmd_verbs+0x54d/0x800 [ib_uverbs]
? __pfx_ib_uverbs_cmd_verbs+0x10/0x10 [ib_uverbs]
? __pfx___raw_spin_lock_irqsave+0x10/0x10
? __pfx_do_vfs_ioctl+0x10/0x10
? ioctl_has_perm.constprop.0.isra.0+0x2c7/0x4c0
? __pfx_ioctl_has_perm.constprop.0.isra.0+0x10/0x10
ib_uverbs_ioctl+0x13e/0x220 [ib_uverbs]
? __pfx_ib_uverbs_ioctl+0x10/0x10 [ib_uverbs]
__x64_sys_ioctl+0x138/0x1c0
do_syscall_64+0x82/0x250
? fdget_pos+0x58/0x4c0
? ksys_write+0xf3/0x1c0
? __pfx_ksys_write+0x10/0x10
? do_syscall_64+0xc8/0x250
? __pfx_vm_mmap_pgoff+0x10/0x10
? fget+0x173/0x230
? fput+0x2a/0x80
? ksys_mmap_pgoff+0x224/0x4c0
? do_syscall_64+0xc8/0x250
? do_user_addr_fault+0x37b/0xfe0
? clear_bhb_loop+0x50/0xa0
? clear_bhb_loop+0x50/0xa0
? clear_bhb_loop+0x50/0xa0
entry_SYSCALL_64_after_hwframe+0x76/0x7e

Fixes: 8700e3e7c485 ("Soft RoCE driver")
Tested-by: Liu Yi <asatsuyu.liu@gmail.com>
Signed-off-by: Zhu Yanjun <yanjun.zhu@linux.dev>
Link: https://patch.msgid.link/20251027215203.1321-1-yanjun.zhu@linux.dev
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/sw/rxe/rxe_srq.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/infiniband/sw/rxe/rxe_srq.c b/drivers/infiniband/sw/rxe/rxe_srq.c
index 038a9cd55413e..82e872fd8f45d 100644
--- a/drivers/infiniband/sw/rxe/rxe_srq.c
+++ b/drivers/infiniband/sw/rxe/rxe_srq.c
@@ -161,18 +161,13 @@ int rxe_srq_from_attr(struct rxe_dev *rxe, struct rxe_srq *srq,
 				       &srq->rq.producer_lock,
 				       &srq->rq.consumer_lock);
 		if (err)
-			goto err2;
+			return err;
 	}
 
 	if (mask & IB_SRQ_LIMIT)
 		srq->limit = attr->srq_limit;
 
 	return 0;
-
-err2:
-	rxe_queue_cleanup(q);
-	srq->rq.queue = NULL;
-	return err;
 }
 
 void rxe_srq_cleanup(struct rxe_pool_elem *elem)
-- 
2.53.0



