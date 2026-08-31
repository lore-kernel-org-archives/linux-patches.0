Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5245E5083BA;
	Mon, 31 Aug 2026 13:42:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183748; cv=none; b=TQa5fzJqFrB2b+WFAv6AFZG80CA2NVYOVPjPOVsuFL5wLgnv7kf89vxbxn3J7ck5FuoclNmaeww741FEkKgDy8VQSCAZMaGtneVHNVzdM6YjxNPKtYjkhQxqhjc0YRtdM9+54xltMd94QGUI9RM73G7b6PVz8foiUJhmBvBV6wQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183748; c=relaxed/simple;
	bh=kODEKTy31iVyNAgfSs1OhbB6x0ysHistFz6mDpQwqME=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ToTvcv4ovYDKnhOaM14efZM9HUdSN17Qbq2htBd5RmWWvxtqfTQGsS0np0vtO01uoDzI32HpWytWWzATou4z330ATLBvOHLw5vgG3E6TiZcKC7OkUUJAoCPiTnF/FKTvRVeETSf20M097ySk4Bmxq4k3GshZ+/hRxSUxDXvkTXM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GTX+CCBG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GTX+CCBG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF3F41F00ADB;
	Mon, 31 Aug 2026 13:42:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183746;
	bh=2snaxlnwBvKp12KEOFcIunRxCJsX0dN+U8uJnsJGq24=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GTX+CCBGJfC0nd7+9Yh/Uk/zdncAbPegIVEcoRMFQVmI4jVC1I0LG0ZLvdnlmDMXD
	 XJ77kwFYqqqJ9T42tYBQdGc0+Ae1YNwCOSCgj0sHljf/RK12XNQA78Je17xXJmNdzH
	 dhC0bR0WM631hKw6uNNjOfqOhFYt/600GGrNdXyt7Lbb4A9BmxKMz/jTDSA4zPoCW9
	 bV4u9hwJw+H9B6JZ2hYNcKpBt28ei+KZTYdlJcHoT5T4L5D8v9S+AsJe/yyj/7MqiX
	 8tfaIDmW3bi/RKbIeGBy1ubhTNOhffrRZZfmwZHdF/t6LNeS5gmk9cHVOzHlziZmxw
	 BI2ssSaL+CNOw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Timur Tabi <ttabi@nvidia.com>,
	Danilo Krummrich <dakr@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	lyude@redhat.com,
	maarten.lankhorst@linux.intel.com,
	mripard@kernel.org,
	tzimmermann@suse.de,
	airlied@gmail.com,
	simona@ffwll.ch,
	dri-devel@lists.freedesktop.org,
	nouveau@lists.freedesktop.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.6] drm/nouveau/gsp: add SEC2 to GA100 chip table
Date: Mon, 31 Aug 2026 09:25:07 -0400
Message-ID: <20260831133314.4125787-279-sashal@kernel.org>
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

From: Timur Tabi <ttabi@nvidia.com>

[ Upstream commit 604d0efb17cc0dd197e089134736ac2698d5fca7 ]

The booter-load and booter-unload firmware run on the SEC2 falcon.
During tu102_gsp_oneinit(), the booter constructor needs device->sec2
to access the SEC2 falcon.

Without the .sec2 entry, device->sec2 is NULL and this dereference
crashes during GSP-RM boot.

Signed-off-by: Timur Tabi <ttabi@nvidia.com>
Link: https://patch.msgid.link/20260430223838.2530778-3-ttabi@nvidia.com
Signed-off-by: Danilo Krummrich <dakr@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: `drm/nouveau/gsp: add SEC2 to GA100 chip
table`

**Local tree:** `v6.18.44` (stable/linux-6.18.y)
**Commit under review:** `604d0efb17cc0` (on `origin/master`, not yet in
this tree)

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Subject line
**Record:** `[drm/nouveau/gsp]` `[add]` — Add missing SEC2 engine entry
to the GA100 (`nv170`) chipset table so GSP-RM boot can access the SEC2
falcon.

### Step 1.2: Tags
**Record:**
- **Signed-off-by:** Timur Tabi `<ttabi@nvidia.com>` (author)
- **Signed-off-by:** Danilo Krummrich `<dakr@kernel.org>` (DRM
  maintainer committer)
- **Link:**
  https://patch.msgid.link/20260430223838.2530778-3-ttabi@nvidia.com
- No `Fixes:`, `Reported-by:`, `Cc: stable@vger.kernel.org`, or `Tested-
  by:`

Notable: part of **PATCH v2 02/10** in series “drm/nouveau: fix GA100
issues”. Absence of stable tag is expected for manual review.

