Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8873E58B6AA;
	Mon, 31 Aug 2026 13:50:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184232; cv=none; b=twcoPLKnoMkb1gbvdHMLcRuJuWzXTVWzfg63AnsrMYUfvfcUvXsYY5Sf5ad72MtLjPwRO8WaHBYFPXrrJUg3nwugCZDa0n6EAE0yup8hV1K/YqqJs71Nnpm5s/5v7B5qsHc89Gl4KdiNHDw83k3Z3E38PJ4dM2HeVyiHHxulWRA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184232; c=relaxed/simple;
	bh=uFxGczykqFKTYpsqfQxkRqUUfKgnxYhwqb5E5dDVj0E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GCGZRN+svVSjlh/aqg5ZC6OxAGylQLwJod+mgial4OANPGJYDxYI/C2gse16M+3wIbEYpwUHdIChfcqmGNX0o+3fmjLQa6fXhsAc62InkwpkbsfWuLIAPf3ykGeGwxp9fv8AzGHF/7XctCN/jmCdfP8wdQhxUXiI25Par/7Cxyc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UVDyH7S4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UVDyH7S4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FD341F000E9;
	Mon, 31 Aug 2026 13:50:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788184230;
	bh=sjVdUiYm/8x5tYlhDT8FvYcN+SUMyrkrpfK0H0O87Pg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UVDyH7S4HimQgAMFQ647ux6SXxlYFlO8kw/avMXXasP1ZSG9jpohq27rFQ4y3UtVa
	 d8vl+p7q+zRn852aevtEMGEYjjxoWOndCfPLmUJ5G69GLFG2FkaNcXizv51eTChJXs
	 MOddhp+OG4D3/TjdjAhLZJRcnDLg+pXBNdmfY0ruYO9Q8oXcduitwyeCUp/pBuyTZf
	 QNR9iwiKdM1YcqQGeOwkf741MfqCNBvjxV3X4LBKq4ButYtgSjpSPL/VlbVZaqH4oZ
	 C1GVp7tbPDp3BknhQqGDow+iCMqmrJo1vyvrAvr/OjZswA1+zFx+sRLb1eOSLrGbJN
	 7kxIeP/w3RXvw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Candice Li <candice.li@amd.com>,
	Tao Zhou <tao.zhou1@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>,
	christian.koenig@amd.com,
	airlied@gmail.com,
	simona@ffwll.ch,
	amd-gfx@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] drm/amdgpu: Bound GPIO I2C table entry count from VBIOS
Date: Mon, 31 Aug 2026 09:29:57 -0400
Message-ID: <20260831133314.4125787-569-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260831133314.4125787-1-sashal@kernel.org>
References: <20260831133314.4125787-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.48
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Candice Li <candice.li@amd.com>

[ Upstream commit a99cd231cd924b7160fecb9fb3a94b801522323b ]

Reject undersized tables and cap the derived entry count
to AMDGPU_MAX_I2C_BUS so we do not overrun adev->i2c_bus[]
or walk an absurd number of entries on corrupt size fields.

Signed-off-by: Candice Li <candice.li@amd.com>
Reviewed-by: Tao Zhou <tao.zhou1@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit Message Forensics

**Step 1.1 — Subject line**

Record: `[drm/amdgpu]` `[Bound]` — Bound/cap GPIO I2C table entry count
parsed from VBIOS atom data tables.

**Step 1.2 — Tags**

Record:
- `Signed-off-by: Candice Li <candice.li@amd.com>` (author)
- `Reviewed-by: Tao Zhou <tao.zhou1@amd.com>`
- `Signed-off-by: Alex Deucher <alexander.deucher@amd.com>` (amdgpu
  maintainer)
- No `Fixes:`, `Reported-by:`, `Link:`, `Cc: stable@vger.kernel.org`, or
  `Tested-by:` tags
- Notable: maintainer sign-off and AMD review, but no fuzzer/user report

**Step 1.3 — Body analysis**

Record:
- **Bug:** VBIOS-reported GPIO I2C table `size` is trusted without
  validation; entry count is derived unchecked.
