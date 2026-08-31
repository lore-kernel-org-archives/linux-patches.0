Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E32A048BD2B;
	Mon, 31 Aug 2026 13:38:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183501; cv=none; b=NbQ1o4nSYn6+2pdI0BdfUBPAHc8jX/nVstPCcYBDdmru8HR5ppe0jmrtYxvXNfApjV9Kb78g2m2cUFfSl/jQIW2YodXTOMoRQerbeGtJh7vYGRN2z8i946y1A3vcCRWJlhQ+5ajHpld1lxHjvCwPXj9Ys9E4tMvjI3gdGdiTztQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183501; c=relaxed/simple;
	bh=J3KzQI3LwPWninebhn9NXhINLhL9S5YrKyahMcJWm08=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WcoqQ5P2AwHY7ApaiDQQixXMVDhliLvqe7mgTW9QJwVEdzA1k2Fo91cpNG2FndUGD/GJfh+UBQ431iOSJsoo7q9A9lSKMlLSGFfa5bPMATzLbxMUwzit7tlwM9DJR8c/sRB4YRXjs5Ud+o6OfbAplFkwkm8JUmROkHmdcR4j9xg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=icPQBc26; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="icPQBc26"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B4F21F000E9;
	Mon, 31 Aug 2026 13:38:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183499;
	bh=3c84E5YoJsZZcdbvzLgAcIzxtlwAXxC3WoDJGveP5ZI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=icPQBc262zSY/w998fvv30+8I2ERrUHnPmq1DvnYGcvxlZjazlOoBL2D6BY4uOV1n
	 virOpscpMUbqWFrjSk46XVfI0Vj5PUGkzZpas18mQt96aCVAHgfzvp81HOfDEvpHC1
	 yOhE8dcusFFoNNEPgh1IUA9P0OqMmxX3LKc6wMajeJ7y6+xdhPbBwJuNK0XqKokUhh
	 J6z6wMHXLFarojC6NUUsloGR54PhB0HFrdvt3jH7s53+FxJfJ3rQQVsK9tdiOlOc2v
	 9Lw5maq+Mhv0AdyfVrnjFdxyE8NmJQ7Hmvs0Gs+F3PgZFeX8qvAu6KAMopH0OV3XmB
	 IPW8FH5hHDn7g==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Pooja Katiyar <pooja.katiyar@intel.com>,
	Rene Sapiens <rene.sapiens@linux.intel.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>,
	andreas.noever@gmail.com,
	westeri@kernel.org,
	YehezkelShB@gmail.com,
	linux-usb@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.6] thunderbolt: Don't access path config space on Lane 1 adapters in tb_switch_reset_host()
Date: Mon, 31 Aug 2026 09:22:41 -0400
Message-ID: <20260831133314.4125787-133-sashal@kernel.org>
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

From: Pooja Katiyar <pooja.katiyar@intel.com>

[ Upstream commit 95c4379e37a0abea72dfd389cfe2c54452523690 ]

USB4 Lane 1 adapters do not have accessible path config space. Skip the
path config space cleanup in tb_switch_reset_host() for these ports. The
check is for USB4 switches only. Thunderbolt 1-3 Lane 1 adapters stay as
is because we do need to program their path config space.

Co-developed-by: Rene Sapiens <rene.sapiens@linux.intel.com>
Signed-off-by: Rene Sapiens <rene.sapiens@linux.intel.com>
Signed-off-by: Pooja Katiyar <pooja.katiyar@intel.com>
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: `thunderbolt: Don't access path config space
on Lane 1 adapters in tb_switch_reset_host()`

**Local tree:** Linux **6.18.44** (`git describe HEAD` → `v6.18.44`)

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Subject line
**Record:** `[thunderbolt]` `[prevent/avoid]` — Don't access path config
space on Lane 1 adapters in `tb_switch_reset_host()`.

### Step 1.2: Tags
**Record:**
- **Fixes:** — absent (expected for manual review)
- **Reported-by:** — none
- **Tested-by:** — none
- **Reviewed-by:** — none
- **Acked-by:** — none
- **Link:** — none
- **Cc: stable:** — none
- **Signed-off-by:** Rene Sapiens, Pooja Katiyar, Mika Westerberg
  (subsystem maintainer)
- **Co-developed-by:** Rene Sapiens
- Notable: no syzbot/fuzzer report; maintainer sign-off from Mika
  Westerberg

