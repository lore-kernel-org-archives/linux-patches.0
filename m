Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E11538422E;
	Mon, 19 Oct 2026 13:56:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418195; cv=none; b=Q9jqXHPp/yBnu5VsqFnN6aw2ivodIroPaay1T5TCg/QHYuUzcVOtES9Ln7+ibSw50XVYa2OEXPmw7HYLJanvLemLjdjWuUP90Vv8o1Rukf6DqkHp7TOmgEL8ynH7NZ4cHBvqSrMezPs8SqB0St+nJSXkpXDN0zsUgIJt4gwHv9M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418195; c=relaxed/simple;
	bh=gDuhLh3xzm1+PCur9Ea4AClzdSiOskaxCsOvp2DCZYY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=O4S2F2lDWHHW00cu3yBX3n3NWa1Qjg45GCHE17m0DZiR8W0GlY7YVo78MayectouwtzHLEmPJ3bfyjf0mH2/UU/Kl6X6a3wk890tC9pN/q2uCJHcWa9wEfukE98sWwJa1WwacAvLca0+xA9SSYiYZKtSVwSr3XhC7WFqZUex0TQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oYb/5YDK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oYb/5YDK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E61D1F000C7;
	Mon, 19 Oct 2026 13:56:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418193;
	bh=UUmqX9tSMyy7Z8P2BIsi4KqSAwSAqTXl96Wr8w+vzLI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oYb/5YDKUMouyxr+ixOxU2s72fM+J0aUCeZW8SCgWHh2zVnpW9uY3u3hIax1SiHYn
	 4UlQdOV+JuYYD+UbhTSVVIQSJCDW/gkUDoNWZ7CCfCbmh11Qi2hcxoJHRrzcQKLzQ3
	 37iACtO85NtGYwRB8/4rU2mpDE1YXo0djt3Jy1cOUxzgh9ciWoGY3Q6bo1x5cettez
	 RLll9yrhsaGiCK7Hx1fUwTiPuPhdKyQ3szViujOVeAmCIo8Sq4JmoYgW8pYo1u/8n2
	 6gITU2Udk53ETIU6TgqJnUBoCNtfmF30BiEagqKYt55iO1ErjLf+alnovLgOTNbE6g
	 AdQp++PVINrtQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Logan Gunthorpe <logang@deltatee.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>,
	kurt.schwemmer@microsemi.com,
	linux-pci@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.1] PCI: switchtec: Add Microchip PCI1008 device ID
Date: Mon, 19 Oct 2026 09:46:09 -0400
Message-ID: <20261019135441.1420968-78-sashal@kernel.org>
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

[ Upstream commit 0d8a6306c680ee534be131e360f0cafa2bada7be ]

Add the Microchip PCI1008 device ID to the core switchtec management
driver's PCI ID table. Without it, the management endpoint on a PCI1008
switch is not bound by this driver, preventing userspace tools from
configuring or monitoring the switch and leaving NTB functionality
unavailable.

Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Link: https://patch.msgid.link/20260714212010.230606-3-logang@deltatee.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

This is a one-line PCI ID addition to an existing Switchtec driver. The
local tree is **7.3.0-rc4** (`v7.3-rc4-27-gf0100363d8c37`).
`SWITCHTEC_PCI100X_DEVICE` and the PCI1001–PCI1006 IDs are already here,
so the patch is applicable.

===============================================================
PHASE 1: COMMIT MESSAGE FORENSICS
===============================================================

**Step 1.1: PARSE THE SUBJECT LINE**
Record: [PCI: switchtec] [Add] [Microchip PCI1008 device ID to the
existing switchtec management driver’s PCI ID table]

**Step 1.2: PARSE ALL COMMIT MESSAGE TAGS**
Record:
- Signed-off-by: Logan Gunthorpe <logang@deltatee.com> (author; listed
  maintainer of PCI DRIVER FOR MICROSEMI SWITCHTEC)
- Signed-off-by: Bjorn Helgaas <bhelgaas@google.com> (PCI maintainer)
- Link:
  https://patch.msgid.link/20260714212010.230606-3-logang@deltatee.com
- No Fixes: tag (expected)
- No Reported-by / Tested-by / Reviewed-by / Acked-by / Cc: stable on
  this commit
- Ignore any Sasha Levin SOB (none on the real commit)

**Step 1.3: ANALYZE THE COMMIT BODY TEXT**
Record:
- Bug: PCI1008 management endpoint is not bound because 0x1008 is
  missing from `switchtec_pci_tbl`.
- Symptom: userspace cannot configure/monitor the switch via
  `/dev/switchtecX`; NTB is unavailable (probe requests
  `ntb_hw_switchtec` only after this driver binds).
- Version info: series was based on v7.2-rc3; applied by Helgaas for
  v7.3.
