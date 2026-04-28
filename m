Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F89240B6C1;
	Tue, 28 Apr 2026 10:42:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777372957; cv=none; b=qCHgEB+Syzyq9dj+PW6mhl4Jpy/9rRsI0ks1evg3lAR0KwEinZ7UFOt+WbfXXV/HqaTYaNvo5k/v4oPAsPEscMCKADRnFO310qqeheyiCG6HOFOfwMuxsvwz5Bji95UdG3il3vU0py23srhiHZeatcrq8DJaqHnvGMaGt4DY3ZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777372957; c=relaxed/simple;
	bh=BOvjJ5GrDqsAXbOKFhat0J6os4YSYT3DQ/aSrq6Yw1A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ncM8uPS+4qv2dWn9ngd4peS3zXc1KBYcQPXBjDxOIMnBmNTFV4VIvH9xw4BaWcsx/coRanPtI429jBsFjYY+qG4CxcH8Vsw4+s51JwQ/wPqvf6zmcZdZ3Kl77QG9L9GFlfSsLs+ZOm2gZwlGZtdnF+uCsYEnMOifWRchmGcGidI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EsfrOOuw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EsfrOOuw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 353D1C2BCB7;
	Tue, 28 Apr 2026 10:42:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777372957;
	bh=BOvjJ5GrDqsAXbOKFhat0J6os4YSYT3DQ/aSrq6Yw1A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EsfrOOuwaVZ1YuaUIiEVlxgsWvZEiwgk7x/wrYVzSV5WpaN6fRygvYgMHldKchpo0
	 zgqzzlvbzfSTnxUjejLmpV+pKdf75tp4FCjSxhj58qxX/Tz7Tgfr+6rFqd0BodwWrH
	 nTTEhWaRq3sMCf/mYjpQTtCcyYVs2Hvor7B0g9viWAUP8703mz8hSYijmD0Al8lt9f
	 XDMr11zfM+820XHYsraUpgZ/KP8us4IJ4RsDe0kYRvlDS2jLPlnAbZevje7VVdQWs0
	 wgbIyioI/QoamCCaOeX1TqF4FFHrpWJxjnbz0YaQHbtaQtXed941I2kns4T9o4/DBM
	 SRalrRGo2+0Nw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Saranya Gopal <saranya.gopal@intel.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0-6.12] mfd: intel-lpss: Add Intel Nova Lake-H PCI IDs
Date: Tue, 28 Apr 2026 06:40:56 -0400
Message-ID: <20260428104133.2858589-45-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260428104133.2858589-1-sashal@kernel.org>
References: <20260428104133.2858589-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 7.0.2
Content-Transfer-Encoding: 8bit

From: Saranya Gopal <saranya.gopal@intel.com>

[ Upstream commit d6e0ef44688249009dfa24f1cd619d41637de060 ]

Add Intel Nova Lake-H LPSS PCI IDs.

Signed-off-by: Saranya Gopal <saranya.gopal@intel.com>
Co-developed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://patch.msgid.link/20260313100337.3471-1-ilpo.jarvinen@linux.intel.com
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Based on my investigation, I have all the information needed. Let me
produce the full phased analysis.

---

# Analysis: mfd: intel-lpss: Add Intel Nova Lake-H PCI IDs

## PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1 - Subject line:**
- Subsystem: `mfd: intel-lpss:` (Multi-Function Device framework, Intel
  LPSS controller)
- Action verb: "Add"
- Record: Adds Intel Nova Lake-H PCI IDs to the existing Intel LPSS PCI
  driver

**Step 1.2 - Tags:**
- Signed-off-by: Saranya Gopal (Intel)
- Co-developed-by: Ilpo Järvinen (Intel)
- Signed-off-by: Ilpo Järvinen (Intel)
- Reviewed-by: Andy Shevchenko (Intel, LPSS subsystem maintainer)
- Link: patch.msgid.link URL pointing to lore thread (v2)
- Signed-off-by: Lee Jones (MFD maintainer, applied the patch)
- Record: NO Fixes: tag (expected, this is hardware enablement); NO Cc:
  stable tag; Reviewed-by from Andy Shevchenko who is the Intel LPSS
  area expert.

**Step 1.3 - Body text:**
- The commit body literally says: "Add Intel Nova Lake-H LPSS PCI IDs."
- No bug description - it's purely a hardware enablement commit
- Record: Not a bug fix. The "problem" being solved is that Linux does
  not currently recognize Nova Lake-H LPSS controllers, so UART/I2C/SPI
  hosts on such machines will not bind to the driver and will be non-
  functional.

