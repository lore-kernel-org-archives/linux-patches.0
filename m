Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214091;
	b=Mf5k+b7Nv5IIoLBgflbqby1HuioT4Gstc9b/eM6ktFfOrVpURLpto7TLkcwAE/FFIYcT
	 wx3nJ7tV9hcjb7hJRSs9QLOHxbCuRKmYvOfNBazMQ0nmyEHFwQlQXVYVT1FB6+H4MoLa1
	 Yih837zOXtT7BftwCjqc8eZfSVBQoSEDXZ0m0ZppAoeEH5HHWGcL4AKzkqajRq0PS2Oq8
	 7L9wuDgBWNoJKuLKMxI8kWMjbh7otCXrI0onVhfMslpReG8znlur9r8O0Sw6v8KjLiCa8
	 VdmO4P1ySxiSKB60WILYn7+GjVM8r2VlxVxRQNKypMMRjnGCFVZ39leU40X7ZCrx2wQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214091;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xnbcIOtq2jZ+CrxT+Swneip8o8kK66xpkS08Jqdsu3Q=;
	b=exi0ga3jK5rDQ55/e1Tjcz/FyzZ/ODkr9O7uyLVJIwNNqbGDu1oMz457iQ2u8pfk0kTq
	 l9xjP9BafiRispbNKv/mU+za28iQn+Vi7iXqEIJSnfIvpVprTPxS2agUgqiEQewVsvmZS
	 Br04pDxeVSZm8Ax81oXXPqWPiAgPZ91etM4PAIV8SJifQiUnrpLDm/tv5bgQ3IMaZjona
	 GqdbSJxWmrS6I1MwWOp9UuDf4cV8yd8/nBLQsCoG9rZIAwU5NMqQg+hxUAWjgwZ7WKXYB
	 mTdMUK3Uqf8Qdkvk5ZQ5qXzGApbJoO7+LvSHrWgSvtWxJAopZLKwrZFRu07YQ+E5bZw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vNFcqomY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E4C4606A31A;
	Wed, 28 Oct 2026 19:01:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vNFcqomY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C3171F01825;
	Wed, 28 Oct 2026 19:01:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214090;
	bh=xnbcIOtq2jZ+CrxT+Swneip8o8kK66xpkS08Jqdsu3Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vNFcqomYNGVqmu4IzYUxywOnHbzwJ9MxkvniE4iEoFX36IbxWwAg5eapNDrHBar9G
	 JZEUWmWWIZTUHj4zzVAqrx1KijUjPDGVlLQO2jk1J4KjOdcSV7GH96DTalDsr96b2I
	 TFdbRr93zXyKhoP2tjgTLM8hRE7107WWmfLGoYqo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yishai Hadas <yishaih@nvidia.com>,
	Artemy Kovalyov <artemyko@nvidia.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0736/1887] RDMA/mlx5: Fix a race for an ODP MR which leads to CQE with error
Date: Wed, 28 Oct 2026 17:47:12 +0100
Message-ID: <20261028170516.197011036@linuxfoundation.org>
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

From: Yishai Hadas <yishaih@nvidia.com>

[ Upstream commit abb604a1a9c87255c7a6f3b784410a9707baf467 ]

This patch addresses a race condition for an ODP MR that can result in a
CQE with an error on the UMR QP.

During the __mlx5_ib_dereg_mr() flow, the following sequence of calls
occurs:

mlx5_revoke_mr()
 mlx5r_umr_revoke_mr()
 mlx5r_umr_post_send_wait()

At this point, the lkey is freed from the hardware's perspective.

However, concurrently, mlx5_ib_invalidate_range() might be triggered by
another task attempting to invalidate a range for the same freed lkey.

This task will:
 - Acquire the umem_odp->umem_mutex lock.
 - Call mlx5r_umr_update_xlt() on the UMR QP.
 - Since the lkey has already been freed, this can lead to a CQE error,
   causing the UMR QP to enter an error state [1].

To resolve this race condition, the umem_odp->umem_mutex lock is now also
acquired as part of the mlx5_revoke_mr() scope.  Upon successful revoke,
we set umem_odp->private which points to that MR to NULL, preventing any
further invalidation attempts on its lkey.

