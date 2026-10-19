Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 253DC5D18BE;
	Mon, 19 Oct 2026 14:01:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418492; cv=none; b=erj9n4vGbuMOJfxlIyj5qEuOabkJ6uowo5e7m3rVSywtpml1f81YByjGB5gTs0s+kAKYxKj8RtYOwNWjSoZh1bbGtd8Hp7QRdRZs3+1Q6W4ificDALng55wPSLWzeg+Cwc7DtF5X/nlAKFaKd/YR2/whSyYekTgQlCmvUITeuH4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418492; c=relaxed/simple;
	bh=UtGByILVLeDDVs9a4tsesfkBDJFlsIYSd1yDo+mI4xc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WTdIMfYv9Og94XwRKfU5q0J1oSHuj3dzfyH+il/6Vf8hgRkSNE8jCllLkx4B+VP7eAyaycuh3aI6dN4baM/d2SJCNuIQayPkKTxxieWRESzQTDzAsgyJ5/rj4tsjKcZ4waqzut68P5CL90Ng9ibpqrRD7VBKOZgAnSexVjVsam4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LMoPetaV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LMoPetaV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDB3F1F000C9;
	Mon, 19 Oct 2026 14:01:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418490;
	bh=fXSy8vXI5Q3X55qaJS0tzwo7fN8/NY8JaWm6glYGfgs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LMoPetaV3eqnwrygwrwGSkQUuE4LPhPZxP631t06heeD7/3Pa0OQA95gNKUYf0e1f
	 0AMXVWmdqhGFKVjvyu2nwEIuBTTQNCAoSH8JwFKMKj+UyMd3RAH4l4ZXSV7zpjqNym
	 B7um9oGcA+5LsjfIXQEIBoFMXY55reguXq3TYr/FbgIiDGTn989zSLUHDVZ9B5fahQ
	 O93rDdtBhRymuXUGlh0iJoL2JI3YiJ/5UBbzUgkAHyAtfsYmt4zrZ2tLuu2D4aqxfg
	 8+okA3hCeyOubW3sr084Hahoec/LvWnpw6qIf2is9pmmRKhft6gnqmHGBPgqAilNZo
	 XATcwrN0pGjEQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Thomas Zimmermann <tzimmermann@suse.de>,
	Sashiko <sashiko-bot@kernel.org>,
	Thierry Reding <treding@nvidia.com>,
	Maxime Ripard <mripard@kernel.org>,
	Javier Martinez Canillas <javierm@redhat.com>,
	Sasha Levin <sashal@kernel.org>,
	maarten.lankhorst@linux.intel.com,
	airlied@gmail.com,
	simona@ffwll.ch,
	dri-devel@lists.freedesktop.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] drm/sysfb: simpledrm: Validate mmap size against framebuffer size
Date: Mon, 19 Oct 2026 09:49:36 -0400
Message-ID: <20261019135441.1420968-285-sashal@kernel.org>
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

From: Thomas Zimmermann <tzimmermann@suse.de>

[ Upstream commit 127d52f9c64b1d9aab6226c4a1f38c37fb7254dc ]

The size of the mmap'ed framebuffer could be smaller than the minimum
required framebuffer size. Validate the resource size against the
framebuffer size.

Buggy firmware that triggers this check should be fixed up with a quirk
on a case-by-case base.

v3:
- fix size checks (Sashiko)
- improve error message for alignment check (Thierry)
- do not store aligned size value

Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Suggested-by: Sashiko <sashiko-bot@kernel.org>
Reviewed-by: Thierry Reding <treding@nvidia.com>
Reviewed-by: Maxime Ripard <mripard@kernel.org>
Reviewed-by: Javier Martinez Canillas <javierm@redhat.com>
Link: https://patch.msgid.link/20260625094509.157581-6-tzimmermann@suse.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

I have enough to decide: this is a 6.18.53 tree, the OOB check is
missing there, and the patch is a small probe-time bounds fix.

---

## PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1: PARSE THE SUBJECT LINE**

