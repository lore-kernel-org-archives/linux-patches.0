Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214114;
	b=Z40Y9i/WE2aRcI/RHetKqssgdBSKhlVZQ/bx1x94oYqlReCUbW+5oQ5BD52U1ZlZ1HTY
	 LSN12uWso3dQFyH92rRqcrPLLcPEBQ/sMPCk/V2U+V68YV1PuIhfyjHjf72B2ZFO7dXg5
	 F19bqMZZMR4MT2b2zNpaIhSHLwgMgP9A50bUq6HvzqRIxp0CD4TQ+6EFnEzo2UfIx34HM
	 IOuoYSpO8iW1F/ILA8RuFcIEtybrZvtXY5CDxTlh9508u/fYbAnktiX8yd37tE7wjOD5m
	 4v6DGpAPEAcSb7KoY3/qzgRN0EWgBVnNIPX/sY7tMUS4zD4m4hOYHpKNXsV6mb95RoQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214114;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=kyhdov7FXiHXmwU3fJfiWGGYbirqZ0lqAOaEB68kDMg=;
	b=b+1ebjSS+Fy99b+MS7d/h69WsQQ9TJ+ivpdEaudZNtiSVPIa0wTTV69j41E8KSNIewXx
	 kGT2Ag57cDLoATtxpvUfOptukqxnRdjQciSHbb64vY9pAFbcFNdtzaohe5qxNzotFgyla
	 1ss29Q7grKQzbgrRjvNf8wYWRzFlAi80W3oiVSjX78EFR6wEVXjWfzb5nzrPnhHaMKfI3
	 OnIMInswwuHHkYkCL/oRNeYi0mD7MSs0jSE/mMnShm56axac+HS4VEy96JLmCfzl8hVCy
	 Iu2mRIXa9qGeR6w38C1LERRIvMNsgh6ivqbMXbe21lx7AuR8lZ7oOH4NSLJUiXfA/9A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Bd00NERo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF4E4606A31C;
	Wed, 28 Oct 2026 19:01:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Bd00NERo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCAF71F01825;
	Wed, 28 Oct 2026 19:01:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214113;
	bh=kyhdov7FXiHXmwU3fJfiWGGYbirqZ0lqAOaEB68kDMg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Bd00NERoCp+H2wFXrS7SU8/bh3ghWPwh2dugllPnBjzOrF06nRx1qKrbn7apNawT0
	 2rRpLzCp0ClfeOXLxisNSByPw3tmTxuha0fE5eKmkT/QJdO4IwNskK/k+jxyxkSeyw
	 nxey6jFRI3rcZ6OOLmUEEpUqkcFH6VzAjaYRa41I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yishai Hadas <yishaih@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0744/1887] RDMA/mlx5: Fix a WARN during dereg_mr for DM type
Date: Wed, 28 Oct 2026 17:47:20 +0100
Message-ID: <20261028170516.377666116@linuxfoundation.org>
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

[ Upstream commit abc7b3f1f056d69a8f11d6dceecc0c9549ace770 ]

Memory regions (MR) of type DM (device memory) do not have an associated
umem.

In the __mlx5_ib_dereg_mr() -> mlx5_free_priv_descs() flow, the code
incorrectly takes the wrong branch, attempting to call
dma_unmap_single() on a DMA address that is not mapped.

This results in a WARN [1], as shown below.

The issue is resolved by properly accounting for the DM type and
ensuring the correct branch is selected in mlx5_free_priv_descs().

