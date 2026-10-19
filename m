Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46DA45605EA;
	Mon, 19 Oct 2026 13:57:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418247; cv=none; b=CFdQ9pal8EgRIhsMzs42WvKKO/CMHZp2J109P3ZBsFMlUMm9pvJReVhpu/GR7EmkCcC+z9YdVWcFN85rh+x8Ww0j7iBhUoeSubY6JvSWBW6IL3Wc5L5wIYwfb9gZLw/ElzWlaGrD8myA8mUvsV3wIjl+vmGHteaun8IMD21BEzg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418247; c=relaxed/simple;
	bh=+bycS3FNwOEP9aBvLSskjl2fWeKQasweKMhsK2k/Dzw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bMw7d/Qq6xDU4R3ZZyHaeQMDHoe49cPE3BtFUCUSrcf0pEb4Akj7Vks06Z/bX0zAfdP6JYa3JAEgbHSx4N7Eu6ZVVjlwjSN5BqqjAgFUGDiiEbtKFlfds7Bezxz8FsUzSuDYd/NgU7XD+XkV5IGBY5Koqv5ZY/6BdF4yoHaF0fs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RYxJ2HuE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RYxJ2HuE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDB281F000C7;
	Mon, 19 Oct 2026 13:57:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418245;
	bh=e/tPNI9hFvJMP9o9Nrl76+6LDOslBsYJqg1tlFuCZCQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RYxJ2HuE/rAvej/yjrQja6JYLqSAZ4JW04Rwd4pdHny+EqP4eyB9a9tcSCV26GFqv
	 gINTfAqjvymgl/d7/7dE8qXol1VgZQddoarwbKufQEO8r8mZJQJRcU+OxYRR+sAgLS
	 AlSvQIDoHnPl27j3KvfyouAiAYtBm/Jn+ltJL2hcfYl1mOjiEg7nFOHBl9d/uU/ZKd
	 YXOzDFFRBIpYbzFCkKQCBDTYqt5zYcbWxqDe45WrF6eKSkg2UkcoWLDYMawKR+yIWG
	 wcy0j/C7enYTiw7XYai9n2925gVzTRp71qKKtWzWp9WfJG07tt8zZG21G+BzOrVi7M
	 zbAL5iRq7SS5w==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Szymon Durawa <szymon.durawa@linux.intel.com>,
	Nirmal Patel <nirmal.patel@linux.intel.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Jonathan Derrick <jonathan.derrick@linux.dev>,
	Sasha Levin <sashal@kernel.org>,
	lpieralisi@kernel.org,
	kwilczynski@kernel.org,
	mani@kernel.org,
	linux-pci@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] PCI: vmd: Add Nova Lake (NVL) and Dunlow (DNL) Device IDs
Date: Mon, 19 Oct 2026 09:46:46 -0400
Message-ID: <20261019135441.1420968-115-sashal@kernel.org>
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

From: Szymon Durawa <szymon.durawa@linux.intel.com>

[ Upstream commit 55aa45154fe48b7d8e96bc031ad27d5b0edfcdb8 ]

Add VMD Device ID Support for Intel NVL/DNL processors.

Suggested-by: Nirmal Patel <nirmal.patel@linux.intel.com>
Signed-off-by: Szymon Durawa <szymon.durawa@linux.intel.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Cc: Nirmal Patel <nirmal.patel@linux.intel.com>
Cc: Jonathan Derrick <jonathan.derrick@linux.dev>
Link: https://patch.msgid.link/20260819130523.398493-1-szymon.durawa@linux.intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

This tree is **6.12.111** (`p-6.12-3-gc504cf0baa3d8`). The commit is a
PCI ID table update for the existing Intel VMD driver, and that driver
plus `VMD_FEATS_CLIENT` are already here.

===============================================================
PHASE 1: COMMIT MESSAGE FORENSICS
===============================================================

**Step 1.1:** Record: `[PCI: vmd] [Add] Add Nova Lake (NVL) and Dunlow
(DNL) Device IDs`

**Step 1.2:** Tags (ignoring pipeline `Signed-off-by: Sasha Levin` /
`[Upstream commit ...]`):
- Suggested-by: Nirmal Patel (Intel VMD maintainer)
- Signed-off-by: Szymon Durawa (author, Intel)
- Signed-off-by: Bjorn Helgaas (PCI maintainer; applied it)
- Cc: Nirmal Patel, Jonathan Derrick
- Link: https://patch.msgid.link/20260819130523.398493-1-
  szymon.durawa@linux.intel.com
