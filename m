Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 183952F5B;
	Sat, 25 Oct 2025 16:12:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761408776; cv=none; b=uibokFeQYAOtEkkE00RWolw0ylsOHTd5UDuksHkjioM0CrVdQEYkrhzC/yYBdvA8m+zUxfnM0Bkoyz6I39lvBEHK1OVTelNgb2CvQqjWjFTTdJd5hzSvBqYIxBgwtSmtGm5p1GLtyUgwzNbXGjE9GlrELHgRet3qMDy6x0qhOXU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761408776; c=relaxed/simple;
	bh=lQP2wYT1hsHH43gq+DZzG3vBY0LhtN1Ub/HdZD/NUIQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KvCsmz5nWtxillaYIzfx5jCz1JYP3VPpBjsZ0J7X2HNSKabV9IZBaIY5G1eWQBJeHQ3EnH5oh7OUQo1wCfdgiwQG+gRNqgwJrS+SQLynqdrMv21i+G/c5S9AQju7AFJdtYa5jLrGrWX5qjgmhPP9OJ7MEatpuUiIIyXJRfozuRE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=k+7h3jbL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="k+7h3jbL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60188C4CEF5;
	Sat, 25 Oct 2025 16:12:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761408775;
	bh=lQP2wYT1hsHH43gq+DZzG3vBY0LhtN1Ub/HdZD/NUIQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k+7h3jbL/d1p2B34Fmc9wQxtjCBIRHnC6yFeXWLqlzv8TdIA0ph/OUQNtrYqLTfj1
	 yFbftAvq1OfCV8FZnvuQ/d98ukZbAwTpszg0YiTaNwLkaHE5Y1Sz+ovGH/dfAEnXDj
	 eHrEvmOxdc0tWZwo+5vZCYUBrKKW5X7lEMjIvRvByjy84ml809uaMrEuLq1a3DbuaG
	 Xf6/FLSWM7vYLrwlllYlxDf8cRyCgcAG2hTc2Cwjj+E8Uq25MxJFqGFFWqLf1DYeEV
	 WZ5IyEKOcFVXjt0WlkovOwalwg6B1Ap9IY7RTepTldAqsvhNPj6YgO0ghe6ZFwJch/
	 mgOqyXTI9tjiQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Sk Anirban <sk.anirban@intel.com>,
	Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>,
	Lucas De Marchi <lucas.demarchi@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	thomas.hellstrom@linux.intel.com,
	rodrigo.vivi@intel.com,
	John.C.Harrison@Intel.com,
	badal.nilawar@intel.com,
	nitin.r.gote@intel.com,
	alexandre.f.demers@gmail.com,
	intel-xe@lists.freedesktop.org
Subject: [PATCH AUTOSEL 6.17] drm/xe/ptl: Apply Wa_16026007364
Date: Sat, 25 Oct 2025 11:54:57 -0400
Message-ID: <20251025160905.3857885-66-sashal@kernel.org>
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

From: Sk Anirban <sk.anirban@intel.com>

[ Upstream commit d72779c29d82c6e371cea8b427550bd6923c2577 ]

As part of this WA GuC will save and restore value of two XE3_Media
control registers that were not included in the HW power context.

Signed-off-by: Sk Anirban <sk.anirban@intel.com>
Reviewed-by: Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>
Link: https://lore.kernel.org/r/20250716101622.3421480-2-sk.anirban@intel.com
Signed-off-by: Lucas De Marchi <lucas.demarchi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES

