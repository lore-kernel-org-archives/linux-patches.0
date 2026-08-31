Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A064A57C718;
	Mon, 31 Aug 2026 13:49:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184172; cv=none; b=ECtlt5Ri2dtO7SXco913ciRfv+FD5EwBlgNwrlsTKFTMVo1u0cfEnYIW7OZhRtVR1fsPsvr7Qizg118taHL1g4CUuqTpKzbSMaPGg0yhfWS1vD3v6+ecNOJrhIYm5lVIcZcqfvc4jRTqzQNn5xNG88Kw0NBTDu7XdtTpnIDUs1o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184172; c=relaxed/simple;
	bh=F++zOrZUfFCl4dMqyhUNgy1wujKjS2nvZvxLdPsb8nU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ozbir6V9XP5nGW9uuxf1DWiSRLTmvZOR4OqSv7nzuL/WhAGeaRio3Jyi1rSntvefEGQyirO3CApG6rweSyhfOWE35zCA5B7l1tcTOPeJVqIJ9s09tzHjT7GYT52baVhExhAHUxEN/entfxddFrfvfJ8VkzjuBqdhF3kowi0v6SU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Iz8Pt/+m; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Iz8Pt/+m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79D861F00A3D;
	Mon, 31 Aug 2026 13:49:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788184169;
	bh=aNzPL9t3Ch3R/81vyFJ8KYM8BGwN9BjbkzaDJlczB9s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Iz8Pt/+mpkLUwne18t+ToVQdXGELRBTYvz3hfQL+/T6qfMb2E8Yo0vIGmeNqbpdqG
	 ntdEoAnDVU7m2wkdoAxWboItzoOETjby2C2B3JbPF1hquVVNH4KTTMCB4p5N+649Ki
	 0Q21KSw1hzzReD6BeXfo3/4lLlXXdwJzOfkc9qGxKX2+gYlXqvQRLcrkiKj6t+Z/l7
	 xb3w+Od84Z0J6fXzPJH9iGrbCvkDVaYwgBN8Ceg8fQw+6Gf2B9y2yTDiR6Rojjduv2
	 Rv1fZ791/RSi47C2jQBpfBJjcQF1H99jqIpvaywjrFg9FCbcrbpBd5GnkoSe4nsmim
	 QB3FOfh/YcPiA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: bui duc phuc <phucduc.bui@gmail.com>,
	Sashiko AI Review <sashiko-bot@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	lgirdwood@gmail.com,
	perex@perex.cz,
	tiwai@suse.com,
	heiko@sntech.de,
	linux-sound@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-rockchip@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] ASoC: rockchip: spdif: Restore regcache cache-only mode on sync failure
Date: Mon, 31 Aug 2026 09:29:20 -0400
Message-ID: <20260831133314.4125787-532-sashal@kernel.org>
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

From: bui duc phuc <phucduc.bui@gmail.com>

[ Upstream commit 3546e9aa691ac981e4734fedd1646d0180784893 ]

If regcache_sync() fails during runtime resume, the driver disables the
clocks and returns an error. However, the regmap cache-only mode is left
disabled.
Restore cache-only mode in the error path so subsequent register accesses
continue to use the cache while the device is inactive.

Reported-by: Sashiko AI Review <sashiko-bot@kernel.org>
Closes: https://lore.kernel.org/all/20260522103713.6C09D1F000E9@smtp.kernel.org/
Signed-off-by: bui duc phuc <phucduc.bui@gmail.com>
Link: https://patch.msgid.link/20260602101608.45137-5-phucduc.bui@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit Message Forensics

### Step 1.1: Subject Line
**Record:** `[ASoC: rockchip: spdif] [Restore] Restore regcache cache-
only mode on sync failure during runtime resume error path`

### Step 1.2: Commit Tags
**Record:**
- **Reported-by:** Sashiko AI Review `<sashiko-bot@kernel.org>` —
  automated review bot, not a user crash report
