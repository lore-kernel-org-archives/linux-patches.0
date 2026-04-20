Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 127B03CE48F;
	Mon, 20 Apr 2026 13:17:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776691076; cv=none; b=PBmTk6r/mjDZCPXJ4ZxMoIZJ0NA/YHBDRTuDjDNoMvEiZI+pES2Wd51740qupkHNLweFUoH8GFW8hchGanJBcB5MFKMaSyxbHHW4WA0BA6+sqVGUTwpjEkOa1LxCU5HplgCtQJhozBZjAkP9OJ7GOrmzGr0XzNEwZycJntofbmg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776691076; c=relaxed/simple;
	bh=HeIqewgVBjC+cs5vcBEs31qFo9TZK6JeLdzhZB2khp4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=M+MfjQN5DooTkyU6/N+bRhYyW+3u3kA5TdhnDmrbkJsgjhyBaw/iiFvGGpY02/hrOz+lDSS9gS/3SM7hwKwgzu59EokXZocVBPFEuaLd7Jabh4pK0bpFpQ2WvRQtgHukWSbsCwkqbrcE2Y/FZxAm4VnSGCFrQYJLUuL24lmW2qg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ObcagBTT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ObcagBTT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA6C4C2BCB7;
	Mon, 20 Apr 2026 13:17:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776691076;
	bh=HeIqewgVBjC+cs5vcBEs31qFo9TZK6JeLdzhZB2khp4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ObcagBTTU0NkILVh+hI2iDG0XHY/wo5QveBBByMlgWiapUvaBmVAnDr+6Gm2p8H7h
	 oaLNn95qw7Ojr/7EB2hMglsUZvQ3wxFHokQuh7uiwK5OKauIWjc0l/SfH6QLDFxPOv
	 9Iz2+wROCu4+K8P2T03tZXuBTFFkIJBNMwBL0y7zOEh5aAE1THgIVxLcWF48ygQ2rg
	 Ksql9uWVS0owpOIFkETuzGl9uqZDW11wTy4TYtBlKtSGZUuCRpv3VT/gcQu6hF+KP3
	 SVhFmMZyGwr1j4jjZFH3oV1g1RULWuELKS/tR5ty7bB1/nA713uwXfOslnh6PeDBBI
	 1L1/mnng8hU6Q==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Marek Vasut <marex@nabladev.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	lgirdwood@gmail.com,
	perex@perex.cz,
	tiwai@suse.com,
	alsa-devel@alsa-project.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0-5.10] ASoC: tas2552: Allow audio enable GPIO to sleep
Date: Mon, 20 Apr 2026 09:09:05 -0400
Message-ID: <20260420131539.986432-79-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420131539.986432-1-sashal@kernel.org>
References: <20260420131539.986432-1-sashal@kernel.org>
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

From: Marek Vasut <marex@nabladev.com>

[ Upstream commit 5ebc20921b7fff9feb44de465448e17a382c9965 ]

The audio enable GPIO is not toggled in any critical section where it
could not sleep, allow the audio enable GPIO to sleep. This allows the
driver to operate the audio enable GPIO connected to I2C GPIO expander.

Signed-off-by: Marek Vasut <marex@nabladev.com>
Link: https://patch.msgid.link/20260220202332.241035-1-marex@nabladev.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I have all the information needed for the full analysis.

---

## PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1: Subject Line**
- Subsystem: `ASoC: tas2552` (sound, ASoC codec driver)
- Action verb: "Allow" - implies enabling something previously not
  supported
- Summary: Allow the enable GPIO to sleep, enabling use with I2C GPIO
  expanders

**Step 1.2: Tags**
- Signed-off-by: Marek Vasut <marex@nabladev.com> (author)
- Link:
  https://patch.msgid.link/20260220202332.241035-1-marex@nabladev.com
- Signed-off-by: Mark Brown <broonie@kernel.org> (ASoC subsystem
  maintainer)
- No Fixes: tag, no Reported-by, no Cc: stable (expected for autosel
  candidates)

**Step 1.3: Commit Body**
The commit describes that the enable GPIO is never toggled from atomic
context, so it's safe to use the sleeping variant. This allows the
driver to work when the enable GPIO is connected to an I2C GPIO expander
(which requires sleeping for bus access).

