Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 598186167DA;
	Mon, 19 Oct 2026 14:04:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418652; cv=none; b=S5PK3Ew98I5/gIfnzsC3M5C7qeR4S82WLfr4Z7LNFWLEzuXpZlyQ9wf8MsiebEB1K19Ht03ouXCdvurtVjMw0PrE369D+2cbYXoerkfv4GhhzwL6FqkNABfyFiYCQW2f5YmWEytWLns/FNg35LZM/zaiqIuYGowrl4TN16+BM9c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418652; c=relaxed/simple;
	bh=wDD6ykyvNysEJCQGddu/mV4rkV7sWkPwIGFxEL1jFy8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MpjlEQC9vli5V0S5bLjjnYjrvSFh2ECT0KqcmY2Ao31n5qCxAlVUNfoWnqPrMWgH91geonl7+vt6lLkPcbFTIea6jEA96vpZQxGJO+qRMyDnCavP107qOP3f2A/P1sUSV082EVkWfyWpEtjsTUVdXAGM0JObvyTkfGSYFnWtdSo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=H3qVumw8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="H3qVumw8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 689831F000C4;
	Mon, 19 Oct 2026 14:04:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418649;
	bh=eiCuBGcaIe6xncLEZgKUCnZLcZudMZJRvrxN0BDTpbI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=H3qVumw8ytV3PbOfXFiAiZGnE2nx8UJ2am6Fn6LTIpfIF+F1+7yk2JyPeBGPo9/j1
	 W4B7daEevc2YA9ipUdTQtuVQJ82lncknkqfbBB4m0xGMQzu5emyXyNffbc3TzVW7Ud
	 z2Hen9OgxuAY4BQcDMe7TXsZcRhTxWlQM4XsVVVVMumKGW3AgXTKitddYPL/dZ+v/j
	 7UwBA1z2Y1YUmLxdpaVqQjWhahm6dJAEyBpws8SNnTigxdbXW9EZP9HH5lz1XKiDe9
	 d0AN/DOuAZKskWec4g3/PBUW7hSg3nSfoIC5VCERKcvJIjKAO3BMA4e5zaxeN0z+06
	 Uv7/bQ2NnVvng==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Jingyi Wang <jingyi.wang@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	mathieu.poirier@linaro.org,
	linux-remoteproc@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.15] remoteproc: core: cancel crash_handler work in rproc_add() error path
Date: Mon, 19 Oct 2026 09:51:30 -0400
Message-ID: <20261019135441.1420968-399-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261019135441.1420968-1-sashal@kernel.org>
References: <20261019135441.1420968-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.57
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jingyi Wang <jingyi.wang@oss.qualcomm.com>

[ Upstream commit 0ec167625b4fea30b26da33c188e853ff25d5583 ]

Ensure crash_handler work is cancelled before tearing down rproc resources
to avoid accessing freed memory.

Signed-off-by: Jingyi Wang <jingyi.wang@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260623-rproc-attach-issue-v3-3-8e24310707ce@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The local tree is **7.3-rc4**. This is a one-line UAF guard:
`rproc_add()` must cancel `crash_handler` before it tears the device
down, and that error path exists here.

===============================================================
PHASE 1: COMMIT MESSAGE FORENSICS
===============================================================

**Step 1.1: PARSE THE SUBJECT LINE**
Record: **[remoteproc/core] [cancel] cancel `crash_handler` work in
`rproc_add()` error path** — “cancel” here is a safety action (flush
pending work before teardown), not a feature.

**Step 1.2: PARSE ALL COMMIT MESSAGE TAGS**
Record:
- **Link:** `https://lore.kernel.org/r/20260623-rproc-attach-
  issue-v3-3-8e24310707ce@oss.qualcomm.com` (patch 3/3 of v3 series)
- **Signed-off-by:** Jingyi Wang (author); Bjorn Andersson (remoteproc
  maintainer)
- No `Fixes:`, `Reported-by:`, `Tested-by:`, `Reviewed-by:`, `Acked-
  by:`, or `Cc: stable` (absence is expected for this review)
- Ignore any pipeline SOBs

Notable: this is **v3 3/3**, titled on-list as “improve robustness for
rproc_attach fail cases”.

**Step 1.3: ANALYZE THE COMMIT BODY TEXT**
Record:
- **Bug:** `crash_handler` can still be pending/running when
  `rproc_add()` unwinds.