- **Closes:** https://lore.kernel.org/all/20260522103713.6C09D1F000E9@sm
  tp.kernel.org/ — Sashiko review thread
- **Signed-off-by:** bui duc phuc `<phucduc.bui@gmail.com>` — author
- **Link:**
  https://patch.msgid.link/20260602101608.45137-5-phucduc.bui@gmail.com
  — patch 5 of a series (message-id suffix)
- **Signed-off-by:** Mark Brown `<broonie@kernel.org>` — ASoC subsystem
  maintainer
- **No Fixes:** tag (expected for manual review pipeline)
- **No Cc: stable@vger.kernel.org** (expected; not a negative signal)
- **No Tested-by / Reviewed-by / Acked-by**

Notable: maintainer sign-off from Mark Brown; same author
(`phucduc.bui`) recently landed an analogous `regcache_cache_only`
error-path fix for `gpio-pca953x` with `Cc: stable@vger.kernel.org`.

### Step 1.3: Commit Body Analysis
**Record:**
- **Bug:** On `regcache_sync()` failure in `rk_spdif_runtime_resume()`,
  clocks are disabled and an error is returned, but
  `regcache_cache_only(false)` is never reverted.
- **Symptom:** After a failed resume, regmap leaves cache-only mode
  while the device is inactive; subsequent register accesses attempt
  hardware I/O instead of using the cache.
- **Root cause:** Incomplete error-path state restoration — suspend sets
  `cache_only(true)`, resume sets `cache_only(false)` before sync, but
  the sync-failure path omits restoring `cache_only(true)`.
- **Version info:** None stated in the commit message.

### Step 1.4: Hidden Bug Fix Detection
**Record:** Not disguised — this is an explicit error-path state-machine
bug fix, though the subject uses "Restore" rather than "fix".

---

## Phase 2: Diff Analysis

### Step 2.1: Change Inventory
**Record:**
- **Files:** `sound/soc/rockchip/rockchip_spdif.c` — 1 line added (+1
  net in the shown hunk)
- **Function modified:** `rk_spdif_runtime_resume()`
- **Scope:** Single-file, surgical fix

Note: upstream diff shows `hclk` enabled before `mclk`; this tree
enables `mclk` then `hclk`. The added line placement (inside the
`regcache_sync()` failure block, before clock disable) is identical in
intent.

### Step 2.2: Code Flow Change
**Record:**
- **Hunk (regcache_sync error path):**
  - **Before:** On sync failure → disable clocks → return error, leaving
    `cache_only == false`
  - **After:** On sync failure → `regcache_cache_only(map, true)` →
    disable clocks → return error
- **Affected path:** Runtime PM resume error path only (not the success
  path)

### Step 2.3: Bug Mechanism
**Record:**
- **Category:** Error-path / state consistency bug (regmap cache-mode
  invariant violation)
- **Mechanism:** `rk_spdif_runtime_suspend()` sets cache-only; resume
  clears it before sync; failed sync leaves the map in "live hardware"
  mode while clocks are off and the device is inactive. The fix restores
  the suspended-state invariant.

### Step 2.4: Fix Quality
**Record:**
- **Quality:** Obviously correct — mirrors the established pattern in
  `sgtl5000.c` and the recently backported `pca953x` fix by the same
  author.
- **Regression risk:** Very low — one line on an already-rare error
  path.
- **Red flags:** None.

---

## Phase 3: Git History Investigation

### Step 3.1: Blame
**Record:**
- Buggy `regcache_sync()` error path introduced by **3628c6987fb45**
  (2016-09-07): "ASoC: rockchip: spdif: restore register during
  runtime_suspend/resume cycle"
- Related prior fix: **6d94d0090527b** (2022-12-08) added missing
  `clk_disable_unprepare()` on hclk failure — same function, same class
  of incomplete error handling
- PM runtime integration: **f50d67f9eff62** (2020-07-13)

### Step 3.2: Fixes: Tag
**Record:** Not applicable — no `Fixes:` tag in the commit message.