### Step 1.3: Body analysis
**Record:**
- **Bug:** `device->sec2` is NULL on GA100 because `nv170_chipset` lacks
  a `.sec2` entry.
- **Symptom:** NULL pointer dereference during GSP-RM boot in
  `tu102_gsp_oneinit()`.
- **Mechanism:** Booter-load/unload firmware runs on the SEC2 falcon;
  booter constructor needs `device->sec2->falcon`.
- **Root cause:** Oversight when GSP was wired into the GA100 chip table
  without the matching SEC2 entry.

### Step 1.4: Hidden bug fix?
**Record:** No — this is an explicit crash fix (NULL deref), not
disguised cleanup.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory
**Record:**
- **Files:** `drivers/gpu/drm/nouveau/nvkm/engine/device/base.c` (+1
  line)
- **Function/structure:** `nv170_chipset` static chip table
- **Scope:** Single-file, surgical one-liner

### Step 2.2: Code flow change
**Record:**
- **Before:** GA100 chip table has `.gsp = ga100_gsp_new` but no
  `.sec2`; `device->sec2` stays NULL after device construction.
- **After:** `.sec2 = { 0x00000001, tu102_sec2_new }` is added; SEC2 is
  instantiated like other Turing/Ampere GSP-RM platforms.
- **Path affected:** Device probe → subdev construction → GSP `oneinit`
  → booter constructor.

### Step 2.3: Bug mechanism
**Record:** **Category:** NULL pointer dereference
**Mechanism:** `tu102_gsp_oneinit()` unconditionally dereferences
`device->sec2->falcon`:

```307:313:drivers/gpu/drm/nouveau/nvkm/subdev/gsp/tu102.c
        ret = gsp->func->booter.ctor(gsp, "booter-load",
gsp->fws.booter.load,
                                     &device->sec2->falcon,
&gsp->booter.load);
        if (ret)
                return ret;

        ret = gsp->func->booter.ctor(gsp, "booter-unload",
gsp->fws.booter.unload,
                                     &device->sec2->falcon,
&gsp->booter.unload);
```

`ga100_gsp` uses this same `oneinit` handler:

```53:54:drivers/gpu/drm/nouveau/nvkm/subdev/gsp/ga100.c
        .dtor = r535_gsp_dtor,
        .oneinit = tu102_gsp_oneinit,
```

### Step 2.4: Fix quality
**Record:** Obviously correct — mirrors every other GSP-RM-capable
Turing chipset (e.g. `nv164_chipset` at line 2508 uses
`tu102_sec2_new`). Minimal risk; no API or behavioral change beyond
enabling a subdev that was always required.

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame
**Record:**
- `nv170_chipset` introduced in `3b050680c8415` (Jan 2021, “recognise
  GA10[024]”).
- `.gsp = ga100_gsp_new` added in `015ef6187f69e` (Sep 2023, “prepare
  for GSP-RM”) — **this is when the bug was introduced**.
- `.sec2` never added to `nv170_chipset` until `604d0efb17cc0`.

### Step 3.2: Fixes: tag
**Record:** N/A — no `Fixes:` tag. Bug introduced by `015ef6187f69e`,
which is present in this stable tree.

### Step 3.3: Related file history
**Record:** Related GA100 work on master (not in 6.18.44):
`20e0c197802c5` (add GA100 GSP support), `0094a7a95d52b` (WPR
placement), `f0de0f89cc1e0` (require GSP-RM), `61de054a772a1` (formally
support GA100). This SEC2 commit is patch 2/10 of v2 series but is
**standalone** for the NULL-deref it fixes.

### Step 3.4: Author context
**Record:** Timur Tabi (NVIDIA) authored the GA100 fix series. Reviewed
on list by Lyude Paul (nouveau maintainer). Committed by Danilo
Krummrich (DRM maintainer).

### Step 3.5: Dependencies
**Record:** No hard dependencies. `tu102_sec2_new` exists in this tree
since `8d2c1e337604f` (2019). Patch applies cleanly (`git apply --check`
passes). Self-contained.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: Original discussion
**Record:** `b4 dig -c 604d0efb17cc0` found thread: [PATCH v2 02/10] at
https://patch.msgid.link/20260430223838.2530778-3-ttabi@nvidia.com.
Series: v1 (6 patches, Apr 7) → v2 (10 patches, Apr 30).

### Step 4.2: Reviewers
**Record:** `b4 dig -w` — CC'd: Lyude Paul, Danilo Krummrich, David
Airlie, nouveau@lists.freedesktop.org. **Reviewed-by: Lyude Paul** found
in mbox for the series.

