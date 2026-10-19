Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB9525B3971;
	Mon, 19 Oct 2026 14:00:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418435; cv=none; b=qb3qk3Un1N0emwr30LpK+8bVqGaPDtKzByQltN8/IPkTAU40DBxXBxwTo+UYQ4UMaljoMyp3TLUqznAtkwr33BSaYyuvs3/0eQB4JCwOaFHz/l5xui4ozHEQa/PM58L9adi2eFuv/GXQPwg+/ToqD0gNu8VDpFxgosH2Dgebh2M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418435; c=relaxed/simple;
	bh=BAeugb3YEIvvtqacTRHjFl2tT3FLLfAdIoKE1je3Mj0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZdFGTITdHEe/oX4cqxnQZLrW0dwp0bwhF7c8DpANAGbpgVbDvsvOk+TypvW2lKpS+RxhR0wsIeLZCUmmGAuH+HtGasUo/+iQ8qAVGP73SyPwhbc+ozytZqEiSXK0RH2THmEpax3XiqKj2/HrkRN/P3Pvfxjs//DpO1H9lTW8fgg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TMVJgkbn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TMVJgkbn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D50F1F000C6;
	Mon, 19 Oct 2026 14:00:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418432;
	bh=j+WVFL+djEwM6R0d23srkPS8anxPgjJXdQcbB1ydMmU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TMVJgkbnMB5ZzylZeqq0MZI3Ur/Q37VWnc1Spyh61hgEBJRPQIYYmWOp10SHElreN
	 hml8tAvwdpYJYig4SoVAc/OcJsfhj75MqaRQkEcFfCmVv2rhZYe2QjvzCWXdcjjYbQ
	 10ie0YedK64QyNJIcZ/+r5v3KRpXH9Qq/oNrrEQKmJR9AyCFs5HmvdcYSK9KH86i6r
	 1BMQdOjmGoOqOgB27xzNqW3sLBF5fDIgwmL3rmJHcKb8hkHRSBCq5PHFp8MyCgYDIU
	 OpKrBjf6COaob+IczWAAKejk/LbMzPWaiFY0/iEvXNEuhx9CMLihVcLg+te05auD1w
	 ysTN5c3A+dpYA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Bjorn Andersson <bjorn.andersson@oss.qualcomm.com>,
	Pradnya Dahiwale <pradnya.dahiwale@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	mathieu.poirier@linaro.org,
	linux-remoteproc@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] remoteproc: Force shutdown during device removal
Date: Mon, 19 Oct 2026 09:48:56 -0400
Message-ID: <20261019135441.1420968-245-sashal@kernel.org>
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

From: Bjorn Andersson <bjorn.andersson@oss.qualcomm.com>

[ Upstream commit 4059c64d78b5d543dabae332922e763b4c95c79e ]

rproc_del() is subjected to the reference counted shutdown path, as such
a remoteproc with more than one reference will be left running as its
resources are released underneath it.

Refactor the shutdown path such that the reference count value is
ignored when called from rproc_del().

Assisted-by: OpenCode:GPT-5.5
Signed-off-by: Bjorn Andersson <bjorn.andersson@oss.qualcomm.com>
Reviewed-by: Pradnya Dahiwale <pradnya.dahiwale@oss.qualcomm.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260723-rproc-rmmod-not-crashing-v1-3-546dfd5de0e6@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The local checkout is mainline **7.3.0-rc4**
(`v7.3-rc4-27-gf0100363d8c37`). The change is a real rmmod/unbind crash
fix: `rproc_del()` used the refcounted shutdown path, so a remoteproc
with `power > 1` kept running while its driver tore resources down
underneath it.

---

## PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1: PARSE THE SUBJECT LINE**
- Record: **[remoteproc] [Force] Force shutdown during device removal**
- Subsystem: `remoteproc`. Verb “Force” is a correctness/safety change:
  shutdown must happen on device removal even if extra power refs
  remain.

