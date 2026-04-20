Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 306133FB05C;
	Mon, 20 Apr 2026 13:26:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776691578; cv=none; b=uYKch381sm7p325bM1jtJYKvXirg7UqokQODwYW9ZknaOSo5EpIQhdkLUQCmznvI+vN8mMu4m4fk3ghtQtn4IDwLUJRn2ZCXXHM5rcTGBAaT1Wk+j/m1DBwHEvctKhspJy31Z6PbYt7pttgoBAByfG8oX1Ailqc0t2JpBEntmaU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776691578; c=relaxed/simple;
	bh=oOmee+wIhKh6TyIF5+Mcfap836l1ShgVtk6iNOcZlmY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SHmbdf8eJPI+5bJpOJNNFFc9dTOn6qry18ulT8SnMRxmR5LKV8temFxOF4kTjqmzFtRwMMhM4tzIpDa7qL30uLGBnsOZTZv+BfRchLO86+m4yexVN3ZIVOm4xQfwzFRaHkTcwKTfc2DFLGsogYC1TYzrmUdrk+ZnxoJz1nfdkwI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=b/dphhiM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="b/dphhiM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8453FC2BCB4;
	Mon, 20 Apr 2026 13:26:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776691577;
	bh=oOmee+wIhKh6TyIF5+Mcfap836l1ShgVtk6iNOcZlmY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b/dphhiMbQrLObYh/wZv12CVXkeVTwGykQQJD9ndEJ4pweDeTuSI/g35E1z1S6hq7
	 D4ZbdCrJfgWG8bxy76KG/fGj/AyGRj8WnbjYhlti8rabXEvNn14K0tNifQ0X71BswU
	 DyB2/KLlzT9gisgUTLilFVzpUx0hD5it9r37HzoveD2UKRJBbmWGzdbEVDiyy6jpqX
	 kHm2SI/i0fiWi3J1i5bQjopCgizjXCsqnbGFtkcLgLdteEwxiItEbGGFH6MapoLFpd
	 tdoXP0iDByZDee+izQkpc4fiVwa67vE29gB6L4kY7PYZ1OSriaUPQybpSZmwhiwwje
	 vmhgLa805saww==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Lizhi Hou <lizhi.hou@amd.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>,
	linux-pci@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0-5.10] PCI: Avoid FLR for AMD NPU device
Date: Mon, 20 Apr 2026 09:18:25 -0400
Message-ID: <20260420132314.1023554-111-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420132314.1023554-1-sashal@kernel.org>
References: <20260420132314.1023554-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 7.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Lizhi Hou <lizhi.hou@amd.com>

[ Upstream commit 806140e9a33218f22188fe5019c7874aa78d81f8 ]

The AMD NPU device (PCI Device IDs 0x1502 and 0x17f0) advertises FLR
support. However, triggering an FLR causes the device to hang.

Signed-off-by: Lizhi Hou <lizhi.hou@amd.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Link: https://patch.msgid.link/20260226182545.3057330-1-lizhi.hou@amd.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Here is the complete analysis:

---

## PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1: Subject Line**
- Subsystem: `PCI`
- Action verb: "Avoid" (indicating a workaround for broken hardware
  behavior)
- Summary: Prevent FLR (Function Level Reset) on AMD NPU device IDs
  0x1502 and 0x17f0 because it causes device hang.

Record: [PCI] [Avoid] [Disable FLR on AMD NPU that hangs when FLR
triggered]

**Step 1.2: Tags**
- `Signed-off-by: Lizhi Hou <lizhi.hou@amd.com>` — author, AMD developer
  working on AMD XDNA/NPU accelerator driver
- `Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>` — PCI subsystem
  maintainer applied the patch
- `Link:
  https://patch.msgid.link/20260226182545.3057330-1-lizhi.hou@amd.com` —
  original submission
- No Fixes: tag (expected — this is a new quirk addition, not a code
  fix)
- No Cc: stable tag (expected — that's why we're reviewing)

Record: Author is AMD NPU developer. PCI subsystem maintainer (Bjorn
Helgaas) applied it personally. No syzbot involvement (this is a
hardware bug, not a software bug).