Record: **[drm/sysfb / simpledrm] [Validate] [reject probe when firmware
framebuffer size exceeds the mapped memory resource]**

**Step 1.2: PARSE ALL COMMIT MESSAGE TAGS**

Record:
- **Fixes:** none (expected for this review)
- **Cc: stable:** none (expected; sibling patches in the same series
  *did* have it)
- **Suggested-by:** Sashiko `<sashiko-bot@kernel.org>` — static-analysis
  bot found the missing bounds check
- **Reviewed-by:** Thierry Reding, Maxime Ripard, Javier Martinez
  Canillas (DRM maintainers)
- **Link:**
  `https://patch.msgid.link/20260625094509.157581-6-tzimmermann@suse.de`
  — v3 patch 5/7 of “Various improvements”
- **Signed-off-by:** Thomas Zimmermann (author/subsystem maintainer)
- **Reported-by / Tested-by:** none
- Ignored pipeline tags: `[Upstream commit 127d52f9c64b…]`, `Signed-off-
  by: Sasha Levin`

**Step 1.3: ANALYZE THE COMMIT BODY TEXT**

Record:
- **Bug:** firmware/DT can advertise width/height/stride whose product
  is larger than the mmap’d `IORESOURCE_MEM` / reserved-memory region.
- **Symptom:** driver maps only `resource_size(mem)` but later draws
  `height * stride` bytes → out-of-bounds access of the mapping.
- **Author note:** firmware that trips this should get a quirk, not a
  silent OOB.
- **v3:** Sashiko fixed inverted size checks; Thierry improved the ALIGN
  error text; aligned size is no longer stored.
- **Versions:** none stated. Driver exists since 2021 (`11e8f5fd223b`,
  “drm: Add simpledrm driver”).

**Step 1.4: DETECT HIDDEN BUG FIXES**

Record: Not disguised. It is an explicit bounds check. Cover letter
groups it with “improve validation of values provided by the device
firmware.” Sashiko’s v1/v2 review called the missing/inverted check a
**High** OOB kernel write.

---

## PHASE 2: DIFF ANALYSIS

**Step 2.1: INVENTORY THE CHANGES**

Record:
- **File:** `drivers/gpu/drm/sysfb/simpledrm.c` — **+24 / −0**
- **Function:** `simpledrm_device_create()`
- **Scope:** single-file surgical probe-path validation
- Adds `#include <linux/overflow.h>` and local `u64 size`

**Step 2.2: UNDERSTAND THE CODE FLOW CHANGE**

Record:
1. After stride is known: compute `size = height * stride` with
   `check_mul_overflow`; fail `-EINVAL` on overflow. Then `ALIGN(size,
   PAGE_SIZE) < PAGE_SIZE` catches wrap of page-align.
2. System-memory path (`devm_memremap`): if `size > resource_size(mem)`,
   fail before mapping.
3. I/O-memory path (`devm_ioremap_wc`): same check after the optional
   `devm_request_mem_region` fallback.

Before: map whatever firmware gave, then blit using `fb_pitch`/`height`.
After: refuse to probe if the logical FB does not fit in the mapping.

**Step 2.3: IDENTIFY THE BUG MECHANISM**

Record: **Memory safety / out-of-bounds + integer overflow**
- `drm_sysfb_plane_helper_atomic_update()` → `drm_fb_blit()` into
  `sysfb->fb_addr` using `sysfb->fb_pitch`
- `drm_sysfb_plane_helper_atomic_disable()` `memset_io` over `height`
  lines of `fb_pitch`
- Mapping length is `resource_size(mem)`, not `height*stride`
- v2 had the comparison **inverted** (`resource_size(mem) > size`); v3
  is `size > resource_size(mem)`

**Step 2.4: ASSESS THE FIX QUALITY**

Record: Obviously correct after v3. Minimal. Probe-time only. Regression
risk: probe fail (no simpledrm display) on undersized firmware resources
that “worked” while writing past the map. Author documents quirks. No
API/locking/struct changes.

---

## PHASE 3: GIT HISTORY INVESTIGATION

**Step 3.1: BLAME THE CHANGED LINES**

