Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F7CA5970D5;
	Mon, 31 Aug 2026 13:51:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184286; cv=none; b=sIrOqT6ILs5wKiM2giD9QVJM8261Hw9NsX2/pJboLDPP+XAeVbqd15C946WwSuRX/L/cXRWBEn0XeLQ13oy1Q0khNuNbnxSUhZkPpy7BfVSAoTlKYS4RORU+OqF5aCZSSuLyEs6bz5DWbfqCbbCIDPYWhsoniqtDJSh7ihjN3ac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184286; c=relaxed/simple;
	bh=b1+7sDCFr7Lzi605lxCk+6E6GtmibPSn9uWdStIKDrI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iX1hvsYqw1xEMqk1We6og8XxrvAF2JA4sTpK4dsyTzUrkdGpzf5DNLXALSsbL3IW0xGjLC8sg0vEJ5zOddInwelbbD7MrYN9ql9qmR0cgojhxzux1MEprKvqiQGjCwc80wt5CRLFI960DaGx6PaJcVTi6kKrEGh1xHJzA8aXzNU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fX6tVGFI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fX6tVGFI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 140531F000E9;
	Mon, 31 Aug 2026 13:51:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788184283;
	bh=Ry5bGhee1+Y43sY8l3F1gxSiDytd52XG4ku7HJvav4U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fX6tVGFIvQ8/hpjgcPv0/wUE/qh3r8NtXudfpCEDAmcDhXryO2+3tyQ/kbUx3HvWE
	 PiXUtERzgW6suLfB8bsUPZHTTmbATAaciSHKpIEHN+qX/hGBd+YJYIw17Spt1mBXfB
	 /+xH5vXwJyFaJuQ0gcdKJGrltZSkNxAdQ3/5w9l6H7GHUi24Lp6OwojiaQmKd3IbD5
	 lUdAZ4Yg2W/wy2/PHWXuNBsn8o6ynCBiIYX54+p2p64Wxif/JxiXB6dzunskDH8wdd
	 B/qUG1SvI/RvjD7jN7UJxsDqs3UqcEkYfANCdWaZeuYMhY8lg5elH4a8wv48fisw3+
	 lZIyGJm0Lvqng==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	linux-sound@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.6] soundwire: intel: Move suspend tracking from trigger to pm suspend
Date: Mon, 31 Aug 2026 09:30:28 -0400
Message-ID: <20260831133314.4125787-600-sashal@kernel.org>
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

From: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>

[ Upstream commit acf676b9de0c86bc735a7f04962d3d688e156ffc ]

Mark all open DAI runtimes as suspended in the component .suspend
callback instead of relying on SNDRV_PCM_TRIGGER_SUSPEND, which is
not delivered during PAUSE or xrun states.

