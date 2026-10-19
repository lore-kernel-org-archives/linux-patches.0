Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C0C1532EF2;
	Mon, 19 Oct 2026 14:03:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418638; cv=none; b=YBMRFsenyExdDjwhtYz7hFup58HI+aKbbiSY36bO9Eqx/8qtbm7VjSApX1r7umpg4H6yMeNE00wPUpl7zwlQK2bpEQD/hTKIihnUQn+qNbPlO7IT41BkwpNgDbih4uiRBjM1OkMNEVIzNDeXkgm9noQoxmUC6W9juZVK8+q6HN0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418638; c=relaxed/simple;
	bh=kGbG52fGB96t4UqheDP3dTe/12gUgpf66muy9TI/pHw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kLRlALDmgViqEahlH8p5AhVlNL+dXH/73+qqBcW04WRYrMwHfmKwYYQZOt5qWFKHvrQFS+j6gcB1VswDg/PN26UoGE+u5O6KhQHkx0keog4lhdCoctMTcSSTst4roqIAVbauQvwcH2MES7s/OGO/iW/7VUr2nNQ2CfzyvFXpFD8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MLyR3Wh5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MLyR3Wh5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27AA81F000C5;
	Mon, 19 Oct 2026 14:03:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418635;
	bh=SH4egVIVR2Di7WSXJDQxMgEss9OGBBJVaE18I3MZHRk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MLyR3Wh5rl94rIl35PjQp+siuJux1zgxj6f7vK50iNx6fxu1B3wgMV+NxRB3vvZhm
	 ULlbF8VsTMJ1Dg6H10Pjg8qZzoSlrVIl4pM+UaEv0BoKjN9h6vrdL2nQPS3LZoUgJl
	 ngSX9hiD1sT0wE4bZI3lRAf7pmiQVVXcW2yA51DyyIuozN0dOj7oxqnTSze0bGBlH8
	 cOyRhsKmbWfWeI42155fg78m7pCVeQh8O+kk38S4oL6MObT2WtGK3dDyqXUwVokhdl
	 zDExYv2yphY2SIFtUec7cHPjsPx7NW8foR5Ux65zhYjarrCDylp/cEHad9nstM2Utr
	 Dn0zCCJ5mqsLw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	shenghao-ding@ti.com,
	kevin-lu@ti.com,
	baojun.xu@ti.com,
	sen@ti.com,
	lgirdwood@gmail.com,
	perex@perex.cz,
	tiwai@suse.com,
	linux-sound@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] ASoC: tlv320aic26: remove keyclick sysfs file
Date: Mon, 19 Oct 2026 09:51:20 -0400
Message-ID: <20261019135441.1420968-389-sashal@kernel.org>
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

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit ae375f8d063d71e598c0d7e14fc056154c84d7a7 ]

aic26_probe() creates the keyclick sysfs file on the component device.
The file callback uses the ASoC component pointer stored in the driver
private data.

There is no matching remove callback, so the sysfs file can remain after
the component is removed while its backing component state is gone.

Add a component remove callback that removes the keyclick file.

Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Link: https://patch.msgid.link/20260615064549.34110-1-pengpeng@iscas.ac.cn
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The local tree is **6.18.53**. The buggy `device_create_file()` path is
present in `v6.18.53`; this 6-line remove-side cleanup is a real
UAF/NULL-deref fix and applies cleanly here.

===============================================================
PHASE 1: COMMIT MESSAGE FORENSICS
===============================================================

**Step 1.1: PARSE THE SUBJECT LINE**
Record: **[ASoC / tlv320aic26] [remove] [tear down the keyclick sysfs
attribute on component remove]**

The subject says “remove keyclick sysfs file”; the body is more precise:
the file is **not** deleted as a feature. A matching `.remove` callback
is added so the existing debug attribute is unregistered when the
component goes away.

**Step 1.2: PARSE ALL COMMIT MESSAGE TAGS**
Record:
- **Link:**
  `https://patch.msgid.link/20260615064549.34110-1-pengpeng@iscas.ac.cn`
- **Signed-off-by:** Pengpeng Hou `<pengpeng@iscas.ac.cn>` (author)
- **Signed-off-by:** Mark Brown `<broonie@kernel.org>` (ASoC maintainer)
- **No Fixes:** tag (expected for this review)
- **No Cc: stable@vger.kernel.org** (expected)
- **No Reported-by / Tested-by / Reviewed-by / Acked-by / syzbot**
- Ignored pipeline tags (`[Upstream commit …]`, Sasha Levin SOB) per
  instructions

