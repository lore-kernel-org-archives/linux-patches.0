Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA2974FD79C;
	Mon, 19 Oct 2026 13:58:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418298; cv=none; b=KwBzdgWpP5DJcF6lpWoQ+8N9h4Chmfw55lbyCDR1I/RoljBPi7n46VelyoXMH/lQT15ZHcHHU2B2ZVeMKUVSS1Mkr965rDMSjHAnFsOgEHJoUEAnNmJBD2PckXsYBRAt9ZWrcF393HcQXwunxqr26qoExBDhig+2zBtQewp74wg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418298; c=relaxed/simple;
	bh=6sFnVbt2hLiO37r4MPLryBWnzrCgJnOWgVpC4ChUDCM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Qe42/5dRnNPyYTU4/8+0w/1mFjn0r3F97In3WIAwj5OqU6UcWE09GcPSliHsIowcSJjrUqwb1btlOT6xu1vAC/hq4Ae6xdcU4vWVjWAM3TOwzkDSr+HusFKLWmLmhx7VAmeDEPX15xgE2YZvJjdXMw+azuDjmg9Si+46e3S0O7w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=U7PWeDm4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="U7PWeDm4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A33B41F000C6;
	Mon, 19 Oct 2026 13:58:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418293;
	bh=dVpi2Qt8rGDhkBJcCF1Rc3xlJf7dXV2WsmSTuQO/f0k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=U7PWeDm49kuuj4jBR9R+HXh1WOSqSKYKa8y/7DOG+QBxVOaWQ0K+qqIJ8PesY5Sjk
	 goCBno4JTE/4RoRuor5OxrixqCUV83SBZZ2jFa2LSoseFtXI3Lym7TKLEBV1RL/51v
	 ZDUEiZfTBzSP5t2P6DFijL20EPgKJ7IJt+Ioep1n27EagqR6UmEdRy3rIS/NhnKWc1
	 Sy3hCn3PeE7ocdzWzbw+r1yxp3h+V1mQQbC4o3JVINaOOD4j3VwZKtWCMtjkRSTgaI
	 Qo30+W37PeEZ/u3JmWhe6yJ3YhelEUBfhObQ+Ntb+HqD9x1HK/W0cYR+dIVGrVZwIG
	 3x0feFihulq3Q==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Aviv Bakal <avivb@amazon.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Ilkka Koskinen <ilkka@os.amperecomputing.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	mark.rutland@arm.com,
	linux-arm-kernel@lists.infradead.org,
	linux-perf-users@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] perf/arm-cmn: Add workarounds for CMN-S3 on Graviton5
Date: Mon, 19 Oct 2026 09:47:16 -0400
Message-ID: <20261019135441.1420968-145-sashal@kernel.org>
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

From: Aviv Bakal <avivb@amazon.com>

[ Upstream commit 9d0b1714e1af16622a2d0f7317ddaa9a4b27f353 ]

Graviton5 uses a customised CMN-S3 implementation where certain
discovery registers report zeroed fields. Add the following workarounds:

 - Introduce a dedicated ACPI HID to identify the Graviton5 CMN variant.
 - Derive the DTC domain from the XP node ID, since the unit info
   register reports it as zero.
 - Set the DTC logical ID from the XP's logical ID, since the node info
   register's logical ID field is also zeroed.

Signed-off-by: Aviv Bakal <avivb@amazon.com>
Reviewed-by: Robin Murphy <robin.murphy@arm.com>
Reviewed-by: Ilkka Koskinen <ilkka@os.amperecomputing.com>
Signed-off-by: Robin Murphy <robin.murphy@arm.com>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The local tree is **v7.3-rc4** (kernel 7.3.0-rc4). The question is
whether `9d0b1714e1af1` (`perf/arm-cmn: Add workarounds for CMN-S3 on
Graviton5`) belongs in **this** tree on technical merit.

---

## PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1: PARSE THE SUBJECT LINE**

Record: `[perf/arm-cmn] [Add] [workarounds for a customised CMN-S3 on
Graviton5]`

**Step 1.2: PARSE ALL COMMIT MESSAGE TAGS**

Record:
- `Fixes:` — none (expected)
- `Reported-by:` — none
- `Tested-by:` — none
- `Reviewed-by: Robin Murphy <robin.murphy@arm.com>` (arm-cmn
  maintainer)