**Step 1.4: Hidden Bug Fix Detection**
YES - this is a bug fix. Using `gpiod_set_value()` with a sleeping GPIO
triggers `WARN_ON(desc->gdev->can_sleep)` in gpiolib.c:3899. This is
incorrect API usage that produces kernel warnings.

## PHASE 2: DIFF ANALYSIS

**Step 2.1: Inventory**
- 1 file changed: `sound/soc/codecs/tas2552.c`
- 5 lines changed (identical substitution at each site)
- Functions modified: `tas2552_runtime_suspend`,
  `tas2552_runtime_resume`, `tas2552_component_probe` (x2),
  `tas2552_component_remove`

**Step 2.2: Code Flow Change**
Each hunk is identical: `gpiod_set_value(tas2552->enable_gpio, X)` ->
`gpiod_set_value_cansleep(tas2552->enable_gpio, X)`. No logic change —
both APIs call the same `gpiod_set_value_nocheck()` internally.

**Step 2.3: Bug Mechanism**
Verified in `drivers/gpio/gpiolib.c`:

```3895:3901:drivers/gpio/gpiolib.c
int gpiod_set_value(struct gpio_desc *desc, int value)
{
        VALIDATE_DESC(desc);
        /* Should be using gpiod_set_value_cansleep() */
        WARN_ON(desc->gdev->can_sleep);
        return gpiod_set_value_nocheck(desc, value);
}
```

vs:

```4359:4364:drivers/gpio/gpiolib.c
int gpiod_set_value_cansleep(struct gpio_desc *desc, int value)
{
        might_sleep();
        VALIDATE_DESC(desc);
        return gpiod_set_value_nocheck(desc, value);
}
```

The bug: When the enable GPIO is on an I2C GPIO expander (`can_sleep =
true`), `gpiod_set_value()` fires `WARN_ON` producing a kernel warning
with stack trace on every suspend/resume cycle and on probe/remove.

**Step 2.4: Fix Quality**
- Obviously correct: the only change is which wrapper is used; both call
  the same underlying function
- Minimal: 5 identical one-line substitutions
- Zero regression risk: `gpiod_set_value_cansleep()` is strictly more
  permissive (works with both sleeping and non-sleeping GPIOs)
- All call sites are process context (PM callbacks, probe, remove) where
  sleeping is allowed

## PHASE 3: GIT HISTORY

**Step 3.1: Blame**
The `gpiod_set_value()` calls were introduced by commit `82cf77a1bd61d9`
(Axel Lin, 2015) which simplified NULL checks. The original code existed
since `5df7f71d5cdfbc` (Dan Murphy, 2014). The buggy code has been
present since v4.3-rc1.

**Step 3.2: Fixes tag**
No Fixes: tag present (expected for autosel).

**Step 3.3: File History**
Recent changes to the file are trivial: RUNTIME_PM_OPS conversion,
removing redundant `pm_runtime_mark_last_busy()`, dropping unused GPIO
includes. No conflicts.

**Step 3.4: Author**
Marek Vasut is a prolific kernel contributor with extensive work across
DRM, DT bindings, and sound subsystems. Not the TAS2552 maintainer but a
well-known contributor.

**Step 3.5: Prerequisites**
None. The change is standalone and independent of the RUNTIME_PM_OPS
conversion. It touches only the `gpiod_set_value()` calls which exist in
all stable trees.

## PHASE 4: MAILING LIST RESEARCH

**Step 4.1: Original Patch**
Found via `b4 am`. The patch was submitted as a single standalone patch
on 2026-02-20. CC'd appropriate maintainers (Mark Brown, Takashi Iwai,
TI engineers, linux-sound, linux-kernel). Applied directly by Mark Brown
(ASoC maintainer). No v2/v3 revisions — accepted as-is.

**Step 4.2: Reviewers**
The patch was CC'd to all relevant TI and ASoC maintainers. Mark Brown
(ASoC subsystem maintainer) applied it directly.

**Step 4.3: Bug Report**
No external bug report. Marek Vasut likely encountered this on a board
with an I2C GPIO expander.

**Step 4.4: Related Patches**
This is a well-established pattern. Multiple identical fixes have been
applied to other ASoC codecs:
- `5f83ee4b1f0c0` ASoC: tas5086: use sleeping variants of gpiod API
- `897d8e86bac76` ASoC: tlv320aic31xx: switch to
  gpiod_set_value_cansleep
