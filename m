Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E67844FB9C1;
	Mon, 19 Oct 2026 13:55:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418149; cv=none; b=eo6v61J8NImqfx5UKVQiE0hDZdFPVVFQtodL+IJxAJrvs5rQ2fwTWfiRXQZCqGykIi4MS4ZB8FpjTnSP5NbIZ1YAG8cQX+at3x9bBXuw8ASQ9y2kSKZUE1+gomd/VsxLWPXdSLulLimMGFm+xEt5xT1Hif1XM/+G0leJ9dFQaBc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418149; c=relaxed/simple;
	bh=xNpJtdbzmu4bsF8kG77rCxjk225HcJCrbbgFn6PT9IM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=b85QwJZlcpyzP4/4HQS7uzqioH76K5JJZuOhC/RbXuKcz7u5VP6LQc5aLPAyJJ+ASHIAoOflZRC9hlPMAwr6VMXJ+s0l2+uofEt+z5TsQC8cuKtkf+DDpoG0ekJsGAlhb+78nV2nZv1BnINVsvUoxHVYrCF2jZuaD2xjtv7T/mo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BgtwxXbW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BgtwxXbW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F06B1F000C7;
	Mon, 19 Oct 2026 13:55:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418147;
	bh=Wg+AIs8KYPCP0rVOxjNhqpgGUxP9XW+ARNuo5978U/4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BgtwxXbWwpe9qTC0GcQPs/8I5QUSy0LEPrKHAGnihldi873a4rHxFo7kX2J3en1Un
	 iyq48ztCulUx/4m3VSOv3pt6YjzqLeggIc+GziU1FNTDMSXH9Bjp1NqOujV1OVgS2R
	 gkoj4+Yj61K9NJn0amqNLY5TuSCzSxeFCTtWM1iInOcSYOwpLCkopaonJ6A2U45OFz
	 m7CkwYOYt3jN17EwM6NCE1CfpAlt46Jw8jjZVXN92a1nLrO5nGKBLiiRYytCklR3ny
	 WpvwsNNEzfvhWX0WzLFbRLeZXMBGUZFICvSmmxGJYDt1Rn5Ca+syfxZaSMghaI33Bb
	 SyxODDqsDdv+w==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Logan Gunthorpe <logang@deltatee.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>,
	linux-pci@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.1] PCI: switchtec: Add Microchip PCI1008 to NTB DMA alias quirk
Date: Mon, 19 Oct 2026 09:45:37 -0400
Message-ID: <20261019135441.1420968-46-sashal@kernel.org>
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

From: Logan Gunthorpe <logang@deltatee.com>

[ Upstream commit 00a479ba1d01249d43ca5e453380d1ed60946f8a ]

Add the PCI1008 device ID to the quirk_switchtec_ntb_dma_alias PCI fixup
table. Without it, DMA transactions from a PCI1008 switch's NTB function
are not given the correct requester ID alias, which can misdirect them
under an IOMMU.

Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Link: https://patch.msgid.link/20260714212010.230606-4-logang@deltatee.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

This is a one-line PCI ID addition to an existing NTB DMA-alias quirk.
The local tree is **v7.3-rc4** (`7.3.0-rc4`, HEAD `f0100363d8c37`). The
`SWITCHTEC_PCI100X_QUIRK` table is present, so the change belongs here.

===============================================================
PHASE 1: COMMIT MESSAGE FORENSICS
===============================================================

**Step 1.1: PARSE THE SUBJECT LINE**

Record: `[PCI: switchtec:] [Add] [PCI1008 device ID to the existing NTB
DMA alias quirk table]`

**Step 1.2: PARSE ALL COMMIT MESSAGE TAGS**

Record:
- `Fixes:` — none (expected)
- `Reported-by:` — none
- `Tested-by:` — none
- `Reviewed-by:` — none
- `Acked-by:` — none on this patch; Vinod Koul acked series patch 1/3
  (dmaengine ID)
- `Link:`
  https://patch.msgid.link/20260714212010.230606-4-logang@deltatee.com
  (series 3/3)
- `Cc: stable@vger.kernel.org` — none (expected)
- `Signed-off-by: Logan Gunthorpe <logang@deltatee.com>` (author;
  SWITCHTEC DMA maintainer)
- `Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>` (PCI subsystem
  maintainer)

**Step 1.3: ANALYZE THE COMMIT BODY TEXT**

