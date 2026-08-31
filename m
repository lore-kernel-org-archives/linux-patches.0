Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FB7448C41F;
	Mon, 31 Aug 2026 13:38:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183504; cv=none; b=kYe2uEBCDrdVx01f8c1FQ6gk+G05vCmINnOGHT/sUrywiU8AS5Gv2zXdplrfSCpd2+4B76XBinJ5CiuSGR5d1nLYBaaiMMMmyoeSJJPjzFjuMmoK8HgZoxS7tzTqQAsDtmox9XlVKNw1XkyIvFmgWxU81Nnto6VHREhTH7P47gE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183504; c=relaxed/simple;
	bh=FTVURYjRuNK6aMRecHajX/sNqfncFdUdxy6hx1rAWOE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=B2iFWJki9ZEHnPxbAAz1qhvP0v7HLD8k3a3IRNPX/VO/BZ1kowMN/+8/r3lNWPKG3Q+CTXWU77wQ/ZgxVPzmGeGur4qNXhLuT1VRC0lCUpg8NStL0iIJMMlX025vu9mEOyulsqy2LrRd+7n6dcnr50Qd5mFKgF2VPQ2cMSOzGiA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ECsV0E2a; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ECsV0E2a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4534A1F00A3D;
	Mon, 31 Aug 2026 13:38:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183501;
	bh=yd5UOgsFxhDufEVl3sFtYrBA70lz23oH9L4LHyhHJ6g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ECsV0E2a13MV2T4dUzlcpaGRgydNT227tAEtaHSAmLNpNHPRIpB8K294aY6ldy1mc
	 3fQ/L8/bNLLP5WgVh6ySfy0V/rX32+ZRY/+gJwxkotd1YC0F+FllLZJQCf5zTmLhZ0
	 1Bi31bnuyL/QDLGPOnMKHMAmkTcVvVmCrgD5Phbwhi4wJ8jFyCvsMHvxFMYBY1ccfR
	 xP/03rFLOfxDTBLTlVo9Sy2Na1nACr/dHbNobvPepmUhPKwhXMghGKEBKpD2hkSFKt
	 EeG/mbxnOYwguqILgd5VZUIXgHDHnT/C6n1bSy0yi7xSLiyEJCXUl25JL9q/bPljs7
	 X+mLP/748JxKw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Paul Cercueil <paul@crapouillou.net>,
	Mehdi Djait <mehdi.djait@linux.intel.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	mchehab@kernel.org,
	linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] media: v4l2-common: Always register clock with device-specific name
Date: Mon, 31 Aug 2026 09:22:42 -0400
Message-ID: <20260831133314.4125787-134-sashal@kernel.org>
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

From: Paul Cercueil <paul@crapouillou.net>

[ Upstream commit 0b42657bea6ba635226e8ef551076d024ceacdc9 ]

If we need to register a dummy fixed-frequency clock, always register it
using a device-specific name.

This supports the use case where a system has two of the same sensor,
meaning two instances of the same driver, which previously both tried
(and failed) to create a clock with the same name.

Signed-off-by: Paul Cercueil <paul@crapouillou.net>
Reviewed-by: Mehdi Djait <mehdi.djait@linux.intel.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: `media: v4l2-common: Always register clock
with device-specific name`

**Local tree:** Linux **6.18.43** (`git describe HEAD` →
`v6.18.43-1-gc7f0dac02d232`)

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Subject line
**Record:** `[media: v4l2-common]` — implicit fix via “Always register…”
— ensures dummy fixed-frequency clocks use unique, device-specific
names.

### Step 1.2: Tags
**Record:**
- **Fixes:** — none
- **Reported-by:** — none
- **Tested-by:** — none
- **Reviewed-by:** Mehdi Djait `<mehdi.djait@linux.intel.com>`
- **Acked-by:** — none
- **Link:** — none
- **Cc: stable:** — none (expected for manual review)
- **Signed-off-by:** Paul Cercueil (author), Hans Verkuil (media
  maintainer)