**Step 1.3: Commit Body**
The message is concise: AMD NPU devices with PCI Device IDs 0x1502 and
0x17f0 advertise FLR support, but triggering FLR causes the device to
hang. This is a hardware defect — the device's FLR capability
advertisement is incorrect.

Record: Bug = device hang on FLR. Symptom = device becomes unresponsive.
Root cause = hardware defect in AMD NPU silicon.

**Step 1.4: Hidden Bug Fix Detection**
This is not a "hidden" fix — it's an explicit hardware workaround. The
commit clearly states the problem (device hang) and the solution (avoid
FLR).

Record: Not a hidden bug fix; explicit hardware quirk/workaround.

---

## PHASE 2: DIFF ANALYSIS

**Step 2.1: Inventory**
- Single file modified: `drivers/pci/quirks.c`
- 3 lines added:
  1. Comment line in the block comment listing affected devices: `* AMD
     Neural Processing Unit 0x1502 0x17f0`
  2. `DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_AMD, 0x1502, quirk_no_flr);`
  3. `DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_AMD, 0x17f0, quirk_no_flr);`
- 0 lines removed
- Function affected: none modified; new entries use existing
  `quirk_no_flr()` function

Record: +3 lines, 0 removals, 1 file. Scope: trivial device ID addition
to existing quirk table.

**Step 2.2: Code Flow Change**
Before: AMD NPU devices (0x1502, 0x17f0) are not in the quirk table, so
`quirk_no_flr` is not called for them. When FLR is attempted via
`pcie_reset_flr()` or `pci_af_flr()`, the `PCI_DEV_FLAGS_NO_FLR_RESET`
flag is not set, and FLR proceeds — causing device hang.

After: During PCI early fixups, `quirk_no_flr()` sets the
`PCI_DEV_FLAGS_NO_FLR_RESET` flag on these devices. When FLR is later
attempted, `pcie_reset_flr()` (line 4375) and `pci_af_flr()` (line 4398)
check this flag and return `-ENOTTY` instead, preventing the hang.

Record: [Before: FLR triggers and hangs device] → [After: FLR is
blocked, device remains functional]

**Step 2.3: Bug Mechanism**
Category: Hardware workaround (PCI quirk).
The `DECLARE_PCI_FIXUP_EARLY` macro registers a callback that runs
during PCI enumeration for the specific vendor/device ID pair. The
callback sets a flag that is checked in the FLR code paths. This is an
extremely well-established pattern used for many other devices.

Record: [Hardware workaround] [Device advertises broken FLR capability;
quirk prevents FLR from being used]

**Step 2.4: Fix Quality**
- Obviously correct: follows identical pattern of 7+ existing entries in
  the same quirk table
- Minimal/surgical: 3 lines, no logic changes
- Regression risk: essentially zero — the flag only affects these
  specific PCI device IDs; no impact on any other devices
- No red flags

Record: Fix quality: excellent. Regression risk: near-zero.

---

## PHASE 3: GIT HISTORY INVESTIGATION

**Step 3.1: Blame**
The `quirk_no_flr` function was introduced in commit `f65fd1aa4f9881`
(2017-04-03, v4.12-rc1) for Intel 82579 NICs. It has been stable
infrastructure since v4.12. Additional device entries were added over
the years (AMD Matisse in 2020, AMD FCH AHCI in 2023, SolidRun SNET DPU,
Mediatek MT7922 in 2025).

Record: `quirk_no_flr` infrastructure exists since v4.12 (2017). Present
in ALL active stable kernel trees.

**Step 3.2: Fixes Tag**
No Fixes: tag — not applicable (this is a new device ID addition, not a
code fix).

**Step 3.3: File History**
`drivers/pci/quirks.c` is an actively maintained file with frequent
device-specific additions. The pattern of adding
`DECLARE_PCI_FIXUP_EARLY` entries for broken FLR is well-established
with many precedents.

Record: File is active. Pattern is established. This is standalone — no
prerequisites.

**Step 3.4: Author**
Lizhi Hou is an AMD developer who works on the `accel/amdxdna` (AMD NPU)
driver. Their commits show deep familiarity with the AMD NPU hardware.
They are the right person to identify this hardware defect.