- **Symptoms:** Can overrun `adev->i2c_bus[]` (fixed size 16) and walk
  an excessive number of entries on corrupt/undersized size fields.
- **Root cause:** `num_indices = (size - header) / entry_size` with no
  lower/upper bound; `amdgpu_atom_parse_data_header()` only reads a
  16-bit size from the BIOS image and does not validate it.
- **Version info:** None in the message.

**Step 1.4 — Hidden bug fix?**

Record: **Yes.** Despite no “fix” in the subject, this is a defensive
bounds-check fix for out-of-bounds array indexing and unbounded
iteration on corrupt VBIOS metadata.

---

## Phase 2: Diff Analysis

**Step 2.1 — Inventory**

Record:
- **File:** `drivers/gpu/drm/amd/amdgpu/amdgpu_atombios.c` (+18 / -6)
- **Functions modified:** new helper
  `amdgpu_atombios_gpio_i2c_num_entries()`; callers
  `amdgpu_atombios_lookup_i2c_gpio()`, `amdgpu_atombios_i2c_init()`,
  `amdgpu_atombios_oem_i2c_init()`
- **Scope:** Single-file, surgical fix

**Step 2.2 — Code flow per hunk**

Record:
- **New helper:** If `size < sizeof(ATOM_COMMON_TABLE_HEADER)` → return
  0; else compute `bytes / sizeof(ATOM_GPIO_I2C_ASSIGMENT)` capped at
  `AMDGPU_MAX_I2C_BUS` (16).
- **Before:** Three sites computed `num_indices` directly from unchecked
  `size`.
- **After:** All three use the bounded helper.
- **Paths affected:**
  - `amdgpu_atombios_i2c_init()` — probe-time I2C bus creation; indexes
    `adev->i2c_bus[i]`
  - `amdgpu_atombios_oem_i2c_init()` — Polaris OEM I2C path; same
    indexing
  - `amdgpu_atombios_lookup_i2c_gpio()` — encoder/router DDC lookup;
    walks GPIO entries by pointer

**Step 2.3 — Bug mechanism**

Record: **Buffer overflow / out-of-bounds access + unbounded loop**

1. **Undersized `size` (< 4 bytes):** `(uint16_t)size - sizeof(header)`
   underflows in unsigned arithmetic → enormous `num_indices` (e.g.
   65534/entry_size ≈ thousands).
2. **Oversized/corrupt `size`:** `num_indices` can exceed
   `AMDGPU_MAX_I2C_BUS` (16). In `amdgpu_atombios_i2c_init()` /
   `oem_i2c_init()`, loop index `i` is used as `adev->i2c_bus[i]` →
   **write past end of 16-element pointer array**.
3. **GPIO pointer walk:** Uncapped iteration reads past the actual VBIOS
   table region.

**Step 2.4 — Fix quality**

Record:
- Fix is minimal, obviously correct, and matches driver limits
  (`AMDGPU_MAX_I2C_BUS == 16`, `ATOM_MAX_SUPPORTED_DEVICE == 16`).
- Does not validate `size` against total BIOS image length (unlike the
  related `drm/amd/display` fix), but still eliminates the array overrun
  and caps iteration.
- **Regression risk:** Very low. Legitimate tables with ≤16 entries
  behave identically; undersized tables fail closed (0 entries) instead
  of crashing.

---

## Phase 3: Git History Investigation

**Step 3.1 — Blame**

Record: Buggy `num_indices` calculation introduced in `d38ceaf99ed01`
(“drm/amdgpu: add core driver (v4)”, Alex Deucher, 2015-04-20). Present
throughout the life of amdgpu in this tree.

**Step 3.2 — Fixes: tag**

Record: N/A — no `Fixes:` tag in commit message.

**Step 3.3 — Related file history**

Record:
- `20f48be63d1ad` added `amdgpu_atombios_oem_i2c_init()` with the same
  unchecked pattern.
