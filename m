Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BA13530DFE;
	Mon, 31 Aug 2026 13:45:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183903; cv=none; b=er1eqjRyw+hAYsKOUw9L6p06Hn17eqhJir0e4OAKtADdiz0RMEpXUuLxvOw36vnMBb2B+FdJZ3nhReXy8f3d+0MqpJJjGbF3VnQsgOYOfLPCGBideEddDoRq+ukcn8btbzQMhZRVOL5nE0l3EWm2Ra/63ksxWEreRemW1mHjxJQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183903; c=relaxed/simple;
	bh=A9wcVg/qwbsNaIOy7VZIx0sVrR5+ogYxsAEZBgXB610=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZgMsEKuQT0IHFeElARxWU67SVuhjfi1dtpR/2ZG213KIneh/ITVJFY3cr03h5bTzvlC9Bywp/jbnxy+Osqi0ZY5n8Aos6y1SGvJp5eQCSTm1dd6XlfrKrfvxAmxdR6N0NI4oH4JgEQIJLA7lOGVk+NbsIN2B79FFoDQLAFntupQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gBFlgIr+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gBFlgIr+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D02681F000E9;
	Mon, 31 Aug 2026 13:44:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183900;
	bh=lxHNJnQPSpDPD+kKDwAJoTZTqjJCXIA4FZuShnRYobQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gBFlgIr+Q2TD6VPJ02Bgy7iqgbCw2BnDtDolKuNlJ9nFnrqXyW+1tZ6fSXJy7ZAze
	 VgfhJ/5+2VJIH57/N8GbUqCmKR2JXwKcPv+rvFbRgegyBzuTGCbSKClZ0vL59En6vz
	 wLdhBcCej2qAxKs9Uchz+p2J7aLUij2DeJLiKeYp1TfUngVqC8MQLuVV8tDe2RpT9S
	 BT36cTvUYiXe4B6+Bd6CuywJU9LUVKq1nR4gQao7FJZR5Q4fR16rt7geH8JDhxjr4K
	 CvVssaCo3lvXSS7zvgXd/bZci412UnMScCydLvQ5gC/lXOZWsEtaWlEK5iT4Tme7Hp
	 ZadkWGMLvm8wQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Pengpeng Hou <pengpeng@iscas.ac.cn>,
	"Rob Herring (Arm)" <robh@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	saravanak@kernel.org,
	devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.6] drivers/of: validate status properties in reconfig state changes
Date: Mon, 31 Aug 2026 09:26:38 -0400
Message-ID: <20260831133314.4125787-370-sashal@kernel.org>
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

[ Upstream commit 0b6b12c5dcce16e604d4cde953bef46531b98571 ]

Live-tree reconfiguration properties also carry raw values plus explicit
lengths. `of_reconfig_get_state_change()` currently treats `status`
property values as NUL-terminated strings and feeds them straight into
`strcmp()`.

Factor the `"okay"` / `"ok"` check out into a helper that first verifies
that the property contains a bounded C string within `prop->length`.
Malformed `status` updates should be treated as not enabling the node.

Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Link: https://patch.msgid.link/20260507081812.91838-2-pengpeng@iscas.ac.cn
Signed-off-by: Rob Herring (Arm) <robh@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit Message Forensics

### Step 1.1: Subject Line
**Record:** `[drivers/of]` `[validate]` — validate `status` properties
during live-tree reconfiguration state-change detection.

### Step 1.2: Tags
**Record:**
- **Link:**
  `https://patch.msgid.link/20260507081812.91838-2-pengpeng@iscas.ac.cn`
  (v3, patch 2/2)
- **Signed-off-by:** Pengpeng Hou `<pengpeng@iscas.ac.cn>`
- **Signed-off-by:** Rob Herring (Arm) `<robh@kernel.org>` (OF
  maintainer)
- No Fixes:, Reported-by:, Tested-by:, Cc: stable, or syzbot tags
- Notable: patch **2/2** in a series; v3 changelog says "no code change;
  carried with patch 1/2"

