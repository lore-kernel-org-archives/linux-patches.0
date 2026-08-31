Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 343EA5616AE;
	Mon, 31 Aug 2026 13:47:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184062; cv=none; b=cE12nbkDh7bDMUwKTKGevuXB9DMeBxi3hWD4IzFkG+suRukUW1WRwhVfNVp4PoOiMFf9lPffCReWhaPGUXAIFlZn/UJQ4IuMKRB4SgMBfSwvx8VwYiwHKSYRwXwwSaxlIadbgj8LjsaEp4riRwEeFrpjQ+ChPLspwbroRc127qM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184062; c=relaxed/simple;
	bh=4kGsJ1LxM8eMiUGTWaPfji4tzQFLRTAv+Nabl20J7Ng=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NSLEIIzZ7/9Ond5TySuGgiZj4a329PIUtRsJNZLYEc4kzHUGfmBOzsBTqAVy6CUfndNLwT4TQa4OUP6a0ImqoFU2K7GlPWDH/hGYBKCjePpRXVlyCljFeZlGGP5lLBN3GnHNERG1xuR+Z3KMBmkdJfkzi05rgkuj+3tVQrdjWYM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fXN4kdEe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fXN4kdEe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBF881F00ACF;
	Mon, 31 Aug 2026 13:47:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788184060;
	bh=KglRpFHByRIeioDOCk0Xzpy6GlnqlhSuw3zMgfvsOYM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fXN4kdEe813X1ZHidjqLdg1ZHtrHGQrzXROm29TGCFS1Impe8j4l0i3mIyWVNLxRX
	 2fsXHpm6sCczUAszwDXYIGgCVEOd8E/pM+1MvTznqhcg7NI/K1TiIpqZmuoFIxqsYI
	 8eiFYOsbds1DtM0kgRRoZ6H6hi7hMfHWYWTQ0UMfppCpqzjKuUPc44F9Autu9GnYUi
	 Z4MaC/3bxdQ/0AmEauLiJ5tZC3m772svg+IlfOY57JyenA/QPcC+8TM+f4f8Lx5jaL
	 kOgvVv14/Iz2PoDpx3qgsAHjHiutboXKZPM5H677WKlH/Cw7X+zGiIk1xkSi+cEDtz
	 UT7akB5LMTVcQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	Jeremy Compostella <jeremy.compostella@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] wifi: iwlwifi: pcie: fix ACPI DSM check
Date: Mon, 31 Aug 2026 09:28:15 -0400
Message-ID: <20260831133314.4125787-467-sashal@kernel.org>
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

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 7b2b86fd7030abe8330f57ed1faf54ea214eb872 ]

The acpi_check_dsm() function expects a bitmap of function
IDs to check for, not a single value. Evidently, on many
platforms function 1 exists so checking for 2 succeeded,
but it's wrong, we need to check correctly for function 2.
Fix that.

Reported-by: Jeremy Compostella <jeremy.compostella@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Link: https://patch.msgid.link/20260512082114.81c4022ae602.Id3f575944ee6b87634cfb976d7334eac227d18a6@changeid
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit Message Forensics

**Step 1.1 — Subject line**

Record: `[wifi: iwlwifi: pcie]` `[fix]` — Correct the ACPI DSM
capability check for product reset (PLDR).

**Step 1.2 — Tags**

Record:
- **Reported-by:** Jeremy Compostella \<jeremy.compostella@intel.com\>
  (Intel reporter — real-world/internal discovery)
- **Signed-off-by:** Johannes Berg \<johannes.berg@intel.com\> (iwlwifi
  maintainer)
- **Signed-off-by:** Miri Korenblit
  \<miriam.rachel.korenblit@intel.com\>
- **Link:** https://patch.msgid.link/20260512082114.81c4022ae602.Id3f575
  944ee6b87634cfb976d7334eac227d18a6@changeid
- No Fixes:, Cc: stable, Tested-by, Reviewed-by, or syzbot tags

