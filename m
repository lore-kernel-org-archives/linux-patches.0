Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024864;
	b=CVIuhiJEIBBOdW3SeVE9UKdlD1IjwDp6fzexKhiyLojwzhv4+Crj88o+DTW7b8/X/PPK
	 rsKr3V7hyITcUwecZRG7YZctzMEtmfdZ2oBXB9O6z0VASOebldRMs9xBMmQlmj+exO1BT
	 fSOeyc1s0tZt/648jnhkKY/YsJKfA+OpRcyLdAZeDTBeGFkhsN4H9ht7MQq2EFTecMbe4
	 K23/D/rVBngNCPFelbwq7MH9PTemrgePuSc8ojBvyKuRz8CM+ztHCfoDb3bpk9J3GTZEb
	 iwMJpXIVU1yOKNYCXZN/03g2hKKMeORdmWBdOt/mYmPkjXyNIPahG2Mh6NUwNEedgFw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024864;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hXpGbYHB4BQf8mmf+4DC4gizPKxnQNav4PHO3J5yicI=;
	b=uCkAuiD8ll2DJ7lNT4dPl9umFlhJUqCJnZj7m/spNUgAa+W1H8F3NXCT8pKzWo+0d1hB
	 BS0R4c4758Sy+7p3deyocfcjfa11azaVZs+iTGJiifGPZ1k0A0wL4UrrhRtsUximrwUrM
	 dG2X+5/dKchXOAimSSVX+xXKabBFnMrMThEaemqtpYFaNWZKjhTR+X5VkxmESOZ/IKqwk
	 zlPKk+BtmWUwzMcr54VoCSw4YnI4ruapA3KfrZYsoQibQjPdQAdmhJlDK2R5OTfQM15HD
	 DTWqHd7BSGMsO4wGjLfmP80ZelSPmtTSOpfjyg/2G/NSA5GqJef2AnhgKE4Zgj4pX7g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="m/mU7JP1";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AC7E606A320;
	Wed, 18 Nov 2026 18:01:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=m/mU7JP1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC5F11F000C4;
	Wed, 18 Nov 2026 18:01:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024864;
	bh=hXpGbYHB4BQf8mmf+4DC4gizPKxnQNav4PHO3J5yicI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=m/mU7JP1bysQiY3UlyjRqFpaXbPPCIXTU2b04F6W9Hk6DllVdaCQTKduAl/0iGhDj
	 yhSLXj3VgzmRFiHtlNZLyk4hl6w8q5t0XgSJi+My1f+rqB/TS06tIe+tdNkeOtW0gQ
	 8o9My/kOzBvDD/Nir8d5BeSoScanOogb7DlBEb68=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Norbert Szetei <norbert@doyensec.com>,
	Zhu Yanjun <yanjun.zhu@linux.dev>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0877/2151] RDMA/rxe: Reject prefetch of a non-ODP MR
Date: Wed, 18 Nov 2026 15:43:32 +0100
Message-ID: <20261118150154.228814833@linuxfoundation.org>
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

From: Norbert Szetei <norbert@doyensec.com>

[ Upstream commit 66f18a749a3eeeb19f0b7812ecbe8b1ac18d73ec ]

rxe_ib_advise_mr_prefetch() and rxe_ib_prefetch_sg_list() look up the MR
by lkey and hand it to rxe_odp_do_pagefault_and_lock() without checking
that it is an ODP MR. That path runs to_ib_umem_odp() on mr->umem, and
for a non-ODP MR mr->umem is a plain struct ib_umem from ib_umem_get(),
so the container_of() in to_ib_umem_odp() lands past the end of the
object and ib_umem_odp_map_dma_and_lock() reads its ib_umem_odp fields
out of bounds.

lookup_mr() validates the lkey, PD, access and state but not the MR
type, and IB_UVERBS_ADVISE_MR_ADVICE_PREFETCH is accepted for any MR.

 BUG: KASAN: slab-out-of-bounds in ib_umem_odp_map_dma_and_lock+0x884/0x8a0
 Read of size 8 at addr ffff88810a3ebcf0 by task advi/921
  ib_umem_odp_map_dma_and_lock+0x884/0x8a0
  rxe_ib_advise_mr+0x543/0xad0
  ib_uverbs_handler_UVERBS_METHOD_ADVISE_MR+0x446/0x530
  ib_uverbs_cmd_verbs+0x2b3c/0x3b20
  ib_uverbs_ioctl+0x1e3/0x310
 Allocated by task 921:
  __ib_umem_get_va+0x13e/0xae0
  rxe_mr_init_user+0x2ae/0xb00
  rxe_reg_user_mr+0x337/0x510
 The buggy address belongs to the object at ffff88810a3ebc80
  which belongs to the cache kmalloc-96 of size 96

Ask lookup_mr() for IB_ACCESS_ON_DEMAND in both the synchronous and
the asynchronous prefetch arm. mr->access carries that flag only for
an MR registered as ODP, so the existing
(access & mr->access) != access test rejects a plain MR and the
prefetch fails with -EINVAL.

Fixes: 3576b0df1588 ("RDMA/rxe: Implement synchronous prefetch for ODP MRs")
Signed-off-by: Norbert Szetei <norbert@doyensec.com>
Link: https://patch.msgid.link/20260923-rxe-advise-mr-v3-v3-2-95e1a4077e4d@doyensec.com
Reviewed-by: Zhu Yanjun <yanjun.zhu@linux.dev>
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/sw/rxe/rxe_odp.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/sw/rxe/rxe_odp.c b/drivers/infiniband/sw/rxe/rxe_odp.c
index 995c1cb5c958e..567b1cb96a950 100644
--- a/drivers/infiniband/sw/rxe/rxe_odp.c
+++ b/drivers/infiniband/sw/rxe/rxe_odp.c
@@ -476,7 +476,7 @@ static int rxe_ib_prefetch_sg_list(struct ib_pd *ibpd,
 		struct rxe_mr *mr;
 		struct ib_umem_odp *umem_odp;
 
-		mr = lookup_mr(pd, IB_ACCESS_LOCAL_WRITE,
+		mr = lookup_mr(pd, IB_ACCESS_LOCAL_WRITE | IB_ACCESS_ON_DEMAND,
 			       sg_list[i].lkey, RXE_LOOKUP_LOCAL);
 
 		if (!mr) {
@@ -542,7 +542,7 @@ static int rxe_ib_advise_mr_prefetch(struct ib_pd *ibpd,
 
 	for (i = 0; i < num_sge; ++i) {
 		/* Takes a reference, which will be released in the queued work */
-		mr = lookup_mr(pd, IB_ACCESS_LOCAL_WRITE,
+		mr = lookup_mr(pd, IB_ACCESS_LOCAL_WRITE | IB_ACCESS_ON_DEMAND,
 			       sg_list[i].lkey, RXE_LOOKUP_LOCAL);
 		if (!mr) {
 			mr = ERR_PTR(-EINVAL);
-- 
2.53.0