**Step 1.4 - Hidden fix detection:**
- No hidden fix patterns. This is exactly what it claims to be: device
  ID enablement.
- Record: Not a hidden bug fix.

## PHASE 2: DIFF ANALYSIS

**Step 2.1 - Inventory:**
- Files: 1 (`drivers/mfd/intel-lpss-pci.c`)
- Lines: +13 / -0
- Functions: modifies the static const `intel_lpss_pci_ids[]` table
- Classification: single-file, surgical, table data addition
- Record: 13 new PCI table entries (12 IDs + 1 comment line), trivial
  additive change.

**Step 2.2 - Code flow change:**
- Before: PCI IDs 0xd325–0xd37b not in match table; driver does not bind
  to NVL-H LPSS devices
- After: 12 new entries added referencing existing `bxt_uart_info`,
  `tgl_spi_info`, `ehl_i2c_info` platform_info structs
- Record: No control flow change at all. Only the PCI ID table grows.

**Step 2.3 - Bug mechanism:**
- Category: Hardware workaround / device enablement (device ID addition)
- Mechanism: Adds 12 new `PCI_VDEVICE(INTEL, 0xd3xx)` entries pointing
  to existing, already-in-stable platform_info structures. These IDs
  follow the exact same layout pattern as sibling platforms (PTL-H at
  0xe3xx, NVL-S at 0x6exx, LNL-M at 0xa8xx).
- Record: Exception category 1 in the backport rules: "NEW DEVICE IDs -
  Adding PCI IDs to existing drivers."

**Step 2.4 - Fix quality:**
- Obviously correct: YES. It's table data.
- Minimal/surgical: YES. No code logic touched.
- Regression risk: effectively zero. New PCI IDs cannot affect any
  existing device binding; the PCI match table is only consulted when a
  device with that exact VID:DID appears. Only Nova Lake-H systems exist
  with these IDs, and those currently have no Linux support at all, so
  there is no one to regress.
- Record: Zero regression risk on existing systems; clearly correct.

## PHASE 3: GIT HISTORY INVESTIGATION

**Step 3.1 - git blame / file history:**
- `drivers/mfd/intel-lpss-pci.c` has a long history of identical PCI ID
  additions for each Intel CPU generation (CML, EHL, TGL, JSL, RPL, MTL,
  LNL, ARL, PTL, WCL, NVL-S, NVL-H).
- Record: This file is explicitly designed to accept per-generation PCI
  ID additions; this is a routine change.

**Step 3.2 - Fixes: tag follow-up:**
- No Fixes: tag. N/A (hardware enablement, not a regression fix).
- Record: N/A.

**Step 3.3 - Related recent changes:**
- `cefd793fa17de mfd: intel-lpss: Add Intel Nova Lake-S PCI IDs`
  (January 2026, same author)
- `c91a0e4e549d0 mfd: intel-lpss: Add Intel Wildcat Lake LPSS PCI IDs`
- `db6a186505c81 mfd: intel-lpss: Add Intel Panther Lake LPSS PCI IDs`
- `6112597f5ba84 mfd: intel-lpss: Add Intel Arrow Lake-H LPSS PCI IDs`
- Record: This is one of a series of per-generation ID additions by Ilpo
  Järvinen/Saranya Gopal. Each is standalone. No prerequisites.

**Step 3.4 - Author context:**
- Ilpo Järvinen is an Intel engineer who regularly adds LPSS IDs for new
  Intel platforms.
- Reviewer Andy Shevchenko is the original LPSS driver
  author/maintainer.
- Record: Authoritative contributors for this subsystem.

**Step 3.5 - Dependencies:**
- The referenced platform_info structs (`bxt_uart_info`, `tgl_spi_info`,
  `ehl_i2c_info`) have been in the driver for many releases
  (Broxton/Elkhart Lake/Tiger Lake eras).
- Record: No dependencies; patch is fully self-contained.

## PHASE 4: MAILING LIST / EXTERNAL RESEARCH

**Step 4.1 - b4 dig:**
- `b4 dig -c d6e0ef44688249009dfa24f1cd619d41637de060` found the
  submission.
- `b4 dig -a` showed v1 (2026-03-12) and v2 (2026-03-13). Applied
  version is v2.
- Record: v2 is the applied version. v1 → v2 changelog was merely
  "Tweaked authorship details" (per the mbox). No substantive change.

