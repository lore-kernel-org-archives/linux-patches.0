Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795049544;
	b=ETTlapYaXCsktgHfIJLoso49qOd7B1bLzg2fT2NDZ6p/IpPqgBv23/5QJOpyTqqKgW3b
	 IkxqbSjDxK1iO1zHlZvvL3sSNPRlbYYrp5M24mB9fKA6flQDQYT0WeWSKr6c9iCnSVVYh
	 Zl48E5KNKhZm81KvUneHdxj2WLEmjvqZO6vy0TTivOTx1G0C12bN2dtWCR1FYnn/7/uVg
	 ThP4dFVzryvdxvQUvNADl5/6EjiQmby6Sxv24MA/hRTm7cRQSO/ioXIBILHsvutjfxXgo
	 B3wTMYzSkM7Q5zlwVIcsQVu2vIP6hh+oo8QzNw76Oa56Sq1cT1awJsgTt5CEQfaiGSw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795049544;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=lJ43fpJvwPI97q/3jciOyu/jeCZ/oBJG7Ic/+Y7CIss=;
	b=pazQ4gBkAa1GyZY7KonTaBzzAyaYjqL8jSC5sSg5NwXtI53+f3cC66RBjWtvQJi1khSe
	 wSa1jtVfZIMOe9BQTXGD20zOlKPZEBRZnxpZXLDgrwb7NB385ghw2bILMqB2o0JIAqxbb
	 b+iFt/VAAwZIYwSN7k50GsyxWnBe3Xf04bBS06n2tiiftjuTP/93GPw1OLP+xaDBHu4EW
	 +aSuRnMASsULPTKw1nJcKGI+i7IrLlNnNUesQT8TG7S4e6/+huyWAQ9acA6780lpjgYEq
	 /BCpL6zE94mzZOkdAiRF6VX8epGgLuBlqmzff94uSd+5lVozD1Y9ESXuFzPSq3oKgeQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jJn4khlq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F216606A31C;
	Thu, 19 Nov 2026 00:52:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jJn4khlq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C0BF1F000C4;
	Thu, 19 Nov 2026 00:52:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795049544;
	bh=lJ43fpJvwPI97q/3jciOyu/jeCZ/oBJG7Ic/+Y7CIss=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jJn4khlqz0awuGmmEH3k2Af32TbfkgBCycpjhsypdpVD7itDVmFYk1puVrGst3JtW
	 L4NSGb5p44L2SipF5v7qgC+iysGPKcZ/p4CDBYSnVpzRiB9W9zfP3sklP8T9S22VkY
	 iJQ1PTNnFNWkweMh5876oZZQCiGL2qxU0fgtG3Ls=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Zhang <markzhang@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2362/2857] RDMA/mlx5: Support driver APIs pre_destroy_cq and post_destroy_cq
Date: Wed, 18 Nov 2026 15:56:36 +0100
Message-ID: <20261118150326.568259418@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

From: Mark Zhang <markzhang@nvidia.com>

[ Upstream commit b5eeb8365d196c95dbb0fd0a5b5a69a44832f16f ]

- pre_destroy_cq: Destroy FW CQ object so that no new CQ event would
                  be generated;
- post_destroy_cq: Release all resources.

