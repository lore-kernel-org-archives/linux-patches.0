Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6839060CDA6;
	Mon, 19 Oct 2026 14:03:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418618; cv=none; b=KI/1IdUl9BdKG7wVXuybfrjpNRoxIJw/39ZFN2qK7Fl00EIMyBwSsTBulcjiCChueQLaajedbaCYfnU4A1zgzOEJf1YSnShfDeVxAYE6vbPqNgj8nf6yNORUUqVUFfcsbGDNmwFtd/B+vr+LKzTjzmPwcD2SYqBVB3kB7BVxZyM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418618; c=relaxed/simple;
	bh=j92dllQBszqrU3b0FCCyQxDoMdsNFcjzZhBXLHCT0go=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=k1wObC95HiY1sH7a5TUPhMofGjekYrNlWCwdbfk4M05UBzdDLKOOW40RvWkrYB/2jjbTjdjMmwevq6+l9ClcQixiTnUGLeQ8LllIhfBe2DmN9Xj2e6KEeNf7caPDJ5LOPuSgarhM1PNM6nJot4wI06HAQJaTnrZhGd5jVZ3x03M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=S8u2ZiDv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="S8u2ZiDv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0CD41F000C4;
	Mon, 19 Oct 2026 14:03:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418615;
	bh=27UIU0XeKm7CxyMBtKFouhIEmrD/4xb0FnUHUBFn2Vc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=S8u2ZiDvHWFJTwUobkWUIG3qDwHM1j8xWr7kSgcEFDwkiutU7MTm5i9rj8GyWv3y5
	 1myLHIww7iarowmTyrTbofy29UnXM7jJUCBN0SUwQD9Tgr+b3LZASxFDYmAOuZEFwX
	 pm2GdQ58SLyjWteVxQ9YfRDlLnfMwHGqphPz1z+AAasVcf8TlIEkFlzC/mP9P9Grva
	 0o3LFkaFszO/zVeVHAKQ0kyy61xz4JtfRGJINiPYoMnCho3ETQXnmRiPPqISZVE8Rv
	 22YWJnPaHtCH4CtAlr7tUFNzfAe0ciHPUNWGrVNwiPAej15FQ+iFIErW9NPhRN34Wd
	 zqRTajc91BcxA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Stefan Binding <sbinding@opensource.cirrus.com>,
	Richard Fitzgerald <rf@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	david.rhodes@cirrus.com,
	lgirdwood@gmail.com,
	perex@perex.cz,
	tiwai@suse.com,
	linux-sound@vger.kernel.org,
	patches@opensource.cirrus.com,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] ASoC: cs35l56: Add support for CS35L62 for SoundWire
Date: Mon, 19 Oct 2026 09:51:05 -0400
Message-ID: <20261019135441.1420968-374-sashal@kernel.org>
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

From: Stefan Binding <sbinding@opensource.cirrus.com>

[ Upstream commit 3330b5f6d8dea66df51c07362f01a39ad9845aad ]

CS35L62 uses the same control and regmap interface as CS35L63 so
support for it can be added into the CS35L56 driver.

Signed-off-by: Stefan Binding <sbinding@opensource.cirrus.com>
Signed-off-by: Richard Fitzgerald <rf@opensource.cirrus.com>
Link: https://patch.msgid.link/20260715120135.939280-2-rf@opensource.cirrus.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit message forensics

**Step 1.1 — Subject**
- Record: `[ASoC/cs35l56] [add] [enable CS35L62 on SoundWire by reusing
  CS35L63 paths]`

**Step 1.2 — Tags**
- Record:
  - `Fixes:` none (expected)
  - `Reported-by:` none
  - `Tested-by:` none
  - `Reviewed-by:` none on the commit
  - `Acked-by:` none
  - `Link: https://patch.msgid.link/20260715120135.939280-2-
    rf@opensource.cirrus.com`
  - `Cc: stable@vger.kernel.org` none (expected)
  - `Signed-off-by: Stefan Binding` (author)
  - `Signed-off-by: Richard Fitzgerald` (Cirrus; submitted the series)
  - `Signed-off-by: Mark Brown` (ASoC maintainer)
  - Ignore any Sasha Levin SOB if present — pipeline noise