**Step 1.2: PARSE ALL COMMIT MESSAGE TAGS**
- Record:
  - **No `Fixes:` tag** (expected for this review pipeline; not a
    negative)
  - **No `Cc: stable@vger.kernel.org`** (same)
  - **No `Reported-by:` / `Tested-by:`**
  - **Reviewed-by:** Pradnya Dahiwale, Konrad Dybcio (Qualcomm
    remoteproc reviewers)
  - **Assisted-by:** OpenCode:GPT-5.5 (LLM-assisted; still maintainer-
    authored and reviewed)
  - **Link:** `https://lore.kernel.org/r/20260723-rproc-rmmod-not-
    crashing-v1-3-546dfd5de0e6@oss.qualcomm.com`
  - **Signed-off-by:** Bjorn Andersson (author and remoteproc
    maintainer). Ignore any Sasha Levin SOB.
- Series identity is in the lore Message-Id: **v1-3** of `rproc-rmmod-
  not-crashing`.

**Step 1.3: ANALYZE THE COMMIT BODY TEXT**
- Record:
  - **Bug:** `rproc_del()` calls the refcounted `rproc_shutdown()` path.
    If `rproc->power > 1`, shutdown only decrements the counter and
    leaves the processor running.
  - **Symptom:** Driver removal continues: debugfs teardown, list
    removal, `device_del()`, char-dev removal, then the platform
    `remove()` unmaps firmware memory / IOMMU / power domains under a
    still-running coprocessor. Cover letter: “unmap memory and shut down
    critical resources under its feet.”
  - **Root cause:** Removal is bound to the user-facing power-refcount
    API, which is intentionally a no-op until the last user.
  - **Version info:** None in the message. The TODO this replaces dates
    to 2016 (`ddf711872c9d2`, v4.9-rc1).
  - **Fix:** Internal `__rproc_shutdown(rproc, force)`; `rproc_del()`
    uses `force=true` and ignores the remaining refcount.

**Step 1.4: DETECT HIDDEN BUG FIXES**
- Record: **Not hidden.** The subject/body describe a crash/UAF-class
  removal bug. “Refactor the shutdown path” is only the mechanism
  (extract a `force` helper). Cover letter of `[PATCH 0/3] remoteproc:
  Improve removal of remoteproc drivers` states the same failure for
  three rmmod cases (crash state, crash-handler race, extra power ref).
  This commit is the third of those.

---

## PHASE 2: DIFF ANALYSIS

**Step 2.1: INVENTORY THE CHANGES**
- Record:
  - **File:** `drivers/remoteproc/remoteproc_core.c` only (`+31 / -26`)
  - **Functions:** `rproc_shutdown` body moved to
    `__rproc_shutdown(struct rproc *rproc, bool force)`;
    `rproc_shutdown()` becomes a `force=false` wrapper; `rproc_del()`
    calls `__rproc_shutdown(rproc, true)` instead of `rproc_shutdown()`
  - **Scope:** Single-file, surgical. No API/struct/header changes.

**Step 2.2: UNDERSTAND THE CODE FLOW CHANGE**
- Record:
  - **Before (`rproc_shutdown`):** lock → require
    RUNNING/ATTACHED/CRASHED → `atomic_dec_and_test(&rproc->power)` → if
    not last user, unlock and return without stopping → else
    `rproc_stop` + resource cleanup + unprepare + IOMMU disable + free
    cached resource table.
  - **After:** same path unless `force`. With `force`, stop/cleanup
    still runs even if the decrement did not hit zero.
  - **`rproc_shutdown()` users** (sysfs, cdev, client drivers) still use
    `force=false`; behavior unchanged.
  - **`rproc_del()`:** was `rproc_shutdown()` (and a TODO “make sure
    this works with rproc->power > 1”); now forced stop. Affected path
    is **device removal / module unload**, not the normal stop API.

**Step 2.3: IDENTIFY THE BUG MECHANISM**
- Record:
  - **Category:** logic/correctness on the removal path, with UAF / use-
    after-unmap / crash consequences.
  - **Mechanism:** Power refs are taken by `rproc_boot()`
    (`atomic_inc_return(&rproc->power) > 1` skips a second boot). Auto-
    boot plus a client (`ath11k`/`ath12k`, TI PRU ethernet, MediaTek
    MDP/vcodec, etc.) or sysfs/cdev `start` yields `power > 1`.
    `rproc_del()` then left the DSP/modem running while
    `qcom_pas_remove()` (verified) does `rproc_del()` then
    `qcom_pas_unassign_memory_region()` and subdev teardown.