- No Fixes:, Reported-by, Tested-by, Reviewed-by in the committed
  message (Reviewed-by: Nirmal Patel was given on v1 but not copied into
  the commit)
- No Cc: stable (expected for this review)

**Step 1.3:** Record: Bug description: none as a crash/leak. The body is
one sentence: add VMD Device IDs for Intel NVL/DNL. Failure mode without
the patch: `vmd` does not bind to 8086:d70b / 8086:d73b, so NVMe/PCIe
devices under Intel RST/VMD stay hidden. No version range in the
message. Root cause: missing PCI IDs in `vmd_ids[]`.

**Step 1.4:** Record: Not a hidden bug fix. It is a hardware-ID
enablement patch, which is an explicit stable exception.

===============================================================
PHASE 2: DIFF ANALYSIS
===============================================================

**Step 2.1:** Record: `drivers/pci/controller/vmd.c` only; +4 / -0.
Function/data: `vmd_ids[]`. Scope: single-file surgical ID add.

**Step 2.2:** Record: Before: table ends at 0xb07f (mainline) / 0xb06f
(this 6.12 tree). After: 0xd70b and 0xd73b appended with `.driver_data =
VMD_FEATS_CLIENT`. Probe path for those IDs then runs `vmd_probe()` →
`vmd_enable_domain()`.

**Step 2.3:** Record: Category **h) hardware workarounds / device ID
additions**. Mechanism: PCI core matches the ID table; without the
entries the driver never probes.

**Step 2.4:** Record: Obviously correct; same pattern as existing client
SKUs (0x7d0b, 0xad0b, 0xb60b, 0xb06f). No locking/API/data-structure
change. Regression risk is very low: only systems with those two IDs are
affected, and they currently have no VMD driver at all.

===============================================================
PHASE 3: GIT HISTORY INVESTIGATION
===============================================================

**Step 3.1:** Record: `vmd_ids[]` dates to 2016 (`185a383ada2e`).
`VMD_FEATS_CLIENT` grouping is `14d2079af6483` (2023, in this tree).
Last IDs in this tree are 0xb60b/0xb06f from `34883c93bd330` (already
backported to 6.12.y). 0xd70b/0xd73b are absent here. 0xb07f is in the
parent context of the mainline commit but **not** in this tree; it is a
sibling ID, not a functional prerequisite.

**Step 3.2:** Record: No Fixes: tag. Not applicable.

**Step 3.3:** Record: Same-file history includes several prior DID adds
that followed this exact pattern:
- `57a128acaba02` PCI: vmd: Add DID 8086:7D0B and 8086:AD0B for Intel
  MTL SKUs
- `34883c93bd330` PCI: vmd: Add DID 8086:B06F and 8086:B60B for Intel
  client SKUs (already in this 6.12 tree)
Standalone; not patch X/Y of a series that this commit depends on.

**Step 3.4:** Record: Author Szymon Durawa has no other VMD commits in
this tree. Suggested/reviewed by Nirmal Patel, who authored the previous
client DID add in this file.

**Step 3.5:** Record: Uses existing `PCI_VDEVICE` and
`VMD_FEATS_CLIENT`. Does not use later v7.3 features
(`VMD_FEAT_USE_BIOS_INFO`, BUS_RESTRICT_CFG=3). Those other v7.3 VMD
patches target different IDs (0x28C1 / Arrow Lake-HX). Can apply
standalone.

===============================================================
PHASE 4: MAILING LIST AND EXTERNAL RESEARCH
===============================================================

**Step 4.1:** Record: Mainline SHA
`55aa45154fe48b7d8e96bc031ad27d5b0edfcdb8` (not an ancestor of this
HEAD).
- b4 dig: https://patch.msgid.link/20260819130523.398493-1-
  szymon.durawa@linux.intel.com
- v1: 2026-07-08 (duplicate subject, missing CCs)
- v2: 2026-07-29 (CCs added)
- v3: 2026-08-19 (description added) — this is what was applied
- No NAKs. Manivannan asked for a changelog body and full maintainer CC.
  Nirmal Patel Reviewed-by on v1. Bjorn: “Applied to pci/controller/vmd
  for v7.3”. No reviewer asked for Cc: stable.