**Step 1.3 — Body**
- Record: No bug, crash, leak, or regression is described. Claimed
  intent is hardware enablement: CS35L62 shares CS35L63’s control/regmap
  interface, so it can live in the existing cs35l56 driver. Symptom
  without the patch: a CS35L62 SoundWire amp is not matched (`-ENODEV` /
  unknown DEVID). Root cause: missing part ID and type cases. No version
  range is given. Mark Brown applied it to `for-7.3` as merge-window
  material, not as a bugfix.

**Step 1.4 — Hidden bug fix?**
- Record: No. Wording is “Add support”, not cleanup/locking/error-path
  repair. This is new silicon enablement, not a disguised UAF/leak/race
  fix.

## Phase 2: Diff analysis

**Step 2.1 — Inventory**
- Record: 3 files, **+7 / −0**, single-driver surgical change.
  - `sound/soc/codecs/cs35l56-sdw.c` (+2): `cs35l56_sdw_probe()`,
    `cs35l56_sdw_id[]`
  - `sound/soc/codecs/cs35l56-shared.c` (+4): `cs35l56_set_patch()`,
    `cs35l56_set_fw_reg_table()`, `cs35l56_system_reset()`,
    `cs35l56_hw_init()`
  - `sound/soc/codecs/cs35l56.c` (+1): `_cs35l56_component_probe()`
- Scope: device-ID addition to an existing codec driver.

**Step 2.2 — Flow**
- Before: SoundWire ID `0x01FA:0x3562` is unmatched; type `0x62` / DEVID
  `0x35A620` fall through to `-ENODEV` or skip CS35L63
  firmware/reset/controls.
- After: ID binds; all CS35L63-specific switches also accept CS35L62 and
  reuse `cs35l63_regmap_sdw`, `cs35l63_patch_fw`, `cs35l63_fw_reg`,
  `cs35l63_system_reset_seq`, `cs35l63_calibration_controls`,
  `cs35l63_controls`.
- Path: probe/init only for the new part. Existing 0x54/56/57/63 paths
  are unchanged.

**Step 2.3 — Bug mechanism**
- Record: `[Hardware enablement / SoundWire device ID]` not a memory-
  safety or locking bug. Mechanism: add `SDW_SLAVE_ENTRY(0x01FA, 0x3562,
  0x3562)` and sibling `case` labels so CS35L62 is treated as CS35L63.

**Step 2.4 — Fix quality**
- Record: Obviously correct given the stated aliasing. Minimal. No
  public API, no new driver. Regression risk for existing chips is very
  low (new cases only). Completeness: other `type` switches in this
  driver already use `default:` for CS35L63-class silicon, so they pick
  up 0x62 without extra cases. I2C/SPI tables are intentionally
  untouched (series is SoundWire-only). KUnit still special-cases only
  0x63 in one test; that is test-only.

## Phase 3: Git history

**Step 3.1 — Blame**
- Record: CS35L63 cases/IDs came from `978858791ceda` (“Add initial
  support for CS35L63…”, 2025-04-07). That commit is an ancestor of HEAD
  and is in v6.16. cs35l56 itself dates to `e496112529006` (2023-03-20).
  The CS35L62 lines are this commit (`3330b5f6d8dea`).

**Step 3.2 — Fixes: tag**
- Record: None. There is no “buggy commit”; support was simply never
  added. N/A.

**Step 3.3 — File history / series**
- Record: Patch **1/2**. Companion `0306d21155819` (“ASoC: sdw_utils:
  Add codec info for CS35L62”) adds the SOF/generic machine-driver table
  entry. Cover letter: chip IDs in the codec driver **and** sdw_utils.
  Follow-up `998b8a6c8aff2` sorted the SDW ID table (addresses Pierre-
  Louis Bossart’s nit). Later cs35l56 changes are independent (IRQ,
  probe deadlock, pm_runtime).

**Step 3.4 — Author**
- Record: Stefan Binding is a regular Cirrus cs35l56/cs35l41 contributor
  (including the original CS35L63 support). Submitted via Richard
  Fitzgerald; applied by Mark Brown. High confidence in the ID mapping.

**Step 3.5 — Prerequisites**
- Record: Needs CS35L63 symbols (`cs35l63_regmap_sdw`,
  patch/fw/reset/calibration/controls). Those exist in this checkout.
  Standalone for the codec driver; SOF auto-wiring wants patch 2/2 as
  well.

## Phase 4: Mailing list / external

**Step 4.1 — b4 dig**
- Record: Lore/thread: `https://patch.msgid.link/20260715120135.939280-
  2-rf@opensource.cirrus.com`
