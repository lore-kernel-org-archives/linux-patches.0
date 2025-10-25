Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA452305051;
	Sat, 25 Oct 2025 16:17:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761409074; cv=none; b=clt8cVr4VWLU+BtnAm0QrCuB5jaI2h7YixTJsf7Tz0gHor9B17P5/DB/iL2p9kexS0sALjWaDA05bYLc6F/fN2MXPDcmauXU8RBdo0NAl1uVhTczcx/C9VDHJvPbSJNkAkfrNzBW5YpiLgHhepTbfNUyst/FWAKCgAklGnlJpxo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761409074; c=relaxed/simple;
	bh=FCArMVWjnscGMtnJ113N+YYqdfA9EBJA1KumvbQntPo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PE+P2Qiqf2FC+iPJWRNZqDMItn6dt6Z5vO+p1/D02hx0dMV/q/hM1vmhb9S/m16YItAk+/eWELXpIXWF2m8FefPGp8mVHe5EBDJznGa38oEH7ig8cCUlKvtecgD943LoLp2eGDzBQGQmbwzo/QTPkf6+PdQ+VXhhwnkFA+z5rpU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EXraoycf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EXraoycf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39383C4CEF5;
	Sat, 25 Oct 2025 16:17:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761409074;
	bh=FCArMVWjnscGMtnJ113N+YYqdfA9EBJA1KumvbQntPo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EXraoycfyT5KOWnUbQY1XO45zlKGAQQaGkd/FN3t4CNt1PeASQ2PDxckHggtetSbN
	 AYos0F/paKq10V5SMX8/oHAEB1GGsEu0wIF2G7e6yoqQhKmety8jPu3SBM6aaDi3iQ
	 nW3c4WKY1w6UCqZ4T/GzS3qKcOEAv8cDLJ5pFwcVoanEKUL2nUeHmpNyucrb/Vde0t
	 hqxL6etbUibnqv4RDR4qG7VdfBHSD2vAagH+1Ag+M14CGkXM90I8zoYE3RzmLOk/51
	 V2H85rzvm4YDAtSeuUuVuBjI9rpfr1LbEML5LzCVE60WLA3P0HUnIUkh1J5JvFMgLf
	 EBJh+DL/AUIYw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Xiang Liu <xiang.liu@amd.com>,
	Tao Zhou <tao.zhou1@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>,
	Hawking.Zhang@amd.com,
	kevinyang.wang@amd.com,
	alexandre.f.demers@gmail.com,
	cesun102@amd.com
Subject: [PATCH AUTOSEL 6.17-6.12] drm/amdgpu: Skip poison aca bank from UE channel
Date: Sat, 25 Oct 2025 11:57:03 -0400
Message-ID: <20251025160905.3857885-192-sashal@kernel.org>
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

From: Xiang Liu <xiang.liu@amd.com>

[ Upstream commit 8e8e08c831f088ed581444c58a635c49ea1222ab ]

Avoid GFX poison consumption errors logged when fatal error occurs.

Signed-off-by: Xiang Liu <xiang.liu@amd.com>
Reviewed-by: Tao Zhou <tao.zhou1@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES

- What it fixes
  - The change filters out non-UMC ACA banks that only indicate “poison”
    when processing the UE (uncorrectable error) channel, which avoids
    spurious “GFX poison consumption” errors being logged during fatal
    errors. This directly addresses noisy/misleading error reporting
    that affects users during GPU fatal error scenarios.

- Key code changes
  - In `aca_smu_get_valid_aca_banks`
    (drivers/gpu/drm/amd/amdgpu/amdgpu_aca.c:135), a new conditional
    skip is added inside the per‑bank loop:
    - Conditions: `type == ACA_SMU_TYPE_UE`,
      `ACA_REG__STATUS__POISON(bank.regs[ACA_REG_IDX_STATUS])`, and
      `!aca_bank_hwip_is_matched(&bank, ACA_HWIP_TYPE_UMC)`.
    - Effect: For UE processing, ACA banks with the POISON bit set that
      are not from UMC are skipped (not logged/processed). This is the
      core behavioral fix.
  - The helper `aca_bank_hwip_is_matched` is moved above to allow its
    use in that function (no behavioral change; just reordering). In
    trees where it’s defined later (e.g.,
    drivers/gpu/drm/amd/amdgpu/amdgpu_aca.c:183), either move it up or
    add a static prototype to avoid implicit declaration errors.
  - The rest of the diff context (e.g., extra logging such as SCRUB) is
    not central to this fix and does not alter the backport’s intent.

- Why it’s correct and minimal
  - “Poison” originates from memory (UMC). When a fatal UE occurs, other
    IPs may reflect poison consumption but should not be counted/logged
    as distinct UE sources; this commit ensures only UMC poison is
    considered in the UE path.
  - The change is localized to one function and one driver file. It does
    not alter SMU programming, scheduling, or broader recovery flow.
  - It only reduces false positives: non-UMC banks with POISON on the UE
    channel are dropped early; non-POISON or UMC banks continue to be
    processed as before.

