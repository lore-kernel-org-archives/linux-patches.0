Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B7F247ACF6;
	Mon, 31 Aug 2026 13:35:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183355; cv=none; b=kZmd+1C0uCL8JfDMnJSMblaBJxPbHsRv+jzBcjymMUGwtQbpj7pb4Cv/jU3ec5kP3Bi9/yJn3pthg0QWHw5HNLblxjgJiGWZJBohQH4JScB9bErlJCSP8MKPIOtirktP8P+f2C7XgQnzrOi3fPmtJOYxueYOQMeqBdo51KVtyLo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183355; c=relaxed/simple;
	bh=BJErzeiI74JZ6qJ6Jfpj0pcjLngiaLD5yiI1F16yZok=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Wneyb5snPGTDN+mKyxAK198H8zCuRtu0IAI+yc8Yu1lkl8AF/9bXTqu2x+QwBzYjlOffJFmVREaJgZWenqM7/CNAh6LF7TDSYM2gMp1jBWY7hItnIQZzhn5vSssZqLyoRXIR1et5/Sg+hhZ1NaDrWvRSYENh3ipcd5Kvun6i3kQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=G/0HuDbW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="G/0HuDbW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 320A71F00A3E;
	Mon, 31 Aug 2026 13:35:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183352;
	bh=ANVOKDALVKlsJxxBXK2vwRUxJHGkyc/zQzu+BCjziio=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=G/0HuDbWMfV6ooKSpYJ4zLbADI89yHmqrrN86Pbs62O68hfmaGWwfwXVv7T3gbWOA
	 axcgJQ4RIgKSJ3lOBqorJzDVnvYE3usX7ZTRqQ1mM36aqwpirhrOa/oeBHv9P+3Wwt
	 DIWI0QTVzPZxZgc4c36v6Hjq1Uawmg+iE+Q4w1RVKShD+GkNy47ZBEV/E2/29HTN+q
	 iAp229fBGKHYr6YGZMGSAJWKDdxNJ25zfL4wq05Z031AkrhRUZKRol6A5MMsz7V4ST
	 RHQmwVAB22RzfX/s8kUqIVqP8EuDH8NIDWLXoliQsWksYY/MMT6d8ly1O/jCI3ytRp
	 cYdQI++5wOMvw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Bard Liao <yung-chuan.liao@linux.intel.com>,
	=?UTF-8?q?P=C3=A9ter=20Ujfalusi?= <peter.ujfalusi@linux.intel.com>,
	Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.dev>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	linux-sound@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] soundwire: only handle alert events when the peripheral is attached
Date: Mon, 31 Aug 2026 09:22:05 -0400
Message-ID: <20260831133314.4125787-97-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260831133314.4125787-1-sashal@kernel.org>
References: <20260831133314.4125787-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.48
Content-Transfer-Encoding: 8bit

From: Bard Liao <yung-chuan.liao@linux.intel.com>

[ Upstream commit 38cd651ebce7065a81c7e950d9e2ea1572304605 ]

It doesn't make sense to handle an alert event when the peripheral is
not attached. The slave->status could be SDW_SLAVE_ATTACHED or
SDW_SLAVE_ALERT when it is attached on the bus.

