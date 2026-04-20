Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C59493C3C1A;
	Mon, 20 Apr 2026 13:17:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776691052; cv=none; b=riW8Xav1SVbJj6PhnQY2Y3LW3/r09PYziAD/I1vAWyMjlMjsn2BLIJZPRZubwBkeJD0KqZDHlaAsmheKm0RQfhc5bcO0EJ35dEjnnu8BubhOBNyd3InOloc0EU3MpbrFN4l0J3uR8OO4aw9BIdowcpyE1vnq6FlCJ+xIz3V7lAM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776691052; c=relaxed/simple;
	bh=8uyOdQ5vyf5e19NAA4Tw4yoMXSJzWRde3/EYk8juQqo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NuNyhrVhUpp/CEPwT8eR8oebVR0WHNwJivCaLwiYekxXf+LktgAauAhvz3ItGU5Ua3uzBDPJogRrH7bXpZhvZVeZ8KgdKy/NtRiMY0ktbQZJPVgrAkEAXqf51uLPNI8fUjoW2hB9LkvcgyrJWbmJRlGHP8OEMZJDk7cJvmsAYA0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qENMbiBZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qENMbiBZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 941D8C2BCB7;
	Mon, 20 Apr 2026 13:17:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776691052;
	bh=8uyOdQ5vyf5e19NAA4Tw4yoMXSJzWRde3/EYk8juQqo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qENMbiBZe+IZ6CycRAlxkOw/tQwgBbVgLv+LF30D/rIMwRZn5uPEbcrsRNEBCZArM
	 Sgc9uOlgKG/+ShM6Dp5mbZh9MsJYOTekPXxXvweIGeaIgyHqkpfBTyubyjZwsfE1Za
	 h+56QEool4YsBEyxydNmewjO1u2lLNXd54zOK/jU6J4BzIOxld7zBOaLE0CS4Eoh9S
	 0BwAIB4LZs/OgP/7ZNxXTGvZWoDd1Fl9SZIBJHkZvpDLLTax+T/6YQazftEE95LagQ
	 EOhwbt5I4jUC3aAwkYfLpx5NPTpJqQi/mF21HqGyeKFnQ/vstu+FFhC5SPvZHpmoDW
	 f5zQDg1HdN/WQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: =?UTF-8?q?G=C3=BCnther=20Noack?= <gnoack@google.com>,
	Lee Jones <lee@kernel.org>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>,
	jikos@kernel.org,
	bentiss@kernel.org,
	linux-input@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0-6.18] HID: logitech-hidpp: Check bounds when deleting force-feedback effects
Date: Mon, 20 Apr 2026 09:08:52 -0400
Message-ID: <20260420131539.986432-66-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420131539.986432-1-sashal@kernel.org>
References: <20260420131539.986432-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 7.0
Content-Transfer-Encoding: 8bit

From: Günther Noack <gnoack@google.com>

[ Upstream commit e606d8329be1e19b7eb3e0c6c72a73cbbb25ae3d ]

Without this bounds check, this might otherwise overwrite index -1.

Triggering this condition requires action both from the USB device and from
userspace, which reduces the scenarios in which it can be exploited.

Cc: Lee Jones <lee@kernel.org>
Signed-off-by: Günther Noack <gnoack@google.com>
Reviewed-by: Lee Jones <lee@kernel.org>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Analysis

### PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1: Parse subject line**
Record: Subsystem `HID: logitech-hidpp:`, action verb `Check` (adding a
missing check). Summary: add missing bounds-check when deleting force-
feedback effects.

**Step 1.2: Parse commit message tags**
Record:
- `Cc: Lee Jones <lee@kernel.org>` (HID area reviewer, not stable)
- `Signed-off-by: Günther Noack <gnoack@google.com>` (author - Google
  security engineer)
- `Reviewed-by: Lee Jones <lee@kernel.org>`
- `Signed-off-by: Jiri Kosina <jkosina@suse.com>` (HID maintainer)
- **NOT** present: `Cc: stable@vger.kernel.org`, `Fixes:`, `Reported-
  by:`, `Link:`
- No syzbot, no user bug report, no sanitizer report

**Step 1.3: Analyze commit body**
Record: Author describes a missing bounds check that "might otherwise
overwrite index -1". Explicitly notes reduced exploitability:
"Triggering this condition requires action both from the USB device and
from userspace, which reduces the scenarios in which it can be
exploited." This is a security-hardening fix with an author-acknowledged
limited attack surface.