### Step 4.3: Bug report
**Record:** No external bug report or syzbot link. Bug identified by
code analysis during GA100 bring-up.

### Step 4.4: Related patches
**Record:** Part of “fix GA100 issues” series. Other patches improve WPR
placement, FRTS handling, and formal GA100 enablement. This commit fixes
a crash independent of those follow-ups.

### Step 4.5: Stable list discussion
**Record:** No explicit `Cc: stable` nomination found in saved mbox. Not
a negative signal.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Key functions
**Record:** `nv170_chipset` (chip table), `tu102_sec2_new`,
`tu102_gsp_oneinit`, `ga100_gsp_new`.

### Step 5.2: Callers
**Record:** Chip table entries drive `NVKM_LAYOUT_ONCE` macros in
`nvkm_device_ctor()` (`base.c` ~3412). `tu102_gsp_oneinit` called via
`nvkm_gsp_oneinit` during `nvkm_device_init()` subdev init loop.

### Step 5.3: Callees
**Record:** `tu102_sec2_new` → `r535_sec2_new` when GSP-RM is active
(`nvkm_gsp_rm(device->gsp)`). Booter constructor uses SEC2 falcon
registers.

### Step 5.4: Reachability
**Record:** Triggered on GA100 probe when:
1. `NvEnableUnsupportedChipsets=1` (required in 6.18.44 — case `0x170`
   only in unsupported path at line 3362–3364)
2. GSP-RM firmware loads (default `NvGspRm=true` in `tu102_gsp_load_rm`)

Driver load / module init path — reachable by root loading `nouveau` on
A100 hardware.

### Step 5.5: Similar patterns
**Record:** All TU10x chipsets (`nv164`–`nv168`) and GA102+ have `.sec2`
entries. GA100 is the sole GSP-enabled chipset missing it.

---

## PHASE 6: CROSS-REFERENCE AGAINST LOCAL TREE (6.18.44)

### Step 6.1: Buggy code present?
**Record:** **YES.** `nv170_chipset` at lines 2512–2532 has `.gsp` but
no `.sec2`. Commit `604d0efb17cc0` is on master but not in `v6.18.44`.

### Step 6.2: Backport complications
**Record:** **Clean apply** — verified with `git apply --check`. No
conflicts expected.

### Step 6.3: Related fixes already present?
**Record:** No alternate fix for this issue in 6.18.44. Grep shows no
`.sec2` in `nv170_chipset`.

---

## PHASE 7: SUBSYSTEM CONTEXT

### Step 7.1: Subsystem criticality
**Record:** `drivers/gpu/drm/nouveau` — **IMPORTANT** (GPU driver,
affects GA100/A100 users).

### Step 7.2: Activity
**Record:** GSP subsystem actively maintained; multiple GSP fixes in
6.18.y history.

---

## PHASE 8: IMPACT AND RISK

### Step 8.1: Who is affected
**Record:** GA100 (NVIDIA A100) users running nouveau with GSP-RM.
Narrow hardware population but high-value datacenter GPUs. In 6.18.44,
requires `NvEnableUnsupportedChipsets=1`.

### Step 8.2: Trigger conditions
**Record:** GA100 hardware + nouveau module load + GSP-RM path. GSP-RM
is default-on (`nvkm_boolopt(..., "NvGspRm", true)`). Trigger is
deterministic on affected config, not a race.

### Step 8.3: Failure mode severity
**Record:** **CRITICAL** — kernel oops / NULL pointer dereference during
driver initialization. GPU completely non-functional; potential system
instability.

### Step 8.4: Risk-benefit
**Record:**
- **Benefit:** HIGH for GA100 users — prevents guaranteed crash on GSP-
  RM boot
- **Risk:** VERY LOW — one line, matches established pattern, no new
  APIs
- **Ratio:** Strongly favorable

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence summary

**FOR backport:**
- Real, reproducible NULL pointer dereference
- Kernel crash on driver init (CRITICAL severity)
- One-line, obviously correct fix
- Bug introduced in-tree by `015ef6187f69e` (Sep 2023) and present since
- Applies cleanly to 6.18.44
- Reviewed by nouveau maintainer (Lyude Paul)
- Matches how all sibling GSP-RM chipsets are configured

**AGAINST backport:**
- GA100 still requires `NvEnableUnsupportedChipsets` in 6.18.44 (limited
  exposure)
- Full GA100 support series not yet in stable (other patches may also be
  needed for complete GA100 functionality, but not for this specific
  crash fix)