[1] From dmesg:

   infiniband rocep8s0f0: dump_cqe:277:(pid 0): WC error: 6, Message: memory bind operation error
   cqe_dump: 00000000: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
   cqe_dump: 00000010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
   cqe_dump: 00000020: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
   cqe_dump: 00000030: 00 00 00 00 08 00 78 06 25 00 11 b9 00 0e dd d2

   WARNING: CPU: 15 PID: 1506 at drivers/infiniband/hw/mlx5/umr.c:394 mlx5r_umr_post_send_wait+0x15a/0x2b0 [mlx5_ib]
   Modules linked in: ip6table_mangle ip6table_natip6table_filter ip6_tables iptable_mangle xt_conntrack xt_MASQUERADE nf_conntrack_netlink nfnetlink xt_addrtype iptable_nat nf_nat br_netfilter rpcsec_gss_krb5 auth_rpcgss oid_registry overlay rpcrdma rdma_ucm ib_iser libiscsi scsi_transport_iscsi rdma_cm iw_cm ib_umad ib_ipoib ib_cm mlx5_ib ib_uverbs ib_core fuse mlx5_core
   CPU: 15 UID: 0 PID: 1506 Comm: ibv_rc_pingpong Not tainted 6.12.0-rc7+ #1626
   Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.13.0-0-gf21b5a4aeb02-prebuilt.qemu.org 04/01/2014
   RIP: 0010:mlx5r_umr_post_send_wait+0x15a/0x2b0 [mlx5_ib]
   [..]
   Call Trace:
   <TASK>
   mlx5r_umr_update_xlt+0x23c/0x3e0 [mlx5_ib]
   mlx5_ib_invalidate_range+0x2e1/0x330 [mlx5_ib]
   __mmu_notifier_invalidate_range_start+0x1e1/0x240
   zap_page_range_single+0xf1/0x1a0
   madvise_vma_behavior+0x677/0x6e0
   do_madvise+0x1a2/0x4b0
   __x64_sys_madvise+0x25/0x30
   do_syscall_64+0x6b/0x140
   entry_SYSCALL_64_after_hwframe+0x76/0x7e

Fixes: e6fb246ccafb ("RDMA/mlx5: Consolidate MR destruction to mlx5_ib_dereg_mr()")
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/r/68a1e007c25b2b8fe5d625f238cc3b63e5341f77.1737290229.git.leon@kernel.org
Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
Reviewed-by: Artemy Kovalyov <artemyko@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mlx5/mr.c  | 31 +++++++++++++++++++++++++------
 drivers/infiniband/hw/mlx5/odp.c |  2 ++
 2 files changed, 27 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/mr.c b/drivers/infiniband/hw/mlx5/mr.c
index 2cb4310cc3d68..60a67a77cd910 100644
--- a/drivers/infiniband/hw/mlx5/mr.c
+++ b/drivers/infiniband/hw/mlx5/mr.c
@@ -1587,6 +1587,8 @@ int mlx5_ib_dereg_mr(struct ib_mr *ibmr, struct ib_udata *udata)
 {
 	struct mlx5_ib_mr *mr = to_mmr(ibmr);
 	struct mlx5_ib_dev *dev = to_mdev(ibmr->device);
+	bool is_odp = is_odp_mr(mr);
+	bool odp_locked = is_odp;
 	int rc;
 
 	/*
@@ -1628,25 +1630,42 @@ int mlx5_ib_dereg_mr(struct ib_mr *ibmr, struct ib_udata *udata)
 	}
 
 	/* Stop DMA */
+	if (odp_locked)
+		mutex_lock(&to_ib_umem_odp(mr->umem)->umem_mutex);
+
 	if (mr->mmkey.cache_ent) {
 		xa_lock_irq(&mr->mmkey.cache_ent->mkeys);
 		mr->mmkey.cache_ent->in_use--;
 		xa_unlock_irq(&mr->mmkey.cache_ent->mkeys);
 
-		if (mlx5r_umr_revoke_mr(mr) ||
-		    push_mkey(mr->mmkey.cache_ent, false,
-			      xa_mk_value(mr->mmkey.key)))
+		if (mlx5r_umr_revoke_mr(mr)) {
 			mr->mmkey.cache_ent = NULL;
+		} else {
+			if (odp_locked) {
+				to_ib_umem_odp(mr->umem)->private = NULL;
+				mutex_unlock(&to_ib_umem_odp(mr->umem)->umem_mutex);
+				odp_locked = false;
+			}
+			if (push_mkey(mr->mmkey.cache_ent, false,
+				      xa_mk_value(mr->mmkey.key)))
+				mr->mmkey.cache_ent = NULL;
+		}
 	}
 	if (!mr->mmkey.cache_ent) {
 		rc = destroy_mkey(to_mdev(mr->ibmr.device), mr);
-		if (rc)
+		if (rc) {
+			if (odp_locked)
+				mutex_unlock(&to_ib_umem_odp(mr->umem)->umem_mutex);
 			return rc;
+		}
 	}
 
-	if (mr->umem) {
-		bool is_odp = is_odp_mr(mr);
+	if (odp_locked) {
+		to_ib_umem_odp(mr->umem)->private = NULL;
+		mutex_unlock(&to_ib_umem_odp(mr->umem)->umem_mutex);
+	}
 
+	if (mr->umem) {
 		if (!is_odp)
 			atomic_sub(ib_umem_num_pages(mr->umem),
 				   &dev->mdev->priv.reg_pages);
diff --git a/drivers/infiniband/hw/mlx5/odp.c b/drivers/infiniband/hw/mlx5/odp.c
index 1b5492b75b7d8..aa24d395a2dc8 100644
--- a/drivers/infiniband/hw/mlx5/odp.c
+++ b/drivers/infiniband/hw/mlx5/odp.c
@@ -265,6 +265,8 @@ static bool mlx5_ib_invalidate_range(struct mmu_interval_notifier *mni,
 	if (!umem_odp->npages)
 		goto out;
 	mr = umem_odp->private;
+	if (!mr)
+		goto out;
 
 	start = max_t(u64, ib_umem_start(umem_odp), range->start);
 	end = min_t(u64, ib_umem_end(umem_odp), range->end);
-- 
2.53.0