- What changed (files and specifics)
  - drivers/gpu/drm/xe/abi/guc_klvs_abi.h: Adds a new GuC WA KLV key
    enum, `GUC_WA_KLV_RESTORE_UNSAVED_MEDIA_CONTROL_REG = 0x900c` (near
    existing WA keys at drivers/gpu/drm/xe/abi/guc_klvs_abi.h:350). This
    is a pure additive identifier so existing paths are unaffected.
  - drivers/gpu/drm/xe/xe_guc_ads.c: Introduces
    `guc_waklv_enable_two_word(...)`, a helper to emit a KLV with LEN=2
    and two 32‑bit payload values, mirroring the existing one‑word and
    simple (LEN=0) helpers (see the existing one‑word helper at
    drivers/gpu/drm/xe/xe_guc_ads.c:288 and `guc_waklv_init` at
    drivers/gpu/drm/xe/xe_guc_ads.c:338).
    - In `guc_waklv_init`, it conditionally emits the new WA KLV only
      when both conditions hold:
      - GuC firmware release version is >= `MAKE_GUC_VER(70, 47, 0)`.
      - Platform WA bit `XE_WA(gt, 16026007364)` is set.
    - The KLV is sent with two dwords `0x0` and `0xF`, via
      `guc_waklv_enable_two_word(...)`, and appended into the existing
      ADS WA KLV buffer using the same offset/remain logic and
      `xe_map_memcpy_to(...)` used by other KLV helpers; on insufficient
      space it only `drm_warn(...)`, matching style already used for
      other entries.
  - drivers/gpu/drm/xe/xe_wa_oob.rules: Adds WA rule `16026007364
    MEDIA_VERSION(3000)`, causing the build to generate
    `XE_WA_OOB_16026007364` for Xe3 Media in `<generated/xe_wa_oob.h>`,
    which then makes `XE_WA(gt, 16026007364)` true on the intended
    hardware.

- Why it matters (bug impact)
  - Commit message: “As part of this WA GuC will save and restore value
    of two XE3_Media control registers that were not included in the HW
    power context.” That means state for two critical media control
    registers is lost across power context save/restore without this WA.
    On affected Xe3 Media platforms, this can cause functional issues on
    power transitions (e.g., RC6 exit, power-gating), impacting users
    running media workloads.

- Scope and risk
  - Small and contained: One enum addition, one helper function, one
    gated call in `guc_waklv_init`, and one WA rule line. No
    architectural changes; no ABI/uAPI changes.
  - Proper gating minimizes regression risk:
    - Firmware gating: The KLV is only sent when
      `GUC_FIRMWARE_VER(&gt->uc.guc) >= MAKE_GUC_VER(70, 47, 0)`, so
      older GuC releases won’t see unknown keys.
    - Hardware gating: The WA is enabled only when `XE_WA(gt,
      16026007364)` is set by the generated OOB WA database for
      `MEDIA_VERSION(3000)`. Other platforms remain untouched.
  - Buffering safety: The WA KLV blob is sized to a full page
    (`guc_ads_waklv_size` returns `SZ_4K`), and the helper checks
    `remain` before writing; failure cases only warn and do not corrupt
    data.
  - Consistency: The new two‑word helper mirrors existing
    one‑word/simple KLV emission patterns
    (drivers/gpu/drm/xe/xe_guc_ads.c:288, 315), and the KLV header
    fields (`GUC_KLV_0_KEY`, `GUC_KLV_0_LEN`) are used consistently with
    other KLV users across the driver.

- Stable backport criteria
  - Fixes a real, user‑visible hardware/firmware interaction bug (lost
    register state on Xe3 Media power transitions).
  - Minimal, localized change within DRM/Xe; no core kernel or
    cross‑subsystem impact.
  - No new features; it only enables a firmware WA when present and
    applicable.
  - Low regression risk due to strict firmware and platform gating.
  - Even if the deployed firmware is older than 70.47.0, the change is
    inert (the KLV is not sent), so it cannot regress those systems and
    transparently benefits systems once they pick up newer GuC firmware.

Given the above, this is a good candidate for stable backport to improve
reliability on affected Xe3 Media platforms with appropriate GuC
firmware.

 drivers/gpu/drm/xe/abi/guc_klvs_abi.h |  1 +
 drivers/gpu/drm/xe/xe_guc_ads.c       | 35 +++++++++++++++++++++++++++
 drivers/gpu/drm/xe/xe_wa_oob.rules    |  1 +
 3 files changed, 37 insertions(+)