Record:
- **Bug:** PCI1008 is missing from `quirk_switchtec_ntb_dma_alias`.
  Switchtec NTB replaces the original requester ID with a hardware proxy
  ID. Without an IOMMU alias, those TLPs are not attributed to the NTB
  device.
- **Symptom:** DMA from a PCI1008 NTB function can be misdirected or
  blocked when an IOMMU is on (IOMMU faults / failed peer DMA).
- **Versions:** none named. Series cover letter says the patches were
  based on v7.2-rc3; Bjorn applied them for v7.3.
- **Root cause:** the PCI100X quirk table lists 0x1001–0x1006 only;
  PCI1008 (0x1008) was never added.

**Step 1.4: DETECT HIDDEN BUG FIXES**

Record: Not hidden. It is an explicit hardware-quirk / device-ID
addition. That is a documented stable exception, not cleanup.

===============================================================
PHASE 2: DIFF ANALYSIS - LINE BY LINE
===============================================================

**Step 2.1: INVENTORY THE CHANGES**

Record:
- File: `drivers/pci/quirks.c` — **+1 / −0**
- Function: none changed; one `SWITCHTEC_PCI100X_QUIRK(0x1008)` entry
  added next to 0x1001–0x1006
- Scope: single-file, one-line surgical fix

**Step 2.2: UNDERSTAND THE CODE FLOW CHANGE**

Record:
- **Before:** `DECLARE_PCI_FIXUP_CLASS_FINAL(PCI_VENDOR_ID_EFAR, 0x1008,
  PCI_CLASS_BRIDGE_OTHER, 8, quirk_switchtec_ntb_dma_alias)` is not
  registered. A PCI1008 NTB function never runs the quirk.
- **After:** the same FINAL-class fixup used for PCI1001–PCI1006 is
  registered for 0x1008. Enumeration of a matching device calls
  `quirk_switchtec_ntb_dma_alias()`, which reads the NTB proxy-ID tables
  and calls `pci_add_dma_alias()`.
- Path: PCI enumeration / class fixup FINAL (init), not a hot path.

**Step 2.3: IDENTIFY THE BUG MECHANISM**

Record:
- **Category:** (h) Hardware workaround — PCI ID added to an existing
  quirk table
- **Mechanism:** Switchtec NTB DMA uses proxy requester IDs. IOMMU
  groups are built from those aliases. Missing 0x1008 means PCI1008
  proxy IDs are not aliased, so IOMMU policy does not match the
  requester ID on the wire.

**Step 2.4: ASSESS THE FIX QUALITY**

Record:
- Obviously correct: same macro and comment style as PCI1001–PCI1006.
- Minimal: one line, no API or structure change.
- Regression risk: very low. The new fixup only matches vendor EFAR +
  device 0x1008 + class `PCI_CLASS_BRIDGE_OTHER`. Other devices are
  unchanged. `quirk_switchtec_ntb_dma_alias()` already bounds `table_sz`
  (skip 0, reject >512).
- Red flags: none. A pre-existing `ep_map + 4` pointer-arithmetic issue
  in the quirk function was flagged on the list; it is not introduced by
  this line.

===============================================================
PHASE 3: GIT HISTORY INVESTIGATION
===============================================================

**Step 3.1: BLAME THE CHANGED LINES**

Record:
- Surrounding `SWITCHTEC_PCI100X_QUIRK` entries: `a3282f84b2151` (“PCI:
  switchtec: Add Microchip PCI100X device IDs”, 2025-01-21). Present in
  v6.14, not in v6.13.
- Original Switchtec NTB DMA alias quirk: `ad281ecf1c7d4` (“PCI: Add DMA
  alias quirk for Microsemi Switchtec NTB”, 2018-06-29). Present in this
  tree.
- The 0x1008 line itself is this commit (`00a479ba1d012`).

**Step 3.2: FOLLOW THE FIXES: TAG**

Record: No `Fixes:` tag. The omission is the PCI1008 ID never being
added when PCI100X support landed in `a3282f84b2151` (six SKUs
1001–1006). PCI1008 is a later part.

**Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES**

Record:
- Same series (msgid `20260714212010.230606-*`, based on v7.2-rc3,
  applied to pci/switchtec for v7.3):
  1. `8b326de3cc02c` dmaengine: switchtec-dma: Add PCI1008 device ID
     (`-2`)
  2. `0d8a6306c680e` PCI: switchtec: Add Microchip PCI1008 device ID
     (`-3`)
  3. `00a479ba1d012` this patch (`-4`, submitted as 3/3)
