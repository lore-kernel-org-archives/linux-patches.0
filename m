Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8ACD3D903E;
	Mon, 20 Apr 2026 13:23:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776691435; cv=none; b=fhccBTIxNnWJ2bJHrODfJSpBkIInRgk1VJWs5AJSDQzqxXVhZkpP1xhfj5MniUWKQI4IC89Qfud8JAscwlSAMAFjYODIgoVVWG6aSOwVFyTke0oWh7LaGMCk6sfPk/fVz8YBdnsnWVELEPqLRk1QbRUbofIKoqMtLQg8Rcnj1Jw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776691435; c=relaxed/simple;
	bh=A+lz1RTkj2e9lOQtV5fCe9QkLphGB6D5KjK3efFNNvo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cgrYrO9imJCpFRjybyu6eSPwX86yCcok9NGAOMRIDCC3vrquPXAsnF54n1dJ2xApKwG0wpE1KPDcRIpxlFXgUN25/za4d34I1U5I7piXzAv5DsmPjfl6qdpRScA4/fsmDBDWeDzohFtPLH9AOCob0PEBVstcnkL3dtT+/122Gbg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HIQmwqvE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HIQmwqvE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C6F9C2BCB4;
	Mon, 20 Apr 2026 13:23:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776691435;
	bh=A+lz1RTkj2e9lOQtV5fCe9QkLphGB6D5KjK3efFNNvo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HIQmwqvEtlCadL/Et0zBZe15EzcZ7z9V72sBJ2USWVjVPwJ+4eLhQXT1jK2n5jMPS
	 2F1hh7oiCO6mPdRcreE0oXcrZaXtn+frOCNOc0tH7PmaboCR8ZcRJ+jojtuMQ4QdI+
	 O6xvhmBQ8qomoWVNKlRsXgrdUK6cGBM0mliy8tz9EmKtal+Qd3+KXm/sbAzop/o2K8
	 R4X0edLPgwsbenVNRqsi7vOjTPyHumO3fzSVvjCY43ZqzqOq+Yfyu9D5Oaiyb6m7r2
	 rQi5zGiUcfKyQbRNYGrYrDom10F3M0gRucHqYyFaVX7GJKRwS3lXscNii9quRO3J4t
	 BOLyd3n6A0FrQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Erik Kurzinger <ekurzinger@gmail.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>,
	harry.wentland@amd.com,
	sunpeng.li@amd.com,
	christian.koenig@amd.com,
	airlied@gmail.com,
	simona@ffwll.ch,
	amd-gfx@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0-6.12] drm/amd/display: remove duplicate format modifier
Date: Mon, 20 Apr 2026 09:16:59 -0400
Message-ID: <20260420132314.1023554-25-sashal@kernel.org>
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

From: Erik Kurzinger <ekurzinger@gmail.com>

[ Upstream commit 6736c8ff9d63e847a3b694aeaeb78d4e8ad42464 ]

amdgpu_dm_plane_get_plane_modifiers always adds DRM_FORMAT_MOD_LINEAR to
the list of modifiers. However, with gfx12,
amdgpu_dm_plane_add_gfx12_modifiers also adds that modifier to the list.
So we end up with two copies. Most apps just ignore this but some
(Weston) don't like it.

As a fix, we change amdgpu_dm_plane_add_gfx12_modifiers to not add
DRM_FORMAT_MOD_LINEAR to the list, matching the behavior of analogous
functions for other chips.

Signed-off-by: Erik Kurzinger <ekurzinger@gmail.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I have all the information needed for the analysis. Let me compile
the findings.

---

## PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1: Subject Line**
Record: [drm/amd/display] [remove] Remove duplicate
DRM_FORMAT_MOD_LINEAR format modifier in gfx12 modifiers list.

**Step 1.2: Tags**
- Signed-off-by: Erik Kurzinger <ekurzinger@gmail.com> (author)
- Acked-by: Alex Deucher <alexander.deucher@amd.com> (AMD subsystem
  maintainer)
- Signed-off-by: Alex Deucher <alexander.deucher@amd.com> (merged by
  maintainer)
