Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57DF52701D1;
	Tue, 11 Nov 2025 01:05:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823123; cv=none; b=vB9ZftJ1VS3pf1lfF0yYiTtGuFGFGMFxUWd3Rkq6otRmGmVDKnbnAdaVB2YSvYMc3NSvatgh5G58OHW+oB8gRAMIAn5o0x6HByWnV2HFhsf6HYHeSAQm5uKkeGkjYnjQF8jNCDp8cRuUX7j/9Eb1Bycv1FgBgzDAL8w7P8UMbVQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823123; c=relaxed/simple;
	bh=zwkiW6AmNgW+4Eva5zs/Dy20gNk+4RZOIGlkRwGgue8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rK4DpAR+onG//zIZ/y9DdQpeCrBFw1ziKgp8TSxS5y3eg5SSKgN3dh8h6TQ/f4y6IbNb2BUcw+dU8JssMkBYjchTZxUrtuQGPsPCgzT1OYpvhb3MKpobrwmOX0MIoWiUQm89ENTeyldKf2uEOvtL8zQbHaycGU/RBoQCR1/0gdg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rvd4hgWC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rvd4hgWC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C69ACC16AAE;
	Tue, 11 Nov 2025 01:05:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823123;
	bh=zwkiW6AmNgW+4Eva5zs/Dy20gNk+4RZOIGlkRwGgue8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rvd4hgWC5cfMDD1To1kV+aZiaq8qg0/i6itULTc0J+8qTOCL01SyNjsPOGPkWGLDy
	 kgBqPBS7Cj/bQJbdTjp/JKn0kW3ffbTJT9ZXd9SQu1pg1r8NeFvHoDapR1ir1NQbXA
	 hBYSFyNalLBw1lV4Ec/6RX1KRKenQHsFndrqPQJs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sathishkumar S <sathishkumar.sundararaju@amd.com>,
	Leo Liu <leo.liu@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 235/849] drm/amdgpu: Check vcn sram load return value
Date: Tue, 11 Nov 2025 09:36:45 +0900
Message-ID: <20251111004542.125538181@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sathishkumar S <sathishkumar.sundararaju@amd.com>

[ Upstream commit faab5ea0836733ef1c8e83cf6b05690a5c9066be ]

Log an error when vcn sram load fails in indirect mode
and return the same error value.

Signed-off-by: Sathishkumar S <sathishkumar.sundararaju@amd.com>
Reviewed-by: Leo Liu <leo.liu@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/vcn_v2_0.c   | 10 ++++++++--
 drivers/gpu/drm/amd/amdgpu/vcn_v2_5.c   | 10 ++++++++--
 drivers/gpu/drm/amd/amdgpu/vcn_v3_0.c   | 10 ++++++++--
 drivers/gpu/drm/amd/amdgpu/vcn_v4_0.c   | 10 ++++++++--
 drivers/gpu/drm/amd/amdgpu/vcn_v4_0_3.c | 11 ++++++++---
 drivers/gpu/drm/amd/amdgpu/vcn_v4_0_5.c | 10 ++++++++--
 drivers/gpu/drm/amd/amdgpu/vcn_v5_0_0.c |  9 +++++++--
 drivers/gpu/drm/amd/amdgpu/vcn_v5_0_1.c | 11 ++++++++---
 8 files changed, 63 insertions(+), 18 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/vcn_v2_0.c b/drivers/gpu/drm/amd/amdgpu/vcn_v2_0.c
index 68b4371df0f1b..d1481e6d57ecd 100644
--- a/drivers/gpu/drm/amd/amdgpu/vcn_v2_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/vcn_v2_0.c
@@ -865,6 +865,7 @@ static int vcn_v2_0_start_dpg_mode(struct amdgpu_vcn_inst *vinst, bool indirect)
 	volatile struct amdgpu_fw_shared *fw_shared = adev->vcn.inst->fw_shared.cpu_addr;
 	struct amdgpu_ring *ring = &adev->vcn.inst->ring_dec;
 	uint32_t rb_bufsz, tmp;
+	int ret;
 
 	vcn_v2_0_enable_static_power_gating(vinst);
 
@@ -948,8 +949,13 @@ static int vcn_v2_0_start_dpg_mode(struct amdgpu_vcn_inst *vinst, bool indirect)
 		UVD, 0, mmUVD_MASTINT_EN),
 		UVD_MASTINT_EN__VCPU_EN_MASK, 0, indirect);
 