If during system suspend a dai is open it means that it is in either in
SUSPENDED, PAUSED or STOPPED  (due to xrun) state and they will need to be
re-initialized during resume (which is done in .prepare callback).

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Signed-off-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Link: https://patch.msgid.link/20260508101755.1247039-1-yung-chuan.liao@linux.intel.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: `soundwire: intel: Move suspend tracking
from trigger to pm suspend`

**Local tree:** Linux 6.18.43 (`git describe HEAD` →
`v6.18.43-1-gc7f0dac02d232`)

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Subject Line
**Record:** `[soundwire: intel]` `[move]` — Relocate suspend-state
tracking from PCM trigger callback to component PM suspend callback.

### Step 1.2: Commit Message Tags
**Record:**
- **Signed-off-by:** Peter Ujfalusi, Bard Liao, Vinod Koul (subsystem
  maintainer)
- **Link:** https://patch.msgid.link/20260508101755.1247039-1-yung-
  chuan.liao@linux.intel.com
- No Fixes:, Reported-by:, Tested-by:, Reviewed-by:, Acked-by:, or Cc:
  stable@vger.kernel.org
- Notable: Maintainer (Vinod Koul) signed off; no syzbot/fuzzer report

### Step 1.3: Commit Body Analysis
**Record:**
- **Bug:** Suspend tracking relied on `SNDRV_PCM_TRIGGER_SUSPEND`, which
  ALSA does not deliver when a stream is in PAUSE or xrun (STOPPED)
  state at system-suspend time.
- **Symptom:** On resume, `.prepare()` does not reinitialize SHIM/DMA
  hardware because `dai_runtime->suspended` was never set; audio fails
  after suspend/resume.
- **Root cause:** `TRIGGER_SUSPEND` is only sent when
  `snd_pcm_running()` is true (RUNNING/DRAINING only).
- **Fix approach:** Mark all open DAIs suspended in the component
  `.suspend` callback, which runs during system PM suspend after PCM
  suspend.

### Step 1.4: Hidden Bug Fix Detection
**Record:** Yes — described as a refactor (“move”), but it fixes a real
suspend/resume correctness bug. The `suspended` flag gates hardware
reinit in `intel_prepare()`.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Change Inventory
**Record:**
- `drivers/soundwire/intel.c`: ~17 lines removed, ~10 modified (net −7)
- `drivers/soundwire/intel_ace2x.c`: ~14 lines removed, ~27 added (new
  `intel_component_dais_suspend`, `.suspend` hook)
- **Functions modified:** `intel_trigger()`,
  `intel_component_dais_suspend()` (intel.c); `intel_trigger()`, new
  `intel_component_dais_suspend()` (intel_ace2x.c)
- **Scope:** Single-subsystem, two related driver files; surgical fix

### Step 2.2: Code Flow Change
**Record:**

| Hunk | Before | After |
|------|--------|-------|
| `intel_trigger()` (both files) | On `SNDRV_PCM_TRIGGER_SUSPEND`, set
`dai_runtime->suspended = true` | `TRIGGER_SUSPEND` case removed; only
pause tracking remains |
| `intel_component_dais_suspend()` (intel.c) | Only set `suspended` if
`paused && !suspended` | Set `suspended = true` for every open
`dai_runtime` |
| `intel_ace2x.c` component driver | No `.suspend` callback | Adds
`intel_component_dais_suspend` + `.suspend` hook |

**Execution path affected:** System suspend (S3/runtime suspend) → ASoC
card suspend → PCM suspend → component suspend → resume → `.prepare()`.

### Step 2.3: Bug Mechanism
**Record:**
- **Category:** Logic/correctness — suspend-state tracking bug
- **Mechanism:** `snd_pcm_do_suspend()` in `sound/core/pcm_native.c`
  skips `TRIGGER_SUSPEND` when `!snd_pcm_running()`. PAUSED and XRUN
  streams are not “running,” so the driver never sets
  `dai_runtime->suspended`. `intel_prepare()` only reinitializes
  SHIM/ALH when `dai_runtime->suspended` is true.

Verified in tree:

```1713:1721:sound/core/pcm_native.c
static int snd_pcm_do_suspend(struct snd_pcm_substream *substream,
                              snd_pcm_state_t state)
{
        struct snd_pcm_runtime *runtime = substream->runtime;
        if (runtime->trigger_master != substream)
                return 0;
        if (! snd_pcm_running(substream))
                return 0;
        substream->ops->trigger(substream, SNDRV_PCM_TRIGGER_SUSPEND);
```

```711:716:include/sound/pcm.h
static inline int snd_pcm_running(struct snd_pcm_substream *substream)
{
        return (substream->runtime->state == SNDRV_PCM_STATE_RUNNING ||
                (substream->runtime->state == SNDRV_PCM_STATE_DRAINING
&&
                 substream->stream == SNDRV_PCM_STREAM_PLAYBACK));
}
```

### Step 2.4: Fix Quality
**Record:**
- Fix is minimal and matches the PM lifecycle; component suspend runs
  after `snd_pcm_suspend_all()` in `snd_soc_suspend()`.
- `intel.c` had a partial PAUSE workaround; this generalizes it to all
  open streams.
- `intel_ace2x.c` had no component suspend at all — worse for PAUSE and
  XRUN.
- **Regression risk:** Low. Setting `suspended` on already-suspended
  streams is idempotent; open streams need reinit after system sleep
  regardless.

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame
**Record:** `git blame` shows suspend-tracking code in `intel.c` at the
tree’s base commit (`a112b91dd6349`). History is shallow in this
checkout; exact introduction commit not determinable. Buggy code is
present in 6.18.43.

### Step 3.2: Fixes: Tag
**Record:** N/A — no Fixes: tag.

### Step 3.3: Related File History
**Record:** `git log --oneline -- drivers/soundwire/intel.c` returns
only the tree base commit (shallow history). Both `intel.c` and
`intel_ace2x.c` exist and are built via `soundwire-intel-y` in
`drivers/soundwire/Makefile`.

### Step 3.4: Author Context
**Record:** Peter Ujfalusi and Bard Liao are regular Intel SoundWire
contributors. Vinod Koul (SoundWire maintainer) committed. Standalone
fix, not part of a multi-patch series in the message.

### Step 3.5: Dependencies
**Record:** No prerequisites. Uses existing `for_each_component_dais`,
`dai_runtime_array`, and `intel_component_dais_suspend` pattern from
`intel.c`. Applies standalone to this tree.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: Original Discussion
**Record:** Lore/patch.msgid.link blocked (403/Anubis). `b4 dig` could
not match this commit (not in local history). **UNVERIFIED:** reviewer
feedback and stable nominations.

### Step 4.2: Reviewers
**Record:** **UNVERIFIED** — `b4 dig -w` not usable without matching
commit.

### Step 4.3: Bug Reports
**Record:** No external bug report tags. Mechanism verified from ALSA
core + driver code.

### Step 4.4: Related Patches
**Record:** Similar pattern in `sound/soc/sof/intel/hda-dai.c`
(`hda_dsp_dais_suspend`) documents the same ALSA `TRIGGER_SUSPEND`
limitation during PAUSE.

### Step 4.5: Stable List History
**Record:** **UNVERIFIED** — lore blocked.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Key Functions
**Record:** `intel_trigger()`, `intel_component_dais_suspend()`,
`intel_prepare()`, `cdns_set_sdw_stream()`

### Step 5.2: Callers
**Record:**
- `intel_trigger()` — ALSA/ASoC PCM trigger path
- `intel_component_dais_suspend()` — `snd_soc_component_suspend()` from
  `snd_soc_suspend()` during system suspend
- `intel_prepare()` — PCM prepare before start/resume after system sleep

### Step 5.3: Callees
**Record:** `intel_prepare()` calls `intel_pdi_shim_configure()`,
`intel_pdi_alh_configure()`, `sdw_cdns_config_stream()`,
`intel_params_stream()` when `dai_runtime->suspended` is true.

### Step 5.4: Reachability
**Record:** Triggered by system suspend/resume on machines with
`CONFIG_SND_SOC_SOF` + Intel SoundWire (`soundwire-intel` module).
Common on modern Intel laptops. Userspace does not need special
privileges beyond having audio open during suspend.

### Step 5.5: Similar Patterns
**Record:** SOF Intel HDA has the same PAUSE/`TRIGGER_SUSPEND`
workaround comment. Confirms this is a known ALSA limitation, not
driver-specific imagination.

---

## PHASE 6: CROSS-REFERENCING AGAINST LOCAL TREE (6.18.43)

### Step 6.1: Buggy Code Present?
**Record:** **Yes.** Verified:
- `intel.c`: `TRIGGER_SUSPEND` in `intel_trigger()` (line 910); partial
  `intel_component_dais_suspend()` (only handles `paused`)
- `intel_ace2x.c`: `TRIGGER_SUSPEND` in `intel_trigger()` (line 825);
  **no** `.suspend` callback
- `dai_runtime->suspended` used in `intel_prepare()` in both files

### Step 6.2: Backport Complications
**Record:** Expected clean apply. Current code matches the patch
context. No conflicting refactors observed.

### Step 6.3: Related Fixes Already Present?
**Record:** Partial PAUSE-only workaround exists in `intel.c` only. No
fix for XRUN; `intel_ace2x.c` unprotected. This commit not yet applied.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

### Step 7.1: Subsystem Criticality
**Record:** `drivers/soundwire/` — IMPORTANT (Intel laptop audio via
SoundWire). Not core kernel, but affects many production systems.

### Step 7.2: Subsystem Activity
**Record:** Actively maintained Intel audio path. `intel_ace2x.c` is
part of current `soundwire-intel` build.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: Who Is Affected
**Record:** Users of Intel SoundWire audio (Tiger Lake and newer Intel
platforms with SOF + SoundWire codecs). Config: `CONFIG_SOUNDWIRE` /
`soundwire-intel` module.

### Step 8.2: Trigger Conditions
**Record:**
- System suspend while audio stream is open and PAUSED, or
- System suspend while stream is in xrun (STOPPED) state
- Moderately common: paused music/video, buffer underrun before lid-
  close
- Unprivileged user with open PCM device

### Step 8.3: Failure Mode Severity
**Record:** Audio broken after resume until full PCM teardown/reopen.
**Severity: HIGH** (functional breakage on suspend/resume, not a kernel
oops, but serious UX impact on laptops).

### Step 8.4: Risk-Benefit
**Record:**
- **Benefit:** HIGH — fixes real suspend/resume audio failure
- **Risk:** LOW — ~50 lines, idempotent flag set, no API changes
- **Ratio:** Strongly favors backport

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence Summary

**FOR backport:**
- Real bug with verified ALSA mechanism (`snd_pcm_running()` gate)
- User-visible suspend/resume audio failure
- Small, surgical, maintainer-reviewed fix
- Buggy code present in 6.18.43 (both `intel.c` and `intel_ace2x.c`)
- `intel_ace2x.c` completely lacks component suspend today
- Same class of fix as existing SOF HDA workaround

**AGAINST backport:**
- Driver-specific (not universal)
- No fuzzer/CVE report
- Lore review discussion unverified

**UNRESOLVED:**
- Original mailing-list review thread
- Exact mainline commit SHA in this checkout

### Step 9.2: Stable Rules Checklist
1. Obviously correct and tested? **PASS** — logic matches ALSA PM
   behavior; maintainer SOB
2. Fixes a real user-affecting bug? **PASS**
3. Important issue? **PASS** — suspend/resume audio failure (HIGH)
4. Small and contained? **PASS** — ~50 lines, 2 files
5. No new features/APIs? **PASS** — moves existing tracking to correct
   callback
6. Can apply to local tree? **PASS** — code present, structure matches

### Step 9.3: Exception Categories
**Record:** N/A — standard bug fix, not device-ID/quirk/DT/build/doc
exception.

### Step 9.4: Decision Rationale
For Linux 6.18.43, the suspend-tracking bug exists in both Intel
SoundWire driver files. The ALSA core deliberately does not send
`TRIGGER_SUSPEND` for PAUSED or xrun streams, so the current trigger-
based tracking is incomplete. Without `dai_runtime->suspended`,
`intel_prepare()` skips hardware reinit after system resume, leaving
audio broken. The fix is small, correct, and addresses a realistic
laptop suspend scenario.

---

## Verification

- **[Phase 1]** Parsed subject, tags, body from provided commit message
- **[Phase 1]** Identified hidden bug fix (suspend/resume correctness)
- **[Phase 2]** Diff: 2 files, `intel_trigger` +
  `intel_component_dais_suspend` changes
- **[Phase 2]** Read `snd_pcm_do_suspend()` — confirmed
  `TRIGGER_SUSPEND` skipped when `!snd_pcm_running()`
- **[Phase 2]** Read `snd_pcm_running()` — only RUNNING/DRAINING return
  true
- **[Phase 2]** Read `intel_prepare()` in `intel.c` and `intel_ace2x.c`
  — reinit gated on `dai_runtime->suspended`
- **[Phase 3]** `git describe HEAD` → v6.18.43
- **[Phase 3]** `git blame` on `intel.c:910-980` — code at tree base
- **[Phase 3]** Shallow history: only base commit for soundwire files
- **[Phase 4]** WebFetch lore/patch.msgid.link — blocked (Anubis/403)
- **[Phase 4]** `curl` lore raw — 403 Forbidden
- **[Phase 4]** `b4 dig -c HEAD` — no match for this commit
- **[Phase 4]** Found analogous SOF HDA comment in `hda-dai.c:935-941`
- **[Phase 5]** Traced suspend path: `snd_soc_suspend()` →
  `snd_pcm_suspend_all()` then `snd_soc_component_suspend()`
- **[Phase 5]** Verified `for_each_component_dais` in
  `include/sound/soc-component.h`
- **[Phase 5]** Verified `dai_runtime_array` allocated in
  `cdns_set_sdw_stream()` when stream is set
- **[Phase 6]** Confirmed buggy code in `intel.c` (partial PAUSE fix, no
  XRUN fix)
- **[Phase 6]** Confirmed `intel_ace2x.c` has no `.suspend` callback
- **[Phase 6]** Confirmed both files built via
  `drivers/soundwire/Makefile`
- **[Phase 8]** Failure mode: audio broken after suspend/resume — HIGH
  severity
- **UNVERIFIED:** Mailing-list reviewer feedback and stable nominations
- **UNVERIFIED:** Mainline commit SHA in this checkout

**YES**The background history search finished. In this 6.18.43 checkout,
`git log -S 'intel_component_dais_suspend'` only turns up the tree base
commit (`a112b91dd6349`), so the shallow history here doesn’t show when
suspend tracking was originally added.

That doesn’t change the backport call: the buggy code is present in both
`intel.c` and `intel_ace2x.c`, and the fix still looks appropriate for
this tree.

**YES**

 drivers/soundwire/intel.c       | 31 ++++++--------------------
 drivers/soundwire/intel_ace2x.c | 39 ++++++++++++++++++++++-----------
 2 files changed, 33 insertions(+), 37 deletions(-)

diff --git a/drivers/soundwire/intel.c b/drivers/soundwire/intel.c
index 9db78f3d76152..a83371233603b 100644
--- a/drivers/soundwire/intel.c
+++ b/drivers/soundwire/intel.c
@@ -907,19 +907,6 @@ static int intel_trigger(struct snd_pcm_substream *substream, int cmd, struct sn
 	}
 
 	switch (cmd) {
-	case SNDRV_PCM_TRIGGER_SUSPEND:
-
-		/*
-		 * The .prepare callback is used to deal with xruns and resume operations.
-		 * In the case of xruns, the DMAs and SHIM registers cannot be touched,
-		 * but for resume operations the DMAs and SHIM registers need to be initialized.
-		 * the .trigger callback is used to track the suspend case only.
-		 */
-
-		dai_runtime->suspended = true;
-
-		break;
-
 	case SNDRV_PCM_TRIGGER_PAUSE_PUSH:
 		dai_runtime->paused = true;
 		break;
@@ -956,10 +943,12 @@ static int intel_component_dais_suspend(struct snd_soc_component *component)
 	struct snd_soc_dai *dai;
 
 	/*
-	 * In the corner case where a SUSPEND happens during a PAUSE, the ALSA core
-	 * does not throw the TRIGGER_SUSPEND. This leaves the DAIs in an unbalanced state.
-	 * Since the component suspend is called last, we can trap this corner case
-	 * and force the DAIs to release their resources.
+	 * Mark all open streams as suspended.
+	 * Open streams at this point can be in SUSPENDED, PAUSED or STOPPED
+	 * state and during prepare the DMAs and SHIM registers need to be
+	 * initialized for them.
+	 * The STOPPED state is a special corner case which can happen if audio
+	 * experiences xrun at suspend time.
 	 */
 	for_each_component_dais(component, dai) {
 		struct sdw_cdns *cdns = snd_soc_dai_get_drvdata(dai);
@@ -967,13 +956,7 @@ static int intel_component_dais_suspend(struct snd_soc_component *component)
 
 		dai_runtime = cdns->dai_runtime_array[dai->id];
 
-		if (!dai_runtime)
-			continue;
-
-		if (dai_runtime->suspended)
-			continue;
-
-		if (dai_runtime->paused)
+		if (dai_runtime)
 			dai_runtime->suspended = true;
 	}
 
diff --git a/drivers/soundwire/intel_ace2x.c b/drivers/soundwire/intel_ace2x.c
index 63aef98361467..f0e0a79b30b0e 100644
--- a/drivers/soundwire/intel_ace2x.c
+++ b/drivers/soundwire/intel_ace2x.c
@@ -822,19 +822,6 @@ static int intel_trigger(struct snd_pcm_substream *substream, int cmd, struct sn
 	}
 
 	switch (cmd) {
-	case SNDRV_PCM_TRIGGER_SUSPEND:
-
-		/*
-		 * The .prepare callback is used to deal with xruns and resume operations.
-		 * In the case of xruns, the DMAs and SHIM registers cannot be touched,
-		 * but for resume operations the DMAs and SHIM registers need to be initialized.
-		 * the .trigger callback is used to track the suspend case only.
-		 */
-
-		dai_runtime->suspended = true;
-
-		break;
-
 	case SNDRV_PCM_TRIGGER_PAUSE_PUSH:
 		dai_runtime->paused = true;
 		break;
@@ -858,8 +845,34 @@ static const struct snd_soc_dai_ops intel_pcm_dai_ops = {
 	.get_stream = intel_get_sdw_stream,
 };
 
+static int intel_component_dais_suspend(struct snd_soc_component *component)
+{
+	struct snd_soc_dai *dai;
+
+	/*
+	 * Mark all open streams as suspended.
+	 * Open streams at this point can be in SUSPENDED, PAUSED or STOPPED
+	 * state and during prepare the DMAs and SHIM registers need to be
+	 * initialized for them.
+	 * The STOPPED state is a special corner case which can happen if audio
+	 * experiences xrun at suspend time.
+	 */
+	for_each_component_dais(component, dai) {
+		struct sdw_cdns *cdns = snd_soc_dai_get_drvdata(dai);
+		struct sdw_cdns_dai_runtime *dai_runtime;
+
+		dai_runtime = cdns->dai_runtime_array[dai->id];
+
+		if (dai_runtime)
+			dai_runtime->suspended = true;
+	}
+
+	return 0;
+}
+
 static const struct snd_soc_component_driver dai_component = {
 	.name			= "soundwire",
+	.suspend		= intel_component_dais_suspend,
 };
 
 /*
-- 
2.53.0

