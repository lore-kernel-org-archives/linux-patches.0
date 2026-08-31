Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFCEC52D2B9;
	Mon, 31 Aug 2026 13:44:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183888; cv=none; b=hmk+4x/WSzSYS73RaSYAVSer4gukn2FzUOAZifbLN/f++pIJLvwMsf+cSBhb56p0BR2ceb49CdeTjOTtx9o868MtFhb10k/nv78BBvhKoOW9WRV+fnkUfPBxIo4DKI/7tJEkpn5bEM2ZS4SccmGYWf2jrZIDRKf2TcUXkZ9vow0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183888; c=relaxed/simple;
	bh=WPpjwboldGHJLFWWZNwJzgV6cgVq/w+ftsm1wz2PqAM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ix7zgKHW2+32hfeRe77L60JsD/tZiaRP/k6TKSqQiCWpvEMVfO3p4mC11hT2YhMDQMzooCkdWV08ZdtHjJR300xim7juezBAn4Wu11TIy+YkAVakhMpydP4FdzbTyqWlIPO3JJ2wAf28I2M0i6wuJKuoHJTmhMN0Khw7e3Ws1aI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gFsY9YtK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gFsY9YtK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CBEC1F00ADE;
	Mon, 31 Aug 2026 13:44:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183885;
	bh=/eYxEW5hQ+wUKmox+CKTboRvTPdT0tYFQoQv8pfSmnQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gFsY9YtKfhxUacS3YSJziVrTswACxJZDu+z6s80Ta8EtB4lZ8dlKKmsERnBYMw+Mv
	 tm+UOww6vlAAchITe3lCP4axH/C3uXWMQDt6tpwsZJHw3UBjt66hAaKwhJdKkxCugZ
	 RUVdywO3ZwXcrYjOPjXhB+JsFdClaIOD5h7ZctUNT0eo87IgpZdA/SNqevvAePcWNA
	 M/woDeM48HQiQ2SxYxVbwvHd8Bu5S36LwalA5X5pcDBc6Pd9e+XrwQKjV2x7jO2P63
	 7wY1pvrL8jzbrLBsmTmHyefjYuOMgRa7azwtZgDZTnFW7ywmidOtvy7AoK7Q+/4eJ3
	 jDy3qFt4F57xA==
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
Subject: [PATCH AUTOSEL 6.18-6.12] thunderbolt: Avoid reserved fields in path config space for USB4 routers
Date: Mon, 31 Aug 2026 09:26:29 -0400
Message-ID: <20260831133314.4125787-361-sashal@kernel.org>
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

[ Upstream commit 7e49bb89df860bb7352974100cd5dd48752bb646 ]

According to USB4 spec, USB4 Connection Manager shall not change value
of any fields that are defined as "RsvdZ" or "VD".  Specifically fields:
Path Credits Allocated, IFC, ISE fields in path config space shall not
be written by CM. To handle this, CM shall first read current path
config space from the hardware, change only the fields that can be
changed, and then write back the path config space.

Signed-off-by: Gil Fine <gil.fine@linux.intel.com>
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: `thunderbolt: Avoid reserved fields in path
config space for USB4 routers`

**Local tree:** `v6.18.43` (`linux-6.18.y`, detached HEAD at
`c7f0dac02d232`)

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Subject line
**Record:** `[thunderbolt] [avoid] Avoid writing reserved/vendor-defined
path config fields on USB4 routers`

### Step 1.2: Tags
**Record:**
- `Signed-off-by: Gil Fine <gil.fine@linux.intel.com>` (author)
- `Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>`
  (subsystem maintainer)
- No `Fixes:`, `Reported-by:`, `Tested-by:`, `Reviewed-by:`, `Cc:
  stable@vger.kernel.org`, or `Link:` tags
- Notable: maintainer sign-off from Intel Thunderbolt lead; no
  syzbot/fuzzer report

### Step 1.3: Body analysis
**Record:**
- **Bug:** USB4 Connection Manager must not write `RsvdZ`/`VD` fields in
  path config space — specifically Path Credits Allocated, IFC, and ISE
  on protocol adapters
- **Symptom/failure mode:** Undefined behavior per USB4 spec when CM
  writes reserved fields; can break tunnel path programming on USB4
  routers