**Step 4.2 - Reviewers (b4 dig -w / mbox):**
- Andy Shevchenko (Intel, LPSS maintainer): gave `Reviewed-by`
- Lee Jones (MFD maintainer): applied
- Saranya Gopal (Intel, co-developer)
- Record: Correct maintainers reviewed and applied. No objections, no
  NAKs.

**Step 4.3 - Bug report:**
- N/A. No Reported-by, no Link to bug, no syzbot. It's hardware
  enablement.
- Record: N/A.

**Step 4.4 - Related patches:**
- Single-patch series. No companion patches needed.
- Record: Standalone.

**Step 4.5 - Stable ML history:**
- Not searched on lore.kernel.org/stable because the commit has no
  stable discussion; but the pattern (adding ID for a new Intel
  platform) has historically been backported without ML debate.
- Record: No explicit stable nomination, but this pattern is routinely
  accepted.

## PHASE 5: CODE SEMANTIC ANALYSIS

**Step 5.1 - Functions modified:**
- Only the static data array `intel_lpss_pci_ids[]`. No functions
  modified.
- Record: Data table only.

**Step 5.2 - Callers:**
- The array is consumed by the PCI core via
  `module_pci_driver(intel_lpss_pci_driver)` / `MODULE_DEVICE_TABLE(pci,
  intel_lpss_pci_ids)`.
- Record: Only consumed by PCI match/bind machinery for devices whose
  VID:DID appears in the table.

**Step 5.3 - Callees:**
- `PCI_VDEVICE(INTEL, ...)` macro expansion only. Platform info structs
  are looked up during probe on actual device match.
- Record: No new callees.