- Series: **v1 only** (no v2/v3). Applied as submitted.
- Review: Pierre-Louis Bossart (SoundWire) only nitted sort order (62
  after 63). No NAK, no stable nomination, no functional concern.
- Mark Brown: applied to `for-7.3`, with the standard note that merge-
  window patches go in the next window “or sooner **if it is a bug
  fix**” — i.e. this was **not** treated as a bugfix.

**Step 4.2 — Recipients (`b4 dig -w`)**
- Record: `broonie@kernel.org`, `linux-sound@vger.kernel.org`, `linux-
  kernel@vger.kernel.org`, `patches@opensource.cirrus.com`. Maintainer
  applied it.

**Step 4.3 — Bug report**
- Record: None. No syzbot, bugzilla, or user crash report.

**Step 4.4 — Related patches**
- Record: `[PATCH 0/2]` + `[PATCH 2/2]` sdw_utils codec_info. Both
  applied together (`3330b5f6d8dea`, `0306d21155819`).

**Step 4.5 — stable@**
- Record: lore.kernel.org/stable WebFetch returned 403. **UNVERIFIED**
  whether stable@ discussed it. Unlikely: 7.3 is still rc4 and this was
  merge-window work.

## Phase 5: Semantic / call graph

**Step 5.1 — Functions**
- Record: `cs35l56_sdw_probe`, `cs35l56_sdw_id[]`, `cs35l56_set_patch`,
  `cs35l56_set_fw_reg_table`, `cs35l56_system_reset`, `cs35l56_hw_init`,
  `_cs35l56_component_probe`.

**Step 5.2 — Callers**
- Record: `cs35l56_sdw_probe` is the `sdw_driver.probe` (SoundWire
  enumeration). `cs35l56_common_probe()` is called from SDW/I2C/SPI
  probe. `cs35l56_hw_init` / `cs35l56_set_patch` are called from the
  codec init path in `cs35l56.c`. `_cs35l56_component_probe` is the ALSA
  component probe. Not a syscall hot path; probe/runtime of this amp.

**Step 5.3 — Callees**
- Record: `devm_regmap_init_sdw`, `cs35l56_common_probe`,
  `regmap_register_patch`, `regmap_multi_reg_write_bypassed`,
  `snd_soc_add_component_controls`. No new helpers.

**Step 5.4 — Reachability**
- Record: Reachable when a CS35L62 SoundWire slave enumerates
  (laptops/SOF). Unprivileged userspace cannot trigger a crash path
  here; without the ID the device simply does not bind.

**Step 5.5 — Similar patterns**
- Record: Same pattern as CS35L63 (`978858791ceda`) and CS35L57 IDs.
  Remaining `case 0x57` blocks use `default:` for CS35L63-class parts,
  so CS35L62 is covered there.

## Phase 6: This tree

**Step 6.1 — Local tree and whether the code exists**
- Record: `git describe HEAD` = **v7.3-rc4-27-gf0100363d8c37**; `make
  kernelversion` = **7.3.0-rc4**. This is mainline 7.3-rc, not an LTS
  branch.
- Driver, CS35L63 paths, and the new IDs all exist here. `git merge-base
  --is-ancestor 978858791ceda HEAD` succeeds. `git merge-base --is-
  ancestor 3330b5f6d8dea HEAD` succeeds. CS35L62 first appears in
  **v7.3-rc1**, not v7.2.

**Step 6.2 — Backport difficulty**
- Record: Context here already includes later IRQ/ID-sort changes, but
  the hunks are trivial case/ID inserts. Expected apply: clean or
  trivial reorder. **Low difficulty.**

**Step 6.3 — Related fixes already here**
- Record: No alternate CS35L62 fix. Support is this series. ID table
  sort came after.

## Phase 7: Subsystem

**Step 7.1**
- Record: `[ASoC codec driver, Cirrus CS35L56 family] [IMPORTANT —
  common laptop speaker amps, not core mm/fs; not staging]`

**Step 7.2**
- Record: Actively maintained (many 2026 probe/IRQ/pm fixes). CS35L56 is
  mature; CS35L62 is a small ID alias on top of CS35L63.

## Phase 8: Impact and risk

**Step 8.1 — Who is affected**
- Record: Driver-specific / config-specific
  (`CONFIG_SND_SOC_CS35L56_SDW`). Only CS35L62 SoundWire hardware.
  Existing CS35L54/56/57/63 behavior unchanged.

**Step 8.2 — Trigger**
- Record: Device enumeration of part `0x3562`. Not a race. Not
  unprivileged exploit surface.