### Step 3.3: Related File History
**Record:**
- Recent changes to this file are cleanups (`RUNTIME_PM_OPS`, remove
  callback, DAI merge) — no overlapping fix for this bug.
- Fix commit message not found in this tree — **fix is not yet applied
  locally**.
- Patch appears standalone (single line, one file); message-id `-5`
  suggests a series, but no series dependency is evident from the diff.

### Step 3.4: Author Context
**Record:**
- Author `phucduc.bui` has no other commits under `sound/soc/rockchip/`
  in this tree.
- Same author authored **2e4bc8422cdee** (`gpio: pca953x: fix cache_only
  ... on restore_context() failure`), which was backported to this
  stable tree with `Cc: stable@vger.kernel.org`.

### Step 3.5: Dependencies
**Record:** No prerequisites — self-contained one-line addition. Applies
cleanly to this tree (clock order differs cosmetically, hunk location
unchanged).

---

## Phase 4: Mailing List and External Research

### Step 4.1: Original Patch Discussion
**Record:** `b4 dig -m "Restore regcache cache-only mode on sync
failure"` returned no match. `b4 dig -m
"20260602101608.45137-5-phucduc.bui@gmail.com"` returned no match.
Lore/patch.msgid.link URLs blocked by Anubis bot protection — **could
not read review thread content**.

### Step 4.2: Reviewers
**Record:** `b4 dig -w` not usable (no thread match). Mark Brown
(maintainer) Signed-off-by confirms maintainer acceptance.

### Step 4.3: Bug Report
**Record:** Reported by Sashiko AI Review (automated static analysis),
not syzbot or a user crash report. Underlying issue is code-review-
identified state inconsistency, not a filed oops trace.

### Step 4.4: Related Patches
**Record:** Same author/class of fix in `gpio-pca953x` (already in this
tree at `2e4bc8422cdee`). `sgtl5000.c` already implements the correct
pattern at lines 1135–1139.

### Step 4.5: Stable List History
**Record:** Could not search lore stable list (Anubis blocking). The
analogous pca953x fix from this author explicitly carried `Cc:
stable@vger.kernel.org` and was merged here by Greg K-H.

---

## Phase 5: Code Semantic Analysis

### Step 5.1: Key Functions
**Record:** `rk_spdif_runtime_resume()` modified; related:
`rk_spdif_runtime_suspend()`, `rk_spdif_hw_params()`,
`rk_spdif_trigger()`

### Step 5.2: Callers
**Record:**
- `rk_spdif_runtime_resume()` registered via `RUNTIME_PM_OPS()` at line
  377 — invoked by PM core on runtime resume
- Direct call from `rk_spdif_probe()` when PM runtime is disabled (lines
  338–341)
- Regmap users: `rk_spdif_hw_params()`, `rk_spdif_trigger()` — ASoC
  PCM/DAI paths during active audio

### Step 5.3: Callees
**Record:** `clk_prepare_enable()`, `regcache_cache_only()`,
`regcache_mark_dirty()`, `regcache_sync()`, `clk_disable_unprepare()`

### Step 5.4: Reachability
**Record:**
- Resume path reachable on every runtime PM resume (suspend/resume
  cycles, audio start on Rockchip boards)
- Bug triggers only when `regcache_sync()` returns error (uncommon but
  real — bus/clock/hardware failure during sync)
- After bug triggers, any regmap access while device is inactive hits
  hardware path instead of cache — reachable from subsequent resume
  retries or regmap ops if PM state is inconsistent

### Step 5.5: Similar Patterns
**Record:**
- **Correct pattern:** `sound/soc/codecs/sgtl5000.c:1135-1139` restores
  `cache_only(true)` on sync failure
- **Same bug class, same author:** `drivers/gpio/gpio-pca953x.c`
  `pca953x_restore_context()` err path
- **Same bug present:** `sound/soc/rockchip/rockchip_sai.c:251-277` —
  also lacks cache-only restore on sync failure (out of scope for this
  commit)

---

## Phase 6: Cross-Reference Against Local Tree

