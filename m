Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D2644FC8F9;
	Mon, 19 Oct 2026 13:54:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418091; cv=none; b=h+r+Eo5TYGX63RYPoJM31e2yWdBdW4m0FvE1e9P+Ip91093abC/AcxZgW8ydZoGOXlJExtSdpodygaEddjstDKoKhbYaKJ+g/lo1rUx241fatzoQzhoDiHoRaDjrO0KGfjdbaRlQFYEGp1VyNx0Kw8ZEoTUhVF5pco02D+EYL4E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418091; c=relaxed/simple;
	bh=QQoVlm+4mbNlXObSNWeqmb5h+b+0yPoTgL/QWUtdZG0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nYyzNE+cC4FQge0OkcCcWLusnCayHieloI2AsdrprqVhN6Gtj85euETxK6+iPY77DfaatsiUUlKQwd5cPIgTGovKruBE6wcQnJYkioU9siuhiRVtFK9wBF+9ehQjt+8ZXraB740LNYSRAubeRHrDllUH/3V4kVxImcW/dzHnsB0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oEr2cvmn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oEr2cvmn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 656501F000C5;
	Mon, 19 Oct 2026 13:54:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418088;
	bh=X1z45abRY0XdCSMnwX2mP6HuNp68VPaI3GKdaVLUi+o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oEr2cvmndDqnS5DnsEbavN2iqqE+d+32IAjzU8WrPOqp9z6ANr5feOBduC4BfycO9
	 4cIc7V5G9Wtht53MJFK/UNRSVkqiP/SoUl/n8cZyHYpJ9trt67o4hiEhKrky4Uott2
	 KOrVSQhGAKM0HNYzzfUr3rS2/RnznKnBQxRABR44e8Eu+Zb1KYrlnaC/EQVzsokL3m
	 ZLXuGDB41azO/4fGdsdBCknV61/Pl3WfMlOzCIPUsO2QJiaiZ21VAp0nzcPP4Ly3t4
	 ZlHbKJkgMW0Th3D1e4Sn+XegfZopw1vb+e/AuLtyunW184M7A0zCQpkT9Wtbiz4JLf
	 +FtqjM1DeTKqw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Ben Dooks <ben.dooks@codethink.co.uk>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Ulf Hansson <ulfh@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	quic_asutoshd@quicinc.com,
	linux-mmc@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] mmc: cqhci: fix to missed endian conversions
Date: Mon, 19 Oct 2026 09:44:55 -0400
Message-ID: <20261019135441.1420968-4-sashal@kernel.org>
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

From: Ben Dooks <ben.dooks@codethink.co.uk>

[ Upstream commit 0aae2c73175821a71c0e20607f8e333be5b71940 ]

Fix two places where the wrong type or conversion of little-endian
types to fix the following sparse warnings:

drivers/mmc/host/cqhci-core.c:487:15: warning: incorrect type in assignment (different base types)
drivers/mmc/host/cqhci-core.c:487:15:    expected restricted __le32 [usertype]
drivers/mmc/host/cqhci-core.c:487:15:    got int
drivers/mmc/host/cqhci-core.c:566:19: warning: incorrect type in assignment (different base types)
drivers/mmc/host/cqhci-core.c:566:19:    expected unsigned long long [usertype] *task_desc
drivers/mmc/host/cqhci-core.c:566:19:    got restricted __le64 [usertype] *

Signed-off-by: Ben Dooks <ben.dooks@codethink.co.uk>
Acked-by: Adrian Hunter <adrian.hunter@intel.com>
Signed-off-by: Ulf Hansson <ulfh@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

This is a real missed little-endian conversion in CQHCI DMA descriptors,
not a sparse-only cleanup. The local tree is mainline 7.3-rc4; the bug
has been in this file since v4.16.

===============================================================
PHASE 1: COMMIT MESSAGE FORENSICS
===============================================================

**Step 1.1: PARSE THE SUBJECT LINE**
Record: **[mmc / cqhci] [fix] missed little-endian conversions on CQHCI
descriptors**

