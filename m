Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 018D72BAF7;
	Wed, 25 Feb 2026 01:31:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983101; cv=none; b=K/v9+joLyX+bNs9KB3+7g9i8m7r2XYZy9YZW1h2EVe+4L7TajCvIo/nY1AjsB07l889OZhWOpcfuaLBBUY3P3SCnMhRusB+phkh6d70XAmrt0ztsMnPWMDkCbD7Eau/xELKlarqzQFndlXCZbaZJY443nlA68Brj8mhPVmSyU4s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983101; c=relaxed/simple;
	bh=XgN9dv3E8KiQXSYbGxWkrQl2GVdDTrnc/U14gXXCJfU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SHRIc4UmyUEREQLayElWWvU4FfhreJr0P/vYFjV1DSWx6IbER6je0wxuNb8idsmjlxt5HPaNfiRKUcoku07jpxbzwHANwB9zcCSdt6Oh7KmhFkDKXFEIsZt4bpfMQ+E4DLGjvgzsPAosM5Z471ri+wM/1rST+hoHhW+gzWJnd9g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dBdS0CqL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dBdS0CqL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64835C116D0;
	Wed, 25 Feb 2026 01:31:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983100;
	bh=XgN9dv3E8KiQXSYbGxWkrQl2GVdDTrnc/U14gXXCJfU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dBdS0CqLOWbiARoFtY5IrA33wU9HoXNcNUpT/CsglhQhJokhwQ6+9c0i0nD6VC7QV
	 5Bi4p3/10ierHq2ph53KGO4pZeSWoxDZ7eYA5Eee29ORvbPrPCRrV0501hLdo3Xwj9
	 Z/3RXyeuw4sWQGf+Cz+QaT8iVfXvXfE5VbvTEW0M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexey Minnekhanov <alexeymin@minlexx.ru>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 262/781] drm/msm/dpu: drop intr_start from DPU 3.x catalog files
Date: Tue, 24 Feb 2026 17:16:11 -0800
Message-ID: <20260225012406.125158911@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>

[ Upstream commit f4a8e3a34ea4129c743c0d1d050b91b6511abf11 ]

DPU 3.x don't have separate intr_start interrupt, drop it from catalog
files.

Fixes: 94391a14fc27 ("drm/msm/dpu1: Add MSM8998 to hw catalog")
Fixes: 7204df5e7e68 ("drm/msm/dpu: add support for SDM660 and SDM630 platforms")
Patchwork: https://patchwork.freedesktop.org/patch/696488/
Link: https://lore.kernel.org/r/20251228-mdp5-drop-dpu3-v4-1-7497c3d39179@oss.qualcomm.com
Tested-by: Alexey Minnekhanov <alexeymin@minlexx.ru>
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/disp/dpu1/catalog/dpu_3_0_msm8998.h | 5 -----
 drivers/gpu/drm/msm/disp/dpu1/catalog/dpu_3_2_sdm660.h  | 5 -----
 drivers/gpu/drm/msm/disp/dpu1/catalog/dpu_3_3_sdm630.h  | 5 -----
 3 files changed, 15 deletions(-)

diff --git a/drivers/gpu/drm/msm/disp/dpu1/catalog/dpu_3_0_msm8998.h b/drivers/gpu/drm/msm/disp/dpu1/catalog/dpu_3_0_msm8998.h
index f91220496082b..b1b03d8b30fa0 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/catalog/dpu_3_0_msm8998.h
+++ b/drivers/gpu/drm/msm/disp/dpu1/catalog/dpu_3_0_msm8998.h
@@ -42,24 +42,19 @@ static const struct dpu_ctl_cfg msm8998_ctl[] = {
 		.name = "ctl_0", .id = CTL_0,
 		.base = 0x1000, .len = 0x94,
 		.features = BIT(DPU_CTL_SPLIT_DISPLAY),
-		.intr_start = DPU_IRQ_IDX(MDP_SSPP_TOP0_INTR2, 9),
 	}, {
 		.name = "ctl_1", .id = CTL_1,
 		.base = 0x1200, .len = 0x94,
-		.intr_start = DPU_IRQ_IDX(MDP_SSPP_TOP0_INTR2, 10),
 	}, {
 		.name = "ctl_2", .id = CTL_2,
 		.base = 0x1400, .len = 0x94,
 		.features = BIT(DPU_CTL_SPLIT_DISPLAY),
-		.intr_start = DPU_IRQ_IDX(MDP_SSPP_TOP0_INTR2, 11),
 	}, {
 		.name = "ctl_3", .id = CTL_3,
 		.base = 0x1600, .len = 0x94,
-		.intr_start = DPU_IRQ_IDX(MDP_SSPP_TOP0_INTR2, 12),
 	}, {
 		.name = "ctl_4", .id = CTL_4,
 		.base = 0x1800, .len = 0x94,
-		.intr_start = DPU_IRQ_IDX(MDP_SSPP_TOP0_INTR2, 13),
 	},
 };
 