[1]
WARNING: CPU: 12 PID: 1346 at drivers/iommu/dma-iommu.c:1230 iommu_dma_unmap_page+0x79/0x90
Modules linked in: ip6table_mangle ip6table_nat ip6table_filter ip6_tables iptable_mangle xt_conntrack xt_MASQUERADE nf_conntrack_netlink nfnetlink xt_addrtype iptable_nat nf_nat br_netfilter rpcsec_gss_krb5 auth_rpcgss oid_registry ovelay rpcrdma rdma_ucm ib_iser libiscsi scsi_transport_iscsi ib_umad rdma_cm ib_ipoib iw_cm ib_cm mlx5_ib ib_uverbs ib_core fuse mlx5_core
CPU: 12 UID: 0 PID: 1346 Comm: ibv_rc_pingpong Not tainted 6.12.0-rc7+ #1631
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.13.0-0-gf21b5a4aeb02-prebuilt.qemu.org 04/01/2014
RIP: 0010:iommu_dma_unmap_page+0x79/0x90
Code: 2b 49 3b 29 72 26 49 3b 69 08 73 20 4d 89 f0 44 89 e9 4c 89 e2 48 89 ee 48 89 df 5b 5d 41 5c 41 5d 41 5e 41 5f e9 07 b8 88 ff <0f> 0b 5b 5d 41 5c 41 5d 41 5e 41 5f c3 cc cc cc cc 66 0f 1f 44 00
RSP: 0018:ffffc90001913a10 EFLAGS: 00010246
RAX: 0000000000000000 RBX: ffff88810194b0a8 RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000001
RBP: ffff88810194b0a8 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000001 R11: 0000000000000000 R12: 0000000000000000
R13: 0000000000000001 R14: 0000000000000000 R15: 0000000000000000
FS:  00007f537abdd740(0000) GS:ffff88885fb00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f537aeb8000 CR3: 000000010c248001 CR4: 0000000000372eb0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
<TASK>
? __warn+0x84/0x190
? iommu_dma_unmap_page+0x79/0x90
? report_bug+0xf8/0x1c0
? handle_bug+0x55/0x90
? exc_invalid_op+0x13/0x60
? asm_exc_invalid_op+0x16/0x20
? iommu_dma_unmap_page+0x79/0x90
dma_unmap_page_attrs+0xe6/0x290
mlx5_free_priv_descs+0xb0/0xe0 [mlx5_ib]
__mlx5_ib_dereg_mr+0x37e/0x520 [mlx5_ib]
? _raw_spin_unlock_irq+0x24/0x40
? wait_for_completion+0xfe/0x130
? rdma_restrack_put+0x63/0xe0 [ib_core]
ib_dereg_mr_user+0x5f/0x120 [ib_core]
? lock_release+0xc6/0x280
destroy_hw_idr_uobject+0x1d/0x60 [ib_uverbs]
uverbs_destroy_uobject+0x58/0x1d0 [ib_uverbs]
uobj_destroy+0x3f/0x70 [ib_uverbs]
ib_uverbs_cmd_verbs+0x3e4/0xbb0 [ib_uverbs]
? __pfx_uverbs_destroy_def_handler+0x10/0x10 [ib_uverbs]
? lock_acquire+0xc1/0x2f0
? ib_uverbs_ioctl+0xcb/0x170 [ib_uverbs]
? ib_uverbs_ioctl+0x116/0x170 [ib_uverbs]
? lock_release+0xc6/0x280
ib_uverbs_ioctl+0xe7/0x170 [ib_uverbs]
? ib_uverbs_ioctl+0xcb/0x170 [ib_uverbs]
__x64_sys_ioctl+0x1b0/0xa70
do_syscall_64+0x6b/0x140
entry_SYSCALL_64_after_hwframe+0x76/0x7e
RIP: 0033:0x7f537adaf17b
Code: 0f 1e fa 48 8b 05 1d ad 0c 00 64 c7 00 26 00 00 00 48 c7 c0 ff ff ff ff c3 66 0f 1f 44 00 00 f3 0f 1e fa b8 10 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d ed ac 0c 00 f7 d8 64 89 01 48
RSP: 002b:00007ffff218f0b8 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 00007ffff218f1d8 RCX: 00007f537adaf17b
RDX: 00007ffff218f1c0 RSI: 00000000c0181b01 RDI: 0000000000000003
RBP: 00007ffff218f1a0 R08: 00007f537aa8d010 R09: 0000561ee2e4f270
R10: 00007f537aace3a8 R11: 0000000000000246 R12: 00007ffff218f190
R13: 000000000000001c R14: 0000561ee2e4d7c0 R15: 00007ffff218f450
</TASK>

Fixes: f18ec4223117 ("RDMA/mlx5: Use a union inside mlx5_ib_mr")
Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
Link: https://patch.msgid.link/2039c22cfc3df02378747ba4d623a558b53fc263.1738587076.git.leon@kernel.org
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mlx5/mr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/mlx5/mr.c b/drivers/infiniband/hw/mlx5/mr.c
index 60a67a77cd910..6dfd425e28c1a 100644
--- a/drivers/infiniband/hw/mlx5/mr.c
+++ b/drivers/infiniband/hw/mlx5/mr.c
@@ -1571,7 +1571,7 @@ mlx5_alloc_priv_descs(struct ib_device *device,
 static void
 mlx5_free_priv_descs(struct mlx5_ib_mr *mr)
 {
-	if (!mr->umem && mr->descs) {
+	if (!mr->umem && mr->ibmr.type != IB_MR_TYPE_DM && mr->descs) {
 		struct ib_device *device = mr->ibmr.device;
 		int size = mr->max_descs * mr->desc_size;
 		struct mlx5_ib_dev *dev = to_mdev(device);
-- 
2.53.0



