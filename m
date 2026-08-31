Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67E5F5287E7;
	Mon, 31 Aug 2026 13:44:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183873; cv=none; b=SFQouUqMRAFb2CVEcDsHa0ac/iLIRU37LMEuPlYUnKNGzvVbuwNQ+41OkEVFLxvznNXFVsQKAZ1a7YJLXHsb2TY1o26jkHxFWfBf5Cm+7Coo+uEzHOpNCgqfw3DaXrEriYO23OwMmGGlQzB/TpmHwLKcwbG9YuXa+8qNjv3qXLc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183873; c=relaxed/simple;
	bh=puNNEFgoDvAsBVoZoHPhxdKlDs1V7Bn/zAFeqzKKQLw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LH9WI5mzwOqABZ7md1KEupICqhRJMU7Zq7VQ7GSSnbnkI2amyzhXgvLurTsChc9uCuNOC8OW3FUEMU2Gpj48p1Il7fru1w/jd901n30aC+AAdkZLzvSqh2xV7CBz8yfiRZ/wX2EDVYMFBIVHMMXsI8oTKetm+7XuYU0KQlyZdy8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZtypRJ+4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZtypRJ+4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E29A71F000E9;
	Mon, 31 Aug 2026 13:44:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183870;
	bh=7cYGm8ncQi+rXRPclvImLskw4LvGRvg1dZVIcJ/v8vE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZtypRJ+4fCsfsywiPwbdFG5fWu7i8E2Eoit4a0JfxU3MhPEtJ0Bfa9VjDAMpxrgLb
	 vmk6Cjj+kzhRVKiXYRAq9LV1IW4WL/PCvv8drDx2dVOG2Sg7js6kXtkKsztge8sLYo
	 noqRNZJnCuq1PDSqbb9Zld2c4narjWZ/tGE6YnSkuVaibEJJH5wO7kHYOrs5rQyvsF
	 cbX6y5iIS+AnzFGVweJ6Qye5p2fCZh+qZMag3ds9BXZJDtAR1tu/m523i7j70GC4Y3
	 f+dT6wr4TYANttFgx6gd+Of8qw8twTQUz/vPOyaLa2PYLfrVfDIFJMpcEOscd6tZFr
	 GEYiopkKOVKKA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Gil Fine <gil.fine@linux.intel.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>,
	andreas.noever@gmail.com,
	westeri@kernel.org,
	YehezkelShB@gmail.com,
	linux-usb@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.6] thunderbolt: Verify Router Ready bit is set after router enumeration
Date: Mon, 31 Aug 2026 09:26:20 -0400
Message-ID: <20260831133314.4125787-352-sashal@kernel.org>
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

From: Gil Fine <gil.fine@linux.intel.com>

[ Upstream commit 062023c4364ffdc72978ed2de1d1435e5d4eee43 ]

The USB4 Connection Manager guide specifies that after enumerating a
router, the Connection Manager shall verify that the Router Ready bit
(ROUTER_CS_6.RR) has been set to ensure hardware configuration has completed.
Currently, this step is missing from the enumeration sequence.

Add this check to follow the Connection Manager guide more closely.

Signed-off-by: Gil Fine <gil.fine@linux.intel.com>
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Connection lost, reconnecting to https://agentn.us.api5.cursor.sh
(attempt 1)...
Retry attempt 1...
## Phase 1: Commit Message Forensics

### Step 1.1: Subject Line
**Record:** `[thunderbolt]` `[verify]` — After USB4 router enumeration,
verify that the Router Ready bit (`ROUTER_CS_6.RR`) is set before
continuing.

### Step 1.2: Commit Message Tags
**Record:**
- **Fixes:** — not present (expected for manual review)
- **Reported-by:** — none
- **Tested-by:** — none
- **Reviewed-by / Acked-by / Cc: stable:** — none in the committed
  message
- **Link:** — none
- **Signed-off-by:** Gil Fine, Mika Westerberg (ignore any pipeline-
  added SOBs)

