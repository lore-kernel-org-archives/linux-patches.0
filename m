Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795056032;
	b=hcyBQr+MazEY5Gj1OTCkryzoHLYY+65cNkrtbkZ3QvchrtK2VsN2Ld+YBApPaU+3+sNu
	 CQUryTbtvC7tNHYjSYT3NHOCzkRglNBy848g+Vg6o3c1v9lTfDcH4kpr/XDgcvFBC1xOm
	 6TDzOv4pYIF0ljmbZTcu5NEheq/w5xV5FNbw70a8ctGg4H1XzVcKnel2MxYR2+6eqwJ2/
	 a6KZlN1F5Bt9gBmiLvYFwqhES7nNL3GGLnOrBcbCpYl+d5+kgMWIU8jkbJXSfc+ujkQS0
	 L+Z94JqcZVx+GlR+IjMmT+ne9fU/bFZgXcE51YxBuzgTPwXsuwDBW2MxC0m2LNDGcvg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056032;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Kl2whb0GOLJ0llWA1JQf4bqqFGfELlIngJJTeeyNDJA=;
	b=LykNFKL8BcR8/Rg5PiDWYiThNsBtjOnJu4CwirWE/YHLbEZA+nKDkWvUr6Tc3dAuZl3P
	 cBgXTM92UhmjChv484HuEABW5+fQlVF+vgM3qMZRcVj3aqv3+YiNj50zHAHobg8Hr3xb4
	 446T0iDaf/IvoSTFwo//bcVqtfJgWxyk6wPTQXSrAYz+OYWK5IUSRUDmFalSQUXreu+l5
	 JJSuQHBzufKZX1Syw7xvZwsKkj0nDxZmmQdoF2evutXdpj6kLhYDOs0VeijlMAlsscloZ
	 hULo7mavU72UvWU/rAMmgB67r07+e1oAFbGEsU+bUpNcMnvpYAdlg1M+h87FfK2qQZg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XMsS0sAK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94317606A320;
	Thu, 19 Nov 2026 02:40:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XMsS0sAK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A56891F000C4;
	Thu, 19 Nov 2026 02:40:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795056032;
	bh=Kl2whb0GOLJ0llWA1JQf4bqqFGfELlIngJJTeeyNDJA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XMsS0sAK9f3IXitXir/mDpcjRpnWIihM2/EOV6M9q7N/FrvvnswsKTk30TqmliVU7
	 XIZdtvz1OYbyg0fzFX9l++YI8z6hzsnyms9+VI5tiuGjfJNpbwVGE3zJADadzd7EFh
	 L4Dwg9mgsJn3/lLFS689vmf3Gsfr2ST3rzfA3hjw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Zhang <markzhang@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1842/2214] RDMA/mlx5: Support driver APIs pre_destroy_cq and post_destroy_cq
Date: Wed, 18 Nov 2026 15:58:38 +0100
Message-ID: <20261118150125.107820435@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 305c1640fde66..ff98fd80c03a7 100644
--- a/drivers/infiniband/hw/mlx5/cq.c
+++ b/drivers/infiniband/hw/mlx5/cq.c
@@ -1037,20 +1037,31 @@ int mlx5_ib_create_cq(struct ib_cq *ibcq, const struct ib_cq_init_attr *attr,
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
index 7afccf1d79d66..7140335a0325e 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -3799,7 +3799,9 @@ static const struct ib_device_ops mlx5_ib_dev_ops = {
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
index 08c59c5a1e108..c5d62ee6f888f 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -1251,6 +1251,8 @@ int mlx5_ib_create_cq(struct ib_cq *ibcq, const struct ib_cq_init_attr *attr,
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



