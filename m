Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7866E544890;
	Mon, 31 Aug 2026 13:46:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183969; cv=none; b=dPyq8bvMJXrLKBBlNf9EyzMbzG1YxqggUycfC17rnkN5h9BrHDvN4BSI6whxuHH3ZHCiIqGmfbtY2nRDyRPD7TKFnotqoygEb58289H7wkRettZodaqSHIT7Wim52V6EZJ1aN6HgwpFc06RvZNBg7ARrJhQ67vtshGEiBhpcB5A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183969; c=relaxed/simple;
	bh=ad2ZfK+WzWZMftcgNKxhb5qHIIkDpac3P5FaL78wHwE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=B0tbw90ad5micff0u19sZUHnBrZHIcGwlKTh8+Je+m75BrWnFygMQK1m5IKq6+83iWDrKoewRaW03MPjUqENbK/4CFF/sS38ANp9iLDz1vJjwf3992KtAbPLiMTdZ1ENhW/fDuCIDvj65wGeGhekiieiCTbtmhnJa3e1d3/rOVg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hXPSIaN8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hXPSIaN8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD61C1F00ACA;
	Mon, 31 Aug 2026 13:46:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183966;
	bh=mKl7NM9aBxpP/vwG1jqeauSAaa989GRP58uEl1mVRio=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hXPSIaN8i93fKBkLksxjoAPt/AY3doMHkg8f/QrUrJgMy2/cFqS6j/8RxDqbF3vn/
	 5DosaaRLwDSf5KUmu77J3DwIsHL6jb0vUJptIb4VIBkTXWP+V2KfkSuekeRLpeTpyH
	 h85uss1uhMk8FPyz6hiEuyDTINAPss9xsvw9xJqX1Os4CdOirX7qnQN2KF14gmyqqk
	 GBoryCraF/9+mSRQnIRjV1QKml06eOs+2eJdU6+gCG6/r6gPnMObpqOpp6t/+Hm3b8
	 HIxB/YZjAK2DZDZOkajXhGjAVsqRu9VNR1/IVfpR+VbVrISP0ASKEHykTeYtX1FTit
	 agmguIk7QQ1Ug==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	yung-chuan.liao@linux.intel.com,
	linux-sound@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] soundwire: validate DT compatible before parsing it
Date: Mon, 31 Aug 2026 09:27:17 -0400
Message-ID: <20260831133314.4125787-409-sashal@kernel.org>
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

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit 45c7bda7b7440183850012153988e40b300f40d0 ]

`sdw_of_find_slaves()` fetches raw `"compatible"` bytes with
`of_get_property()` and then immediately parses them with
`sscanf("sdw%01x%04hx%04hx%02hhx", ...)`.

Live-tree OF properties are stored as raw bytes plus a separate length;
they are not globally guaranteed to be NUL-terminated. Validate the
first compatible string before parsing it.

Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Link: https://patch.msgid.link/20260403183504.4-soundwire-compatible-pengpeng@iscas.ac.cn
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: `soundwire: validate DT compatible before
parsing it`

**Local tree:** `v6.18.43-1-gc7f0dac02d232` (Linux **6.18.43**)

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Subject Line
**Record:** `[soundwire] [validate] validate DT compatible before
parsing it` — subsystem is SoundWire; action is validation/correctness
fix before string parsing.

### Step 1.2: Commit Tags
**Record:**
- **Signed-off-by:** Pengpeng Hou `<pengpeng@iscas.ac.cn>` (author)
- **Link:** https://patch.msgid.link/20260403183504.4-soundwire-
  compatible-pengpeng@iscas.ac.cn
- **Signed-off-by:** Vinod Koul `<vkoul@kernel.org>` (SoundWire
  maintainer, applied)
- No `Fixes:`, `Reported-by:`, `Tested-by:`, `Reviewed-by:`, `Cc:
  stable@vger.kernel.org`
- Pipeline markers (`[Upstream commit ...]`, Sasha Levin SOB) ignored
  per instructions

### Step 1.3: Body Analysis
**Record:**
- **Bug:** `sdw_of_find_slaves()` uses `of_get_property()` to fetch raw
  `"compatible"` bytes, then passes them to `sscanf()` and `%s` logging
  without ensuring NUL termination within property bounds.
- **Symptom:** Out-of-bounds read when the first compatible string is
  not NUL-terminated within the declared property length (live-tree OF
  properties).
- **Root cause:** Live-tree OF properties are length-delimited byte
  sequences, not guaranteed C strings; `of_get_property()` does not
  validate string termination.
- **Version info:** None stated in commit message.

