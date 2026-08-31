Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 494EE4F0553;
	Mon, 31 Aug 2026 13:40:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183652; cv=none; b=mGq4uOwkSuO0UUbD7Tklgy/iBNEFOTk04cqrQen5SNuAfuoUj+Ths0NP7xPs7AtSmP0VGFrKuzmB6wjdPT279QaJ5zC2M4l8C1dPcEy1wUHC5QYV7cTIWQ0hDsstoOQmVktYSsjIOnJL1wSq35T4Dr6mmWFKOG8n/DDEbFxdkfY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183652; c=relaxed/simple;
	bh=OVtzjj6S3NguXDus+FQWGLDOOyZUa3Ojz1gR+naJDyI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hDDvX8CRD+eEVz9+ArEncWgiL7izLVpyJVwp0X/JJYo6ldtoRweWJxm8m18gU6vbdCnQTN7MoBlbqcqyHIKxdoZqNtScAFOhjxIYjS/BsUc6Kh9URYs3usyQbyEcDyea0KwOe9IWbpJgdGCCmIE55cuXxbbWZzDAFT0bHekwK8c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gWm/eDQL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gWm/eDQL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 080CC1F00ADB;
	Mon, 31 Aug 2026 13:40:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183649;
	bh=eonFPEKCyg5BqZFTIL3C/Bi5nHSqguCbsaDjQk4rT+Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gWm/eDQL3qKQCJ2lvJ6uLsGjLY1ZywkjzdGjw82MzYMziSfA/UAr6lp7cFj4qlt2d
	 KKuL1fy4kld8zpJEBlmPpPcTdqKMBDyqnsoIE1OdcTHkark+kVb5274O5vEuLbLCTz
	 EokCvkdIfFKmj6Y0xcTWq9OHBf+W63RPo/BtDBvYDkgt6CDu4iYWlZ6VDPDP0Pw178
	 SaM73WwzBvvLOIYKRLL3OEiBQonVIPKBqZAHnS8at5cd1xP0u2DF990wNWiDd+Xsxg
	 mhCg1M7CDob4wVz4pXRdoRqZSeeUGtsozPmXA9PaKXYCfsDQXxffr56YGKwgmoXtMZ
	 wI4kU2uVLOPgw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Xianwei Zhao <xianwei.zhao@amlogic.com>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	neil.armstrong@linaro.org,
	khilman@baylibre.com,
	linux-amlogic@lists.infradead.org,
	linux-gpio@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] pinctrl: meson: amlogic-a4: use nolock get range
Date: Mon, 31 Aug 2026 09:24:08 -0400
Message-ID: <20260831133314.4125787-220-sashal@kernel.org>
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

From: Xianwei Zhao <xianwei.zhao@amlogic.com>

[ Upstream commit afa0c07131d8829ea0ebbcd8267c85aa178ce52c ]

Use pinctrl_find_gpio_range_from_pin_nolock() instead of
pinctrl_find_gpio_range_from_pin() when configuring a pin or
setting a GPIO value.

This avoids taking the lock and allows the code to be safely
called from interrupt context.

Signed-off-by: Xianwei Zhao <xianwei.zhao@amlogic.com>
Signed-off-by: Linus Walleij <linusw@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: `pinctrl: meson: amlogic-a4: use nolock get
range`

**Local tree:** Linux **6.18.44** (`v6.18.44-1-g2736c32da98b9`,
stable/linux-6.18.y)

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Subject line
**Record:** `[pinctrl/meson/amlogic-a4]` `[use]` — switch remaining GPIO
range lookups to the nolock variant when configuring pins / setting
GPIO-related state.

### Step 1.2: Tags
**Record:**
- **Fixes:** — absent (expected for manual review)
- **Reported-by:** — none
- **Tested-by:** — none
- **Reviewed-by:** — none
- **Acked-by:** — none
- **Link:** — none
- **Cc: stable@vger.kernel.org:** — absent
- **Signed-off-by:** Xianwei Zhao, Linus Walleij (ignore pipeline SOB
  markers)

Notable: no syzbot/fuzzer report; no explicit stable nomination.

### Step 1.3: Body analysis
**Record:**
- **Bug described:** Using `pinctrl_find_gpio_range_from_pin()` takes
  `pctldev->mutex`. When callers already hold that mutex (or run in
  contexts where locking is unsafe), this causes deadlock or invalid
  locking.
- **Symptom:** Kernel hang / lockdep issues when configuring pins
  through paths that already hold the pinctrl mutex.
- **Root cause:** Recursive mutex acquisition in pinconf SET helpers and
  `aml_pmx_set_mux()`.
