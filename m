Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CE0A49EC7C;
	Mon, 31 Aug 2026 13:40:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183660; cv=none; b=KnBNDZzdDu1la3Kqe64HW8YfG+KMHHdO6W1n44X1rHXjRxvHbYjUOUo+Rr+rccNtuAAOUnXE2JrIL66eaaPyoTZjoIz9VZTgzthttlex2PezdmdOCCPVuFoVJZ4J5XfoHp0hL/Z5ZNHxuKfKhdmEjECPTBWRFJMc6egcLuigCJ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183660; c=relaxed/simple;
	bh=pEN59Hvh2xSnx4Oset4MKQbPIxWil82jRcAsfuC5FwQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WQAF6HzyPBUAC7z8YpICeUbNSSIEDwDPYIaVAZQ/Km8vig9+Rd+WY7a14IVaJIaDXlsIiMT02xOwYwqNukGzSUCsaok+PxhSIaJd2iNUX9j/9fRKqxX2utZWgt7euQsNVEtWFde2RCfa9uh9XX/4NEXHl5tqUvTUSkr0qCczAc0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cM7eqY8q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cM7eqY8q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 241F71F000E9;
	Mon, 31 Aug 2026 13:40:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183657;
	bh=z9mJTpMcm1/aaJKkgjCHY5iHQT365GwTrWPUks41BV0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cM7eqY8qeEosnPuAchJ+qaOkybCExHHdxr+kgSQtlVD1RgFoZigPYDhn8Wd9pdyQK
	 cz9zlPlLGpRk6l8ZOuGoo8YHT3AM0Ro801ldKVFuL20GrorAVErTPZudmx5WZnP/7x
	 MN9+5YvUJ84ciRkW7eIbjFaKiQ5Dh2FGpSljqgqitXNbyEnaqVkZnVjJcx49uObveF
	 q03EVIUZuOnMadYmMViMf2lOHelZV5biVaR9WjEJE5E5AXkroYLSdzVIVqSUznRwmZ
	 VEeCaFxPNfz3yUVeALDWqy+jK2ZcwHchnKRmtKYfLRDWH4ek7W52qLGlrLoc1CjzKa
	 RAfXsom+EKpyw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Carlos Bilbao <carlos.bilbao@kernel.org>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>,
	kwilczynski@kernel.org,
	gregkh@linuxfoundation.org,
	linux-pci@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] misc: pci_endpoint_test: Validate BAR index in doorbell test
Date: Mon, 31 Aug 2026 09:24:13 -0400
Message-ID: <20260831133314.4125787-225-sashal@kernel.org>
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

From: Carlos Bilbao <carlos.bilbao@kernel.org>

[ Upstream commit 854bd081c7680029d7886689f6bef8f740625fde ]

pci_endpoint_test_doorbell() reads the BAR number directly from an endpoint
test register and uses it as an index into test->bar[].  Add a defensive
bounds check before the dereference: positive values >= PCI_STD_NUM_BARS
are out of range, and NO_BAR (-1) as a negative signed value would slip
past an upper-bound-only check.