- This patch is standalone. The quirk is a PCI fixup, not a driver ID
  table. It does not need the switchtec or switchtec-dma ID additions.

**Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS**

Record: Logan Gunthorpe is listed maintainer of SWITCHTEC DMA
(`MAINTAINERS`) and a long-time switchtec contributor. Bjorn Helgaas
(PCI maintainer) signed off and applied the series.

**Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS**

Record:
- Prerequisite in this tree: `SWITCHTEC_PCI100X_QUIRK` /
  `PCI_VENDOR_ID_EFAR` table from `a3282f84b2151` — present.
- `quirk_switchtec_ntb_dma_alias()` and `pci_add_dma_alias()` — present.
- No other structural dependency. Can apply standalone.

===============================================================
PHASE 4: MAILING LIST AND EXTERNAL RESEARCH
===============================================================

**Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION**

Record:
- `b4 dig -c 00a479ba1d012` →
  https://patch.msgid.link/20260714212010.230606-4-logang@deltatee.com
- Subject on list: `[PATCH v1 3/3] PCI: Add PCI1008 to switchtec NTB DMA
  alias quirk`
- `b4 dig -a`: only v1. Cover letter `[PATCH v1 0/3] switchtec: add new
  device IDs`.
- Direct lore.kernel.org HTTP fetch returned 403/Anubis; the thread was
  recovered via `b4 dig -m`.
- Review: no NAKs. Sashiko noted a pre-existing `ep_map + 4` pointer
  issue; Logan said it is unrelated and should not gate the series.
  Bjorn: “Applied to pci/switchtec for v7.3, thanks!”
- No reviewer asked for `Cc: stable`.

**Step 4.2: CHECK WHO REVIEWED THE PATCH**

Record (`b4 dig -w`): Logan Gunthorpe, linux-pci, linux-kernel,
dmaengine, Vinod Koul, Bjorn Helgaas, Frank Li, Kelvin Cao (Microchip /
SWITCHTEC DMA co-maintainer). PCI and dmaengine maintainers were on the
original To/Cc.

**Step 4.3: SEARCH FOR THE BUG REPORT**

Record: No bugzilla/syzbot link. Cover letter: Logan originally had only
the dmaengine ID; Sashiko reminded him to add the management ID and the
NTB quirk, then he sent this 3-patch series. Hardware impact is
described in the patch, not in a separate user report.

**Step 4.4: CHECK FOR RELATED PATCHES AND SERIES**

Record: Three independent 1-line ID additions (dmaengine, switchtec
management, NTB quirk). This quirk patch is self-contained. The other
two enable management/NTB userspace and the DMA engine; they are not
required for the IOMMU alias.

**Step 4.5: CHECK STABLE MAILING LIST HISTORY**

Record: lore.kernel.org/stable search for PCI1008 returned HTTP 403. No
stable discussion in the linux-pci mbox. UNVERIFIED whether anyone
requested this on stable@ after merge.

===============================================================
PHASE 5: CODE SEMANTIC ANALYSIS
===============================================================

**Step 5.1: IDENTIFY KEY FUNCTIONS IN THE DIFF**

Record: No function body edited. New fixup entry invokes existing
`quirk_switchtec_ntb_dma_alias()`.

**Step 5.2: TRACE CALLERS**

Record: Not called in C. Registered with
`DECLARE_PCI_FIXUP_CLASS_FINAL(PCI_VENDOR_ID_EFAR, 0x1008,
PCI_CLASS_BRIDGE_OTHER, 8, ...)`. PCI core runs class FINAL fixups
during device setup, before typical driver probe. Context: boot/hotplug
enumeration, not IRQ.

**Step 5.3: TRACE CALLEES**

Record: `quirk_switchtec_ntb_dma_alias()` uses `pci_enable_device`,
`pci_iomap`, MMIO reads of NTB partition/proxy tables,
`pci_add_dma_alias()`, then unmap/disable. `pci_add_dma_alias()` sets
`dma_alias_mask` bits used to program IOMMU source IDs.

**Step 5.4: FOLLOW THE CALL CHAIN**

