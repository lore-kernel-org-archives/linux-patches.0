Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8E574B0492;
	Mon, 17 Aug 2026 13:39:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786973965; cv=none; b=cQnByt/uI0Y4NDxWuHKC0FGLGezTupy1JgiNsVVERR3Ft2KFDkT/7FfoNIZnZs+1OvUdcrExEmVftU596A8QBcIr35gOmMcOdxkWuB71WhjLPT7mX30CRh68kSavTlMBsDPkhXPkOBZTEmXKEBa4EYz4ZuS4h5ryME+smnFtehY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786973965; c=relaxed/simple;
	bh=7a4Jz0d2jKa45MAmMUHNVtu4nIepfqNSDAcbBZlCb6w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Pk7JjCCwBV6uaP3HR6l5XY68msVMPaER353JIpy8TW9Q0nbAQmoMt6ltA8MuEJihae0LL6S4e5f4Kr37M58bDOHSx1sehneJejD+7C8shOG8psL6OsKGAFv/PDB7rzr7LzINMZJoxaEO0yXrt+vBkV5ey14cJ9v+vL/o+Qu/t50=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0OmopDpl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0OmopDpl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADF5F1F000E9;
	Mon, 17 Aug 2026 13:39:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786973964;
	bh=xLGjxaWRGDI38PjsENaSEzh8ZPjm/pttVmoR4exeWKI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0OmopDplmT8FsM7wgGYi0EuTJc4Z/kATLHzlUhNBvr6IELh4088IsUuAncM5ZPRdh
	 +Pb3Up7IFdlKPnB3moyDIzAPzQjS85qSXZ69WEyOPb5+f1cVNjN6hTjSooSXbesmIx
	 hcsHr1iPsnIZGJCD7y6ElgfpQsMY8K/V0z8KeqkE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Akhil P Oommen <akhilpo@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 009/271] arm64: dts: qcom: purwa: Fix GPU IOMMU property
Date: Mon, 17 Aug 2026 15:28:54 +0200
Message-ID: <20260817132537.143530217@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132536.752504388@linuxfoundation.org>
References: <20260817132536.752504388@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Akhil P Oommen <akhilpo@oss.qualcomm.com>

[ Upstream commit 4cd774c1feb3f720265c512174c5c3312eca1be2 ]

Purwa's GPU does not support SID 1, which is typically used for
LPAC-related traffic. Remove SID 1 from the GPU node's iommus property to
accurately describe the hardware. This fixes the splat below, seen with
some versions of Gunyah hypervisor:

  Internal error: synchronous external abort: 0000000096000010 [#1]  SMP
  CPU: 0 UID: 0 PID: 80 Comm: kworker/u33:2 Tainted: G   M
  Tainted: [M]=MACHINE_CHECK
  Hardware name: Qualcomm Technologies, Inc. Purwa IoT EVK (DT)
  Workqueue: events_unbound deferred_probe_work_func
  pstate: 21400005 (nzCv daif +PAN -UAO -TCO +DIT -SSBS BTYPE=--)
  pc : arm_smmu_write_s2cr+0x9c/0xbc
  lr : arm_smmu_master_install_s2crs+0x78/0xa4
  sp : ffff80008039b570
  x29: ffff80008039b570 x28: 0000000000000000 x27: ffffaddd62f1ab78
  x26: ffff00080a4ff280 x25: 0000000000000018 x24: ffff00080b896480
  x23: ffff00080ba9b7a0 x22: ffff00080bb05160 x21: 0000000000000000
  x20: 0000000000000000 x19: 0000000000000001 x18: 00000000ffffffff
  x17: 0000000000000000 x16: 0000000000000000 x15: ffff80008039b1d0
  x14: ffff80010039b37d x13: 00746c7561662d74 x12: 0000000000000000
  x11: ffff00080b7fbd98 x10: ffffffffffffffc0 x9 : ffffffffffffffff
  x8 : 0000000000000228 x7 : 0000000000000e87 x6 : 0000000000000000
  x5 : 0000000000000000 x4 : ffff00080a4ff280 x3 : 0000000000000000
  x2 : ffff800082a40c04 x1 : 0000000000000000 x0 : ffff800082a40000
  Call trace:
   arm_smmu_write_s2cr+0x9c/0xbc (P)
   arm_smmu_master_install_s2crs+0x78/0xa4
   arm_smmu_attach_dev+0xb0/0x1d8
   __iommu_device_set_domain+0x84/0x11c
   __iommu_group_set_domain_internal+0x60/0x120
   __iommu_attach_group+0x88/0x9c
   iommu_attach_device+0x6c/0xa0
   msm_iommu_new.part.0+0x84/0xe4 [msm]
   msm_iommu_gpu_new+0x3c/0x104 [msm]
   adreno_iommu_create_vm+0x24/0xc8 [msm]
   a6xx_create_vm+0x48/0x78 [msm]
   msm_gpu_init+0x2d8/0x508 [msm]
   adreno_gpu_init+0x208/0x324 [msm]
   a6xx_gpu_init+0x604/0x8cc [msm]
   adreno_bind+0xb4/0x124 [msm]
   component_bind_all+0x114/0x23c
   msm_drm_init+0x1b0/0x1ec [msm]
   msm_drm_bind+0x30/0x3c [msm]
   try_to_bring_up_aggregate_device+0x164/0x1d0
   __component_add+0xa4/0x16c
   component_add+0x14/0x20
   msm_dp_display_probe_tail+0x4c/0xac [msm]
   msm_dp_auxbus_done_probe+0x14/0x20 [msm]
   dp_aux_ep_probe+0x4c/0xf4 [drm_dp_aux_bus]
   really_probe+0xbc/0x29c
   __driver_probe_device+0x78/0x12c
   driver_probe_device+0x3c/0x15c
   __device_attach_driver+0xb8/0x134
   bus_for_each_drv+0x88/0xe8
   __device_attach+0xa0/0x190
   device_initial_probe+0x50/0x54
   bus_probe_device+0x38/0xa4
   deferred_probe_work_func+0x88/0xc0
   process_one_work+0x148/0x28c
   worker_thread+0x2cc/0x3d4
   kthread+0x12c/0x204
   ret_from_fork+0x10/0x20
  ---[ end trace 0000000000000000 ]---

Fixes: 1aa0b4e36436 ("arm64: dts: qcom: x1p42100: Add GPU support")
Signed-off-by: Akhil P Oommen <akhilpo@oss.qualcomm.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260410-purwa-gpu-dt-fix-v1-1-4637892156cf@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/purwa.dtsi | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/purwa.dtsi b/arch/arm64/boot/dts/qcom/purwa.dtsi
index 9ab4f26b35f29..5b17840fb62fb 100644
--- a/arch/arm64/boot/dts/qcom/purwa.dtsi
+++ b/arch/arm64/boot/dts/qcom/purwa.dtsi
@@ -47,6 +47,8 @@ &gmu {
 &gpu {
 	compatible = "qcom,adreno-43030c00", "qcom,adreno";
 
+	iommus = <&adreno_smmu 0 0x0>;
+
 	nvmem-cells = <&gpu_speed_bin>;
 	nvmem-cell-names = "speed_bin";
 
-- 
2.53.0