Signed-off-by: Carlos Bilbao (Lambda) <carlos.bilbao@kernel.org>
[mani: changed errno to -ERANGE]
Signed-off-by: Manivannan Sadhasivam <mani@kernel.org>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Link: https://patch.msgid.link/20260410230300.135631-2-carlos.bilbao@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: `misc: pci_endpoint_test: Validate BAR index
in doorbell test`

**Local tree:** `v6.18.44-1-g2736c32da98b9` (kernel version **6.18.44**,
6.18.y stable series)

**Commit under review:** `854bd081c7680` (not yet in this tree; present
on `master`)

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Subject line
**Record:** `[misc: pci_endpoint_test]` `[Validate]` — defensive bounds
check on BAR index used in the doorbell test path.

### Step 1.2: Tags
**Record:**
- **Signed-off-by:** Carlos Bilbao (Lambda), Manivannan Sadhasivam,
  Bjorn Helgaas
- **Link:** https://patch.msgid.link/20260410230300.135631-2-
  carlos.bilbao@kernel.org
- No `Fixes:`, `Reported-by:`, `Cc: stable@vger.kernel.org`, `Tested-
  by:`, or `Reviewed-by:` in the committed message
- Notable: PCI subsystem maintainers (Mani, Bjorn) signed off; no syzbot
  or user bug report

### Step 1.3: Body analysis
**Record:**
- **Bug:** `pci_endpoint_test_doorbell()` reads a BAR number from
  endpoint MMIO (`PCI_ENDPOINT_TEST_DB_BAR`) and uses it unvalidated as
  `test->bar[bar]`.
- **Symptom:** Out-of-range positive values (`>= PCI_STD_NUM_BARS`) or
  `NO_BAR (-1)` cause out-of-bounds indexing before `writel()`.
- **Root cause:** Missing lower/upper bounds check; an upper-bound-only
  check would miss negative values because `bar` is `enum pci_barno`
  (signed, with `NO_BAR = -1`).
- **Version info:** None in the message.

### Step 1.4: Hidden bug fix?
**Record:** Yes — explicitly a memory-safety bounds-check fix, not
cosmetic cleanup. Same bug class as the earlier ioctl underflow fix
(`1ad82f9db13d8`).

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory
**Record:**
- **Files:** `drivers/misc/pci_endpoint_test.c` (+5 lines)
- **Function:** `pci_endpoint_test_doorbell()`
- **Scope:** Single-file, surgical fix

### Step 2.2: Code flow change
**Record:**
- **Before:** After re-reading `PCI_ENDPOINT_TEST_DB_BAR`, code
  immediately does `writel(data, test->bar[bar] + addr)`.
- **After:** Validates `bar < BAR_0 || bar >= PCI_STD_NUM_BARS`; logs
  error and returns `-ERANGE` on failure; only then dereferences
  `test->bar[bar]`.
- **Path affected:** Error/safety path inside doorbell test, reached via
  `ioctl(PCITEST_DOORBELL)`.

### Step 2.3: Bug mechanism
**Record:** **Category:** Out-of-bounds array access / buffer overflow.
- `test->bar` is `void __iomem *bar[PCI_STD_NUM_BARS]` (6 elements,
  indices 0–5).
- `pci_endpoint_test_readl()` returns `u32`; assigned to signed `enum
  pci_barno`.
- `bar == -1` (NO_BAR) → array underflow; `bar >= 6` → array overflow.
- Either can yield a garbage pointer passed to `writel()` → kernel oops
  or memory corruption.

### Step 2.4: Fix quality
**Record:** Obviously correct; mirrors the existing ioctl guard (`bar <=
NO_BAR || bar > BAR_5`). Minimal, no API changes. Low regression risk.
Does not add a NULL-bar check (consistent with other paths that validate
index separately).

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame
**Record:** Lines 895–897 introduced by `eefb83790a0dd` ("Add doorbell
test case", Frank Li, 2025-07-10). First appeared in **v6.17**. Bug
present since doorbell support landed.

### Step 3.2: Fixes: tag
**Record:** N/A — no `Fixes:` tag. Related introducing commit:
`eefb83790a0dd`, which is an ancestor of this 6.18.44 tree.

### Step 3.3: Related file history
**Record:**
- `eefb83790a0dd` — added doorbell test (v6.17+)
- `1ad82f9db13d8` — fixed ioctl array underflow for user-supplied BAR
  (same `NO_BAR` issue)
- `cc8e391067164`, `384b1b29481e3` — other doorbell-related cleanups
- Fix is standalone (patch 1/2 of a series); patch 2/2 only removes a
  dead register read (cleanup, not required for the bounds fix)

### Step 3.4: Author context
**Record:** Carlos Bilbao is a PCI endpoint contributor. Manivannan
Sadhasivam (PCI endpoint maintainer) applied the series. Dan Carpenter
previously fixed the parallel ioctl-path bug.

### Step 3.5: Dependencies
**Record:** No prerequisites. Doorbell code exists in this tree. `git
apply --check` on the patch succeeds cleanly against 6.18.44.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: Original discussion
**Record:** `b4 dig -c 854bd081c7680` → https://patch.msgid.link/2026041
0230300.135631-2-carlos.bilbao@kernel.org. Part of **v2 1/2** series.
Manivannan Sadhasivam replied "Applied, thanks!" No explicit stable
nomination found.

### Step 4.2: Reviewers
**Record:** `b4 dig -w`: CC'd to `mani@kernel.org`,
`kwilczynski@kernel.org`, `kishon@kernel.org`, `den@valinux.co.jp`,
`linux-pci@vger.kernel.org`. **Reviewed-by: Koichiro Den** on the
series.

### Step 4.3: Bug reports
**Record:** No external bug report, syzbot report, or crash log.
Proactive defensive fix identified during code review.

### Step 4.4: Series context
**Record:** 2-patch series. Only patch 1/2 (this commit) fixes the OOB
bug. Patch 2/2 removes an unused earlier BAR read.

### Step 4.5: Stable list history
**Record:** Not searched separately; no stable-list discussion found in
the patch thread.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Key functions
**Record:** `pci_endpoint_test_doorbell()` (modified), called from
`pci_endpoint_test_ioctl()`.

### Step 5.2: Callers
**Record:**
- `pci_endpoint_test_ioctl()` → `case PCITEST_DOORBELL:` →
  `pci_endpoint_test_doorbell(test)`
- Exposed via `misc_device` (`/dev/pci-endpoint-test.*`) through
  `unlocked_ioctl`
- Selftest: `tools/testing/selftests/pci_endpoint/pci_endpoint_test.c`
  calls `PCITEST_DOORBELL`

### Step 5.3: Callees
**Record:** `pci_endpoint_test_readl/writel`,
`wait_for_completion_timeout`, `writel()` to BAR-mapped MMIO.

### Step 5.4: Reachability
**Record:** Reachable from userspace via `ioctl()` on the misc device.
Requires access to the PCI endpoint test device node (typically root or
delegated permissions). Not triggerable by unprivileged users without
device access. With device access + buggy/malicious endpoint firmware
returning an invalid BAR register value, the OOB path is reachable.

### Step 5.5: Similar patterns
**Record:** Ioctl path already has equivalent validation at line 940:
```940:941:drivers/misc/pci_endpoint_test.c
                if (bar <= NO_BAR || bar > BAR_5)
                        goto ret;