- `5d7e0b1516dfc` ASoC: dmic: Allow GPIO operations to sleep
- `ea2a2ad17ca1e` ASoC: dio2125: use gpiod_set_value_cansleep (had
  Fixes: tag)

**Step 4.5: Stable Discussion**
No stable-specific discussion found. The dio2125 variant (ea2a2ad17ca1e)
had a Fixes: tag and was likely auto-selected for stable.

## PHASE 5: CODE SEMANTIC ANALYSIS

**Step 5.1: Functions Modified**
- `tas2552_runtime_suspend()` — PM runtime callback
- `tas2552_runtime_resume()` — PM runtime callback
- `tas2552_component_probe()` — ASoC component probe (x2 sites)
- `tas2552_component_remove()` — ASoC component remove

**Step 5.2: Callers**
All five call sites are invoked from process context:
- Runtime PM callbacks are invoked by the PM subsystem in process
  context
- Component probe/remove are called from the ASoC registration path,
  always sleepable

**Step 5.3-5.4: No atomic context concerns**
All callers can sleep. The `gpiod_set_value_cansleep()` API with its
`might_sleep()` is the correct choice.

**Step 5.5: Similar Patterns**
There are 5 remaining `gpiod_set_value()` calls in this file — this
patch converts all of them. Other ASoC drivers have undergone identical
transformations.

## PHASE 6: STABLE TREE ANALYSIS

**Step 6.1: Buggy Code in Stable?**
YES. The `gpiod_set_value()` calls date back to commit `82cf77a1bd61d9`
(v4.3-rc1, 2015). All active stable trees contain this code.

**Step 6.2: Backport Complications**
Minimal. The `gpiod_set_value()` lines are identical across all stable
versions. The only difference is that pre-6.12 trees have `#ifdef
CONFIG_PM` guards and `SET_RUNTIME_PM_OPS` instead of `RUNTIME_PM_OPS`,
but this doesn't affect the changed lines. The patch should apply
cleanly or with trivial context offset.

**Step 6.3: No Existing Fix**
No related fix for this specific issue in any stable tree.

## PHASE 7: SUBSYSTEM CONTEXT

**Step 7.1:** Sound/ASoC codec driver — PERIPHERAL criticality (specific
codec driver), but TAS2552 is used in embedded systems.

**Step 7.2:** The driver is mature/stable with minimal recent activity
(only cleanup commits).

## PHASE 8: IMPACT AND RISK ASSESSMENT

**Step 8.1: Affected Users**
Users of the TAS2552 audio amplifier who have the enable GPIO connected
to an I2C GPIO expander. This is a valid embedded hardware
configuration.

**Step 8.2: Trigger Conditions**
The WARN_ON triggers on EVERY suspend/resume cycle and on driver
probe/remove — not rare at all for affected hardware.

**Step 8.3: Failure Mode**
- WARN_ON with full stack trace in kernel log (MEDIUM severity normally)
- With `panic_on_warn=1`: kernel panic (CRITICAL severity for those
  configurations)
- Without panic_on_warn: console spam, log pollution, incorrect API
  usage flagged

**Step 8.4: Risk-Benefit**
- BENEFIT: Eliminates WARN_ON spam, enables I2C GPIO expander hardware
  correctly, fixes incorrect API usage
- RISK: Virtually zero — both APIs call the same underlying function,
  the only difference is the debug assertion

## PHASE 9: FINAL SYNTHESIS

**Step 9.1: Evidence Summary**

FOR backporting:
- Fixes incorrect GPIO API usage that triggers WARN_ON
- Can cause kernel panic with `panic_on_warn=1`
- Trivially small (5 identical line substitutions), trivially correct
- Zero regression risk (both APIs have identical functional behavior)
- Well-established pattern applied to many other drivers
- Applied by ASoC subsystem maintainer Mark Brown
- Buggy code present since v4.3 — affects all stable trees
- No dependencies on other patches

AGAINST backporting:
- No Reported-by (no evidence of real-world user reports)
- WARN_ON is non-fatal in default configurations
- Affects specific hardware configuration (I2C GPIO expander)
- Could be seen as "enablement" rather than pure "fix"

**Step 9.2: Stable Rules Checklist**
1. Obviously correct and tested: YES — trivially provable
2. Fixes a real bug: YES — WARN_ON from incorrect API usage
3. Important issue: MEDIUM — WARN_ON, potential panic with panic_on_warn
4. Small and contained: YES — 5 lines in 1 file
5. No new features: YES — just API correction
6. Can apply to stable: YES — clean apply expected