**Step 1.4: Hidden bug fix?**
Record: Not hidden at all - clearly a bug fix (missing bounds check
preventing OOB write). The "Check bounds" phrasing is classic stable-
style bug fix language.

### PHASE 2: DIFF ANALYSIS

**Step 2.1: Inventory**
Record: 1 file modified: `drivers/hid/hid-logitech-hidpp.c`. 9 lines
added, 6 removed. Single function modified: `hidpp_ff_work_handler()`,
single switch case: `HIDPP_FF_DESTROY_EFFECT`. Classification: single-
file surgical fix.

**Step 2.2: Code flow change**
Record:
- BEFORE: In `HIDPP_FF_DESTROY_EFFECT`, unconditionally writes
  `data->effect_ids[wd->params[0]-1] = -1` when `effect_id >= 0`. No
  bounds check on `wd->params[0]`.
- AFTER: First reads `slot = wd->params[0]`, then wraps the writes in
  `if (slot > 0 && slot <= data->num_effects)`.
- This is an error-path / invalid-state handling fix, but on a normal
  runtime path.

**Step 2.3: Bug mechanism**
Record: Category (f) Memory safety - bounds check added. Specific
mechanism: `wd->params[0]` is set by `hidpp_ff_find_effect()` (line
2478), which returns 0 when the requested `effect_id` is not present in
`data->effect_ids[]`. For `HIDPP_FF_EFFECTID_AUTOCENTER`, it's set to
`data->slot_autocenter` (initially 0 before autocenter is uploaded).
When `params[0] == 0`, the expression `params[0] - 1` promotes through
int arithmetic to `-1`, causing `data->effect_ids[-1] = -1` - an out-of-
bounds write of a fixed value `-1` at index `-1` of a
`kzalloc`-allocated `int*` array. The analogous
`HIDPP_FF_DOWNLOAD_EFFECT` case (lines 2493-2502) already contains the
exact same defensive check `if (slot > 0 && slot <= data->num_effects)`
- this fix restores symmetry.

**Step 2.4: Fix quality**
Record: Obviously correct - mirrors existing defensive check from the
same function's DOWNLOAD case. Minimal/surgical. Zero regression risk:
the added condition only suppresses an invalid index write; it doesn't
restrict any legitimate behavior. No red flags.

### PHASE 3: GIT HISTORY INVESTIGATION

**Step 3.1: git blame**
Record: The buggy `HIDPP_FF_DESTROY_EFFECT` handler was introduced by
commit `ff21a635dd1a9c` (Edwin Velds, 2016-01-11) "HID: logitech-hidpp:
Force feedback support for the Logitech G920". `git describe --contains`
places it at `v4.6-rc1~107^2^4~1` - first appeared in v4.6. The code has
been stable for ~10 years and is present in every supported stable tree.

**Step 3.2: Follow Fixes: tag**
Record: No `Fixes:` tag in the commit, but git blame identifies the
introducing commit as `ff21a635dd1a9c` (v4.6). That original commit is
in all stable trees that fork from ≥v4.6, which is every currently-
supported stable tree (5.4, 5.10, 5.15, 6.1, 6.6, 6.12, 6.19).

**Step 3.3: Related recent changes**
Record: Recent related work:
- `f7a4c78bfeb32` (Feb 2026) - Lee Jones, "Prevent use-after-free on
  force feedback initialisation failure" - UAF fix in same FF path, no
  `Cc: stable`.
- `1547d41f9f19d` (Jan 2026) - Günther Noack, "Check maxfield in
  hidpp_get_report_length()" - hardening fix, **has** `Cc: stable`.
- This commit is standalone and self-contained; not part of a series (b4
  dig -a shows only v1).

**Step 3.4: Author's other commits**
Record: Günther Noack (Google) has been actively hardening HID drivers
against malicious/fake USB devices: `HID: asus: avoid memory leak`,
`HID: magicmouse: Do not crash on missing msc->input` (+Cc stable),
`HID: prodikeys: Check presence of pm->input_ep82` (+Cc stable), `HID:
logitech-hidpp: Check maxfield in hidpp_get_report_length()` (+Cc
stable). Author is credible, security-focused, and knows stable
conventions.

**Step 3.5: Dependencies**
Record: No dependencies. Standalone, self-contained fix.

### PHASE 4: MAILING LIST / EXTERNAL RESEARCH

**Step 4.1: b4 dig original submission**
Record: `b4 dig -c e606d8329be1e` returned a single-message thread at `h
ttps://lore.kernel.org/all/20260331074052.194064-1-gnoack@google.com/`.
`b4 dig -a` confirms only v1 was posted - no revision history.