Notable pattern: no fuzzer report, no user report, no explicit stable
nomination.

### Step 1.3: Commit Body Analysis
**Record:**
- **Bug described:** USB4 Connection Manager guide requires verifying
  `ROUTER_CS_6.RR` after router enumeration to confirm hardware
  configuration is complete; Linux omits this step.
- **Symptom/failure mode:** Not spelled out as a crash or user report.
  Implied failure mode is continuing enumeration before the router is
  ready, which can cause flaky or failed device bring-up.
- **Version info:** none
- **Root cause:** Missing mandatory hardware-ready polling in the USB4
  enumeration sequence.

### Step 1.4: Hidden Bug Fix Detection
**Record:** Yes, likely a hidden correctness bug. The message frames it
as CM-guide compliance, but the mechanism is a missing hardware-ready
wait in a hot enumeration path — the same class of fix as the existing
Configuration Ready (`ROUTER_CS_6.CR`) wait already in this driver.

---

## Phase 2: Diff Analysis

### Step 2.1: Change Inventory
**Record:**
- `drivers/thunderbolt/tb_regs.h`: +1 line (`ROUTER_CS_6_RR`)
- `drivers/thunderbolt/usb4.c`: +6 / -1 lines in `usb4_switch_setup()`
- **Functions modified:** `usb4_switch_setup()`
- **Scope:** single-function, 2-file surgical fix

### Step 2.2: Code Flow Change
**Record:**
- **Hunk 1 (`tb_regs.h`):** Adds `ROUTER_CS_6_RR` (`BIT(24)`).
- **Hunk 2 (`usb4.c`):**
  - **Before:** `usb4_switch_setup()` wrote `ROUTER_CS_5` and returned
    immediately.
  - **After:** checks `tb_sw_write()` return value, then waits up to 500
    ms for `ROUTER_CS_6_RR` via `tb_switch_wait_for_bit()`.
- **Path affected:** USB4 router enumeration setup in
  `tb_switch_configure()` → `usb4_switch_setup()`.

### Step 2.3: Bug Mechanism
**Record:**
- **Category:** synchronization / hardware-readiness race
- **Mechanism:** Without waiting for RR, the CM can proceed to plug-
  event enablement and later configuration/tunnel setup while the router
  may still be finishing hardware configuration. The fix blocks until RR
  is set or returns `-ETIMEDOUT`.

### Step 2.4: Fix Quality
**Record:**
- **Quality:** High. Mirrors the existing CR wait in
  `usb4_switch_configuration_valid()`.
- **Regression risk:** Low. `tb_switch_wait_for_bit()` returns
  immediately when the bit is already set; 500 ms is a max timeout, not
  a fixed sleep.
- **Red flags:** none significant.

---

## Phase 3: Git History Investigation

### Step 3.1: Blame / Introduction of Buggy Code
**Record:**
- `usb4_switch_setup()` introduced in `d49b4f043d63b` (2022-10-11),
  refined in later commits.
- The direct-return `tb_sw_write()` path dates to original USB4 support
  (`b04079837b209`, 2019-12-18).
- **Bug present since initial USB4 support** in this subsystem.

### Step 3.2: Fixes: Tag
**Record:** N/A — no `Fixes:` tag.

### Step 3.3: Related File History
**Record:**
- Part of Gil Fine’s 5-patch series `[PATCH 0/5] CM fixes to follow CM
  guide more closely` on lore.
- Related upstream-only commits on `master` not in `linux-6.18.y`:
  - `ba2cc38511012` — increase CR timeout to 500 ms
  - `e24f3c0df4837` — increase notification timeout
  - `69a7b98770b7e` — verify PCIe adapter detect state before tunnel
    setup
- **This patch is standalone**; it does not depend on the other series
  members.

### Step 3.4: Author Context
**Record:** Gil Fine is a regular Thunderbolt contributor; prior work
includes moving/wait-bit infrastructure (`1639664fb74f3`). Mika
Westerberg committed/applied it.