- Risk and side effects
  - Low risk: The filter applies only when `type == ACA_SMU_TYPE_UE` and
    the POISON bit is set, and only for non‑UMC hardware IPs. It does
    not hide non‑poison UE errors, nor any UMC-origin errors.
  - It reduces misleading GFX-side logs and counters, which can
    otherwise trigger unnecessary investigations or misleading event
    paths.
  - No architectural changes; no API changes; no new features.

- Stable/backport suitability
  - Important bug fix: prevents spurious/misleading error logs during
    fatal events.
  - Small and contained change to a single driver file.
  - No new interfaces; purely defensive filtering logic.
  - Dependencies exist in stable trees:
    - `ACA_REG__STATUS__POISON` is defined
      (drivers/gpu/drm/amd/amdgpu/amdgpu_aca.h:48).
    - `ACA_HWIP_TYPE_UMC` and `aca_bank_hwip_is_matched` exist
      (drivers/gpu/drm/amd/amdgpu/amdgpu_aca.c:183 for the helper; may
      require moving it above or adding a forward declaration).
    - The new check uses the `type` argument already present in
      `aca_smu_get_valid_aca_banks`; it does not depend on newer struct
      fields (e.g., `smu_err_type`) for this logic.
  - No evidence of required follow-ups or reverts for this particular
    behavior. The change is orthogonal to other ACA fixes already in
    stable (e.g., boundary checks).

- Backport note
  - When applying to trees where `aca_bank_hwip_is_matched` is defined
    after `aca_smu_get_valid_aca_banks`
    (drivers/gpu/drm/amd/amdgpu/amdgpu_aca.c:183), either move the
    helper above or add `static bool aca_bank_hwip_is_matched(struct
    aca_bank *, enum aca_hwip_type);` before use to satisfy kernel build
    rules (no implicit declarations).

Conclusion: This is a targeted, low-risk bugfix that reduces false
poison consumption logging during fatal UEs. It fits stable criteria
well and should be backported.

 drivers/gpu/drm/amd/amdgpu/amdgpu_aca.c | 51 +++++++++++++++----------
 1 file changed, 30 insertions(+), 21 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_aca.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_aca.c
index cbc40cad581b4..d1e431818212d 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_aca.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_aca.c
@@ -130,6 +130,27 @@ static void aca_smu_bank_dump(struct amdgpu_device *adev, int idx, int total, st
 		RAS_EVENT_LOG(adev, event_id, HW_ERR "hardware error logged by the scrubber\n");
 }
 
+static bool aca_bank_hwip_is_matched(struct aca_bank *bank, enum aca_hwip_type type)
+{
+
+	struct aca_hwip *hwip;
+	int hwid, mcatype;
+	u64 ipid;
+
+	if (!bank || type == ACA_HWIP_TYPE_UNKNOW)
+		return false;
+
+	hwip = &aca_hwid_mcatypes[type];
+	if (!hwip->hwid)
+		return false;
+
+	ipid = bank->regs[ACA_REG_IDX_IPID];
+	hwid = ACA_REG__IPID__HARDWAREID(ipid);
+	mcatype = ACA_REG__IPID__MCATYPE(ipid);
+
+	return hwip->hwid == hwid && hwip->mcatype == mcatype;
+}
+
 static int aca_smu_get_valid_aca_banks(struct amdgpu_device *adev, enum aca_smu_type type,
 				       int start, int count,
 				       struct aca_banks *banks, struct ras_query_context *qctx)
@@ -168,6 +189,15 @@ static int aca_smu_get_valid_aca_banks(struct amdgpu_device *adev, enum aca_smu_
 
 		bank.smu_err_type = type;
 
+		/*
+		 * Poison being consumed when injecting a UE while running background workloads,
+		 * which are unexpected.
+		 */
+		if (type == ACA_SMU_TYPE_UE &&
+		    ACA_REG__STATUS__POISON(bank.regs[ACA_REG_IDX_STATUS]) &&
+		    !aca_bank_hwip_is_matched(&bank, ACA_HWIP_TYPE_UMC))
+			continue;
+
 		aca_smu_bank_dump(adev, i, count, &bank, qctx);
 
 		ret = aca_banks_add_bank(banks, &bank);
@@ -178,27 +208,6 @@ static int aca_smu_get_valid_aca_banks(struct amdgpu_device *adev, enum aca_smu_
 	return 0;
 }
 
-static bool aca_bank_hwip_is_matched(struct aca_bank *bank, enum aca_hwip_type type)
-{
-
-	struct aca_hwip *hwip;
-	int hwid, mcatype;
-	u64 ipid;
-
-	if (!bank || type == ACA_HWIP_TYPE_UNKNOW)
-		return false;
-
-	hwip = &aca_hwid_mcatypes[type];
-	if (!hwip->hwid)
-		return false;
-
-	ipid = bank->regs[ACA_REG_IDX_IPID];
-	hwid = ACA_REG__IPID__HARDWAREID(ipid);
-	mcatype = ACA_REG__IPID__MCATYPE(ipid);
-
-	return hwip->hwid == hwid && hwip->mcatype == mcatype;
-}
-
 static bool aca_bank_is_valid(struct aca_handle *handle, struct aca_bank *bank, enum aca_smu_type type)
 {
 	const struct aca_bank_ops *bank_ops = handle->bank_ops;
-- 
2.51.0