Notable: Intel media reviewer sign-off; no syzbot or user bug reports.

### Step 1.3: Body analysis
**Record:**
- **Bug:** When `__devm_v4l2_sensor_clk_get()` registers a dummy fixed
  clock and the caller passes a non-NULL `id` (e.g. `"xvclk"`), the
  clock is registered under that bare string. Two instances of the same
  sensor driver collide on the global clock name.
- **Symptom:** Second sensor instance fails clock registration
  (`-EEXIST` from the clock core) → driver probe fails → second camera
  does not work.
- **Root cause:** Device-specific naming was only applied when `id ==
  NULL`; non-NULL `id` was passed straight to
  `devm_clk_hw_register_fixed_rate()`.
- **Version info:** None in the commit message.

### Step 1.4: Hidden bug fix?
**Record:** No — this is an explicit hardware-enablement bug fix, not
disguised cleanup.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory
**Record:**
- **Files:** `drivers/media/v4l2-core/v4l2-common.c` (+7 / −6)
- **Function:** `__devm_v4l2_sensor_clk_get()`
- **Scope:** Single-file, surgical fix (~13 lines touched)

### Step 2.2: Code flow change
**Record:**

| Hunk | Before | After |
|------|--------|-------|
| Clock naming | Only when `!id`: allocate `"clk-<devname>"`, assign to
`id` | Always allocate: `"clk-<devname>-<id>"` if `id` set, else
`"clk-<devname>"` |
| Registration | `devm_clk_hw_register_fixed_rate(dev, id, ...)` |
`devm_clk_hw_register_fixed_rate(dev, clk_id, ...)` |

Affected path: dummy fixed-clock registration on non-OF platforms or
legacy ACPI/OF paths when `devm_clk_get_optional()` returns no clock.

### Step 2.3: Bug mechanism
**Record:** **Logic / correctness fix** — global clock namespace
collision. `clk_core_lookup()` returns `-EEXIST` for duplicate names
(verified in `drivers/clk/clk.c:3910-3914`).

### Step 2.4: Fix quality
**Record:**
- Obviously correct: mirrors the existing NULL-`id` naming pattern and
  extends it.
- Minimal, no API changes.
- Low regression risk: only changes internally registered dummy clock
  names; callers still request clocks by their original `id` via
  `devm_clk_get_optional()`.
- `clk_id` already uses `__free(kfree)` cleanup attribute — memory
  handling unchanged.

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame
**Record:** Buggy naming logic present since helper introduction. `git
blame` on lines 767–774 attributes to commit `5d324e5159d9e` (tree
history artifact). `git show v6.18:...` confirms identical buggy code in
**Linux 6.18.0**. Helper does **not** exist in v6.17 (`grep` count = 0).

### Step 3.2: Fixes: tag
**Record:** N/A — no Fixes: tag.

### Step 3.3: Related file history
**Record:**
- `git log v6.18..HEAD -- drivers/media/v4l2-core/v4l2-common.c`: only
  `2b2a17af8d8c7` (YUV24 format info) — unrelated.
- Fix commit on mainline: `0b42657bea6ba635226e8ef551076d024ceacdc9`
  (2026-03-31).
- Standalone; not part of a multi-patch series.

### Step 3.4: Author context
**Record:** Paul Cercueil — regular media contributor. Hans Verkuil
merged. Mehdi Djait (Intel) reviewed. No other related commits from this
author visible in this tree’s shallow history.

### Step 3.5: Dependencies
**Record:** None. Self-contained; no prerequisite commits. Applies
cleanly to current `v4l2-common.c` in this tree (buggy code confirmed at
lines 767–774).

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: Original discussion
**Record:**
- `b4 dig -c 0b42657bea6b`:
  https://patch.msgid.link/20260331084340.67613-1-paul@crapouillou.net