**Step 5.4 - Reachability:**
- The new IDs can only be matched by actual Nova Lake-H silicon. On any
  other hardware, the additions are dead data (PCI subsystem simply
  never calls probe for IDs that don't match).
- Record: Code only runs on NVL-H hardware.

**Step 5.5 - Similar patterns:**
- Directly adjacent in the file: PTL-H (0xe3xx), LNL-M (0xa8xx), NVL-S
  (0x6exx) — all identical patterns using the same 3 platform_info
  structs.
- Record: This is literally a copy-of-pattern with a different PCI
  VID:DID block.

## PHASE 6: CROSS-REFERENCING / STABLE TREE ANALYSIS

**Step 6.1 - Code existence in stable:**
- `intel-lpss-pci.c` exists in every currently-supported stable tree
  (5.10+).
- `bxt_uart_info`, `tgl_spi_info`, `ehl_i2c_info` all exist in stable
  6.1.y, 6.6.y, 6.12.y, 6.17.y+, 6.18.y, 6.19.y.
- Record: All prerequisite structures are present in every stable tree.

**Step 6.2 - Backport complications:**
- The patch context includes surrounding ID entries. On older stable
  trees that lack the most recent additions (PTL-H, WCL, NVL-S), the
  surrounding context differs, so a small context-level reshuffle of the
  hunk location may be needed — but the added 13 lines apply verbatim.
- Checked `stable-push/linux-6.12.y`: contains NVL-S (commit
  `a4c1546858558`) and Wildcat Lake (`42e7440ac65c1`). Trivial to add
  NVL-H alongside them.
- Checked `stable-push/linux-6.19.y`: contains NVL-S (`ae7ccffcc8f2f`).
  Trivial merge.
- Record: Clean apply on recent stables; minor context massaging only
  for older stables if they are targeted.

**Step 6.3 - Related fixes in stable:**
- NVL-S already in 6.12.y, 6.19.y — precisely the same pattern this
  commit applies. The NVL-H commit is the natural companion.
- Record: Identical sibling commit (NVL-S) is already in stable,
  confirming this pattern is accepted.

## PHASE 7: SUBSYSTEM / MAINTAINER CONTEXT

**Step 7.1 - Subsystem criticality:**
- `drivers/mfd/intel-lpss-pci.c` — peripheral device driver, but drives
  UART/I2C/SPI controllers on Intel PCH. Without these IDs, users of
  NVL-H hardware lose access to serial ports, I2C
  touchpads/touchscreens, SPI flash, etc.
- Criticality: IMPORTANT for affected users (hardware is unusable
  without the IDs); PERIPHERAL in scope.
- Record: IMPORTANT for NVL-H users.

**Step 7.2 - Subsystem activity:**
- Actively maintained; regular per-generation updates.
- Record: Active and healthy.

## PHASE 8: IMPACT AND RISK ASSESSMENT

**Step 8.1 - Affected users:**
- Users of Intel Nova Lake-H platforms who run a stable kernel.
- Record: Hardware-specific; affects everyone who buys NVL-H
  laptops/desktops if they want Linux LPSS support.

**Step 8.2 - Trigger conditions:**
- Boot on Nova Lake-H hardware.
- Record: Trivially triggered on affected hardware; zero effect on all
  other hardware.

**Step 8.3 - Failure mode:**
- Without this patch on NVL-H: LPSS UART/I2C/SPI devices do not bind →
  non-functional serial, touchpad, touchscreen, SPI flash, etc.
- With this patch: devices bind normally and work.
- Severity on affected hardware: HIGH (broad functional loss on new
  systems); severity on unaffected hardware: NONE.
- Record: HIGH benefit on NVL-H; zero risk elsewhere.

**Step 8.4 - Risk/benefit:**
- BENEFIT: Hardware enablement for a new Intel platform. Stable users
  upgrading to NVL-H laptops will have basic system functionality.
- RISK: Essentially zero. 13 lines of static table data; the added IDs
  do not match any existing hardware; structs used are long-established.
- Record: Very high benefit-to-risk ratio.

## PHASE 9: FINAL SYNTHESIS

**Step 9.1 - Evidence compilation:**
FOR:
- Classic "device ID addition" exception category (explicit stable
  policy allowance)
- Uses only pre-existing, battle-tested platform_info structs
- 13-line, single-file, additive, zero-logic-change patch
- Reviewed by subsystem expert (Andy Shevchenko)
- Sibling commits (NVL-S, Wildcat Lake, Panther Lake, Arrow Lake-H,
  Lunar Lake-M) routinely backported to stable; NVL-S already in 6.12.y
  and 6.19.y
- Zero regression risk on non-NVL-H hardware by construction

AGAINST:
- No Cc: stable tag (but this is expected — stable tags weren't added to
  recent NVL-S/WCL LPSS additions either, yet they were backported)
- Enables not-yet-released hardware (marginal consideration; once
  silicon is in the wild, stable users need the support)

UNRESOLVED:
- None material.

**Step 9.2 - Stable rules checklist:**
1. Obviously correct and tested? YES — maintainer-reviewed, uses
   existing structs.
2. Fixes a real issue affecting users? YES — missing hardware support on
   NVL-H.
3. Important issue? YES — basic I/O (UART/I2C/SPI) on the platform.
4. Small and contained? YES — 13 lines, one file.
5. No new features/APIs? YES — falls under the explicit "new device IDs"
   exception.
6. Applies to stable? YES — clean apply to recent stables.

**Step 9.3 - Exception category:**
- EXPLICITLY falls under "NEW DEVICE IDs" exception (PCI IDs added to
  existing driver).

**Step 9.4 - Decision:**
- This is the textbook case for stable backporting: a trivial PCI ID
  table addition to an existing, well-established driver, enabling users
  of a new Intel platform to have working UART/I2C/SPI. Zero risk, real
  user benefit, reviewed by the right people, and the same pattern for
  sibling platforms (NVL-S, WCL, PTL, ARL-H, LNL-M) has already been
  backported.

---

## Verification

- [Phase 1] Parsed tags: Reviewed-by Andy Shevchenko, Co-developed-by
  Ilpo Järvinen, applied by Lee Jones; no Fixes/stable/syzbot tags
  (confirmed from supplied message and from `/tmp/nvl_h_thread.mbox`).
- [Phase 2] Counted diff: +13 lines, 0 lines removed, 1 file
  (`drivers/mfd/intel-lpss-pci.c`), inserts 12 `PCI_VDEVICE(INTEL,
  0xd3xx)` entries + 1 comment.
- [Phase 3] `git log --oneline drivers/mfd/intel-lpss-pci.c` confirmed
  long series of per-generation PCI ID additions.
- [Phase 3] `git log --oneline --grep="mfd.*Nova Lake"` found only NVL-S
  (`cefd793fa17de`) in tree; `git log --all --grep="Nova Lake-H PCI"`
  (one-off ALL search) found commit `d6e0ef4468824` in a merge branch.
- [Phase 3] `git show cefd793fa17de` confirmed the sibling NVL-S commit
  pattern is identical.
- [Phase 4] `b4 dig -c d6e0ef44688249009dfa24f1cd619d41637de060`
  returned the patch thread and confirmed applied commit.
- [Phase 4] `b4 dig -a` confirmed two revisions (v1 and v2); v2 is the
  applied version.
- [Phase 4] Read `/tmp/nvl_h_thread.mbox` produced by `b4 dig -m`:
  confirmed Andy Shevchenko's Reviewed-by, Lee Jones' application, and
  v2 changelog ("Tweaked authorship details" only).
- [Phase 5] `Grep` for `bxt_uart_info|tgl_spi_info|ehl_i2c_info` in the
  driver file: 158 references total; `Read` confirmed all three structs
  are defined at lines 156, 229, 243 (long-established).
- [Phase 6] `git log stable-push/linux-6.12.y drivers/mfd/intel-lpss-
  pci.c`: confirmed NVL-S (`a4c1546858558`) and Wildcat Lake
  (`42e7440ac65c1`) already backported — same pattern as this commit.
- [Phase 6] `git log stable-push/linux-6.19.y drivers/mfd/intel-lpss-
  pci.c`: confirmed NVL-S (`ae7ccffcc8f2f`) backported to 6.19.y.
- [Phase 7] File path `drivers/mfd/intel-lpss-pci.c` classified as
  MFD/PCH peripheral driver for LPSS (UART/I2C/SPI controllers on Intel
  PCH).
- [Phase 8] Reachability: driver binding only triggers on hardware whose
  VID:DID matches; verified PCI_VDEVICE(INTEL, 0xd3xx) block is NVL-H-
  exclusive by comparison with PTL-H (0xe3xx), LNL-M (0xa8xx), NVL-S
  (0x6exx) ranges in the same file.
- UNVERIFIED: Could not fetch lore.kernel.org directly (Anubis proof-of-
  work block); mailing list details obtained via `b4 dig -m` mbox
  instead — this fully covers the discussion.
- UNVERIFIED: Did not test-apply the patch onto each individual stable
  branch; but inspection of context lines plus presence of surrounding
  generations in 6.12.y/6.19.y shows near-clean apply with at most
  trivial context adjustment.

This commit is a clean, low-risk hardware enablement device-ID addition
that sits squarely in the explicit stable-kernel-rules exception for new
PCI IDs, with a well-established precedent of identical sibling commits
(NVL-S, WCL) already in stable.

**YES**

 drivers/mfd/intel-lpss-pci.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/mfd/intel-lpss-pci.c b/drivers/mfd/intel-lpss-pci.c
index 713a5bfb1a3c2..a9452ac92fb2d 100644
--- a/drivers/mfd/intel-lpss-pci.c
+++ b/drivers/mfd/intel-lpss-pci.c
@@ -633,6 +633,19 @@ static const struct pci_device_id intel_lpss_pci_ids[] = {
 	{ PCI_VDEVICE(INTEL, 0xa879), (kernel_ulong_t)&ehl_i2c_info },
 	{ PCI_VDEVICE(INTEL, 0xa87a), (kernel_ulong_t)&ehl_i2c_info },
 	{ PCI_VDEVICE(INTEL, 0xa87b), (kernel_ulong_t)&ehl_i2c_info },
+	/* NVL-H */
+	{ PCI_VDEVICE(INTEL, 0xd325), (kernel_ulong_t)&bxt_uart_info },
+	{ PCI_VDEVICE(INTEL, 0xd326), (kernel_ulong_t)&bxt_uart_info },
+	{ PCI_VDEVICE(INTEL, 0xd327), (kernel_ulong_t)&tgl_spi_info },
+	{ PCI_VDEVICE(INTEL, 0xd330), (kernel_ulong_t)&tgl_spi_info },
+	{ PCI_VDEVICE(INTEL, 0xd347), (kernel_ulong_t)&tgl_spi_info },
+	{ PCI_VDEVICE(INTEL, 0xd350), (kernel_ulong_t)&ehl_i2c_info },
+	{ PCI_VDEVICE(INTEL, 0xd351), (kernel_ulong_t)&ehl_i2c_info },
+	{ PCI_VDEVICE(INTEL, 0xd352), (kernel_ulong_t)&bxt_uart_info },
+	{ PCI_VDEVICE(INTEL, 0xd378), (kernel_ulong_t)&ehl_i2c_info },
+	{ PCI_VDEVICE(INTEL, 0xd379), (kernel_ulong_t)&ehl_i2c_info },
+	{ PCI_VDEVICE(INTEL, 0xd37a), (kernel_ulong_t)&ehl_i2c_info },
+	{ PCI_VDEVICE(INTEL, 0xd37b), (kernel_ulong_t)&ehl_i2c_info },
 	/* PTL-H */
 	{ PCI_VDEVICE(INTEL, 0xe325), (kernel_ulong_t)&bxt_uart_info },
 	{ PCI_VDEVICE(INTEL, 0xe326), (kernel_ulong_t)&bxt_uart_info },
-- 
2.53.0