### Step 1.4: Hidden Bug Fix Detection
**Record:** Yes — described as validation, but it is a real memory-
safety bug fix (out-of-bounds read via `sscanf()` / `%s`), not cosmetic
cleanup.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Change Inventory
**Record:**
- **Files:** `drivers/soundwire/slave.c` only (+2 / −2 lines)
- **Function:** `sdw_of_find_slaves()`
- **Scope:** Single-file, surgical fix

### Step 2.2: Code Flow Change
**Record:**
- **Before:** `compat = of_get_property(node, "compatible", NULL); if
  (!compat) continue;` — uses raw property pointer directly.
- **After:** `ret = of_property_read_string(node, "compatible",
  &compat); if (ret) continue;` — validates NUL termination within
  `prop->length` before use.
- **Path affected:** Device-tree slave enumeration loop during SoundWire
  bus master registration (normal probe path on OF platforms).

### Step 2.3: Bug Mechanism
**Record:**
- **Category:** Memory safety / out-of-bounds read (buffer/string
  bounds)
- **Mechanism:** `of_get_property()` returns `prop->value` without
  checking that a NUL byte exists within `prop->length`. `sscanf(compat,
  ...)` and `dev_err(..., "%s", compat)` scan until NUL, potentially
  reading past the property into adjacent kernel memory.
  `of_property_read_string()` rejects malformed strings via
  `strnlen(prop->value, prop->length) >= prop->length` → `-EILSEQ`.

### Step 2.4: Fix Quality
**Record:**
- Obviously correct — canonical OF API for reading string properties.
- Minimal change; no unrelated edits.
- Low regression risk: valid, well-formed DT `compatible` strings behave
  identically; malformed/non-terminated strings are skipped instead of
  parsed unsafely.
- `ret` is already declared in the loop scope; reuse is safe.

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame / Introduction
**Record:** In this checkout, `sdw_of_find_slaves()` with
`of_get_property(node, "compatible", ...)` is present at `ac3fd01e4c1ef`
(Linux 6.18-rc7) and in current HEAD. Git history in this repo is
shallow; blame metadata is unreliable (shows unrelated AFS commit), but
the buggy pattern is confirmed present in 6.18.43.

### Step 3.2: Fixes: Tag
**Record:** N/A — no `Fixes:` tag in commit message.

### Step 3.3: Related File History
**Record:** Recent `drivers/soundwire/` activity includes other bug
fixes (e.g. `a454f61747c97 soundwire: fix bug in
sdw_add_element_group_count found by syzkaller`). No duplicate fix for
this compatible-string issue found in current HEAD.

### Step 3.4: Author Context
**Record:** Pengpeng Hou has multiple similar “validate before string
parse” fixes in this tree (e.g. Bluetooth btusb, ASoC tas2781, media
drivers). Vinod Koul (SoundWire maintainer) applied the patch.

### Step 3.5: Dependencies
**Record:** Standalone — no series dependency, no prerequisite commits
required. `of_property_read_string()` already exists in
`drivers/of/property.c` in this tree.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: Original Discussion
**Record:**
- **b4 dig URL:** https://patch.msgid.link/20260403183504.4-soundwire-
  compatible-pengpeng@iscas.ac.cn
- **Revisions:** v1 only (no v2/v3)
- **Review:** Vinod Koul replied “Applied, thanks!” — no NAKs, no
  objections
- **Stable nomination:** None in thread

### Step 4.2: Reviewers
**Record:** CC'd: Vinod Koul, Bard Liao, Pierre-Louis Bossart, linux-
sound@vger.kernel.org, linux-kernel@vger.kernel.org

### Step 4.3: Bug Report
**Record:** No syzbot, no user crash report, no Bugzilla link. Issue
identified via OF live-tree string-safety analysis (same author filed
related `drivers/of: validate live-tree string properties before string
use`).

### Step 4.4: Related Series
**Record:** Related but separate upstream commit `1e54c31b9cbbb` fixes
OF core helpers; this SoundWire commit is independently applicable.

### Step 4.5: Stable List History
**Record:** Not searched exhaustively; no stable-list nomination found
in patch thread.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Key Functions
**Record:** `sdw_of_find_slaves()` modified.

### Step 5.2: Callers
**Record:**
- `sdw_bus_master_add()` in `drivers/soundwire/bus.c:141` calls
  `sdw_of_find_slaves(bus)` when `CONFIG_OF` and `bus->dev->of_node` and
  ACPI path is not taken.