- Series: v1 (2026-03-27) → v2 (2026-03-27, adds clock id to name) → v3
  (2026-03-31, adds NULL-id support). Committed version is v3.
- No stable nomination found in thread.
- No NAKs found in mbox.

### Step 4.2: Reviewers
**Record:** `b4 dig -w`: To/Cc includes Mauro Chehab, Mehdi Djait,
Laurent Pinchart, linux-media, linux-kernel.

### Step 4.3: Bug report
**Record:** No external bug report. Author describes a concrete dual-
sensor scenario.

### Step 4.4: Related patches
**Record:** Helper introduced by the large “Add a helper for obtaining
the clock producer” series (landed in 6.18). This fix is a follow-up to
that introduction.

### Step 4.5: Stable list history
**Record:** Not searched separately; no stable discussion found in patch
thread.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Key functions
**Record:** `__devm_v4l2_sensor_clk_get()` — wrappers
`devm_v4l2_sensor_clk_get()` and `devm_v4l2_sensor_clk_get_legacy()`.

### Step 5.2: Callers
**Record:** 40+ camera sensor drivers call this helper. **13 drivers**
pass a non-NULL string id and are affected on the dummy-clock path,
including:
- `ov5693.c` (`"xvclk"`), `ov5640.c` (`"xclk"`), `ov7740.c` (`"xvclk"`),
  `imx296.c` (`"inck"`), etc.
- Additional drivers use `devm_v4l2_sensor_clk_get_legacy()` with non-
  NULL ids (`ov8856.c`, `ov5695.c`, etc.).
- Many drivers pass `NULL` — already worked before this fix.

### Step 5.3: Callees
**Record:** `devm_clk_get_optional()`, `device_property_read_u32("clock-
frequency")`, `devm_clk_hw_register_fixed_rate()`, `kasprintf()`.

### Step 5.4: Reachability
**Record:**
1. I2C/ACPI camera sensor probes during boot or module load.
2. `devm_clk_get_optional()` returns NULL (no explicit clock provider —
   typical ACPI path).
3. `CONFIG_COMMON_CLK` enabled, platform is non-OF or legacy mode.
4. `clock-frequency` property present.
5. Second identical sensor → name collision → `-EEXIST` → probe failure.

Example from `ov5693.c`:

```1292:1296:drivers/media/i2c/ov5693.c
        ov5693->xvclk = devm_v4l2_sensor_clk_get(&client->dev, "xvclk");
        if (IS_ERR(ov5693->xvclk))
                return dev_err_probe(&client->dev,
PTR_ERR(ov5693->xvclk),
                                     "failed to get xvclk: %ld\n",
                                     PTR_ERR(ov5693->xvclk));
```

Userspace cannot directly trigger this, but it is a normal boot-time
hardware path on ACPI dual-camera systems.

### Step 5.5: Similar patterns
**Record:** NULL-`id` path already used device-specific naming
(`"clk-%s"`). Fix extends the same pattern to non-NULL ids — consistent
with existing design intent.

---

## PHASE 6: CROSS-REFERENCE WITH LOCAL TREE (6.18.43)

### Step 6.1: Buggy code present?
**Record:** **YES.** Current tree at lines 767–774 has the pre-fix
logic. Confirmed identical in `v6.18.0`. Helper absent in v6.17 — bug
introduced with the helper in 6.18.

### Step 6.2: Backport complications
**Record:** **Clean apply expected.** Only the naming block changes;
surrounding function matches the patch context. One unrelated commit
(`YUV24 format info`) since v6.18.0 in this file.

### Step 6.3: Related fixes already present?
**Record:** **No.** `git log --grep="device-specific name"` returned
nothing. Fix not in this tree.

---

## PHASE 7: SUBSYSTEM CONTEXT

### Step 7.1: Subsystem criticality
**Record:** **drivers/media** — IMPORTANT, driver-specific. Affects ACPI
camera sensor users, not the whole kernel.