- `Reviewed-by: Ilkka Koskinen <ilkka@os.amperecomputing.com>`
- `Link:` — none in the commit
- `Cc: stable@vger.kernel.org` — none (expected)
- `Signed-off-by: Aviv Bakal <avivb@amazon.com>` (author)
- `Signed-off-by: Robin Murphy <robin.murphy@arm.com>`
- `Signed-off-by: Will Deacon <will@kernel.org>`
- Ignored: any Sasha Levin SOB / Upstream-commit markers

**Step 1.3: ANALYZE THE COMMIT BODY TEXT**

Record:
- **Bug:** Graviton5’s CMN-S3 zeros some discovery fields (DTC domain in
  unit info, logical ID in node info).
- **Symptom:** Standard discovery cannot identify DTC domains or DTC
  logical IDs; a 10×14 mesh also exceeds `CMN_MAX_DIMENSION` 12.
- **Version info:** none in the message.
- **Root cause:** custom silicon, not a kernel logic regression.
  Identified via ACPI HID `AMZN0070`.

**Step 1.4: DETECT HIDDEN BUG FIXES**

Record: Not a disguised cleanup. It is an explicit hardware workaround
plus ACPI ID. Cover letter language is “adds support”; the mechanism is
a quirk for broken discovery registers.

---

## PHASE 2: DIFF ANALYSIS

**Step 2.1: INVENTORY THE CHANGES**

Record:
- File: `drivers/perf/arm-cmn.c` (+31 / −1)
- Functions: `arm_cmn_graviton5_dtc_domain` (new), `arm_cmn_discover`
  (workaround + DTC logid), `arm_cmn_acpi_match[]` (HID)
- Also: `CMN_MAX_DIMENSION` 12→14, `PART_GRAVITON5`
- Scope: single-file, surgical, driver-local

**Step 2.2: UNDERSTAND THE CODE FLOW CHANGE**

Record:
- Dimension cap 12→14 so a 10×14 mesh is not rejected.
- ACPI `AMZN0070` → synthetic `PART_GRAVITON5`, then treated as
  `PART_CMN_S3`.
- DTC domain: from unit-info register → from XP node ID `(x/5)+(y/7)*2`
  on the 10×14 mesh (domains 0–3).
- DTC `logid`: from node info → XP `logid` so sort order matches
  firmware IRQ order.

**Step 2.3: IDENTIFY THE BUG MECHANISM**

Record: **Hardware workaround + ACPI device ID.** Zeroed discovery
fields would map every XP to DTC domain 0 and every DTC logid to 0. Mesh
10×14 fails `max(mesh_x,mesh_y) > CMN_MAX_DIMENSION` (`36c0de02575ce`,
already in this tree).

**Step 2.4: ASSESS THE FIX QUALITY**

Record:
- Quality: small, gated on `AMZN0070` except the dimension bump.
  Maintainer R-b’d after review (v1 used `xp->logid`; v2 used `xp->dtc`;
  Robin required `xp->logid` because `cmn->dtc[]` is sorted by logid to
  match firmware IRQ order). Committed code matches that.
- Regression risk: low. Workaround is HID-gated. `CMN_MAX_DIMENSION` 14
  only grows per-event bitmaps (`CMN_MAX_XPS` 144→196). Domain formula
  is Graviton5-specific; x,y are 4-bit so theoretical max domain is 7,
  but 10×14 yields 0–3 (`CMN_MAX_DTCS` is 4).

---

## PHASE 3: GIT HISTORY INVESTIGATION

**Step 3.1: BLAME THE CHANGED LINES**

Record:
- Workaround and dimension bump introduced by `9d0b1714e1af1` itself
  (Aviv Bakal, 2026-06-30; merged 2026-07-21).
- Driver: long-standing. CMN-S3: `0dc2f4963f7ef` (2024-09-04). ACPI
  `ARMHC003`: `8c138a189f6db` (2025-05-19). Mesh reject: `36c0de02575ce`
  (2026-02-03, `Cc: stable`).

**Step 3.2: FOLLOW THE FIXES: TAG**

