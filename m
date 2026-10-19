Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53C12503913;
	Mon, 19 Oct 2026 14:05:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418749; cv=none; b=p3xBeT/Rh2DRVIKr1PHrm1GsptiXm+qlALV3VvqP1iLFJ31tD3nW3xPcB4Pb25s5at72W9VwZKqBTiz0Xp+x+l5wf4VVMsTk0MXupRmwy6p+GsAxl7Dk41UvBkbCl3f9c2UwayytXSeT30ELIcQt7AcEwE51JGaLPu0r73wWHik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418749; c=relaxed/simple;
	bh=y8wdHJg2sOaw1nJ+HEFkmKGkxO6fbX3AEEouhO4/uwA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=j3qrhDuQ/OuX9NOrspdetUaIL/FI/N4EEznNYdeHREQ1O2Ugob1jAXOt3HpThXJWhYf8PXjDmgc2+GBVBTbGi9VKwheJsHsPrDHPDujccbYMd5Cp4ZGvxDCAYeEZWV4E8cPUlRRnxMK5JRe6De9aQUfyXyoIkPEG/2xsLXS+0+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WhieVU7z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WhieVU7z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 256131F000C4;
	Mon, 19 Oct 2026 14:05:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418746;
	bh=VEhvWpSBuuOgsR6j1PDhVuySMCC2OyAu0N0as+4w6MU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WhieVU7zU7BL9EWxz581XbaKsng5RBaa4xo6OsMjb5JsUzSE/4o+kQSykFxiKL4Xe
	 6A7L6NE6277xk2LpjfZZCccgxz6e1l8Re8yoNVlc999Qcfh8eqHi4OIcKzGbeDvTf6
	 MhwIos7lIO/jO3/b5pHNveU62Jxk9TCbS64kY18dGLsqwTRr744oyu1ZVW7CHZgrLh
	 oziuxvhTmEAmTHd9Hcc3b9iP/7Yblteaqw8h5g6LQgGoPPUhmOed509QFixB+My8/j
	 N9e4Ew3FAPwwUtsIQXxk91BfOOqo/nHT9nEIIjsvALxRR+YgQ8yOQi3FjqAN55RcRT
	 YqtRAqY+a9YqA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Lijo Lazar <lijo.lazar@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>,
	christian.koenig@amd.com,
	airlied@gmail.com,
	simona@ffwll.ch,
	amd-gfx@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.12] drm/amdgpu: Guard reads in pcie state readout
Date: Mon, 19 Oct 2026 09:52:37 -0400
Message-ID: <20261019135441.1420968-466-sashal@kernel.org>
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

From: Lijo Lazar <lijo.lazar@amd.com>

[ Upstream commit 230753e46a4a9d04dad6a9b5dbaeb7fd52add7d0 ]

Internal US/DS switch may not be exposed in passthrough. Guard the
upstream port reads to avoid a NULL dereference.

Signed-off-by: Lijo Lazar <lijo.lazar@amd.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

I have enough to decide: this is a NULL-deref on a sysfs read for MI300
passthrough, the buggy code is in 6.18.53, and the patch is small and
already reviewed.

---

## Phase 1: Commit message forensics

**Step 1.1: Subject line**
Record: `[drm/amdgpu] [Guard] Guard reads in PCIe state readout` —
“Guard” here is a missing-NULL-check / skip-on-missing-hardware fix, not
a feature.

**Step 1.2: Tags**
Record:
- `Signed-off-by: Lijo Lazar <lijo.lazar@amd.com>` (author; AMD amdgpu
  contributor)
- `Acked-by: Alex Deucher <alexander.deucher@amd.com>` (amdgpu
  maintainer)
- `Signed-off-by: Alex Deucher <alexander.deucher@amd.com>` (maintainer
  merge)
- No `Fixes:`, `Reported-by:`, `Cc: stable`, `Link:`, `Tested-by:`, or
  `Reviewed-by:` (absence of Fixes/Cc-stable is expected for this
  review)
- Ignore `[Upstream commit 230753e46a4a...]` and `Signed-off-by: Sasha
  Levin` (pipeline)

**Step 1.3: Body**
Record:
- Bug: internal US/DS PCIe switch may not be visible in passthrough
- Symptom: NULL dereference when reading upstream-port config
- Root cause: `pci_upstream_bridge()` can return NULL; the code still
  uses the pointer
- No stack trace, no version list, no reproducer in the message