### Step 7.2: Activity
**Record:** `devm_v4l2_sensor_clk_get` is new in 6.18 (large driver
conversion series). Active development area with a bug shipped from
initial release.

---

## PHASE 8: IMPACT AND RISK

### Step 8.1: Who is affected
**Record:** ACPI (and some legacy) platforms with **two or more
instances of the same camera sensor driver** where the dummy fixed-clock
path is used and the driver passes a non-NULL clock id. Config:
`CONFIG_MEDIA_SUPPORT`, `CONFIG_COMMON_CLK`, relevant sensor drivers
built-in or as modules.

### Step 8.2: Trigger conditions
**Record:** Moderately narrow but realistic — dual front/rear camera
with same sensor model on ACPI laptops/tablets. Not every boot (single-
camera systems unaffected). Not userspace-triggerable.

### Step 8.3: Failure severity
**Record:** **Probe failure** for the second sensor (`-EEXIST` →
`dev_err_probe`). No kernel oops/panic, no data corruption, no security
impact. **Severity: MEDIUM** — hardware does not work, system remains
stable.

### Step 8.4: Risk-benefit
**Record:**
- **Benefit:** Enables dual-camera ACPI systems that are broken in all
  6.18.y releases shipped so far; fixes a bug present since 6.18.0.
- **Risk:** Very low — 7-line naming change, reviewed, no API impact.
- **Ratio:** Favorable for **6.18.y** specifically, where the helper and
  bug both exist.

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence summary

**FOR backport:**
- Real, reproducible probe failure on dual-sensor ACPI systems
- Bug shipped in 6.18.0 and present in 6.18.43
- Small, obviously correct, reviewed fix
- 13+ sensor drivers use non-NULL ids on the affected path
- No dependencies; clean apply
- Hardware-enablement fix (similar category to quirks/workarounds)

**AGAINST backport:**
- Not a crash, deadlock, corruption, or security issue
- Narrow trigger: ACPI + dual same sensor + non-NULL id + dummy clock
  path
- Many drivers pass NULL (already worked)
- No user/syzbot report; no explicit stable nomination

**Unresolved:** No specific hardware platform named in the commit or
mailing list thread.

### Step 9.2: Stable rules checklist

| Criterion | Result |
|-----------|--------|
| 1. Obviously correct and tested? | **PASS** — simple naming logic,
Reviewed-by from Intel media developer |
| 2. Fixes a real user-affecting bug? | **PASS** — second camera probe
fails on dual-sensor ACPI systems |
| 3. Important issue? | **PASS (borderline)** — hardware probe failure,
not crash/corruption; important for affected dual-camera platforms |
| 4. Small and contained? | **PASS** — 1 file, ~7 net lines |
| 5. No new features/APIs? | **PASS** — internal clock naming only |
| 6. Applies to this tree? | **PASS** — buggy code confirmed in 6.18.43;
helper absent in older series |

### Step 9.3: Exception category
**Record:** Hardware workaround / multi-instance enablement — analogous
to quirks that fix broken multi-device behavior.

### Step 9.4: Decision rationale
For **this 6.18.43 tree**, the `devm_v4l2_sensor_clk_get` helper was
introduced in 6.18 with a naming bug that breaks dual instances of the
same sensor on ACPI platforms. The fix is minimal, low-risk, and self-
contained. While severity is medium rather than critical, stable 6.18.y
is the correct place to fix a defect that has been present since the
helper’s initial release. Older stable series (e.g. 6.12.y) do not have
this code and are out of scope for this tree-specific verdict.

---

## Verification

- **[Phase 1]** Parsed subject, tags (Reviewed-by: Mehdi Djait; no
  Fixes/Reported-by/Link)
- **[Phase 2]** Diff analysis: naming logic in
  `__devm_v4l2_sensor_clk_get()`, +7/−6 lines