**Step 1.2: PARSE ALL COMMIT MESSAGE TAGS**
Record:
- **Fixes:** none (expected for this review pipeline)
- **Reported-by:** none
- **Tested-by:** none
- **Reviewed-by:** none
- **Acked-by:** Adrian Hunter \<adrian.hunter@intel.com\> (CQHCI/SDHCI
  expert)
- **Link:** none in the commit; mailing-list thread recovered via `b4
  dig`
- **Cc: stable:** none (not a negative signal here)
- **Signed-off-by:** Ben Dooks \<ben.dooks@codethink.co.uk\> (author);
  Ulf Hansson \<ulfh@kernel.org\> (MMC maintainer). Ignore any Sasha
  Levin SOB.

**Step 1.3: ANALYZE THE COMMIT BODY TEXT**
Record:
- **Bug described:** two assignments use the wrong type / omit
  `cpu_to_le*` when writing `__le32` / `__le64` CQHCI descriptors.
- **Symptom in the message:** sparse type warnings only. No stack trace,
  no reproducer, no user report.
- **Failure mode implied by the code (not stated in the message):** on a
  big-endian CPU, transfer-descriptor attributes (including
  `CQHCI_DAT_LENGTH`) and DCMD task descriptors are stored in CPU byte
  order instead of the little-endian layout the CQHCI controller
  expects.
- **Version info:** none in the message.
- **Root cause as given:** missed endian conversion / wrong pointer
  type.

**Step 1.4: DETECT HIDDEN BUG FIXES**
Record: **Yes, this is a hidden functional endian fix.** The subject
says “fix” but the body only cites sparse. The same file already
converts sibling descriptor fields with `cpu_to_le32`/`cpu_to_le64`.
Omitting that on `__le32 *attr` and `__le64 *task_desc` is a hardware-
descriptor bug on BE, not a warning-only cleanup.

===============================================================
PHASE 2: DIFF ANALYSIS - LINE BY LINE
===============================================================

**Step 2.1: INVENTORY THE CHANGES**
Record:
- **File:** `drivers/mmc/host/cqhci-core.c` — 7 insertions, 7 deletions
  (14 lines touched).
- **Functions:** `cqhci_set_tran_desc()`, `cqhci_prep_dcmd_desc()`.
- **Scope:** single-file surgical fix.

**Step 2.2: UNDERSTAND THE CODE FLOW CHANGE**
Record:
- **Hunk 1 (`cqhci_set_tran_desc`):** before, `*(__le32 *)attr` was
  assigned a native `int` bitfield (`VALID|END|INT|ACT|DAT_LENGTH`).
  Address words already used `cpu_to_le64`/`cpu_to_le32`. After, the
  attribute word is wrapped in `cpu_to_le32()`. Path: every CQE data
  transfer descriptor (normal I/O path).
- **Hunk 2 (`cqhci_prep_dcmd_desc`):** before, `task_desc` was `u64 *`
  and `*task_desc |= data` mixed a CPU-endian `u64` into memory obtained
  as `__le64`. After, `task_desc` is `__le64 *` and the OR uses
  `cpu_to_le64(data)`. Path: CQE direct commands (DCMD), e.g. cache
  flush / status when `MMC_CAP2_CQE_DCMD` is set.

**Step 2.3: IDENTIFY THE BUG MECHANISM**
Record: **[Type / endianness]** CQHCI descriptors in memory are little-
endian. `CQHCI_DAT_LENGTH` lives in bits 16–31; DCMD
`CMD_INDEX`/`CMD_TIMING`/`RESP_TYPE` live in bits 16–24. Those fields do
not fit in byte 0, so a native store is wrong on BE. The controller
would see a swapped length and scrambled DCMD opcode/timing. The fix is
the same conversion already used in `cqhci_prep_task_desc()`
(`task_desc[0] = cpu_to_le64(desc0)`).