**Step 2.4: ASSESS THE FIX QUALITY**
- Record:
  - **Quality:** Obviously correct. Forced stop on deletion is what the
    2016 TODO asked for. Existing state check still avoids stopping an
    already-offline rproc. `rproc_stop` failure still re-increments
    `power` (same as before).
  - **Regression risk:** Low. Force-stop while clients still hold refs
    is intentional: the rproc device is going away; leaving firmware
    running during unmap is worse. Residual `power` after force-stop is
    harmless: a later `rproc_shutdown()` hits the state check
    (`OFFLINE`) and returns `-EINVAL` **before** another decrement.
  - **Review note (verified in mbox):** Konrad asked whether non-forced
    `rproc_shutdown()` should also check `rproc->deleting`. Bjorn
    explained the mutex + state machine already serializes that race; v1
    was applied unchanged. No NAK.

---

## PHASE 3: GIT HISTORY INVESTIGATION

**Step 3.1: BLAME THE CHANGED LINES**
- Record:
  - Shutdown-on-delete + TODO introduced in **`ddf711872c9d2`**
    (“remoteproc: Introduce auto-boot flag”, 2016-08-17, **v4.9-rc1**).
    Originally `if (rproc->auto_boot) rproc_shutdown()`.
  - Recovery-path copy of the same TODO was later removed in
    **`7e83cab824a86`** (v4.13-rc1) by switching recovery to
    `rproc_stop()`/`rproc_start()`. The **`rproc_del()` TODO remained
    until this commit**.
  - Bug is long-standing, not new-in-7.3 code.

**Step 3.2: FOLLOW THE FIXES: TAG**
- Record: **No `Fixes:` tag on this commit.** Related series:
  - **1/3 `2482ca875ef59`** “Allow shutdown of crashed processors” —
    `Fixes: 5e6a0e05270e` (2022). Present in this tree.
  - **2/3 `74ee3b2f57674`** “Prevent crash handling to race with
    rproc_del()” — `Fixes: 8afd519c3470`. Present in this tree.
  - This 3/3 commit is **`4059c64d78b5d`** (2026-07-27).

**Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES**
- Record: Immediate parents are 1/3 and 2/3 (same author, same lore
  series). Follow-ups on `remoteproc_core.c` after 3/3: **none**.
  Standalone for the `power > 1` bug; 1/3 and 2/3 fix other rmmod crash
  variants.

**Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS**
- Record: Bjorn Andersson is the remoteproc maintainer (`Signed-off-by:
  Bjorn Andersson <andersson@kernel.org>` on apply). Same-week series is
  exactly these three rmmod-crash fixes.

**Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS**
- Record:
  - 3/3 does **not** require 2/3’s `deleting` flag or `cancel_work_sync`
    (those are adjacent context in `rproc_del()`).
  - 3/3 does **not** add the `RPROC_CRASHED` state check; that is 1/3.
    Forced shutdown of a **running** rproc with extra refs works without
    1/3.
  - **In this tree:** 1/3 and 2/3 are already ancestors, so no missing
    prereqs here. Can apply standalone.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

**Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION**
- Record:
  - `b4 dig -c 4059c64d78b5d` → https://patch.msgid.link/20260723-rproc-
    rmmod-not-crashing-v1-3-546dfd5de0e6@oss.qualcomm.com
  - `b4 dig -a`: **v1 only** (no v2/v3). Applied as submitted.
  - Cover letter (mbox msg 0): three rmmod failure modes; this patch is
    “bump the refcount … rproc_shutdown() becomes a nop, again leaving
    the remoteproc running”.
  - Konrad R-b, then a follow-up question about `deleting`; Bjorn
    replied with the mutex/state analysis; Pradnya R-b; applied
    2026-07-27.
  - **No NAK. No reviewer request for `Cc: stable`.** Maintainer:
    “there's more dragons hidden in these code paths” but still applied
    this as a real fix.