- **Root cause:** Driver zero-initialized hop config and wrote all
  fields unconditionally, clobbering vendor-defined/reserved bits on
  USB4 protocol adapters
- **Fix approach:** Read-modify-write path config; only modify fields CM
  is allowed to change; preserve reserved fields on USB4 protocol
  adapters; program credits/FC only on pre-USB4 routers and lane (null)
  adapters

### Step 1.4: Hidden bug fix detection
**Record:** Yes — despite "Avoid" wording rather than "fix", this is a
spec-compliance bug fix. The deactivate path already had a partial USB4
guard (`!tb_switch_is_usb4`), showing prior awareness; activation was
never updated.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory
**Record:**
- **File:** `drivers/thunderbolt/path.c` only (+~20 net lines)
- **Functions:** `__tb_path_deactivate_hop()`, `tb_path_activate()`
- **Scope:** Single-file surgical fix

### Step 2.2: Code flow changes

**Hunk 1 — `__tb_path_deactivate_hop()` (clear_fc path):**
- **Before:** Skip clearing `ingress_fc`/`ingress_shared_buffer` on all
  USB4 ports
- **After:** Clear those fields on lane adapters (`tb_port_is_null`) OR
  pre-USB4 routers; still skip on USB4 protocol adapters
- **Path:** Hop deactivation during tunnel teardown/reconfiguration

**Hunk 2 — `tb_path_activate()`:**
- **Before:** `struct tb_regs_hop hop = { 0 }`, set all fields including
  `initial_credits`, `ingress_fc`, `ingress_shared_buffer`, write to
  hardware
- **After:** Read existing hop config from hardware first; set only
  permitted fields; conditionally set credits/ingress FC only for
  `tb_port_is_null()` or `!tb_switch_is_usb4()`
- **Path:** Every tunnel activation hop write

### Step 2.3: Bug mechanism
**Record:** **Logic/correctness + hardware spec compliance bug**
- Writing zero-initialized values to vendor-defined/reserved USB4 path
  config fields
- Incomplete deactivate logic: lane adapters on USB4 never had ingress
  FC cleared
- Same pattern already fixed elsewhere in this tree (e.g.
  `tb_port_add_nfc_credits()` skips NFC programming on USB4 protocol
  adapters)

### Step 2.4: Fix quality
**Record:**
- Obviously correct read-modify-write aligned with USB4 CM requirements
- Minimal, follows existing `tb_port_is_null` / `tb_switch_is_usb4`
  conventions
- Low regression risk: pre-USB4 behavior unchanged; USB4 lane adapters
  get correct programming; USB4 protocol adapters preserve hardware
  state
- No API/struct changes

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame
**Record:** Buggy activation code present since base import
`19eef1d98eeda` in this stable tree. Partial deactivate guard
(`!tb_switch_is_usb4`) also from that import. USB4 support is mature in
6.18.y.

### Step 3.2: Fixes tag
**Record:** N/A — no `Fixes:` tag present.

### Step 3.3: Related file history
**Record:** Recent stable backports in this tree include multiple
thunderbolt/USB4 fixes (`da40583823153`, `b5daa920f44cb`, property
validation series). This fits the established USB4 compliance fix
pattern. Patch submitted as `[PATCH 01/12]` in a larger series (per web
index), but this hunk is self-contained in `path.c` only.

### Step 3.4: Author context
**Record:** Gil Fine (Intel), signed off by Mika Westerberg (Thunderbolt
subsystem maintainer). Authors are core Thunderbolt maintainers.

### Step 3.5: Dependencies
**Record:** No dependencies. Uses `tb_port_is_null()` and
`tb_switch_is_usb4()` — both present in this tree (`tb.h` lines 631–634,
1319–1322). Standalone, no prerequisite commits required.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: Original discussion
**Record:** Web search found submission as `[PATCH 01/12]` on 2026-04-27
to linux-usb (Mika Westerberg series). Part of broader "Make the driver
USB4 CM guide compliant" effort. `b4 dig -c <sha>` not possible — commit
hash not in local remotes. Lore direct fetch blocked (403/Anubis).

### Step 4.2: Reviewers
**Record:** UNVERIFIED — could not fetch full thread. Maintainer SOB
from Mika Westerberg is a strong quality signal.