- **Version info:** None in message. Driver landed in this tree via
  `6e9be3abb78c2` (Feb 2025).

### Step 1.4: Hidden bug fix detection
**Record:** Yes — despite neutral wording ("use nolock"), this is a
**deadlock fix**, completing the same class of fix already partially
backported as `e917713f01342` ("fix deadlock issue") which only
converted the three pinconf **GET** helpers.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory
**Record:**
- **File:** `drivers/pinctrl/meson/pinctrl-amlogic-a4.c` only
- **Scope:** 5 call-site replacements (no logic changes)
- **Functions modified:**
  - `aml_pmx_set_mux()`
  - `aml_pinconf_disable_bias()`
  - `aml_pinconf_enable_bias()`
  - `aml_pinconf_set_drive_strength()`
  - `aml_pinconf_set_gpio_bit()`
- **Classification:** Single-file, surgical fix

Note: subject says "get range" but the diff touches **SET** paths (and
`set_mux`), not GET paths — GET paths were already fixed in
`e917713f01342`.

### Step 2.2: Code flow change
**Record (per hunk):**
| Location | Before | After |
|---|---|---|
| All 5 sites | `pinctrl_find_gpio_range_from_pin()` → locks
`pctldev->mutex`, walks `gpio_ranges` |
`pinctrl_find_gpio_range_from_pin_nolock()` → no lock, same list walk |

Affected paths:
- **Pinconf SET** (bias, drive strength, GPIO bit output) — reached from
  `aml_pinconf_set()` and its helpers.
- **Pinmux SET** — `aml_pmx_set_mux()` during function selection.

### Step 2.3: Bug mechanism
**Record:** **Category:** Deadlock / lock ordering (mutex recursion)

Verified chain for pinconf SET:
1. `aml_gpio_template.set_config = gpiochip_generic_config` (line 959)
2. `gpiochip_generic_config()` → `pinctrl_gpio_set_config()`
   (`core.c:919-937`)
3. `pinctrl_gpio_set_config()` **locks** `pctldev->mutex` (line 931)
4. Calls `pinconf_set_config()` → `aml_pinconf_set()` → e.g.
   `aml_pinconf_set_gpio_bit()`
5. Helper calls `pinctrl_find_gpio_range_from_pin()` which tries to
   **lock the same mutex again** → **DEADLOCK**

This mirrors the already-fixed GET path where `pinconf_pins_show()`
holds the mutex and GET helpers deadlocked.

### Step 2.4: Fix quality
**Record:**
- **Obviously correct:** Yes —
  `pinctrl_find_gpio_range_from_pin_nolock()` is the established API for
  callers that already hold the lock or must not sleep; same pattern
  used in stm32, airoha, etc.
- **Minimal:** Yes — function name substitution only.
- **Regression risk:** Very low — read-only lookup of the static
  `gpio_ranges` list populated at probe time.
- **Red flags:** None.

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame
**Record:** All 5 remaining locking call sites introduced in
`6e9be3abb78c2` ("pinctrl: Add driver support for Amlogic SoCs", Feb
2025). Bug present since driver introduction.

### Step 3.2: Fixes: tag
**Record:** N/A — no Fixes: tag. Related fix `e917713f01342` (upstream
`e72ce02981039`) addresses the same bug class for GET paths only;
confirmed present in this tree.

### Step 3.3: Related file history
**Record:**
- `e917713f01342` — partial deadlock fix (3 GET helpers → nolock) —
  **already in 6.18.44**
- `4a1afa32145b5` — mark GPIO controller `can_sleep = true` (lockdep fix
  for shared GPIO proxy)
- `80f8e2302e639` — gpio output glitch fix
- Commit under review ("use nolock get range") — **NOT in this tree**

This is a logical follow-up to `e917713f01342`, not part of a multi-
patch dependency series.

### Step 3.4: Author context
**Record:** Xianwei Zhao authored the original Amlogic pinctrl driver
(`6e9be3abb78c2`) and the prior deadlock fix. Linus Walleij (pinctrl
maintainer) merged both.

### Step 3.5: Dependencies
**Record:**
- Requires `pinctrl-amlogic-a4.c` driver — **present**
- Requires `pinctrl_find_gpio_range_from_pin_nolock()` — **present** in
  `drivers/pinctrl/core.c` since long before this driver
- Requires prior GET-path fix — **optional**; this patch is standalone
  and applies independently