**Step 1.3: ANALYZE THE COMMIT BODY TEXT**
Record:
- **Bug:** `aic26_probe()` creates `keyclick` on `component->dev`.
  `keyclick_show` / `keyclick_store` use `dev_get_drvdata()` and then
  `aic26->component`. There is no matching remove.
- **Symptom:** After the ASoC component is removed, the sysfs file can
  still be there while the component / driver private state is gone.
- **Failure mode:** use of stale `aic26` / `aic26->component` from sysfs
  (UAF or NULL deref).
- **Version info:** none in the message. The create-file path dates to
  the original 2008 driver.
- **Fix:** add `aic26_remove()` that calls `device_remove_file()` and
  wire it to `snd_soc_component_driver.remove`.

**Step 1.4: DETECT HIDDEN BUG FIXES**
Record: **Yes — a real lifetime bug, not a feature deletion.** The
subject is slightly misleading; this is the standard “create in probe,
never remove” sysfs teardown hole.

===============================================================
PHASE 2: DIFF ANALYSIS - LINE BY LINE
===============================================================

**Step 2.1: INVENTORY THE CHANGES**
Record:
- **File:** `sound/soc/codecs/tlv320aic26.c` (**+6 / −0**)
- **Functions:** new `aic26_remove()`; `aic26_soc_component_dev` gets
  `.remove`
- **Scope:** single-file surgical fix

**Step 2.2: UNDERSTAND THE CODE FLOW CHANGE**
Record:
- **Before:** `aic26_probe()` (card bind) does
  `device_create_file(component->dev, &dev_attr_keyclick)` and returns 0
  even if create fails. No `.remove`.
- **After:** card/component teardown calls `aic26_remove()` →
  `device_remove_file()`.
- **Path:** component remove / card unbind / codec unregister — not the
  playback hot path.

**Step 2.3: IDENTIFY THE BUG MECHANISM**
Record: **[UAF / NULL deref from leftover sysfs] [probe creates an
unmanaged attribute; remove never tears it down]**

Verified mechanics in this tree:

1. `component->dev` is the SPI device (`snd_soc_component_initialize()`
   sets `component->dev = dev`; SPI probe passes `&spi->dev`).
2. `keyclick_show` / `keyclick_store` do `dev_get_drvdata(dev)` then
   `snd_soc_component_read/update_bits(aic26->component, …)`.
3. `aic26_probe()` is only run from `soc_probe_component()` when a card
   binds.
4. `soc_remove_component()` calls `snd_soc_component_remove()` →
   `driver->remove` if set. Without this patch that is NULL, so the
   attribute stays on the still-live SPI device.
5. On SPI driver unbind, `device_unbind_cleanup()` runs
   `devres_release_all()` (frees `aic26` via `devm_kzalloc`, unregisters
   the component) then `dev_set_drvdata(dev, NULL)`.
   `device_create_file()` is **not** a managed resource, so `keyclick`
   remains.
6. Later sysfs access: NULL deref if drvdata is already NULL; UAF in the
   window while `aic26` is freed and drvdata is not yet cleared; or
   concurrent show/store vs teardown because `device_remove_file()` is
   what waits out in-flight sysfs ops.

Sibling codecs already pair create/remove the same way (`wm8962.c`,
`cs42l52.c`, `cs42l56.c`).

**Step 2.4: ASSESS THE FIX QUALITY**
Record:
- **Obviously correct:** matches the established ASoC pattern;
  `device_remove_file()` is the matching API.
- **Minimal:** 6 lines, no API/behavior change for working hardware.
- **Regression risk:** very low. If `device_create_file()` failed,
  `device_remove_file()` may emit a kernfs “failed to remove” warning;
  that is the same pattern as the sibling beep drivers and only on the
  already-failed create path. No new locking.

===============================================================
PHASE 3: GIT HISTORY INVESTIGATION
===============================================================

**Step 3.1: BLAME THE CHANGED LINES**
Record:
- **Introduced by:** `d8e3bb7385da0` (“ALSA: ASoC: Add Texas Instruments
  TLV320AIC26 codec driver”, 2008-07-29)
- **Kernel version:** v2.6.27-era; present for the entire life of this
  6.18 tree
- Sysfs create itself has been stable; later commits only reworked ASoC
  helpers (`1514613a7a448` codec→component, `2eadc04d83f6c`
  `DEVICE_ATTR_RW`, `1218d67d37615` `sysfs_emit`)

**Step 3.2: FOLLOW THE FIXES: TAG**
Record: **No Fixes: tag.** Blame is sufficient: the hole is the original
driver, not a recent regression.

**Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES**
Record:
- Recent on this file at `v6.18.53`: `sysfs_emit`, DAI naming,
  `DEVICE_ATTR_RW` — none add remove.
- Same author, same day: `02b2a3058912d` / upstream `ce3733792d38`
  “ASoC: sma1303: remove fault-check sysfs group on remove” —
  **parallel** fix in another codec, different msgid, not a
  prerequisite.
- **Standalone.**

**Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS**
Record: Pengpeng Hou is a regular ASoC codec contributor (error-path /
lifetime fixes). Not the subsystem maintainer. Maintainer **Mark Brown**
applied the patch.

**Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS**
Record: **None.** `.remove` is already `void (*remove)(struct
snd_soc_component *)` in `include/sound/soc-component.h` on this tree.
No new helpers.

===============================================================
PHASE 4: MAILING LIST AND EXTERNAL RESEARCH
===============================================================

**Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION**
Record:
- **b4 dig:**
  https://patch.msgid.link/20260615064549.34110-1-pengpeng@iscas.ac.cn
- **Revisions:** v1 only (no v2/v3)
- **Thread (mbox via `b4 dig -m`):** 2 messages — submission and Mark
  Brown’s apply to `broonie/sound.git for-7.3`
- **No NAK, no review comments, no Cc: stable in-thread**
- Direct lore HTTP fetch returned **403**; discussion was recovered from
  the mbox, not from the web UI

**Step 4.2: CHECK WHO REVIEWED THE PATCH**
Record (`b4 dig -w`): To/Cc included Mark Brown, Liam Girdwood, Takashi
Iwai, Jaroslav Kysela, TI codec contacts, `linux-sound`, `linux-kernel`.
Applied by the ASoC maintainer. No extra Reviewed-by.

**Step 4.3: SEARCH FOR THE BUG REPORT**
Record: **No user/syzbot/bugzilla report.** Code-analysis fix. No
evidence of a field crash report.

**Step 4.4: CHECK FOR RELATED PATCHES AND SERIES**
Record: Same-day sma1303 sysfs-remove patch is a sibling, not a
dependency. This patch is `[PATCH]` (not `n/N`).

**Step 4.5: CHECK STABLE MAILING LIST HISTORY**
Record: **UNVERIFIED** for lore.kernel.org/stable (HTTP 403). No in-tree
discussion of a reason to skip this on 6.18.y.

===============================================================
PHASE 5: CODE SEMANTIC ANALYSIS
===============================================================

**Step 5.1: IDENTIFY KEY FUNCTIONS IN THE DIFF**
Record: `aic26_remove` (new), `aic26_soc_component_dev` table; related
existing: `aic26_probe`, `keyclick_show`, `keyclick_store`,
`aic26_spi_probe`

**Step 5.2: TRACE CALLERS**
Record:
- `aic26_probe` ← `snd_soc_component_probe()` ← `soc_probe_component()`
  (card bind)
- `aic26_remove` ← `snd_soc_component_remove()` ←
  `soc_remove_component()` ← `soc_remove_link_components()` / error
  unwind; also via card unbind when the component is unregistered
  (`snd_soc_del_component_unlocked()` → `snd_soc_unbind_card()`)
- Sysfs callbacks: userspace read/write of `keyclick` (mode 0644 via
  `DEVICE_ATTR_RW`)

**Step 5.3: TRACE CALLEES**
Record: `device_remove_file()` only. Show/store use
`snd_soc_component_read` / `update_bits` on `aic26->component`.

**Step 5.4: FOLLOW THE CALL CHAIN**
Record:
- Bind: SPI probe → `devm_snd_soc_register_component` → later card bind
  → `aic26_probe` → sysfs create
- Unbind: card/component teardown should drop the file; SPI unbind then
  frees `aic26` and clears drvdata
- **Reachable from userspace:** yes, via sysfs after bind. After broken
  unbind, any reader of that 0644 file can oops. Unprivileged read is
  possible; write is typically root. Trigger is teardown (rmmod / unbind
  / card removal), not every PCM period.

**Step 5.5: SEARCH FOR SIMILAR PATTERNS**
Record: In-tree ASoC codecs that create device sysfs files already
remove them (wm8962, cs42l52, cs42l56). This driver was the outlier.
sma1303 got the same class of fix the same day.

===============================================================
PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE
===============================================================

**Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?**
Record: **Yes.** `git describe HEAD` → `v6.18.53-5049-g0f0bdc2b0dffb`;
`make kernelversion` → **6.18.53**.
- `git grep aic26_remove v6.18.53 -- sound/soc/codecs/tlv320aic26.c` →
  **not present**