- No Fixes: tag, no Cc: stable, no Reported-by — all expected for
  AUTOSEL candidates.

**Step 1.3: Commit Body**
The commit message clearly describes:
`amdgpu_dm_plane_get_plane_modifiers` always adds
`DRM_FORMAT_MOD_LINEAR` at the end of the modifier list for all chips
(line 769). But `amdgpu_dm_plane_add_gfx12_modifiers` also includes
`DRM_FORMAT_MOD_LINEAR` in its own `gfx12_modifiers[]` array, causing it
to appear twice. Most compositors ignore duplicates, but Weston
compositor breaks when it encounters them.

Record: Bug = duplicate format modifier in the kernel-to-userspace
modifier list for gfx12 GPUs. Symptom = Weston compositor malfunctions
on gfx12 hardware.

**Step 1.4: Hidden Bug Fix**
This is unambiguously a bug fix — it fixes incorrect behavior that
breaks a real compositor (Weston). The word "remove" understates the fix
— this corrects a real user-visible bug.

---

## PHASE 2: DIFF ANALYSIS

**Step 2.1: Inventory**
- 1 file changed:
  `drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_plane.c`
- ~4 lines of functional change within
  `amdgpu_dm_plane_add_gfx12_modifiers()`
- Scope: single-file, single-function surgical fix

**Step 2.2: Code Flow Changes**
1. `gfx12_modifiers[]` array: `DRM_FORMAT_MOD_LINEAR` removed from the
   array (5 elements → 4)