- `sdw_bus_master_add()` called from `drivers/soundwire/qcom.c`,
  `drivers/soundwire/amd_manager.c`,
  `drivers/soundwire/intel_auxdevice.c`.

### Step 5.3: Callees
**Record:** `of_property_read_string()`, `sscanf()`, `of_get_property()`
(for `reg`), `sdw_slave_add()`, `dev_err()`.

### Step 5.4: Reachability
**Record:**
- Triggered at SoundWire controller probe/registration on OF-based
  platforms (e.g. Qualcomm SoundWire).
- On typical x86 Intel laptops, ACPI path (`sdw_acpi_find_slaves`) is
  preferred when `ACPI_HANDLE(bus->dev)` is set; OF path applies to
  embedded/ARM platforms without ACPI.
- Reachable during boot driver probe; not a syscall path, but triggered
  during normal hardware initialization.

### Step 5.5: Similar Patterns
**Record:** Identical `of_get_property(..., "compatible", ...)` +
`sscanf` pattern exists in `drivers/slimbus/core.c:211` (not fixed by
this commit). Confirms this is a known anti-pattern class.

---

## PHASE 6: CROSS-REFERENCING AGAINST LOCAL TREE (6.18.43)

### Step 6.1: Buggy Code Present?
**Record:** **Yes.** Current `drivers/soundwire/slave.c:243-245` still
uses `of_get_property(node, "compatible", NULL)`. Fix commit
`89e52161a7b25` / upstream `45c7bda7b744` is **not** applied to HEAD.

### Step 6.2: Backport Complications
**Record:** Clean apply expected — 2-line change, no structural
conflicts. `slave.c` in this tree matches the patch context.

### Step 6.3: Related Fixes Already Present?
**Record:** No — grep shows no `of_property_read_string` usage in
`drivers/soundwire/`. Bug remains unfixed.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

### Step 7.1: Subsystem Criticality
**Record:** **drivers/soundwire** — IMPORTANT/PERIPHERAL. Affects audio
hardware on OF-based SoundWire platforms (mobile/embedded), not
universal core kernel code.

### Step 7.2: Subsystem Activity
**Record:** Actively maintained; recent syzkaller-found SoundWire fix in
this tree shows the subsystem receives stability attention.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: Who Is Affected
**Record:** Users of SoundWire on device-tree platforms without ACPI
(e.g. Qualcomm SoundWire controllers). Intel ACPI-dominated paths are
unaffected.

### Step 8.2: Trigger Conditions
**Record:** SoundWire bus master add enumerates child DT nodes whose
`compatible` property lacks an in-bounds NUL terminator. More likely
with live-tree/dynamic OF properties than well-formed static DTBs (dtc
normally emits NUL-terminated strings), but possible with malformed DT
or runtime property manipulation.

### Step 8.3: Failure Mode Severity
**Record:** Out-of-bounds kernel memory read during `sscanf()` / `%s`
logging → **HIGH** (memory safety; potential info leak or KASAN fault;
unpredictable parse results). Not proven to cause production panics, but
consequences are serious if triggered.

### Step 8.4: Risk-Benefit
**Record:**
- **Benefit:** Eliminates OOB read in probe path; aligns with OF API
  contract.
- **Risk:** Very low — 2-line API substitution, no behavior change for
  valid DT.
- **Ratio:** Favorable for backport.

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence Summary

**FOR backport:**
- Real memory-safety bug (OOB read via string functions on non-validated
  property bytes)
- Tiny, obviously correct fix using standard `of_property_read_string()`
  API
- Buggy code confirmed present in Linux 6.18.43 checkout
- Applies cleanly; no dependencies
- Subsystem maintainer applied without objection
- Same author/maintainer pattern as other validated string-parse fixes

**AGAINST backport:**
- No syzbot report or user crash report
- Trigger may be uncommon on static, dtc-generated DTBs
- x86 Intel SoundWire (major desktop/laptop user base) typically uses
  ACPI path, not OF
- No explicit stable nomination in review thread

**Unresolved:**
- Exact kernel version when `sdw_of_find_slaves()` was first introduced
  (shallow git history in this repo)
- No confirmed production crash attributed to this specific bug

### Step 9.2: Stable Rules Checklist
1. Obviously correct and tested? **PASS** — idiomatic OF API; maintainer
   applied; no test regressions reported
2. Fixes a real bug? **PASS** — OOB read on non-NUL-terminated
   compatible property
3. Important issue? **PASS** — memory safety / OOB read (HIGH severity
   class)
4. Small and contained? **PASS** — 2 lines, 1 file
5. No new features/APIs? **PASS** — uses existing
   `of_property_read_string()`