**Step 4.2: CHECK WHO REVIEWED THE PATCH**
- Record (`b4 dig -w`): To/Cc included Bjorn Andersson, Mathieu Poirier,
  Shengjiu Wang, Fernando Guzman Lugo, Ohad Ben-Cohen, `linux-
  remoteproc@`, `linux-arm-msm@`, `linux-kernel@`. Kernel.org lore 403’d
  for WebFetch; thread recovered via `b4 dig -m`.

**Step 4.3: SEARCH FOR THE BUG REPORT**
- Record: No syzbot/bugzilla `Reported-by`. Evidence is maintainer
  analysis plus the decade-old TODO. Cover letter describes a concrete
  rmmod trigger. No separate user bug report found.

**Step 4.4: CHECK FOR RELATED PATCHES AND SERIES**
- Record: Series of 3, all applied. 1/3 crashed-state stop; 2/3 crash-
  work vs `rproc_del()`; 3/3 force stop on extra refs. 3/3 is self-
  contained for its bug. In this tree the other two are already present.

**Step 4.5: CHECK STABLE MAILING LIST HISTORY**
- Record: lore.kernel.org/stable search for this subject did not turn up
  a stable-specific discussion. WebFetch of lore returned 403; WebSearch
  snippets were unrelated. **No evidence this was rejected for stable.**

---

## PHASE 5: CODE SEMANTIC ANALYSIS

**Step 5.1: IDENTIFY KEY FUNCTIONS**
- Record: `__rproc_shutdown()` (new static), `rproc_shutdown()`,
  `rproc_del()`. Indirectly `rproc_stop()`, `rproc_resource_cleanup()`,
  `rproc_unprepare_device()`, `rproc_disable_iommu()`.

**Step 5.2: TRACE CALLERS**
- Record:
  - `rproc_del()`: every remoteproc platform `remove()`
    (`qcom_q6v5_pas`, `qcom_q6v5_mss`, `qcom_wcnss`, `stm32_rproc`,
    `mtk_scp`, `xlnx_r5_remoteproc`, …).
  - `rproc_shutdown()`: sysfs `state`, cdev stop/release, and clients
    (`ath11k`/`ath12k` AHB, TI ICSSG/ICSSM, `wkup_m3_ipc`, `st_fdma`,
    MediaTek vcodec, etc.). Those keep `force=false`.
  - Context: process context, driver unbind / `rmmod`, not IRQ.

**Step 5.3: TRACE CALLEES**
- Record: Forced path still `rproc_stop()` (subdevices, resource table
  reset, `ops->stop`, unprepare, `RPROC_OFFLINE`) then resource cleanup,
  unprepare, IOMMU disable, `kfree(cached_table)`. Same teardown as a
  last-user shutdown, just not gated on refcount.

**Step 5.4: FOLLOW THE CALL CHAIN**
- Record: Userspace-reachable via `rmmod` / sysfs unbind of a remoteproc
  driver while another `rproc_boot()` holder exists (Wi-Fi firmware on
  Qualcomm PAS is a documented client). Unprivileged trigger depends on
  whether module unload is allowed; the bug is real on developer and
  production unbind paths.

**Step 5.5: SEARCH FOR SIMILAR PATTERNS**
- Record: `stm32_rproc_remove()` already does an extra
  `rproc_shutdown()` if `power > 0` before `rproc_del()`, which can
  happen to drain one extra ref. Qualcomm PAS `remove()` only calls
  `rproc_del()` then unassigns memory — that is the crashing pattern
  this fixes in core so every driver gets it.

---

## PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE

**Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?**
- Record: **Yes.** `__rproc_shutdown()` / forced `rproc_del()` are in
  `drivers/remoteproc/remoteproc_core.c` (this commit is an ancestor of
  HEAD). Pre-fix form is `rproc_shutdown()` in `rproc_del()` plus the
  power-refcount bailout. Bug introduced **v4.9-rc1** (`ddf711872c9d2`).

