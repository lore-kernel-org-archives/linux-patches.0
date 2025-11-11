Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDE4726D4DF;
	Tue, 11 Nov 2025 01:05:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823120; cv=none; b=CUyrrUsem9Ib5B0XoIgcaG2OJ7l2XsOVxJF/5MblwDy1fxSM1c86cFCjI3uEjhsR+c8emHxRpfQa6B762FhUTU+Cy8h6TGF3vksaUi2EX2BqxyVaG7Gdmz3g5uScHQ9rysz1pDz50X0txjGgENBwzJmlGV3q6glUzHHnyL0Cubo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823120; c=relaxed/simple;
	bh=M7pD13RZfyI2eCYbMYg5S+rQKpvrS4ag3/CC88RLgkQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DNLxtmKFPDseE4gD0YkFp13neIff5gtk9B7mFjcmf4O2QbtDyx7AbG2Plh3gZ5LLw8WKyIhUYKMvVfQsEp2MwK9dUAzFV2xQnJanIrPXzifOIu0aFSyUVmVsmuJvHkFos06a5CoPYY+7EDmmgkhYEH1fgC+xC2qwQKAhJD0bLDA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PY3a9sd2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PY3a9sd2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63C9AC19422;
	Tue, 11 Nov 2025 01:05:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823120;
	bh=M7pD13RZfyI2eCYbMYg5S+rQKpvrS4ag3/CC88RLgkQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PY3a9sd2HKqFyMzEq3goFvVi96+IxnmMQKJyp0D0aL3d28vcP3+PyAzjRL5BtKbbX
	 Ixg3t5fAiLmSyiLKk06Li+uvG3w7upGvWubN6N423qDOtlaIvzQnwgijP5mFeMDWhU
	 26iqU5/DYdZqiCrfmgwZ/OM9Z/ddzQj05XMW1bCc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sathishkumar S <sathishkumar.sundararaju@amd.com>,
	Leo Liu <leo.liu@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 175/565] drm/amdgpu: Check vcn sram load return value
Date: Tue, 11 Nov 2025 09:40:31 +0900
Message-ID: <20251111004530.871668101@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index f0edaabdcde5d..f085fdaafae00 100644
--- a/drivers/gpu/drm/amd/amdgpu/vcn_v2_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/vcn_v2_0.c
@@ -842,6 +842,7 @@ static int vcn_v2_0_start_dpg_mode(struct amdgpu_device *adev, bool indirect)
 	volatile struct amdgpu_fw_shared *fw_shared = adev->vcn.inst->fw_shared.cpu_addr;
 	struct amdgpu_ring *ring = &adev->vcn.inst->ring_dec;
 	uint32_t rb_bufsz, tmp;
+	int ret;
 
 	vcn_v2_0_enable_static_power_gating(adev);
 
