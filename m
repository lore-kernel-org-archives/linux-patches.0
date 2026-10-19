Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53C295827B6;
	Mon, 19 Oct 2026 13:59:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418401; cv=none; b=fxXSuMVP8uJQy0gypN0ZtbbjX0zOmhmHlLqN0mrofoXqvH2nsmDwMLE90eg5JxZOWnhz5ViFvI0MJ5a4t4ek8KD5slwkFhbwHmYGWLXEGKSwadCsk7afMXLYMZXbHo1/8uGItdJpyNqGNhyEkWRhcSm/9jSKz9bVc//q8c2QizE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418401; c=relaxed/simple;
	bh=5QDcUM7V3F85GFwGD4h7tdAoC/2rDXMWYHQDXo3SzMQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jWVqUFvLvNXZs80zXIkU1d2QZlc3U1e8GHrbwQ8b4vXyN87oytn2YQBuRXDO8zBVuQW953v1GKkeVxTa/5MQRN8gfnwEn7xgIgd1F0e/El/JpkAwp9mNoQdvu+Tc4zPRYI9qCKMEhpIOpmGFowojs5HUr6bFGN+aqU1O6hHc2mI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hXVb4oxq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hXVb4oxq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29C951F000C4;
	Mon, 19 Oct 2026 13:59:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418399;
	bh=rN5dETSaf8THpyHMEVrc/LonwTYZDhVP2rrH8ZWjnjM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hXVb4oxquf3yq60oqS/PGvRpJEN8mOARbsUzAn+01xPELIvxtUPTWvl7t0im2Y/lk
	 Sp0oATw1xomhDshEolpS5Z+8rhduN+SBRFw309ILVtt5BOIqPTye9Yor22oKeo6nMW
	 pHzCQ0l2nQqQkDMH9Z7Vd5FXEQtx39MMINrgh/axlXkN0dctTSQd93IY4T87cywgFM
	 kavhKXImN8FmPVdvbEvb7/DYtBX3LtucYS1gDkn1SNLj/uSs2VkJI6dqTxIfwN+DPy
	 Y4IL/PYnhnZpSy1yT+9qul09cbu0Rqjwsq8Y/H1lHmWh3vgJoYn9V8bhkhIhcWbqdC
	 tjmriiYZk1IGg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Matthew Jacob <mjacob@feralsw.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>,
	christian.koenig@amd.com,
	airlied@gmail.com,
	simona@ffwll.ch,
	amd-gfx@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] drm/amdgpu: Support some Barco AMD based graphics adapters
Date: Mon, 19 Oct 2026 09:48:33 -0400
Message-ID: <20261019135441.1420968-222-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261019135441.1420968-1-sashal@kernel.org>
References: <20261019135441.1420968-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.57
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Matthew Jacob <mjacob@feralsw.com>

[ Upstream commit 3dc4d68ee26a7ac12069ff0562ad8935106c79b6 ]

These adapters typically are only supported by Barco on the
Windows platform. However, with these changes in the linux
driver, multiple monitor support should work correctly.

Signed-off-by: Matthew Jacob <mjacob@feralsw.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit message forensics

**Step 1.1:** Record: `[drm/amdgpu] [Support] [add PCI IDs so Barco AMD
adapters bind to amdgpu]`

**Step 1.2:** Tags in the commit as given:
- `Signed-off-by: Matthew Jacob <mjacob@feralsw.com>` (author)
- `Signed-off-by: Alex Deucher <alexander.deucher@amd.com>` (amdgpu
  maintainer)
- No `Fixes:`, `Reported-by:`, `Cc: stable`, `Link:`, `Tested-by`, or
  `Reviewed-by` on the committed message (absence of `Fixes`/`Cc:
  stable` is expected for this review)

**Step 1.3:** Record:
- Bug/problem: Barco MXRT cards (AMD GPUs with Barco PCI IDs) are not in
  `pciidlist`, so amdgpu never binds; Windows-only vendor support.
- Symptom: cards do not work as DRM devices; multi-monitor setups fail.
- Version info: none in the message.
- Root cause: missing device IDs, not a logic bug in existing chip code.

**Step 1.4:** Record: Not a hidden crash/UAF fix. It is hardware
enablement via PCI IDs. That is an explicit stable exception, not
disguised cleanup.

## Phase 2: Diff analysis

**Step 2.1:** Record:
- File: `drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c` only
- +4 / -0 (four PCI ID rows)
- Function/object: `pciidlist[]`
- Scope: single-file surgical device-ID addition