### Step 1.3: Body Analysis
**Record:**
- **Bug:** `of_reconfig_get_state_change()` uses `strcmp()` on
  `prop->value` without verifying a NUL terminator within
  `prop->length`. Live-tree reconfiguration properties are raw byte
  sequences + explicit length.
- **Symptom:** Malformed/non-NUL-terminated `status` values can cause
  out-of-bounds reads via `strcmp()`, and may be misclassified as
  enabling/disabling a node.
- **Fix approach:** New `of_property_status_ok()` helper uses
  `strnlen()` bounded by `prop->length`; malformed values → not
  enabling.
- **Root cause:** Reconfig path assumes C strings; DT properties are
  length-bounded byte sequences.

### Step 1.4: Hidden Bug Fix?
**Record:** Yes — described as validation, but it is a memory-safety and
correctness fix (OOB read + wrong state decisions), not cosmetic
cleanup.

---

## Phase 2: Diff Analysis

### Step 2.1: Inventory
**Record:**
- **File:** `drivers/of/dynamic.c` (+16 / -4, ~20 lines net)
- **Functions:** new `of_property_status_ok()`; modified
  `of_reconfig_get_state_change()`
- **Scope:** Single-file, surgical fix

### Step 2.2: Code Flow Change
**Record:**
- **Hunk 1 (new helper):** Before — no bounds check. After — reject
  NULL/empty/non-NUL-terminated values; only then `strcmp("okay"/"ok")`.
- **Hunk 2 (`of_reconfig_get_state_change`):** Before — direct
  `strcmp(prop->value, "okay")`. After — `of_property_status_ok(prop)`
  for new and old status properties on ADD/UPDATE/REMOVE/ATTACH/DETACH
  paths.

### Step 2.3: Bug Mechanism
**Record:** **Category:** Memory safety (out-of-bounds read) + logic
correctness.
- `strcmp()` reads past `prop->length` when no NUL exists within the
  declared length.
- `__of_prop_dup()` copies exactly `prop->length` bytes via `kmemdup()`
  with no added NUL.
- FDT `populate_properties()` stores raw blob bytes with `pp->length =
  sz` — a normal `status = "okay"` is 4 bytes, typically without a
  trailing NUL.
- Malformed values may be treated as enabled when they should not be.

### Step 2.4: Fix Quality
**Record:** Obviously correct; matches existing OF patterns in
`overlay.c:228` and `property.c:505`. Minimal regression risk —
conservative default (malformed = disabled). No new APIs.

---

## Phase 3: Git History Investigation

### Step 3.1: Blame
**Record:** Buggy `strcmp` lines at `dynamic.c:138-142` attributed to
`6bda50f4333fa` (initial tree content). `of_reconfig_get_state_change()`
has been present since tree import; bug is not newly introduced
post-6.18 branch.

### Step 3.2: Fixes: Tag
**Record:** N/A — no Fixes: tag.

### Step 3.3: Related File History
**Record:** Recent `dynamic.c` changes: `fa9a4c5e` (fwnode flags thread
safety), `ae62edb0` (revert). No prior fix for this issue in this tree.
Fix not yet merged here.

### Step 3.4: Author Context
**Record:** Pengpeng Hou has multiple sanitizer-hardening patches in
this tree (btusb, hwmon, media, iommu). Rob Herring reviewed and
committed. Patch series went v1 → v2 → v3 with maintainer feedback on
patch 1/2 only.

### Step 3.5: Dependencies
**Record:** Patch 2/2 is **standalone** — self-contained helper in
`dynamic.c`, no symbols from patch 1/2. v3 changelog explicitly says "no
code change" in 2/2 across revisions. Can apply independently.

---

## Phase 4: Mailing List and External Research