### Step 3.5: Prerequisites
**Record:**
- `tb_switch_wait_for_bit()` exists in this tree (`switch.c`, declared
  in `tb.h`).
- `usb4_switch_setup()` exists and matches the patch context.
- `git apply --check` on the upstream patch: **clean apply**.
- **Standalone:** yes.

---

## Phase 4: Mailing List and External Research

### Step 4.1: Original Discussion
**Record:**
- `b4 dig -c 062023c4364ff` → https://patch.msgid.link/20260126220606.34
  76657-4-gil.fine@linux.intel.com
- Series: v1 only, `[PATCH 3/5]`
- Cover letter: “improves Connection Manager implementation to better
  align with the CM Guide”
- **No stable nomination found** in the downloaded thread.

### Step 4.2: Reviewers
**Record:** `b4 dig -w` CC’d `mika.westerberg@linux.intel.com`, `linux-
usb@vger.kernel.org`, Andreas Noever, YehezkelShB, Lukas Wunner. No
`Reviewed-by` / `Acked-by` captured in the committed result.

### Step 4.3: Bug Report
**Record:** No external bug report, syzbot link, or `Reported-by:`.

### Step 4.4: Series Context
**Record:** 5-patch CM-guide alignment series. Other patches include log
cleanup, PCIe LTSSM check, CR timeout increase, and notification timeout
increase. Only patch 3 is under review here.

### Step 4.5: Stable List History
**Record:** No stable-list discussion found for this specific patch.

---

## Phase 5: Code Semantic Analysis

### Step 5.1: Key Functions
**Record:** `usb4_switch_setup()`, `tb_switch_wait_for_bit()`,
`tb_switch_configure()`

### Step 5.2: Callers
**Record:**
- `usb4_switch_setup()` called from `tb_switch_configure()` in
  `switch.c` for USB4 routers.
- `tb_switch_configure()` called from:
  - hotplug path in `tb.c` (`~1344`) during downstream router discovery
  - resume/reconfigure paths (`switch.c`, `tb.c`)

**Context:** device hotplug/enumeration and resume — common, user-
visible paths.

### Step 5.3: Callees
**Record:** `tb_sw_read()`, `tb_sw_write()`, `tb_switch_wait_for_bit()`
— standard router config-space access and polling.

### Step 5.4: Reachability
**Record:**
- Triggered by USB4/Thunderbolt hotplug, resume, and domain
  initialization.
- Requires `CONFIG_USB4` / Thunderbolt stack; not universal, but
  important on modern laptops and docks.
- **Userspace-reachable indirectly** via physical hotplug/connect
  events.

### Step 5.5: Similar Patterns
**Record:** Existing CR wait in `usb4_switch_configuration_valid()`:

```329:330:drivers/thunderbolt/usb4.c
        return tb_switch_wait_for_bit(sw, ROUTER_CS_6, ROUTER_CS_6_CR,
                                      ROUTER_CS_6_CR, 50);
```

The RR wait is the missing earlier-stage counterpart after enumeration
setup.

---

## Phase 6: Cross-Reference Against Local Tree

### Step 6.1: Does Buggy Code Exist Here?
**Record:** **Yes.**
- Local tree: `stable/linux-6.18.y`, `v6.18.44`
- `ROUTER_CS_6_RR` is **not** present
- `usb4_switch_setup()` still returns directly after `tb_sw_write()`:

```294:297:drivers/thunderbolt/usb4.c
        /* TBT3 supported by the CM */
        val &= ~ROUTER_CS_5_CNS;

        return tb_sw_write(sw, &val, TB_CFG_SWITCH, ROUTER_CS_5, 1);
```

- Commit `062023c4364ff` is on `master` but **not** in this `6.18.y`
  checkout.

### Step 6.2: Backport Complications
**Record:** **Clean apply expected.** `git apply --check` succeeded with
no conflicts.

### Step 6.3: Related Fixes Already Present?
**Record:** No equivalent RR wait already in `6.18.y`. Related dock
timing fix `bd646c768a934` is already present, but it addresses a
different issue (sideband polling delay), not RR verification.