**Step 2.2:** Record (each hunk is the same pattern):
- Before: ID missing → PCI core does not match amdgpu
- After: ID present with existing `CHIP_*` flags → probe uses already-
  supported ASIC paths
  - `0x664D` → `CHIP_BONAIRE`
  - `0x693B` → `CHIP_TONGA`
  - `0x67D4` → `CHIP_POLARIS10`
  - `0x698F` → `CHIP_POLARIS12`
- Path: device enumeration / probe, not an error path

**Step 2.3:** Record: `[Hardware workarounds / device ID addition]`
Mechanism: missing IDs so existing Bonaire/Tonga/Polaris code never runs
for those DIDs.

**Step 2.4:** Record: Obviously correct if the IDs belong to those
families. Regression risk is low: only those four DIDs start probing;
neighboring IDs are unchanged. Wrong-family assignment could mis-init a
GPU; public PCI databases and nearby IDs in the same table match the
chosen `CHIP_*` values. Original submission used `//` comments; the
committed form dropped them (kernel style). No API or data-structure
change.

## Phase 3: Git history

**Step 3.1:** Record: `pciidlist` has existed for the life of amdgpu.
Nearby IDs (`0x6649`, `0x6939`, `0x67D0`, `0x6987`) are long-standing.
The gap is missing Barco DIDs, not a newly introduced logic bug.
`CHIP_BONAIRE` / `CHIP_TONGA` / `CHIP_POLARIS10` / `CHIP_POLARIS12` are
in `include/drm/amd_asic_type.h` (enum values 5, 11, 15, 17).

**Step 3.2:** No `Fixes:` tag. Buggy “code” is the absence of IDs. Not
applicable as a Fixes follow-up.

**Step 3.3:** Recent related history on this file includes other PCI ID
work (e.g. cyan skillfish IDs already in v6.18). Standalone; not patch
X/Y. A later named-initializer rewrite of the table exists only as a
later candidate on this branch, not in `v6.18.53`.

**Step 3.4:** Author Matthew Jacob (Feral Software) has this one amdgpu
commit here. Alex Deucher, amdgpu maintainer, applied it (`CommitDate:
Wed Jul 1 2026`, SOB).

**Step 3.5:** No functional prerequisites. Applies against the existing
`pciidlist` format in `v6.18.53`. Does not need new CHIP types, new
helpers, or other series patches.

Upstream object `3dc4d68ee26a7ac12069ff0562ad8935106c79b6` is **not** an
ancestor of `v6.18` or `v6.18.53`.

## Phase 4: Mailing list / external research

**Step 4.1:** `b4 dig -c 3dc4d68ee26a7ac12069ff0562ad8935106c79b6`
failed (lore.kernel.org server error). Fallback: freedesktop amd-gfx.
- Submission: https://lists.freedesktop.org/archives/amd-
  gfx/2026-June/147081.html
- First attempt (attachment, not git-format):
  https://lists.freedesktop.org/archives/amd-gfx/2026-June/147075.html
- Alex asked for a proper git patch + SOB:
  https://lists.freedesktop.org/archives/amd-gfx/2026-June/147077.html
- Alex applied the git-format patch the same day:
  https://lists.freedesktop.org/archives/amd-gfx/2026-June/147083.html
  (“Applied. Thanks!”)
- Archive index also lists later Christian König and Matthew Jacob
  follow-ups; **exact text of those later mails is UNVERIFIED** (message
  numbers not resolved). No NAK found on the applied version.

**Step 4.2:** Recipients: amd-gfx. Maintainer Alex Deucher reviewed and
applied. Not a drive-by unreviewed ID dump.

**Step 4.3:** Real-world reports:
- 2023: Matthias Reichl, Barco MXRT-5600 `1002:664d` on HP Z240; neither
  radeon nor amdgpu bound; adding the ID made it work (Debian, kernel
  6.2-rc3, CIK enabled). Alex noted the DID was missing from AMD’s
  Windows list too. https://lists.freedesktop.org/archives/amd-
  gfx/2023-January/088522.html
- 2026 cover letter: Kaiser radiology PACS fleets; Barco/Kaiser had no
  objection.
- PCI ID databases: `664D` Bonaire/W5100/MXRT-5600; `693B`
  Tonga/W7100/MXRT-7600; `67D4` Polaris10/WX 7100/MXRT-8700; `698F`
  Polaris12/WX 3100/MXRT 4700.

**Step 4.4:** Standalone 4-line ID add. A later separate patch proposed
`0x67D7` (MXRT-6700); not required for this commit.