- No prior bounds-check fix for GPIO I2C tables in this tree.
- Fix commit `a99cd231cd92` is **not** present locally
  (`amdgpu_atombios_gpio_i2c_num_entries` not found).

**Step 3.4 — Author context**

Record: Candice Li has other amdgpu commits in this tree (RAS, SMU,
etc.). Patch reviewed by Tao Zhou and signed off by Alex Deucher.

**Step 3.5 — Dependencies**

Record: Mailing-list submission is **[PATCH 3/4]** in a hardening
series, but this patch is **standalone**:
- Patch 1/4: RAS CPER buffer bounds (different files)
- Patch 2/4: ATOM command table nesting depth (different code)
- Patch 4/4: PSP fw_pri_buf validation (different code)

No prerequisite commits needed for this hunk to apply and function.

---

## Phase 4: Mailing List and External Research

**Step 4.1 — Original discussion**

Record:
- `b4 dig -c a99cd231cd924b7160fecb9fb3a94b801522323b` → no lore match
  (thread on freedesktop.org, not lore).
- Verified at https://lists.freedesktop.org/archives/amd-
  gfx/2026-May/144648.html
- Series: [PATCH 3/4], May 18 2026
- No stable nomination found in the thread
- No NAKs observed in fetched content

**Step 4.2 — Reviewers**

Record: CC list includes Hawking Zhang, Tao Zhou, Stanley Yang, Thomas
Chai. `Reviewed-by: Tao Zhou`. `Signed-off-by: Alex Deucher`.

**Step 4.3 — Bug reports**

Record: None. No syzbot, bugzilla, or user crash reports referenced.

**Step 4.4 — Related patches**

Record: Related hardening in same series (RAS, ATOM nesting, PSP).
Separate mainline commit `86d2b20644b` (“drm/amd/display: Validate GPIO
pin LUT table size before iterating”) addresses the same class of VBIOS
table parsing bug in the display BIOS parser and was nominated with `Cc:
stable@vger.kernel.org`.

**Step 4.5 — Stable list**

Record: No stable-list discussion found for this specific patch (lore
blocked by bot protection; freedesktop thread has no stable CC).

---

## Phase 5: Code Semantic Analysis

**Step 5.1 — Key functions**

Record: `amdgpu_atombios_gpio_i2c_num_entries()`,
`amdgpu_atombios_lookup_i2c_gpio()`, `amdgpu_atombios_i2c_init()`,
`amdgpu_atombios_oem_i2c_init()`.

**Step 5.2 — Callers**

Record:
- `amdgpu_atombios_i2c_init()` ← `amdgpu_i2c_init()` in `amdgpu_i2c.c`
- `amdgpu_atombios_oem_i2c_init()` ← `amdgpu_i2c_init()` (Polaris chips
  with DC)
- `amdgpu_i2c_init()` ← `amdgpu_device.c` during device init when
  `adev->bios` present and `!adev->is_atom_fw`
- `amdgpu_atombios_lookup_i2c_gpio()` ← `amdgpu_atombios.c`
  encoder/router parsing (DDC/I2C routing during display setup)

**Step 5.3 — Callees**

Record: `amdgpu_atom_parse_data_header()`,
`amdgpu_atombios_get_bus_rec_for_i2c_gpio()`, `amdgpu_i2c_create()`,
`min_t()`.

**Step 5.4 — Reachability**

Record:
- **Probe path:** `amdgpu_i2c_init()` runs during GPU driver
  initialization for legacy atombios (non-atom-fw) GPUs — common on pre-
  GCN/older hardware and Polaris OEM path.
- **Display path:** `amdgpu_atombios_lookup_i2c_gpio()` runs during
  encoder/connector parsing — broader reach on atom-bios GPUs.
- **Userspace trigger:** Not a direct syscall path; triggered by GPU
  probe with VBIOS present. Corrupt/malicious VBIOS (flash corruption or
  reflashing) can trigger it at module load / GPU init. Unprivileged
  users cannot typically rewrite GPU VBIOS without root/hardware access.

**Step 5.5 — Similar patterns**