---

## Phase 7: Subsystem and Maintainer Context

### Step 7.1: Subsystem Criticality
**Record:** `drivers/thunderbolt` — **IMPORTANT**. Affects
USB4/Thunderbolt device enumeration on laptops, docks, and peripherals.

### Step 7.2: Subsystem Activity
**Record:** Actively maintained; recent stable-relevant fixes include
dock connection and wake issues.

---

## Phase 8: Impact and Risk Assessment

### Step 8.1: Who Is Affected
**Record:** Users with USB4/Thunderbolt hardware and
`CONFIG_USB4`/Thunderbolt enabled — common on Intel/Apple/modern AMD
laptops and docks.

### Step 8.2: Trigger Conditions
**Record:**
- USB4 router enumeration during hotplug, resume, or domain setup
- Race manifests when software proceeds before router sets RR
- **Likelihood:** intermittent/timing-dependent; bug has existed since
  2019 without a cited report, but the race window is real on a
  mandatory spec step

### Step 8.3: Failure Mode Severity
**Record:**
- **Without fix:** possible flaky enumeration, failed router bring-up,
  downstream tunnel/device failures
- **With fix:** explicit success or `-ETIMEDOUT` instead of proceeding
  on unready hardware
- **Severity:** **MEDIUM-HIGH** for affected hardware paths; not a
  kernel oops, but can make docks/devices fail to connect

### Step 8.4: Risk-Benefit
**Record:**
- **Benefit:** improves correctness of USB4 enumeration; prevents use of
  a router before hardware configuration completes
- **Risk:** very low — tiny patch, existing helper, immediate return
  when bit already set
- **Ratio:** favorable

---

## Phase 9: Final Synthesis

### Step 9.1: Evidence Summary

**For backport:**
- Real missing hardware-ready wait in USB4 enumeration
- Small, surgical, cleanly applies to `6.18.y`
- Uses existing `tb_switch_wait_for_bit()` infrastructure
- Consistent with existing CR wait in same driver
- Failure aborts enumeration cleanly instead of continuing in a bad
  state
- Maintainer-authored/applied Thunderbolt fix

**Against backport:**
- No user report, syzbot, or crash trace
- Framed as CM-guide compliance rather than fixing a reported regression
- Issue present since 2019 without demonstrated widespread impact
- Part of a broader spec-alignment series
- No explicit stable nomination or `Cc: stable`

**Unresolved:**
- No proof of a specific production failure this patch fixes
- No `Tested-by` on hardware

### Step 9.2: Stable Rules Checklist
1. Obviously correct and tested? **PASS** — logic is clear; no runtime
   test evidence
2. Fixes a real bug affecting users? **PASS** — missing mandatory
   hardware-ready check in enumeration
3. Important issue? **PASS** — can cause device/dock enumeration failure
4. Small and contained? **PASS** — 7 lines, 2 files
5. No new features/APIs? **PASS**
6. Can apply to this tree? **PASS**

### Step 9.3: Exception Categories
**Record:** Not a device-ID/quirk/DT/build/docs exception. This is a
driver correctness/hardware-readiness fix.

### Step 9.4: Decision Rationale

For **linux-6.18.y**, this is worth backporting. The missing RR
verification is not just documentation polish: it allows the connection
manager to continue router bring-up before the hardware signals
configuration completion. That is a real race in a user-visible hotplug
path. The fix is tiny, uses established driver infrastructure, applies
cleanly, and matches an existing pattern already present in this tree
for `ROUTER_CS_6_CR`. The lack of a specific bug report weakens the
case, but stable policy favors small correctness fixes that prevent
hardware-init races on commonly used laptop/dock paths when risk is
minimal.

---

## Verification

- [Phase 1] Parsed subject/tags/body from provided commit and `git show
  062023c4364ff`
- [Phase 2] Diff analysis: 2 files, `usb4_switch_setup()` only; adds RR
  define and wait