**Step 6.2: CHECK FOR BACKPORT COMPLICATIONS**
- Record: **On this tree: clean / already integrated.** 2/3 already
  added `crash_handler_lock` / `deleting` / `cancel_work_sync`
  immediately above the changed call, matching this hunk. No later
  conflicting edits.

**Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE**
- Record: 1/3 and 2/3 are in HEAD. No alternate force-shutdown
  implementation. This commit is the fix for the `power > 1` case.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

**Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY**
- Record: **`drivers/remoteproc/` — IMPORTANT** (not mm/VFS, but core
  for Qualcomm/TI/STM32/Mediatek/Xilinx coprocessors: modem, Wi-Fi,
  audio DSP, PRU). A core-framework removal bug hits every remoteproc
  driver.

**Step 7.2: ASSESS SUBSYSTEM ACTIVITY**
- Record: Actively maintained (Qualcomm PAS, sysmon, attach/detach,
  crash handling). This is a maintainer fix for a very old hole, not
  churn in brand-new code.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

**Step 8.1: DETERMINE WHO IS AFFECTED**
- Record: **Driver-specific / config-specific:** `CONFIG_REMOTEPROC`
  platforms, especially Qualcomm PAS + client `rproc_boot()` users. Not
  universal desktop x86, but common on phones, laptops with Qualcomm
  SoCs, and embedded boards.

**Step 8.2: DETERMINE THE TRIGGER CONDITIONS**
- Record:
  - Trigger: `rproc_del()` while `atomic_read(&rproc->power) > 1` and
    state is RUNNING/ATTACHED/CRASHED.
  - How: auto-boot + client `rproc_boot()`, or extra sysfs/cdev start,
    then unbind/`rmmod`.
  - Not every boot; **common on Qualcomm** where Wi-Fi/other clients
    hold a boot ref.
  - Unprivileged: only if module unload is permitted.

**Step 8.3: DETERMINE THE FAILURE MODE SEVERITY**
- Record: Firmware left running while driver unmaps carveouts, disables
  IOMMU, and frees resource tables → **oops/UAF, possible DMA
  corruption**. Cover letter matches that. **Severity: HIGH (crash /
  memory safety on device removal).**

**Step 8.4: CALCULATE RISK-BENEFIT RATIO**
- Record:
  - **Benefit:** High for remoteproc users — prevents rmmod/unbind crash
    and teardown-under-running-firmware.
  - **Risk:** Low — ~net +5 lines of logic, wrapper extract, no API
    change, `rproc_shutdown()` behavior unchanged, reviewed by subsystem
    people.
  - **Ratio:** Benefit clearly exceeds risk.

---

## PHASE 9: FINAL SYNTHESIS

**Step 9.1: COMPILE THE EVIDENCE**

**FOR backporting:**
- Real bug: extra power refs make `rproc_del()` skip stop; resources
  released under live firmware (crash/UAF/DMA).
- Known since 2016 TODO in `rproc_del()`.
- Concrete trigger: client `rproc_boot()` + driver remove (Qualcomm PAS
  verified).
- Small, contained, obviously correct `force` flag.
- Maintainer patch, two Reviewed-by, applied after discussion; no NAK.
- No new APIs/features; public `rproc_shutdown()` unchanged.
- Prerequisites 1/3 and 2/3 are in this tree; 3/3 still stands alone for
  this bug.

**AGAINST:**
- Patch 3/3 of a series (other rmmod cases need 1/3 and 2/3; those are
  already here).
- No `Fixes:`/`Cc: stable`/`Reported-by` (expected here; not a veto).
- Trigger is unbind/rmmod, not every boot.
- Cover letter admits more issues remain in these paths (not a reason to
  skip this hole).

**UNRESOLVED:**
- lore.kernel.org HTTP 403 via WebFetch; thread recovered with `b4 dig
  -m`.
- No stable-list discussion found.

**Step 9.2: APPLY THE STABLE RULES CHECKLIST**
1. Obviously correct and tested? **PASS** — logic is local and reviewed;
   maintainer applied v1.
2. Fixes a real bug that affects users? **PASS** — rmmod/unbind with
   extra boot refs.