- Root cause: incomplete ID table for a new PCI100x SKU, not a logic
  bug.

**Step 1.4: DETECT HIDDEN BUG FIXES**
Record: Not a hidden cleanup. It is an explicit device-ID enablement.
Stable rules treat “just add a device ID” as an accepted class.

===============================================================
PHASE 2: DIFF ANALYSIS
===============================================================

**Step 2.1: INVENTORY THE CHANGES**
Record:
- File: `drivers/pci/switch/switchtec.c` (+1 / −0)
- Function/data: `switchtec_pci_tbl[]` (static PCI ID table)
- Scope: single-file, one-line surgical change

**Step 2.2: UNDERSTAND THE CODE FLOW CHANGE**
Record:
- Before: PCI1001–PCI1006 (vendor `PCI_VENDOR_ID_EFAR` / 0x1055) match
  via `SWITCHTEC_PCI100X_DEVICE`; 0x1008 does not.
- After: 0x1008 matches the same way as 0x1001–0x1006, with `driver_data
  = SWITCHTEC_GEN4`.
- Path: PCI enumeration → `pci_driver.id_table` match →
  `switchtec_pci_probe()`.

**Step 2.3: IDENTIFY THE BUG MECHANISM**
Record:
- Category: hardware enablement / device ID addition
- Mechanism: without the ID, the management function is unbound. Probe
  also does `request_module_nowait("ntb_hw_switchtec")` for
  `PCI_CLASS_BRIDGE_OTHER`, so NTB never attaches.

**Step 2.4: ASSESS THE FIX QUALITY**
Record:
- Obviously correct: same macro and generation as sibling PCI100x IDs.
- Minimal: one table line, no API/behavior change for other devices.
- Regression risk: very low; only PCI1008 (vendor 0x1055, device 0x1008)
  is newly bound.
- Red flags: none.

===============================================================
PHASE 3: GIT HISTORY INVESTIGATION
===============================================================

**Step 3.1: BLAME THE CHANGED LINES**
Record:
- PCI1001–PCI1006: `a3282f84b2151` (“PCI: switchtec: Add Microchip
  PCI100X device IDs”, 2025-01-20), first described as
  `v6.13-rc1-1-ga3282f84b2151`.
- Sentinel `{0}`: original driver from 2017 (`080b47def5e5e2`).
- PCI1008 line: this commit `0d8a6306c680e`.

**Step 3.2: FOLLOW THE FIXES: TAG**
Record: No Fixes: tag. Not applicable.

**Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES**
Record:
- `a3282f84b2151` added the PCI100X macro, IDs 0x1001–0x1006, and
  matching `SWITCHTEC_PCI100X_QUIRK` entries.
- Series companions (same author/date):
  - `8b326de3cc02c` dmaengine: switchtec-dma: Add PCI1008 device ID
    (msgid -2)
  - `00a479ba1d012` PCI: switchtec: Add Microchip PCI1008 to NTB DMA
    alias quirk (msgid -4)
- This commit is standalone for the management driver. The quirk is
  needed for NTB DMA under IOMMU; DMA ID is a different PCI function.

**Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS**
Record: Logan Gunthorpe is a listed maintainer (`MAINTAINERS`: PCI
DRIVER FOR MICROSEMI SWITCHTEC). He authored the original switchtec
driver and this ID series.

**Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS**
Record:
- Needs `SWITCHTEC_PCI100X_DEVICE` and `SWITCHTEC_GEN4` — both present
  here.
- Does not need the dmaengine or quirk commits to compile or bind the
  management device.
- Applies standalone.

===============================================================
PHASE 4: MAILING LIST AND EXTERNAL RESEARCH
===============================================================

**Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION**
Record:
- `b4 dig -c 0d8a6306c680e`:
  https://patch.msgid.link/20260714212010.230606-3-logang@deltatee.com
- Series: v1 only, `[PATCH v1 0/3] switchtec: add new device IDs`
  (2026-07-14)
- Cover: IDs for PCI driver, DMA driver, and NTB quirk; based on
  v7.2-rc3; intended for the PCI tree
- Sashiko: “found no issues” on this patch
- Bjorn Helgaas (2026-07-17): “Applied to pci/switchtec for v7.3,
  thanks!”
- No NAKs. Unrelated Sashiko note on `quirk_switchtec_ntb_dma_alias()`
  pointer arithmetic was explicitly not a blocker.
- No Cc: stable in the thread.

**Step 4.2: CHECK WHO REVIEWED THE PATCH**
Record (`b4 dig -w`):
- To: linux-pci, dmaengine, Vinod Koul, Bjorn Helgaas
- Cc: Frank Li, Kelvin Cao (Microchip)
- Vinod Acked-by on the dmaengine ID
- PCI maintainer applied the series