- [Phase 3] `git describe HEAD` → `v6.18.44`; tree is `6.18.44`
- [Phase 3] `git blame` on `usb4.c:295-297` → path present since USB4
  bring-up
- [Phase 3] `usb4_switch_setup` introduced via `b04079837b209` /
  `d49b4f043d63bd`
- [Phase 3] `tb_switch_wait_for_bit` present since `1639664fb74f3`
- [Phase 3] Commit not in `stable/linux-6.18.y`; present on `master` as
  `062023c4364ff`
- [Phase 4] `b4 dig -c 062023c4364ff` found lore thread
- [Phase 4] `b4 dig -a` found v1 series only
- [Phase 4] `b4 dig -w` listed Thunderbolt/USB maintainers/reviewers
- [Phase 4] Downloaded mbox; cover letter confirms CM-guide alignment
  series; no stable CC found
- [Phase 5] `grep usb4_switch_setup` → called from
  `tb_switch_configure()`
- [Phase 5] `grep tb_switch_configure` → hotplug path in `tb.c:1344`
- [Phase 5] Verified existing CR wait in
  `usb4_switch_configuration_valid()`
- [Phase 6] Confirmed `ROUTER_CS_6_RR` absent in current `6.18.y`
  checkout
- [Phase 6] `git apply --check` on upstream patch → clean apply
- [Phase 6] Verified prerequisites `tb_switch_wait_for_bit` and USB4
  support are ancestors of HEAD
- [Phase 8] Read failure handling in `tb.c:1344-1346` — configure
  failure drops switch and aborts bring-up

**YES****Verdict: YES** — backport to `linux-6.18.y`.

The commit adds a missing Router Ready (`ROUTER_CS_6.RR`) wait in
`usb4_switch_setup()` after USB4 router enumeration. Without it, the
driver can continue before hardware configuration finishes, which can
cause flaky dock/device bring-up. The fix is small (7 lines), applies
cleanly to `6.18.y`, and follows the same pattern as the existing
Configuration Ready wait in the Thunderbolt driver.

The main weakness is the lack of a reported bug or crash trace — it's
framed as CM-guide compliance — but the correctness issue in a hot
enumeration path and the low risk still make it a reasonable stable
candidate.

 drivers/thunderbolt/tb_regs.h | 1 +
 drivers/thunderbolt/usb4.c    | 7 ++++++-
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/thunderbolt/tb_regs.h b/drivers/thunderbolt/tb_regs.h
index 97404d8d878bf..7f2dcb309e928 100644
--- a/drivers/thunderbolt/tb_regs.h
+++ b/drivers/thunderbolt/tb_regs.h
@@ -216,6 +216,7 @@ struct tb_regs_switch_header {
 #define ROUTER_CS_6_WOPS			BIT(2)
 #define ROUTER_CS_6_WOUS			BIT(3)
 #define ROUTER_CS_6_HCI				BIT(18)
+#define ROUTER_CS_6_RR				BIT(24)
 #define ROUTER_CS_6_CR				BIT(25)
 #define ROUTER_CS_7				0x07
 #define ROUTER_CS_9				0x09
diff --git a/drivers/thunderbolt/usb4.c b/drivers/thunderbolt/usb4.c
index 9430bed07c468..6383fd43203d7 100644
--- a/drivers/thunderbolt/usb4.c
+++ b/drivers/thunderbolt/usb4.c
@@ -294,7 +294,12 @@ int usb4_switch_setup(struct tb_switch *sw)
 	/* TBT3 supported by the CM */
 	val &= ~ROUTER_CS_5_CNS;
 
-	return tb_sw_write(sw, &val, TB_CFG_SWITCH, ROUTER_CS_5, 1);
+	ret = tb_sw_write(sw, &val, TB_CFG_SWITCH, ROUTER_CS_5, 1);
+	if (ret)
+		return ret;
+
+	return tb_switch_wait_for_bit(sw, ROUTER_CS_6, ROUTER_CS_6_RR,
+				      ROUTER_CS_6_RR, 500);
 }
 
 /**
-- 
2.53.0