Record: Mapping code from Thomas Zimmermann / Thierry Reding (2022–2023,
originally `drivers/gpu/drm/tiny/simpledrm.c`). Bug is **missing
validation since the driver was added** (`11e8f5fd223bd`, 2021-05-01),
not a recent regression.

**Step 3.2: FOLLOW THE FIXES: TAG**

Record: No `Fixes:` tag. Buggy behavior is the original probe path. Not
introduced after 6.18 branched.

**Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES**

Same v3 series (msgid `20260625094509.157581`):

| Patch | Subject | In v6.18.53? |
|---|---|---|
| 1/7 | Improve framebuffer-size validation | **YES** (`8d65b8d1722d8`,
Cc: stable v5.14+) |
| 2/7 | Improve panel-size validation | **YES** (`54e32ad5e0c74`, Cc:
stable v6.4+) |
| 3/7 | Inline `simplefb_get_validated_int()` | NO — cleanup only, not
required |
| 4/7 | Improve stride validation | **YES** (`6892f0a2f6b59`, Cc: stable
v6.1+) |
| **5/7** | **This mmap-size check** | **NO** |
| 6–7/7 | Panel orientation | new feature, not this commit |

Record: Standalone vs this tree. Inline helper is not a prerequisite
(diff vs v6.18.53 does not touch those call sites).

**Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS**

Record: Thomas Zimmermann authored simpledrm (2021) and maintains
drm/sysfb. Related: ofdrm overflow used this same `check_mul_overflow`
pattern.

**Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS**

Record: Needs `check_mul_overflow` / `overflow.h` (present in 6.18).
Needs `simpledrm_device_create` layout after stride validation (present
at v6.18.53). No new helpers. **Can apply standalone to this tree.**

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

**Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION**

Record:
- `b4 dig -c 127d52f9…` →
  https://patch.msgid.link/20260625094509.157581-6-tzimmermann@suse.de
- Series: v1 (3 patches, 2026-06-19) → v2 (6, 2026-06-22) → v3 (7,
  2026-06-25). Committed version is v3.
- v1: Sashiko asked to compare firmware size vs mapped resource (High:
  OOB writes on plane update).
- v2: check added **inverted**; Sashiko: rejects valid larger resources,
  allows `size > resource_size`.
- v3: comparison corrected; ALIGN value not stored.
- lore.kernel.org / spinics WebFetch: 403/500. Content recovered via `b4
  dig`, WebSearch snippets, and the ratatoskr thread archive.
- No NAK. No reviewer `Cc: stable` on this specific patch (unlike 1/7,
  2/7, 4/7).

**Step 4.2: CHECK WHO REVIEWED THE PATCH**

Record (`b4 dig -w`): dri-devel; Thierry, Maxime, Javier, airlied,
simona, Maarten Lankhorst, Neil Armstrong; Sashiko. Subsystem
maintainers were on To/Cc and Reviewed-by.

**Step 4.3: SEARCH FOR THE BUG REPORT**

Record: No syzbot/bugzilla/user crash. Finding is Sashiko review of this
series. Mechanism verified in tree (blit/memset past `resource_size`).

**Step 4.4: CHECK FOR RELATED PATCHES AND SERIES**

Record: Patches 6–7 (panel orientation) are features, not needed.
Patches 1/2/4 already in 6.18.53. Patch 3 is unused cleanup.

**Step 4.5: CHECK STABLE MAILING LIST HISTORY**

Record: lore.kernel.org/stable search not available (HTTP 403).
Unverified whether stable@ discussed this SHA. Sibling validation
patches were already taken into 6.18.53 via `Cc: stable`.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

**Step 5.1: KEY FUNCTIONS**

Record: `simpledrm_device_create()` (modified). Callers of the mapped
buffer: `drm_sysfb_plane_helper_atomic_update`, `atomic_disable`,
`get_scanout_buffer`.

**Step 5.2: TRACE CALLERS**

Record:
- `simpledrm_probe()` → `simpledrm_device_create()` — platform probe for
  `simple-framebuffer` / sysfb