**Step 4.3: SEARCH FOR THE BUG REPORT**
Record: No bugzilla/syzbot. Author is the subsystem maintainer adding a
new SKU. Cover letter says Sashiko reminded him the management ID and
NTB quirk were also required.

**Step 4.4: CHECK FOR RELATED PATCHES AND SERIES**
Record: 3 independent one-line ID/quirk additions. This patch is 2/3 and
self-contained. Companion quirk is valuable for PCI1008 NTB+IOMMU but is
a separate candidate.

**Step 4.5: CHECK STABLE MAILING LIST HISTORY**
Record: lore.kernel.org/stable search returned HTTP 403. Thread mbox has
no “stable” mentions. UNVERIFIED: whether -stable already discussed this
ID.

===============================================================
PHASE 5: CODE SEMANTIC ANALYSIS
===============================================================

**Step 5.1: IDENTIFY KEY FUNCTIONS**
Record: No function body changed. Data: `switchtec_pci_tbl[]`.
Consumers: `switchtec_pci_driver.id_table`, `MODULE_DEVICE_TABLE(pci,
...)`. Probe: `switchtec_pci_probe()`.

**Step 5.2: TRACE CALLERS**
Record: PCI core matches `id_table` at enumeration/hotplug. Probe
creates `/dev/switchtecX`, enables MRPC, and may load
`ntb_hw_switchtec`. NTB uses `class_interface` on `switchtec_class` (no
second PCI ID table).

**Step 5.3: TRACE CALLEES**
Record: Probe calls `stdev_create`, `switchtec_init_pci`,
`switchtec_init_isr`, `cdev_device_add`. Existing paths; ID only selects
them for this device.

**Step 5.4: FOLLOW THE CALL CHAIN**
Record: Reachable when a PCI1008 is present (`CONFIG_PCI_SW_SWITCHTEC`).
Unprivileged users do not enumerate PCI IDs; impact is hardware owners
of this switch.

**Step 5.5: SEARCH FOR SIMILAR PATTERNS**
Record: Same family already lists 0x1001–0x1006. DMA driver has 0x1008.
`quirks.c` has `SWITCHTEC_PCI100X_QUIRK(0x1008)` from the companion
commit.

===============================================================
PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE
===============================================================

**Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?**
Record: Yes. `drivers/pci/switch/switchtec.c` has
`SWITCHTEC_PCI100X_DEVICE` and PCI1001–PCI1006. Without 0x1008, PCI1008
would not bind. Prerequisite `a3282f84b2151` is an ancestor (`git merge-
base --is-ancestor` succeeded). PCI100X support dates to v6.13-rc1.

**Step 6.2: CHECK FOR BACKPORT COMPLICATIONS**
Record: Clean apply. Adjacent lines are the existing PCI100x block. No
refactor conflicts in this checkout.

**Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE**
Record: No alternate PCI1008 ID in switchtec.c besides this line.
Companion DMA ID and NTB quirk are also present here as separate
commits.

===============================================================
PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT
===============================================================

**Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY**
Record: [PCI switch management driver `drivers/pci/switch/`] [PERIPHERAL
— specific Microchip/Microsemi Switchtec hardware; NTB/management users]

**Step 7.2: ASSESS SUBSYSTEM ACTIVITY**
Record: Mature (driver since 2017). Recent work is mostly new IDs (Gen5,
Gen6, PCI100x). Typical stable ID-table churn.

===============================================================
PHASE 8: IMPACT AND RISK ASSESSMENT
===============================================================

**Step 8.1: DETERMINE WHO IS AFFECTED**
Record: Driver-specific / config-specific (`CONFIG_PCI_SW_SWITCHTEC`).
Only PCI1008 (0x1055:0x1008). Other Switchtec IDs unchanged.

**Step 8.2: DETERMINE THE TRIGGER CONDITIONS**
Record: Trigger is plugging/booting with a PCI1008. Common for that
hardware; impossible otherwise. Not a userspace-triggerable crash.

**Step 8.3: DETERMINE THE FAILURE MODE SEVERITY**
Record: Device not bound → no `/dev/switchtecX`, no NTB. Severity MEDIUM
for those systems (hardware unusable for management/NTB), LOW for
everyone else. Not a panic/UAF.

**Step 8.4: CALCULATE RISK-BENEFIT RATIO**
Record:
- Benefit: high for PCI1008 owners (management + NTB enablement);
  documented stable exception.
- Risk: very low (one ID line, existing macro).
- Ratio: strongly favors backport.

===============================================================
PHASE 9: FINAL SYNTHESIS
===============================================================

**Step 9.1: COMPILE THE EVIDENCE**

FOR:
- Stable rules: “fix a real bug … or just add a device ID”
  (`Documentation/process/stable-kernel-rules.rst`).
