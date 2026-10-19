Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8CD6511882;
	Mon, 19 Oct 2026 13:56:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418211; cv=none; b=XqJ5oA2eRDxJShlSummIoPZDt8c0J7d2zmIuPCIdAP8d4rdwwCJ3OowuqnOsJMSHfQ3EDDkLbpCpCsqcmxVOjy4vEknGPs+gxDEdIqJf8ZXDLMzdFAoREq58FjFGd10G96tK+dcxJNyFndQa71WwRkpE4bTZtKBRZT2FK/1Sxig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418211; c=relaxed/simple;
	bh=1iXGcyE+mB3oSIh0oukTqsQovgY3iTPujs8Q57Sxv20=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Dv5CPTmkiKYW+f1Po1skHi1E5/r8kh7YCrTn4wNYWqwTfU42feYE9i6Bkdz5advsXisRD2QJ2/aZ+WsCftmVwU3839Yi3ZIDjeOi9LyYClDfa7cwMBX6RP6JQVeCY3pnQ0GtjeTQ0wAyRTCdN6CndcV+HmavMTLs8JI8KdDqVT8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YdBpICYO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YdBpICYO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B5051F000CA;
	Mon, 19 Oct 2026 13:56:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418208;
	bh=wtMA7tykm4p2klfOQZv9kTCziyui7WJUsRYmknVZgJs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YdBpICYOhjy4YmOfHXicTXkvevvAgita+gBd/4kYbiZISYyKwTMaIH71QJONbelf8
	 lv8ma7EJPvStLP5sg7zWZ+A2MwVE62rINy5fTH0QCWP20nAZiarDqqgY+Npzv69fzw
	 QVMPhjjl6gGTU0kEi4534nLPKplKTgADpWa4njECmGUqW1EyKOCIdww8/FsfRRJM0G
	 BDkqZexPH3t5t2hZtiXmvz/EE70zd3XT6xMJY7x9unayoNLpYLBF6CYsOnRceCdkJ3
	 V96RAnEBGUSvTu+IFNT7T8F/xfFLXG6oAUgfoQrOXGrm7FtitRClUNAER6wXnwNbN8
	 D15ubSbUIK8ag==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Aditya Sherawat <asherawa@qti.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Akhil P Oommen <akhilpo@oss.qualcomm.com>,
	Rob Clark <robin.clark@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>,
	lumag@kernel.org,
	airlied@gmail.com,
	simona@ffwll.ch,
	linux-arm-msm@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	freedreno@lists.freedesktop.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.12] drm/msm/adreno: Add support for A704 GPU
Date: Mon, 19 Oct 2026 09:46:20 -0400
Message-ID: <20261019135441.1420968-89-sashal@kernel.org>
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

From: Aditya Sherawat <asherawa@qti.qualcomm.com>

[ Upstream commit 1f69339da06255a7f8560b4768fff83992c03deb ]

Adreno A704 GPU found in Shikra is an IP reuse of A702 GPU with very
minimal changes. The only KMD facing difference is the chipid and the
zap firmware which is specified via devicetree.

Just add the new chipid to enable support for A704 GPU in Shikra.

Signed-off-by: Aditya Sherawat <asherawa@qti.qualcomm.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Signed-off-by: Akhil P Oommen <akhilpo@oss.qualcomm.com>
Patchwork: https://patchwork.freedesktop.org/patch/738931/
Message-ID: <20260710-shikra-gpu-v6-1-b388ec5dce77@oss.qualcomm.com>
Signed-off-by: Rob Clark <robin.clark@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The local checkout is **Linux 7.3.0-rc4**
(`v7.3-rc4-27-gf0100363d8c37`). The commit is a one-line Adreno chip-id
add on the existing A702 catalog entry; that is the textbook device-ID
exception, so the rest of the write-up is the forensic checklist behind
a YES for this tree.

===============================================================
PHASE 1: COMMIT MESSAGE FORENSICS
===============================================================

**Step 1.1: PARSE THE SUBJECT LINE**