- Plane helpers in `drm_sysfb_modeset.c` — atomic update/disable on
  every scanout

Not IRQ. Probe + modeset. Userspace DRM clients and in-kernel
fbdev/client setup trigger blits.

**Step 5.3: TRACE CALLEES**

Record: `check_mul_overflow`, `ALIGN`, `resource_size`, `devm_memremap`
/ `devm_ioremap_wc`. No new locks or allocations beyond existing probe.

**Step 5.4: FOLLOW THE CALL CHAIN**

Record: Reachable whenever `CONFIG_DRM_SIMPLEDRM` binds. DT `simple-
framebuffer` (ARM/QEMU/etc.) and `sysfb_create_simplefb()` (EFI/VESA)
both hit this function. **EFI/VESA path already checks `height*stride`
vs VRAM in `sysfb_create_simplefb()`**
(`drivers/firmware/sysfb_simplefb.c` lines 98–102). **DT `reg` /
`memory-region` does not.** That is the hole.

**Step 5.5: SEARCH FOR SIMILAR PATTERNS**

Record:
- **vesadrm / efidrm:** `drm_sysfb_get_visible_size_si(...,
  resource_size(res))` already caps visible size.
- **ofdrm:** `check_mul_overflow(linebytes, height, &fb_size)` —
  **already in v6.18.53** (`ded6ad826fe0f`, Cc: stable). Message says it
  matches simpledrm.c — i.e. this check in mainline — while 6.18.53
  still lacks it in simpledrm.

---

## PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE

**Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?**

Record:
- `git describe HEAD` → **v6.18.53-5049-g0f0bdc2b0dffb**; `Makefile`
  **6.18.53**
- `git merge-base --is-ancestor 8f06389364d85 v6.18.53` → **not in
  6.18.53**
- At v6.18.53, `simpledrm_device_create()` maps `resource_size(mem)`
  with **no** `height*stride` check (verified by reading that version of
  the file)
- Bug present since simpledrm (v5.14-era), well before 6.18

**Step 6.2: CHECK FOR BACKPORT COMPLICATIONS**

Record: **Clean apply.** v6.18.53 already has stride/width/height
validation; insertion point after `stride = pitch` matches. `overflow.h`
exists. Only extra autosel commit is the unused inline cleanup.

**Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE**

Record: Dimension/stride caps yes; mmap-vs-resource check **no**. No
alternate fix for this OOB.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

**Step 7.1: SUBSYSTEM AND CRITICALITY**

Record: **drm/sysfb / simpledrm** — generic firmware framebuffer.
**IMPORTANT** (not core mm/net, but default/fallback display on many DT
and some x86 firmware systems).

**Step 7.2: SUBSYSTEM ACTIVITY**

Record: Active in 2026 (validation series, ofdrm overflow, vesadrm).
Driver itself is mature (2021).

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

**Step 8.1: WHO IS AFFECTED**

Record: **Driver-specific**, `CONFIG_DRM_SIMPLEDRM`. Highest relevance:
DT `simple-framebuffer` with mismatched `memory-region`/`reg` vs
width/height/stride. EFI/VESA sysfb already rejects undersized VRAM
before creating the device.

**Step 8.2: TRIGGER CONDITIONS**

Record: Probe + later plane update. Trigger is **buggy/mismatched
firmware or DT**, not a normal userspace syscall. Unprivileged users do
not invent the resource; they can trigger the blit after a bad probe
succeeds. Not a timing race.

**Step 8.3: FAILURE MODE SEVERITY**

Record: **OOB write** into/beyond ioremap/memremap (`drm_fb_blit` /
`memset_io`) → **HIGH** (crash, corruption, possible security). Overflow
of `height*stride` → **HIGH** in principle; with U16 height and INT_MAX
stride already in 6.18.53, u64 overflow is unlikely; the resource-size
check is the real fix.

**Step 8.4: RISK-BENEFIT RATIO**

Record:
- **Benefit:** HIGH for mismatched DT/firmware; closes a hole sibling
  drivers already close; ofdrm’s copy of the overflow check is already
  in this tree.
