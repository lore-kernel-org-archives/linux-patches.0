Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B76823D7F0;
	Sat, 25 Oct 2025 16:21:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761409271; cv=none; b=ihSp7FyYgozOtxoYp92Oa1bHhAHky8IcgWHwEXiY75Ww6eUqDFhlEbhD1D98Iyd56isCktnm0NWCUh13VGRXhYROkK9loqMpn5XTBZaD45SiVAqc+LF2ube9hY6QoX8BeZCIyCPt3QbT8AFLV+ZNxaSAn/4FyyoudK2rSvgs+9s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761409271; c=relaxed/simple;
	bh=hQhUcECGAfLSwPvXwBPH6SPlIk3HTugC1U1DevKgAGI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WmKZDapA+3v5MznA1TF3fK/PoLoPM8OEGV/+IUy6sact0tsnm2EuFbO8P+zJiHG07X+qdWRTpf6bBzZxtfG+BkZX4vyIJmMsctEMpDK9aCC2j/0Q7DdgopVJmCMxEXvPpyNTtxxZCTutw7nslAaR/bCgvms+IyJGGIk9gLFtqzU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=b4DDZ15X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="b4DDZ15X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7AA1C116D0;
	Sat, 25 Oct 2025 16:21:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761409267;
	bh=hQhUcECGAfLSwPvXwBPH6SPlIk3HTugC1U1DevKgAGI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b4DDZ15Xbq99BKyycOT5YedwtAPjMTHRv3oovdvD87CgooV+EP51JBM1bLo4gXzne
	 nj3eMyDWP3rFx4d3DqvVXpYhTHs7FreXxT37cdKP9fuk4WT/oREw921aNDhkYPjtpW
	 KOg/qwAZZzMfH01aTPthHt38WP+oWp4rGvd8irQOIh/XlVLTg7MZjP5RbgMFnuxGcT
	 W+SpSVkk+KkdHydy/FJIX1int8Fvgr7M3f4bzdRcwXjqOlmy1garplcZPFMNdtHG+I
	 VLh8FnVjNzkflltR/Ld90qFxiuXmqKBURpWaH9MUII5sR2+OCoWsjhiSETBXfZHGAy
	 2G6Egqxsgi6/w==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Sathishkumar S <sathishkumar.sundararaju@amd.com>,
	Leo Liu <leo.liu@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>,
	boyuan.zhang@amd.com,
	christian.koenig@amd.com,
	sunil.khatri@amd.com,
	ruijing.dong@amd.com,
	siqueira@igalia.com,
	alexandre.f.demers@gmail.com,
	david.rosca@amd.com,
	David.Wu3@amd.com,
	lijo.lazar@amd.com,
	xiang.liu@amd.com,
	Hawking.Zhang@amd.com,
	sonny.jiang@amd.com,
	Mangesh.Gadre@amd.com,
	FangSheng.Huang@amd.com
Subject: [PATCH AUTOSEL 6.17-6.12] drm/amdgpu: Check vcn sram load return value
Date: Sat, 25 Oct 2025 11:58:07 -0400
Message-ID: <20251025160905.3857885-256-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251025160905.3857885-1-sashal@kernel.org>
References: <20251025160905.3857885-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Sathishkumar S <sathishkumar.sundararaju@amd.com>

[ Upstream commit faab5ea0836733ef1c8e83cf6b05690a5c9066be ]

Log an error when vcn sram load fails in indirect mode
and return the same error value.

Signed-off-by: Sathishkumar S <sathishkumar.sundararaju@amd.com>
Reviewed-by: Leo Liu <leo.liu@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES

- What it fixes
  - Previously, `amdgpu_vcn_psp_update_sram()` return codes were ignored
    in DPG “indirect” SRAM-load paths. If PSP SRAM load fails, the
    driver silently continues to program rings and unblock interrupts,
    leading to undefined behavior or later failures/timeouts with no
    clear root cause. This change logs the error and returns it
    immediately, making the failure visible and halting the start
    sequence at the right spot.