Record: **[drm/msm/adreno] [Add] [register Adreno A704 chipid on the
existing A702 catalog entry]**

**Step 1.2: PARSE ALL COMMIT MESSAGE TAGS**

Record:
- **Fixes:** none (expected; this is new hardware ID enablement, not a
  regression fix)
- **Reported-by:** none
- **Tested-by:** none
- **Reviewed-by:** Konrad Dybcio `<konrad.dybcio@oss.qualcomm.com>`
  (listed reviewer of the msm/adreno driver); Dmitry Baryshkov
  `<dmitry.baryshkov@oss.qualcomm.com>` (msm display maintainer)
- **Acked-by:** none
- **Link:** none in the commit body; **Patchwork:**
  https://patchwork.freedesktop.org/patch/738931/; **Message-ID:**
  `<20260710-shikra-gpu-v6-1-b388ec5dce77@oss.qualcomm.com>` (explicit
  **v6 1/7** of the Shikra GPU series)
- **Cc: stable:** none (expected)
- **Signed-off-by:** Aditya Sherawat (author); Akhil P Oommen
  (msm/adreno reviewer/maintainer, listed in MAINTAINERS); Rob Clark
  (DRM msm maintainer, committer)
- Pipeline markers such as `Upstream commit` / `Signed-off-by: Sasha
  Levin` were ignored per instructions; none were present on the git
  object itself

**Step 1.3: ANALYZE THE COMMIT BODY TEXT**

Record:
- **Bug/problem:** Adreno A704 on Qualcomm **Shikra** is an IP reuse of
  A702. The kernel-facing difference is the chipid (`0x07000400` vs
  `0x07000200`); zap firmware is supplied via DT, not a new catalog
  firmware name.
- **Symptom:** without the chipid, `adreno_info()` does not match,
  `adreno_has_gpu()` warns `Unknown GPU revision` and returns false, and
  the GPU does not bind.
- **Version info:** none in the message. Git: commit is
  `1f69339da06255a7f8560b4768fff83992c03deb`, first contained in
  **v7.3-rc1**.
- **Root cause as stated:** missing catalog chipid; A704 is not a new
  GPU family.

**Step 1.4: DETECT HIDDEN BUG FIXES**

Record: **Not a hidden bug fix.** The subject is honest new-hardware
enablement. It still qualifies under the **new device-ID** stable
exception (one ID on an already-supported driver), not as a
crash/UAF/leak fix.

===============================================================
PHASE 2: DIFF ANALYSIS - LINE BY LINE
===============================================================

**Step 2.1: INVENTORY THE CHANGES**

Record:
- **File:** `drivers/gpu/drm/msm/adreno/a6xx_catalog.c` — **1 insertion,
  1 deletion** (2 lines changed, 1 file)
- **Function/object:** `static const struct adreno_info a7xx_gpus[]` —
  first entry (A702)
- **Scope:** single-file surgical ID add

**Step 2.2: UNDERSTAND THE CODE FLOW CHANGE**

Record:
- **Before:** that catalog entry matches only `chip_ids = {0x07000200,
  0}`.
- **After:** `{0x07000200, 0x07000400, 0}`.
- **Path:** GPU probe / `adreno_has_gpu()` → `find_chipid()` (DT
  compatible `qcom,adreno-07000400` or `qcom,chipid`) → `adreno_info()`
  walks `chip_ids[]`. A704 now returns the existing A702 `adreno_info`
  (same firmware `a702_sqe.fw`, same `a6xx_gmuwrapper_funcs`, same
  quirks). Systems without that chipid are unchanged.

**Step 2.3: IDENTIFY THE BUG MECHANISM**

Record: **[Hardware / device-ID enablement]** not UAF/leak/race.
Mechanism: catalog match table omitted `0x07000400`, so A704 never
bound. Fix: append the ID to the existing A702 row. Same pattern as
existing multi-id rows (e.g. A630 `0x06030001, 0x06030002`).

Verified detail: `adreno_is_a702()` compares `gpu->info->chip_ids[0] ==
0x07000200`. A702 remains first, so A704 still takes the A702 code paths
— consistent with “IP reuse”.