**Step 2.4: ASSESS THE FIX QUALITY**
Record: Obviously correct and minimal. On little-endian,
`cpu_to_le32`/`cpu_to_le64` are no-ops, so the common CQHCI population
does not change. Regression risk is very low. No API, locking, or
structure-layout change. `update_dcmd_desc` still mutates the CPU-endian
`u64 data` before conversion (Tegra’s callback is consistent with that).

===============================================================
PHASE 3: GIT HISTORY INVESTIGATION
===============================================================

**Step 3.1: BLAME THE CHANGED LINES**
Record: Buggy assignments come from **a4080225f51dce** (“mmc: cqhci:
support for command queue enabled host”, Venkat Gopalakrishnan,
2017-11-29), first in **v4.16-rc1**. Address-field conversions were
already present then; the attribute/DCMD stores were the miss. Code has
been in-tree for many years.

**Step 3.2: FOLLOW THE FIXES: TAG**
Record: No `Fixes:` tag. The introducing commit is a4080225f51dce
(v4.16). Intermediate related work: **ee49d0321f025** (Eric Biggers,
2021) converted `cqhci_prep_task_desc()` to `__le64 *` + `cpu_to_le64`
and did not fix DCMD / transfer-attr stores.

**Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES**
Record: Recent `cqhci-core.c` work is halt/recovery/callback related,
not endian. Not a numbered series. Standalone.

**Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS**
Record: Ben Dooks is a regular MMC endian/sparse contributor (`dw_mmc`
LE descriptor fixes, endian-agnostic IO). Not the MMC maintainer. Ulf
Hansson applied it; Adrian Hunter acked it.

**Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS**
Record: No functional prerequisite. `cqhci_set_tran_desc` was exported
in **52bf134fca61f** (v6.11) for DWCMSHC; the body bug is independent of
that. File rename `cqhci.c` → `cqhci-core.c` (**0653300224a69**) is a
path tweak only for older trees. Can apply standalone.

===============================================================
PHASE 4: MAILING LIST AND EXTERNAL RESEARCH
===============================================================

**Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION**
Record:
- Lore URL from `b4 dig -c 0aae2c73175821`: https://patch.msgid.link/202
  60622145036.513129-1-ben.dooks@codethink.co.uk
- **Series:** v1 only (`b4 dig -a`). Applied version is that v1.
- **Review:** Adrian Hunter Acked-by. Ulf Hansson: “Applied for next,
  thanks!”
- **NAKs / stable nominations:** none in the thread.
- WebFetch of lore.kernel.org returned 403; thread was read from `b4 dig
  -m` mbox instead.

**Step 4.2: CHECK WHO REVIEWED THE PATCH**
Record (`b4 dig -w`): To/Cc included Adrian Hunter, Asutosh Das, Ritesh
Harjani, Ulf Hansson, linux-mmc, linux-kernel. Right maintainers were on
the original mail.

**Step 4.3: SEARCH FOR THE BUG REPORT**
Record: No Reported-by, bugzilla, or syzbot link. Trigger was sparse,
not a user crash report.

**Step 4.4: CHECK FOR RELATED PATCHES AND SERIES**
Record: Standalone single patch. Not 2/N.

**Step 4.5: CHECK STABLE MAILING LIST HISTORY**
Record: **UNVERIFIED** (lore.kernel.org/stable WebFetch 403). Original
thread did not mention stable.

===============================================================
PHASE 5: CODE SEMANTIC ANALYSIS
===============================================================

**Step 5.1: IDENTIFY KEY FUNCTIONS**
Record: `cqhci_set_tran_desc`, `cqhci_prep_dcmd_desc`. Callers also
involved: `cqhci_prep_tran_desc`, `cqhci_request`,
`dwcmshc_set_tran_desc`.

**Step 5.2: TRACE CALLERS**
Record:
- `cqhci_set_tran_desc`: `cqhci_prep_tran_desc` (default),
  `dwcmshc_set_tran_desc` in `sdhci-of-dwcmshc.c` (Rockchip/DWC MSHC).
- `cqhci_prep_dcmd_desc`: `cqhci_request()` when `!mrq->data`.
- `cqhci_request` is `.cqe_request` — MMC command-queue I/O, not init-
  only.