Record: Same unchecked `(size - header) / struct_size` pattern exists
elsewhere in `amdgpu_atombios.c` (e.g. spread-spectrum tables at lines
929+), but this commit does not touch those — scoped to GPIO I2C only. A
related display-side GPIO LUT bounds fix exists upstream.

---

## Phase 6: Cross-Reference Against Local Tree (v6.18.44)

**Step 6.1 — Buggy code present?**

Record: **Yes.** Local tree is `v6.18.44` (Makefile: 6.18.44). All three
unchecked `num_indices` calculations exist at lines 99–100, 130–131, and
161–162 of `amdgpu_atombios.c`. `adev->i2c_bus[AMDGPU_MAX_I2C_BUS]` is
defined in `amdgpu.h` with `AMDGPU_MAX_I2C_BUS = 16`. Bug dates to
original amdgpu import (2015).

**Step 6.2 — Backport complications**

Record: **Clean apply expected.** File structure and includes match the
patch context (`bif/bif_4_1_d.h` present, same three call sites). No
conflicting fix already applied.

**Step 6.3 — Related fixes already present?**

Record: **None** for GPIO I2C table bounding.
`amdgpu_atombios_gpio_i2c_num_entries` does not exist in tree.

---

## Phase 7: Subsystem and Maintainer Context

**Step 7.1 — Subsystem**

Record: `drm/amdgpu` display/GPU driver — **IMPORTANT** subsystem
(widely deployed AMD GPU driver).

**Step 7.2 — Activity**

Record: File actively maintained; recent commits include OEM I2C
support, vbios interfaces, PM cleanups.

---

## Phase 8: Impact and Risk Assessment

**Step 8.1 — Who is affected**

Record: AMD GPU users on the legacy atombios path (`!adev->is_atom_fw`)
during I2C init; additionally any GPU using atom-bios encoder routing
that calls `amdgpu_atombios_lookup_i2c_gpio()`. Config-specific to
`CONFIG_DRM_AMDGPU` with affected hardware.

**Step 8.2 — Trigger conditions**

Record:
- Corrupt or malicious VBIOS with invalid GPIO I2C table `size` field
- Undersized table (`size < 4`) or oversized entry count (`> 16`)
- **Likelihood:** Low for legitimate factory VBIOS; non-zero for flash
  corruption, bad flashing, or adversarial VBIOS
- **Unprivileged direct trigger:** Unlikely without ability to modify
  GPU VBIOS

**Step 8.3 — Failure mode severity**

Record:
- `amdgpu_atombios_i2c_init()` / `oem_i2c_init()`: **out-of-bounds
  write** to `adev->i2c_bus[]` → heap corruption, kernel oops, possible
  security impact — **CRITICAL/HIGH**
- All three functions: **out-of-bounds read** past VBIOS mapping, very
  long loops → probe hang/oops — **HIGH**
- Undersized table: previously could loop thousands of times instead of
  zero — **HIGH** (boot hang)

**Step 8.4 — Risk vs benefit**

Record:
- **Benefit:** Prevents kernel crash/corruption during GPU probe on
  corrupt VBIOS; aligns with AMD’s own hardening series and similar
  stable-nominated display fix.
- **Risk:** Minimal — 15-line helper, caps at existing hardware limit of
  16 buses.
- **Ratio:** High benefit, very low risk.

---

## Phase 9: Final Synthesis

**Step 9.1 — Evidence compile**

**FOR backport:**
- Real OOB write to `adev->i2c_bus[i]` when `i >= 16`
- Real OOB read / unbounded loop on corrupt `size`
- Small, maintainer-reviewed, obviously correct
- Bug present since 2015 in this tree
- Same vulnerability class as a related fix already nominated for stable
  (display GPIO LUT)
- Applies cleanly to v6.18.44

**AGAINST backport:**
- No user bug report or syzbot reproduction
- Requires corrupt/malicious VBIOS — uncommon trigger
- Fix does not validate `size` against total BIOS image length (partial
  mitigation only)