- **Can apply standalone:** Yes

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: Original discussion
**Record:**
- `b4 dig -c e72ce02981039` found the related v1 thread:
  https://patch.msgid.link/20260422-fix-
  pinconf-v1-1-abb4d2e0da55@amlogic.com
- That thread covers only the GET-path deadlock fix (same author, same
  mechanism).
- **No separate lore thread found** for "use nolock get range" in this
  repo or via b4.
- WebFetch of lore URL blocked by bot protection; mbox saved locally
  confirms GET-path discussion with Reviewed-by Neil Armstrong.

### Step 4.2: Reviewers
**Record:** Related GET fix reviewed by Neil Armstrong (Linaro/Meson
maintainer). This follow-up commit has no explicit Reviewed-by in the
provided message; Linus Walleij merged it.

### Step 4.3: Bug report
**Record:** No external bug report, syzbot link, or user Reported-by for
this specific commit. Deadlock mechanism inferred from code analysis and
prior accepted fix.

### Step 4.4: Series context
**Record:** Companion to `e917713f01342` — completes the nolock
conversion. Not a multi-part series requiring other patches.

### Step 4.5: Stable list history
**Record:** Prior GET-path fix was backported to this tree (has `[
Upstream commit ...]` and Sasha Levin SOB from stable pipeline — per
instructions, ignored for decision). No stable-list discussion found for
this specific follow-up.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Key functions
**Record:** `aml_pmx_set_mux`, `aml_pinconf_disable_bias`,
`aml_pinconf_enable_bias`, `aml_pinconf_set_drive_strength`,
`aml_pinconf_set_gpio_bit`

### Step 5.2: Callers
**Record:**
- **Pinconf SET helpers** ← `aml_pinconf_set()` ←
  `pinconf_apply_setting()` (DT pinconf at probe) AND
  `pinconf_set_config()` ← `pinctrl_gpio_set_config()` (GPIO
  `set_config` path — **mutex already held**)
- **`aml_pmx_set_mux`** ← `pinmux_enable_setting()` (pinctrl state
  changes, probe)

GPIO chip hooks:
- `.set_config = gpiochip_generic_config` — triggers the verified
  deadlock path
- `.set = aml_gpio_set` — does **not** use
  `pinctrl_find_gpio_range_from_pin()` (uses direct register calc)

### Step 5.3: Callees
**Record:** `pinctrl_find_gpio_range_from_pin[_nolock]()` → walks
`pctldev->gpio_ranges`; then `regmap_update_bits()` on GPIO/mux
registers.

### Step 5.4: Reachability
**Record:**
- **Verified reachable:** `gpiod_set_config()` /
  `gpiochip_generic_config()` on Amlogic A4 GPIOs with `CONFIG_PINCTRL`
  — userspace or drivers configuring bias, drive strength, output
  enable, level.
- **Platform-specific:** Amlogic A4/A5/S6/S7 SoCs only (driver in tree
  since 6.18 merge window).

### Step 5.5: Similar patterns
**Record:** stm32, airoha, pinctrl-lpc18xx, pinctrl-stmfx all use
`_nolock` in pinconf/pinmux paths. Meson GET paths already converted in
`e917713f01342`.

---

## PHASE 6: CROSS-REFERENCE WITH LOCAL TREE (6.18.44)

### Step 6.1: Buggy code present?
**Record:** **Yes.** Five call sites still use locking variant:
- Line 253: `aml_pmx_set_mux`
- Lines 452, 465, 487, 522: pinconf SET helpers

Three GET helpers already use nolock (lines 295, 329, 368) from
`e917713f01342`.

### Step 6.2: Backport complications
**Record:** **Clean apply expected** — simple function renames at the
same lines the diff shows. No structural divergence since partial fix.

### Step 6.3: Related fixes already present?
**Record:** Partial fix `e917713f01342` (GET paths) already in tree.
This commit is needed to complete the fix. No duplicate fix for SET
paths found.

---

## PHASE 7: SUBSYSTEM CONTEXT

### Step 7.1: Subsystem criticality
**Record:** **PERIPHERAL** — Amlogic SoC pinctrl/GPIO driver. Not core
kernel, but pinctrl/GPIO is on critical paths for embedded boards.

### Step 7.2: Activity
**Record:** Actively maintained — 6+ amlogic-a4 commits in this stable
tree including deadlock, lockdep, and glitch fixes.

---

## PHASE 8: IMPACT AND RISK

### Step 8.1: Who is affected
**Record:** Users of Amlogic A4/A5/S6/S7 platforms using the `pinctrl-
amlogic-a4` driver, especially when calling `gpiod_set_config()` or GPIO
`set_config` on these pins.