**Step 5.3: TRACE CALLEES**
Record: Bitfield macros, `get_desc()`, optional `update_dcmd_desc`
(Tegra only), `cpu_to_le32`/`cpu_to_le64`. No alloc/lock changes.

**Step 5.4: FOLLOW THE CALL CHAIN**
Record: Userspace block I/O on CQE eMMC → MMC core → `cqe_request` →
descriptor prep → doorbell. Reachable on any CQHCI host (Qualcomm, i.MX,
Tegra, MTK, Broadcom STB, Arasan, Intel GLK, TI AM654, Rockchip DWCMSHC,
etc.). BE vs LE is a kernel endian config, not a separate code path.

**Step 5.5: SEARCH FOR SIMILAR PATTERNS**
Record: `cqhci_prep_task_desc` already converts correctly.
`setup_trans_desc()` still writes `VALID|ACT|END` through a `u8 *`;
those bits fit in byte 0, so a LE controller still sees the correct LSB
regardless of CPU endianness. The two sites this patch touches are the
ones that put multi-byte fields into `__le32`/`__le64` words.

===============================================================
PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE
===============================================================

**Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?**
Record: This checkout is **v7.3-rc4** (`7.3.0-rc4`, HEAD
`f0100363d8c37`, origin/master). Commit **0aae2c73175821 is already an
ancestor of HEAD** (merged in `mmc-v7.3`). Pre-fix code is in
`0aae2c73^`. The unconverted stores existed from v4.16 until this
commit. The bug is in this tree’s history and in any stable series that
still has the old assignments.

**Step 6.2: CHECK FOR BACKPORT COMPLICATIONS**
Record: Clean apply on this tree (already applied). Older stables may
still name the file `cqhci.c` and may still have a static
`cqhci_set_tran_desc`; that is a trivial context/path adjustment, not a
semantic rework.

**Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE**
Record: No earlier equivalent DCMD/attr conversion. `ee49d0321f025` only
fixed `cqhci_prep_task_desc`.

===============================================================
PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT
===============================================================

**Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY**
Record: **MMC host / CQHCI** (`drivers/mmc/host/`). **IMPORTANT** — eMMC
command queue on widely used SoCs and some PCI hosts. Not core mm/VFS,
not staging.

**Step 7.2: ASSESS SUBSYSTEM ACTIVITY**
Record: Actively maintained (halt, recovery, crypto, DWCMSHC callbacks).
CQHCI itself is mature (2017).

===============================================================
PHASE 8: IMPACT AND RISK ASSESSMENT
===============================================================

**Step 8.1: DETERMINE WHO IS AFFECTED**
Record: CQHCI users on **big-endian** kernels. In-tree `supports-cqe` DT
is ARM64 (Qualcomm, Rockchip, Tegra, …). ARM64 has
`CONFIG_CPU_BIG_ENDIAN`. No MIPS `supports-cqe` DT. Little-endian CQHCI
(the usual phone/board case) is unaffected.

**Step 8.2: DETERMINE THE TRIGGER CONDITIONS**
Record: Any CQE data transfer (`cqhci_set_tran_desc`) or DCMD
(`cqhci_prep_dcmd_desc`) on BE. Common path if CQE is enabled. Not a
race. Unprivileged I/O can exercise it if the device is
mounted/accessible.

**Step 8.3: DETERMINE THE FAILURE MODE SEVERITY**
Record: Wrong LE descriptor in DMA memory → controller misreads length /
DCMD fields → **I/O failure and possible data corruption**. **Severity:
HIGH** on BE CQHCI; **none** on LE.

**Step 8.4: CALCULATE RISK-BENEFIT RATIO**
Record: **Benefit:** high for BE CQHCI (makes CQE descriptors spec-
correct); none for LE. **Risk:** very low (7 lines, LE no-op, no
locking/API). **Ratio:** favorable. This is the usual justification for
descriptor endian fixes in stable.

===============================================================
PHASE 9: FINAL SYNTHESIS
===============================================================