**Step 2.4: ASSESS THE FIX QUALITY**

Record: **Obviously correct and minimal.** No API, locking, or struct-
layout change. Regression risk is **very low**: unknown chipids still
miss; only `0x07000400` newly matches, and it reuses the already-shipped
A702 programming. Zap firmware override remains DT `firmware-name`
(`adreno_gpu.c`).

===============================================================
PHASE 3: GIT HISTORY INVESTIGATION
===============================================================

**Step 3.1: BLAME THE CHANGED LINES**

Record:
- Current line is this commit (`1f69339da06255`).
- Surrounding A702 entry comes from catalog split **`2e819c420e5b8`**
  (Rob Clark, 2024-06-18) and A702 support **`18397519cb622`**
  (“drm/msm/adreno: Add A702 support”), first contained in **v6.9-rc1**.
- A702 code has been in-tree for many releases; this is not last-month-
  only infrastructure.

**Step 3.2: FOLLOW THE FIXES: TAG**

Record: **No Fixes: tag.** N/A. There is no “introduced the bug” SHA;
the gap is a new chipid on existing IP.

**Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES**

Record:
- Immediate neighbors in `a6xx_catalog.c`: A810 support, A722 support,
  GBIF rename, A730 hwcg fix — unrelated GPU SKUs.
- **Series:** Message-ID is **v6 1/7** “drm/msm: Add support for Shikra
  GPU (A704)”. Rest of series: dt-binding `qcom,adreno-07000400`, SMMU
  binding, Shikra GPU/SMMU/cooling DT, EVK enable.
- Binding commit **`9479a45e5f59c`** is in this tree
  (`qcom,adreno-07000400` in `gpu.yaml`).
- This catalog patch is **standalone** as a match-table add; it does not
  call new helpers.

**Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS**

Record: Aditya Sherawat has this one msm/adreno commit in the path-
limited log. Submitted via **Akhil P Oommen** (MAINTAINERS reviewer for
Adreno) and merged by **Rob Clark**. Weight is from reviewer/maintainer
trailers, not author volume.

**Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS**

Record:
- Needs the A702 `a7xx_gpus[]` row and `ADRENO_CHIP_IDS()` — both
  present here.
- Does **not** need the rest of the 7-patch DT series to be correct or
  safe.
- Cover letter listed many Shikra SoC prerequisites; those apply to
  **board GPU bring-up**, not to appending a chipid.
- **Can apply standalone: yes.**

===============================================================
PHASE 4: MAILING LIST AND EXTERNAL RESEARCH
===============================================================

**Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION**

Record:
- `b4 dig -c 1f69339da06255`: **[PATCH v6 1/7] drm/msm/adreno: Add
  support for A704 GPU** — https://patch.msgid.link/20260710-shikra-
  gpu-v6-1-b388ec5dce77@oss.qualcomm.com
- `b4 dig -a`: v1 (2026-06-09, 2 patches, bindings-first) through **v6
  (2026-07-10, 7 patches)**. Applied version is latest (v6).
- Cover letter (v5 mbox, same change-id): A704 is A702 reuse; Mesa
  already merged
  (gitlab.freedesktop.org/mesa/mesa/-/merge_requests/41762). DT bits
  added from v3.
- Reviews on this patch: R-b Konrad, R-b Dmitry. **No NAK** on the
  chipid patch. Dmitry’s only v5 comment was parsing of the **GPU
  cooling DT** commit (patch 6), unrelated to the chipid.
- **No reviewer Cc: stable** on this patch.

**Step 4.2: CHECK WHO REVIEWED THE PATCH**

Record (`b4 dig -w`): To/Cc included Rob Clark, Konrad Dybcio, Dmitry
Baryshkov, Akhil P Oommen, linux-arm-msm, dri-devel, freedreno, DT list.
Right maintainers and lists.

**Step 4.3: SEARCH FOR THE BUG REPORT**

Record: **No syzbot/bugzilla/user crash.** Intent is enablement of
Shikra A704, not a fuzzer bug. Cover letter is the “report”.