### Step 1.3: Body analysis
**Record:**
- **Bug:** USB4 Lane 1 adapters have no accessible path config space,
  but `tb_switch_reset_host()` tries to clean it up anyway.
- **Symptom:** Config-space reads/writes on Lane 1 fail (negative errno
  from `tb_port_read()` / `tb_path_deactivate_hop()`), causing host
  reset to fail.
- **Root cause:** Regression in the expanded reset path added by
  `ec8162b3f0683` (v6.10); it did not exclude USB4 Lane 1 adapters,
  unlike earlier init-time handling.
- **Version info:** USB4-only; TB1–3 Lane 1 adapters intentionally
  unchanged.

### Step 1.4: Hidden bug fix?
**Record:** Yes — explicit bug fix. It completes the same Lane 1
exclusion already applied during port init (`2ad3e1314cafa`) for the
reset path introduced later.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory
**Record:**
- **Files:** `drivers/thunderbolt/switch.c` (+6 lines)
- **Function:** `tb_switch_reset_host()`
- **Scope:** Single-file, surgical fix

### Step 2.2: Code flow change
**Record:**
- **Before:** After `tb_port_reset()` on a downstream lane (null)
  adapter, always loop over hop IDs and call `tb_path_deactivate_hop()`.
- **After:** For USB4 switches, if `!port->usb4` (Lane 1 adapter — no
  USB4 port capability/device), `continue` and skip path-config cleanup.
- **Path affected:** Host-router reset during `tb_switch_reset()` →
  `tb_switch_reset_host()` for generation > 1 routers.

### Step 2.3: Bug mechanism
**Record:**
- **Category:** Logic / hardware-spec correctness fix (invalid config-
  space access)
- **Mechanism:** `tb_path_deactivate_hop()` → `tb_port_read(port, ...,
  TB_CFG_HOPS, ...)` on Lane 1 adapters where that space is not
  implemented per USB4 spec. `tb_port_reset()` already skips USB4 Lane 1
  (`!port->cap_usb4` → return 0 at line 691), but the subsequent cleanup
  loop did not.

### Step 2.4: Fix quality
**Record:**
- Obviously correct: mirrors `2ad3e1314cafa` (`port->cap_usb4` at init)
  and `tb_port_reset()` logic.
- `port->usb4` is only set on Lane 0 adapters with `cap_usb4`
  (`usb4_switch_add_ports()`).
- TB1–3 unaffected because `tb_switch_is_usb4(sw)` is false.
- Low regression risk: 6 lines, no API/locking changes.

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame
**Record:** Buggy reset loop introduced by **`ec8162b3f0683`** (Sanath
S, 2024-01-13), merged for **v6.10**. Present in this 6.18.44 tree.

