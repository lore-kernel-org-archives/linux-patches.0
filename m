Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5C01599A51;
	Mon, 19 Oct 2026 13:55:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418133; cv=none; b=VlZMyF/nmDPUqVRoPfeZsvRj+6gQg5Zkcc7VxXdX5nAY2zDlNHdEkxWV8L/g2fWE1J2s7AMF7Za+N3N0lgltp1/ip79qYMsHnYG47rX8+hBD3nfkx6QHEpMURBD51yBkLXcaMqM6aDohoA76Dsq5XzNOa6O44UUbQeqxdVQjseA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418133; c=relaxed/simple;
	bh=Se+GY3063rskGGloNTcFDRZ9Qm69oGaLB3ewpOJ7+0Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=e5scirNJER9DKgP57EtQNlkDmwIAAcIZMyRfyqemfe3WBw+0CxUzLixtBzZGdhXmQp5XYspXcN6PkUx4gKSQZS10to5vH3SJa+qQBvKOr8vOA/CkyT9y2TBUbGxw7DS30WYJyUavwLw4zcqy9+1tF3uUcAI/2QMzMxQbzfRfupc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WyRNdDr6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WyRNdDr6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 629421F000C4;
	Mon, 19 Oct 2026 13:55:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418130;
	bh=N1WBpvUT1LBft8j2MisXNoz9KQD7JeZYoan8e1V+zi8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WyRNdDr6Uho0TIQDKXuSdZjl++k+99uYnvmNTX0tOxkRctEgQrm/OYCfBtdNRKFch
	 tZglBtSLRoSrysTXZDLPLqdSDQjHPnXEen3GzC8EGjf4AO9ER+hmAojq0Jp0GKqdCe
	 T+wJvykXXJY8mZSfV5KIGurFudNlB0lIwIQotgSh/i6iqc62P/UcVFmE9uUCrwBtxj
	 QZxEoxnMJKhIxITxvNuOszDrGIdeOOKdKGe33gFSDWnSn8ArCS+N2SXzFZiu2VAl7X
	 kKMJfDAAhSpUlw6kxzSzY+gfVh5ULIT8ZIs1RP7xZn4/WEc+GfL9Gzju4bUA8QrqF/
	 PLnRJxrupBq4Q==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Heiko Schocher <hs@nabladev.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Sasha Levin <sashal@kernel.org>,
	maarten.lankhorst@linux.intel.com,
	mripard@kernel.org,
	tzimmermann@suse.de,
	airlied@gmail.com,
	simona@ffwll.ch,
	dri-devel@lists.freedesktop.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] drm/panel: simple: Add Kyocera tcg070wvlq panel
Date: Mon, 19 Oct 2026 09:45:24 -0400
Message-ID: <20261019135441.1420968-33-sashal@kernel.org>
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

From: Heiko Schocher <hs@nabladev.com>

[ Upstream commit 900517da69afca6f72dacf14278aee3b65275507 ]

Commit 922fb2db0287 ("dt-bindings: display: simple: Add Kyocera
tcg070wvlq panel") added the compatible string for the Kyocera
tcg070wvlq panel to the devicetree bindings documentation
(panel-simple.yaml), but the corresponding entry was not added
to the panel-simple driver.

Add the missing compatible entry to the driver.

Signed-off-by: Heiko Schocher <hs@nabladev.com>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://patch.msgid.link/20260721041935.757240-1-hs@nabladev.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The local tree is **7.3.0-rc4** (`v7.3-rc4-27-gf0100363d8c37`). This
commit is a 3-line `of_device_id` addition to the existing `panel-
simple` driver. Official stable rules allow that class of change.

## Phase 1: Commit message forensics

**Step 1.1:** Record: `[drm/panel: simple] [Add] [register OF compatible
kyo,tcg070wvlq, reusing existing lg_lb070wv8 descriptor]`

**Step 1.2:** Record: tags present:
- Reviewed-by: Neil Armstrong (drm/panel maintainer)
- Signed-off-by: Heiko Schocher (author); Neil Armstrong (applied to
  drm-misc)
- Link: https://patch.msgid.link/20260721041935.757240-1-hs@nabladev.com
- No Fixes:, Reported-by, Tested-by, Cc: stable, or syzbot (absence
  expected)

Ignored pipeline markers: none in the provided text beyond the usual
evaluation context.

**Step 1.3:** Record:
- Bug: commit `922fb2db0287` (v5.12-rc1) documented `kyo,tcg070wvlq` in
  `panel-simple.yaml` but never added the matching `of_device_id` entry.
- Symptom: a DT node whose only compatible is `kyo,tcg070wvlq` does not
  bind to `panel-simple`.
- Version info: bindings since v5.12; driver entry added 2026-07-22.
- Root cause: incomplete match-table vs documented binding, not a crash
  path.

**Step 1.4:** Record: Not a hidden crash/UAF/leak fix. It is hardware-ID
enablement. The 2021 bindings commit said the panel “seems to be
compatible with `lg,lb070wv8`” and added the string “only to the dt-
binding documentation to fix the checkpatch warnings.”

## Phase 2: Diff analysis

**Step 2.1:** Record: `drivers/gpu/drm/panel/panel-simple.c` +3/−0.
Function/table: `platform_of_match[]`. Scope: single-file surgical
match-table insert.

**Step 2.2:** Record: Before, `kyo,tcg070wvlq` was not in
`platform_of_match`. After, it matches and uses `&lg_lb070wv8` (same
timings/size/bus as `lg,lb070wv8`).

**Step 2.3:** Record: category **h) hardware / device ID**. Mechanism:
documented OF compatible now matches the existing panel descriptor.