3. Important issue (crash, security, corruption, deadlock)? **PASS** —
   crash / UAF / DMA under teardown; HIGH.
4. Small and contained? **PASS** — one file, wrapper + one call-site
   change.
5. No new features or APIs? **PASS** — internal `force` flag only.
6. Can apply to the local tree? **PASS** — code and prereqs are in this
   7.3-rc4 tree.

**Step 9.3: CHECK FOR EXCEPTION CATEGORIES**
- Record: None (not a device ID, quirk, DT, build, or doc exception). It
  qualifies as a normal important bugfix.

**Step 9.4: MAKE YOUR DECISION**
This is a small, correct fix for a long-standing removal crash in
remoteproc core. On this tree the surrounding series is already present,
so there is no missing dependency. It meets stable-kernel rules on
technical merit.

---

### What the commit solves (for stable users)
`rproc_del()` used to call `rproc_shutdown()`, which only actually stops
the remote processor when the power refcount hits zero. Auto-boot plus
any extra `rproc_boot()` (Wi-Fi, PRU ethernet, sysfs/cdev start, …) left
the coprocessor running while the platform driver unmapped firmware
memory and dropped IOMMU/power resources. That is an oops / use-after-
unmap on `rmmod` or device unbind.

### Risk vs benefit
Benefit is preventing a real crash on a common Qualcomm/embedded unbind
path. Risk is low: the public shutdown API is unchanged; only deletion
forces stop.

### Concerns
None that block this tree. It is series patch 3/3, but the `power > 1`
fix does not need 1/3 or 2/3, and both are already here.

---

### Verification
- **[Phase 1]** `git log -1 --format=%B 4059c64d78b5d`:
  subject/body/tags as above; no Fixes/Cc-stable/Reported-by; Link lore
  id `v1-3`; Reviewed-by Pradnya + Konrad.
- **[Phase 1]** Local tree: `git describe HEAD` →
  `v7.3-rc4-27-gf0100363d8c37`; `make kernelversion` → `7.3.0-rc4`.
- **[Phase 2]** `git show 4059c64d78b5d`: 1 file, +31/-26;
  `__rproc_shutdown(..., force)`; `rproc_del` uses `force=true`.
- **[Phase 2]** Read current
  `rproc_shutdown`/`rproc_del`/`rproc_boot`/`rproc_stop` in this
  checkout: power increment-on-boot, bailout-on-shutdown, forced stop on
  delete confirmed.
- **[Phase 3]** `git log -S 'TODO: make sure this works with
  rproc->power'` → `ddf711872c9d2` (v4.9-rc1) and this commit; `git
  describe --contains ddf711872c9d2` → `v4.9-rc1~104^2~13`.
- **[Phase 3]** `git merge-base --is-ancestor 4059c64d78b5d HEAD` → yes;
  same for `2482ca875ef59` and `74ee3b2f57674`.
- **[Phase 3]** `git log 4059c64d78b5d..HEAD --
  drivers/remoteproc/remoteproc_core.c` → empty (no follow-up reversal).
- **[Phase 4]** `b4 dig -c 4059c64d78b5d` / `-w` / `-a` / `-m
  /tmp/rproc-thread.mbox`: v1-only series; cover letter describes extra-
  refcount rmmod crash; Konrad R-b + deleting-flag question; Bjorn
  reply; Pradnya R-b; applied. No NAK, no Cc-stable in thread.
- **[Phase 4]** WebFetch lore.kernel.org → 403; used mbox instead.
  Stable-list search: no relevant hits.
- **[Phase 5]** `rg rproc_boot` / `rproc_shutdown` / `rproc_del`:
  clients and remove paths listed above. Read `qcom_q6v5_pas.c`
  `qcom_pas_remove()`: `rproc_del()` then
  `qcom_pas_unassign_memory_region()`. Read `stm32_rproc_remove()`:
  extra `rproc_shutdown` before `rproc_del()`.
- **[Phase 6]** Buggy `rproc_del`+refcount path present since v4.9; this
  tree has the fix and both series siblings.