**Step 4.5:** lore.kernel.org/stable search returned 403; **UNVERIFIED**
whether stable@ already discussed this ID set. No evidence of a NAK for
stable.

## Phase 5: Code semantic analysis

**Step 5.1:** Record: `pciidlist[]` (static `pci_device_id` table). No
function body edits.

**Step 5.2:** Record: PCI core match → `amdgpu` `.id_table` /
`MODULE_DEVICE_TABLE(pci, pciidlist)` around the probe path in
`amdgpu_drv.c`. Trigger is plugging in / booting with that GPU. Not a
syscall hot path.

**Step 5.3:** Record: probe then uses existing ASIC init for
`CHIP_BONAIRE` / `CHIP_TONGA` / `CHIP_POLARIS10` / `CHIP_POLARIS12`.
Those ASICs already have full driver support in this tree.

**Step 5.4:** Record: Userspace-reachable only in the sense of having
the card. Unprivileged users cannot invent a PCI ID. Impact is “card
works vs. no DRM driver”.

**Step 5.5:** Same table already lists sibling IDs in each family.
`amdgpu_unsupported_pciidlist[]` does not contain these four IDs. radeon
`include/drm/drm_pciids.h` still lacks `0x664D` (Bonaire default driver
is radeon unless CIK is switched to amdgpu). That does not block amdgpu
IDs for Tonga/Polaris.

## Phase 6: Local tree (this checkout)

**Step 6.1:** Record:
- `git describe HEAD` → `v6.18.53-5049-g0f0bdc2b0dffb`; `Makefile` →
  **6.18.53**
- `v6.18.53:drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c` does **not**
  contain `0x664D`, `0x693B`, `0x67D4`, `0x698F`
- Surrounding rows in `v6.18.53` match the candidate hunks (positional
  `{0x1002, 0x...., PCI_ANY_ID, ...}` form)
- `CHIP_*` enums exist in this series
- Bug/gap: missing IDs, present for as long as those families have been
  in amdgpu

**Step 6.2:** Record: **clean apply** onto `v6.18.53`. No format
mismatch. (HEAD currently uses `PCI_DEVICE()` named initializers because
a later candidate rewrote the table; that rewrite is not in `v6.18.53`.)

**Step 6.3:** Record: No alternate fix for these four IDs in
`v6.18..v6.18.53`. Cyan skillfish ID adds are a different family and
already in v6.18.

## Phase 7: Subsystem context

**Step 7.1:** Record: `[drm/amdgpu] [IMPORTANT]` — common GPU driver,
not staging. Device-ID-only, not a new driver.

**Step 7.2:** Record: amdgpu is actively developed; these GCN families
(CIK/VI/Polaris) are mature. Adding IDs to old ASICs is the usual
pattern.

## Phase 8: Impact and risk

**Step 8.1:** Record: driver-specific / hardware-specific. Users of
Barco MXRT (medical/pro multi-display) AMD cards. Not universal.

**Step 8.2:** Record: Trigger = boot with that PCI device. Common for
those machines, zero for everyone else. Not a userspace exploit path.

**Step 8.3:** Record: Failure mode today = adapter unbound / no KMS, not
an oops. Severity for affected users: **HIGH** (hardware dead on Linux).
Severity for others: none. Not panic/UAF.

**Step 8.4:** Record:
- Benefit: high for those GPUs (kernel finally binds; Tonga/Polaris work
  with default amdgpu; Bonaire needs existing `DRM_AMDGPU_CIK` /
  `amdgpu.cik_support=1` like other Bonaire parts)
- Risk: very low (4 rows, existing CHIP flags, maintainer-applied)
- Ratio: favorable; this is the documented device-ID exception

Caveats (not blockers):
- Two IDs were labeled “Tentative” in the mail (`0x67D4` MXRT-8750 vs
  databases saying MXRT-8700; `0x698F` MXRT-4700, which does exist).
  Family assignment still matches public PCI IDs.
- Bonaire `0x664D` is not added to radeon; default CIK remains radeon.
  Same as needing CIK-in-amdgpu for other Bonaire cards.

## Phase 9: Synthesis

**Evidence FOR:**
- Canonical PCI ID addition to an existing driver
- 4 lines, existing `CHIP_*` only
- Families already in 6.18.y; IDs missing from `v6.18.53`
- Applies cleanly
- Maintainer (Alex Deucher) applied it
- Documented users (Kaiser PACS, 2023 MXRT-5600 report)
- PCI ID databases agree with the chip mapping