**Unresolved:** No user crash reports or syzbot reproduction found (bug
found during development).

### Step 9.2: Stable rules checklist
1. Obviously correct and tested? **PASS** — mirrors TU10x pattern;
   reviewed on list
2. Fixes a real bug? **PASS** — NULL deref with clear code path
3. Important issue? **PASS** — kernel oops on GPU probe/init
4. Small and contained? **PASS** — 1 line, 1 file
5. No new features/APIs? **PASS** — enables existing subdev constructor
   already used elsewhere
6. Can apply to local tree? **PASS** — clean apply verified

### Step 9.3: Exception categories
**Record:** Hardware enablement fix for existing driver — analogous to
missing chip-table entry quirk. Not a new driver.

### Step 9.4: Decision rationale

When GSP-RM support was added to the GA100 chip table in September 2023,
the matching SEC2 entry was omitted. Because `ga100_gsp` uses
`tu102_gsp_oneinit()`, which unconditionally accesses
`device->sec2->falcon`, any attempt to boot GSP-RM on GA100 in this tree
crashes. The fix is a single missing table entry — the same
`tu102_sec2_new` used by all Turing GSP-RM platforms — and it applies
cleanly to v6.18.44.

Even though GA100 remains behind `NvEnableUnsupportedChipsets` in this
stable release, users who enable it for A100 testing will hit this crash
deterministically. The fix is minimal, low-risk, and prevents a serious
initialization failure.

---

## Verification

- [Phase 1] Parsed subject, tags, body; identified NULL-deref crash
  during GSP-RM boot
- [Phase 2] Read diff (+1 line to `nv170_chipset`); traced
  `tu102_gsp_oneinit()` NULL deref at lines 307–313
- [Phase 3] `git describe HEAD` → v6.18.44; `git blame` → GSP added to
  GA100 in `015ef6187f69e`, sec2 never added
- [Phase 3] `git show 015ef6187f69e` confirmed GSP added without SEC2;
  bug commit is in this tree
- [Phase 3] `git log v6.18.44..origin/master` → commit `604d0efb17cc0`
  on master, not in stable
- [Phase 4] `b4 dig -c 604d0efb17cc0` → lore URL found; v2 02/10 of
  10-patch series
- [Phase 4] `b4 dig -a` → v1 and v2 series revisions listed
- [Phase 4] `b4 dig -w` → Lyude Paul, Danilo Krummrich, Airlie CC'd
- [Phase 4] mbox grep → Reviewed-by: Lyude Paul; no stable nomination
- [Phase 5] Confirmed `ga100_gsp.oneinit = tu102_gsp_oneinit` in
  `ga100.c`
- [Phase 5] Confirmed `tu102_sec2_new` exists and handles GSP-RM via
  `r535_sec2_new`
- [Phase 5] Confirmed GA100 only enabled with
  `NvEnableUnsupportedChipsets` at `base.c:3362`
- [Phase 6] Confirmed `nv170_chipset` lacks `.sec2` in current tree
  (lines 2512–2532)
- [Phase 6] `git apply --check` on commit patch → applies cleanly
- [Phase 8] Failure mode: NULL deref → kernel oops, severity CRITICAL

**YES****Verdict: YES** — backport to this tree (v6.18.44).

The background checks confirmed `604d0efb17cc0` ("add SEC2 to GA100 chip
table") is on `origin/master` but not in stable/linux-6.18.y. In the
current tree, `nv170_chipset` has GSP support but no `.sec2` entry, so
`tu102_gsp_oneinit()` will NULL-deref `device->sec2` during GSP-RM boot
on GA100.

The fix is a one-line addition (`.sec2 = { 0x00000001, tu102_sec2_new
}`) that matches other Turing GSP-RM chipsets and applies cleanly.

 drivers/gpu/drm/nouveau/nvkm/engine/device/base.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/nouveau/nvkm/engine/device/base.c b/drivers/gpu/drm/nouveau/nvkm/engine/device/base.c
index a965914f1c2fb..0dab8b6cbf9f3 100644
--- a/drivers/gpu/drm/nouveau/nvkm/engine/device/base.c
+++ b/drivers/gpu/drm/nouveau/nvkm/engine/device/base.c
@@ -2529,6 +2529,7 @@ nv170_chipset = {
 	.vfn      = { 0x00000001, ga100_vfn_new },
 	.ce       = { 0x000003ff, ga100_ce_new },
 	.fifo     = { 0x00000001, ga100_fifo_new },
+	.sec2     = { 0x00000001, tu102_sec2_new },
 };
 
 static const struct nvkm_device_chip
-- 
2.53.0