-	if (indirect)
-		amdgpu_vcn_psp_update_sram(adev, 0, 0);
+	if (indirect) {
+		ret = amdgpu_vcn_psp_update_sram(adev, 0, 0);
+		if (ret) {
+			dev_err(adev->dev, "vcn sram load failed %d\n", ret);
+			return ret;
+		}
+	}
 
 	/* force RBC into idle state */
 	rb_bufsz = order_base_2(ring->ring_size);
diff --git a/drivers/gpu/drm/amd/amdgpu/vcn_v2_5.c b/drivers/gpu/drm/amd/amdgpu/vcn_v2_5.c
index f13ed3c1e29c2..fdd8e33916f27 100644
--- a/drivers/gpu/drm/amd/amdgpu/vcn_v2_5.c
+++ b/drivers/gpu/drm/amd/amdgpu/vcn_v2_5.c
@@ -1012,6 +1012,7 @@ static int vcn_v2_5_start_dpg_mode(struct amdgpu_vcn_inst *vinst, bool indirect)
 	volatile struct amdgpu_fw_shared *fw_shared = adev->vcn.inst[inst_idx].fw_shared.cpu_addr;
 	struct amdgpu_ring *ring;
 	uint32_t rb_bufsz, tmp;
+	int ret;
 
 	/* disable register anti-hang mechanism */
 	WREG32_P(SOC15_REG_OFFSET(VCN, inst_idx, mmUVD_POWER_STATUS), 1,
@@ -1102,8 +1103,13 @@ static int vcn_v2_5_start_dpg_mode(struct amdgpu_vcn_inst *vinst, bool indirect)
 		VCN, 0, mmUVD_MASTINT_EN),
 		UVD_MASTINT_EN__VCPU_EN_MASK, 0, indirect);
 
-	if (indirect)
-		amdgpu_vcn_psp_update_sram(adev, inst_idx, 0);
+	if (indirect) {
+		ret = amdgpu_vcn_psp_update_sram(adev, inst_idx, 0);
+		if (ret) {
+			dev_err(adev->dev, "vcn sram load failed %d\n", ret);
+			return ret;
+		}
+	}
 
 	ring = &adev->vcn.inst[inst_idx].ring_dec;
 	/* force RBC into idle state */
diff --git a/drivers/gpu/drm/amd/amdgpu/vcn_v3_0.c b/drivers/gpu/drm/amd/amdgpu/vcn_v3_0.c
index 866222fc10a05..b7c4fcca18bb1 100644
--- a/drivers/gpu/drm/amd/amdgpu/vcn_v3_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/vcn_v3_0.c
@@ -1041,6 +1041,7 @@ static int vcn_v3_0_start_dpg_mode(struct amdgpu_vcn_inst *vinst, bool indirect)
 	volatile struct amdgpu_fw_shared *fw_shared = adev->vcn.inst[inst_idx].fw_shared.cpu_addr;
 	struct amdgpu_ring *ring;
 	uint32_t rb_bufsz, tmp;