- `v6.18.53:sound/soc/codecs/tlv320aic26.c` still has create in
  `aic26_probe()` and no `.remove`
- Bug introduced in 2008; present for all of 6.18.y

**Step 6.2: CHECK FOR BACKPORT COMPLICATIONS**
Record: **Clean apply** to the `v6.18.53` copy of the file (`patch
--dry-run` return code 0). Surrounding probe/driver table matches the
hunk. `.remove` is already `void` here.

**Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE**
Record: No earlier tlv320aic26 sysfs-remove fix at `v6.18.53`.
`sysfs_emit` conversion does not close the lifetime hole.

===============================================================
PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT
===============================================================

**Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY**
Record: **ASoC codec driver (`sound/soc/codecs/`)** — **PERIPHERAL**
- `CONFIG_SND_SOC_TLV320AIC26` is a **promptless** tristate, `depends on
  SPI`
- Only in-tree `imply` is `SND_SOC_ALL_CODECS`, which **`depends on
  COMPILE_TEST`**
- Grep of the whole tree: no machine driver, DTS, or defconfig selects
  this codec

**Step 7.2: ASSESS SUBSYSTEM ACTIVITY**
Record: ASoC is active; **this file is mature/quiet**. Last functional
churn is ASoC API modernization, not new features. Long-lived bug.

===============================================================
PHASE 8: IMPACT AND RISK ASSESSMENT
===============================================================

**Step 8.1: DETERMINE WHO IS AFFECTED**
Record: **Driver-specific / config-specific.** Production 6.18 configs
will not enable this unless they set the hidden
`CONFIG_SND_SOC_TLV320AIC26` (out-of-tree board, explicit fragment).
Compile-test “all codecs” builds can include it.

**Step 8.2: DETERMINE THE TRIGGER CONDITIONS**
Record:
- Requires the codec bound to a card (so probe created the file), then
  component/driver teardown, then sysfs access — or concurrent access
  during unbind
- Not every-boot; **module unload / card unbind**
- Unprivileged users can **read** the leftover 0644 file (DoS oops), not
  typically write

**Step 8.3: DETERMINE THE FAILURE MODE SEVERITY**
Record: **NULL deref / UAF → kernel oops** — **HIGH** (crash;
theoretically memory-safety). Not silent corruption. No syzbot/CVE.

**Step 8.4: CALCULATE RISK-BENEFIT RATIO**
Record:
- **Benefit:** medium-low population, high severity *if* the driver is
  used; prevents oops/UAF on teardown
- **Risk:** very low (6 lines, standard API, no locking/ABI)
- **Ratio:** favorable for stable — cheap crash fix

===============================================================
PHASE 9: FINAL SYNTHESIS
===============================================================

**Step 9.1: COMPILE THE EVIDENCE**

FOR:
- Real probe/remove mismatch: unmanaged sysfs vs component/driver
  lifetime
- Failure is oops/UAF, a class stable regularly takes
- 6 lines, obviously correct, same pattern as wm8962/cs42l52/cs42l56
- Bug present since 2008; code exists in this 6.18.53 tree; patch
  applies cleanly
- No prerequisites; `void (*remove)` already matches
- ASoC maintainer applied v1 with no objections

AGAINST:
- No field report / syzbot / Fixes / Cc: stable
- Obscure codec: no in-tree card, hidden Kconfig, only implied under
  `COMPILE_TEST`
- Debug sysfs, not the PCM path
- Tiny warning risk if create failed and remove still runs

UNRESOLVED:
- Stable-list discussion (lore HTTP 403)
- Whether any distro/out-of-tree 6.18 config actually sets
  `CONFIG_SND_SOC_TLV320AIC26`

**Step 9.2: APPLY THE STABLE RULES CHECKLIST**
1. Obviously correct and tested? **PASS** — standard
   `device_remove_file` pairing; maintainer applied; in-tree siblings
   already do this
2. Fixes a real bug that affects users? **PASS** — leftover sysfs after
   remove is a real lifetime bug (population is small, but the bug is
   real)
3. Important issue (crash, security, corruption, deadlock)? **PASS** —
   UAF/NULL deref oops on a world-readable sysfs file after unbind
4. Small and contained? **PASS** — +6 lines, one codec
5. No new features or APIs? **PASS**
6. Can apply to the local tree? **PASS** — applies to `v6.18.53`
   tlv320aic26.c; `.remove` type matches

**Step 9.3: CHECK FOR EXCEPTION CATEGORIES**
Record: **Not** an ID/quirk/DT/build/doc exception. Ordinary small
bugfix.