diff --git a/drivers/gpu/drm/msm/disp/dpu1/catalog/dpu_3_2_sdm660.h b/drivers/gpu/drm/msm/disp/dpu1/catalog/dpu_3_2_sdm660.h
index 8f9a097147c02..64df4e80ea43d 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/catalog/dpu_3_2_sdm660.h
+++ b/drivers/gpu/drm/msm/disp/dpu1/catalog/dpu_3_2_sdm660.h
@@ -37,24 +37,19 @@ static const struct dpu_ctl_cfg sdm660_ctl[] = {
 		.name = "ctl_0", .id = CTL_0,
 		.base = 0x1000, .len = 0x94,
 		.features = BIT(DPU_CTL_SPLIT_DISPLAY),
-		.intr_start = DPU_IRQ_IDX(MDP_SSPP_TOP0_INTR2, 9),
 	}, {
 		.name = "ctl_1", .id = CTL_1,
 		.base = 0x1200, .len = 0x94,
-		.intr_start = DPU_IRQ_IDX(MDP_SSPP_TOP0_INTR2, 10),
 	}, {
 		.name = "ctl_2", .id = CTL_2,
 		.base = 0x1400, .len = 0x94,
 		.features = BIT(DPU_CTL_SPLIT_DISPLAY),
-		.intr_start = DPU_IRQ_IDX(MDP_SSPP_TOP0_INTR2, 11),
 	}, {
 		.name = "ctl_3", .id = CTL_3,
 		.base = 0x1600, .len = 0x94,
-		.intr_start = DPU_IRQ_IDX(MDP_SSPP_TOP0_INTR2, 12),
 	}, {
 		.name = "ctl_4", .id = CTL_4,
 		.base = 0x1800, .len = 0x94,
-		.intr_start = DPU_IRQ_IDX(MDP_SSPP_TOP0_INTR2, 13),
 	},
 };
 
diff --git a/drivers/gpu/drm/msm/disp/dpu1/catalog/dpu_3_3_sdm630.h b/drivers/gpu/drm/msm/disp/dpu1/catalog/dpu_3_3_sdm630.h
index 0ad18bd273ff8..b409af8999182 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/catalog/dpu_3_3_sdm630.h
+++ b/drivers/gpu/drm/msm/disp/dpu1/catalog/dpu_3_3_sdm630.h
@@ -36,24 +36,19 @@ static const struct dpu_ctl_cfg sdm630_ctl[] = {
 		.name = "ctl_0", .id = CTL_0,
 		.base = 0x1000, .len = 0x94,
 		.features = BIT(DPU_CTL_SPLIT_DISPLAY),
-		.intr_start = DPU_IRQ_IDX(MDP_SSPP_TOP0_INTR2, 9),
 	}, {
 		.name = "ctl_1", .id = CTL_1,
 		.base = 0x1200, .len = 0x94,
-		.intr_start = DPU_IRQ_IDX(MDP_SSPP_TOP0_INTR2, 10),
 	}, {
 		.name = "ctl_2", .id = CTL_2,
 		.base = 0x1400, .len = 0x94,
 		.features = BIT(DPU_CTL_SPLIT_DISPLAY),
-		.intr_start = DPU_IRQ_IDX(MDP_SSPP_TOP0_INTR2, 11),
 	}, {
 		.name = "ctl_3", .id = CTL_3,
 		.base = 0x1600, .len = 0x94,
-		.intr_start = DPU_IRQ_IDX(MDP_SSPP_TOP0_INTR2, 12),
 	}, {
 		.name = "ctl_4", .id = CTL_4,
 		.base = 0x1800, .len = 0x94,
-		.intr_start = DPU_IRQ_IDX(MDP_SSPP_TOP0_INTR2, 13),
 	},
 };
 
-- 
2.51.0