- **Symptom:** use of rproc state after debugfs/`device_del`/char-dev
  teardown, and after the caller drops the last ref
  (`rproc_type_release()` does `kfree(rproc)` with no work cancel).
- **Failure mode:** use-after-free / use of a half-destroyed rproc from
  `rproc_crash_handler_work()`.
- **Version info in the message:** none.
- **Root cause (author):** teardown without
  `cancel_work_sync(&rproc->crash_handler)`.

Cover letter (verified in mbox): *“Failure in rproc_attach() path can
cause issues like NULL pointer dereference when doing recovery and
rproc_add() fail.”*

**Step 1.4: DETECT HIDDEN BUG FIXES**
Record: Not disguised. One-line UAF/lifetime fix. “Ensure … cancelled
before tearing down” is explicit.

===============================================================
PHASE 2: DIFF ANALYSIS - LINE BY LINE
===============================================================

**Step 2.1: INVENTORY THE CHANGES**
Record:
- **File:** `drivers/remoteproc/remoteproc_core.c` (+1, −0)
- **Function:** `rproc_add()`
- **Scope:** single-file, one-line surgical fix

**Step 2.2: UNDERSTAND THE CODE FLOW CHANGE**
Record: On `rproc_trigger_auto_boot()` failure, `rproc_add()` jumps to
`rproc_remove_dev`, which used to `rproc_delete_debug_dir()` →
`device_del()` → `rproc_char_device_remove()` and return. After the
change, it **`cancel_work_sync(&rproc->crash_handler)` first**, then the
same teardown. Success path is unchanged.

**Step 2.3: IDENTIFY THE BUG MECHANISM**
Record:
- **Category:** use-after-free / lifetime (work vs teardown); also a
  resource-lifetime race.
- **Mechanism:** `INIT_WORK(&rproc->crash_handler, …)` happens in
  `rproc_alloc()`. `rproc_report_crash()` can
  `queue_work(rproc_recovery_wq, &rproc->crash_handler)` from IRQ/atomic
  context. `rproc_crash_handler_work()` then uses `rproc` (`dev`,
  `lock`, `state`, recovery). The `rproc_add()` error path unregisters
  the device but never waited for that work; callers then
  `rproc_free()`/`put_device()`, and `rproc_type_release()` kfree’s
  `rproc` with no cancel. Sibling patch 2’s stack shows
  `rproc_crash_handler_work` running because `rproc_report_crash()`
  fired during attach — so the work is not hypothetical.

**Step 2.4: ASSESS THE FIX QUALITY**
Record: Obviously correct: `cancel_work_sync` is the standard “don’t
free while work may run” pattern. Later `rproc_del()` uses the same
cancel (plus `deleting` + `pm_relax`). Regression risk is very low:
cancel on idle work is a no-op. Minor incompleteness: this path does not
`pm_relax()` if cancel returns true (unlike `rproc_del()`). That is a
wakeup-source leak only if the work was actually queued, which is still
far better than UAF. No API/data-structure change.

===============================================================
PHASE 3: GIT HISTORY INVESTIGATION
===============================================================

**Step 3.1: BLAME THE CHANGED LINES**
Record:
- `rproc_remove_dev` teardown: **7dbdb8bd7c028** (“Cleanup device in
  case of failure”, 2021-06-14, in **v5.14-rc1**).
- Auto-boot error `goto`: same era; auto_boot itself from
  **7a20c64ddb3dee** (2017).
- `crash_handler`: **8afd519c3470f** (2012).
- DETACHED sync attach in `rproc_trigger_auto_boot()`: **e3d2193959824**
  (2020-07-14).
Buggy combination (error-path teardown without cancelling crash work)
has been present for years.

**Step 3.2: FOLLOW THE FIXES: TAG**
Record: No `Fixes:` tag. Not applicable beyond that.

**Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES**
Record: Same series, same author/date, landed together in v7.3-rc1:
1. **026a3fada4326** (v3-1): async attach via `attach_work` so attach
   failure no longer fails `rproc_add()`.
2. **f44ae8ce156a3** (v3-2): `subdevs_started` — real NULL deref in
   glink stop during crash recovery (stack trace).
3. **0ec167625b4fe** (this, v3-3): cancel crash work on `rproc_add()`
   error.

Later related: **74ee3b2f57674** “Prevent crash handling to race with
`rproc_del()`” (Fixes: 8afd519c3470) — same class of bug on **remove**,
not a substitute for this add-error-path cancel.