**Step 9.4: MAKE YOUR DECISION**
This is a small, correct teardown fix for a use-after-free / NULL deref.
The driver is obscure, but the rules and the usual stable practice still
take this class of probe/remove hole: crash on unbind, surgical change,
no dependencies, clean apply to **this** 6.18.53 tree. Benefit is
limited by who enables the codec; risk is negligible. That is a YES.

------------------------------------------------
What the commit solves for stable users
------------------------------------------------
`aic26_probe()` publishes `keyclick` on the SPI device. Show/store use
driver private data and `aic26->component`. Nothing ever calls
`device_remove_file()`. After card/component teardown or `rmmod`, the
attribute can remain while `aic26` is freed and drvdata is cleared. A
later read oopses. The patch adds the missing component `.remove`.

------------------------------------------------
Stable rules / risk vs benefit
------------------------------------------------
Meets the bar: obviously correct, real crash-class bug, tiny, no new
API, applies here. User set is small (hidden Kconfig, no in-tree
machine), but regression risk is near zero. No extra commits needed.

------------------------------------------------
Verification
------------------------------------------------
- **[Phase 1]** Tags: Link msgid, SOB Hou + Brown; no Fixes/Reported-
  by/syzbot/Cc:stable
- **[Phase 2]** Diff: +6 lines, `aic26_remove` + `.remove =
  aic26_remove`
- **[Phase 2]** `keyclick_show`/`store` use `dev_get_drvdata` then
  `aic26->component` (file read)
- **[Phase 2]** Siblings wm8962/cs42l52/cs42l56 already
  `device_remove_file` in remove
- **[Phase 3]** Blame: create-file from `d8e3bb7385da0` (2008); no Fixes
  tag
- **[Phase 3]** Author also fixed sma1303 sysfs on remove the same day;
  independent
- **[Phase 4]** `b4 dig -c ae375f8d063d…`: lore msgid
  20260615064549.34110-1; v1 only
- **[Phase 4]** `b4 dig -w`: Brown, Girdwood, Iwai, Kysela, linux-sound
  CC’d
- **[Phase 4]** `b4 dig -m`: 2-message thread; Brown applied to for-7.3;
  no NAK
- **[Phase 4]** lore.kernel.org / patch.msgid.link HTTP **403**; used
  mbox instead
- **[Phase 5]** probe via `soc_probe_component`; remove via
  `soc_remove_component`
- **[Phase 5]** `device_unbind_cleanup` (`drivers/base/dd.c`):
  `devres_release_all` then `dev_set_drvdata(NULL)`
- **[Phase 5]** `DEVICE_ATTR_RW` → 0644 (`include/linux/device.h`)
- **[Phase 6]** `git describe HEAD` = `v6.18.53-5049-g0f0bdc2b0dffb`;
  kernelversion 6.18.53
- **[Phase 6]** `aic26_remove` **absent** from `v6.18.53`; patch dry-run
  against that file **succeeds**
- **[Phase 6]** `git merge-base --is-ancestor ae375f8d063d HEAD` → not
  ancestor (upstream 7.3 material)
- **[Phase 7]** `CONFIG_SND_SOC_TLV320AIC26` promptless; only `imply`
  from `SND_SOC_ALL_CODECS` (`depends on COMPILE_TEST`); no
  DTS/board/defconfig
- **[Phase 8]** Failure mode: oops/UAF after unbind; severity HIGH;
  population small
- **UNVERIFIED:** stable@ lore discussion (HTTP 403); whether any 6.18
  distro enables this hidden symbol

**YES**

 sound/soc/codecs/tlv320aic26.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/sound/soc/codecs/tlv320aic26.c b/sound/soc/codecs/tlv320aic26.c
index e5dfb3d752a3a..84e954311c1b2 100644
--- a/sound/soc/codecs/tlv320aic26.c
+++ b/sound/soc/codecs/tlv320aic26.c
@@ -320,8 +320,14 @@ static int aic26_probe(struct snd_soc_component *component)
 	return 0;
 }
 
+static void aic26_remove(struct snd_soc_component *component)
+{
+	device_remove_file(component->dev, &dev_attr_keyclick);
+}
+
 static const struct snd_soc_component_driver aic26_soc_component_dev = {
 	.probe			= aic26_probe,
+	.remove			= aic26_remove,
 	.controls		= aic26_snd_controls,
 	.num_controls		= ARRAY_SIZE(aic26_snd_controls),
 	.dapm_widgets		= tlv320aic26_dapm_widgets,
-- 
2.53.0