- Part of a 4-patch hardening series (though this patch is independent)

**Unresolved:** No runtime crash report confirming field failure on
production systems.

**Step 9.2 — Stable rules checklist**

1. Obviously correct and tested? **PASS** — logic is straightforward;
   reviewed by AMD engineer and maintainer. No runtime test tag.
2. Fixes a real bug? **PASS** — verified OOB array indexing and
   unbounded iteration in source.
3. Important issue? **PASS** — OOB write during driver probe
   (crash/corruption potential).
4. Small and contained? **PASS** — 18 lines added, one file, three call
   sites.
5. No new features/APIs? **PASS** — defensive bounds only.
6. Can apply to local tree? **PASS** — buggy code confirmed present;
   patch not yet applied; clean apply expected.

**Step 9.3 — Exception category**

Record: Not a device-ID/quirk/DT/build/docs exception — standard bug-
fix/hardening.

**Step 9.4 — Decision rationale**

For **this** tree (v6.18.44), the unchecked VBIOS size parsing is a
long-standing defect that can cause out-of-bounds writes to a kernel
array during GPU initialization. The fix is minimal, self-contained,
maintainer-approved, and matches established stable practice for amdgpu
VBIOS table hardening. The lack of a user report is outweighed by the
severity of the failure mode and the negligible regression risk.

---

## Verification

- [Phase 1] Parsed subject, tags, body from provided commit message
- [Phase 2] Diff analysis: verified +18/-6 in `amdgpu_atombios.c`, three
  call sites, new helper function
- [Phase 2] Read current `amdgpu_atombios.c` lines 82–175: confirmed
  unchecked `num_indices` pattern
- [Phase 2] Read `amdgpu.h`: `i2c_bus[AMDGPU_MAX_I2C_BUS]` with
  `AMDGPU_MAX_I2C_BUS = 16`
- [Phase 2] Read `atom.c` `amdgpu_atom_parse_data_header()`: `size` from
  `CU16(idx)`, no bounds validation
- [Phase 3] `git blame`: buggy lines from `d38ceaf99ed01` (2015-04-20)
- [Phase 3] `git show d38ceaf99ed01`: original amdgpu core driver import
- [Phase 3] `grep amdgpu_atombios_gpio_i2c_num_entries`: not in tree
  (fix absent)
- [Phase 3] Verified patch 3/4 is standalone; patches 1–2 are unrelated
  subsystems (freedesktop.org)
- [Phase 4] `b4 dig -c a99cd23...`: no lore match
- [Phase 4] WebFetch freedesktop.org amd-gfx May 2026: confirmed [PATCH
  3/4] content
- [Phase 4] Web search: mainline SHA
  `a99cd231cd924b7160fecb9fb3a94b801522323b`; related display fix
  `86d2b20` with `Cc: stable`
- [Phase 5] `grep` callers: `amdgpu_i2c_init` → `amdgpu_device.c:4771`;
  lookup used in encoder parsing
- [Phase 5] Read `amdgpu_i2c.c:218–235`: init paths for legacy and
  Polaris OEM
- [Phase 5] Read `amdgpu_device.c:4753–4772`: called when `adev->bios &&
  !adev->is_atom_fw`
- [Phase 6] `git describe HEAD`: `v6.18.44`; Makefile confirms 6.18.44
- [Phase 6] Buggy code confirmed at lines 99, 130, 161 in local tree
- [Phase 6] `ATOM_MAX_SUPPORTED_DEVICE` = 16 (`atombios.h`), matches
  `AMDGPU_MAX_I2C_BUS`
- [Phase 7/8] Assessed subsystem criticality and failure modes from
  verified call paths
- UNVERIFIED: No end-user crash report for this specific GPIO I2C issue
- UNVERIFIED: Whether undersized-table underflow has been observed in
  the field

**YES**The background search finished: the **Bound GPIO I2C** fix is
**not** in this tree (`v6.18.44`). Candice Li’s other amdgpu work is
present, but `amdgpu_atombios_gpio_i2c_num_entries()` is missing and the
unchecked `num_indices` logic is still at lines 99, 130, and 161 of
`amdgpu_atombios.c`.