**Evidence AGAINST:**
- Not a crash/security/corruption fix
- Two IDs originally marked tentative
- Bonaire ID incomplete vs radeon default
- Exact later König comments UNVERIFIED

**Unresolved:** exact text of later amd-gfx follow-ups; whether stable@
already discussed it (lore 403 / b4 lore error).

**Stable rules checklist:**
1. Obviously correct and tested? **PASS** — table rows + maintainer
   apply; 2023 user tested `664d`
2. Real bug affecting users? **PASS** — devices never bind
3. Important? **PASS** under the device-ID exception (hardware
   enablement, not a new driver)
4. Small and contained? **PASS** — 4 lines, one file
5. No new features/APIs? **PASS** — IDs only; no new ioctls/params
6. Can apply to this tree? **PASS** — `v6.18.53` table format matches

**Exception category:** New PCI IDs on an existing driver.

This should be backported to this 6.18.y tree: the driver and ASIC
support are already here; only the four IDs are missing.

Verification:
- [Phase 1] Parsed subject/tags/body: Support + two SOBs; no
  Fixes/Reported-by
- [Phase 2] Diff: +4 PCI IDs in `pciidlist` (`664D` Bonaire, `693B`
  Tonga, `67D4` Polaris10, `698F` Polaris12)
- [Phase 3] `git describe HEAD` / Makefile: 6.18.53; upstream
  `3dc4d68ee26a` not ancestor of v6.18/v6.18.53
- [Phase 3] `git show v6.18.53:drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c`:
  those four IDs absent; neighbor rows match the patch
- [Phase 3] `CHIP_BONAIRE` etc. in `include/drm/amd_asic_type.h`
- [Phase 4] b4 dig: lore server error; used lists.freedesktop.org
  instead
- [Phase 4] 147075/147077/147081/147083: resend as git patch, Alex
  applied
- [Phase 4] 2023 664d thread: card worked after adding the ID
- [Phase 5] `MODULE_DEVICE_TABLE` / `.id_table = pciidlist`; IDs not on
  `amdgpu_unsupported_pciidlist`
- [Phase 6] Clean apply to v6.18.53 old-style table; radeon
  `drm_pciids.h` still has `0x6649` but not `0x664D`
- [Phase 7] amdgpu important, families mature
- [Phase 8] Probe-only; risk limited to those DIDs
- UNVERIFIED: full text of later Christian König replies; stable@
  archive (403)

**YES**

 drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
index 376a7cd2667f6..845ebe041563f 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
@@ -1953,6 +1953,7 @@ static const struct pci_device_id pciidlist[] = {
 	{0x1002, 0x6646, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_BONAIRE|AMD_IS_MOBILITY},
 	{0x1002, 0x6647, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_BONAIRE|AMD_IS_MOBILITY},
 	{0x1002, 0x6649, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_BONAIRE},
+	{0x1002, 0x664D, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_BONAIRE},
 	{0x1002, 0x6650, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_BONAIRE},
 	{0x1002, 0x6651, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_BONAIRE},
 	{0x1002, 0x6658, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_BONAIRE},
@@ -2022,6 +2023,7 @@ static const struct pci_device_id pciidlist[] = {
 	{0x1002, 0x6930, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_TONGA},
 	{0x1002, 0x6938, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_TONGA},
 	{0x1002, 0x6939, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_TONGA},
+	{0x1002, 0x693B, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_TONGA},
 	/* fiji */
 	{0x1002, 0x7300, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_FIJI},
 	{0x1002, 0x730F, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_FIJI},
@@ -2050,6 +2052,7 @@ static const struct pci_device_id pciidlist[] = {
 	{0x1002, 0x67C4, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_POLARIS10},
 	{0x1002, 0x67C7, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_POLARIS10},
 	{0x1002, 0x67D0, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_POLARIS10},
+	{0x1002, 0x67D4, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_POLARIS10},
 	{0x1002, 0x67DF, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_POLARIS10},
 	{0x1002, 0x67C8, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_POLARIS10},
 	{0x1002, 0x67C9, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_POLARIS10},
@@ -2063,6 +2066,7 @@ static const struct pci_device_id pciidlist[] = {
 	{0x1002, 0x6985, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_POLARIS12},
 	{0x1002, 0x6986, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_POLARIS12},
 	{0x1002, 0x6987, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_POLARIS12},
+	{0x1002, 0x698F, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_POLARIS12},
 	{0x1002, 0x6995, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_POLARIS12},
 	{0x1002, 0x6997, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_POLARIS12},
 	{0x1002, 0x699F, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_POLARIS12},
-- 
2.53.0