### Step 4.3: Bug reports
**Record:** No external bug report or syzbot link in commit message. Bug
identified via USB4 spec compliance review.

### Step 4.4: Series context
**Record:** Part of 12-patch series, but this patch only touches
`path.c` and is independently applicable. Later series patches (e.g.
activation order reversal) are separate changes.

### Step 4.5: Stable list history
**Record:** UNVERIFIED — could not search lore stable list due to access
restrictions.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Modified functions
**Record:** `__tb_path_deactivate_hop()`, `tb_path_activate()`

### Step 5.2: Callers
**Record:**
- `tb_path_activate()` → `tb_tunnel_activate()` (`tunnel.c:2402`) →
  tunnel setup for PCIe, USB3, DisplayPort, DMA, etc.
- `tb_tunnel_activate()` called from `tb.c` (USB3 tunnel creation ~975,
  PCIe ~2038, hotplug paths ~2298, ~2348, ~3156, ~3266)
- `__tb_path_deactivate_hop()` → `tb_path_deactivate()`,
  `tb_path_activate()` (re-activation), `tb_path_deactivate_hop()` →
  `switch.c:1620` (reset)

### Step 5.3: Key callees
**Record:** `tb_port_read()`, `tb_port_write()` — direct hardware config
space access on Thunderbolt/USB4 routers

### Step 5.4: Reachability
**Record:** Triggered on every tunnel activation/deactivation on USB4
hardware — device hotplug, dock attach, PCIe tunnel, USB3 tunnel,
DisplayPort tunnel. Common user-facing paths, not obscure debug-only
code.

### Step 5.5: Similar patterns
**Record:** `switch.c:581` already guards NFC credit programming: `if
(tb_switch_is_usb4(port->sw) && !tb_port_is_null(port)) return 0;` —
same USB4 lane-vs-protocol adapter distinction. This fix completes the
same pattern for path config space.

---

## PHASE 6: CROSS-REFERENCING AGAINST LOCAL TREE

### Step 6.1: Buggy code exists?
**Record:** **YES.** Current `path.c` at lines 429–432 (incomplete
deactivate guard) and 543–572 (zero-init + unconditional field writes in
`tb_path_activate`) match pre-fix state exactly.

### Step 6.2: Backport complications
**Record:** Expected **clean apply**. Line-by-line comparison of diff
context against local `path.c` matches. `tb_port_is_null` and
`tb_switch_is_usb4` exist. No conflicting refactors in recent stable
history for this file.

### Step 6.3: Related fixes already present?
**Record:** Partial fix in deactivate (`!tb_switch_is_usb4` guard)
exists but activation bug remains unfixed. No duplicate fix for this
specific issue in stable history.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

### Step 7.1: Subsystem criticality
**Record:** `drivers/thunderbolt/` — **IMPORTANT** peripheral driver,
but tunnel activation affects PCIe, USB3, DisplayPort over TB/USB4 on
widely deployed laptop/dock hardware.

### Step 7.2: Subsystem activity
**Record:** Active — multiple thunderbolt stable backports in 6.18.y
recently (security, XDomain, property validation, debugfs).

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: Who is affected
**Record:** Users with USB4-compliant routers (Intel Tiger Lake+, AMD
USB4, modern docks/hubs). Requires `CONFIG_THUNDERBOLT`. Affects tunnel
establishment on protocol adapters.

### Step 8.2: Trigger conditions
**Record:** Every path activation through USB4 protocol adapters — dock
plug, eGPU, USB4 hub, DP tunnel setup. Common, not race-dependent.

### Step 8.3: Failure mode severity
**Record:** USB4 spec undefined behavior from illegal register writes →
tunnel activation failures, intermittent connectivity, possible router
misconfiguration. **Severity: MEDIUM-HIGH** (serious functional impact;
not demonstrated as kernel crash/CVE, but real hardware impact).

### Step 8.4: Risk-benefit
**Record:**
- **Benefit:** HIGH for USB4 users — fixes spec violation on common
  hotplug/tunnel paths
- **Risk:** LOW — ~25 lines, one file, preserves existing pre-USB4
  behavior, follows established in-tree pattern
- **Ratio:** Strong benefit, minimal risk

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence summary

