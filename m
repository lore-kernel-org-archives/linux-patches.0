Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C54EF24BCE8;
	Mon, 12 May 2025 17:46:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747071998; cv=none; b=cFTg3/VUz+YQZREC4NCJ6vf9LGghtW1NTwMGvOeBByrRA1MD0AdfU/HTmlFeImvKeFw+DUb421QuEDFJg1hDnkQOrDk6LUwOS2bXoS2PJIvnOkPEtavJuvjQGspJvPU/u1ur3ME3SaScfqc+x7DP9ZYEiZys/973XBWBF7pCauY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747071998; c=relaxed/simple;
	bh=AwHs3bj+xEbxyxyo8TsL9s+sqc7A6t09pe0HD6tzYrY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tpYckZCkGNax8rmS85rvfWt8KHMDBLUkivbdAIKY+IVG6JU/O0Ren1IqctUVpY0WkkvSb7yD891GzhpwgWqGy+mFMQ8WoPxd3VQbqftuo6QEvS8p5IccBDThxHaeGp4mLVWItNPdRfoVW3ukpccHuiSs8e5n6OJ11nfLxPaImo4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yOHYY9Pe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yOHYY9Pe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E34DC4CEE7;
	Mon, 12 May 2025 17:46:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747071998;
	bh=AwHs3bj+xEbxyxyo8TsL9s+sqc7A6t09pe0HD6tzYrY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yOHYY9Pesl9hTqYiMi+IrErWdaRZIW9b0lan3XTKMiUF2x7uw03wUwlnNlpb4mlgG
	 vIGm0MK9WQ6dC5zYsOrMLtFzMVNoQF7plQXRTYEaSK1NE9rEymTaGNDizgcvNWl6N4
	 Iw15le4jfIA3M4CP2BcDeEBsqTERXANtScvtT/Vk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Saleemkhan Jamadar <saleemkhan.jamadar@amd.com>,
	Leo Liu <leo.liu@amd.com>,
	Ruijing Dong <ruijing.dong@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.14 105/197] drm/amdgpu/vcn: using separate VCN1_AON_SOC offset
Date: Mon, 12 May 2025 19:39:15 +0200
Message-ID: <20250512172048.657917312@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172044.326436266@linuxfoundation.org>
References: <20250512172044.326436266@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ruijing Dong <ruijing.dong@amd.com>

commit b7e84fb708392b37e5dbb2a95db9b94a0e3f0aa2 upstream.

VCN1_AON_SOC_ADDRESS_3_0 offset varies on different
VCN generations, the issue in vcn4.0.5 is caused by
a different VCN1_AON_SOC_ADDRESS_3_0 offset.

This patch does the following:

    1. use the same offset for other VCN generations.
    2. use the vcn4.0.5 special offset
    3. update vcn_4_0 and vcn_5_0

Acked-by: Saleemkhan Jamadar <saleemkhan.jamadar@amd.com>
Reviewed-by: Leo Liu <leo.liu@amd.com>
Signed-off-by: Ruijing Dong <ruijing.dong@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 5c89ceda9984498b28716944633a9a01cbb2c90d)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_vcn.h |    1 -
 drivers/gpu/drm/amd/amdgpu/vcn_v2_0.c   |    1 +
 drivers/gpu/drm/amd/amdgpu/vcn_v2_5.c   |    1 +
 drivers/gpu/drm/amd/amdgpu/vcn_v3_0.c   |    1 +
 drivers/gpu/drm/amd/amdgpu/vcn_v4_0.c   |    4 +++-
 drivers/gpu/drm/amd/amdgpu/vcn_v4_0_3.c |    1 +
 drivers/gpu/drm/amd/amdgpu/vcn_v4_0_5.c |    1 +
 drivers/gpu/drm/amd/amdgpu/vcn_v5_0_0.c |    3 ++-
 8 files changed, 10 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_vcn.h
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_vcn.h
@@ -66,7 +66,6 @@
 #define VCN_ENC_CMD_REG_WAIT		0x0000000c
 
 #define VCN_AON_SOC_ADDRESS_2_0 	0x1f800
-#define VCN1_AON_SOC_ADDRESS_3_0 	0x48000
 #define VCN_VID_IP_ADDRESS_2_0		0x0
 #define VCN_AON_IP_ADDRESS_2_0		0x30000
 
--- a/drivers/gpu/drm/amd/amdgpu/vcn_v2_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/vcn_v2_0.c
@@ -39,6 +39,7 @@
 
 #define VCN_VID_SOC_ADDRESS_2_0					0x1fa00
 #define VCN1_VID_SOC_ADDRESS_3_0				0x48200