Record: No `Fixes:` tag. Not a regression from a specific kernel commit;
hardware does not implement discovery as the driver expects.

**Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES**

Record:
- This is **v6 2/2**. Patch 1 is `56603c28d9169` (`Move DTM index data
  out of hw_perf_event`) — **already an ancestor of HEAD**. Needed
  because embedded `dtm_idx`/`wp_idx` in `hw_perf_event` were size-
  capped; growing `CMN_MAX_DIMENSION` without that move would fail
  `static_assert(sizeof(struct arm_cmn_hw_event) <= offsetof(struct
  hw_perf_event, target))`.
- Later 7.3 work (filter refactor, CMN S3 r2) does not revert the
  workaround. No graviton-specific follow-up.

**Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS**

Record: Aviv Bakal (Amazon) — this is their only arm-cmn commit here.
Robin Murphy is the driver author/maintainer and both reviewed and re-
posted v6.

**Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS**

Record: Needs CMN-S3, ACPI table, mesh-size check, and the DTM-index
move. **All are in this 7.3-rc4 tree.** Standalone on this tree.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

**Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION**

Record:
- `b4 dig -c 9d0b1714e1af1` → https://patch.msgid.link/e9340d3a4385e6f1a
  6e80bda944a3ba6435472b6.1782824005.git.robin.murphy@arm.com
- Revisions: v1 (2026-05-03) → v2 → v3 (added DTM move) → v4 → v5 → **v6
  applied** (Robin re-post, 2026-06-30)
- Robin on v2: use `xp->logid` not `xp->dtc`; “surprisingly pleasant and
  unobtrusive given that it's a pretty horrible hardware issue”
- No NAK. Applied version is latest.
- A sashiko-bot note about unbounded DTC domain / sort order is the
  opposite of Robin’s requested `xp->logid` behaviour; not a NAK from
  maintainers.

**Step 4.2: CHECK WHO REVIEWED THE PATCH**

Record (`b4 dig -w`): Robin Murphy, Will Deacon, Mark Rutland, linux-
arm-kernel, linux-perf-users, Amazon (zeev, blakgeof), Ilkka Koskinen.
Right maintainers.

**Step 4.3: SEARCH FOR THE BUG REPORT**

Record: No syzbot/bugzilla. Amazon submitted from silicon bring-up.

**Step 4.4: CHECK FOR RELATED PATCHES AND SERIES**

Record: Series is DTM-index move + this workaround. Patch 1 is in this
tree. No extra ACPI docs/HID patch required (`AMZN0070` is only in `arm-
cmn.c`).

**Step 4.5: CHECK STABLE MAILING LIST HISTORY**

Record: lore.kernel.org/stable search returned 403. **UNVERIFIED:** no
confirmed stable-list nomination or rejection.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

**Step 5.1: IDENTIFY KEY FUNCTIONS**

Record: `arm_cmn_graviton5_dtc_domain`, `arm_cmn_discover`,
`arm_cmn_acpi_match`, `arm_cmn_init_node_info` (unchanged, still source
of zeroed logid).

**Step 5.2: TRACE CALLERS**

Record: `arm_cmn_discover()` ← `arm_cmn_probe()` only. Probe runs when
ACPI matches (including `AMZN0070`). Not IRQ/syscall hot path;
boot/device-init.

**Step 5.3: TRACE CALLEES**

Record: `arm_cmn_init_node_info`, `arm_cmn_dtc_domain` / graviton5
variant, `arm_cmn_init_dtm`, then `arm_cmn_init_dtcs` (sort by
type+logid, `platform_get_irq` by sort index).

**Step 5.4: FOLLOW THE CALL CHAIN**

Record: ACPI `AMZN0070` → probe → discover (workaround) → init DTCs/IRQs
→ register PMU. Userspace `perf` then uses the interconnect PMU.
Reachable on Graviton5 with `CONFIG_ARM_CMN`.

**Step 5.5: SEARCH FOR SIMILAR PATTERNS**

Record: Same file already has AmpereOneX bogus-child-pointer handling
and CMN-600AE aliasing. Same “quirks for broken discovery” pattern.

---

## PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE

**Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?**