**Step 1.4: Hidden bug fix?**
Record: Not hidden. Explicit NULL-deref fix. Extra vendor/type checks
also avoid treating a hypervisor virtual bridge as the GPU’s internal
switch.

---

## Phase 2: Diff analysis

**Step 2.1: Inventory**
Record:
- File: `drivers/gpu/drm/amd/amdgpu/aqua_vanjaram.c` only
- ~42 insertions, ~17 deletions (59-line churn)
- New helper `aqua_vanjaram_get_us_pdev()`;
  `aqua_vanjaram_read_pcie_state()` updated
- Classification: single-file surgical fix

**Step 2.2: Code flow**
Record:
- **Before:** `ds_pdev = pci_upstream_bridge(adev->pdev); us_pdev =
  pci_upstream_bridge(ds_pdev);` then unconditional
  `pcie_capability_read_word(us_pdev, ...)`,
  `pci_find_ext_capability(us_pdev, ...)`,
  `pci_read_config_dword(us_pdev, ...)`.
- **After:** helper requires ATI downstream port then ATI/AMD upstream
  port; if either walk fails, skip those config reads. SMN register dump
  still runs.
- Path: sysfs `reg_state` read (normal userspace debug path), not
  probe/error-only.

**Step 2.3: Bug mechanism**
Record: **NULL pointer dereference** (memory safety).
- `pci_upstream_bridge()` in `include/linux/pci.h` returns NULL on a
  root bus.
- `pci_upstream_bridge(NULL)` calls `pci_physfn(dev)` which does
  `dev->is_virtfn` — immediate oops if the GPU has no parent.
- Typical VFIO topology (GPU under a QEMU root port): `ds_pdev` is non-
  NULL, `us_pdev` is NULL, then `pcie_capability_read_word(NULL, ...)`
  oopses.
- Helper matches the existing pattern in
  `amdgpu_device_cache_switch_state()` /
  `amdgpu_device_get_aspm_pdev()`.

**Step 2.4: Fix quality**
Record: Obviously correct; same topology checks already used nearby.
Residual: skipped fields are not zeroed (AER fields were already
conditional). That is much less severe than an oops. No new API, no
lock, no ABI change. Low regression risk.

---

## Phase 3: Git history

**Step 3.1: Blame**
Record: Unguarded walk introduced in `081a6eda2b2509` (“drm/amdgpu: Read
aquavanjaram PCIE register state”, 2023-11-29, Lijo Lazar). In this tree
since well before v6.18. Contained in v6.8-era history
(`locking_urgent_for_v6.8_rc2~...`).

**Step 3.2: Fixes: tag**
Record: No `Fixes:` tag. Introducer `081a6eda2b2509` **is** an ancestor
of `v6.18.53` (`git merge-base --is-ancestor` exit 0).