+#define VCN1_AON_SOC_ADDRESS_3_0				0x48000
 
 #define mmUVD_CONTEXT_ID_INTERNAL_OFFSET			0x1fd
 #define mmUVD_GPCOM_VCPU_CMD_INTERNAL_OFFSET			0x503
--- a/drivers/gpu/drm/amd/amdgpu/vcn_v2_5.c
+++ b/drivers/gpu/drm/amd/amdgpu/vcn_v2_5.c
@@ -39,6 +39,7 @@
 
 #define VCN_VID_SOC_ADDRESS_2_0					0x1fa00
 #define VCN1_VID_SOC_ADDRESS_3_0				0x48200
+#define VCN1_AON_SOC_ADDRESS_3_0				0x48000
 
 #define mmUVD_CONTEXT_ID_INTERNAL_OFFSET			0x27
 #define mmUVD_GPCOM_VCPU_CMD_INTERNAL_OFFSET			0x0f
--- a/drivers/gpu/drm/amd/amdgpu/vcn_v3_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/vcn_v3_0.c
@@ -40,6 +40,7 @@
 
 #define VCN_VID_SOC_ADDRESS_2_0					0x1fa00
 #define VCN1_VID_SOC_ADDRESS_3_0				0x48200
+#define VCN1_AON_SOC_ADDRESS_3_0				0x48000
 
 #define mmUVD_CONTEXT_ID_INTERNAL_OFFSET			0x27
 #define mmUVD_GPCOM_VCPU_CMD_INTERNAL_OFFSET			0x0f
--- a/drivers/gpu/drm/amd/amdgpu/vcn_v4_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/vcn_v4_0.c
@@ -46,6 +46,7 @@
 
 #define VCN_VID_SOC_ADDRESS_2_0							0x1fb00
 #define VCN1_VID_SOC_ADDRESS_3_0						0x48300
+#define VCN1_AON_SOC_ADDRESS_3_0						0x48000
 
 #define VCN_HARVEST_MMSCH								0
 
@@ -582,7 +583,8 @@ static void vcn_v4_0_mc_resume_dpg_mode(
 
 	/* VCN global tiling registers */
 	WREG32_SOC15_DPG_MODE(inst_idx, SOC15_DPG_MODE_OFFSET(
-		VCN, 0, regUVD_GFX10_ADDR_CONFIG), adev->gfx.config.gb_addr_config, 0, indirect);
+			VCN, inst_idx, regUVD_GFX10_ADDR_CONFIG),
+			adev->gfx.config.gb_addr_config, 0, indirect);
 }
 
 /**
--- a/drivers/gpu/drm/amd/amdgpu/vcn_v4_0_3.c
+++ b/drivers/gpu/drm/amd/amdgpu/vcn_v4_0_3.c
@@ -44,6 +44,7 @@
 
 #define VCN_VID_SOC_ADDRESS_2_0		0x1fb00
 #define VCN1_VID_SOC_ADDRESS_3_0	0x48300
+#define VCN1_AON_SOC_ADDRESS_3_0	0x48000
 
 static const struct amdgpu_hwip_reg_entry vcn_reg_list_4_0_3[] = {
 	SOC15_REG_ENTRY_STR(VCN, 0, regUVD_POWER_STATUS),
--- a/drivers/gpu/drm/amd/amdgpu/vcn_v4_0_5.c
+++ b/drivers/gpu/drm/amd/amdgpu/vcn_v4_0_5.c
@@ -46,6 +46,7 @@
 
 #define VCN_VID_SOC_ADDRESS_2_0						0x1fb00
 #define VCN1_VID_SOC_ADDRESS_3_0					(0x48300 + 0x38000)
+#define VCN1_AON_SOC_ADDRESS_3_0					(0x48000 + 0x38000)
 
 #define VCN_HARVEST_MMSCH							0
 
--- a/drivers/gpu/drm/amd/amdgpu/vcn_v5_0_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/vcn_v5_0_0.c
@@ -502,7 +502,8 @@ static void vcn_v5_0_0_mc_resume_dpg_mod
 
 	/* VCN global tiling registers */
 	WREG32_SOC24_DPG_MODE(inst_idx, SOC24_DPG_MODE_OFFSET(
-		VCN, 0, regUVD_GFX10_ADDR_CONFIG), adev->gfx.config.gb_addr_config, 0, indirect);
+		VCN, inst_idx, regUVD_GFX10_ADDR_CONFIG),
+		adev->gfx.config.gb_addr_config, 0, indirect);
 
 	return;
 }