**Step 9.1: COMPILE THE EVIDENCE**

**FOR backporting:**
- Real missed `cpu_to_le*` on hardware DMA/task descriptors, present
  since v4.16.
- Sibling `cqhci_prep_task_desc` and the address fields in the same
  function already convert; these two stores were the hole.
- On BE, `DAT_LENGTH` and DCMD opcode/timing/response type would be
  byte-swapped → CQE malfunction / corruption risk.
- 7-line, obviously correct, LE no-op.
- Acked by Adrian Hunter; applied by Ulf Hansson.
- Matches the endianness/type-bug class used in stable.

**AGAINST backporting:**
- Commit text only mentions sparse; no user report, no `Fixes:`, no `Cc:
  stable`.
- Typical CQHCI hardware is ARM64/x86 LE, so most stable users see no
  runtime change.
- Author did not describe a user-visible failure.

**UNRESOLVED:**
- Whether this was discussed on stable@ (lore 403).
- Whether any production BE CQHCI board is in the wild (in-tree CQE DT
  is ARM64; ARM64 BE exists but is uncommon).

**Step 9.2: APPLY THE STABLE RULES CHECKLIST**
1. Obviously correct and tested? **PASS** — mechanical `cpu_to_le*` to
   match existing descriptor stores; maintainer ack.
2. Fixes a real bug that affects users? **PASS** — wrong CQHCI
   descriptor endianness on BE is a real protocol/hardware bug, not
   whitespace.
3. Important issue? **PASS** — wrong transfer length / DCMD fields can
   break CQE I/O or corrupt data. Sparse is how it was found, not the
   user-visible impact.
4. Small and contained? **PASS** — 7 lines, one file, two functions.
5. No new features or APIs? **PASS**.
6. Can apply to the local tree? **PASS** — already present on this
   7.3-rc4 tree; the pre-fix pattern is the long-standing one.

**Step 9.3: CHECK FOR EXCEPTION CATEGORIES**
Record: Not a device-ID/quirk/DT/docs exception. Closest adjacent class
is **endianness correctness** (and incidentally a sparse warning). Not a
reason to reject.

**Step 9.4: MAKE YOUR DECISION**
The local tree is mainline **7.3.0-rc4**, which already contains the
fix. The evaluation is whether that fix should also be selected for
stable: the buggy stores have been in CQHCI since **v4.16**, the change
is self-contained, and it corrects hardware-visible descriptors. Sparse
was the detector; the bug is endian-incorrect DMA descriptors. Risk on
the LE majority is zero. That is appropriate for stable.

===============================================================
What the commit solves and why it matters
===============================================================
CQHCI transfer and DCMD descriptors are little-endian in memory. Two
writes used native CPU values: transfer attributes
(`VALID`/`END`/`ACT`/`DAT_LENGTH`) and the DCMD task word. On big-endian
that swaps the length and command fields the controller DMA-reads, so
command-queue I/O can fail or transfer the wrong size. Little-endian
kernels are unchanged. The patch is small, already reviewed by the CQHCI
expert, and needs no extra commits.

Risk vs benefit: very low risk, real correctness fix for BE CQHCI, no
behavior change for typical LE devices.

===============================================================
Verification
===============================================================
- [Phase 1] Parsed commit 0aae2c73175821: Acked-by Adrian Hunter; SOB
  Ben Dooks, Ulf Hansson; no Fixes/Reported-by/Cc: stable.
- [Phase 2] Diff: 7+/-7 in `cqhci_set_tran_desc` and
  `cqhci_prep_dcmd_desc` only.
- [Phase 2] Confirmed `CQHCI_DAT_LENGTH` is bits 16–31 and DCMD fields
  are bits 16+ in `cqhci.h`.
- [Phase 2] Pre-fix parent still assigned native ints/`u64` into `__le*`
  memory; addresses already used `cpu_to_le*`.
- [Phase 3] `git blame`: buggy code from a4080225f51dce (v4.16-rc1).
- [Phase 3] `cqhci_prep_task_desc` conversion added in ee49d0321f025
  (2021); DCMD/attr left unconverted.