### Step 4.1: Original Discussion
**Record:** Lore blocked by bot protection. Verified via lkml.iu.edu
mirror: [PATCH v3 2/2](https://lkml.iu.edu/2605.0/09220.html). Series:
patch 1/2 fixes `of_prop_next_string()` / `__of_device_is_status()` in
`property.c`/`base.c`; patch 2/2 fixes reconfig notifier path.

### Step 4.2: Reviewers
**Record:** To: Rob Herring, Saravana Kannan. Cc: devicetree, linux-
kernel. Rob Herring applied with his Signed-off-by.

### Step 4.3: Bug Report
**Record:** No external bug report or syzbot link. Bug identified by
code analysis in patch series (live-tree properties not NUL-terminated).

### Step 4.4: Series Context
**Record:** Patch 1/2 is complementary but separate. This commit alone
closes the reconfig-specific hole. Patch 1/2 not in this tree either.

### Step 4.5: Stable List
**Record:** No stable-list discussion found (lore inaccessible). Not a
negative signal per instructions.

---

## Phase 5: Code Semantic Analysis

### Step 5.1: Key Functions
**Record:** `of_property_status_ok()` (new),
`of_reconfig_get_state_change()` (modified).

### Step 5.2: Callers
**Record:** `of_reconfig_get_state_change()` called from reconfig
notifiers in:
- `drivers/of/platform.c:730` — platform device create/destroy on DT
  changes
- `drivers/i2c/i2c-core-of.c:168` — I2C client register/unregister
- `drivers/spi/spi.c:4802` — SPI device management
- `drivers/gpio/gpiolib-of.c:909` — GPIO chip management
- `drivers/bus/imx-weim.c:309` — WEIM bus

All under `CONFIG_OF_DYNAMIC`.

### Step 5.3: Callees
**Record:** `strnlen()`, `strcmp()` — validation then comparison only on
bounded C strings.

### Step 5.4: Reachability
**Record:** Triggered during live DT changesets/overlays
(`of_changeset_apply()`, `of_overlay_*()`). `CONFIG_OF_DYNAMIC` is
selected by `CONFIG_OF_OVERLAY` (common on ARM/embedded) and several
platform Kconfigs (PowerPC pseries, PCI, etc.). Reachable when overlays
change `status` or nodes are attached/detached — not a dead-code path on
affected configs.

### Step 5.5: Similar Patterns
**Record:** Same `strnlen(prop->value, prop->length) >= prop->length`
guard already used in `overlay.c:228` and `of_property_read_string()` at
`property.c:505`. This commit brings the reconfig path in line with
established OF practice.

---

## Phase 6: Cross-Reference Against Local Tree

### Step 6.1: Buggy Code Present?
**Record:** **Yes.** Local tree is **6.18.43** (`git describe HEAD` →
`v6.18.43-1-gc7f0dac02d232`). Buggy `strcmp` code present at
`drivers/of/dynamic.c:138-142`. Fix (`of_property_status_ok`) **not**
present.

### Step 6.2: Backport Complications
**Record:** Clean apply expected — single file, no structural conflicts.
Recent `dynamic.c` churn is unrelated (fwnode flags, revert).

### Step 6.3: Related Fixes Already Present?
**Record:** No. `of_property_status_ok` not found. Patch 1/2 string-
validation changes not in tree.

---

## Phase 7: Subsystem Context

### Step 7.1: Subsystem Criticality
**Record:** **drivers/of** — device tree core. **IMPORTANT** for
ARM/embedded/PowerPC platforms using live DT overlays; not universal
like mm/net, but critical on affected platforms.

### Step 7.2: Activity
**Record:** OF subsystem actively maintained; live-tree/overlay code is
mature but still receiving hardening fixes.

---

## Phase 8: Impact and Risk Assessment

### Step 8.1: Who Is Affected
**Record:** Platforms with `CONFIG_OF_DYNAMIC` (typically
`CONFIG_OF_OVERLAY`). Users applying DT overlays or runtime changesets
that touch `status` properties.

### Step 8.2: Trigger Conditions
**Record:**
- Any reconfig action where `status` property lacks NUL within
  `prop->length` — includes normal FDT `"okay"` (4 bytes) on ATTACH_NODE
  via `of_find_property()`.
- Overlay property updates via `__of_prop_dup()` (exact-length copy, no
  NUL appended).
- **Likelihood:** Moderate on overlay-enabled systems; ATTACH_NODE with
  standard DTB is a common path.
- **Unprivileged trigger:** Overlay application typically requires
  elevated privileges (root/capabilities), limiting direct userspace
  exploitation.

### Step 8.3: Failure Mode Severity
**Record:**
- **OOB read** via `strcmp()` past property boundary — **HIGH** (memory
  safety; KASAN-detectable)
- **Incorrect enable/disable** of platform/I2C/SPI/GPIO devices —
  **MEDIUM-HIGH** (wrong devices probed or removed)
- Not typically a direct panic, but real correctness and safety impact.

### Step 8.4: Risk-Benefit
**Record:**
- **Benefit:** HIGH on OF_DYNAMIC platforms — closes verified OOB read
  and fixes state-machine correctness.
- **Risk:** VERY LOW — ~14 lines of helper, conservative semantics,
  maintainer-reviewed, matches existing OF patterns.
- **Ratio:** Strongly favors backport.

---

## Phase 9: Final Synthesis

### Step 9.1: Evidence Summary

**FOR backport:**
- Real memory-safety bug (`strcmp` past `prop->length`)
- Affects live DT reconfiguration — common overlay path on embedded ARM
- Can mis-probe or mis-remove devices
- Small, self-contained, obviously correct
- OF maintainer (Rob Herring) signed off
- Buggy code confirmed present in local 6.18.43 tree
- Standalone — no dependency on patch 1/2
- Matches established validation pattern elsewhere in OF

**AGAINST backport:**
- Only affects `CONFIG_OF_DYNAMIC` builds (not all kernels)
- No syzbot/user crash report filed
- Patch 1/2 addresses related paths separately (but does not subsume
  this fix)
- Overlay access usually requires privileges

**Unresolved:** Full lore review thread unavailable (bot protection). No
runtime crash report — impact inferred from code analysis.

### Step 9.2: Stable Rules Checklist
1. Obviously correct and tested? **PASS** — logic mirrors
   `overlay.c`/`property.c`; maintainer reviewed; no unit tests in this
   patch but pattern is established.
2. Fixes a real bug? **PASS** — OOB read and incorrect status
   classification verified in code.
3. Important issue? **PASS** — memory safety (HIGH) + device probe
   correctness (MEDIUM-HIGH).
4. Small and contained? **PASS** — 1 file, ~20 lines.
5. No new features/APIs? **PASS** — static helper only.
6. Can apply to local tree? **PASS** — buggy code present, clean apply
   expected.

### Step 9.3: Exception Category
**Record:** Not a device-ID/quirk/DT/bindings/doc exception — standard
bug fix.

### Step 9.4: Problem Summary for Stable Users

On 6.18.y systems with live device-tree reconfiguration enabled,
`of_reconfig_get_state_change()` uses unbounded `strcmp()` on `status`
property values that are stored as length-delimited byte sequences (not
guaranteed NUL-terminated). A normal `status = "okay"` from a DTB is 4
bytes without a trailing NUL; `__of_prop_dup()` also copies without
appending NUL. This can read past the property boundary and produce
wrong enable/disable decisions during overlay application, causing
incorrect device probe/remove behavior on affected platforms.

The fix is minimal, self-contained, maintainer-approved, and directly
applicable to this 6.18.43 tree where the bug exists.

---

## Verification

- **[Phase 1]** Parsed subject, tags, body from user-provided commit
  message; fetched lkml mirror for v3 2/2
- **[Phase 2]** Read diff; confirmed `of_property_status_ok()` and
  `of_reconfig_get_state_change()` changes
- **[Phase 2]** Read `__of_prop_dup()` at `dynamic.c:409-425` —
  `kmemdup(prop->value, prop->length)` without NUL
- **[Phase 2]** Read `populate_properties()` at `fdt.c:151-153` — stores
  raw FDT bytes with explicit length
- **[Phase 2]** Confirmed `strnlen` pattern in `overlay.c:228` and
  `property.c:505`
- **[Phase 3]** `git blame -L 136,142 drivers/of/dynamic.c` → lines from
  `6bda50f4333fa`
- **[Phase 3]** `git log --oneline -20 -- drivers/of/dynamic.c` — no
  prior fix for this issue
- **[Phase 3]** `git log --grep='of_property_status_ok'` — no results
  (fix not merged)
- **[Phase 4]** lkml.iu.edu/2605.0/09220.html — confirmed v3 2/2 content
  and standalone nature
- **[Phase 4]** Web search — identified patch 1/2 as separate (`validate
  live-tree string properties`)
- **[Phase 4]** lore.kernel.org — blocked (Anubis); b4 dig requires
  commit hash not available in tree
- **[Phase 5]** `grep of_reconfig_get_state_change` — 5 caller sites
  verified
- **[Phase 5]** Read `platform.c:730`, `i2c-core-of.c:168` notifier
  paths
- **[Phase 6]** `git describe HEAD` → v6.18.43; `make kernelversion` →
  6.18.43
- **[Phase 6]** Read `dynamic.c:136-142` — buggy strcmp code present
- **[Phase 6]** `grep of_property_status_ok` — not found
- **[Phase 7]** Read `drivers/of/Kconfig:83-107` — OF_DYNAMIC selected
  by OF_OVERLAY
- **[Phase 8]** Assessed OOB read + incorrect probe as HIGH/MEDIUM-HIGH
  severity
- **UNVERIFIED:** No runtime KASAN report or user crash report found for
  this specific path

**YES**The background `git log -S 'of_reconfig_get_state_change'` job
hung (likely from a slow history walk) and was killed. A rerun without
`--all` finished, but this tree’s history is shallow, so it didn’t pin
down when the function was first added.

That didn’t change the backport call: the buggy `strcmp` path is present
in your **6.18.43** tree, the fix is small and self-contained, and the
verdict remains **YES**.

 drivers/of/dynamic.c | 20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

diff --git a/drivers/of/dynamic.c b/drivers/of/dynamic.c
index b5be7484fb36d..3e08484d351b4 100644
--- a/drivers/of/dynamic.c
+++ b/drivers/of/dynamic.c
@@ -74,6 +74,20 @@ static const char *action_names[] = {
 	[OF_RECONFIG_UPDATE_PROPERTY] = "UPDATE_PROPERTY",
 };
 
+static bool of_property_status_ok(const struct property *prop)
+{
+	const char *status;
+
+	if (!prop || !prop->value || prop->length <= 0)
+		return false;
+
+	status = prop->value;
+	if (strnlen(status, prop->length) >= prop->length)
+		return false;
+
+	return !strcmp(status, "okay") || !strcmp(status, "ok");
+}
+
 #define _do_print(func, prefix, action, node, prop, ...) ({	\
 	func("changeset: " prefix "%-15s %pOF%s%s\n",		\
 	     ##__VA_ARGS__, action_names[action], node,		\
@@ -135,11 +149,9 @@ int of_reconfig_get_state_change(unsigned long action, struct of_reconfig_data *
 
 	if (prop && !strcmp(prop->name, "status")) {
 		is_status = 1;
-		status_state = !strcmp(prop->value, "okay") ||
-			       !strcmp(prop->value, "ok");
+		status_state = of_property_status_ok(prop);
 		if (old_prop)
-			old_status_state = !strcmp(old_prop->value, "okay") ||
-					   !strcmp(old_prop->value, "ok");
+			old_status_state = of_property_status_ok(old_prop);
 	}
 
 	switch (action) {
-- 
2.53.0