**Step 3.3: File history**
Record: Related NULL-guard already in this tree: `9b608fe94870f`
“drm/amdgpu: Check swus/ds for switch state save” (in v6.18.53; GitLab
drm/amd#4602). Same topology bug, different path (reset/save). This
patch is the sysfs readout counterpart. Standalone, not `N/M`.

**Step 3.4: Author**
Record: Lijo Lazar is a regular amdgpu author of this file. Maintainer
Alex Deucher acked and applied.

**Step 3.5: Dependencies**
Record: None. Uses existing `pci_upstream_bridge`,
`PCI_VENDOR_ID_ATI/AMD`, `pci_pcie_type`. No new helpers from later
series. Can apply standalone.

---

## Phase 4: Mailing list / external

**Step 4.1: Original discussion**
Record: `b4 dig -c 230753e46a4a9d04dad6a9b5dbaeb7fd52add7d0` →
https://patch.msgid.link/20260617093518.753118-1-lijo.lazar@amd.com
`b4 dig -a`: **v1 only**, 2026-06-17. No later rewrite.

**Step 4.2: Recipients (`b4 dig -w`)**
Record: `amd-gfx@lists.freedesktop.org`, Hawking Zhang, Alex Deucher,
Asad Kamal, Candice Li. Right list and maintainer.

**Step 4.3: Review (mbox `/tmp/pcie-guard.mbox`)**
Record:
- Kevin Wang: under VFIO the guest topology is virtualized; suggested
  hiding the whole interface in PT/SRIOV.
- Lijo: SMN/endpoint reads still useful; this patch only skips the
  physical-link (US port) reads that need real switch ports.
- Alex Deucher: `Acked-by` (2026-06-19). No NAK. No `Cc: stable` in
  review.

**Step 4.4: Series**
Record: Single standalone patch.

**Step 4.5: Stable list**
Record: lore.kernel.org/stable fetch returned 403. UNVERIFIED whether
stable@ discussed it. Does not change the technical verdict.

---

## Phase 5: Semantic / call chain

**Step 5.1: Functions**
Record: `aqua_vanjaram_get_us_pdev` (new),
`aqua_vanjaram_read_pcie_state` (modified).

**Step 5.2: Callers**
Record:
- `aqua_vanjaram_read_pcie_state` ← `aqua_vanjaram_get_reg_state` (PCIE
  case)
- ← `amdgpu_asic_get_reg_state` ← `amdgpu_sysfs_reg_state_get`
- Sysfs bin attr `reg_state` mode **0444**, offset
  `AMDGPU_SYS_REG_STATE_PCIE = 0x2000`
- `get_reg_state` is only on `aqua_vanjaram_asic_funcs` (`soc15.c`)

**Step 5.3: Callees**
Record: `pci_upstream_bridge`, `pcie_capability_read_word`,
`pci_find_ext_capability`, `pci_read_config_dword`, plus existing SMN
reads (`aqua_read_smn` / `RREG32_PCIE`).

**Step 5.4: Reachability**
Record: Userspace-reachable: `read()` on `/sys/devices/.../reg_state` at
offset 0x2000 (or via drm sysfs). Not interrupt/hot path. Any process
that can read that 0444 file can trigger it.

**Step 5.5: Similar patterns**
Record: Same US/DS walk in `amdgpu_device_cache_switch_state()` (already
NULL-checked in this tree) and `amdgpu_device_get_aspm_pdev()`.

---

## Phase 6: Local tree (v6.18.53)

**Step 6.1: Does the bug exist here?**
Record:
- `git describe HEAD`: `v6.18.53-5049-g0f0bdc2b0dffb`;
  `VERSION/PATCHLEVEL/SUBLEVEL` = 6.18.53
- `git merge-base --is-ancestor 9bd596d9e90da v6.18.53` → **no** (fix
  not in 6.18.53)
- `git merge-base --is-ancestor 081a6eda2b2509 v6.18.53` → **yes** (bug
  is in 6.18.53)
- At `v6.18.53` lines 653–670: unguarded `pci_upstream_bridge` + config
  reads

**Step 6.2: Backport difficulty**
Record: `git apply --check` of both the candidate and upstream diffs
onto the v6.18.53 file **succeeds** (hunk offset only). Context around
`pcie_reg_addrs` / `aqua_vanjaram_read_pcie_state` matches. **Clean
apply.**

**Step 6.3: Related fixes already here?**
Record: Switch-state save is guarded (`9b608fe94870f` in v6.18.53).
Sysfs PCIe readout is **not**. No earlier version of this helper in
6.18.53.

---

## Phase 7: Subsystem context

**Step 7.1**
Record: amdgpu / Aqua Vanjaram (Instinct MI300 family: GC 9.4.3, 9.4.4,
9.5.0). **IMPORTANT** (datacenter GPU driver), not core mm/VFS, not
staging.

**Step 7.2**
Record: File is actively developed, but this readout path has been
unchanged since 2023. Mature buggy code, not a brand-new feature.

---

## Phase 8: Impact and risk

**Step 8.1: Who is affected**
Record: Driver-specific: MI300/MI308/MI350 (`IP_VERSION(9,4,3/4)` and
`(9,5,0)`). Highest impact: **VFIO/QEMU passthrough guests** where the
internal US/DS switch is hidden. Bare metal with the real AMD switch is
unaffected.

**Step 8.2: Trigger**
Record: Reading sysfs `reg_state` at PCIE offset. Common for AMD
debug/RAS dumps; also trivial to hit (`dd`/`pread` at 0x2000).
Unprivileged users can read 0444 sysfs. Not a boot-every-time path.

**Step 8.3: Failure mode**
Record: Kernel oops / NULL deref. **Severity: HIGH** (crash; local DoS
from sysfs). Not silent corruption.

**Step 8.4: Risk-benefit**
Record:
- Benefit: stops a real oops on MI300 passthrough when diagnostics read
  PCIe state — production cloud/HPC setup.
- Risk: ~25-line helper + `if (us_pdev)` around existing reads; mirrors
  code already in this tree. **Low.**
- Ratio: strongly favors backport.

---

## Phase 9: Synthesis

**Step 9.1: Evidence**

For:
- Real NULL deref, reachable from sysfs
- Buggy code in this 6.18.53 tree since 2023
- Passthrough is a stated, realistic trigger
- Same topology already caused a user-visible bug (drm/amd#4602) on the
  sibling path
- Small, obviously correct, maintainer-acked
- Applies cleanly to v6.18.53
- No new features/APIs

Against:
- Affects one ASIC family, debug sysfs, not a universal path
- No `Reported-by` / public crash log on *this* function
- Kevin argued for hiding the whole interface (not a NAK of the NULL
  check)
- Skipped struct fields left uninitialized (minor, pre-existing for AER)

Unresolved:
- Stable@ discussion (lore 403)
- Whether a specific production crash dump exists for this sysfs path
  (unverified; mechanism is still verified in code)

**Step 9.2: Stable rules**
1. Obviously correct and tested? **PASS** (mirror of existing checks;
   maintainer Acked-by)
2. Real bug affecting users? **PASS** (oops on MI300 passthrough sysfs
   read)
3. Important (crash/security/corruption/deadlock)? **PASS** — oops /
   local DoS, HIGH
4. Small and contained? **PASS** — one file, one helper + guard
5. No new features/APIs? **PASS**
6. Applies to local tree? **PASS** — clean apply; buggy code present

**Step 9.3: Exceptions**
Record: None (not a device-ID/quirk/DT/build/doc-only change). Qualifies
as a normal crash fix.

**Step 9.4: Decision**
Backport. This tree is 6.18.53; the unguarded walk is present; the fix
is a small NULL-deref guard for a userspace-reachable path on hardware
this kernel already supports.

---

### What the commit solves for this tree
`aqua_vanjaram_read_pcie_state()` walks to the GPU’s internal upstream
switch and reads PCIe/AER config with no NULL or topology check. In
passthrough that switch is often missing, so `pci_upstream_bridge()`
returns NULL and the kernel oopses. The helper skips those reads when
the ATI/AMD US/DS chain is not there, while still dumping SMN regs.

### Risk vs benefit
Benefit is avoiding a reproducible oops on Instinct MI300-class GPUs in
VFIO guests. Risk is a narrow, identical-to-existing-pattern check.
Applies cleanly to 6.18.53.

### Verification
- [Phase 1] Parsed tags: author SOB, Alex Deucher Acked-by + SOB; no
  Fixes/Reported-by/Cc-stable
- [Phase 2] Diff: helper + `if (us_pdev)` around config reads in
  `aqua_vanjaram.c`; SMN loop unchanged
- [Phase 2] `pci_upstream_bridge()` / `pci_physfn()` read: NULL parent →
  NULL deref
- [Phase 3] `git blame v6.18.53`: lines from `081a6eda2b2509` (2023)
- [Phase 3] `git merge-base --is-ancestor 081a6eda2b2509 v6.18.53`: yes
  (bug in this tree)
- [Phase 3] `git merge-base --is-ancestor 9bd596d9e90da v6.18.53`: no
  (fix not in 6.18.53)
- [Phase 3] Related `9b608fe94870f` already in v6.18.53 (switch-state
  save)
- [Phase 4] `b4 dig -c 230753e46a4a...`: lore thread; v1 only
- [Phase 4] mbox: Kevin design comment; Lijo kept SMN reads; Alex Acked-
  by; no NAK
- [Phase 4] lore.kernel.org/stable: **UNVERIFIED** (HTTP 403)
- [Phase 5] Callers: sysfs `reg_state` 0444 → PCIE offset 0x2000; only
  `aqua_vanjaram_asic_funcs`
- [Phase 6] `git describe HEAD` / Makefile: 6.18.53; unguarded code at
  v6.18.53:653–670
- [Phase 6] `git apply --check` of candidate and upstream patches onto
  v6.18.53 file: success (offset only)
- [Phase 8] Failure mode: NULL deref oops on sysfs read in passthrough,
  HIGH
- UNVERIFIED: no public crash log specifically for this sysfs function
  (mechanism still verified)

**YES**

 drivers/gpu/drm/amd/amdgpu/aqua_vanjaram.c | 59 +++++++++++++++-------
 1 file changed, 42 insertions(+), 17 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/aqua_vanjaram.c b/drivers/gpu/drm/amd/amdgpu/aqua_vanjaram.c
index 15e70415c35b4..b73e114206cc1 100644
--- a/drivers/gpu/drm/amd/amdgpu/aqua_vanjaram.c
+++ b/drivers/gpu/drm/amd/amdgpu/aqua_vanjaram.c
@@ -613,6 +613,29 @@ static struct aqua_reg_list pcie_reg_addrs[] = {
 	{ smreg_0x1A380088, 6, DW_ADDR_INCR },
 };
 
+/*
+ * Return the GPU's internal US switch port, or NULL if it is not visible
+ * (e.g. passthrough) or the EP is parented under an unrelated bridge.
+ */
+static struct pci_dev *aqua_vanjaram_get_us_pdev(struct amdgpu_device *adev)
+{
+	struct pci_dev *ds_pdev, *us_pdev;
+
+	ds_pdev = pci_upstream_bridge(adev->pdev);
+	if (!ds_pdev || ds_pdev->vendor != PCI_VENDOR_ID_ATI ||
+	    pci_pcie_type(ds_pdev) != PCI_EXP_TYPE_DOWNSTREAM)
+		return NULL;
+
+	us_pdev = pci_upstream_bridge(ds_pdev);
+	if (!us_pdev ||
+	    (us_pdev->vendor != PCI_VENDOR_ID_ATI &&
+	     us_pdev->vendor != PCI_VENDOR_ID_AMD) ||
+	    pci_pcie_type(us_pdev) != PCI_EXP_TYPE_UPSTREAM)
+		return NULL;
+
+	return us_pdev;
+}
+
 static ssize_t aqua_vanjaram_read_pcie_state(struct amdgpu_device *adev,
 					     void *buf, size_t max_size)
 {
@@ -620,7 +643,7 @@ static ssize_t aqua_vanjaram_read_pcie_state(struct amdgpu_device *adev,
 	uint32_t start_addr, incrx, num_regs, szbuf;
 	struct amdgpu_regs_pcie_v1_0 *pcie_regs;
 	struct amdgpu_smn_reg_data *reg_data;
-	struct pci_dev *us_pdev, *ds_pdev;
+	struct pci_dev *us_pdev;
 	int aer_cap, r, n;
 
 	if (!buf || !max_size)
@@ -652,25 +675,27 @@ static ssize_t aqua_vanjaram_read_pcie_state(struct amdgpu_device *adev,
 		}
 	}
 
-	ds_pdev = pci_upstream_bridge(adev->pdev);
-	us_pdev = pci_upstream_bridge(ds_pdev);
+	us_pdev = aqua_vanjaram_get_us_pdev(adev);
+	if (us_pdev) {
+		pcie_capability_read_word(us_pdev, PCI_EXP_DEVSTA,
+					  &pcie_regs->device_status);
+		pcie_capability_read_word(us_pdev, PCI_EXP_LNKSTA,
+					  &pcie_regs->link_status);
+
+		aer_cap = pci_find_ext_capability(us_pdev, PCI_EXT_CAP_ID_ERR);
+		if (aer_cap) {
+			pci_read_config_dword(us_pdev,
+					      aer_cap + PCI_ERR_COR_STATUS,
+					      &pcie_regs->pcie_corr_err_status);
+			pci_read_config_dword(us_pdev,
+					      aer_cap + PCI_ERR_UNCOR_STATUS,
+					      &pcie_regs->pcie_uncorr_err_status);
+		}
 
-	pcie_capability_read_word(us_pdev, PCI_EXP_DEVSTA,
-				  &pcie_regs->device_status);
-	pcie_capability_read_word(us_pdev, PCI_EXP_LNKSTA,
-				  &pcie_regs->link_status);
-
-	aer_cap = pci_find_ext_capability(us_pdev, PCI_EXT_CAP_ID_ERR);
-	if (aer_cap) {
-		pci_read_config_dword(us_pdev, aer_cap + PCI_ERR_COR_STATUS,
-				      &pcie_regs->pcie_corr_err_status);
-		pci_read_config_dword(us_pdev, aer_cap + PCI_ERR_UNCOR_STATUS,
-				      &pcie_regs->pcie_uncorr_err_status);
+		pci_read_config_dword(us_pdev, PCI_PRIMARY_BUS,
+				      &pcie_regs->sub_bus_number_latency);
 	}
 
-	pci_read_config_dword(us_pdev, PCI_PRIMARY_BUS,
-			      &pcie_regs->sub_bus_number_latency);
-
 	pcie_reg_state->common_header.structure_size = szbuf;
 	pcie_reg_state->common_header.format_revision = 1;
 	pcie_reg_state->common_header.content_revision = 0;
-- 
2.53.0