### Step 3.2: Fixes: tag
**Record:** N/A — no `Fixes:` tag. Introducing commit verified:
`ec8162b3f0683` ("Make tb_switch_reset() support Thunderbolt 2, 3 and
USB4 routers") is an ancestor of HEAD.

### Step 3.3: Related file history
**Record:**
- **`2ad3e1314cafa`** (2022): "Do not touch lane 1 adapter path config
  space" in `tb_init_port()` — **already in this tree**
- **`ec8162b3f0683`** (2024): Added path-config cleanup to reset —
  **introduced the regression**
- **`95c4379e37a0a`** (2026): This fix — **NOT in this tree** (`git
  merge-base --is-ancestor` confirms)
- Standalone fix, not part of a series

### Step 3.4: Author context
**Record:** Pooja Katiyar / Rene Sapiens (Intel); committed by Mika
Westerberg (Thunderbolt maintainer). Prior related fix by same
maintainer (Mika) in `2ad3e1314cafa`.

### Step 3.5: Dependencies
**Record:** No prerequisites. Uses `tb_switch_is_usb4()` and
`port->usb4`, both present in 6.18.44. `git show 95c4379e37a0a | git
apply --check` passes cleanly.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: Original discussion
**Record:** `b4 dig -c 95c4379e37a0a` — **no match found** on lore
(patch may be too recent or not yet indexed). Manual lore search blocked
by bot protection.

### Step 4.2: Reviewers
**Record:** `b4 dig -w` also failed. Maintainer sign-off from Mika
Westerberg verified from commit metadata.

### Step 4.3: Bug report
**Record:** No external bug report, syzbot link, or user `Reported-by:`
tags.

### Step 4.4: Related patches
**Record:** Direct predecessor fix `2ad3e1314cafa` already in tree; this
commit closes the same gap in the reset path.

### Step 4.5: Stable list history
**Record:** UNVERIFIED — could not search lore stable archive due to
access restrictions.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Key functions
**Record:** `tb_switch_reset_host()`, `tb_path_deactivate_hop()`,
`tb_port_reset()`, `tb_switch_reset()`

### Step 5.2: Callers
**Record:** `tb_switch_reset()` called from `drivers/thunderbolt/tb.c`:
1. Line 3038: USB4 v1 root switch during domain init (`reset &&
   tb_switch_is_usb4 && version == 1`)
2. Line 3127: Non-USB4 root switch on resume (`!tb_switch_is_usb4`)

USB4 bug path is (1). Resume path (2) uses non-USB4 hosts only.

### Step 5.3: Callees
**Record:** `tb_path_deactivate_hop()` →
`tb_port_read()`/`tb_port_write()` on `TB_CFG_HOPS` — fails on
inaccessible Lane 1 space.

### Step 5.4: Reachability
**Record:** Triggered during Thunderbolt/USB4 domain initialization on
USB4 v1 host routers with dual-lane downstream null adapters — real
hardware path, not theoretical.

### Step 5.5: Similar patterns
**Record:**
- `tb_init_port()`: `if (port->cap_usb4)` before reading hops
  (post-`2ad3e1314cafa`)
- `tb_port_reset()`: `port->cap_usb4 ? usb4_port_reset(port) : 0` for
  USB4
- `usb4_switch_add_ports()`: only sets `port->usb4` when
  `port->cap_usb4` (Lane 0)

---

## PHASE 6: CROSS-REFERENCING AGAINST LOCAL TREE

### Step 6.1: Buggy code exists?
**Record:** **Yes.** `drivers/thunderbolt/switch.c` lines 1600–1623 in
6.18.44 lack the Lane 1 skip. Bug present since v6.10 (`ec8162b3f0683`).

### Step 6.2: Backport complications
**Record:** **Clean apply** — `git apply --check` succeeds with zero
conflicts.

### Step 6.3: Related fixes already present?
**Record:** `2ad3e1314cafa` (init-time Lane 1 exclusion) is in tree.
This reset-path gap is **not** yet fixed.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

### Step 7.1: Subsystem criticality
**Record:** `drivers/thunderbolt/` — **IMPORTANT** (laptop/workstation
docking, USB4/Thunderbolt peripherals; not core kernel but widely used
on modern hardware).

### Step 7.2: Subsystem activity
**Record:** Actively maintained; recent stable-worthy fixes in same
subsystem (UAF, buffer bounds, property validation).

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: Who is affected
**Record:** Users with **USB4 v1 host routers** (dual-lane topology)
where `tb_switch_reset()` runs during domain init. Config-dependent on
`CONFIG_THUNDERBOLT`.

### Step 8.2: Trigger conditions
**Record:** Domain init with `reset=true` on USB4 v1 root switch. Not
every boot path (USB4 v2+ uses different reset), but reproducible on
affected hardware when that code path runs.

### Step 8.3: Failure severity
**Record:** `tb_switch_reset_host()` returns error; `tb_switch_reset()`
logs `"failed to reset"`. Early return leaves later ports unprocessed.
Init at line 3038 **ignores** the return value, but partial reset and
dmesg warnings remain. Severity: **MEDIUM-HIGH** (functional
Thunderbolt/USB4 reset failure on real hardware, not a security issue).

### Step 8.4: Risk-benefit
**Record:**
- **Benefit:** MEDIUM-HIGH for USB4 v1 users; fixes a regression in a
  maintainer-owned code path
- **Risk:** VERY LOW — 6 lines, consistent with existing in-tree pattern
- **Ratio:** Strongly favors backport

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence summary

**FOR backport:**
- Real bug: invalid config-space access on USB4 Lane 1 adapters
- Regression from `ec8162b3f0683`, present in 6.18.44
- Prior art in-tree (`2ad3e1314cafa`) establishes the correct behavior
- Small, surgical, applies cleanly
- Maintainer sign-off (Mika Westerberg)
- No new APIs or features

**AGAINST backport:**
- No user/syzbot report (impact inferred from code + spec)
- Caller ignores reset failure return value (mitigates crash risk but
  not functional correctness)
- Affects a subset of USB4 v1 init paths, not all Thunderbolt users

**UNRESOLVED:**
- No lore discussion retrieved
- No explicit stable nomination found

### Step 9.2: Stable rules checklist
1. Obviously correct and tested? **PASS** — matches existing Lane 1
   handling; maintainer-reviewed
2. Fixes a real bug affecting users? **PASS** — invalid hardware access
   on USB4 Lane 1 during reset
3. Important issue? **PASS** — functional reset failure on USB4 hardware
   (MEDIUM-HIGH)
4. Small and contained? **PASS** — 6 lines, one function
5. No new features or APIs? **PASS**
6. Can apply to local tree? **PASS** — verified clean apply

### Step 9.3: Exception categories
**Record:** None (not device ID, quirk, DT, build, or docs). Standard
bug fix.

### Step 9.4: Decision rationale

This is a regression fix for code introduced in v6.10 that is present in
Linux 6.18.44. The Thunderbolt maintainers already fixed the same USB4
Lane 1 path-config-space issue during port initialization
(`2ad3e1314cafa`); this commit applies the same principle to the reset
path added by `ec8162b3f0683`. The fix is minimal, obviously correct,
applies cleanly, and prevents erroneous config-space access that causes
host-router reset to fail on USB4 v1 hardware.

---

## Verification

- [Phase 1] Parsed commit message and tags from user-provided content
  and `git show 95c4379e37a0a`
- [Phase 2] Read current `tb_switch_reset_host()` at lines 1584–1641 in
  6.18.44; analyzed diff
- [Phase 3] `git blame -L 1600,1623`: buggy code from `ec8162b3f0683`
- [Phase 3] `git show ec8162b3f0683`: introduced expanded reset with
  path-config cleanup (v6.10)
- [Phase 3] `git show 2ad3e1314cafa`: prior Lane 1 fix in
  `tb_init_port()` using `port->cap_usb4`
- [Phase 3] `git merge-base --is-ancestor`: `2ad3e` and `ec8162` in
  tree; `95c437` NOT in tree
- [Phase 3] `git tag --contains ec8162b3f0683`: first in v6.10
- [Phase 4] `b4 dig -c/-w/-a 95c4379e37a0a`: no lore match
- [Phase 4] lore.kernel.org fetch: blocked (bot protection) — stable
  discussion UNVERIFIED
- [Phase 5] `grep tb_switch_reset`: callers at `tb.c:3038` and
  `tb.c:3127`
- [Phase 5] Read `tb_port_reset()` at switch.c:688–692: Lane 1 already
  skipped for reset, not for hop cleanup
- [Phase 5] Read `__tb_path_deactivate_hop()` at path.c:392–446:
  accesses `TB_CFG_HOPS`
- [Phase 5] Read `usb4_switch_add_ports()` at usb4.c:1073–1097:
  `port->usb4` only on `cap_usb4` ports
- [Phase 6] `git describe HEAD`: v6.18.44
- [Phase 6] `git show 95c4379e37a0a | git apply --check`: applies
  cleanly
- [Phase 6] Confirmed fix not present in current `switch.c` (no
  `!port->usb4` check in `tb_switch_reset_host`)
- [Phase 8] Read `tb.c:3035–3038`: USB4 v1 reset during domain init;
  return value not checked

**YES****Verdict: YES** — backport to this tree (Linux 6.18.44).

The fix is a 6-line change in `tb_switch_reset_host()` that skips path
config space cleanup on USB4 Lane 1 adapters, which don't expose that
space. Without it, the reset path added in v6.10 (`ec8162b3f0683`) can
fail on USB4 v1 hosts during domain init — the same class of issue
already handled at init time in `2ad3e1314cafa`. The patch applies
cleanly and is not yet in this tree.

 drivers/thunderbolt/switch.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/thunderbolt/switch.c b/drivers/thunderbolt/switch.c
index 0e07904aa73b4..a99d2db220802 100644
--- a/drivers/thunderbolt/switch.c
+++ b/drivers/thunderbolt/switch.c
@@ -1601,6 +1601,12 @@ static int tb_switch_reset_host(struct tb_switch *sw)
 				ret = tb_port_reset(port);
 				if (ret)
 					return ret;
+				/*
+				 * USB4 Lane 1 adapters do not have accessible
+				 * path config space.
+				 */
+				if (tb_switch_is_usb4(sw) && !port->usb4)
+					continue;
 			} else if (tb_port_is_usb3_down(port) ||
 				   tb_port_is_usb3_up(port)) {
 				tb_usb3_port_enable(port, false);
-- 
2.53.0