**Step 8.3 — Failure mode without the patch**
- Record: Device does not probe; no speaker amp. Severity **LOW** as a
  kernel bug (no oops/corruption), **HIGH** as hardware enablement for
  those machines.

**Step 8.4 — Benefit vs risk**
- Record: Benefit: CS35L62 SoundWire amps work on this kernel. Risk:
  very low (7 lines, additive cases). Ratio: favorable **if** treating
  this as a device-ID exception; poor **if** requiring a crash/security
  bug.

## Phase 9: Synthesis

**Step 9.1 — Evidence**

For:
- Matches the documented **new device ID** exception (SoundWire ID +
  cases routing to existing CS35L63 code).
- Small (7 lines), obviously correct, maintainer-applied.
- Driver and CS35L63 prerequisites exist in this 7.3 tree.
- No change to existing IDs’ control flow.
- Author is the Cirrus driver owner.

Against:
- Subject/body are **new feature**, not a bugfix. No crash, leak, UAF,
  deadlock, or CVE.
- Mark Brown applied it to **for-7.3 merge window**, not as a stable
  bugfix.
- Patch 1/2; SOF machine auto-config also wants `0306d21155819`.
- No `Reported-by` / no in-field bug.
- Stable rules 2 and 3 fail unless the ID exception is used.

Unresolved:
- stable@ lore search could not be fetched (403).

**Step 9.2 — Stable rules checklist**
1. Obviously correct and tested? **PASS** — aliasing is local and
   reviewed; applied by broonie. Only review comment was sort order.
2. Fixes a real bug that affects users? **FAIL** as a defect; **PASS**
   only under the device-ID exception (unsupported CS35L62).
3. Important issue (crash/security/corruption/deadlock)? **FAIL**
4. Small and contained? **PASS** (7 lines, one driver)
5. No new features or APIs? **FAIL** as a feature; **PASS** under
   device-ID exception (no new driver/API, only an ID)
6. Can apply to the local tree? **PASS** — CS35L63 paths present on
   7.3-rc4

**Step 9.3 — Exception**
- Record: **NEW DEVICE IDs** on an existing driver. Same class as adding
  a PCI/USB ID. Not a new driver, not a new uAPI.

**Step 9.4 — Decision**

This tree is **7.3.0-rc4**. The cs35l56 driver and CS35L63 handling are
present, so the patch is applicable here. It does not fix a stability
bug, but it is the standard “add ID to existing driver” pattern the
stable rules explicitly allow: one SoundWire ID and a handful of `case`
labels so CS35L62 reuses CS35L63. Risk to current users is negligible.
Companion sdw_utils entry is separate and not required for the codec to
bind.

### What it solves for users of this tree
Without the ID, a CS35L62 SoundWire amp never matches the driver. With
it, the existing CS35L63 path runs. That is hardware enablement, not a
crash fix.

### Rules / risk
Meets “small, obviously correct, no new API”. Importance is hardware
support, covered by the device-ID exception. Backport/apply risk is very
low.

---

Verification:
- [Phase 1] Parsed tags: SOB Binding/Fitzgerald/Brown; Link to patch
  1/2; no Fixes/Reported-by/stable Cc
- [Phase 2] Diff: +7 lines, ID `0x3562` + cases `0x62`/`0x35A620`
  reusing CS35L63
- [Phase 3] `git blame`: CS35L63 from `978858791ceda` (v6.16); CS35L62
  from `3330b5f6d8dea`
- [Phase 3] `git merge-base --is-ancestor 978858791ceda HEAD`: CS35L63
  in this tree
- [Phase 3] `git merge-base --is-ancestor 3330b5f6d8dea v7.3-rc1`: first
  in 7.3-rc1; not in v7.2
- [Phase 3] Series: 1/2 codec IDs, 2/2 `0306d21155819` sdw_utils
- [Phase 4] `b4 dig -c 3330b5f6d8dea`: v1 only; URL
  patch.msgid.link/20260715120135.939280-2-…
- [Phase 4] `b4 dig -a`: no later revision
- [Phase 4] `b4 dig -w`: broonie + linux-sound
- [Phase 4] mbox: Bossart sort-order nit only; Brown applied to for-7.3
- [Phase 4] WebFetch lore.kernel.org: 403; used b4 mbox + openwall
  instead
- [Phase 5] grep callers: SDW probe → `cs35l56_common_probe`;
  hw_init/set_patch from codec init