Record: PCI enumeration → class FINAL fixup → alias programming → IOMMU
group creation. Reachable only with PCI1008 hardware present.
Unprivileged userspace cannot trigger the quirk directly; a user of that
NTB/IOMMU path sees DMA failures if it is missing.

**Step 5.5: SEARCH FOR SIMILAR PATTERNS**

Record: Same pattern as PCI1001–PCI1006 in this file, and as many other
`pci_add_dma_alias` quirks (PLX NTB, Ricoh, Marvell, etc.). Adding
0x1008 is consistent with how every prior Switchtec/PCI100X ID was
handled.

===============================================================
PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE
===============================================================

**Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?**

Record: Yes. `drivers/pci/quirks.c` has `SWITCHTEC_PCI100X_QUIRK` for
0x1001–0x1006. Without 0x1008, a PCI1008 NTB function would not get
aliases. `a3282f84b2151` (v6.14) added the table; this tree is 7.3-rc4,
so the table is present. `git merge-base --is-ancestor 00a479ba1d012
HEAD` is true (commit is already in 7.3-rc1); that is not treated as
“already selected for stable.”

**Step 6.2: CHECK FOR BACKPORT COMPLICATIONS**

Record: Expected apply: **clean**. Context is the existing PCI100X quirk
block, unchanged except for the new line. No refactor of this table
since it was added.

**Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE**

Record: No alternate PCI1008 NTB alias fix. Companion IDs in
`switchtec.c` and `switchtec_dma.c` are the sibling series patches, not
substitutes for this quirk.

===============================================================
PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT
===============================================================

**Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY**

Record: `[PCI quirks / Switchtec NTB DMA alias] [IMPORTANT]` — not core
mm/scheduler, but PCI IOMMU correctness for NTB. Affects systems with
this Microchip switch and IOMMU enabled.

**Step 7.2: ASSESS SUBSYSTEM ACTIVITY**

Record: PCI quirks and switchtec are actively maintained (recent
pci/switchtec and pci/virtualization merges on this tree). The quirk
function itself has been stable since 2018; PCI100X IDs since v6.14.

===============================================================
PHASE 8: IMPACT AND RISK ASSESSMENT
===============================================================

**Step 8.1: DETERMINE WHO IS AFFECTED**

Record: Driver/hardware-specific: Microchip PCI1008 (vendor EFAR 0x1055,
device 0x1008) with NTB and IOMMU. Not universal.

**Step 8.2: DETERMINE THE TRIGGER CONDITIONS**

Record: Present whenever that device is enumerated with IOMMU on. Not a
race. Not triggerable by an unprivileged syscall on machines without the
hardware. Common for any PCI1008 NTB + IOMMU deployment.

**Step 8.3: DETERMINE THE FAILURE MODE SEVERITY**

Record: IOMMU rejects or mis-groups DMA from NTB proxy IDs → DMA
failures, IOMMU faults, broken peer NTB DMA. **HIGH** for that hardware;
not a generic panic.

**Step 8.4: CALCULATE RISK-BENEFIT RATIO**

Record:
- **Benefit:** HIGH for PCI1008+IOMMU users (device works correctly
  under IOMMU). Classic device-ID/quirk enablement.
- **Risk:** VERY LOW (1 line, existing macro, match is device-specific).
- **Ratio:** strongly favors backporting.

===============================================================
PHASE 9: FINAL SYNTHESIS
===============================================================

**Step 9.1: COMPILE THE EVIDENCE**

FOR:
- PCI ID / hardware quirk on an existing table (stable exception).
- Real IOMMU DMA misdirection without the alias.
- 1 line, obviously correct, same pattern as PCI1001–1006.
- Prerequisite table exists in this 7.3 tree.
- Author is switchtec maintainer; PCI maintainer applied it.
- Standalone; no API change.

AGAINST:
- No `Reported-by` / production crash log (typical for ID additions).
- Audience is PCI1008 NTB + IOMMU, not all machines.
- Unrelated pre-existing `ep_map` pointer issue in the quirk function
  (not caused by this line).
- Stable@ discussion could not be fetched (403).

UNRESOLVED:
- Whether stable@ discussed this after merge (lore.kernel.org/stable
  403).
- Whether Logan later sent an `ep_map` fix (explicitly out of scope).

**Step 9.2: APPLY THE STABLE RULES CHECKLIST**

1. Obviously correct and tested? **PASS** — one-line ID, applied by PCI
   maintainer after list review.