**Step 2.4:** Record: Obviously correct (alias of an existing
descriptor). Minimal. Regression risk very low: in-tree `imx6dl-
prtmvt.dts` already has fallback `lg,lb070wv8` pointing at the same
data, so probe behavior is unchanged there.

## Phase 3: Git history

**Step 3.1:** Record: Missing driver ID is the gap left by
`922fb2db0287` (v5.12-rc1). `lg_lb070wv8` itself is `dd0150026901b`
(v4.2-rc1). In-tree DTS usage is `f3604ba14bd75e` (v5.12-rc1):
`compatible = "kyo,tcg070wvlq", "lg,lb070wv8"`.

**Step 3.2:** Record: No Fixes: tag. The referenced bindings commit is
an ancestor of HEAD.

**Step 3.3:** Record: Standalone; not `patch X/Y`. Nearby `panel-simple`
commits are other panel IDs, not prerequisites.

**Step 3.4:** Record: Heiko originally added `lg_lb070wv8` (2015) and
this ID (2026). Neil Armstrong reviewed and applied it. Maintainer-
acked.

**Step 3.5:** Record: Depends only on `lg_lb070wv8` and
`platform_of_match`, both present here. Applies standalone.

## Phase 4: Mailing list / external

**Step 4.1:** Record: `b4 dig` → v1 only,
https://patch.msgid.link/20260721041935.757240-1-hs@nabladev.com.
Thread: Heiko submit → Neil `Reviewed-by` → applied to drm-misc-next as
`900517da69afc`. No NAK, no stable discussion, no requested revisions.

**Step 4.2:** Record: Recipients included Neil Armstrong, Maxime Ripard,
dri-devel, DRM maintainers, original bindings author Oleksij Rempel.

**Step 4.3:** Record: No bugzilla/syzbot. Motivation is binding/driver
mismatch, not a crash report.

**Step 4.4:** Record: Single-patch series.

**Step 4.5:** Record: lore.kernel.org/stable search returned 403; no
stable-list discussion verified. LKML mirrors confirm review-only
thread.

## Phase 5: Code semantics

**Step 5.1:** Record: `platform_of_match[]` only.

**Step 5.2:** Record: Used as `.of_match_table` of
`panel_simple_platform_driver` (`panel_simple_platform_probe`). Probe
path on DT match.

**Step 5.3:** Record: Match data is existing `lg_lb070wv8` (`panel_desc`
+ LVDS timings). No new alloc/lock/API.

**Step 5.4:** Record: Reachable when a DT node uses `kyo,tcg070wvlq`.
In-tree board `imx6dl-prtmvt` already matches via fallback. Userspace
does not trigger this except by using that panel.

**Step 5.5:** Record: Same file already has `kyo,tcg121xglp` and
`lg,lb070wv8`. This is the standard panel-simple ID pattern.

## Phase 6: This checkout

**Step 6.1:** Record: Tree is 7.3.0-rc4. `panel-simple.c`,
`lg_lb070wv8`, bindings `kyo,tcg070wvlq`, and DTS fallback all exist.
Commit `900517da69afc` is already an ancestor of HEAD (merged via drm-
misc-next → drm-next before v7.3-rc1). The **match table and descriptor
this patch needs are in this tree**.

**Step 6.2:** Record: Clean apply (already applied here). Insertion sits
alphabetically between `koe,tx31d200vm0baa` and `kyo,tcg121xglp`.

**Step 6.3:** Record: No alternate fix. This *is* the driver-side
completion of the v5.12 binding.

## Phase 7: Subsystem context

**Step 7.1:** Record: `drivers/gpu/drm/panel` — **PERIPHERAL** (one LVDS
panel / Protonic MVT i.MX6 board).

**Step 7.2:** Record: `panel-simple` is mature and still gets ID
additions; this is normal hardware enablement, not a new subsystem.

## Phase 8: Impact and risk