diff --git a/drivers/gpu/drm/xe/abi/guc_klvs_abi.h b/drivers/gpu/drm/xe/abi/guc_klvs_abi.h
index d7719d0e36ca7..45a321d0099f1 100644
--- a/drivers/gpu/drm/xe/abi/guc_klvs_abi.h
+++ b/drivers/gpu/drm/xe/abi/guc_klvs_abi.h
@@ -421,6 +421,7 @@ enum xe_guc_klv_ids {
 	GUC_WORKAROUND_KLV_ID_BACK_TO_BACK_RCS_ENGINE_RESET				= 0x9009,
 	GUC_WA_KLV_WAKE_POWER_DOMAINS_FOR_OUTBOUND_MMIO					= 0x900a,
 	GUC_WA_KLV_RESET_BB_STACK_PTR_ON_VF_SWITCH					= 0x900b,
+	GUC_WA_KLV_RESTORE_UNSAVED_MEDIA_CONTROL_REG					= 0x900c,
 };
 
 #endif
diff --git a/drivers/gpu/drm/xe/xe_guc_ads.c b/drivers/gpu/drm/xe/xe_guc_ads.c
index 131cfc56be00a..8ff8626227ae4 100644
--- a/drivers/gpu/drm/xe/xe_guc_ads.c
+++ b/drivers/gpu/drm/xe/xe_guc_ads.c
@@ -284,6 +284,35 @@ static size_t calculate_golden_lrc_size(struct xe_guc_ads *ads)
 	return total_size;
 }
 
+static void guc_waklv_enable_two_word(struct xe_guc_ads *ads,
+				      enum xe_guc_klv_ids klv_id,
+				      u32 value1,
+				      u32 value2,
+				      u32 *offset, u32 *remain)
+{
+	u32 size;
+	u32 klv_entry[] = {
+			/* 16:16 key/length */
+			FIELD_PREP(GUC_KLV_0_KEY, klv_id) |
+			FIELD_PREP(GUC_KLV_0_LEN, 2),
+			value1,
+			value2,
+			/* 2 dword data */
+	};
+
+	size = sizeof(klv_entry);
+
+	if (*remain < size) {
+		drm_warn(&ads_to_xe(ads)->drm,
+			 "w/a klv buffer too small to add klv id %d\n", klv_id);
+	} else {
+		xe_map_memcpy_to(ads_to_xe(ads), ads_to_map(ads), *offset,
+				 klv_entry, size);
+		*offset += size;
+		*remain -= size;
+	}
+}
+
 static void guc_waklv_enable_one_word(struct xe_guc_ads *ads,
 				      enum xe_guc_klv_ids klv_id,
 				      u32 value,
@@ -381,6 +410,12 @@ static void guc_waklv_init(struct xe_guc_ads *ads)
 		guc_waklv_enable_simple(ads,
 					GUC_WA_KLV_RESET_BB_STACK_PTR_ON_VF_SWITCH,
 					&offset, &remain);
+	if (GUC_FIRMWARE_VER(&gt->uc.guc) >= MAKE_GUC_VER(70, 47, 0) && XE_WA(gt, 16026007364))
+		guc_waklv_enable_two_word(ads,
+					  GUC_WA_KLV_RESTORE_UNSAVED_MEDIA_CONTROL_REG,
+					  0x0,
+					  0xF,
+					  &offset, &remain);
 
 	size = guc_ads_waklv_size(ads) - remain;
 	if (!size)
diff --git a/drivers/gpu/drm/xe/xe_wa_oob.rules b/drivers/gpu/drm/xe/xe_wa_oob.rules
index 710f4423726c9..48c7a42e2fcad 100644
--- a/drivers/gpu/drm/xe/xe_wa_oob.rules
+++ b/drivers/gpu/drm/xe/xe_wa_oob.rules
@@ -73,3 +73,4 @@ no_media_l3	MEDIA_VERSION(3000)
 14022085890	GRAPHICS_VERSION(2001)
 
 15015404425_disable	PLATFORM(PANTHERLAKE), MEDIA_STEP(B0, FOREVER)
+16026007364    MEDIA_VERSION(3000)
-- 
2.51.0