+	int ret;
 
 	/* disable register anti-hang mechanism */
 	WREG32_P(SOC15_REG_OFFSET(VCN, inst_idx, mmUVD_POWER_STATUS), 1,
@@ -1133,8 +1134,13 @@ static int vcn_v3_0_start_dpg_mode(struct amdgpu_vcn_inst *vinst, bool indirect)
 	WREG32_SOC15_DPG_MODE(inst_idx, SOC15_DPG_MODE_OFFSET(
 		VCN, inst_idx, mmUVD_VCPU_CNTL), tmp, 0, indirect);
 
-	if (indirect)
-		amdgpu_vcn_psp_update_sram(adev, inst_idx, 0);
+	if (indirect) {
+		ret = amdgpu_vcn_psp_update_sram(adev, inst_idx, 0);
+		if (ret) {
+			dev_err(adev->dev, "vcn sram load failed %d\n", ret);
+			return ret;
+		}
+	}
 
 	ring = &adev->vcn.inst[inst_idx].ring_dec;
 	/* force RBC into idle state */
diff --git a/drivers/gpu/drm/amd/amdgpu/vcn_v4_0.c b/drivers/gpu/drm/amd/amdgpu/vcn_v4_0.c
index ac55549e20be6..082def4a6bdfe 100644
--- a/drivers/gpu/drm/amd/amdgpu/vcn_v4_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/vcn_v4_0.c
@@ -1012,6 +1012,7 @@ static int vcn_v4_0_start_dpg_mode(struct amdgpu_vcn_inst *vinst, bool indirect)
 	volatile struct amdgpu_vcn4_fw_shared *fw_shared = adev->vcn.inst[inst_idx].fw_shared.cpu_addr;
 	struct amdgpu_ring *ring;
 	uint32_t tmp;
+	int ret;
 
 	/* disable register anti-hang mechanism */
 	WREG32_P(SOC15_REG_OFFSET(VCN, inst_idx, regUVD_POWER_STATUS), 1,
@@ -1094,8 +1095,13 @@ static int vcn_v4_0_start_dpg_mode(struct amdgpu_vcn_inst *vinst, bool indirect)
 		UVD_MASTINT_EN__VCPU_EN_MASK, 0, indirect);
 
 
-	if (indirect)
-		amdgpu_vcn_psp_update_sram(adev, inst_idx, 0);
+	if (indirect) {
+		ret = amdgpu_vcn_psp_update_sram(adev, inst_idx, 0);
+		if (ret) {
+			dev_err(adev->dev, "vcn sram load failed %d\n", ret);
+			return ret;
+		}
+	}
 
 	ring = &adev->vcn.inst[inst_idx].ring_enc[0];
 
diff --git a/drivers/gpu/drm/amd/amdgpu/vcn_v4_0_3.c b/drivers/gpu/drm/amd/amdgpu/vcn_v4_0_3.c
index ba944a96c0707..2e985c4a288a3 100644
--- a/drivers/gpu/drm/amd/amdgpu/vcn_v4_0_3.c
+++ b/drivers/gpu/drm/amd/amdgpu/vcn_v4_0_3.c
@@ -849,7 +849,7 @@ static int vcn_v4_0_3_start_dpg_mode(struct amdgpu_vcn_inst *vinst,
 	volatile struct amdgpu_vcn4_fw_shared *fw_shared =
 						adev->vcn.inst[inst_idx].fw_shared.cpu_addr;
 	struct amdgpu_ring *ring;
-	int vcn_inst;
+	int vcn_inst, ret;
 	uint32_t tmp;
 
 	vcn_inst = GET_INST(VCN, inst_idx);
@@ -942,8 +942,13 @@ static int vcn_v4_0_3_start_dpg_mode(struct amdgpu_vcn_inst *vinst,
 		VCN, 0, regUVD_MASTINT_EN),
 		UVD_MASTINT_EN__VCPU_EN_MASK, 0, indirect);
 
-	if (indirect)
-		amdgpu_vcn_psp_update_sram(adev, inst_idx, AMDGPU_UCODE_ID_VCN0_RAM);
+	if (indirect) {
+		ret = amdgpu_vcn_psp_update_sram(adev, inst_idx, AMDGPU_UCODE_ID_VCN0_RAM);
+		if (ret) {
+			dev_err(adev->dev, "vcn sram load failed %d\n", ret);
+			return ret;
+		}
+	}
 
 	ring = &adev->vcn.inst[inst_idx].ring_enc[0];
 
diff --git a/drivers/gpu/drm/amd/amdgpu/vcn_v4_0_5.c b/drivers/gpu/drm/amd/amdgpu/vcn_v4_0_5.c
index 11fec716e846a..3ce49dfd3897d 100644
--- a/drivers/gpu/drm/amd/amdgpu/vcn_v4_0_5.c
+++ b/drivers/gpu/drm/amd/amdgpu/vcn_v4_0_5.c
@@ -924,6 +924,7 @@ static int vcn_v4_0_5_start_dpg_mode(struct amdgpu_vcn_inst *vinst,
 	volatile struct amdgpu_vcn4_fw_shared *fw_shared = adev->vcn.inst[inst_idx].fw_shared.cpu_addr;
 	struct amdgpu_ring *ring;
 	uint32_t tmp;
+	int ret;
 
 	/* disable register anti-hang mechanism */
 	WREG32_P(SOC15_REG_OFFSET(VCN, inst_idx, regUVD_POWER_STATUS), 1,
@@ -1004,8 +1005,13 @@ static int vcn_v4_0_5_start_dpg_mode(struct amdgpu_vcn_inst *vinst,
 		VCN, inst_idx, regUVD_MASTINT_EN),
 		UVD_MASTINT_EN__VCPU_EN_MASK, 0, indirect);
 
-	if (indirect)
-		amdgpu_vcn_psp_update_sram(adev, inst_idx, 0);
+	if (indirect) {
+		ret = amdgpu_vcn_psp_update_sram(adev, inst_idx, 0);
+		if (ret) {
+			dev_err(adev->dev, "vcn sram load failed %d\n", ret);
+			return ret;
+		}
+	}
 
 	ring = &adev->vcn.inst[inst_idx].ring_enc[0];
 
diff --git a/drivers/gpu/drm/amd/amdgpu/vcn_v5_0_0.c b/drivers/gpu/drm/amd/amdgpu/vcn_v5_0_0.c
index 07a6e95828808..f8bb90fe764bb 100644
--- a/drivers/gpu/drm/amd/amdgpu/vcn_v5_0_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/vcn_v5_0_0.c
@@ -713,6 +713,7 @@ static int vcn_v5_0_0_start_dpg_mode(struct amdgpu_vcn_inst *vinst,
 	volatile struct amdgpu_vcn5_fw_shared *fw_shared = adev->vcn.inst[inst_idx].fw_shared.cpu_addr;
 	struct amdgpu_ring *ring;
 	uint32_t tmp;
+	int ret;
 
 	/* disable register anti-hang mechanism */
 	WREG32_P(SOC15_REG_OFFSET(VCN, inst_idx, regUVD_POWER_STATUS), 1,
@@ -766,8 +767,12 @@ static int vcn_v5_0_0_start_dpg_mode(struct amdgpu_vcn_inst *vinst,
 		VCN, inst_idx, regUVD_MASTINT_EN),
 		UVD_MASTINT_EN__VCPU_EN_MASK, 0, indirect);
 
-	if (indirect)
-		amdgpu_vcn_psp_update_sram(adev, inst_idx, 0);
+	if (indirect) {
+		ret = amdgpu_vcn_psp_update_sram(adev, inst_idx, 0);
+		dev_err(adev->dev, "%s: vcn sram load failed %d\n", __func__, ret);
+		if (ret)
+			return ret;
+	}
 
 	ring = &adev->vcn.inst[inst_idx].ring_enc[0];
 
diff --git a/drivers/gpu/drm/amd/amdgpu/vcn_v5_0_1.c b/drivers/gpu/drm/amd/amdgpu/vcn_v5_0_1.c
index cdefd7fcb0da6..d8bbb93767318 100644
--- a/drivers/gpu/drm/amd/amdgpu/vcn_v5_0_1.c
+++ b/drivers/gpu/drm/amd/amdgpu/vcn_v5_0_1.c
@@ -605,7 +605,7 @@ static int vcn_v5_0_1_start_dpg_mode(struct amdgpu_vcn_inst *vinst,
 		adev->vcn.inst[inst_idx].fw_shared.cpu_addr;
 	struct amdgpu_ring *ring;
 	struct dpg_pause_state state = {.fw_based = VCN_DPG_STATE__PAUSE};
-	int vcn_inst;
+	int vcn_inst, ret;
 	uint32_t tmp;
 
 	vcn_inst = GET_INST(VCN, inst_idx);
@@ -666,8 +666,13 @@ static int vcn_v5_0_1_start_dpg_mode(struct amdgpu_vcn_inst *vinst,
 		VCN, 0, regUVD_MASTINT_EN),
 		UVD_MASTINT_EN__VCPU_EN_MASK, 0, indirect);
 
-	if (indirect)
-		amdgpu_vcn_psp_update_sram(adev, inst_idx, AMDGPU_UCODE_ID_VCN0_RAM);
+	if (indirect) {
+		ret = amdgpu_vcn_psp_update_sram(adev, inst_idx, AMDGPU_UCODE_ID_VCN0_RAM);
+		if (ret) {
+			dev_err(adev->dev, "vcn sram load failed %d\n", ret);
+			return ret;
+		}
+	}
 
 	/* resetting ring, fw should not check RB ring */
 	fw_shared->sq.queue_mode |= FW_QUEUE_RING_RESET;
-- 
2.51.0