- [Phase 5] Other `case 0x63` sites updated; remaining type switches use
  `default:` for L63-class
- [Phase 6] `git describe HEAD` / `make kernelversion`: v7.3-rc4 /
  7.3.0-rc4; files present
- [Phase 8] Failure mode: no bind for CS35L62, not an oops; existing IDs
  unchanged
- UNVERIFIED: stable@ mailing list (lore 403)

**YES**

 sound/soc/codecs/cs35l56-sdw.c    | 2 ++
 sound/soc/codecs/cs35l56-shared.c | 4 ++++
 sound/soc/codecs/cs35l56.c        | 1 +
 3 files changed, 7 insertions(+)

diff --git a/sound/soc/codecs/cs35l56-sdw.c b/sound/soc/codecs/cs35l56-sdw.c
index a513a15d7e5a7..a7b4e2a923205 100644
--- a/sound/soc/codecs/cs35l56-sdw.c
+++ b/sound/soc/codecs/cs35l56-sdw.c
@@ -529,6 +529,7 @@ static int cs35l56_sdw_probe(struct sdw_slave *peripheral, const struct sdw_devi
 		regmap_config = &cs35l56_regmap_sdw;
 		break;
 	case 0x3563:
+	case 0x3562:
 		regmap_config = &cs35l63_regmap_sdw;
 		break;
 	default:
@@ -582,6 +583,7 @@ static const struct sdw_device_id cs35l56_sdw_id[] = {
 	SDW_SLAVE_ENTRY(0x01FA, 0x3556, 0x3556),
 	SDW_SLAVE_ENTRY(0x01FA, 0x3557, 0x3557),
 	SDW_SLAVE_ENTRY(0x01FA, 0x3563, 0x3563),
+	SDW_SLAVE_ENTRY(0x01FA, 0x3562, 0x3562),
 	{},
 };
 MODULE_DEVICE_TABLE(sdw, cs35l56_sdw_id);
diff --git a/sound/soc/codecs/cs35l56-shared.c b/sound/soc/codecs/cs35l56-shared.c
index 646bb4fbca025..3001ec45a72de 100644
--- a/sound/soc/codecs/cs35l56-shared.c
+++ b/sound/soc/codecs/cs35l56-shared.c
@@ -86,6 +86,7 @@ int cs35l56_set_patch(struct cs35l56_base *cs35l56_base)
 					    ARRAY_SIZE(cs35l56_patch_fw));
 		break;
 	case 0x63:
+	case 0x62:
 		ret = regmap_register_patch(cs35l56_base->regmap, cs35l63_patch_fw,
 					    ARRAY_SIZE(cs35l63_patch_fw));
 		break;
@@ -370,6 +371,7 @@ static void cs35l56_set_fw_reg_table(struct cs35l56_base *cs35l56_base)
 		}
 		break;
 	case 0x63:
+	case 0x62:
 		cs35l56_base->fw_reg = &cs35l63_fw_reg;
 		break;
 	}
@@ -576,6 +578,7 @@ void cs35l56_system_reset(struct cs35l56_base *cs35l56_base, bool is_soundwire)
 		}
 		break;
 	case 0x63:
+	case 0x62:
 		regmap_multi_reg_write_bypassed(cs35l56_base->regmap,
 						cs35l63_system_reset_seq,
 						ARRAY_SIZE(cs35l63_system_reset_seq));
@@ -1080,6 +1083,7 @@ int cs35l56_hw_init(struct cs35l56_base *cs35l56_base)
 		cs35l56_base->calibration_controls = &cs35l56_calibration_controls;
 		break;
 	case 0x35A630:
+	case 0x35A620:
 		cs35l56_base->calibration_controls = &cs35l63_calibration_controls;
 		devid = devid >> 4;
 		break;
diff --git a/sound/soc/codecs/cs35l56.c b/sound/soc/codecs/cs35l56.c
index e3334b2d84532..69976761ffa50 100644
--- a/sound/soc/codecs/cs35l56.c
+++ b/sound/soc/codecs/cs35l56.c
@@ -968,6 +968,7 @@ static int cs35l56_component_probe(struct snd_soc_component *component)
 						     ARRAY_SIZE(cs35l56_controls));
 		break;
 	case 0x63:
+	case 0x62:
 		ret = snd_soc_add_component_controls(component, cs35l63_controls,
 						     ARRAY_SIZE(cs35l63_controls));
 		break;
-- 
2.53.0