@@ -925,8 +926,13 @@ static int vcn_v2_0_start_dpg_mode(struct amdgpu_device *adev, bool indirect)
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
index e4d0c0310e76d..274d5063e9a26 100644
--- a/drivers/gpu/drm/amd/amdgpu/vcn_v2_5.c
+++ b/drivers/gpu/drm/amd/amdgpu/vcn_v2_5.c
@@ -870,6 +870,7 @@ static int vcn_v2_5_start_dpg_mode(struct amdgpu_device *adev, int inst_idx, boo
 	volatile struct amdgpu_fw_shared *fw_shared = adev->vcn.inst[inst_idx].fw_shared.cpu_addr;
 	struct amdgpu_ring *ring;
 	uint32_t rb_bufsz, tmp;
+	int ret;
 
 	/* disable register anti-hang mechanism */
 	WREG32_P(SOC15_REG_OFFSET(VCN, inst_idx, mmUVD_POWER_STATUS), 1,
@@ -960,8 +961,13 @@ static int vcn_v2_5_start_dpg_mode(struct amdgpu_device *adev, int inst_idx, boo
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
index 9700414520963..4196bdece253b 100644
--- a/drivers/gpu/drm/amd/amdgpu/vcn_v3_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/vcn_v3_0.c
@@ -990,6 +990,7 @@ static int vcn_v3_0_start_dpg_mode(struct amdgpu_device *adev, int inst_idx, boo
 	volatile struct amdgpu_fw_shared *fw_shared = adev->vcn.inst[inst_idx].fw_shared.cpu_addr;
 	struct amdgpu_ring *ring;
 	uint32_t rb_bufsz, tmp;
+	int ret;
 
 	/* disable register anti-hang mechanism */
 	WREG32_P(SOC15_REG_OFFSET(VCN, inst_idx, mmUVD_POWER_STATUS), 1,
@@ -1082,8 +1083,13 @@ static int vcn_v3_0_start_dpg_mode(struct amdgpu_device *adev, int inst_idx, boo
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
index 33d413444a46a..ae510fd9d2944 100644
--- a/drivers/gpu/drm/amd/amdgpu/vcn_v4_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/vcn_v4_0.c
@@ -963,6 +963,7 @@ static int vcn_v4_0_start_dpg_mode(struct amdgpu_device *adev, int inst_idx, boo
 	volatile struct amdgpu_vcn4_fw_shared *fw_shared = adev->vcn.inst[inst_idx].fw_shared.cpu_addr;
 	struct amdgpu_ring *ring;
 	uint32_t tmp;
+	int ret;
 
 	/* disable register anti-hang mechanism */
 	WREG32_P(SOC15_REG_OFFSET(VCN, inst_idx, regUVD_POWER_STATUS), 1,
@@ -1045,8 +1046,13 @@ static int vcn_v4_0_start_dpg_mode(struct amdgpu_device *adev, int inst_idx, boo
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
index 77542dabec59f..2094357a931c4 100644
--- a/drivers/gpu/drm/amd/amdgpu/vcn_v4_0_3.c
+++ b/drivers/gpu/drm/amd/amdgpu/vcn_v4_0_3.c
@@ -778,7 +778,7 @@ static int vcn_v4_0_3_start_dpg_mode(struct amdgpu_device *adev, int inst_idx, b
 	volatile struct amdgpu_vcn4_fw_shared *fw_shared =
 						adev->vcn.inst[inst_idx].fw_shared.cpu_addr;
 	struct amdgpu_ring *ring;
-	int vcn_inst;
+	int vcn_inst, ret;
 	uint32_t tmp;
 
 	vcn_inst = GET_INST(VCN, inst_idx);
@@ -871,8 +871,13 @@ static int vcn_v4_0_3_start_dpg_mode(struct amdgpu_device *adev, int inst_idx, b
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
index 3d114ea7049f7..48cb61a9c13fe 100644
--- a/drivers/gpu/drm/amd/amdgpu/vcn_v4_0_5.c
+++ b/drivers/gpu/drm/amd/amdgpu/vcn_v4_0_5.c
@@ -876,6 +876,7 @@ static int vcn_v4_0_5_start_dpg_mode(struct amdgpu_device *adev, int inst_idx, b
 	volatile struct amdgpu_vcn4_fw_shared *fw_shared = adev->vcn.inst[inst_idx].fw_shared.cpu_addr;
 	struct amdgpu_ring *ring;
 	uint32_t tmp;
+	int ret;
 
 	/* disable register anti-hang mechanism */
 	WREG32_P(SOC15_REG_OFFSET(VCN, inst_idx, regUVD_POWER_STATUS), 1,
@@ -956,8 +957,13 @@ static int vcn_v4_0_5_start_dpg_mode(struct amdgpu_device *adev, int inst_idx, b
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
index d19eec4d47905..cc7add217fd19 100644
--- a/drivers/gpu/drm/amd/amdgpu/vcn_v5_0_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/vcn_v5_0_0.c
@@ -665,6 +665,7 @@ static int vcn_v5_0_0_start_dpg_mode(struct amdgpu_device *adev, int inst_idx, b
 	volatile struct amdgpu_vcn5_fw_shared *fw_shared = adev->vcn.inst[inst_idx].fw_shared.cpu_addr;
 	struct amdgpu_ring *ring;
 	uint32_t tmp;
+	int ret;
 
 	/* disable register anti-hang mechanism */
 	WREG32_P(SOC15_REG_OFFSET(VCN, inst_idx, regUVD_POWER_STATUS), 1,
@@ -718,8 +719,12 @@ static int vcn_v5_0_0_start_dpg_mode(struct amdgpu_device *adev, int inst_idx, b
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