This line does **not** need patches 1–2 to compile or be correct. Patch
1 **shrinks** the window on this tree (DETACHED attach no longer takes
`rproc_remove_dev`).

**Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS**
Record: Jingyi Wang is a Qualcomm remoteproc contributor (this series +
PAS/attach work). Maintainer **Bjorn Andersson** applied the series. Co-
maintainer **Mathieu Poirier** was on the original To/Cc.

**Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS**
Record: None for this hunk. It only needs `rproc->crash_handler` and the
`rproc_remove_dev` label, both present. Standalone 1-line apply.

===============================================================
PHASE 4: MAILING LIST AND EXTERNAL RESEARCH
===============================================================

**Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION**
Record:
- **b4 dig -c 0ec167625b4fe:** `https://patch.msgid.link/20260623-rproc-
  attach-issue-v3-3-8e24310707ce@oss.qualcomm.com`
- **b4 dig -a:** v2 (2026-05-19) and v3 (2026-06-23). Patch 3 was
  **added in v2** (“Add change to cancel crash_handler work”). v3 kept
  it; v3 review comments were about patch 2’s flag placement, not this
  line.
- Applied version is latest (v3 3/3).
- Bjorn: “Applied, thanks!” — no NAK, no stable discussion in the
  thread.
- No reviewer `Cc: stable` on this specific patch.

**Step 4.2: CHECK WHO REVIEWED THE PATCH**
Record: **b4 dig -w** recipients: Jingyi Wang; Bjorn Andersson; Mathieu
Poirier; Qualcomm colleagues; `linux-remoteproc@vger.kernel.org`. Right
maintainers were on the patch. No extra Reviewed-by on 3/3; maintainer
still merged it.

**Step 4.3: SEARCH FOR THE BUG REPORT**
Record: No syzbot/bugzilla for *this* line. The series cover letter and
patch 2 document a real Qualcomm attach-crash NULL deref with a full
stack through `rproc_crash_handler_work`. That is the same window this
cancel is meant to close if `rproc_add()` then fails.

**Step 4.4: CHECK FOR RELATED PATCHES AND SERIES**
Record: 3-patch robustness series. Patch 1 is a behavior change (async
attach). Patch 2 is the NULL-deref fix. Patch 3 is independent UAF
hygiene on the add error path. Not a “2/3 without 1/3 won’t build”
situation.

**Step 4.5: CHECK STABLE MAILING LIST HISTORY**
Record: **UNVERIFIED** — `lore.kernel.org/stable/` fetch returned HTTP
403. No local evidence this was rejected for stable.

===============================================================
PHASE 5: CODE SEMANTIC ANALYSIS
===============================================================

**Step 5.1: IDENTIFY KEY FUNCTIONS IN THE DIFF**
Record: `rproc_add()` only. Related: `rproc_crash_handler_work()`,
`rproc_report_crash()`, `rproc_trigger_auto_boot()`, `rproc_del()`,
`rproc_type_release()`.

**Step 5.2: TRACE CALLERS**
Record: `rproc_add()` / `devm_rproc_add()` are the register path for
every remoteproc driver (qcom PAS/ADSP/MSS/WCSS/WCNSS, imx, omap, stm32,
mtk, pru, k3, etc.). Called from probe. `rproc_report_crash()` is
exported and used from IRQs (e.g. `qcom_q6v5` wdog/fatal, requested in
`qcom_q6v5_init()` **before** `rproc_add()`).

**Step 5.3: TRACE CALLEES**
Record: Error path: `cancel_work_sync` → `rproc_delete_debug_dir` →
`device_del` → `rproc_char_device_remove`. Crash work: mutex, state,
`rproc_trigger_recovery()`, `pm_relax()`.

**Step 5.4: FOLLOW THE CALL CHAIN**
Record: Reachable from driver probe (`auto_boot`). On this 7.3 tree,
after 026a3fada4326, DETACHED attach is async and **does not** fail
`rproc_add()`. The remaining `goto rproc_remove_dev` is
`request_firmware_nowait()` failure. Crash work is still initialized;
IRQs may already be requested. Userspace does not trigger this directly
except via device probe/firmware-request failure. Severity if it hits:
UAF in workqueue context.