Record: Yes. `drivers/perf/arm-cmn.c` has CMN-S3, ACPI match, mesh-size
reject. Without this commit, `AMZN0070` would not bind; a 10×14 mesh
would `-ENODEV`; zeroed DTC fields would mis-program the PMU. Introduced
as hardware behaviour, not a post-7.3 commit.

`git describe HEAD` = `v7.3-rc4-27-gf0100363d8c37`. Commit is in
v7.3-rc1 (not in v7.2). That is **not** used as “already selected”; it
only shows 7.3 has the prerequisites.

**Step 6.2: CHECK FOR BACKPORT COMPLICATIONS**

Record: Clean on this tree. Context still matches (graviton5 flag, ACPI
HID, dimension 14). Later S3 r2/filter refactors left the workaround in
place.

**Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE**

Record: No alternate Graviton5 fix. No later graviton-specific patch in
`9d0b1714e1af1..HEAD`.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

**Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY**

Record: `drivers/perf/` — Arm CMN uncore PMU. **PERIPHERAL/IMPORTANT:**
ARM64 servers with CMN; Graviton5-specific for the HID path. Not
mm/sched/VFS.

**Step 7.2: ASSESS SUBSYSTEM ACTIVITY**

Record: Active in 7.3 (S3 r2, filters, DTM layout). Driver itself is
mature (~CMN-600 era).

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

**Step 8.1: DETERMINE WHO IS AFFECTED**

Record: ACPI `AMZN0070` / Graviton5 only, plus a small extra bitmap size
for all `CONFIG_ARM_CMN` users.

**Step 8.2: DETERMINE THE TRIGGER CONDITIONS**

Record: Probe on Graviton5. Not unprivileged-triggerable beyond normal
perf. Not a race. Common on that platform at boot.

**Step 8.3: DETERMINE THE FAILURE MODE SEVERITY**

Record: Missing/wrong CMN PMU (no bind, `-ENODEV`, or events on the
wrong DTC). Not panic/corruption/deadlock. **MEDIUM** for that hardware;
still the documented quirk/ID exception.

**Step 8.4: CALCULATE RISK-BENEFIT RATIO**

Record:
- Benefit: Graviton5 CMN perf actually works (HID + discovery + 10×14
  mesh).
- Risk: low (~31 lines, HID-gated, maintainer-reviewed). Dimension bump
  is small and already paired with the DTM-index move in this tree.
- Ratio: favorable.

---

## PHASE 9: FINAL SYNTHESIS

**Step 9.1: COMPILE THE EVIDENCE**

**FOR:**
- ACPI ID + hardware quirk on an existing driver (stable exception).
- Real silicon: zeroed CMN-S3 discovery, 10×14 mesh.
- Small, single-file, obviously correct after maintainer review.
- Prerequisites present in 7.3-rc4.
- Robin Murphy: use `xp->logid`; workaround is unobtrusive.

**AGAINST:**
- Enablement/quirk, not a crash/security/corruption fix.
- Cover letter is “add support”.
- `CMN_MAX_DIMENSION` affects all CMN bitmap sizes (small).
- Series 2/2 (patch 1 already here).
- No `Reported-by` from production crashes.

**UNRESOLVED:**
- Stable list discussion (lore 403).
- No public Tested-by (author is Amazon; hardware access is plausible
  but unverified).

**Step 9.2: APPLY THE STABLE RULES CHECKLIST**

1. Obviously correct and tested? **PASS** — maintainer R-b after v1–v6;
   IRQ/logid issue addressed as Robin specified.
2. Fixes a real bug that affects users? **PASS** — Graviton5 CMN PMU
   cannot enumerate correctly without it.
3. Important issue? **PASS** via quirk/ID exception (severity MEDIUM as
   a PMU, not a panic).
4. Small and contained? **PASS** — +31/−1, one file.
5. No new features or APIs? **PASS** — no new uAPI; HID + discovery
   workaround on existing PMU.
6. Can apply to the local tree? **PASS** — driver, CMN-S3, DTM-index
   move, mesh check all present.

**Step 9.3: CHECK FOR EXCEPTION CATEGORIES**

Record: **ACPI device ID** (`AMZN0070`) **and hardware quirk** for
customised CMN-S3.

**Step 9.4: MAKE YOUR DECISION**