**Step 4.2: Recipients**
Record: `b4 dig -w` shows patch was sent to Filipe Laíns, Bastien
Nocera, Jiri Kosina (HID maintainer), Benjamin Tissoires (HID co-
maintainer), Lee Jones, linux-input@vger.kernel.org, linux-
kernel@vger.kernel.org. Appropriate audience.

**Step 4.3: Bug report**
Record: No bug report referenced; no syzbot/KASAN/KMSAN tag. Appears to
be a code-audit / hardening finding by the author.

**Step 4.4: Thread discussion**
Record: Thread saved to `/tmp/hidpp_thread.mbox`. Contents:
- Lee Jones: "LGTM. Reviewed-by: Lee Jones <lee@kernel.org>"
- Jiri Kosina: "Applied, thanks."
- **No reviewer suggested `Cc: stable`**. No NAKs, no concerns raised.

**Step 4.5: Stable-list discussion**
Record: No evidence of prior stable-list discussion for this particular
bug.

### PHASE 5: CODE SEMANTIC ANALYSIS

**Step 5.1: Functions in diff**
Record: Only `hidpp_ff_work_handler()` (switch case
`HIDPP_FF_DESTROY_EFFECT`).

**Step 5.2: Callers / trigger path**
Record: `hidpp_ff_work_handler` is the workqueue callback scheduled by
`hidpp_ff_queue_work()`. The DESTROY path is queued by
`hidpp_ff_erase_effect()` (line 2712), which is assigned to `ff->erase`
(line 2877). `ff->erase` is the standard input-layer callback invoked
when userspace calls `EVIOCRMFF` ioctl on `/dev/input/eventX` of the FF
device. So the buggy code is reachable via a standard userspace ioctl on
any user with access to the device node (typically needs `input` group
membership, or root).

**Step 5.3: Callees**
Record: `hidpp_ff_find_effect()` iterates `data->effect_ids[]` and
returns `i+1` if found, `0` otherwise. The return value `0` directly
causes the `params[0]-1 = -1` OOB when the destroy command proceeds.

**Step 5.4: Reachability**
Record: Buggy path is reachable from userspace: `EVIOCRMFF` ioctl →
`ff->erase` → `hidpp_ff_erase_effect` →
`hidpp_ff_queue_work(HIDPP_FF_DESTROY_EFFECT)` → workqueue →
`hidpp_ff_work_handler`. Needs a Logitech HID++ FF-capable device (e.g.,
G920 wheel) and a userspace condition that erases an effect not present
in the driver's tracking array (race between operations, stale
effect_id, or autocenter destroy before upload).

**Step 5.5: Similar patterns**
Record: The same function already has the correct pattern in
`HIDPP_FF_DOWNLOAD_EFFECT` (lines 2494-2502): `slot =
response.fap.params[0]; if (slot > 0 && slot <= data->num_effects) { ...
}`. This fix brings DESTROY into symmetry with DOWNLOAD.

### PHASE 6: CROSS-REFERENCING AND STABLE TREE ANALYSIS

**Step 6.1: Buggy code in stable trees?**
Record: The buggy code was added in v4.6 (Jan 2016) and is virtually
unchanged since then (blame shows only a whitespace/comment tweak in
2024). Present in every supported stable tree: 5.4.y, 5.10.y, 5.15.y,
6.1.y, 6.6.y, 6.12.y, 6.19.y.

**Step 6.2: Backport complications**
Record: Minimal. Recent churn in the function: Yan Zhen (2024, comment
typo fix) and Lee Jones (2026, adjacent UAF fix in init path - not this
function). The switch statement body targeted by this patch is identical
to what has been in the tree since 2016. Clean apply expected on all
stable branches, modulo trivial context adjustments.

**Step 6.3: Related fixes in stable**
Record: No prior fix for this specific OOB. Some adjacent FF hardening
(UAF fix `f7a4c78bfeb32`) exists in mainline but also lacks Cc: stable.

### PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

**Step 7.1: Subsystem criticality**
Record: `drivers/hid/hid-logitech-hidpp.c` - HID driver for specific
Logitech HID++ devices (G920 wheel, MX mice, etc.). Classification:
PERIPHERAL (hardware-specific driver), but FF is a userspace-reachable
subsystem where games commonly issue erase/upload ioctls, so realistic
number of users on systems with a G920/G923 wheel.