Signed-off-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Reviewed-by: Péter Ujfalusi <peter.ujfalusi@linux.intel.com>
Reviewed-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.dev>
Link: https://patch.msgid.link/20260520025720.1999367-1-yung-chuan.liao@linux.intel.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: `soundwire: only handle alert events when
the peripheral is attached`

**Local tree:** `v6.18.44` (`stable/linux-6.18.y`, detached HEAD)
**Upstream commit:** `38cd651ebce70` (not yet in this tree)
**Verdict target:** Should `38cd651ebce70` be backported to **this**
6.18.y tree?

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Subject line
**Record:** `[soundwire] [handle/prevent] only handle alert events when
the peripheral is attached` — subsystem is SoundWire bus core; action is
defensive filtering of alert handling.

### Step 1.2: Tags
**Record:**
- **Fixes:** — none
- **Reported-by:** — none
- **Tested-by:** — none
- **Reviewed-by:** Péter Ujfalusi, Ranjani Sridharan, Pierre-Louis
  Bossart
- **Acked-by:** — none
- **Link:** https://patch.msgid.link/20260520025720.1999367-1-yung-
  chuan.liao@linux.intel.com
- **Cc: stable:** — none (expected for manual review)
- **Signed-off-by:** Bard Liao (author), Vinod Koul (maintainer); ignore
  pipeline-added SOBs

Notable: three Intel SoundWire reviewers plus subsystem maintainer
Pierre-Louis Bossart.

### Step 1.3: Body analysis
**Record:**
- **Bug:** Alert events are processed even when the peripheral is not
  attached on the bus.
- **Symptom:** Spurious alert handling on unattached slaves; author
  later clarified this is seen rarely during suspend/resume testing
  (mailing list).
- **Root cause (author):** `slave->status` should only be
  `SDW_SLAVE_ATTACHED` or `SDW_SLAVE_ALERT` when the peripheral is
  actually attached; otherwise alert handling is nonsensical.
- **Version info:** none in commit message.

### Step 1.4: Hidden bug fix?
**Record:** Yes. Although the subject does not say "fix", this is a
correctness/race-condition guard. Mailing-list follow-up confirms a real
suspend/resume race where `sdw_handle_slave_alerts()` runs while the
peripheral is still `SDW_SLAVE_UNATTACHED`.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory
**Record:**
- **Files:** `drivers/soundwire/bus.c` (+4 / -0)
- **Function:** `sdw_handle_slave_status()`
- **Scope:** Single-file, surgical fix in one `switch` case.

### Step 2.2: Code flow change
**Record:**
- **Hunk (`SDW_SLAVE_ALERT` case):**
  - **Before:** Any hardware-reported `SDW_SLAVE_ALERT` immediately
    calls `sdw_handle_slave_alerts(slave)`.
  - **After:** Alert handling is skipped (`continue`) unless
    `slave->status` is `SDW_SLAVE_ATTACHED` or `SDW_SLAVE_ALERT`.
  - **Path affected:** IRQ/work-driven bus status processing during
    enumeration, attach/detach, and suspend/resume.

### Step 2.3: Bug mechanism
**Record:**
- **Category:** Logic/correctness + race-condition guard.
- **Mechanism:** Without the check, a spurious or raced
  `SDW_SLAVE_ALERT` status from hardware is acted on while the driver's
  view of the slave is still `SDW_SLAVE_UNATTACHED`.
  `sdw_handle_slave_alerts()` then:
  1. Forces `slave->status` to `SDW_SLAVE_ALERT` via
     `sdw_modify_slave_status()`.
  2. Calls `pm_runtime_get_sync()`.
  3. Performs register I/O (`sdw_read_no_pm`, etc.) on a device not
     attached on the bus.

This is inconsistent with other code in the same file that already skips
unattached slaves.

### Step 2.4: Fix quality
**Record:**
- **Quality:** High. Matches an established pattern already used
  elsewhere in `bus.c` (clock-stop paths at lines 1074–1076, 1129–1130,
  etc.).
- **Regression risk:** Low. Only suppresses alert processing when the
  driver already believes the slave is not attached.
- **Note from review:** Pierre-Louis Bossart said the patch is "probably
  not enough but it's not wrong either" and still gave `Reviewed-by`.

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame
**Record:**
- `SDW_SLAVE_ALERT` handling without guard introduced in `b0a9c37b0178b`
  ("soundwire: Add slave status handling", 2017-12-14).
- That commit is an ancestor of this tree; the buggy pattern has been
  present since early SoundWire bus support.

### Step 3.2: Fixes: tag
**Record:** N/A — no `Fixes:` tag.

### Step 3.3: Related file history
**Record:**
- Related prior guard pattern: `929cfee314d15` "soundwire: bus:
  clock_stop: don't deal with UNATTACHED Slave devices"
- Related unattached-peripheral fix already in this tree:
  `d3896c944338c` "soundwire: don't program SDW_SCP_BUSCLOCK_SCALE on a
  unattached Peripheral" (same author, same class of bug)
- Standalone 1/1 patch; no series dependency.

### Step 3.4: Author context
**Record:** Bard Liao is an active Intel SoundWire contributor with
multiple fixes in this subsystem, including the already-backported
unattached-peripheral guard in `stream.c`.

### Step 3.5: Prerequisites
**Record:** No prerequisite commits required. Patch applies cleanly
(`git apply --check` succeeded). Uses only existing `slave->status` enum
values and control flow.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: Original discussion
**Record:**
- **URL:** https://patch.msgid.link/20260520025720.1999367-1-yung-
  chuan.liao@linux.intel.com
- **Series:** v1 only (standalone patch)
- **Key feedback:**
  - Pierre-Louis Bossart initially questioned the scenario.
  - Bard Liao replied: race during suspend/resume testing;
    `sdw_handle_slave_alerts()` called while peripheral still
    unattached.
  - Bossart: incomplete but not wrong; gave `Reviewed-by`.
  - Vinod Koul applied to mainline.
- **Stable nomination:** none found in thread.

### Step 4.2: Reviewers
**Record:** CC'd linux-sound, vkoul@kernel.org, Pierre-Louis Bossart,
Péter Ujfalusi. Appropriate subsystem coverage.

### Step 4.3: Bug report
**Record:** No syzbot/bugzilla report. Bug evidence is author's
suspend/resume test observation and maintainer acknowledgment of a
plausible race.

### Step 4.4: Related patches
**Record:** Same author recently fixed similar "don't touch unattached
peripheral" issues; those are already in 6.18.y.

### Step 4.5: Stable list
**Record:** No stable-list discussion found for this specific patch.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Key functions
**Record:** `sdw_handle_slave_status()`, `sdw_handle_slave_alerts()`,
`sdw_modify_slave_status()`, `sdw_update_slave_status()`.

### Step 5.2: Callers
**Record:** `sdw_handle_slave_status()` called from:
- `drivers/soundwire/cadence_master.c` (Intel Cadence manager, IRQ path)
- `drivers/soundwire/amd_manager.c` (AMD, workqueue)
- `drivers/soundwire/qcom.c` (Qualcomm)

All are hot paths for bus state changes and interrupts.

### Step 5.3: Callees
**Record:** `sdw_handle_slave_alerts()` does runtime PM, register
reads/writes, optional driver `interrupt_callback`, and status
modification — all inappropriate on an unattached peripheral.

### Step 5.4: Reachability
**Record:** Reachable from hardware interrupts and suspend/resume
status-update work on systems with `CONFIG_SOUNDWIRE`. This is a real
device operation path, not init-only dead code.

### Step 5.5: Similar patterns
**Record:** Identical `slave->status != SDW_SLAVE_ATTACHED &&
slave->status != SDW_SLAVE_ALERT` guard already exists in clock-stop
helpers in the same file. This patch closes a gap in alert handling.

---

## PHASE 6: CROSS-REFERENCE WITH LOCAL TREE

### Step 6.1: Buggy code present?
**Record:** Yes. Current `drivers/soundwire/bus.c` at lines 1960–1966
handles `SDW_SLAVE_ALERT` without any `slave->status` check. Bug present
since 2017 (`b0a9c37b0178b`).

### Step 6.2: Backport complications
**Record:** Clean apply expected and verified. No structural divergence
in the target hunk.

### Step 6.3: Related fixes already present?
**Record:** Related unattached-peripheral guard (`d3896c944338c`) is
already in this tree. This specific alert-path guard is not.

---

## PHASE 7: SUBSYSTEM CONTEXT

### Step 7.1: Subsystem criticality
**Record:** `drivers/soundwire/` — **IMPORTANT** (common on modern
Intel/AMD laptop audio paths; not core-kernel-wide, but affects many
consumer devices).

### Step 7.2: Activity
**Record:** Actively maintained; multiple recent bus.c changes in
6.18.y.

---

## PHASE 8: IMPACT AND RISK

### Step 8.1: Who is affected
**Record:** Users with SoundWire audio (Intel/AMD/Qualcomm platforms),
especially during suspend/resume.

### Step 8.2: Trigger conditions
**Record:** Rare race during suspend/resume where hardware reports
`SDW_SLAVE_ALERT` before driver state reflects attachment. Not
userspace-triggerable directly, but system PM operations are universal
on laptops.

### Step 8.3: Failure mode severity
**Record:**
- Incorrect state transition (`UNATTACHED` → `ALERT`)
- Spurious register I/O and error logging
- Potential suspend/resume/audio instability
- **Severity: MEDIUM** (functional PM/audio issue, not demonstrated
  kernel panic or memory corruption)

### Step 8.4: Risk-benefit
**Record:**
- **Benefit:** Prevents incorrect alert processing during PM
  transitions; aligns with existing defensive patterns; author hit it in
  testing.
- **Risk:** Very low (4 lines, same pattern as existing code).
- **Ratio:** Favorable for stable.

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence summary

**FOR backport:**
- Real bug observed during suspend/resume testing (author)
- Prevents nonsensical I/O and status corruption on unattached
  peripherals
- Tiny, obviously correct, matches existing in-tree pattern
- Applies cleanly to 6.18.44
- Reviewed by subsystem maintainer and Intel SoundWire developers
- Same class of fix already backported to this tree (`d3896c944338c`)

**AGAINST backport:**
- Bug is rare
- Maintainer noted fix may be incomplete for all race scenarios
- No crash/oops/data-corruption report attached
- No explicit stable nomination

**Unresolved:**
- Exact failure symptoms beyond spurious alert handling not fully
  documented (no stack trace in thread)

### Step 9.2: Stable rules checklist
1. Obviously correct and tested? **PASS** — logic is sound;
   suspend/resume testing cited; three Reviewed-by.
2. Fixes a real bug affecting users? **PASS** — suspend/resume race on
   SoundWire hardware.
3. Important issue? **PASS** — PM/audio stability on laptop hardware
   (MEDIUM severity).
4. Small and contained? **PASS** — 4 lines, one file.
5. No new features/APIs? **PASS**.
6. Can apply to local tree? **PASS** — verified clean apply.

### Step 9.3: Exception categories
**Record:** None (not device ID/quirk/DT/build/docs). This is a straight
bug fix.

### Step 9.4: Decision rationale
This commit closes a real gap in SoundWire bus status handling that can
cause spurious alert processing during suspend/resume races. The fix is
minimal, follows an established pattern already present in the same file
and tree, applies cleanly to 6.18.y, and addresses a user-visible
PM/audio issue. While rare and possibly incomplete for all races, it is
clearly correct defensive code with low regression risk — appropriate
for stable.

---

## Verification

- [Phase 1] Parsed subject, tags, body; no Fixes/Reported-by/syzbot
- [Phase 1] Mailing-list follow-up confirms suspend/resume race (`b4 dig
  -m /tmp/sdw_alert.mbox`)
- [Phase 2] Diff: +4 lines in `sdw_handle_slave_status()`
  `SDW_SLAVE_ALERT` case
- [Phase 2] Read `sdw_handle_slave_alerts()`: performs status change,
  PM, register I/O
- [Phase 3] `git blame`: alert case from `b0a9c37b0178b` (2017), present
  in tree
- [Phase 3] `git merge-base --is-ancestor 38cd651ebce70 HEAD` → exit 1
  (commit NOT in tree)
- [Phase 3] `git merge-base --is-ancestor b0a9c37b0178b HEAD` → exit 0
  (buggy code in tree)
- [Phase 3] Related fix `d3896c944338c` already in tree
- [Phase 4] `b4 dig -c 38cd651ebce70`: lore URL found
- [Phase 4] `b4 dig -a`: single v1 patch
- [Phase 4] `b4 dig -w`: vkoul, linux-sound, Bossart CC'd
- [Phase 4] Mbox: Bossart questioned, author cited suspend/resume race,
  Bossart Reviewed-by
- [Phase 5] `grep sdw_handle_slave_status`: callers in cadence_master.c,
  amd_manager.c, qcom.c
- [Phase 5] `grep slave->status != SDW_SLAVE_ATTACHED`: same guard
  pattern at lines 1074+, 1129+, 1200+, 1242+
- [Phase 6] `git describe HEAD` → v6.18.44
- [Phase 6] `make -s kernelversion` → 6.18.44
- [Phase 6] Read current bus.c lines 1960–1966: missing guard confirmed
- [Phase 6] `git show 38cd651ebce70 -p | git apply --check` → clean
  apply
- [Phase 8] Failure mode assessed as MEDIUM PM/audio correctness issue
  from code analysis

**YES**The background searches finished and match what the analysis
already used:

- **Git history search** (`--grep "only handle alert events"`): no hit
  on the current `stable/linux-6.18.y` checkout — the fix is not in this
  tree yet.
- **Master search**: found upstream commit `38cd651ebce70` on `master`
  (merged via `soundwire-7.2-rc1`).

**Verdict for v6.18.44:** **YES** — small suspend/resume race guard,
applies cleanly, same pattern as other unattached-peripheral fixes
already in this tree.

 drivers/soundwire/bus.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/soundwire/bus.c b/drivers/soundwire/bus.c
index 14e1351a3f8ae..8951044c491e2 100644
--- a/drivers/soundwire/bus.c
+++ b/drivers/soundwire/bus.c
@@ -1958,6 +1958,10 @@ int sdw_handle_slave_status(struct sdw_bus *bus,
 			break;
 
 		case SDW_SLAVE_ALERT:
+			if (slave->status != SDW_SLAVE_ATTACHED &&
+			    slave->status != SDW_SLAVE_ALERT)
+				continue;
+
 			ret = sdw_handle_slave_alerts(slave);
 			if (ret < 0)
 				dev_err(&slave->dev,
-- 
2.53.0