**Step 4.4: CHECK FOR RELATED PATCHES AND SERIES**

Record: 7-patch Shikra GPU series. This commit is **1/7** and is the
only KMD catalog change. Later patches are bindings/DT. Not a “2/3 logic
fix that is incomplete alone”.

**Step 4.5: CHECK STABLE MAILING LIST HISTORY**

Record: `https://lore.kernel.org/stable/?q=A704+adreno` → **[No results
found]**. No stable request and no documented rejection.

===============================================================
PHASE 5: CODE SEMANTIC ANALYSIS
===============================================================

**Step 5.1: IDENTIFY KEY FUNCTIONS IN THE DIFF**

Record: No function body edited. Data: `a7xx_gpus[]`. Consumers:
`adreno_info()`, `adreno_has_gpu()`, `adreno_bind()`.

**Step 5.2: TRACE CALLERS**

Record:
- `adreno_info()`: used from `adreno_has_gpu()` and `adreno_bind()`.
- `adreno_has_gpu()` / bind: OF GPU device probe (drm/msm), not a
  syscall-hot path.
- Context: platform probe, process context.

**Step 5.3: TRACE CALLEES**

Record: After match, `info->funcs->init` is existing
`&a6xx_gmuwrapper_funcs`. No new callees.

**Step 5.4: FOLLOW THE CALL CHAIN**

Record: userspace cannot invent a chipid; DT/firmware describes the GPU.
Reachable on Shikra (or any board with `qcom,adreno-07000400`). **Not**
a universal mm/fs path. Without a GPU node the new ID is inert.

**Step 5.5: SEARCH FOR SIMILAR PATTERNS**

Record: Multiple `ADRENO_CHIP_IDS(id1, id2)` rows already exist (A630
and others). This is the standard alias-SKU pattern.

===============================================================
PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE
===============================================================

**Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?**

Record:
- Tree: **7.3.0-rc4** (mainline -rc, `HEAD` `f0100363d8c37`).
- `a6xx_catalog.c` A702 row exists; **this commit is already an ancestor
  of HEAD** (`git merge-base --is-ancestor 1f69339da06255 HEAD` → yes).
  Current source already has `ADRENO_CHIP_IDS(0x07000200, 0x07000400)`.
- A702 support: **v6.9-rc1**; catalog file since **`2e819c420e5b8`**.
- Missing-id problem is real for any 7.3-based kernel that lacked this
  SHA; this checkout already contains the ID.

**Step 6.2: CHECK FOR BACKPORT COMPLICATIONS**

Record: **Clean apply** onto the A702 row in this tree (already
applied). No conflicting hunk. `a6xx_gmuwrapper_funcs` is present
(`491fadb2b818e`).

**Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE**

Record: Binding `9479a45e5f59c` is here. Shikra `shikra.dtsi` has GPUCC
but **no `gpu@` / `qcom,adreno-07000400` node** in this checkout — DT
enablement from later series patches is incomplete here, which does
**not** make the chipid harmful.

===============================================================
PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT
===============================================================

**Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY**

Record: **drm/msm/adreno** (Qualcomm GPU). **IMPORTANT** for MSM/Adreno
devices, not core mm/vfs. Peripheral relative to the whole kernel;
important for Shikra and any other A704 SKU.

**Step 7.2: ASSESS SUBSYSTEM ACTIVITY**

Record: **Active** — recent catalog churn (A810, A722, A840, X2-85).
Maintained by Rob Clark / Akhil / Konrad. Mature A702 path since v6.9;
this ID rides that path.

===============================================================
PHASE 8: IMPACT AND RISK ASSESSMENT
===============================================================

**Step 8.1: DETERMINE WHO IS AFFECTED**

Record: **driver/platform-specific** — Adreno A704 / Shikra. No effect
on other GPUs. `CONFIG_DRM_MSM` users only.

**Step 8.2: DETERMINE THE TRIGGER CONDITIONS**