6. Can apply to local tree? **PASS** — buggy code present, patch applies
   cleanly

### Step 9.3: Exception Category
**Record:** None (not device ID, quirk, DT binding, build fix, or docs).
Standard bug fix.

### Step 9.4: Decision Rationale

For **this** 6.18.43 tree, the buggy `of_get_property()` + string-parse
pattern exists in `sdw_of_find_slaves()` and is reachable on OF
SoundWire probe. The fix is minimal, uses the correct existing API, and
prevents an out-of-bounds read. While the trigger is less common than a
syzbot-reported crash and many Intel systems use the ACPI enumeration
path, the stable rules favor small, obviously-correct memory-safety
fixes in driver probe paths. The fix meets all stable criteria for this
tree.

---

## Verification

- **[Phase 1]** Parsed commit message and tags from user query and `git
  show 89e52161a7b25`
- **[Phase 1]** Confirmed no Reported-by/syzbot/Fixes tags
- **[Phase 2]** Read current `drivers/soundwire/slave.c:231-274` — buggy
  `of_get_property` pattern present
- **[Phase 2]** Read `git show 89e52161a7b25` — 2-line fix confirmed
- **[Phase 2]** Read `drivers/of/property.c:496-509` —
  `of_property_read_string()` validates NUL within `prop->length`
- **[Phase 3]** `git describe HEAD` → v6.18.43
- **[Phase 3]** `git show ac3fd01e4c1ef:drivers/soundwire/slave.c` —
  buggy code present since 6.18-rc7 base in this repo
- **[Phase 3]** `git log --oneline -20 -- drivers/soundwire/` — no
  duplicate fix found
- **[Phase 4]** `b4 dig -c 45c7bda7b7440183850012153988e40b300f40d0` —
  found lore thread
- **[Phase 4]** `b4 dig -a` — v1 only
- **[Phase 4]** `b4 dig -w` — maintainers CC'd (Vinod Koul, Bard Liao,
  Pierre-Louis Bossart)
- **[Phase 4]** `b4 dig -m /tmp/soundwire_compat.mbx` — Vinod applied;
  no stable nomination, no NAKs
- **[Phase 5]** `grep sdw_of_find_slaves` — caller in `bus.c:141`
- **[Phase 5]** `grep sdw_bus_master_add` — callers in qcom.c,
  amd_manager.c, intel_auxdevice.c
- **[Phase 5]** Read `bus.c:138-143` — OF path conditional confirmed
- **[Phase 5]** `grep of_get_property.*compatible` — similar unfixed
  pattern in slimbus/core.c
- **[Phase 6]** HEAD still has `of_get_property` at slave.c:243 — fix
  not applied
- **[Phase 6]** `of_property_read_string` available in
  include/linux/of.h and drivers/of/property.c
- **[Phase 7]** `drivers/soundwire/Makefile` — slave.c always built into
  soundwire-bus
- **[Phase 8]** Read `drivers/of/fdt.c:151-153` — boot-time properties
  point into DT blob (normally NUL-terminated by dtc); live-tree case
  documented in commit message and related OF fix

**YES**Those background lookups finished and matched what we used in the
analysis:

- **b4 dig** eventually succeeded on upstream commit `45c7bda7b744` and
  found the lore thread (v1 only; Vinod Koul applied it).
- **Soundwire grep on autosel** located the fix as `89e52161a7b25`, plus
  a related OF live-tree validation commit (`75a2c260ce6a1`).
- **History search** on autosel only surfaced the fix commit itself —
  this repo’s history is shallow, so when `sdw_of_find_slaves()` was
  introduced couldn’t be pinned down reliably here.

That lines up with the earlier conclusion: the buggy `of_get_property()`
usage is still in 6.18.43, the fix is a clean 2-line change, and the
backport recommendation remains **YES**.

 drivers/soundwire/slave.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/soundwire/slave.c b/drivers/soundwire/slave.c
index 3d4d00188c26c..3c84027692460 100644
--- a/drivers/soundwire/slave.c
+++ b/drivers/soundwire/slave.c
@@ -240,8 +240,8 @@ int sdw_of_find_slaves(struct sdw_bus *bus)
 		struct sdw_slave_id id;
 		const __be32 *addr;
 
-		compat = of_get_property(node, "compatible", NULL);
-		if (!compat)
+		ret = of_property_read_string(node, "compatible", &compat);
+		if (ret)
 			continue;
 
 		ret = sscanf(compat, "sdw%01x%04hx%04hx%02hhx", &sdw_version,
-- 
2.53.0