```
Doorbell path lacks this guard — an inconsistency the patch corrects.

---

## PHASE 6: CROSS-REFERENCING AGAINST LOCAL TREE (6.18.44)

### Step 6.1: Buggy code present?
**Record:** **Yes.** `pci_endpoint_test_doorbell()` at lines 895–897
performs unchecked `test->bar[bar]` dereference. Doorbell support
(`eefb83790a0dd`) is an ancestor of HEAD (landed in v6.17, present in
6.18.44).

### Step 6.2: Backport complications
**Record:** **Clean apply.** `git apply --check` passes. No structural
conflicts; line numbers differ but context matches.

### Step 6.3: Related fixes already present?
**Record:** Ioctl underflow fix (`1ad82f9db13d8`) is in this tree. The
doorbell-path BAR validation fix (`854bd081c7680`) is **not** in this
tree (only on `master`).

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

### Step 7.1: Subsystem criticality
**Record:** **drivers/misc** — PCI Endpoint Test driver
(`CONFIG_PCI_ENDPOINT_TEST`). **PERIPHERAL** — host-side test driver for
PCI endpoint development (TI K3, Rockchip, etc.). Not a core subsystem,
but kernel code reachable from userspace ioctl.

### Step 7.2: Activity
**Record:** Actively maintained; multiple recent fixes in the same file
(IRQ range checks, ioctl underflow, integer overflow prevention).

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: Who is affected
**Record:** Users with `CONFIG_PCI_ENDPOINT_TEST` enabled who run the
doorbell selftest against PCI endpoint hardware. Primarily embedded/SoC
developers, not typical server/desktop workloads.

### Step 8.2: Trigger conditions
**Record:** `ioctl(PCITEST_DOORBELL)` after doorbell enable, when
endpoint MMIO reports `PCI_ENDPOINT_TEST_DB_BAR` outside [0, 5] or as
-1. Unlikely in correct firmware, but possible with bugs or during
bring-up. Requires device-node access.

### Step 8.3: Failure mode severity
**Record:** Out-of-bounds pointer dereference in `writel()` → **kernel
oops / potential memory corruption**. **Severity: HIGH** if triggered;
**likelihood: LOW** (niche driver, privileged access, depends on
endpoint behavior).

### Step 8.4: Risk-benefit
**Record:**
- **Benefit:** Prevents kernel crash from a real OOB bug; aligns
  doorbell path with already-fixed ioctl path.
- **Risk:** Very low — 5-line bounds check, maintainer-reviewed, clean
  apply.
- **Ratio:** Favorable for backport despite narrow exposure.

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence summary

**FOR backport:**
- Real out-of-bounds array index bug (underflow and overflow)
- Can cause kernel oops
- Small (5 lines), obviously correct, applies cleanly
- Buggy code confirmed in 6.18.44 since v6.17 doorbell addition
- PCI maintainers signed off; parallel ioctl fix already in this tree
- Self-contained; no dependencies

**AGAINST backport:**
- Niche test driver (`CONFIG_PCI_ENDPOINT_TEST`)
- Requires privileged device access
- No syzbot/user crash reports
- Invalid BAR comes from endpoint MMIO, not direct userspace input
- Limited production impact

**Unresolved:** None material to the decision.

### Step 9.2: Stable rules checklist
1. Obviously correct and tested? **PASS** — simple bounds check;
   selftests exercise doorbell path; maintainer applied.
2. Fixes a real bug? **PASS** — OOB array indexing.
3. Important issue? **PASS** — kernel crash on invalid index (HIGH
   severity, lower exposure).
4. Small and contained? **PASS** — 5 lines, one function.
5. No new features/APIs? **PASS**.
6. Can apply to local tree? **PASS** — clean apply verified.

### Step 9.3: Exception categories
**Record:** None (not device ID, quirk, DT, build, or docs). Standard
bug fix.

### Step 9.4: Decision rationale
For **6.18.44**, the doorbell test exists and has had an unchecked BAR
index since v6.17. This is the same class of memory-safety bug already
fixed on the ioctl path in this tree. The fix is minimal, maintainer-
approved, and prevents a kernel oops. Narrow driver scope lowers urgency
but does not negate that it is a real, reachable crash fix in code that
is present and active in this stable tree.

---

## Verification

- **[Phase 1]** Parsed commit `854bd081c7680` message and tags via `git
  show`
- **[Phase 1]** No syzbot/Reported-by; Link tag present; Bjorn Helgaas
  and Mani SOBs confirmed
- **[Phase 2]** Read `pci_endpoint_test_doorbell()` at lines 857–922;
  confirmed unchecked `test->bar[bar]` at line 897
- **[Phase 2]** Confirmed `test->bar[PCI_STD_NUM_BARS]` and `NO_BAR =
  -1` at lines 108–121
- **[Phase 3]** `git blame -L 895,897`: introduced by `eefb83790a0dd`
  (2025-07-10)
- **[Phase 3]** `git log -20 -- drivers/misc/pci_endpoint_test.c`:
  related ioctl fix `1ad82f9db13d8` present
- **[Phase 3]** `git tag --contains eefb83790a0dd`: first in **v6.17**
- **[Phase 3]** `git merge-base --is-ancestor`: doorbell IN tree; fix
  `854bd081c7680` NOT in HEAD; ioctl fix IN HEAD
- **[Phase 4]** `b4 dig -c 854bd081c7680`: lore URL found
- **[Phase 4]** `b4 dig -m /tmp/doorbell_bar.mbox`: v2 1/2 series;
  Reviewed-by Den; Mani "Applied, thanks!"
- **[Phase 4]** No stable nomination in thread
- **[Phase 5]** Traced call chain: `pci_endpoint_test_ioctl` →
  `PCITEST_DOORBELL` → `pci_endpoint_test_doorbell`
- **[Phase 5]** Grep `PCITEST_DOORBELL`: ioctl case at line 974,
  selftest at
  `tools/testing/selftests/pci_endpoint/pci_endpoint_test.c:261`
- **[Phase 5]** Confirmed ioctl bounds check at line 940 (`bar <= NO_BAR
  || bar > BAR_5`)
- **[Phase 6]** `git describe HEAD`: v6.18.44; `make kernelversion`:
  6.18.44
- **[Phase 6]** `git apply --check` on patch: **clean apply**
- **[Phase 6]** Read probe: `test` allocated with `devm_kzalloc` (line
  1019); `test->bar[]` sized `PCI_STD_NUM_BARS`
- **[Phase 8]** `CONFIG_PCI_ENDPOINT_TEST` in `drivers/misc/Kconfig:482`
  — tristate host-side PCI endpoint test driver

**YES**The background lookups finished and match the earlier analysis:

- **Commit hash:** `854bd081c7680` — `misc: pci_endpoint_test: Validate
  BAR index in doorbell test`
- **Location:** on `master` (via merge `ae385ca812325`), **not** in the
  checked-out **6.18.44** tree
- **Local state:** the doorbell path still does an unchecked
  `test->bar[bar]` dereference; the patch applies cleanly here

**Verdict remains YES** for backport to this 6.18.y tree — small bounds-
check fix for a real OOB bug in code that’s already present since v6.17.

 drivers/misc/pci_endpoint_test.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/misc/pci_endpoint_test.c b/drivers/misc/pci_endpoint_test.c
index 1c0fd185114fc..43e2282f8a76e 100644
--- a/drivers/misc/pci_endpoint_test.c
+++ b/drivers/misc/pci_endpoint_test.c
@@ -893,6 +893,11 @@ static int pci_endpoint_test_doorbell(struct pci_endpoint_test *test)
 	pci_endpoint_test_writel(test, PCI_ENDPOINT_TEST_STATUS, 0);
 
 	bar = pci_endpoint_test_readl(test, PCI_ENDPOINT_TEST_DB_BAR);
+	if (bar < BAR_0 || bar >= PCI_STD_NUM_BARS) {
+		dev_err(dev, "BAR %d reported by endpoint out of range [0, %u]\n",
+			bar, PCI_STD_NUM_BARS - 1);
+		return -ERANGE;
+	}
 
 	writel(data, test->bar[bar] + addr);
 
-- 
2.53.0