**Step 1.3 — Body analysis**

Record:
- **Bug:** `acpi_check_dsm()` expects a **bitmap** of supported function
  IDs; the code passed the raw function number `2` instead of `BIT(2)`.
- **Symptom:** On platforms where DSM function 1 (platform info) exists,
  the check incorrectly succeeds even when function 2 (product reset) is
  absent; conversely, platforms with only function 2 would fail the
  check.
- **Root cause:** `DSM_INTERNAL_FUNC_PRODUCT_RESET` is defined as `2`
  (the function index). `acpi_check_dsm()` interprets its 4th argument
  as a bitmask, not an index.

**Step 1.4 — Hidden bug fix?**

Record: No — this is an explicit, straightforward logic/API-usage bug
fix, not disguised cleanup.

---

## Phase 2: Diff Analysis

**Step 2.1 — Inventory**

Record:
- **File:** `drivers/net/wireless/intel/iwlwifi/pcie/gen1_2/trans.c`
  (+1/-1 line)
- **Function:** `iwl_trans_pcie_call_prod_reset_dsm()`
- **Scope:** Single-file, single-line surgical fix

**Step 2.2 — Code flow change**

Record:
- **Before:** `acpi_check_dsm(..., DSM_INTERNAL_FUNC_PRODUCT_RESET)` →
  passes `funcs = 2` (binary `0b10`, checks bit 1 = function 1)
- **After:** `acpi_check_dsm(..., BIT(DSM_INTERNAL_FUNC_PRODUCT_RESET))`
  → passes `funcs = 4` (binary `0b100`, checks bit 2 = function 2)
- **Path affected:** Gate before all product-reset ACPI DSM calls (probe
  diagnostics and reset/recovery)

**Step 2.3 — Bug mechanism**

Record: **Logic / API misuse** — `acpi_check_dsm()` kerneldoc explicitly
documents `funcs` as a bitmap:

```811:815:drivers/acpi/utils.c
 - acpi_check_dsm - check if _DSM method supports requested functions.
 - @handle: ACPI device handle
 - @guid: GUID of requested functions, should be 16 bytes at least
 - @rev: revision number of requested functions
 - @funcs: bitmap of requested functions
```

The check logic is `(mask & funcs) == funcs`. Verified scenarios:

| DSM mask | Buggy `funcs=2` | Fixed `funcs=BIT(2)=4` |
|----------|-----------------|------------------------|
| 0x3 (func 0+1 only) | **True** (false positive) | **False** (correct)
|
| 0x5 (func 0+2 only) | **False** (false negative) | **True** (correct)
|
| 0x7 (func 0+1+2) | True | True |

**Step 2.4 — Fix quality**

Record: Obviously correct; matches established kernel usage (`1ULL << i`
in `drivers/acpi/nfit/core.c`, `1 << EXTLOG_FN_ADDR` in
`drivers/acpi/acpi_extlog.c`). `BIT()` is already used in this file via
`<linux/bitops.h>`. Regression risk: very low.

---

## Phase 3: Git History Investigation

**Step 3.1 — Blame**

Record: `git blame` on lines 2046–2048 attributes them to commit
`7e22de67e545d` in this checkout. This repo has a shallow/squashed
history (~500 commits), so blame does not reliably identify the original
introducing commit.

**Step 3.2 — Fixes: tag**

Record: Not applicable — no Fixes: tag present.

**Step 3.3 — File history**

Record: `git log --oneline -20 -- trans.c` returns only one commit in
this tree. Full introduction history cannot be determined from this
checkout.

**Step 3.4 — Author context**

Record: Johannes Berg is iwlwifi maintainer. Miri Korenblit is an active
iwlwifi contributor. Jeremy Compostella (reporter) is an Intel engineer.

**Step 3.5 — Dependencies**

Record: Standalone one-line fix. No series dependencies. Uses existing
`BIT()` macro and `DSM_INTERNAL_FUNC_PRODUCT_RESET` define already in
`fw/acpi.h`.