**Verdict from the analysis:** backport **YES** — small, standalone
bounds-check fix that prevents OOB writes to `adev->i2c_bus[]` and
unbounded VBIOS table walks on corrupt GPIO I2C table sizes during GPU
init.

 drivers/gpu/drm/amd/amdgpu/amdgpu_atombios.c | 24 +++++++++++++++-----
 1 file changed, 18 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_atombios.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_atombios.c
index 763f2b8dcf13a..b8f7e3a18d324 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_atombios.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_atombios.c
@@ -36,6 +36,21 @@
 #include "atombios_encoders.h"
 #include "bif/bif_4_1_d.h"
 
+/* VBIOS-reported table size is unchecked against the image; cap iterations and
+ * adev->i2c_bus[] indexing to AMDGPU_MAX_I2C_BUS.
+ */
+static int amdgpu_atombios_gpio_i2c_num_entries(uint16_t size)
+{
+	u32 bytes;
+
+	if (size < sizeof(ATOM_COMMON_TABLE_HEADER))
+		return 0;
+
+	bytes = size - sizeof(ATOM_COMMON_TABLE_HEADER);
+	return (int)min_t(u32, bytes / sizeof(ATOM_GPIO_I2C_ASSIGMENT),
+			  AMDGPU_MAX_I2C_BUS);
+}
+
 static struct amdgpu_i2c_bus_rec amdgpu_atombios_get_bus_rec_for_i2c_gpio(ATOM_GPIO_I2C_ASSIGMENT *gpio)
 {
 	struct amdgpu_i2c_bus_rec i2c;
@@ -96,8 +111,7 @@ struct amdgpu_i2c_bus_rec amdgpu_atombios_lookup_i2c_gpio(struct amdgpu_device *
 	if (amdgpu_atom_parse_data_header(ctx, index, &size, NULL, NULL, &data_offset)) {
 		i2c_info = (struct _ATOM_GPIO_I2C_INFO *)(ctx->bios + data_offset);
 
-		num_indices = (size - sizeof(ATOM_COMMON_TABLE_HEADER)) /
-			sizeof(ATOM_GPIO_I2C_ASSIGMENT);
+		num_indices = amdgpu_atombios_gpio_i2c_num_entries(size);
 
 		gpio = &i2c_info->asGPIO_Info[0];
 		for (i = 0; i < num_indices; i++) {
@@ -127,8 +141,7 @@ void amdgpu_atombios_i2c_init(struct amdgpu_device *adev)
 	if (amdgpu_atom_parse_data_header(ctx, index, &size, NULL, NULL, &data_offset)) {
 		i2c_info = (struct _ATOM_GPIO_I2C_INFO *)(ctx->bios + data_offset);
 
-		num_indices = (size - sizeof(ATOM_COMMON_TABLE_HEADER)) /
-			sizeof(ATOM_GPIO_I2C_ASSIGMENT);
+		num_indices = amdgpu_atombios_gpio_i2c_num_entries(size);
 
 		gpio = &i2c_info->asGPIO_Info[0];
 		for (i = 0; i < num_indices; i++) {
@@ -158,8 +171,7 @@ void amdgpu_atombios_oem_i2c_init(struct amdgpu_device *adev, u8 i2c_id)
 	if (amdgpu_atom_parse_data_header(ctx, index, &size, NULL, NULL, &data_offset)) {
 		i2c_info = (struct _ATOM_GPIO_I2C_INFO *)(ctx->bios + data_offset);
 
-		num_indices = (size - sizeof(ATOM_COMMON_TABLE_HEADER)) /
-			sizeof(ATOM_GPIO_I2C_ASSIGMENT);
+		num_indices = amdgpu_atombios_gpio_i2c_num_entries(size);
 
 		gpio = &i2c_info->asGPIO_Info[0];
 		for (i = 0; i < num_indices; i++) {
-- 
2.53.0