- **Risk:** LOW–MEDIUM — 24 lines, probe-only; possible **black screen**
  if firmware resource is smaller than `height*stride` but the machine
  still “displayed something.” Author: add quirks. That is still better
  than kernel OOB writes.
- **Ratio:** benefit outweighs risk for 6.18.y.

---

## PHASE 9: FINAL SYNTHESIS

**Step 9.1: EVIDENCE**

**FOR:**
- Real OOB on plane update when mapped size < `height*stride` (verified
  blit/memset paths)
- Sashiko High finding; v3 fixed inverted compare
- 24 lines, probe-time, no APIs
- Reviewed by DRM maintainers; author is simpledrm maintainer
- Same validation series already partly in 6.18.53
- ofdrm overflow backport in this tree explicitly follows simpledrm
- Code and context exist; applies cleanly; no extra series patches
  required

**AGAINST:**
- No `Fixes:` / no user crash dump (absence is not a veto per rules)
- Author did not `Cc: stable` (sibling patches did; likely because this
  check was added mid-series)
- Probe failure on quirky firmware
- No syzbot reproducer

**UNRESOLVED:**
- lore/stable HTTP fetch failed; no confirmation of stable@ discussion
- No evidence of a specific board that hits this today (unverified)

**Step 9.2: STABLE RULES CHECKLIST**

1. Obviously correct and tested? **PASS** — v3 comparison is correct;
   three DRM R-bs
2. Real bug affecting users? **PASS** — OOB if DT/firmware sizes
   disagree with the memory resource
3. Important (crash/security/corruption)? **PASS** — kernel OOB write,
   severity HIGH
4. Small and contained? **PASS** — +24 lines, one function
5. No new features/APIs? **PASS**
6. Can apply to this tree? **PASS** — present and matching at v6.18.53

**Step 9.3: EXCEPTION CATEGORIES**

Record: None (not a device ID/quirk/DT/build/doc exception). It is a
normal memory-safety fix.

**Step 9.4: DECISION**

This is a small, reviewed bounds check for a real OOB in simpledrm’s
probe/scanout path. The buggy code is in 6.18.53; prerequisites are
already there; ofdrm already received the same overflow approach.
Firmware-quirk probe failure is the main risk and is acceptable versus
out-of-bounds kernel writes.

---

### What the commit solves for this tree

On **6.18.53**, `simpledrm_device_create()` still maps only
`resource_size(mem)` and then `drm_fb_blit()` / `memset_io()` walk
`height * stride` bytes. If DT `simple-framebuffer` (or other platform
data not going through `sysfb_create_simplefb()`) gives a smaller
resource, that is an out-of-bounds kernel write. This patch fails probe
instead.

### Stable rules / risk

Meets the rules: small, obviously correct after v3, no new API, applies
cleanly here. Benefit is preventing corruption/oops on mismatched
firmware; risk is losing simpledrm on those same configs (quirks if
needed).

### Concerns

- Not originally `Cc: stable` (do not treat as a no).
- Inline helper commit is **not** required.
- ALIGN overflow check is largely redundant after U16/INT_MAX caps
  already in 6.18.53; harmless.

---

Verification:
- [Phase 1] Tags: Suggested-by Sashiko; R-b Thierry, Maxime, Javier;
  Link patch 5/7 v3; no Fixes/Cc: stable
- [Phase 2] +24 lines in `simpledrm_device_create`: overflow + `size >
  resource_size` on both mem paths
- [Phase 3] `git describe`/Makefile: **6.18.53**; `merge-base --is-
  ancestor 8f063893 v6.18.53` = not present; file at v6.18.53 lacks the
  check
- [Phase 3] Series 1/2/4 already in v6.18.53; patch 3 (inline) not
  needed (`git diff v6.18.53` only inlines helpers)
- [Phase 3] Blame: mapping from 2022–23 simpledrm; driver
  `11e8f5fd223bd` (2021)
- [Phase 4] `b4 dig -c 127d52f9`: lore msgid; v1→v3; inverted check in
  v2