### Step 6.1: Buggy Code Present?
**Record:** **YES.** Local tree is **v6.18.44** (`6.18.44`). Buggy code
at:

```98:102:sound/soc/rockchip/rockchip_spdif.c
        ret = regcache_sync(spdif->regmap);
        if (ret) {
                clk_disable_unprepare(spdif->mclk);
                clk_disable_unprepare(spdif->hclk);
        }
```

Missing `regcache_cache_only(spdif->regmap, true)`. Bug present since
3628c6987fb45 (2016).

### Step 6.2: Backport Complications
**Record:** Clean apply expected — add one line inside existing `if
(ret)` block. Clock enable order differs from upstream diff but hunk
location is unchanged.

### Step 6.3: Related Fixes Already Present?
**Record:** No equivalent fix in this tree. Prior related fix
6d94d0090527b (missing clk disable) is present. Fix commit not found via
grep or git log.

---

## Phase 7: Subsystem Context

### Step 7.1: Subsystem and Criticality
**Record:** **ASoC / Rockchip SPDIF driver** — **PERIPHERAL** (Rockchip
embedded SoC audio output). Affects boards using the in-SoC SPDIF
controller (RK3288, RK3399, RK3568, etc.).

### Step 7.2: Subsystem Activity
**Record:** Moderate recent activity (SAI driver additions, cleanups);
SPDIF driver itself is mature with infrequent changes.

---

## Phase 8: Impact and Risk Assessment

### Step 8.1: Who Is Affected
**Record:** Users of Rockchip platforms with
`CONFIG_SND_SOC_ROCKCHIP_SPDIF` and the built-in SPDIF DAI —
embedded/ARM boards, not universal x86 users.

### Step 8.2: Trigger Conditions
**Record:**
- **Trigger:** `regcache_sync()` failure during runtime resume
- **Likelihood:** Uncommon (requires hardware/bus/clock issue during
  sync)
- **Unprivileged trigger:** No — requires device access and a resume
  failure condition

### Step 8.3: Failure Mode Severity
**Record:**
- **Failure mode:** Regmap attempts live MMIO
  (`devm_regmap_init_mmio_clk` uses `hclk`) while driver considers
  device suspended; register state may be inconsistent; subsequent
  resume/audio operations may fail, hang, or produce silent corruption
- **Severity:** **MEDIUM** — real functional bug on an error path, not a
  common crash, but can leave driver in an unrecoverable inconsistent
  state without the fix

### Step 8.4: Risk-Benefit
**Record:**
- **Benefit:** Restores correct PM/regmap state invariant; prevents
  post-failure regmap/hardware mismatch on Rockchip SPDIF; aligns with
  established kernel patterns
- **Risk:** Very low — one line, error path only
- **Ratio:** Favorable for backport

---

## Phase 9: Final Synthesis

### Step 9.1: Evidence Summary

**FOR backport:**
- Real bug — incomplete error-path state restoration since 2016
- Bug confirmed present in v6.18.44 tree
- One-line, obviously correct fix matching `sgtl5000` and backported
  `pca953x` precedent
- ASoC maintainer (Mark Brown) Signed-off-by
- Same author successfully got analogous fix into this stable tree
- Low regression risk

**AGAINST backport:**
- Rare trigger (`regcache_sync()` failure)
- Driver-specific, embedded Rockchip only
- No user crash report or syzbot — flagged by AI review bot
- Medium not critical severity

**UNRESOLVED:**
- Full lore review thread content (Anubis blocked)
- Whether reviewers explicitly nominated for stable
- Whether patch 5/N series has other dependencies (diff appears
  standalone)

### Step 9.2: Stable Rules Checklist
1. Obviously correct and tested? **PASS** — pattern proven elsewhere;
   maintainer SOB; no Tested-by
2. Fixes a real bug affecting users? **PASS** — state-machine bug on
   resume error path for Rockchip SPDIF users
3. Important issue? **PASS (MEDIUM)** — can cause driver
   malfunction/hang on error path, not security/data-corruption in
   common case