This patch, along with last one, fixes the crash below.

 Unable to handle kernel paging request at virtual address ffff8000114b1180
 Mem abort info:
   ESR = 0x96000047
   EC = 0x25: DABT (current EL), IL = 32 bits
   SET = 0, FnV = 0
   EA = 0, S1PTW = 0
 Data abort info:
   ISV = 0, ISS = 0x00000047
   CM = 0, WnR = 1
 swapper pgtable: 4k pages, 48-bit VAs, pgdp=00000000f4582000
 [ffff8000114b1180] pgd=00000447fffff003, p4d=00000447fffff003, pud=00000447ffffe003, pmd=00000447ffffb003, pte=0000000000000000
 Internal error: Oops: 96000047 [#1] SMP
 Modules linked in: udp_diag uio_pci_generic uio tcp_diag inet_diag binfmt_misc sn_core_odd(OE) rpcrdma(OE) xprtrdma(OE) ib_isert(OE) ib_iser(OE) ib_srpt(OE) ib_srp(OE) ib_ipoib(OE) kpatch_9658536(OK) kpatch_9322385(OK) kpatch_8843421(OK) kpatch_8636216(OK) vfat fat aes_ce_blk crypto_simd cryptd aes_ce_cipher crct10dif_ce ghash_ce sm4_ce sha2_ce sha256_arm64 sha1_ce sbsa_gwdt sg acpi_ipmi ipmi_si ipmi_msghandler m1_uncore_ddrss_pmu m1_uncore_cmn_pmu team_yosemite9rc6(OE) vnic(OE) ip_tables mlx5_ib(OE) sd_mod ast mlx5_core(OE) i2c_algo_bit drm_vram_helper psample drm_kms_helper mlxdevm(OE) auxiliary(OE) mlxfw(OE) syscopyarea sysfillrect tls sysimgblt fb_sys_fops drm_ttm_helper nvme ttm nvme_core drm t10_pi i2c_designware_platform i2c_designware_core i2c_core ahci libahci libata rdma_ucm(OE) ib_uverbs(OE) rdma_cm(OE) iw_cm(OE) ib_cm(OE) ib_umad(OE) ib_core(OE) ib_ucm(OE) mlx_compat(OE) [last unloaded: ipmi_devintf]
 CPU: 83 PID: 59375 Comm: kworker/u253:1 Kdump: loaded Tainted: G           OE K   5.10.84-004.ali5000.alios7.aarch64 #1
 Hardware name: Inspur AliServer-Xuanwu2.0AM-02-2UM1P-5B/AS1221MG1, BIOS 1.2.M1.AL.P.158.00 08/31/2023
 Workqueue: ib-comp-unb-wq ib_cq_poll_work [ib_core]
 pstate: 82c00089 (Nzcv daIf +PAN +UAO +TCO BTYPE=--)
 pc : native_queued_spin_lock_slowpath+0x1c4/0x31c
 lr : mlx5_ib_poll_cq+0x18c/0x2f8 [mlx5_ib]
 sp : ffff80002be1bc80
 x29: ffff80002be1bc80 x28: ffff000810e69000
 x27: ffff000810e69000 x26: ffff000810e69200
 x25: 0000000000000000 x24: ffff8000117db000
 x23: ffff04000156b780 x22: 0000000000000000
 x21: ffff04000ce6c160 x20: ffff0008196a4000
 x19: 0000000000000010 x18: 0000000000000020
 x17: 0000000000000000 x16: 0000000000000000
 x15: ffff040055a364e8 x14: ffffffffffffffff
 x13: ffff80002318bda8 x12: ffff0400358836e8
 x11: 0000000000000040 x10: 0000000000000eb0
 x9 : 0000000000000000 x8 : 0000000000000000
 x7 : ffff04477fa20140 x6 : ffff8000114b1140
 x5 : ffff04477fa20140 x4 : ffff8000114b1180
 x3 : ffff000810e69200 x2 : ffff8000114b1180
 x1 : 0000000001500000 x0 : ffff04477fa20148
 Call trace:
  native_queued_spin_lock_slowpath+0x1c4/0x31c
  __ib_process_cq+0x74/0x1b8 [ib_core]
  ib_cq_poll_work+0x34/0xa0 [ib_core]
  process_one_work+0x1d8/0x4b0
  worker_thread+0x180/0x440
  kthread+0x114/0x120
 Code: 910020e0 8b0400c4 f862d929 aa0403e2 (f8296847)
 ---[ end trace 387be2290557729c ]---
 Kernel panic - not syncing: Oops: Fatal exception
 SMP: stopping secondary CPUs
 Kernel Offset: disabled
 CPU features: 0x9850817,7a60aa38
 Memory Limit: none
 Starting crashdump kernel...
 Bye!

Signed-off-by: Mark Zhang <markzhang@nvidia.com>
Link: https://patch.msgid.link/aaf0072f350d1c7e8731f43b79e11a560bafb9e0.1750070205.git.leon@kernel.org
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Stable-dep-of: a0ab2bb269e7 ("RDMA/mlx5: Cancel software CQ notifications before teardown")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mlx5/cq.c      | 19 +++++++++++++++----
 drivers/infiniband/hw/mlx5/main.c    |  2 ++
 drivers/infiniband/hw/mlx5/mlx5_ib.h |  2 ++
 3 files changed, 19 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/cq.c b/drivers/infiniband/hw/mlx5/cq.c
index b5c2e0e1d82b2..3d50fd28b227f 100644
--- a/drivers/infiniband/hw/mlx5/cq.c
+++ b/drivers/infiniband/hw/mlx5/cq.c
@@ -1047,20 +1047,31 @@ int mlx5_ib_create_cq(struct ib_cq *ibcq, const struct ib_cq_init_attr *attr,
 	return err;
 }
 
-int mlx5_ib_destroy_cq(struct ib_cq *cq, struct ib_udata *udata)
+int mlx5_ib_pre_destroy_cq(struct ib_cq *cq)
 {
 	struct mlx5_ib_dev *dev = to_mdev(cq->device);
 	struct mlx5_ib_cq *mcq = to_mcq(cq);
+
+	return mlx5_core_destroy_cq(dev->mdev, &mcq->mcq);
+}
+
+void mlx5_ib_post_destroy_cq(struct ib_cq *cq)
+{
+	destroy_cq_kernel(to_mdev(cq->device), to_mcq(cq));
+}
+
+int mlx5_ib_destroy_cq(struct ib_cq *cq, struct ib_udata *udata)
+{
 	int ret;
 
-	ret = mlx5_core_destroy_cq(dev->mdev, &mcq->mcq);
+	ret = mlx5_ib_pre_destroy_cq(cq);
 	if (ret)
 		return ret;
 
 	if (udata)
-		destroy_cq_user(mcq, udata);
+		destroy_cq_user(to_mcq(cq), udata);
 	else
-		destroy_cq_kernel(dev, mcq);
+		mlx5_ib_post_destroy_cq(cq);
 	return 0;
 }
 
diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 72bba5f05d248..a1a6aca8aff1b 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -3729,7 +3729,9 @@ static const struct ib_device_ops mlx5_ib_dev_ops = {
 	.modify_port = mlx5_ib_modify_port,
 	.modify_qp = mlx5_ib_modify_qp,
 	.modify_srq = mlx5_ib_modify_srq,
+	.pre_destroy_cq = mlx5_ib_pre_destroy_cq,
 	.poll_cq = mlx5_ib_poll_cq,
+	.post_destroy_cq = mlx5_ib_post_destroy_cq,
 	.post_recv = mlx5_ib_post_recv_nodrain,
 	.post_send = mlx5_ib_post_send_nodrain,
 	.post_srq_recv = mlx5_ib_post_srq_recv,
diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index 9b6fa6b1c1cac..2b05470c7011b 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -1277,6 +1277,8 @@ int mlx5_ib_create_cq(struct ib_cq *ibcq, const struct ib_cq_init_attr *attr,
 		      struct ib_udata *udata);
 int mlx5_ib_destroy_cq(struct ib_cq *cq, struct ib_udata *udata);
 int mlx5_ib_poll_cq(struct ib_cq *ibcq, int num_entries, struct ib_wc *wc);
+int mlx5_ib_pre_destroy_cq(struct ib_cq *cq);
+void mlx5_ib_post_destroy_cq(struct ib_cq *cq);
 int mlx5_ib_arm_cq(struct ib_cq *ibcq, enum ib_cq_notify_flags flags);
 int mlx5_ib_modify_cq(struct ib_cq *cq, u16 cq_count, u16 cq_period);
 int mlx5_ib_resize_cq(struct ib_cq *ibcq, int entries, struct ib_udata *udata);
-- 
2.53.0