**Step 5.5: SEARCH FOR SIMILAR PATTERNS**
Record: Same cancel later in `rproc_del()` (74ee3b2f57674).
`rproc_type_release()` still does not cancel works — so add-error-path
cancel (and del cancel) are the actual guards.

===============================================================
PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE
===============================================================

**Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?**
Record: Yes. Tree is **v7.3-rc4-27-gf0100363d8c37** / **7.3.0-rc4**.
`rproc_add()` error path and `crash_handler` are here. Candidate
**0ec167625b4fe** is in **v7.3-rc1** (`git describe --contains` →
`v7.3-rc1~46^2~27`). Evaluating merit as if selecting it for this tree:
the code it touches is present; the bug was **not** introduced after 7.3
branched.

**Step 6.2: CHECK FOR BACKPORT COMPLICATIONS**
Record: Clean apply. One line at a stable label. No structural conflict
in this file’s `rproc_add()`.

**Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE**
Record: 74ee3b2f57674 fixes `rproc_del()`, not this add-error path. No
earlier equivalent cancel on `rproc_remove_dev` (git log -S shows this
commit as the first).

===============================================================
PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT
===============================================================

**Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY**
Record: **drivers/remoteproc** — **IMPORTANT** on Qualcomm/embedded
(modems, ADSP, CDSP, Wi-Fi firmware). Not CORE mm/VFS, but crash during
probe/recovery is a host kernel oops, not “DSP-only.”

**Step 7.2: ASSESS SUBSYSTEM ACTIVITY**
Record: Active (qcom PAS, crash/remove races, new platforms). Mature
core with long-lived `rproc_add`/`crash_handler`.

===============================================================
PHASE 8: IMPACT AND RISK ASSESSMENT
===============================================================

**Step 8.1: DETERMINE WHO IS AFFECTED**
Record: **driver-specific / config-specific** (`CONFIG_REMOTEPROC`,
especially `auto_boot` and attach/early-boot Qualcomm PAS). Not
universal desktop, but common on phones and embedded SoCs.

**Step 8.2: DETERMINE THE TRIGGER CONDITIONS**
Record: `auto_boot` + `rproc_trigger_auto_boot()` failure, with
`crash_handler` already queued. On **this** tree, patch 1 removed the
attach-fail → `rproc_add()`-fail path, so the remaining trigger is
firmware-nowait failure (and any crash queued around probe).
Unprivileged userspace does not have a clean repro; probe/firmware error
+ IRQ crash is the window. Sibling patch proves crash work **does** run
during attach.

**Step 8.3: DETERMINE THE FAILURE MODE SEVERITY**
Record: **UAF / oops in workqueue** if work runs after teardown/free.
**Severity: HIGH** (crash; possible memory corruption). Not a guaranteed
panic on every boot.

**Step 8.4: CALCULATE RISK-BENEFIT RATIO**
Record:
- **Benefit:** medium–high if the race hits (UAF); on this tree the
  attach-fail window is smaller, so benefit is more “correct teardown”
  than “every Qualcomm boot.”
- **Risk:** very low (1 line, idle cancel is harmless).
- **Ratio:** favorable. Missing a 1-line UAF cancel is worse than
  applying it.

===============================================================
PHASE 9: FINAL SYNTHESIS
===============================================================

**Step 9.1: COMPILE THE EVIDENCE**

FOR:
- Explicit UAF/lifetime fix; author states freed-memory access.
- 1 line, obviously correct, same primitive later required in
  `rproc_del()`.
- `rproc_type_release()` kfree’s without cancelling work — error-path
  cancel is necessary.
- Series documents real attach-time crash handling (NULL deref stack in
  2/3).
- Maintainer merged; no NAKs.
- Code and error path exist in this 7.3 tree; applies cleanly; no new
  API.
- Independently correct without the rest of the series.

AGAINST:
- After 026a3fada4326 (already in this tree), DETACHED attach no longer
  fails `rproc_add()`, so the original attach-fail UAF is largely gone
  here; remaining trigger is `request_firmware_nowait()` failure.
- No `Fixes:`/`Reported-by`/syzbot for this exact line; commit body is
  one sentence.
- Incomplete vs `rproc_del()` (no `pm_relax` / `deleting`).
- Patch 3/3 of a robustness series, not a stand-alone user report.

UNRESOLVED:
- Stable list discussion (lore 403).
- Could not prove a live crash IRQ on the firmware-nowait-only error
  path on this tree.