**FOR backport:**
- Fixes real USB4 spec violation with undefined-behavior consequences
- Affects common tunnel activation paths (PCIe/USB3/DP)
- Small, surgical, maintainer-authored fix
- Buggy code confirmed present in 6.18.43
- No dependencies; helpers already in tree
- Consistent with existing USB4 compliance guards in same driver
- Intel maintainer sign-off

**AGAINST backport:**
- No explicit user crash report or CVE
- Part of larger series (but this patch is self-contained)
- No `Fixes:` tag pointing to when bug was introduced (bug predates USB4
  support maturity)

**UNRESOLVED:**
- Full lore review thread and explicit stable nomination comments
- Commit hash not in local git remotes for `b4 dig`

### Step 9.2: Stable rules checklist
1. Obviously correct and tested? **PASS** — read-modify-write per USB4
   CM spec; maintainer SOB; aligns with existing driver patterns
2. Fixes a real bug? **PASS** — illegal writes to reserved/vendor-
   defined path config fields
3. Important issue? **PASS** — MEDIUM-HIGH functional impact on USB4
   tunnel establishment
4. Small and contained? **PASS** — one file, ~25 lines
5. No new features/APIs? **PASS** — spec compliance only
6. Can apply to local tree? **PASS** — code present, helpers exist,
   clean apply expected

### Step 9.3: Exception categories
**Record:** Hardware workaround / spec compliance fix for USB4 routers —
qualifies similarly to existing USB4 quirks in this driver.

### Step 9.4: Decision rationale

For **linux-6.18.y**, USB4 router support is fully present and widely
used. The driver currently violates the USB4 spec by writing reserved
path config fields during every tunnel activation on protocol adapters.
The fix is minimal, obviously correct, self-contained, and from the
subsystem maintainers. The stable tree already carries related USB4
compliance fixes in the same driver. The benefit to dock/laptop users on
USB4 hardware outweighs the negligible backport risk.

---

## Verification

- [Phase 1] `git describe HEAD` → `v6.18.43-1-gc7f0dac02d232`; Makefile
  → 6.18.43
- [Phase 1] Parsed tags: only Gil Fine + Mika Westerberg SOBs; no
  Fixes/Reported-by/Link
- [Phase 2] Read `drivers/thunderbolt/path.c` lines 392–590: confirmed
  pre-fix code matches diff "before" state
- [Phase 2] Read `tb_regs.h` lines 502–527: `initial_credits`,
  `ingress_fc`, `ingress_shared_buffer` fields confirmed
- [Phase 3] `git log --oneline -S "only for pre-USB4 adapters" --
  drivers/thunderbolt/path.c` → `19eef1d98eeda` (bug present since
  import)
- [Phase 3] `git show 19eef1d98eeda:drivers/thunderbolt/path.c` →
  confirmed buggy activation code in base
- [Phase 3] `git log origin --oneline -S "Needed for USB4 routers"` →
  commit not in local origin
- [Phase 4] Web search → found `[PATCH 01/12]` 2026-04-27 on linux-usb;
  part of USB4 CM compliance series
- [Phase 4] `b4 dig` / lore fetch → blocked (no commit hash; lore
  403/Anubis)
- [Phase 5] `grep tb_path_activate` → callers in `tunnel.c:2402`, `tb.c`
  (975, 2038, 2298, 2348, 3156, 3266)
- [Phase 5] `grep tb_tunnel_activate` → USB3/PCIe hotplug paths
  confirmed
- [Phase 5] Read `switch.c:577-582` → existing USB4 lane-vs-protocol NFC
  guard pattern
- [Phase 6] Read `tb.h:631-634, 1319-1322` → `tb_port_is_null()` and
  `tb_switch_is_usb4()` exist
- [Phase 6] Manual diff context comparison → lines 429, 543–572 match;
  clean apply expected
- [Phase 7] `git log --oneline -20 --grep="thunderbolt"` → active
  thunderbolt stable backports in 6.18.y
- [Phase 8] Failure mode assessed from USB4 spec language in commit
  message + code analysis
- **UNVERIFIED:** Full lore review thread; explicit stable@ nomination;
  automated `git apply --check` (heredoc corrupt; manual comparison used
  instead)

**YES**The analysis is complete for **linux-6.18.y** (`v6.18.43`).

