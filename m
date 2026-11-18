Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017872;
	b=EryjnCSix74OWe8qlG1SB5SJX02GCs9W4E1Ph+4jcnWkNBxX6nikVrA++TIQZTSlTAGS
	 ApqKY/xWbYWwSeI2K7Ccv8rZiJ+u0sUpl6MD1Pc1VVKQ/uOCPJ0evRGHP9BPIhBOTvkPG
	 2TCoEx8gNmE/YcbPky/YUNcHuJP9zc8T4xzjIS4IKjp9wG6/duUrM6FOqSv9bHgJVN53B
	 ZRejv3Vj7SZEGAZDqDy9qGKig2J3jg4H7wO4UBxEsj7938Zui+zqYwGos6Qwitvzgcyo+
	 z+RA4huBV2/Wk0tw3/34aPnpyFbuRIRmfsJKo/rb/dtY6aDoAizv09UJCg9EUpu3bww==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017872;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=wYUwDd/xpy74+/3YQj3XqZodld3aVfnZhNKlYd2k+uI=;
	b=3YKpHa1/8GdLhCdKObno4Z+SHxoMojFjel3XmOzSWBiGXWkgS3vPbvvx7F7sbYWjZfbi
	 jmvx/Z+rcolQ5X7bUx3Smb50LdxroEH1goBB8l8HUpxa4OgTSN9wRV58n4u6pyo6Z8l8w
	 AI+NUDmwRRpUZ16KNxZv+Ezc6fiSp03el3XDwhiapgyFP5eCHShozChunAjo9gcP6w4Qk
	 czGfeDnbV0ZLgskfzCIrF9Wap4PWzJvKg/DE5jB8J9i9Ct7dwEcPvmTFWy29zy/maTt2l
	 W38a8gt4Y882nT71+tgP5wdjR28ixSFki7WFUPxVLBDd8jzjijXYtjyYTq/vzVL4i3g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kmiEkQSa;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D84EF606A31C;
	Wed, 18 Nov 2026 16:04:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kmiEkQSa
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A0DA1F000C4;
	Wed, 18 Nov 2026 16:04:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017872;
	bh=wYUwDd/xpy74+/3YQj3XqZodld3aVfnZhNKlYd2k+uI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kmiEkQSas7BhC800BOLrxC8b+QhVBEUvHu4KkmVubrB21vjWf4WszxK1iI+nyGj6d
	 y9Q9bj4FepgF6bKL+XEdAbBFyKJDaN/7LMPVjNKwfgiGeiyTLYCix9SkEwpFhe1NGa
	 iHnj8zib6vuNa/Sb4EXJ3aILbvA/OywVAQINc8mg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Norbert Szetei <norbert@doyensec.com>,
	Zhu Yanjun <yanjun.zhu@linux.dev>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1037/2651] RDMA/rxe: Reject prefetch of a non-ODP MR
Date: Wed, 18 Nov 2026 15:37:57 +0100
Message-ID: <20261118150325.298928222@linuxfoundation.org>
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
index ab21b620e94ca..c375d3efd9992 100644
--- a/drivers/infiniband/sw/rxe/rxe_odp.c
+++ b/drivers/infiniband/sw/rxe/rxe_odp.c
@@ -469,7 +469,7 @@ static int rxe_ib_prefetch_sg_list(struct ib_pd *ibpd,
 		struct rxe_mr *mr;
 		struct ib_umem_odp *umem_odp;
 
-		mr = lookup_mr(pd, IB_ACCESS_LOCAL_WRITE,
+		mr = lookup_mr(pd, IB_ACCESS_LOCAL_WRITE | IB_ACCESS_ON_DEMAND,
 			       sg_list[i].lkey, RXE_LOOKUP_LOCAL);
 
 		if (!mr) {
@@ -535,7 +535,7 @@ static int rxe_ib_advise_mr_prefetch(struct ib_pd *ibpd,
 
 	for (i = 0; i < num_sge; ++i) {
 		/* Takes a reference, which will be released in the queued work */
-		mr = lookup_mr(pd, IB_ACCESS_LOCAL_WRITE,
+		mr = lookup_mr(pd, IB_ACCESS_LOCAL_WRITE | IB_ACCESS_ON_DEMAND,
 			       sg_list[i].lkey, RXE_LOOKUP_LOCAL);
 		if (!mr) {
 			mr = ERR_PTR(-EINVAL);
-- 
2.53.0