- [Phase 3] Author history on `drivers/mmc/`: several real dw_mmc endian
  fixes.
- [Phase 3] `git merge-base --is-ancestor 0aae2c73175821 HEAD` → commit
  is in this tree.
- [Phase 4] `b4 dig -c/-a/-w/-m`: v1-only thread; Hunter ack; Ulf
  “Applied for next”; lists linux-mmc + Hunter/Hansson.
- [Phase 4] lore WebFetch 403; used local mbox. Stable@ search
  UNVERIFIED (403).
- [Phase 5] Callers: `cqhci_request` → prep_tran_desc/prep_dcmd_desc;
  `dwcmshc_set_tran_desc` calls `cqhci_set_tran_desc`.
- [Phase 5] No semcode MCP; used git grep.
- [Phase 6] `git describe HEAD` = v7.3-rc4-27-gf0100363d8c37; `make
  kernelversion` = 7.3.0-rc4.
- [Phase 6] Fix merged via f96718fc1f614 (`mmc-v7.3`).
- [Phase 6] In-tree `supports-cqe` is ARM64-only; no MIPS matches.
- [Phase 7] CQHCI selected by MSM, i.MX, Tegra, MTK, brcmstb, Arasan,
  DWCMSHC, AM654, SDHCI PCI.
- [Phase 8] Failure mode: BE descriptor corruption → CQE I/O failure /
  possible data corruption; LE no-op.
- UNVERIFIED: production BE CQHCI user reports; stable@ discussion.

The patch is small, obviously correct, and fixes a real hardware-
descriptor endian bug that has been in this tree’s CQHCI code since
v4.16.

**YES**

 drivers/mmc/host/cqhci-core.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/mmc/host/cqhci-core.c b/drivers/mmc/host/cqhci-core.c
index 178277d90c31c..00614b500b2bc 100644
--- a/drivers/mmc/host/cqhci-core.c
+++ b/drivers/mmc/host/cqhci-core.c
@@ -484,11 +484,11 @@ void cqhci_set_tran_desc(u8 *desc, dma_addr_t addr, int len, bool end,
 {
 	__le32 *attr = (__le32 __force *)desc;
 
-	*attr = (CQHCI_VALID(1) |
-		 CQHCI_END(end ? 1 : 0) |
-		 CQHCI_INT(0) |
-		 CQHCI_ACT(0x4) |
-		 CQHCI_DAT_LENGTH(len));
+	*attr = cpu_to_le32((CQHCI_VALID(1) |
+			     CQHCI_END(end ? 1 : 0) |
+			     CQHCI_INT(0) |
+			     CQHCI_ACT(0x4) |
+			     CQHCI_DAT_LENGTH(len)));
 
 	if (dma64) {
 		__le64 *dataddr = (__le64 __force *)(desc + 4);
@@ -542,7 +542,7 @@ static int cqhci_prep_tran_desc(struct mmc_request *mrq,
 static void cqhci_prep_dcmd_desc(struct mmc_host *mmc,
 				   struct mmc_request *mrq)
 {
-	u64 *task_desc = NULL;
+	__le64 *task_desc = NULL;
 	u64 data = 0;
 	u8 resp_type;
 	u8 *desc;
@@ -574,7 +574,7 @@ static void cqhci_prep_dcmd_desc(struct mmc_host *mmc,
 		 CQHCI_CMD_TIMING(timing) | CQHCI_RESP_TYPE(resp_type));
 	if (cq_host->ops->update_dcmd_desc)
 		cq_host->ops->update_dcmd_desc(mmc, mrq, &data);
-	*task_desc |= data;
+	*task_desc |= cpu_to_le64(data);
 	desc = (u8 *)task_desc;
 	pr_debug("%s: cqhci: dcmd: cmd: %d timing: %d resp: %d\n",
 		 mmc_hostname(mmc), mrq->cmd->opcode, timing, resp_type);
-- 
2.53.0