- **[Phase 8]** Failure mode: firmware running during resource unmap →
  crash/UAF; severity HIGH. Trigger: extra `rproc_boot` + device
  removal.
- **UNVERIFIED:** Direct HTTP read of lore HTML (403). No public
  syzbot/user bugzilla report.

**YES**

 drivers/remoteproc/remoteproc_core.c | 57 +++++++++++++++-------------
 1 file changed, 31 insertions(+), 26 deletions(-)

diff --git a/drivers/remoteproc/remoteproc_core.c b/drivers/remoteproc/remoteproc_core.c
index 70c990c3a5d76..1e277333de871 100644
--- a/drivers/remoteproc/remoteproc_core.c
+++ b/drivers/remoteproc/remoteproc_core.c
@@ -1993,28 +1993,7 @@ int rproc_boot(struct rproc *rproc)
 }
 EXPORT_SYMBOL(rproc_boot);
 
-/**
- * rproc_shutdown() - power off the remote processor
- * @rproc: the remote processor
- *
- * Power off a remote processor (previously booted with rproc_boot()).
- *
- * In case @rproc is still being used by an additional user(s), then
- * this function will just decrement the power refcount and exit,
- * without really powering off the device.
- *
- * Every call to rproc_boot() must (eventually) be accompanied by a call
- * to rproc_shutdown(). Calling rproc_shutdown() redundantly is a bug.
- *
- * Notes:
- * - we're not decrementing the rproc's refcount, only the power refcount.
- *   which means that the @rproc handle stays valid even after rproc_shutdown()
- *   returns, and users can still use it with a subsequent rproc_boot(), if
- *   needed.
- *
- * Return: 0 on success, and an appropriate error value otherwise
- */
-int rproc_shutdown(struct rproc *rproc)
+static int __rproc_shutdown(struct rproc *rproc, bool force)
 {
 	struct device *dev = &rproc->dev;
 	bool crashed;
@@ -2034,9 +2013,10 @@ int rproc_shutdown(struct rproc *rproc)
 	}
 	crashed = rproc->state == RPROC_CRASHED;
 
-	/* if the remote proc is still needed, bail out */
-	if (!atomic_dec_and_test(&rproc->power))
+	if (!atomic_dec_and_test(&rproc->power) && !force) {
+		/* The remote processor is still needed by another user. */
 		goto out;
+	}
 
 	ret = rproc_stop(rproc, crashed);
 	if (ret) {
@@ -2060,6 +2040,32 @@ int rproc_shutdown(struct rproc *rproc)
 	mutex_unlock(&rproc->lock);
 	return ret;
 }
+
+/**
+ * rproc_shutdown() - power off the remote processor
+ * @rproc: the remote processor
+ *
+ * Power off a remote processor (previously booted with rproc_boot()).
+ *
+ * In case @rproc is still being used by an additional user(s), then
+ * this function will just decrement the power refcount and exit,
+ * without really powering off the device.
+ *
+ * Every call to rproc_boot() must (eventually) be accompanied by a call
+ * to rproc_shutdown(). Calling rproc_shutdown() redundantly is a bug.
+ *
+ * Notes:
+ * - we're not decrementing the rproc's refcount, only the power refcount.
+ *   which means that the @rproc handle stays valid even after rproc_shutdown()
+ *   returns, and users can still use it with a subsequent rproc_boot(), if
+ *   needed.
+ *
+ * Return: 0 on success, and an appropriate error value otherwise
+ */
+int rproc_shutdown(struct rproc *rproc)
+{
+	return __rproc_shutdown(rproc, false);
+}
 EXPORT_SYMBOL(rproc_shutdown);
 
 /**
@@ -2626,8 +2632,7 @@ int rproc_del(struct rproc *rproc)
 	if (cancel_work_sync(&rproc->crash_handler))
 		pm_relax(rproc->dev.parent);
 
-	/* TODO: make sure this works with rproc->power > 1 */
-	rproc_shutdown(rproc);
+	__rproc_shutdown(rproc, true);
 
 	rproc_delete_debug_dir(rproc);
 
-- 
2.53.0