This tree is 7.3-rc4, which already contains CMN-S3 and the series
prerequisite. The patch is the standard stable shape: ID + quirk so
existing `arm-cmn` works on shipping Graviton5. Benefit is real for that
platform; risk is low and mostly HID-gated.

---

## What the commit solves and why it matters here

Graviton5 implements CMN-S3 with discovery registers that read as zero
and a 10×14 mesh. In this tree, `arm_cmn_discover()` would then put
every XP in DTC domain 0, leave DTC logids at 0 (breaking IRQ sort
order), and reject the mesh as larger than 12. Adding `AMZN0070` and the
three workarounds makes the existing CMN PMU usable on that hardware
without new APIs.

It meets stable rules as a quirk/ID exception: small, reviewed, no uAPI,
applies cleanly here because `56603c28d9169` already moved DTM arrays
out of `hw_perf_event`.

Risk vs benefit: extra bitmap bytes for all CMN users vs a working
interconnect PMU on Graviton5. Favorable.

Concerns: not a panic-class bug; depends on the DTM-index move (already
in this tree). No stable-list confirmation (fetch failed).

---

## Verification

- [Phase 1] Parsed tags: R-b Robin Murphy + Ilkka Koskinen; SOB Aviv
  Bakal, Robin Murphy, Will Deacon; no Fixes/Reported-by/Cc:stable
- [Phase 2] Diff: `drivers/perf/arm-cmn.c` +31/−1; HID `AMZN0070`,
  `CMN_MAX_DIMENSION` 14, DTC domain/logid workarounds
- [Phase 2] Current tree still has graviton5 paths at `arm_cmn_discover`
  / `arm_cmn_graviton5_dtc_domain` / ACPI table
- [Phase 3] `git describe HEAD` = v7.3-rc4-27-gf0100363d8c37; `make
  kernelversion` = 7.3.0-rc4
- [Phase 3] `git merge-base --is-ancestor 9d0b1714e1af1 HEAD` — yes; in
  v7.3-rc1, not v7.2
- [Phase 3] CMN-S3 `0dc2f4963f7ef` (2024-09-04) in tree; ACPI S3
  `8c138a189f6db` in tree
- [Phase 3] Mesh reject `36c0de02575ce` in tree; DTM move
  `56603c28d9169` in tree (series 1/2)
- [Phase 3] `git blame` on workaround lines → `9d0b1714e1af1`
- [Phase 3] No graviton follow-ups in `9d0b1714e1af1..HEAD`
- [Phase 4] `b4 dig -c 9d0b1714e1af1` → v6 2/2 msgid `e9340d3a4385e6f1a6
  e80bda944a3ba6435472b6.1782824005.git.robin.murphy@arm.com`
- [Phase 4] `b4 dig -a`: v1–v6; applied is v6
- [Phase 4] `b4 dig -w`: Will/Mark/Robin, linux-arm-kernel, linux-perf-
  users
- [Phase 4] Robin v2 review: must use `xp->logid` for firmware IRQ order
  (committed code does)
- [Phase 4] UNVERIFIED: lore.kernel.org/stable (403)
- [Phase 5] `arm_cmn_discover` only from `arm_cmn_probe`; ACPI match
  includes `AMZN0070`
- [Phase 6] Buggy discovery path and mesh check exist in this checkout;
  apply is clean
- [Phase 7] `CONFIG_ARM_CMN` depends on ARM64 || COMPILE_TEST
- [Phase 8] Failure: missing/wrong CMN PMU on Graviton5, not
  oops/deadlock; severity MEDIUM + quirk exception
- UNVERIFIED: Amazon Tested-by on silicon (not in tags)

**YES**

 drivers/perf/arm-cmn.c | 32 +++++++++++++++++++++++++++++++-
 1 file changed, 31 insertions(+), 1 deletion(-)

diff --git a/drivers/perf/arm-cmn.c b/drivers/perf/arm-cmn.c
index 527a953bf4744..688a94ef81c22 100644
--- a/drivers/perf/arm-cmn.c
+++ b/drivers/perf/arm-cmn.c
@@ -31,7 +31,8 @@
 #define CMN_CHILD_NODE_ADDR		GENMASK(29, 0)
 #define CMN_CHILD_NODE_EXTERNAL		BIT(31)
 