**Step 4.2:** Record: Recipients included linux-pci, Bjorn Helgaas,
Nirmal Patel, Jonathan Derrick, Dan Williams, Lukas Wunner, Lorenzo
Pieralisi, Krzysztof Wilczyński, Manivannan Sadhasivam, Rob Herring.
Right maintainers were on the thread by v2/v3.

**Step 4.3:** Record: No syzbot/bugzilla report. This is Intel
enablement, not a fuzzer crash.

**Step 4.4:** Record: Standalone 1-patch series. Same v7.3 VMD merge
also had BIOS-info / BUS_RESTRICT_CFG=3 / _OSC patches; this ID add does
not depend on them.

**Step 4.5:** Record: No stable-list discussion found
(lore.kernel.org/stable returned 403; web search did not show a stable
thread for this subject). Absence is not a negative signal.

===============================================================
PHASE 5: CODE SEMANTIC ANALYSIS
===============================================================

**Step 5.1:** Record: Modified `vmd_ids[]` only. Consumers:
`vmd_drv.id_table` → PCI core → `vmd_probe()`.

**Step 5.2:** Record: Callers of `vmd_probe()`: PCI bus match on VMD
devices. Context: driver probe during enumeration (boot / module load),
not IRQ/hot path. Impact surface: only 8086:d70b and 8086:d73b.

**Step 5.3:** Record: `vmd_probe()` uses `id->driver_data` as feature
flags, then `vmd_enable_domain()`. `VMD_FEATS_CLIENT` already includes
membar shadow VSCAP, bus restrictions, first-vector offset, BIOS PM
quirk.

**Step 5.4:** Record: Reachable whenever firmware presents those PCI IDs
(Intel RST/VMD mode on NVL/DNL). Userspace cannot invent the IDs;
missing IDs mean missing NVMe.

**Step 5.5:** Record: Same pattern as every recent client VMD DID add.
`34883c93bd330` is the direct precedent already in this tree.

===============================================================
PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE
===============================================================

**Step 6.1:** Record: VMD driver exists (`drivers/pci/controller/vmd.c`,
`CONFIG_VMD`). `VMD_FEATS_CLIENT` exists at lines 83–86. Current table
ends at 0xb06f (lines 1109–1132). 0xd70b and 0xd73b are **not** present.
Hardware is new; the *driver* has been here for years.

**Step 6.2:** Record: Backport difficulty: **minor context tweak**. Hunk
context mentions 0xb07f, which this tree lacks. Insert the two entries
after 0xb06f. No semantic rework.

**Step 6.3:** Record: No equivalent NVL/DNL IDs already here. `git
merge-base --is-ancestor 55aa45154fe48b7d8e96bc031ad27d5b0edfcdb8 HEAD`
failed (not in this tree).

===============================================================
PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT
===============================================================

**Step 7.1:** Record: Subsystem PCI host controller / Intel VMD.
Criticality: **IMPORTANT** for Intel client systems using RST/VMD
(common laptop default); not core mm/fs, but storage disappearance is
user-visible.

**Step 7.2:** Record: Mature driver (since ~2016). Recent 6.12 VMD work
is bugfixes plus prior DID adds. This is the same mature ID-table
pattern.

===============================================================
PHASE 8: IMPACT AND RISK ASSESSMENT
===============================================================

**Step 8.1:** Record: Affected users: Intel Nova Lake / Dunlow systems
with VMD enabled (`CONFIG_VMD`, x86_64). Not universal.

**Step 8.2:** Record: Trigger: boot/enumeration on that hardware. Common
on those SKUs if BIOS leaves RST/VMD on. Not a race; not unprivileged-
exploit.

**Step 8.3:** Record: Failure mode: VMD and child NVMe never bind →
missing system/data disks. Severity: **HIGH** for those platforms
(storage unavailable), not a kernel oops.

**Step 8.4:** Record: Benefit high for NVL/DNL on 6.12.y (LTS still
receiving updates at 6.12.111). Risk very low: 4 lines, existing flags,
existing probe path. Precedent: 0xb06f/0xb60b already backported here.

===============================================================
PHASE 9: FINAL SYNTHESIS
===============================================================

**Step 9.1:** FOR:
- Stable exception: PCI ID add to an existing driver
- Driver, `VMD_FEATS_CLIENT`, and probe path all present in 6.12.111
- Same pattern already backported (`34883c93bd330`)
- 4 lines, no new APIs, no new features beyond matching two IDs
- Suggested/reviewed by VMD maintainer; applied by PCI maintainer
- Without it, NVMe behind VMD is invisible on those CPUs