Record: Author is the AMD NPU subsystem developer — credible source for
this hardware bug report.

**Step 3.5: Dependencies**
None. The `quirk_no_flr` function, `DECLARE_PCI_FIXUP_EARLY` macro, and
`PCI_VENDOR_ID_AMD` constant all exist in every stable tree back to
v4.12. This patch is completely self-contained.

Record: No dependencies. Will apply cleanly to any stable tree with the
quirk infrastructure (all of them).

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

**Step 4.1-4.5:** Lore and patch.msgid.link are currently returning
anti-bot challenges. However, the commit was applied by Bjorn Helgaas
(PCI subsystem maintainer), which is the strongest possible endorsement
for a PCI patch. The Link: tag confirms it was submitted and reviewed
through the standard kernel mailing list process.

Record: Could not access lore discussion due to anti-bot protection.
However, maintainer (Bjorn Helgaas) applied the patch directly, which is
strong validation.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

**Step 5.1: Functions**
No functions modified. Two new `DECLARE_PCI_FIXUP_EARLY` entries added
that call existing `quirk_no_flr()`.

**Step 5.2: Callers of quirk_no_flr**
Called by the PCI subsystem during device enumeration (early fixup
phase). This runs for every PCI device matching the vendor/device ID
pair.

**Step 5.3-5.4: Impact path**
`quirk_no_flr()` → sets `PCI_DEV_FLAGS_NO_FLR_RESET` → checked by
`pcie_reset_flr()` and `pci_af_flr()` in `drivers/pci/pci.c`. FLR is
triggered during VFIO device passthrough, device reset operations, and
error recovery. The flag causes these functions to return `-ENOTTY`,
which makes the PCI reset machinery use an alternative reset method.

Record: FLR is triggered in VFIO passthrough and device reset. The quirk
prevents hang in these common operations.

**Step 5.5: Similar patterns**
7 existing entries in the same quirk table for AMD, Intel, Mediatek, and
SolidRun devices. This is a very common pattern.

---

## PHASE 6: STABLE TREE ANALYSIS

**Step 6.1: Buggy code in stable?**
The "buggy code" is the PCI FLR path itself which doesn't know about
these AMD NPU devices. The `quirk_no_flr` infrastructure has existed
since v4.12. However, the AMD NPU hardware itself may only appear in
relatively recent systems.

Record: The quirk infrastructure exists in all stable trees. The fix
will apply cleanly.

**Step 6.2: Backport complications**
None expected. The patch adds entries at the end of an existing table.
The exact ordering might differ slightly across stable trees, but the
macro entries are independent and the patch should apply with at most
trivial context adjustments.

Record: Expected backport difficulty: clean apply or trivial context
adjustment.

**Step 6.3: Related fixes in stable**
No related fixes for AMD NPU FLR already in stable.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

**Step 7.1:** PCI subsystem (`drivers/pci/`) — CORE infrastructure,
affects all PCI device users.

**Step 7.2:** PCI quirks.c is actively maintained with frequent device
additions.

Record: [PCI subsystem] [CORE criticality] [Active development]

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

**Step 8.1: Who is affected**
Users with AMD NPU hardware (PCI IDs 0x1502, 0x17f0). This includes
users doing VFIO passthrough to VMs, users experiencing error recovery
that triggers FLR, and potentially users of the amdxdna accelerator
driver.

Record: Affected users: AMD NPU hardware users.

**Step 8.2: Trigger conditions**
FLR is triggered during: VFIO device attach/detach, device error
recovery, and explicit reset operations. For VFIO users, this is
triggered during normal VM operations.

Record: Trigger is FLR attempt — common in VFIO and device reset
scenarios.

**Step 8.3: Failure mode**
Device hang — the NPU becomes unresponsive and cannot be used. This is a
HIGH severity issue.

Record: Severity: HIGH (device hang, device becomes unusable)

**Step 8.4: Risk-Benefit**
- Benefit: HIGH — prevents device hang on real hardware for real users
- Risk: VERY LOW — 3 lines, uses existing well-tested infrastructure,
  affects only the specific device IDs, no logic changes
- Ratio: Excellent benefit-to-risk ratio

---

## PHASE 9: FINAL SYNTHESIS