### Step 8.2: Trigger conditions
**Record:**
- **Verified trigger:** GPIO pin configuration via
  `gpiochip_generic_config` → `pinctrl_gpio_set_config` (mutex held)
- **Likelihood:** Moderate — any driver or userspace tool setting pin
  bias/drive/output config on these GPIOs
- **Unprivileged trigger:** Possible if GPIO is accessible to userspace
- **"Interrupt context" claim in commit message:** UNVERIFIED as primary
  mechanism — `pinctrl_gpio_set_config()` itself uses `mutex_lock()`.
  The verified failure mode is **mutex recursion deadlock**, not hardirq
  misuse.

### Step 8.3: Failure mode severity
**Record:** **CRITICAL** — task hang / unkillable deadlock when
triggered. Same severity class as the already-backported GET-path fix.

### Step 8.4: Risk-benefit
**Record:**
- **Benefit:** HIGH for affected platforms — prevents kernel hang;
  completes incomplete stable fix
- **Risk:** VERY LOW — 5-line function rename, established API pattern
- **Ratio:** Strongly favors backport

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence summary

**FOR backport:**
- Fixes real, verifiable mutex-recursion deadlock in pinconf SET path
- Completes partial fix (`e917713f01342`) already in 6.18.44
- Same bug class as already-accepted stable commit
- Small, obviously correct, no new APIs
- Driver and prerequisite API exist in this tree
- Failure mode is system hang (critical)

**AGAINST backport:**
- Platform-specific (Amlogic only) — limited user base
- No syzbot/user report for this specific commit
- Commit message "interrupt context" claim not fully verified
- `aml_pmx_set_mux` deadlock path not independently verified (change is
  still safe)

**Unresolved:**
- No lore thread found for this exact follow-up commit
- Whether `aml_pmx_set_mux` has a mutex-held caller (preventive fix at
  most)

### Step 9.2: Stable rules checklist
1. Obviously correct and tested? **PASS** — established nolock API;
   prior GET fix same pattern merged and backported
2. Fixes real bug affecting users? **PASS** — verified deadlock in
   `pinctrl_gpio_set_config` → pinconf SET chain
3. Important issue? **PASS** — deadlock / system hang (CRITICAL)
4. Small and contained? **PASS** — 5 call-site changes, 1 file
5. No new features/APIs? **PASS** — uses existing exported nolock helper
6. Can apply to local tree? **PASS** — driver present, clean apply
   expected

### Step 9.3: Exception categories
**Record:** None (not device ID, quirk, DT, build, or docs). Standard
bug fix.

### Step 9.4: Decision rationale
This tree (6.18.44) already carries a **partial** deadlock fix for the
Amlogic A4 pinctrl driver. The remaining five locking call sites in
pinconf SET helpers create a verified mutex-recursion deadlock when GPIO
`set_config` is used (`gpiochip_generic_config` →
`pinctrl_gpio_set_config`). Without this commit, stable users on Amlogic
platforms can still hit kernel hangs that the prior backport was meant
to address. The fix is minimal, follows an established pattern, and
completes work already started in this tree.

---

## Verification

- **[Phase 1]** Parsed commit message and tags from user-provided diff
- **[Phase 2]** Diff analysis: 5 `pinctrl_find_gpio_range_from_pin` →
  `_nolock` replacements in SET/mux paths
- **[Phase 3]** `git describe HEAD`: v6.18.44; `git blame` lines
  252-254, 451-453: introduced in `6e9be3abb78c2`
- **[Phase 3]** `git log --oneline -10 -- drivers/pinctrl/meson/pinctrl-
  amlogic-a4.c`: found `e917713f01342` partial fix
- **[Phase 3]** `git merge-base --is-ancestor 6e9be3abb78c2 HEAD`:
  driver in tree; `e917713f01342`: partial fix in tree
- **[Phase 3]** `git show e917713f01342`: confirmed GET-only fix (3
  sites)
- **[Phase 3]** `git grep pinctrl_find_gpio_range_from_pin(` in file: 5
  remaining locking calls
- **[Phase 4]** `b4 dig -c e72ce02981039`: found related GET-fix thread;
  mbox downloaded
- **[Phase 4]** WebFetch lore URL: blocked (bot protection) — used mbox
  grep instead
- **[Phase 4]** UNVERIFIED: no lore thread for "use nolock get range"
  commit specifically
- **[Phase 5]** Traced call chain: `gpiochip_generic_config` →
  `pinctrl_gpio_set_config` (mutex at core.c:931) → `aml_pinconf_set_*`
  → locking lookup = deadlock