Record: Probe of a GPU node whose parsed chipid is `0x07000400`. Common
on that SoC, never on others. Unprivileged users do not trigger a new
attack surface; they only get a working GPU after bind.

**Step 8.3: DETERMINE THE FAILURE MODE SEVERITY**

Record: Without the ID: GPU not recognized, no bind, no display/compute
on that SoC — **not** panic/UAF. **Severity: MEDIUM for those devices**
(hardware dead), **LOW for everyone else**. Device-ID exception treats
that as backport-worthy enablement.

**Step 8.4: CALCULATE RISK-BENEFIT RATIO**

Record:
- **Benefit:** A704/Shikra GPU can bind using the already-supported A702
  path; Mesa support already exists per cover letter.
- **Risk:** very low (1-token ID, existing row, no hot-path/locking).
- **Ratio:** high benefit for that hardware, negligible risk.

===============================================================
PHASE 9: FINAL SYNTHESIS
===============================================================

**Step 9.1: COMPILE THE EVIDENCE**

**FOR:**
- Classic **new device ID** on an existing driver (A702 since v6.9).
- One-line, obviously correct; A704 is documented IP reuse of A702.
- Matching already supports multiple `chip_ids`; A702 stays
  `chip_ids[0]` so `adreno_is_a702()` still works.
- Reviewed by Konrad Dybcio and Dmitry Baryshkov; signed off by Akhil P
  Oommen; merged by Rob Clark.
- Inert on machines without chipid `0x07000400`.
- Local tree has the A702 catalog row, macros, and probe path; patch
  applies (and is already in 7.3-rc1+).

**AGAINST:**
- Not a crash/security/corruption fix; it is new SKU enablement.
- Part of a 7-patch Shikra GPU series (DT still incomplete in this dts).
- No syzbot/user crash, no Cc: stable, no stable@ discussion.
- Author is not a high-volume subsystem regular (mitigated by maintainer
  R-b/SOB).

**UNRESOLVED:**
- lore HTML for the v6 thread was 403 via WebFetch; discussion was
  recovered via `b4 dig` + mbox (v5 thread saved; v6 is the applied
  revision with the same chipid hunk).
- Whether every Shikra EVK DT patch is in 7.3-rc4: GPU node not found in
  `shikra*.dts*`; does not change chipid safety.

**Step 9.2: APPLY THE STABLE RULES CHECKLIST**

1. Obviously correct and tested? **PASS** — one ID, two msm maintainers
   R-b, merged by drm/msm maintainer; Mesa noted as already merged.
2. Fixes a real bug that affects users? **PASS** (via device-ID
   exception) — without the ID, A704 never matches and the GPU does not
   probe.
3. Important issue (crash, security, corruption, deadlock)? **PASS**
   under the **new device-ID exception**, not as a critical memory-
   safety fix. Severity for A704 owners is missing GPU, not oops.
4. Small and contained? **PASS** — 1 file, +1/-1.
5. No new features or APIs? **PASS** — no new uAPI/driver; only a chipid
   alias on existing A702 code.
6. Can apply to the local tree? **PASS** — A702 row and
   `ADRENO_CHIP_IDS` exist; commit is already in this 7.3-rc4 history.

**Step 9.3: CHECK FOR EXCEPTION CATEGORIES**

Record: **NEW DEVICE ID on an existing driver** (Adreno catalog chipid ≡
PCI/USB ID add). DT exception would apply to later series patches, not
this one.

**Step 9.4: MAKE YOUR DECISION**

This tree is **7.3.0-rc4**. The A702 driver and catalog entry are
present. The patch is a one-line chipid add, which stable policy
explicitly allows. It does not need the rest of the Shikra DT series to
be correct. Benefit is enabling A704; risk is negligible. That is a YES
for this tree.

---

**What the commit solves for users of this tree:** A704 reports chipid
`0x07000400`. Without it, drm/msm logs unknown revision and skips the
GPU. With it, the existing A702 path runs (SQE firmware, GMU wrapper,
quirks). Zap firmware stays DT-overridable.