**Step 9.1: Evidence Summary**

FOR backporting:
- Classic PCI quirk addition — explicitly listed as an exception
  category for stable
- Only 3 lines added, using existing infrastructure unchanged since
  v4.12
- Prevents device hang (HIGH severity)
- Applied by PCI subsystem maintainer (Bjorn Helgaas)
- Author is the AMD NPU hardware developer (credible bug report)
- Zero regression risk — only affects specific PCI device IDs
- Pattern has 7+ precedents in the same file
- Will apply cleanly to all stable trees

AGAINST backporting:
- None identified

**Step 9.2: Stable Rules Checklist**
1. Obviously correct and tested? **YES** — identical pattern to 7 other
   entries, applied by subsystem maintainer
2. Fixes a real bug? **YES** — device hang on FLR
3. Important issue? **YES** — device hang is HIGH severity
4. Small and contained? **YES** — 3 lines, single file
5. No new features or APIs? **YES** — just device IDs for existing quirk
6. Can apply to stable trees? **YES** — infrastructure exists since
   v4.12

**Step 9.3: Exception Category**
This is a **hardware quirk/workaround** — explicitly called out as
automatic YES for stable.

---

## Verification

- [Phase 1] Parsed tags: Signed-off-by from AMD developer (Lizhi Hou)
  and PCI maintainer (Bjorn Helgaas)
- [Phase 2] Diff analysis: +3 lines (1 comment, 2
  DECLARE_PCI_FIXUP_EARLY macros) in `drivers/pci/quirks.c`
- [Phase 3] git blame: `quirk_no_flr` introduced in commit
  `f65fd1aa4f9881` (v4.12-rc1, 2017), present in all stable trees
- [Phase 3] git show `0d14f06cd6657`: confirmed AMD Matisse FLR quirk
  precedent from 2020
- [Phase 3] git log --author: Lizhi Hou confirmed as AMD XDNA/NPU
  accelerator developer
- [Phase 4] Lore/patch.msgid.link blocked by anti-bot; maintainer SOB
  confirms standard review process
- [Phase 5] Grep for `PCI_DEV_FLAGS_NO_FLR_RESET`: checked in
  `pcie_reset_flr()` (line 4375) and `pci_af_flr()` (line 4398) in
  `pci.c`
- [Phase 6] `quirk_no_flr` infrastructure exists since v4.12 — present
  in ALL active stable trees
- [Phase 6] No backport complications: trivial table additions
- [Phase 8] Failure mode: device hang on FLR, severity HIGH
- UNVERIFIED: Could not access lore discussion to check for reviewer
  feedback or stable nominations (anti-bot protection)

This is a textbook hardware quirk addition: minimal (3 lines), using
long-established infrastructure, preventing a device hang on real AMD
NPU hardware, applied by the PCI subsystem maintainer, with zero
regression risk.

**YES**

 drivers/pci/quirks.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index 48946cca4be72..757a296eae411 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -5603,6 +5603,7 @@ DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_INTEL, 0x443, quirk_intel_qat_vf_cap);
  * AMD Starship/Matisse HD Audio Controller 0x1487
  * AMD Starship USB 3.0 Host Controller 0x148c
  * AMD Matisse USB 3.0 Host Controller 0x149c
+ * AMD Neural Processing Unit 0x1502 0x17f0
  * Intel 82579LM Gigabit Ethernet Controller 0x1502
  * Intel 82579V Gigabit Ethernet Controller 0x1503
  * Mediatek MT7922 802.11ax PCI Express Wireless Network Adapter
@@ -5615,6 +5616,8 @@ DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_AMD, 0x1487, quirk_no_flr);
 DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_AMD, 0x148c, quirk_no_flr);
 DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_AMD, 0x149c, quirk_no_flr);
 DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_AMD, 0x7901, quirk_no_flr);
+DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_AMD, 0x1502, quirk_no_flr);
+DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_AMD, 0x17f0, quirk_no_flr);
 DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_INTEL, 0x1502, quirk_no_flr);
 DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_INTEL, 0x1503, quirk_no_flr);
 DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_MEDIATEK, 0x0616, quirk_no_flr);
-- 
2.53.0