- **[Phase 3]** `git describe HEAD`: v6.18.43; `make kernelversion`:
  6.18.43
- **[Phase 3]** `git blame` lines 767–774: pre-fix code present
- **[Phase 3]** `git show v6.18:...`: identical buggy code in 6.18.0
- **[Phase 3]** `git show v6.17:...`: helper absent (count 0)
- **[Phase 3]** `git log v6.18..HEAD -- v4l2-common.c`: only unrelated
  YUV24 commit
- **[Phase 4]** `b4 dig -c 0b42657bea6b`: lore URL found
- **[Phase 4]** `b4 dig -a`: v1→v2→v3 series; v3 is committed version
- **[Phase 4]** `b4 dig -w`: maintainers CC'd
- **[Phase 4]** mbox grep: Reviewed-by only; no stable nomination or NAK
- **[Phase 5]** `grep devm_v4l2_sensor_clk_get`: 40+ callers; 13 with
  non-NULL string id
- **[Phase 5]** Read `ov5693.c:1292-1296`: probe fails on clock error
- **[Phase 5]** Read `clk.c:3910-3914`: duplicate name returns `-EEXIST`
- **[Phase 6]** Read current `v4l2-common.c:767-774`: buggy code
  confirmed
- **[Phase 6]** `git merge-base --is-ancestor v6.18 HEAD`: v6.18 is
  ancestor
- **[Phase 8]** Failure mode: probe failure, severity MEDIUM

**YES**The analysis is complete for **Linux 6.18.43**.

**Verdict: backport this fix.**

The bug is in `__devm_v4l2_sensor_clk_get()` since 6.18.0: when a dummy
fixed clock is registered with a non-NULL `id` (e.g. `"xvclk"`), two
instances of the same sensor driver collide on the global clock name and
the second probe fails with `-EEXIST`. The patch is small (about 7
lines), low risk, and applies cleanly to this tree.

**YES**The history search finished. Repo-wide `git log -S
"__devm_v4l2_sensor_clk_get"` didn’t add anything beyond what we already
had: in this checkout the helper shows up with the 6.18 release, and it
isn’t present in v6.17. That matches the earlier conclusion — the bug
exists in 6.18.43 and the fix is worth backporting.

**YES**The `devm_clk_hw_register_fixed_rate` history search finished. In
this tree it only ties back to the `__devm_v4l2_sensor_clk_get()` dummy-
clock path introduced in 6.18 — nothing that changes the backport call.
Verdict remains **YES**.

 drivers/media/v4l2-core/v4l2-common.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-common.c b/drivers/media/v4l2-core/v4l2-common.c
index c1e3bcb4c1c40..524c11e92aec5 100644
--- a/drivers/media/v4l2-core/v4l2-common.c
+++ b/drivers/media/v4l2-core/v4l2-common.c
@@ -764,14 +764,15 @@ struct clk *__devm_v4l2_sensor_clk_get(struct device *dev, const char *id,
 	if (ret)
 		return ERR_PTR(ret == -EINVAL ? -EPROBE_DEFER : ret);
 
-	if (!id) {
+	if (id)
+		clk_id = kasprintf(GFP_KERNEL, "clk-%s-%s", dev_name(dev), id);
+	else
 		clk_id = kasprintf(GFP_KERNEL, "clk-%s", dev_name(dev));
-		if (!clk_id)
-			return ERR_PTR(-ENOMEM);
-		id = clk_id;
-	}
 
-	clk_hw = devm_clk_hw_register_fixed_rate(dev, id, NULL, 0, rate);
+	if (!clk_id)
+		return ERR_PTR(-ENOMEM);
+
+	clk_hw = devm_clk_hw_register_fixed_rate(dev, clk_id, NULL, 0, rate);
 	if (IS_ERR(clk_hw))
 		return ERR_CAST(clk_hw);
 
-- 
2.53.0