**Stable rules:** small, reviewed, no new API; qualifies as a device-ID
add, not as a sanitizer/crash fix.

**Risk vs benefit:** very low risk, real hardware enablement for
Shikra/A704.

**Concerns:** series 1/7; DT GPU node may still be missing on Shikra in
this checkout — that does not make the ID unsafe. No crash-fix urgency.

Verification:
- [Phase 1] Subject/tags: no Fixes/Reported-by/Cc:stable; R-b Konrad +
  Dmitry; SOB Akhil + Rob Clark; Message-ID v6-1/7
- [Phase 1] Body: A704 = A702 reuse; difference is chipid + DT zap
- [Phase 2] `git show 1f69339da06255`: `a6xx_catalog.c` +1/-1,
  `ADRENO_CHIP_IDS(0x07000200, 0x07000400)`
- [Phase 2] `adreno_is_a702()` uses `chip_ids[0] == 0x07000200` — A702
  remains first
- [Phase 2] `adreno_info()` matches any `chip_ids[k]`
  (`adreno_device.c:59-61`)
- [Phase 3] `git describe --match 'v*' --contains 18397519cb622` → A702
  in **v6.9-rc1**
- [Phase 3] `git describe --match 'v*' --contains 1f69339da06255` → A704
  in **v7.3-rc1**
- [Phase 3] blame: A702 row from `2e819c420e5b8`; this line from
  `1f69339da06255`
- [Phase 3] no Fixes: tag; standalone vs DT series
- [Phase 4] `b4 dig -c`: lore/msgid v6 1/7; `-a`: v1–v6; `-w`: msm
  maintainers + lists
- [Phase 4] mbox `/tmp/a704-thread.mbox`: v5 0–7/7 subjects; R-b on
  chipid; Dmitry comment only on cooling DT
- [Phase 4] lore.kernel.org/stable `A704 adreno`: no hits
- [Phase 4] WebFetch lore/patchwork: 403/Anubis; discussion taken from
  b4/mbox instead
- [Phase 5] probe path `find_chipid` → `adreno_info` →
  `info->funcs->init`; grep callers verified
- [Phase 5] similar multi-id: A630 `0x06030001, 0x06030002`
- [Phase 6] `git describe HEAD` → **v7.3-rc4-27-gf0100363d8c37**; `make
  kernelversion` → **7.3.0-rc4**
- [Phase 6] `git merge-base --is-ancestor 1f69339da06255 HEAD` → yes
  (already in this tree)
- [Phase 6] `gpu.yaml` contains `qcom,adreno-07000400` via
  `9479a45e5f59c`
- [Phase 6] no `gpu@` / adreno compatible in
  `arch/arm64/boot/dts/qcom/shikra*`
- [Phase 7] MAINTAINERS: Rob Clark / Konrad / Akhil for
  `drivers/gpu/drm/msm/adreno/`
- [Phase 8] failure mode: unknown GPU, no bind; not oops; device-ID
  exception
- UNVERIFIED: full v6 lore HTML (403); whether Shikra EVK GPU DT landed
  under a different subject

**YES**

 drivers/gpu/drm/msm/adreno/a6xx_catalog.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/msm/adreno/a6xx_catalog.c b/drivers/gpu/drm/msm/adreno/a6xx_catalog.c
index b43850966a5f6..bbfee7fef6dc0 100644
--- a/drivers/gpu/drm/msm/adreno/a6xx_catalog.c
+++ b/drivers/gpu/drm/msm/adreno/a6xx_catalog.c
@@ -1417,7 +1417,7 @@ DECLARE_ADRENO_REGLIST_LIST(a750_ifpc_reglist);
 
 static const struct adreno_info a7xx_gpus[] = {
 	{
-		.chip_ids = ADRENO_CHIP_IDS(0x07000200),
+		.chip_ids = ADRENO_CHIP_IDS(0x07000200, 0x07000400),
 		.family = ADRENO_6XX_GEN1, /* NOT a mistake! */
 		.fw = {
 			[ADRENO_FW_SQE] = "a702_sqe.fw",
-- 
2.53.0