- Existing driver + PCI100X macro in this tree.
- One line, same pattern as PCI1001–PCI1006.
- Maintainer-authored, PCI maintainer applied, no NAKs.
- Real user impact: management chardev and NTB never attach without the
  ID.

AGAINST:
- Not a crash/security fix; new SKU enablement only.
- Affects a niche PCIe switch.
- Companion quirk is a separate patch (NTB DMA under IOMMU still
  incomplete without it). That does not make this ID wrong or unsafe.

UNRESOLVED:
- lore.kernel.org HTTP 403; stable@ discussion not verified beyond the
  saved thread (no “stable” hits there).

**Step 9.2: APPLY THE STABLE RULES CHECKLIST**
1. Obviously correct and tested? **PASS** — identical to existing
   PCI100x entries; applied by PCI maintainer.
2. Fixes a real bug that affects users? **PASS** — PCI1008 otherwise
   unbound (or qualifies as a device ID addition).
3. Important issue? **PASS** under the device-ID exception (not a
   panic).
4. Small and contained? **PASS** — +1 line, one file.
5. No new features or APIs? **PASS** — ID only; no new ioctls/sysfs.
6. Can apply to the local tree? **PASS** — `SWITCHTEC_PCI100X_DEVICE`
   and sibling IDs present.

**Step 9.3: CHECK FOR EXCEPTION CATEGORIES**
Record: Device ID addition to an existing driver.

**Step 9.4: DECISION**
This is the standard stable device-ID case. The driver and PCI100x
helper exist in this tree, the change is one table line, and without it
PCI1008 management/NTB never bind. Risk is negligible.

The companion NTB DMA alias quirk is a separate one-line candidate; this
ID patch does not depend on it.

Verification:
- [Phase 1] Parsed tags: Logan Gunthorpe SOB, Bjorn Helgaas SOB, lore
  Link; no Fixes/Reported-by/Cc: stable
- [Phase 1] `git describe HEAD` / Makefile: local tree is 7.3.0-rc4
  (`v7.3-rc4-27-gf0100363d8c37`)
- [Phase 2] Diff: +1 line in `switchtec_pci_tbl[]` —
  `SWITCHTEC_PCI100X_DEVICE(0x1008, SWITCHTEC_GEN4)`
- [Phase 2] Confirmed probe uses `id_table` and requests
  `ntb_hw_switchtec` for bridge class
- [Phase 3] `git blame`: PCI1001–1006 from `a3282f84b2151` (v6.13-rc1);
  PCI1008 from `0d8a6306c680e`
- [Phase 3] `git merge-base --is-ancestor a3282f84b2151 HEAD` succeeded
- [Phase 3] Series companions: `8b326de3cc02c` (DMA ID), `00a479ba1d012`
  (NTB quirk)
- [Phase 4] `b4 dig -c 0d8a6306c680e`: lore URL found; v1-only 3-patch
  series
- [Phase 4] `b4 dig -w`: linux-pci, Bjorn Helgaas, Vinod Koul, Microchip
  Cc
- [Phase 4] mbox: Helgaas applied for v7.3; Sashiko clean on this patch;
  Vinod Acked DMA ID; no NAK
- [Phase 4] UNVERIFIED: stable@ mailing list (lore HTTP 403)
- [Phase 5] NTB binds via `switchtec_class` class_interface; this ID is
  required for NTB attach
- [Phase 6] File in tree has PCI100x macro and IDs; patch applies
  cleanly
- [Phase 7] Maintainer entry: Logan Gunthorpe for Switchtec
- [Phase 8] Failure: device unbound, not a kernel crash; device-ID
  exception applies
- [Phase 9] stable-kernel-rules.rst line 15 explicitly allows device ID
  additions

**YES**

 drivers/pci/switch/switchtec.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/pci/switch/switchtec.c b/drivers/pci/switch/switchtec.c
index f32ddfa79da99..30566c2d9f806 100644
--- a/drivers/pci/switch/switchtec.c
+++ b/drivers/pci/switch/switchtec.c
@@ -1874,6 +1874,7 @@ static const struct pci_device_id switchtec_pci_tbl[] = {
 	SWITCHTEC_PCI100X_DEVICE(0x1004, SWITCHTEC_GEN4),  /* PCI1004 16XG4 */
 	SWITCHTEC_PCI100X_DEVICE(0x1005, SWITCHTEC_GEN4),  /* PCI1005 16XG4 */
 	SWITCHTEC_PCI100X_DEVICE(0x1006, SWITCHTEC_GEN4),  /* PCI1006 16XG4 */
+	SWITCHTEC_PCI100X_DEVICE(0x1008, SWITCHTEC_GEN4),  /* PCI1008 16XG4 */
 	{0}
 };
 MODULE_DEVICE_TABLE(pci, switchtec_pci_tbl);
-- 
2.53.0