2. DCC loop: `ARRAY_SIZE(gfx12_modifiers) - 1` →
   `ARRAY_SIZE(gfx12_modifiers)` (now iterates over ALL tiled modifiers
   for DCC, since there's no LINEAR to skip)
3. Comments updated to explain the caller adds LINEAR for all chips

**Step 2.3: Bug Mechanism**
Category: Logic/correctness fix. The gfx12 function inconsistently added
LINEAR while all other gfx functions (gfx9, gfx10_1, gfx10_3, gfx11)
rely on the caller to add it. Verified by grepping — only gfx12 had
LINEAR in its internal list.

**Step 2.4: Fix Quality**
Obviously correct — makes gfx12 match the pattern of all other chip
functions. Minimal, surgical. Zero regression risk to other chips. The
loop bound fix is critical: without it, removing LINEAR from the array
would cause the DCC loop to skip the last real modifier (mod_256b).

---

## PHASE 3: GIT HISTORY INVESTIGATION

**Step 3.1: Blame**
The buggy `DRM_FORMAT_MOD_LINEAR` in the `gfx12_modifiers[]` array was
introduced by commit `21e6f6085bbc97` ("drm/amd/display: Allow display
DCC for DCN401", Aurabindo Pillai, 2024-07-03), which restructured the
gfx12 function to add DCC support. The original gfx12 function
(`a64a521231a46`, 2024-02-02) also had LINEAR inline, but pre-DCC. Both
are in v6.11+.

**Step 3.2: Fixes target**
No Fixes: tag. The bug was introduced by `21e6f6085bbc97` (v6.11). This
commit exists in stable trees 6.11.y, 6.12.y, 6.13.y, 6.14.y.

**Step 3.3: File History**
Recent changes to the file are unrelated (color pipeline, kmalloc
conversions). No prerequisites or dependencies found.

**Step 3.4: Author**
Erik Kurzinger is a DRM contributor (drm/syncobj patches). Alex Deucher,
who Acked and merged, is the AMD subsystem maintainer.

**Step 3.5: Dependencies**
The fix is completely standalone. The only context dependency is that
`max_comp_block[] = {2, 1, 0}` in v6.15+ vs `{1, 0}` in 6.11-6.14 (from
commit `3855f1d925d4f`), but this is in context lines, not in the
changed lines. Minor context fuzz at most.

---

## PHASE 4: MAILING LIST RESEARCH

- Patch v1 was posted on Feb 10, 2026. Alex Deucher immediately Acked
  it.
- v2 was submitted the same day with improved comments and the loop
  bound fix. Alex Deucher Acked v2 as well.
- No NAKs or concerns raised. No explicit stable nomination, but also no
  objection.
- b4 dig could not find the AMD patches on lore (AMD patches go through
  freedesktop gitlab, not always indexed by b4).

---

## PHASE 5: CODE SEMANTIC ANALYSIS

**Step 5.1-5.4: Function and Call Chain**
- `amdgpu_dm_plane_add_gfx12_modifiers()` is called from
  `amdgpu_dm_plane_get_plane_modifiers()` for AMDGPU_FAMILY_GC_12_0_0
  devices.
- `amdgpu_dm_plane_get_plane_modifiers()` is called during plane
  initialization (`amdgpu_dm_plane_init()`), which runs for every
  display plane on every gfx12 GPU.
- The modifier list is exported to userspace via the DRM plane
  properties and queried by compositors like Weston when selecting
  buffer formats.

**Step 5.5: Similar Patterns**
Confirmed: gfx9, gfx10_1, gfx10_3, and gfx11 functions do NOT add
`DRM_FORMAT_MOD_LINEAR`. Only gfx12 was inconsistent.

---

## PHASE 6: STABLE TREE ANALYSIS

**Step 6.1: Buggy Code Presence**
- gfx12 modifiers introduced in v6.11 (a64a521231a46)
- DCC restructuring (introducing the duplicate) also in v6.11
  (21e6f6085bbc97)
- Bug exists in: **6.11.y, 6.12.y, 6.13.y, 6.14.y** stable trees
- Not in v6.10 or earlier (no gfx12 support)

**Step 6.2: Backport Complications**
For 6.11-6.14: `max_comp_block[] = {1, 0}` (context-only difference from
`{2, 1, 0}` in 6.15+). The actual changed lines are identical. Should
apply with minor fuzz or a trivial context adjustment.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

**Step 7.1:** drm/amd/display — IMPORTANT subsystem. AMD GPUs
(especially gfx12 = RDNA4) are widely used in desktops and embedded
systems. Display bugs affect all users of the GPU.

**Step 7.2:** The file is actively maintained with frequent changes.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

**Step 8.1: Affected Users**
All users of gfx12 (AMDGPU RDNA4) GPUs running Weston compositor. Also
potentially affects other compositors that validate modifier lists
strictly.

**Step 8.2: Trigger Conditions**
100% triggered on every gfx12 GPU initialization — the duplicate
modifier is always present in the exported list.

**Step 8.3: Failure Mode Severity**
Weston compositor fails to work properly with gfx12 GPUs. Severity:
MEDIUM-HIGH. This prevents a major compositor from functioning on new
AMD hardware.

**Step 8.4: Risk-Benefit**
- Benefit: HIGH — fixes Weston on gfx12, corrects API contract (DRM
  modifiers should not have duplicates)
- Risk: VERY LOW — 4-line change in a single function, matching
  established pattern of all other chip functions, Acked by maintainer
- Ratio: Very favorable

---

## PHASE 9: FINAL SYNTHESIS

**Evidence FOR backporting:**
- Fixes a real bug that breaks Weston compositor on gfx12 hardware
- Small, surgical, obviously correct (4 functional line changes)
- Matches the established pattern of all other chip generations
- Acked by subsystem maintainer (Alex Deucher)
- Bug present in all stable trees with gfx12 support (6.11+)
- Zero regression risk to other chips
- No new features or APIs

**Evidence AGAINST backporting:**
- Impact is limited to Weston users on gfx12 (most compositors tolerate
  duplicates)
- No CVE, no crash, no data corruption

**Stable Rules Checklist:**
1. Obviously correct and tested? **YES** — matches all other chip
   functions, Acked by maintainer
2. Fixes a real bug? **YES** — duplicate modifier breaks Weston
3. Important issue? **MEDIUM-HIGH** — prevents compositor from working
   on new hardware
4. Small and contained? **YES** — 4 lines, 1 function, 1 file
5. No new features or APIs? **YES**
6. Can apply to stable? **YES** — may need minor context adjustment for
   6.11-6.14

---

## Verification

- [Phase 1] Parsed tags: Acked-by Alex Deucher (AMD maintainer), no
  Fixes/Cc-stable (expected)
- [Phase 2] Diff analysis: 4 functional lines changed in
  `amdgpu_dm_plane_add_gfx12_modifiers()`, removes LINEAR from array and
  fixes loop bound
- [Phase 2] Confirmed all other gfx add functions (gfx9, gfx10_1,
  gfx10_3, gfx11) do NOT add LINEAR — verified via grep
- [Phase 2] Confirmed caller `amdgpu_dm_plane_get_plane_modifiers()`
  adds LINEAR at line 769 for ALL chips — verified via Read
- [Phase 3] git blame: buggy line 707 introduced by commit
  21e6f6085bbc97 (v6.11, 2024-07-03)
- [Phase 3] git show a64a521231a46: original gfx12 function also had
  LINEAR (duplicate from day one)
- [Phase 3] Verified gfx12 NOT in v6.10, IS in v6.11+ via `git merge-
  base --is-ancestor`
- [Phase 3] 3855f1d925d4f (max_comp_block context change) in v6.15 only
  — minor context fuzz for older stables
- [Phase 4] Found patch v1 and v2 on freedesktop.org mailing list
  archives
- [Phase 4] v1 (1-line change) and v2 (4-line change with improved
  comments/loop) both Acked by Alex Deucher
- [Phase 4] No NAKs, no concerns raised in discussion
- [Phase 5] Verified call chain: `amdgpu_dm_plane_init()` →
  `amdgpu_dm_plane_get_plane_modifiers()` →
  `amdgpu_dm_plane_add_gfx12_modifiers()` — runs on every gfx12 display
  plane init
- [Phase 6] Bug present in 6.11.y, 6.12.y, 6.13.y, 6.14.y stable trees
  (verified)
- [Phase 8] Failure mode: Weston compositor broken on gfx12, severity
  MEDIUM-HIGH

**YES**

 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_plane.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_plane.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_plane.c
index 127207e18dcb0..bc19438211dd3 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_plane.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_plane.c
@@ -704,21 +704,21 @@ static void amdgpu_dm_plane_add_gfx12_modifiers(struct amdgpu_device *adev,
 	uint8_t max_comp_block[] = {2, 1, 0};
 	uint64_t max_comp_block_mod[ARRAY_SIZE(max_comp_block)] = {0};
 	uint8_t i = 0, j = 0;
-	uint64_t gfx12_modifiers[] = {mod_256k, mod_64k, mod_4k, mod_256b, DRM_FORMAT_MOD_LINEAR};
+	/* Note, linear (no DCC) gets added to the modifier list for all chips by the caller. */
+	uint64_t gfx12_modifiers[] = {mod_256k, mod_64k, mod_4k, mod_256b};
 
 	for (i = 0; i < ARRAY_SIZE(max_comp_block); i++)
 		max_comp_block_mod[i] = AMD_FMT_MOD_SET(DCC_MAX_COMPRESSED_BLOCK, max_comp_block[i]);
 
 	/* With DCC: Best choice should be kept first. Hence, add all 256k modifiers of different
 	 * max compressed blocks first and then move on to the next smaller sized layouts.
-	 * Do not add the linear modifier here, and hence the condition of size-1 for the loop
 	 */
-	for (j = 0; j < ARRAY_SIZE(gfx12_modifiers) - 1; j++)
+	for (j = 0; j < ARRAY_SIZE(gfx12_modifiers); j++)
 		for (i = 0; i < ARRAY_SIZE(max_comp_block); i++)
 			amdgpu_dm_plane_add_modifier(mods, size, capacity,
 						     ver | dcc | max_comp_block_mod[i] | gfx12_modifiers[j]);
 
-	/* Without DCC. Add all modifiers including linear at the end */
+	/* Without DCC. */
 	for (i = 0; i < ARRAY_SIZE(gfx12_modifiers); i++)
 		amdgpu_dm_plane_add_modifier(mods, size, capacity, gfx12_modifiers[i]);
 
-- 
2.53.0