- **[Phase 5]** Confirmed `aml_gpio_set` does NOT use
  `pinctrl_find_gpio_range_from_pin`
- **[Phase 5]** Confirmed `pinctrl_find_gpio_range_from_pin_nolock`
  exists in `core.c:484-505`
- **[Phase 6]** Read current file: GET paths nolock (295,329,368); SET
  paths still locking (253,452,465,487,522)
- **[Phase 6]** Commit under review NOT in tree (`git log --grep="nolock
  get range"`: no match on current branch)
- **[Phase 8]** Deadlock severity: CRITICAL
- **[Phase 8]** UNVERIFIED: "interrupt context" as stated in commit
  message; verified mechanism is mutex recursion

**YES**The background searches are done. Here’s what they showed:

- **Commit not in this tree:** Searches on the current branch and `all-
  next` did not find `pinctrl: meson: amlogic-a4: use nolock get range`.
  That matches treating it as a backport candidate, not something
  already in 6.18.44.
- **Partial fix already present:** `e917713f01342` is in the tree and
  only switched the three pinconf **GET** helpers to
  `pinctrl_find_gpio_range_from_pin_nolock()`.
- **Buggy code still present:** Five call sites in SET/mux paths still
  use the locking variant (`aml_pmx_set_mux` plus four pinconf SET
  helpers), introduced in `6e9be3abb78c2`.

That supports the earlier **YES** verdict: this patch completes an
incomplete deadlock fix already started in 6.18.44, with a clean, low-
risk apply expected.

 drivers/pinctrl/meson/pinctrl-amlogic-a4.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/pinctrl/meson/pinctrl-amlogic-a4.c b/drivers/pinctrl/meson/pinctrl-amlogic-a4.c
index 1bd58fbbd26ac..e598373f51663 100644
--- a/drivers/pinctrl/meson/pinctrl-amlogic-a4.c
+++ b/drivers/pinctrl/meson/pinctrl-amlogic-a4.c
@@ -250,7 +250,7 @@ static int aml_pmx_set_mux(struct pinctrl_dev *pctldev, unsigned int fselector,
 	int i;
 
 	for (i = 0; i < group->npins; i++) {
-		range =  pinctrl_find_gpio_range_from_pin(pctldev, group->pins[i]);
+		range =  pinctrl_find_gpio_range_from_pin_nolock(pctldev, group->pins[i]);
 		aml_pctl_set_function(info, range, group->pins[i], group->func[i]);
 	}
 
@@ -449,7 +449,7 @@ static int aml_pinconf_disable_bias(struct aml_pinctrl *info,
 				    unsigned int pin)
 {
 	struct pinctrl_gpio_range *range =
-			 pinctrl_find_gpio_range_from_pin(info->pctl, pin);
+			 pinctrl_find_gpio_range_from_pin_nolock(info->pctl, pin);
 	struct aml_gpio_bank *bank = gpio_chip_to_bank(range->gc);
 	unsigned int reg, bit = 0;
 
@@ -462,7 +462,7 @@ static int aml_pinconf_enable_bias(struct aml_pinctrl *info, unsigned int pin,
 				   bool pull_up)
 {
 	struct pinctrl_gpio_range *range =
-			 pinctrl_find_gpio_range_from_pin(info->pctl, pin);
+			 pinctrl_find_gpio_range_from_pin_nolock(info->pctl, pin);
 	struct aml_gpio_bank *bank = gpio_chip_to_bank(range->gc);
 	unsigned int reg, bit, val = 0;
 	int ret;
@@ -484,7 +484,7 @@ static int aml_pinconf_set_drive_strength(struct aml_pinctrl *info,
 					  u16 drive_strength_ua)
 {
 	struct pinctrl_gpio_range *range =
-			 pinctrl_find_gpio_range_from_pin(info->pctl, pin);
+			 pinctrl_find_gpio_range_from_pin_nolock(info->pctl, pin);
 	struct aml_gpio_bank *bank = gpio_chip_to_bank(range->gc);
 	unsigned int reg, bit, ds_val;
 
@@ -519,7 +519,7 @@ static int aml_pinconf_set_gpio_bit(struct aml_pinctrl *info,
 				    bool arg)
 {
 	struct pinctrl_gpio_range *range =
-			 pinctrl_find_gpio_range_from_pin(info->pctl, pin);
+			 pinctrl_find_gpio_range_from_pin_nolock(info->pctl, pin);
 	struct aml_gpio_bank *bank = gpio_chip_to_bank(range->gc);
 	unsigned int reg, bit;
 
-- 
2.53.0

