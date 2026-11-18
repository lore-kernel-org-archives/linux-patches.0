Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023665;
	b=2tj+bRnzqGiKtsAL0FOQeZjpph5pn628qRPPDOB93naJ9kYpYRi/Sz6vKJ491uKknrLM
	 ohI5IB/opEpQ+dFAe89IrALhzKVhs6A84ZoZ2GLpuNDla7LoWoiTDTKMruUdNpfqK/EJv
	 czIe1OHNE+zb1HBYkYMeisYx7f2Zn0RQp4lY9NOyZzsTWqEkVUfUCHu30DUqigH7kKZzv
	 THtg/Fj/8U5VUNdkLzNukLQZ1iN4Ob1ITJGPdeepFgYkmA5Q2btDwS1pZmXToCZO+5s1Q
	 xgPprWeGE3xyLx2HSPAsl2hs89EhS9J/6HIzOVlaeLmUpXlxDCc7U/isCRhPcbyVsqw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023665;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=KHvV1BvEUhvSVTAZzBDrG9LdDmXTInbljTnSRAjk0rI=;
	b=e4cdL8xAu6ovZ/DNe77BWEEL2P5kXUkSjhDjliq9SkDUiZ2ex+hDVcBVbJlUDcVhxWAK
	 6lOmgDK3wwjOFAZLuVm/GfNpyeFcrqAWOuGNdD/QAASmgHOvcb0hOQZa3ca830IrPPEst
	 n6NaPVvK8sVe3AdF7JGTqkztbLCYryEL/MIP5fdvWlkPK8SbUE2wcEqOMcIvzYSjaY3nZ
	 lkj5mfMw/SoiuUYkiohEKbKYoK2Exc9Tw1D6fR7l14yFbZEyoVbq/NhreYpLFRUPrvLSb
	 P21M8lp5AGo6KE+10CNuJQ2fSrMDSpt1oIyPaO5daU7yWhDJ69DSjjk7lMWDPH78ANw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="AS/eCg78";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EE23606A31C;
	Wed, 18 Nov 2026 17:41:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AS/eCg78
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52C4B1F000C4;
	Wed, 18 Nov 2026 17:41:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023664;
	bh=KHvV1BvEUhvSVTAZzBDrG9LdDmXTInbljTnSRAjk0rI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AS/eCg785XgPetj4YIx9315Zot160KMwV6X0jvSd465Zp5gSeF3mOvBL/deUTZR2J
	 hqUTpYPgDenl8DJWTyiNS98KHBPONdaOydrcqs3gzTpvAoN3wN83Uwy6e3Gw7Xa2rs
	 XmEH6gxgRekt6qnClq4AA3/iWAWbrCs+pncmj9Wg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhu Yanjun <yanjun.zhu@linux.dev>,
	Nicolas Morey <nmorey@suse.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0450/2151] RDMA/rxe: Use validated num_sge in local buffer
Date: Wed, 18 Nov 2026 15:36:25 +0100
Message-ID: <20261118150138.427199320@linuxfoundation.org>
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

From: Nicolas Morey <nmorey@suse.com>

[ Upstream commit a4368022a3ac5324356ae8d88e3a42d115956fd6 ]

For both SRQ and non-SRQ receive paths, the WQE is copied into a local
buffer to provide a kernel-owned, validated copy. While calculating the
memcpy size from the validated num_sge prevents overflow during the
copy, memcpy() itself still copies num_sge from shared memory.

A concurrent userspace modification before or during memcpy() leaves
an unvalidated num_sge in the local buffer, leading to potential
out-of-bounds reads in rxe_resp_check_length() and copy_data() causing:

  BUG: KASAN: slab-out-of-bounds in rxe_receiver+0x8109/0x9ec0 [rdma_rxe]
  Read of size 4 at addr ffff88812c4867f8 by task kworker/u9:6/361
  Workqueue: rxe_wq do_work [rdma_rxe]
  Call Trace:
   rxe_receiver+0x8109/0x9ec0 [rdma_rxe]
   do_work+0x149/0x610 [rdma_rxe]
   process_one_work+0x726/0x10a0

  The buggy address belongs to the object at ffff88812c486000
   which belongs to the cache kmalloc-part-13-2k of size 2048
  The buggy address is located 0 bytes to the right of
   allocated 2040-byte region [ffff88812c486000, ffff88812c4867f8)

Explicitly assign the validated num_sge to the local buffer after the
copy to prevent this race.

Fixes: 22b8fbded65b ("RDMA/rxe: Fix TOCTOU heap overflow in get_srq_wqe")
Fixes: d6ab440240a0 ("RDMA/rxe: Copy WQE to local buffer in non-SRQ receive path")
Reviewed-by: Zhu Yanjun <yanjun.zhu@linux.dev>
Signed-off-by: Nicolas Morey <nmorey@suse.com>
Link: https://patch.msgid.link/20260909160132.1491248-1-nmorey@suse.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/sw/rxe/rxe_resp.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/infiniband/sw/rxe/rxe_resp.c b/drivers/infiniband/sw/rxe/rxe_resp.c
index 6aabf1d07ea34..761362de74c46 100644
--- a/drivers/infiniband/sw/rxe/rxe_resp.c
+++ b/drivers/infiniband/sw/rxe/rxe_resp.c
@@ -287,6 +287,7 @@ static enum resp_states get_srq_wqe(struct rxe_qp *qp)
 	}
 	size = sizeof(*wqe) + num_sge * sizeof(struct rxe_sge);
 	memcpy(&qp->resp.srq_wqe, wqe, size);
+	qp->resp.srq_wqe.wqe.dma.num_sge = num_sge;
 
 	qp->resp.wqe = &qp->resp.srq_wqe.wqe;
 	queue_advance_consumer(q, QUEUE_TYPE_FROM_CLIENT);
@@ -327,6 +328,7 @@ static enum resp_states rxe_get_recv_wqe(struct rxe_qp *qp)
 	}
 	size = sizeof(*wqe) + num_sge * sizeof(struct rxe_sge);
 	memcpy(&qp->resp.srq_wqe, wqe, size);
+	qp->resp.srq_wqe.wqe.dma.num_sge = num_sge;
 
 	qp->resp.wqe = &qp->resp.srq_wqe.wqe;
 	return RESPST_CHK_LENGTH;
-- 
2.53.0