AGAINST:
- Not a crash/UAF/security fix
- Context mentions 0xb07f, absent here (trivial adjust)
- NVL/DNL are newer than 6.12’s original release; other platform bits
  may still be missing on a given machine — but that is true of every
  DID backport and is not a reason to omit the IDs

UNRESOLVED:
- Could not read lore.kernel.org/stable (403). No evidence of a
  deliberate stable skip.

**Step 9.2:** Stable rules:
1. Obviously correct and tested? **PASS** (standard ID table; maintainer
   review + applied)
2. Fixes a real bug that affects users? **PASS** (devices never bind
   without the IDs)
3. Important issue? **PASS** under the device-ID exception; storage non-
   enumeration is serious for affected hardware
4. Small and contained? **PASS** (4 lines, one table)
5. No new features or APIs? **PASS** (IDs only; existing feature flags)
6. Can apply to this tree? **PASS** (minor context conflict only)

**Step 9.3:** Record: Exception category: **NEW DEVICE IDs** on an
existing driver.

**Step 9.4:** Backport. The local tree has the driver and the client
feature set; this is the same class of change already taken for earlier
Intel client VMD IDs.

Verification:
- [Phase 1] Parsed tags: Suggested-by Nirmal Patel; SOB Durawa +
  Helgaas; Link msgid 20260819130523.398493-1; no Fixes/syzbot
- [Phase 2] Diff: +4 lines in `vmd_ids[]` for 0xd70b and 0xd73b with
  `VMD_FEATS_CLIENT`
- [Phase 3] blame: table from 2016; `VMD_FEATS_CLIENT` from
  `14d2079af6483` (in tree); last IDs `34883c93bd330` (in tree)
- [Phase 3] No Fixes: tag
- [Phase 3] `git merge-base --is-ancestor
  55aa45154fe48b7d8e96bc031ad27d5b0edfcdb8 HEAD` → not in this tree
- [Phase 4] `b4 dig -c 55aa45154fe48b7d8e96bc031ad27d5b0edfcdb8`:
  matched v1/v2/v3; v3 applied
- [Phase 4] `b4 dig -w`: linux-pci + Helgaas + Patel on original To/Cc
- [Phase 4] v1 mbox: Manivannan requested description/CCs; Nirmal Patel
  Reviewed-by; no NAK
- [Phase 4] v3 mbox: Helgaas applied for v7.3
- [Phase 4] lore.kernel.org/stable fetch: 403, UNVERIFIED whether it was
  discussed on stable@
- [Phase 5] `vmd_probe()` reads `id->driver_data`; `CONFIG_VMD` in
  `drivers/pci/controller/Kconfig`
- [Phase 6] `git describe HEAD` / Makefile: 6.12.111; IDs
  0xd70b/0xd73b/0xb07f absent from local `vmd.c`
- [Phase 6] `VMD_FEATS_CLIENT` present at lines 83–86 of local `vmd.c`
- [Phase 8] Failure mode: VMD/NVMe not enumerated on NVL/DNL, not a
  panic

This is a four-line PCI ID addition to a driver that already exists in
6.12.y, using feature flags already used by other client SKUs. That is
exactly the stable device-ID exception.

**YES**

 drivers/pci/controller/vmd.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/pci/controller/vmd.c b/drivers/pci/controller/vmd.c
index 5d3e6cc7e4feb..aa6d4f56f612a 100644
--- a/drivers/pci/controller/vmd.c
+++ b/drivers/pci/controller/vmd.c
@@ -1141,6 +1141,10 @@ static const struct pci_device_id vmd_ids[] = {
                 .driver_data = VMD_FEATS_CLIENT,},
 	{PCI_VDEVICE(INTEL, 0xb07f),
                 .driver_data = VMD_FEATS_CLIENT,},
+	{PCI_VDEVICE(INTEL, 0xd70b),
+		.driver_data = VMD_FEATS_CLIENT,},
+	{PCI_VDEVICE(INTEL, 0xd73b),
+		.driver_data = VMD_FEATS_CLIENT,},
 	{0,}
 };
 MODULE_DEVICE_TABLE(pci, vmd_ids);
-- 
2.53.0