4. Small and contained? **PASS** — 1 line, 1 file
5. No new features or APIs? **PASS**
6. Can apply to local tree? **PASS** — buggy code present, clean apply

### Step 9.3: Exception Categories
**Record:** Not applicable — standard bug fix, not device
ID/quirk/build/doc exception.

### Step 9.4: Decision Rationale
This is a well-understood error-path invariant fix: when runtime resume
fails after disabling cache-only mode, the driver must restore cache-
only mode before turning clocks off — exactly what suspend established.
The bug has existed since the regcache resume logic was added in 2016
and is present in this 6.18.y tree. While the trigger is uncommon and
impact is driver-specific, the fix is trivial, low-risk, maintainer-
approved, and follows a pattern already accepted for stable (pca953x,
sgtl5000). Conservative stable policy favors such surgical error-path
fixes that prevent leaving hardware drivers in inconsistent states.

---

## Verification

- **[Phase 1]** Parsed commit message and all tags from user-provided
  commit text
- **[Phase 2]** Diff analysis: 1 line added in
  `rk_spdif_runtime_resume()` error path
- **[Phase 3]** `git describe HEAD`: v6.18.44-1-g2736c32da98b9 / kernel
  6.18.44
- **[Phase 3]** `git blame -L 77,105`: regcache error path from
  3628c6987fb45 (2016)
- **[Phase 3]** `git show 3628c6987fb45`: confirmed introduction of
  regcache_sync without cache-only restore on error
- **[Phase 3]** `git show 6d94d0090527b`: related prior error-path fix
  in same function
- **[Phase 3]** `git log --grep="Restore regcache"`: no fix commit in
  tree
- **[Phase 3]** `git show 2e4bc8422cdee`: same author's analogous
  pca953x fix backported here with Cc: stable
- **[Phase 4]** `b4 dig -m "Restore regcache..."`: no match
- **[Phase 4]** WebFetch lore/patch.msgid.link URLs: blocked by Anubis —
  **UNVERIFIED** review thread content
- **[Phase 5]** Read `rockchip_spdif.c`: confirmed regmap users and PM
  ops registration
- **[Phase 5]** Read `sgtl5000.c:1135-1139`: confirmed correct reference
  pattern
- **[Phase 5]** Read `rockchip_sai.c:251-277`: same missing pattern
  (separate issue)
- **[Phase 5]** Read `drivers/base/regmap/regcache.c:551-570`: confirmed
  cache_only semantics
- **[Phase 6]** Read current `rockchip_spdif.c:66-105`: confirmed buggy
  code without fix
- **[Phase 6]** `git log --oneline -20 --
  sound/soc/rockchip/rockchip_spdif.c`: no conflicting fix present

**YES****Verdict: YES** — backport to this tree (v6.18.44).

The Rockchip SPDIF driver leaves `regcache_cache_only` disabled when
`regcache_sync()` fails during runtime resume, so later register
accesses can hit hardware while the device is still inactive. The fix is
a one-line restore of cache-only mode on that error path — same pattern
as `sgtl5000` and the author’s backported `pca953x` fix. The bug has
been present since 2016 and is still in this checkout; it’s a small,
low-risk, maintainer-signed error-path fix.

 sound/soc/rockchip/rockchip_spdif.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/soc/rockchip/rockchip_spdif.c b/sound/soc/rockchip/rockchip_spdif.c
index d365168934dc6..7a15f680de2fe 100644
--- a/sound/soc/rockchip/rockchip_spdif.c
+++ b/sound/soc/rockchip/rockchip_spdif.c
@@ -97,6 +97,7 @@ static int rk_spdif_runtime_resume(struct device *dev)
 
 	ret = regcache_sync(spdif->regmap);
 	if (ret) {
+		regcache_cache_only(spdif->regmap, true);
 		clk_disable_unprepare(spdif->mclk);
 		clk_disable_unprepare(spdif->hclk);
 	}
-- 
2.53.0