2. Fixes a real bug that affects users? **PASS** — PCI1008 NTB DMA under
   IOMMU is wrong without the alias.
3. Important issue? **PASS** — IOMMU DMA correctness (faults /
   misdirected DMA), HIGH for that hardware.
4. Small and contained? **PASS** — +1 line in `drivers/pci/quirks.c`.
5. No new features or APIs? **PASS** — device ID on an existing quirk;
   allowed exception.
6. Can apply to the local tree? **PASS** — `SWITCHTEC_PCI100X_QUIRK` is
   present; apply is clean.

**Step 9.3: CHECK FOR EXCEPTION CATEGORIES**

Record: **Device ID addition** and **hardware quirk/workaround** (PCI
DMA alias quirk). These are listed as YES for stable.

**Step 9.4: MAKE YOUR DECISION**

This tree has the PCI100X quirk table. Adding PCI1008 is the same class
of change already used for PCI1001–1006. Without it, PCI1008 NTB DMA can
be misdirected under an IOMMU. The patch is one line, applies cleanly,
and does not need the rest of the series.

Verification:
- [Phase 1] `git describe HEAD` → `v7.3-rc4-27-gf0100363d8c37`; `make
  kernelversion` → `7.3.0-rc4`. Tags: SOB Logan + Bjorn; Link to patch
  3/3; no Fixes/stable/Reported-by.
- [Phase 2] `git show 00a479ba1d012`: +1 line
  `SWITCHTEC_PCI100X_QUIRK(0x1008)` in `drivers/pci/quirks.c`.
- [Phase 2] Read `quirk_switchtec_ntb_dma_alias()`: enable, iomap, read
  proxy IDs, `pci_add_dma_alias()`, table_sz 0/512 guards.
- [Phase 3] `git blame -L 6087,6096`: table from `a3282f84b2151`
  (v6.14); 0x1008 from this commit.
- [Phase 3] `git merge-base --is-ancestor a3282f84b2151 v6.14` true; not
  ancestor of v6.13. Original quirk `ad281ecf1c7d4` (2018) is in HEAD.
- [Phase 3] `git merge-base --is-ancestor 00a479ba1d012 v7.2` false;
  ancestor of v7.3-rc1/rc4.
- [Phase 3] Series patches `8b326de3cc02c`, `0d8a6306c680e` are sibling
  ID adds, not prerequisites of this quirk.
- [Phase 4] `b4 dig -c 00a479ba1d012` / `-a` / `-w` / `-m`: v1-only
  3-patch series; Bjorn applied for v7.3; Vinod acked 1/3; no NAK;
  Sashiko `ep_map` note treated as unrelated.
- [Phase 4] lore.kernel.org HTTP 403/Anubis; thread recovered via b4
  mbox. stable@ search 403 — UNVERIFIED.
- [Phase 5] No C callers; `DECLARE_PCI_FIXUP_CLASS_FINAL` in
  `include/linux/pci.h`; `pci_add_dma_alias` in `drivers/pci/pci.c`.
- [Phase 6] Local `quirks.c` has PCI100X table and (in this checkout)
  the 0x1008 line. Companion IDs exist in `switchtec.c:1877` and
  `switchtec_dma.c:1426`.
- [Phase 7] PCI subsystem maintainer Bjorn Helgaas; Logan maintains
  SWITCHTEC DMA.
- [Phase 8] Failure mode: IOMMU DMA misdirection for PCI1008 NTB — HIGH
  for that hardware; patch risk very low.

The change is a one-line PCI quirk ID. That is the standard stable
exception, it is obviously correct, and this tree already has the table
it extends.

**YES**

 drivers/pci/quirks.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index e8067ff59e2a5..e03a3831bcc00 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -6045,6 +6045,7 @@ SWITCHTEC_PCI100X_QUIRK(0x1003);  /* PCI1003XG4 */
 SWITCHTEC_PCI100X_QUIRK(0x1004);  /* PCI1004XG4 */
 SWITCHTEC_PCI100X_QUIRK(0x1005);  /* PCI1005XG4 */
 SWITCHTEC_PCI100X_QUIRK(0x1006);  /* PCI1006XG4 */
+SWITCHTEC_PCI100X_QUIRK(0x1008);  /* PCI1008XG4 */
 
 
 /*
-- 
2.53.0