**Step 9.3: Exception Categories**
This is closest to a hardware quirk/workaround — it makes the driver
work correctly with I2C GPIO expanders.

## Verification

- [Phase 1] Parsed tags: Signed-off-by from author and ASoC maintainer,
  Link to patch.msgid
- [Phase 2] Diff analysis: 5 identical `gpiod_set_value` ->
  `gpiod_set_value_cansleep` substitutions
- [Phase 2] Verified `gpiod_set_value()` has
  `WARN_ON(desc->gdev->can_sleep)` at gpiolib.c:3899
- [Phase 2] Verified `gpiod_set_value_cansleep()` calls same
  `gpiod_set_value_nocheck()` at gpiolib.c:4363
- [Phase 3] git blame: `gpiod_set_value` calls introduced by commit
  82cf77a1bd61d9 (v4.3-rc1, 2015)
- [Phase 3] git log: no conflicting changes in recent history
- [Phase 3] RUNTIME_PM_OPS conversion (1570c33f2f38b) does not affect
  the changed lines
- [Phase 4] b4 am: found original patch, single standalone submission
- [Phase 4] Multiple identical fixes applied to other ASoC codecs
  (tas5086, tlv320aic31xx, dmic, dio2125)
- [Phase 5] All call sites (runtime_suspend/resume,
  component_probe/remove) are process context — can sleep
- [Phase 6] Buggy code present since v4.3, exists in all active stable
  trees
- [Phase 6] Patch applies cleanly — no conflicting changes to the
  affected lines
- [Phase 8] WARN_ON triggers on every suspend/resume for affected
  hardware, not a rare event

The fix is trivially correct, carries zero regression risk, and fixes
incorrect GPIO API usage that produces kernel warnings (and potential
panics) for valid hardware configurations. While it's not fixing a crash
in the default configuration, the WARN_ON is a genuine bug indicator,
and this well-established pattern has been applied to many other
drivers.

**YES**

 sound/soc/codecs/tas2552.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/sound/soc/codecs/tas2552.c b/sound/soc/codecs/tas2552.c
index 43449d7c25843..80206c2e09462 100644
--- a/sound/soc/codecs/tas2552.c
+++ b/sound/soc/codecs/tas2552.c
@@ -487,7 +487,7 @@ static int tas2552_runtime_suspend(struct device *dev)
 	regcache_cache_only(tas2552->regmap, true);
 	regcache_mark_dirty(tas2552->regmap);
 
-	gpiod_set_value(tas2552->enable_gpio, 0);
+	gpiod_set_value_cansleep(tas2552->enable_gpio, 0);
 
 	return 0;
 }
@@ -496,7 +496,7 @@ static int tas2552_runtime_resume(struct device *dev)
 {
 	struct tas2552_data *tas2552 = dev_get_drvdata(dev);
 
-	gpiod_set_value(tas2552->enable_gpio, 1);
+	gpiod_set_value_cansleep(tas2552->enable_gpio, 1);
 
 	tas2552_sw_shutdown(tas2552, 0);
 
@@ -583,7 +583,7 @@ static int tas2552_component_probe(struct snd_soc_component *component)
 		return ret;
 	}
 
-	gpiod_set_value(tas2552->enable_gpio, 1);
+	gpiod_set_value_cansleep(tas2552->enable_gpio, 1);
 
 	ret = pm_runtime_resume_and_get(component->dev);
 	if (ret < 0) {
@@ -608,7 +608,7 @@ static int tas2552_component_probe(struct snd_soc_component *component)
 
 probe_fail:
 	pm_runtime_put_noidle(component->dev);
-	gpiod_set_value(tas2552->enable_gpio, 0);
+	gpiod_set_value_cansleep(tas2552->enable_gpio, 0);
 
 	regulator_bulk_disable(ARRAY_SIZE(tas2552->supplies),
 					tas2552->supplies);
@@ -621,7 +621,7 @@ static void tas2552_component_remove(struct snd_soc_component *component)
 
 	pm_runtime_put(component->dev);
 
-	gpiod_set_value(tas2552->enable_gpio, 0);
+	gpiod_set_value_cansleep(tas2552->enable_gpio, 0);
 };
 
 #ifdef CONFIG_PM
-- 
2.53.0