**Step 9.2: APPLY THE STABLE RULES CHECKLIST**
1. Obviously correct and tested? **PASS** — 1-line `cancel_work_sync`;
   merged by maintainer after v2/v3.
2. Fixes a real bug that affects users? **PASS** — UAF if crash work
   outlives `rproc_add()` failure teardown; work is known to run during
   attach (patch 2 stack).
3. Important issue? **PASS** — UAF/oops, HIGH; window on this tree is
   narrower than pre-async-attach but still the right fix for that error
   path.
4. Small and contained? **PASS** — +1 line, one function.
5. No new features or APIs? **PASS**
6. Can apply to the local tree? **PASS** — `rproc_add()` /
   `crash_handler` / `rproc_remove_dev` all present.

**Step 9.3: CHECK FOR EXCEPTION CATEGORIES**
Record: None (not an ID/quirk/DT/build/doc exception). It is a normal
small bugfix.

**Step 9.4: MAKE YOUR DECISION**
This belongs in this tree: a one-line, obviously correct cancel before
teardown, preventing crash-handler UAF on the `rproc_add()` error path.
Patch 1 reduced how often that path is taken for attach, but it did not
make the cancel wrong or unnecessary, and it does not depend on the
other series patches.

What it solves for users: if auto-boot registration fails after
`crash_handler` was queued, the work can run against a deleted device
and a soon-to-be-freed `rproc`. That is a host oops, not a DSP-only
glitch.

Risk vs benefit: near-zero risk, real UAF class. Incomplete `pm_relax`
is not a reason to drop the cancel.

### Verification
- [Phase 1] Tags: Link to v3-3 lore; SOBs Jingyi Wang, Bjorn Andersson;
  no Fixes/Reported-by/Cc stable.
- [Phase 1] Cover letter (mbox): attach-fail NULL deref **and**
  `rproc_add()` fail.
- [Phase 2] Diff: +1 `cancel_work_sync(&rproc->crash_handler)` at
  `rproc_remove_dev` in `rproc_add()`.
- [Phase 2] Current `rproc_add()`/`rproc_crash_handler_work()`/`rproc_re
  port_crash()`/`rproc_type_release()` read in-tree.
- [Phase 3] `git describe HEAD` → v7.3-rc4-27-gf0100363d8c37; `make
  kernelversion` → 7.3.0-rc4.
- [Phase 3] Blame: teardown from 7dbdb8bd7c028 (v5.14-rc1); this cancel
  is 0ec167625b4fe.
- [Phase 3] `git merge-base --is-ancestor` 0ec167625b4fe, 026a3fada4326,
  7dbdb8bd7c028, e3d2193959824 vs HEAD: all yes.
- [Phase 3] `git describe --contains 0ec167625b4fe` → v7.3-rc1~46^2~27.
- [Phase 3] `git log -S cancel_work_sync(&rproc->crash_handler)`: only
  this commit and later 74ee3b2f57674 (`rproc_del`).
- [Phase 4] `b4 dig -c/-a/-w/-m`: v2+v3 series; patch 3 added in v2;
  Bjorn applied; no NAK on 3/3; Stephan Gerhold reviewed **patch 2**
  only.
- [Phase 4] lore WebFetch 403; stable list **UNVERIFIED**.
- [Phase 5] Callers: many `rproc_add`/`devm_rproc_add` probe sites;
  `qcom_q6v5_init()` requests wdog/fatal IRQs before `rproc_add()`.
- [Phase 6] Buggy error path exists; apply would be clean; no other fix
  on this label.
- [Phase 8] Failure mode: workqueue UAF/oops, HIGH; trigger rarer here
  because of async attach.

The patch is small, correct, and closes a real lifetime hole on a path
this tree still has.

**YES**

 drivers/remoteproc/remoteproc_core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/remoteproc/remoteproc_core.c b/drivers/remoteproc/remoteproc_core.c
index 068a3ef467f78..70c990c3a5d76 100644
--- a/drivers/remoteproc/remoteproc_core.c
+++ b/drivers/remoteproc/remoteproc_core.c
@@ -2358,6 +2358,7 @@ int rproc_add(struct rproc *rproc)
 	return 0;
 
 rproc_remove_dev:
+	cancel_work_sync(&rproc->crash_handler);
 	rproc_delete_debug_dir(rproc);
 	device_del(dev);
 rproc_remove_cdev:
-- 
2.53.0