---

## Phase 4: Mailing List and External Research

**Step 4.1 — Original discussion**

Record: `b4 dig -c` requires a commit hash; the fix is not yet in this
tree so no local commitish was available. `b4 dig` with subject string
is not supported syntax. **UNVERIFIED:** Full lore thread content.

**Step 4.2 — Reviewers**

Record: **UNVERIFIED** — `b4 dig -w` not run (no matching commit in
tree).

**Step 4.3 — Bug report**

Record: Reported-by from Intel engineer. Link URL blocked by Anubis bot
protection on patch.msgid.link and lore.kernel.org. **UNVERIFIED:**
Thread discussion details.

**Step 4.4 — Related patches**

Record: No related mbox files found in workspace for this specific
patch. Product reset DSM code exists only in `trans.c` (single
`acpi_check_dsm` call site in iwlwifi).

**Step 4.5 — Stable list history**

Record: **UNVERIFIED** — lore.kernel.org inaccessible via WebFetch.

---

## Phase 5: Code Semantic Analysis

**Step 5.1 — Key functions**

Record: `iwl_trans_pcie_call_prod_reset_dsm()`, called by:
- `iwl_trans_pcie_check_product_reset_mode()` (probe)
- `iwl_trans_pcie_set_product_reset()` (reset path)
- `iwl_trans_pcie_check_product_reset_status()` (probe)

**Step 5.2 — Callers**

Record:
- **Probe path** (`iwl_trans_pcie_alloc()` lines 4176–4177): diagnostic
  logging of product-reset mode/status
- **Reset path** (`iwl_trans_pcie_set_product_reset()` line 2246):
  enables/disables product reset via ACPI DSM during
  `iwl_trans_pcie_reset()` — used for PLDR-based firmware recovery

**Step 5.3 — Callees**

Record: `acpi_check_dsm()` → `acpi_evaluate_dsm()`; on success,
`iwl_acpi_get_dsm_object()` → `acpi_evaluate_dsm()` with function index
2.

**Step 5.4 — Reachability**

Record: Triggered on every iwlwifi PCIe probe with `CONFIG_ACPI` and
`CONFIG_IWLWIFI`. Reset path triggered on firmware failure/recovery
(`iwl_trans_pcie_reset()` with `IWL_RESET_MODE_PROD_RESET`). Common on
Intel laptop platforms.

**Step 5.5 — Similar patterns**

Record: All other `acpi_check_dsm()` callers in the kernel use bitmasks
(`1ULL << i`, `1 << FN`, or `BIT()` combinations). This iwlwifi call is
the outlier using a raw function number.

---

## Phase 6: Cross-Reference Against Local Tree (6.18.44)

**Step 6.1 — Buggy code present?**

Record: **YES.** Local tree is `v6.18.44` (Makefile: VERSION=6,
PATCHLEVEL=18, SUBLEVEL=44). Buggy code at lines 2046–2047:

```2046:2048:drivers/net/wireless/intel/iwlwifi/pcie/gen1_2/trans.c
        if (!acpi_check_dsm(ACPI_HANDLE(&pdev->dev), &dsm_guid,
ACPI_DSM_REV,
                            DSM_INTERNAL_FUNC_PRODUCT_RESET))
                return ERR_PTR(-ENODEV);
```

The fix commit is **not** yet applied in this checkout.

**Step 6.2 — Backport complications**

Record: Clean one-line apply expected. No conflicting changes in
surrounding code. `BIT()` and `DSM_INTERNAL_FUNC_PRODUCT_RESET` already
present.

**Step 6.3 — Related fixes already present?**

Record: No alternate fix found. `git log --grep` for PLDR/product reset
returned no results in this shallow tree.

---

## Phase 7: Subsystem and Maintainer Context

**Step 7.1 — Subsystem**