**Step 7.2: Subsystem activity**
Record: Actively developed, with a mix of feature additions (new device
support) and security hardening (see Günther Noack's string of commits).
Mature codebase.

### PHASE 8: IMPACT AND RISK ASSESSMENT

**Step 8.1: Affected users**
Record: Users of Logitech HID++ FF-capable devices (G920/G923 wheels and
similar). Not universal - driver-specific. Requires the device to be
plugged in and a userspace FF client (game, test tool, etc.).

**Step 8.2: Trigger conditions**
Record: Author states "requires action both from the USB device and from
userspace." In practice: userspace invokes `EVIOCRMFF` with an effect_id
that the driver cannot find in `data->effect_ids[]` (e.g., effect never
uploaded, already erased, or device returned unexpected slot) AND the
device responds successfully to the destroy command. Not triggerable by
an unprivileged attacker alone; requires access to the evdev node.

**Step 8.3: Failure mode**
Record: Out-of-bounds write of the fixed value `-1` (`0xFFFFFFFF`) at
index `-1` of the `kzalloc`ed `data->effect_ids[]` array (an `int *`).
This corrupts 4 bytes immediately before the allocation - likely slab
metadata / redzone or an adjacent slab object. Severity: HIGH (memory
corruption), but with limited exploitability because (a) both value and
offset are fixed (not attacker-controlled), (b) requires non-trivial
combination of device + userspace state. Not directly security-critical
as a remote/local privilege escalation primitive, but an unambiguous
memory-safety bug.

**Step 8.4: Benefit/risk**
Record:
- BENEFIT: Fixes a 10-year-old memory-corruption bug in a userspace-
  reachable code path. Medium-low because the trigger is narrow, but
  non-zero - silent slab corruption can manifest as hard-to-debug
  crashes.
- RISK: Extremely low. 9-line purely additive bounds-check that mirrors
  an existing check in the same function. Zero regression potential on
  normal operation.
- Ratio: Low benefit but near-zero risk → favorable for stable.

### PHASE 9: FINAL SYNTHESIS

**Evidence FOR backporting:**
- Clear out-of-bounds memory write (OOB pattern - recognized stable
  category).
- Bug present in all stable trees since v4.6 (2016).
- Fix is 9 lines, in a single function, obviously correct.
- Mirrors existing defensive check in the same function
  (`HIDPP_FF_DOWNLOAD_EFFECT`).
- Reviewed by Lee Jones; applied by HID maintainer Jiri Kosina.
- Author is a security-focused developer doing ongoing HID hardening.
- Clean apply expected on all stable branches.
- Zero regression risk.

**Evidence AGAINST backporting:**
- Author explicitly noted reduced exploitability ("requires action both
  from the USB device and from userspace").
- Author did NOT include `Cc: stable@vger.kernel.org`, despite including
  it on several similar HID hardening commits in the same timeframe.
  This is a deliberate signal from a stable-aware author.
- No `Fixes:` tag, no bug report, no syzbot/KASAN evidence of real-world
  triggers.
- Trigger requires specific hardware (Logitech FF wheel) + specific
  userspace sequence.
- Bug has been present 10 years without reported user impact.

**Stable rules checklist:**
1. Obviously correct and tested? YES - mirrors existing pattern;
   reviewed and applied.
2. Fixes a real bug? YES - OOB write is a real memory-safety bug.
3. Important issue? BORDERLINE - memory corruption but with narrow, non-
   attacker-controlled trigger.
4. Small and contained? YES - 9 insertions, 6 deletions, one function.
5. No new features? YES - pure defensive check.
6. Applies cleanly? YES - expected clean on all active stable branches.

**Exception categories:** Not applicable (not a device-
ID/quirk/DT/build/doc fix).

**Decision rationale:**
This is a borderline case. Technically, it is a legitimate memory-safety
fix for a bug in userspace-reachable code that has been in the tree for
a decade. The patch is small, obviously correct, and zero-risk. OOB
writes are a canonical stable-backport category per the rule set.

The strongest counter-signal is the author's deliberate omission of `Cc:
stable` while including it on peer hardening patches, combined with the
explicit statement about limited exploitability. However, per the task
instructions, the absence of `Cc: stable` is explicitly NOT a negative
signal, and the technical criteria for stable are met.

Weighing the risk (near-zero) against the benefit (fixes a real OOB
write, even if rarely triggered), this is the kind of defensive bounds-
check fix that stable trees routinely accept. Memory corruption with a
hardcoded value at a hardcoded offset is still memory corruption.

### Verification

- [Phase 1] Parsed tags from commit message: found Signed-off-by (Noack,
  Kosina), Reviewed-by (Jones), Cc (Jones). No `Cc: stable`, no
  `Fixes:`, no `Reported-by:`, no `Link:`.
- [Phase 2] Diff analysis: 9 lines added, 6 removed, single file, single
  function (`hidpp_ff_work_handler`), single case
  (`HIDPP_FF_DESTROY_EFFECT`). Confirmed by `git show e606d8329be1e`.
- [Phase 2] Confirmed symmetry with existing check in
  `HIDPP_FF_DOWNLOAD_EFFECT` by reading `drivers/hid/hid-logitech-
  hidpp.c` lines 2493-2511.
- [Phase 3] `git blame -L 2502,2515 drivers/hid/hid-logitech-hidpp.c`:
  buggy code introduced by `ff21a635dd1a9c` (Edwin Velds, 2016-01-11).
- [Phase 3] `git describe --contains ff21a635dd1a9c`:
  `v4.6-rc1~107^2^4~1` (present since v4.6, 2016).
- [Phase 3] `git log --author="gnoack@google.com" --oneline`: confirmed
  author's pattern of HID hardening work, including `Cc: stable`-tagged
  peer commits (`17abd396`, `cee8337e`, `1547d41f`).
- [Phase 4] `b4 dig -c e606d8329be1e`: matched single thread at
  `lore.kernel.org/all/20260331074052.194064-1-gnoack@google.com/`.
- [Phase 4] `b4 dig -a`: only v1 was posted - no revisions.
- [Phase 4] `b4 dig -w`: recipients include HID maintainers (Kosina,
  Tissoires) and linux-input.
- [Phase 4] Read saved mbox `/tmp/hidpp_thread.mbox`: Lee Jones gave
  Reviewed-by, Jiri Kosina said "Applied, thanks." No stable request or
  concerns raised.
- [Phase 5] Confirmed reachability: `hidpp_ff_erase_effect()` wired to
  `ff->erase` (line 2877), reachable via `EVIOCRMFF` ioctl. Confirmed
  `hidpp_ff_find_effect` returns 0 when effect not found (line 2457).
- [Phase 5] Confirmed the buggy `params[0]-1 = -1` path when the
  returned slot is 0.
- [Phase 6] Confirmed `ff21a635dd1a9c` pre-dates all active stable
  branches (branch points are all after v4.6).
- [Phase 7] Subsystem `drivers/hid/` - PERIPHERAL driver for specific
  Logitech HID++ devices with FF.
- [Phase 8] Failure mode: OOB write of fixed value `-1` at fixed offset
  `-1` → slab corruption, severity HIGH but limited exploitability
  primitive.
- UNVERIFIED: Did not run per-branch apply test on each stable tree, but
  the function body is unchanged since 2016 so clean apply is highly
  likely.
- UNVERIFIED: Could not find any user-reported crash or bug report
  pointing to this specific OOB (no bug-tracker links in the commit
  message or on the mailing list).

The fix is small, obviously correct, low-risk, and addresses a real out-
of-bounds write in a userspace-reachable path. Even with the author's
deliberate omission of `Cc: stable`, the technical stable criteria are
met, and bounds-check fixes of this nature are routinely backported.

**YES**

 drivers/hid/hid-logitech-hidpp.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/hid/hid-logitech-hidpp.c b/drivers/hid/hid-logitech-hidpp.c
index d1dea7297712d..5f63f1d2303a0 100644
--- a/drivers/hid/hid-logitech-hidpp.c
+++ b/drivers/hid/hid-logitech-hidpp.c
@@ -2502,12 +2502,15 @@ static void hidpp_ff_work_handler(struct work_struct *w)
 		}
 		break;
 	case HIDPP_FF_DESTROY_EFFECT:
-		if (wd->effect_id >= 0)
-			/* regular effect destroyed */
-			data->effect_ids[wd->params[0]-1] = -1;
-		else if (wd->effect_id >= HIDPP_FF_EFFECTID_AUTOCENTER)
-			/* autocenter spring destroyed */
-			data->slot_autocenter = 0;
+		slot = wd->params[0];
+		if (slot > 0 && slot <= data->num_effects) {
+			if (wd->effect_id >= 0)
+				/* regular effect destroyed */
+				data->effect_ids[slot-1] = -1;
+			else if (wd->effect_id >= HIDPP_FF_EFFECTID_AUTOCENTER)
+				/* autocenter spring destroyed */
+				data->slot_autocenter = 0;
+		}
 		break;
 	case HIDPP_FF_SET_GLOBAL_GAINS:
 		data->gain = (wd->params[0] << 8) + wd->params[1];
-- 
2.53.0