**Step 8.1:** Record: Driver/board-specific (`CONFIG_DRM_PANEL_SIMPLE`,
DT with this compatible). Not universal.

**Step 8.2:** Record: Trigger is panel probe. Common for that one
industrial board; otherwise only if DT lists `kyo,tcg070wvlq`. Not a
syscall/security path.

**Step 8.3:** Record: Without the ID, a **primary-only**
`kyo,tcg070wvlq` node fails to bind (no display). In-tree DTS still
works via `lg,lb070wv8`. Severity **LOW** as a crash; **hardware
enablement** under the device-ID rule.

**Step 8.4:** Record: Benefit = correct match for a documented
compatible / existing panel. Risk = very low (3 lines, existing
descriptor). Ratio favors taking it: official rules explicitly allow
device IDs.

## Phase 9: Synthesis

**Evidence FOR:**
- `Documentation/process/stable-kernel-rules.rst` in this tree: “It must
  either fix a real bug that bothers people **or just add a device
  ID**.”
- Device-ID exception in the review criteria: ID-only change in an
  existing driver.
- 3 lines, reuses `lg_lb070wv8` since v4.2, reviewed by the panel
  maintainer.
- Completes a compatible documented since v5.12.

**Evidence AGAINST:**
- Not a crash, UAF, deadlock, or corruption fix.
- In-tree `imx6dl-prtmvt.dts` already falls back to `lg,lb070wv8`, so
  this tree’s in-tree board already probes.
- 2021 bindings commit intentionally omitted the driver entry at first.
- No user/syzbot report.

**Unresolved:** Could not fetch lore.kernel.org/stable (403). No
evidence this was rejected for stable.

**Stable checklist:**
1. Obviously correct and tested — **PASS** (maintainer Reviewed-by,
   applied to drm-misc-next)
2. Real bug that affects users — **PASS** as device ID (documented
   compatible did not match); in-tree fallback means limited user-
   visible delta
3. Important issue — **PASS via device-ID exception**, not via
   crash/security
4. Small and contained — **PASS** (+3)
5. No new features/APIs — **PASS** (no new descriptor, timings, or uAPI;
   match-table ID only)
6. Can apply to this tree — **PASS** (`lg_lb070wv8` and
   `platform_of_match` present)

**Exception category:** New device ID (OF compatible) on an existing
driver.

This is not a stability fix, but it is exactly the “just add a device
ID” case the stable rules call out. Risk is negligible.

Verification:
- [Phase 1] Parsed tags: Reviewed-by Neil Armstrong; Link msgid
  20260721041935.757240-1; no Fixes/syzbot
- [Phase 2] Diff: +3 in `platform_of_match[]`; `.data = &lg_lb070wv8`
- [Phase 3] `git name-rev --tags 922fb2db02871` → v5.12-rc1;
  `dd0150026901b` → v4.2-rc1; `f3604ba14bd75e` DTS fallback
- [Phase 3] `git merge-base --is-ancestor 922fb2db0287 HEAD` exit 0;
  `900517da69afc` ancestor of HEAD
- [Phase 4] `b4 dig -c 900517da69afc` / `-a` / `-w` / `-m`: v1 only;
  Neil review + apply; dri-devel CCd
- [Phase 4] lore.kernel.org WebFetch 403; LKML mirrors used instead
- [Phase 5] `platform_of_match` →
  `panel_simple_platform_driver.of_match_table`
- [Phase 6] `git describe HEAD` → v7.3-rc4-27-gf0100363d8c37; `make
  kernelversion` → 7.3.0-rc4
- [Phase 6] Grep: `kyo,tcg070wvlq` in driver, yaml, and `imx6dl-
  prtmvt.dts`
- [Phase 8] Failure mode: unmatched compatible → no panel probe; in-tree
  DTS still matches fallback
- [Phase 9] Read `Documentation/process/stable-kernel-rules.rst` lines
  15–16: device IDs are allowed
- UNVERIFIED: stable@vger discussion (HTTP 403)

**YES**

 drivers/gpu/drm/panel/panel-simple.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/panel/panel-simple.c b/drivers/gpu/drm/panel/panel-simple.c
index 878a5dc7748fb..c784f67f58fa4 100644
--- a/drivers/gpu/drm/panel/panel-simple.c
+++ b/drivers/gpu/drm/panel/panel-simple.c
@@ -5245,6 +5245,9 @@ static const struct of_device_id platform_of_match[] = {
 	}, {
 		.compatible = "koe,tx31d200vm0baa",
 		.data = &koe_tx31d200vm0baa,
+	}, {
+		.compatible = "kyo,tcg070wvlq",
+		.data = &lg_lb070wv8,
 	}, {
 		.compatible = "kyo,tcg121xglp",
 		.data = &kyo_tcg121xglp,
-- 
2.53.0