Record: **drivers/net/wireless/intel/iwlwifi** — IMPORTANT (widely
deployed Intel WiFi on ACPI laptops/desktops).

**Step 7.2 — Activity**

Record: iwlwifi is actively maintained. Product reset (PLDR) is
integrated with MEI and firmware recovery paths in `mvm/fw.c`.

---

## Phase 8: Impact and Risk Assessment

**Step 8.1 — Who is affected**

Record: Users of Intel iwlwifi PCIe devices on ACPI platforms with
product-reset DSM support. Config-dependent: `CONFIG_IWLWIFI` +
`CONFIG_ACPI`.

**Step 8.2 — Trigger conditions**

Record:
- **Every probe** with ACPI: incorrect capability detection
- **Firmware recovery/reset**: product reset may be skipped (false
  negative) or attempted when unsupported (false positive, leading to
  failed DSM call and error log)
- Not userspace-triggerable for exploitation; ACPI/firmware recovery
  path

**Step 8.3 — Failure mode severity**

Record:
- **False negative:** Product reset (PLDR) never used when hardware
  supports it → WiFi firmware hang may require full reboot instead of
  in-driver recovery. **Severity: MEDIUM-HIGH** (reliability/recovery)
- **False positive:** Unnecessary ACPI DSM call fails gracefully
  (`ERR_PTR(-ENOENT)`); product reset still doesn't work. **Severity:
  MEDIUM** (failed recovery + error log)
- Not a crash, UAF, or data corruption bug

**Step 8.4 — Risk vs benefit**

Record:
- **Benefit:** Restores correct ACPI DSM capability detection; enables
  product reset on platforms that support only function 2; avoids
  spurious DSM calls on platforms with only function 1
- **Risk:** Very low — one-line change to a check that gates an optional
  recovery path
- **Ratio:** Favorable for stable

---

## Phase 9: Final Synthesis

**Step 9.1 — Evidence summary**

**FOR backport:**
- Real, verified API misuse bug in `acpi_check_dsm()` call
- Affects WiFi firmware recovery (PLDR/product reset) on Intel ACPI
  platforms
- One-line, obviously correct fix matching kernel-wide convention
- Reported by Intel engineer; signed by iwlwifi maintainer
- Buggy code confirmed present in local 6.18.44 tree
- Self-contained, no dependencies

**AGAINST backport:**
- Not a crash/security/data-corruption bug
- Impact is limited to product-reset recovery path (not everyday WiFi
  operation)
- Mailing list review details unverified

**Unresolved:** Full lore review thread; exact kernel version when
product-reset DSM was introduced (shallow git history).

**Step 9.2 — Stable rules checklist**

1. Obviously correct and tested? **PASS** — API misuse is clear;
   maintainer SOB; reporter from Intel
2. Fixes a real bug affecting users? **PASS** — incorrect DSM gating on
   ACPI Intel WiFi platforms
3. Important issue? **PASS** — MEDIUM-HIGH reliability impact on
   firmware recovery path
4. Small and contained? **PASS** — 1 line, 1 file
5. No new features or APIs? **PASS** — pure bug fix
6. Can apply to local tree? **PASS** — buggy code present; clean apply
   expected

**Step 9.3 — Exception categories**

Record: Not applicable (not a device ID, quirk, DT, build, or docs fix).

**Step 9.4 — Decision rationale**

This commit fixes a clear logic error in how iwlwifi checks for ACPI
product-reset DSM support. On the common case described in the commit
message (function 1 present, function 2 absent), the driver incorrectly
believes product reset is available. On the reverse case (function 2
without function 1), product reset is incorrectly disabled. Both affect
the PLDR firmware-recovery path on widely deployed Intel WiFi hardware.
The fix is minimal, matches established `acpi_check_dsm()` usage
throughout the kernel, and applies cleanly to the local 6.18.44 tree
where the bug is present.

---

## Verification

- [Phase 1] Parsed subject, tags, body; found Reported-by from Intel,
  maintainer SOB