-#define CMN_MAX_DIMENSION		12
+/* Some implementations use a mesh larger than the architectural max of 12 */
+#define CMN_MAX_DIMENSION		14
 #define CMN_MAX_XPS			(CMN_MAX_DIMENSION * CMN_MAX_DIMENSION)
 #define CMN_MAX_DTMS			(CMN_MAX_XPS + (CMN_MAX_DIMENSION - 1) * 4)
 
@@ -215,6 +216,8 @@ enum cmn_part {
 	PART_CMN700 = 0x43c,
 	PART_CI700 = 0x43a,
 	PART_CMN_S3 = 0x43e,
+	/* Synthetic part number, overridden to PART_CMN_S3 during discovery */
+	PART_GRAVITON5 = 0xa5,
 };
 
 /* CMN-600 r0px shouldn't exist in silicon, thankfully */
@@ -2217,6 +2220,18 @@ static unsigned int arm_cmn_dtc_domain(struct arm_cmn *cmn, void __iomem *xp_reg
 	return FIELD_GET(CMN_DTM_UNIT_INFO_DTC_DOMAIN, readl_relaxed(xp_region + offset));
 }
 
+static unsigned int arm_cmn_graviton5_dtc_domain(u16 xp_id)
+{
+	unsigned int x = (xp_id >> 7) & 0xf;
+	unsigned int y = (xp_id >> 3) & 0xf;
+
+	/*
+	 * The unit info register reads as zero; derive the DTC domain from
+	 * the XP's mesh coordinates over the 10x14 mesh.
+	 */
+	return (x / 5) + (y / 7) * 2;
+}
+
 static void arm_cmn_init_node_info(struct arm_cmn *cmn, u32 offset, struct arm_cmn_node *node)
 {
 	int level;
@@ -2262,6 +2277,7 @@ static int arm_cmn_discover(struct arm_cmn *cmn, unsigned int rgn_offset)
 	u64 reg;
 	int i, j;
 	size_t sz;
+	bool graviton5_workaround = false;
 
 	arm_cmn_init_node_info(cmn, rgn_offset, &cfg);
 	if (cfg.type != CMN_TYPE_CFG)
@@ -2272,6 +2288,13 @@ static int arm_cmn_discover(struct arm_cmn *cmn, unsigned int rgn_offset)
 	reg = readq_relaxed(cfg_region + CMN_CFGM_PERIPH_ID_01);
 	part = FIELD_GET(CMN_CFGM_PID0_PART_0, reg);
 	part |= FIELD_GET(CMN_CFGM_PID1_PART_1, reg) << 8;
+
+	/* Graviton5 has a customised CMN-S3 which needs some fixups */
+	if (cmn->part == PART_GRAVITON5) {
+		cmn->part = PART_CMN_S3;
+		graviton5_workaround = true;
+	}
+
 	/* 600AE is close enough that it's not really worth more complexity */
 	if (part == PART_CMN600AE)
 		part = PART_CMN600;
@@ -2361,6 +2384,8 @@ static int arm_cmn_discover(struct arm_cmn *cmn, unsigned int rgn_offset)
 
 		if (cmn->part == PART_CMN600)
 			xp->dtc = -1;
+		else if (graviton5_workaround)
+			xp->dtc = arm_cmn_graviton5_dtc_domain(xp->id);
 		else
 			xp->dtc = arm_cmn_dtc_domain(cmn, xp_region);
 
@@ -2439,6 +2464,10 @@ static int arm_cmn_discover(struct arm_cmn *cmn, unsigned int rgn_offset)
 
 			switch (dn->type) {
 			case CMN_TYPE_DTC:
+				if (graviton5_workaround) {
+					/* Node info logical ID is zeroed; use the XP's */
+					dn->logid = xp->logid;
+				}
 				cmn->num_dtcs++;
 				dn++;
 				break;
@@ -2671,6 +2700,7 @@ static const struct acpi_device_id arm_cmn_acpi_match[] = {
 	{ "ARMHC650" },
 	{ "ARMHC700" },
 	{ "ARMHC003" },
+	{ "AMZN0070", PART_GRAVITON5 },
 	{}
 };
 MODULE_DEVICE_TABLE(acpi, arm_cmn_acpi_match);
-- 
2.53.0