- Scope and changes
  - The change is small and localized: introduce `int ret;`, call `ret =
    amdgpu_vcn_psp_update_sram(...)`, and if non-zero, `dev_err(...)`
    and `return ret` in the DPG indirect path of VCN start across
    generations.
  - Files and functions updated:
    - `drivers/gpu/drm/amd/amdgpu/vcn_v2_0.c`:
      `vcn_v2_0_start_dpg_mode(...)` — checks and returns on error after
      enabling master interrupt.
    - `drivers/gpu/drm/amd/amdgpu/vcn_v2_5.c`:
      `vcn_v2_5_start_dpg_mode(...)` — same pattern, per-instance
      (`inst_idx`) handling.
    - `drivers/gpu/drm/amd/amdgpu/vcn_v3_0.c`:
      `vcn_v3_0_start_dpg_mode(...)` — same pattern; placed after the
      “add nop to workaround PSP size check” write.
    - `drivers/gpu/drm/amd/amdgpu/vcn_v4_0.c`:
      `vcn_v4_0_start_dpg_mode(...)` — same pattern.
    - `drivers/gpu/drm/amd/amdgpu/vcn_v4_0_3.c`:
      `vcn_v4_0_3_start_dpg_mode(...)` — same pattern; uses
      `AMDGPU_UCODE_ID_VCN0_RAM` when calling
      `amdgpu_vcn_psp_update_sram`.
    - `drivers/gpu/drm/amd/amdgpu/vcn_v4_0_5.c`:
      `vcn_v4_0_5_start_dpg_mode(...)` — same pattern.
    - `drivers/gpu/drm/amd/amdgpu/vcn_v5_0_0.c`:
      `vcn_v5_0_0_start_dpg_mode(...)` — adds error check, but currently
      prints `dev_err(...)` unconditionally before `if (ret) return
      ret;` (this should be conditional to avoid spurious “failed 0”
      messages).
    - `drivers/gpu/drm/amd/amdgpu/vcn_v5_0_1.c`:
      `vcn_v5_0_1_start_dpg_mode(...)` — same pattern; uses
      `AMDGPU_UCODE_ID_VCN0_RAM`.

- Why it fits stable
  - Bug fix: converts a silent failure path into a logged, properly-
    returned error in start-up sequencing. This clearly affects users
    when SRAM load fails (e.g., firmware load/size mismatch or PSP
    rejects the request).
  - Minimal and contained: no API/ABI changes, no architectural
    refactor. Only adds a few lines per function and an early return on
    actual error.
  - Low regression risk: the functions already return `int`; calling
    code in some trees may ignore the return (so behavior remains mostly
    unchanged except better logging), and where callers do propagate,
    the error handling is now correct and earlier.
  - No feature addition; strictly error handling.
  - Touches a driver subsystem (amdgpu VCN) in a focused way.

- Notable caveat to fix while backporting
  - In `vcn_v5_0_0.c`, the added `dev_err(adev->dev, "%s: vcn sram load
    failed %d\n", __func__, ret);` is placed before the `if (ret)`,
    which logs an error even when `ret == 0`. For stable, make the log
    conditional (only print on non-zero `ret`) to avoid noisy false
    errors:
    - `drivers/gpu/drm/amd/amdgpu/vcn_v5_0_0.c`: change to:
      - `ret = amdgpu_vcn_psp_update_sram(...);`
      - `if (ret) { dev_err(..., ret); return ret; }`

- Additional context
  - `amdgpu_vcn_psp_update_sram()` already returns the status of
    `psp_execute_ip_fw_load`, so callers should not ignore it. The
    change aligns all DPG-indirect code paths to check it.
  - Even where the higher-level `start()` ignores `start_dpg_mode()`’s
    return, this commit still improves diagnostics and avoids continuing
    the start sequence after a known failure.

Given the above, this is an appropriate, low-risk bug fix for stable.

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