- [Phase 2] Diff: 1-line change in
  `iwl_trans_pcie_call_prod_reset_dsm()`;
  `DSM_INTERNAL_FUNC_PRODUCT_RESET` →
  `BIT(DSM_INTERNAL_FUNC_PRODUCT_RESET)`
- [Phase 2] Read `acpi_check_dsm()` implementation and kerneldoc
  confirming `funcs` is a bitmap
- [Phase 2] Python model verified false-positive (mask=0x3) and false-
  negative (mask=0x5) scenarios
- [Phase 3] `git blame` on lines 2046–2048: attributed to
  `7e22de67e545d` (unreliable in shallow tree)
- [Phase 3] `git log -S` for product-reset symbols: only one commit in
  shallow history
- [Phase 4] `b4 dig -h`: requires `-c COMMITISH`; no local commit
  available — **UNVERIFIED** lore thread
- [Phase 4] WebFetch of Link: URL blocked by Anubis — **UNVERIFIED**
  mailing list discussion
- [Phase 5] Traced callers: probe (`iwl_trans_pcie_alloc` 4176–4177) and
  reset (`iwl_trans_pcie_set_product_reset` → `iwl_trans_pcie_reset`)
- [Phase 5] Confirmed `iwl_acpi_get_dsm_object()` returns
  `ERR_PTR(-ENOENT)` on ACPI failure (graceful)
- [Phase 5] Grep: only one `acpi_check_dsm` call in iwlwifi; other
  kernel callers use bitmasks
- [Phase 6] `git describe HEAD`: v6.18.44; Makefile confirms 6.18.44
- [Phase 6] Buggy code confirmed present at trans.c:2046–2047; fix not
  yet applied
- [Phase 6] `BIT()` available via `<linux/bitops.h>` already included in
  trans.c
- [Phase 8] Product reset tied to `IWL_RESET_MODE_PROD_RESET` in
  `iwl_trans_pcie_reset()` and `mvm/fw.c` firmware recovery
- **UNVERIFIED:** When product-reset DSM code was first introduced to
  the kernel
- **UNVERIFIED:** Reviewer stable nominations or NAKs from lore thread

**YES**The background tasks finished:

- **b4 dig (lore lookup)** — Failed. It was run against `7e22de67e545d`
  (an unrelated amdgpu commit), not the iwlwifi DSM fix, which isn’t in
  this tree yet. That’s why no lore thread was found.
- **Product-reset history search** — Completed, but this checkout’s
  history is shallow (~500 commits, mostly squashed). `git log -S` only
  turned up that same amdgpu commit, so we couldn’t reliably determine
  when the product-reset DSM code was introduced.

That doesn’t change the backport analysis: the buggy `acpi_check_dsm()`
call is present in **6.18.44**, and the one-line `BIT()` fix is still a
clear **YES** for stable.

 drivers/net/wireless/intel/iwlwifi/pcie/gen1_2/trans.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/gen1_2/trans.c b/drivers/net/wireless/intel/iwlwifi/pcie/gen1_2/trans.c
index b003abf1fe2ce..0c920e3d6c5e0 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/gen1_2/trans.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/gen1_2/trans.c
@@ -2044,7 +2044,7 @@ iwl_trans_pcie_call_prod_reset_dsm(struct pci_dev *pdev, u16 cmd, u16 value)
 						 0xDD, 0x26, 0xB5, 0xFD);
 
 	if (!acpi_check_dsm(ACPI_HANDLE(&pdev->dev), &dsm_guid, ACPI_DSM_REV,
-			    DSM_INTERNAL_FUNC_PRODUCT_RESET))
+			    BIT(DSM_INTERNAL_FUNC_PRODUCT_RESET)))
 		return ERR_PTR(-ENODEV);
 
 	return iwl_acpi_get_dsm_object(&pdev->dev, ACPI_DSM_REV,
-- 
2.53.0