- [Phase 4] WebSearch/ratatoskr: Sashiko High OOB; drm_fb_memcpy/blit
  past map
- [Phase 4] lore/spinics WebFetch 403/500 — UNVERIFIED full mbox;
  substance recovered from b4 + archives
- [Phase 4] stable@ search UNVERIFIED (lore 403)
- [Phase 5] `simpledrm_probe` → create; blit/memset in
  `drm_sysfb_modeset.c` use `fb_addr`/`fb_pitch`
- [Phase 5] `sysfb_create_simplefb()` already rejects `length > size`;
  DT `simplefb_get_memory_of()` does not
- [Phase 5] ofdrm `check_mul_overflow` **is** in v6.18.53
  (`ded6ad826fe0f`)
- [Phase 6] `check_mul_overflow` in `include/linux/overflow.h` at
  v6.18.53
- [Phase 8] Failure: OOB write on plane update, HIGH; trigger =
  mismatched firmware/DT
- UNVERIFIED: specific product firmware known to undersize the resource

**YES**

 drivers/gpu/drm/sysfb/simpledrm.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/drivers/gpu/drm/sysfb/simpledrm.c b/drivers/gpu/drm/sysfb/simpledrm.c
index 22f8caab39be0..91f114ab99a3e 100644
--- a/drivers/gpu/drm/sysfb/simpledrm.c
+++ b/drivers/gpu/drm/sysfb/simpledrm.c
@@ -5,6 +5,7 @@
 #include <linux/of_clk.h>
 #include <linux/minmax.h>
 #include <linux/of_reserved_mem.h>
+#include <linux/overflow.h>
 #include <linux/platform_data/simplefb.h>
 #include <linux/platform_device.h>
 #include <linux/pm_domain.h>
@@ -626,6 +627,7 @@ static struct simpledrm_device *simpledrm_device_create(struct drm_driver *drv,
 	u16 width_mm = 0, height_mm = 0;
 	struct device_node *panel_node;
 	const struct drm_format_info *format;
+	u64 size;
 	struct resource *res, *mem = NULL;
 	struct drm_plane *primary_plane;
 	struct drm_crtc *crtc;
@@ -716,6 +718,14 @@ static struct simpledrm_device *simpledrm_device_create(struct drm_driver *drv,
 		}
 		stride = pitch;
 	}
+	if (check_mul_overflow(height, stride, &size)) {
+		drm_err(dev, "framebuffer size exceeds maximum\n");
+		return ERR_PTR(-EINVAL);
+	}
+	if (ALIGN(size, PAGE_SIZE) < PAGE_SIZE) {
+		drm_err(dev, "page-aligned framebuffer exceeds maximum\n");
+		return ERR_PTR(-EINVAL);
+	}
 
 	sysfb->fb_mode = drm_sysfb_mode(width, height, width_mm, height_mm);
 	sysfb->fb_format = format;
@@ -741,6 +751,13 @@ static struct simpledrm_device *simpledrm_device_create(struct drm_driver *drv,
 
 		drm_dbg(dev, "using system memory framebuffer at %pr\n", mem);
 
+		if (size > resource_size(mem)) {
+			drm_err(dev,
+				"framebuffer size of %llu exceeds memory range %pr\n",
+				size, mem);
+			return ERR_PTR(-EINVAL);
+		}
+
 		screen_base = devm_memremap(dev->dev, mem->start, resource_size(mem), MEMREMAP_WC);
 		if (IS_ERR(screen_base))
 			return screen_base;
@@ -774,6 +791,13 @@ static struct simpledrm_device *simpledrm_device_create(struct drm_driver *drv,
 			mem = res;
 		}
 
+		if (size > resource_size(mem)) {
+			drm_err(dev,
+				"framebuffer size of %llu exceeds memory range %pr\n",
+				size, mem);
+			return ERR_PTR(-EINVAL);
+		}
+
 		screen_base = devm_ioremap_wc(&pdev->dev, mem->start, resource_size(mem));
 		if (!screen_base)
 			return ERR_PTR(-ENOMEM);
-- 
2.53.0