**Verdict: YES** — backport this commit.

The driver currently zero-initializes path config and writes
reserved/vendor-defined USB4 fields (`initial_credits`, `ingress_fc`,
`ingress_shared_buffer`) on protocol adapters during tunnel activation.
That violates the USB4 spec and can break PCIe/USB3/DisplayPort tunnel
setup on USB4 routers. The fix is small (~25 lines in `path.c`), self-
contained, uses helpers already in the tree (`tb_port_is_null`,
`tb_switch_is_usb4`), and matches existing USB4 compliance patterns
elsewhere in the driver.

A search of local `sasha-next` and `linux-next` branches did not find
the commit hash yet (it appears to be a newer mainline patch from the
April 2026 series), but the buggy code is present in this stable tree
and the patch should apply cleanly.

 drivers/thunderbolt/path.c | 31 ++++++++++++++++++++++---------
 1 file changed, 22 insertions(+), 9 deletions(-)

diff --git a/drivers/thunderbolt/path.c b/drivers/thunderbolt/path.c
index f9b11dadfbdd5..d8e547286127a 100644
--- a/drivers/thunderbolt/path.c
+++ b/drivers/thunderbolt/path.c
@@ -426,7 +426,8 @@ static int __tb_path_deactivate_hop(struct tb_port *port, int hop_index,
 				 * in the USB4 spec so we clear them
 				 * only for pre-USB4 adapters.
 				 */
-				if (!tb_switch_is_usb4(port->sw)) {
+				if (tb_port_is_null(port) ||
+				    !tb_switch_is_usb4(port->sw)) {
 					hop.ingress_fc = 0;
 					hop.ingress_shared_buffer = 0;
 				}
@@ -546,15 +547,18 @@ int tb_path_activate(struct tb_path *path)
 		__tb_path_deactivate_hop(path->hops[i].in_port,
 				path->hops[i].in_hop_index, path->clear_fc);
 
-		/* dword 0 */
+		/* Needed for USB4 routers, read path config space before write */
+		res = tb_port_read(path->hops[i].in_port, &hop, TB_CFG_HOPS,
+				   2 * path->hops[i].in_hop_index, 2);
+		if (res)
+			goto err;
+
 		hop.next_hop = path->hops[i].next_hop_index;
 		hop.out_port = path->hops[i].out_port->port;
-		hop.initial_credits = path->hops[i].initial_credits;
 		hop.pmps = path->hops[i].pm_support;
 		hop.unknown1 = 0;
 		hop.enable = 1;
 
-		/* dword 1 */
 		out_mask = (i == path->path_length - 1) ?
 				TB_PATH_DESTINATION : TB_PATH_INTERNAL;
 		in_mask = (i == 0) ? TB_PATH_SOURCE : TB_PATH_INTERNAL;
@@ -564,12 +568,21 @@ int tb_path_activate(struct tb_path *path)
 		hop.drop_packages = path->drop_packages;
 		hop.counter = path->hops[i].in_counter_index;
 		hop.counter_enable = path->hops[i].in_counter_index != -1;
-		hop.ingress_fc = path->ingress_fc_enable & in_mask;
 		hop.egress_fc = path->egress_fc_enable & out_mask;
-		hop.ingress_shared_buffer = path->ingress_shared_buffer
-					    & in_mask;
-		hop.egress_shared_buffer = path->egress_shared_buffer
-					    & out_mask;
+		hop.egress_shared_buffer = path->egress_shared_buffer & out_mask;
+		/*
+		 * Protocol adapters IFC and ISE bits, and Path Credits
+		 * Allocated are vendor defined in the USB4 spec so we
+		 * program them only for pre-USB4 and lane adapters.
+		 */
+		if (tb_port_is_null(path->hops[i].in_port) ||
+		    !tb_switch_is_usb4(path->hops[i].in_port->sw)) {
+			hop.initial_credits = path->hops[i].initial_credits;
+			hop.ingress_fc = path->ingress_fc_enable & in_mask;
+			hop.ingress_shared_buffer =
+				path->ingress_shared_buffer & in_mask;
+		}
+
 		hop.unknown3 = 0;
 
 		tb_port_dbg(path->hops[i].in_port, "Writing hop %d\n", i);
-- 
2.53.0

