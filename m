Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83419597F53;
	Mon, 19 Oct 2026 13:59:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418353; cv=none; b=lR1SO+rov8dVgT/CIXKNhH6E/rbDdfFUyjRgfbx6ZeFYnPAFDPXv8mX+UCA3xluYRUHSHzPkwI2vq5Q/9O4PiVH5P8SR4orydPPbb5p3LxRIGkvHA8iwBoJgkKzXL6JeKDujSq9pH6oxj9Ezs6IivpiI/CYVlgGPmh5pH7/IwVw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418353; c=relaxed/simple;
	bh=b+OMwOLcW33yq5gnsz2FawLSP8MWAZjLTP9XzueV1Hw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kNMmS44PYgbm9lUOPVEhpiBApBrMKcXG1yOReFYevFsARGI058YGbygPFMsYswfiTtlVQp/UDNkZ+xPZrJblgz7chQHBUtud16g6jVU5imHb3+G0lxmVXuc839i1hO9vfm7tkRI3UqUU5aLotJlvLvBsZStuqLHNnNKsNSEG8h4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hK+QrYeA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hK+QrYeA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80E081F000C4;
	Mon, 19 Oct 2026 13:59:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418350;
	bh=QEfjg6P1FYqNYGIigcbrCtHbIVajWC/AZaOZAgOrtf4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hK+QrYeAlramjQFHe+Yn5NElxq+jbuQRMG3imO0F38+mEbOOJ67wMG4+90aFk9dC8
	 Biv4VXIWbJidFUe0axu6xGimDSUjHWhlQS2J1n25ay28XIF46g02SkGucjRzT5GpZY
	 KkTrwddFW1jRexvOyefnvqPpvBryzMCQ1TkVzHehgFfcerSoLhUZ7T2egWORqBdo5m
	 JvQRpbPwPBwdhL+sFq6EMqpPJZ01q+ueoL7Zi9nL0eHH/FOeBHb9JTNRzBPyUw2JCW
	 /A1TxPwzxAoD0icgIANIizFvrMMxWVGpT8mu4ciq2i38B8XGFSLA97flJ1PXFcdPQz
	 W2uewv4EvJdGw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Geetha sowjanya <gakula@marvell.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	mark.rutland@arm.com,
	linux-arm-kernel@lists.infradead.org,
	linux-perf-users@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.1] perf: marvell: Cancel CN10K DDR PMU hrtimer on device remove
Date: Mon, 19 Oct 2026 09:47:56 -0400
Message-ID: <20261019135441.1420968-185-sashal@kernel.org>
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

From: Geetha sowjanya <gakula@marvell.com>

[ Upstream commit 7dbcb0268d1e2a1d3badb0c6e77ee70e550b1787 ]

cn10k_ddr_perf_remove() did not cancel the poll hrtimer before returning.
If the device was unbound while perf events were still active the timer
callback could run post-free.

To fix the issue by adding hrtimer_cancel() in remove().

Signed-off-by: Geetha sowjanya <gakula@marvell.com>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

I have enough to decide: the UAF is in this 6.1 tree, the cancel is a
standalone 6-line fix, and it does not need the CN20K series.

===============================================================
PHASE 1: COMMIT MESSAGE FORENSICS
===============================================================

**Step 1.1: PARSE THE SUBJECT LINE**

Record: `[perf/marvell] [Cancel] Cancel CN10K DDR PMU hrtimer on device
remove`

Subsystem `perf: marvell:` is the Marvell CN10K DDR uncore PMU driver.
Verb `Cancel` is a stop-the-timer safety action. Claimed intent: stop
the poll hrtimer in the platform `remove()` path so it cannot fire after
the device is torn down.

**Step 1.2: PARSE ALL COMMIT MESSAGE TAGS**

Record: tags present in the candidate message:
- `Signed-off-by: Geetha sowjanya <gakula@marvell.com>` (author)
- `Signed-off-by: Will Deacon <will@kernel.org>` (ARM perf maintainer
  merge; pipeline `Signed-off-by: Sasha Levin` ignored per instructions)

Tags **not** present (expected for this review queue, not treated as a
negative):
- No `Fixes:`
- No `Reported-by:` / `Tested-by:` / `Reviewed-by:` / `Acked-by:`
- No `Link:`
- No `Cc: stable@vger.kernel.org`

From mailing-list forensics (Phase 4): original submission was `[PATCH
v8 3/3]` of a CN20K feature series, Message-ID
`20260601073318.7098-4-gakula@marvell.com`. Will Deacon applied it to
`arm64 (for-next/perf)` as `7dbcb0268d1e`. Krzysztof’s `Reviewed-by` is
on patch 1/3 (dt-bindings) only, not on this UAF patch.

**Step 1.3: ANALYZE THE COMMIT BODY TEXT**

Record:
- **Bug:** `cn10k_ddr_perf_remove()` returned without cancelling the
  overflow-poll hrtimer.
- **Symptom / failure mode:** if the device is unbound while events (and
  therefore the timer) are still active, `cn10k_ddr_pmu_timer_handler()`
  can run after `devm` frees `struct cn10k_ddr_pmu` and unmaps MMIO —
  use-after-free / MMIO-after-unmap.
- **Version info:** cover letter for v8 says this is **pre-existing for
  CN10K/Odyssey**, not a CN20K-only issue.
- **Root cause (author):** missing `hrtimer_cancel()` in `remove()`.

**Step 1.4: DETECT HIDDEN BUG FIXES**

Record: Not a disguised cleanup. The message names a post-free timer
callback. This is an explicit UAF fix. The series is mostly a CN20K
feature add; **this patch was split out in v8 specifically as a pre-
existing bug fix**.

===============================================================
PHASE 2: DIFF ANALYSIS - LINE BY LINE
===============================================================

**Step 2.1: INVENTORY THE CHANGES**

Record:
- File: `drivers/perf/marvell_cn10k_ddr_pmu.c`
- Scope: **+6 / -0**, single function `cn10k_ddr_perf_remove()`
- Classification: **single-file surgical fix** (comment +
  `hrtimer_cancel()`)

**Step 2.2: UNDERSTAND THE CODE FLOW CHANGE**

Record:
- **Before:** `remove()` got drvdata, dropped the cpuhp instance,
  unregistered the PMU, returned. Timer left live if it had been
  started.
- **After:** `hrtimer_cancel(&ddr_pmu->hrtimer)` **first**, then the
  same teardown. `hrtimer_cancel()` also waits for a running callback,
  so the handler cannot continue after `remove()` returns.
- Path: **driver teardown / unbind / module unload**, not the normal
  event add/del path (that already cancels on last `event_del`).

**Step 2.3: IDENTIFY THE BUG MECHANISM**

Record: **Use-after-free / lifetime bug (memory safety)**

Mechanism verified in this tree:
- `ddr_pmu` is `devm_kzalloc()`’d; MMIO is
  `devm_platform_get_and_ioremap_resource()`. Both are released after
  `remove()` returns.
- Timer is started on first `event_add` (`hrtimer_start`,
  `HRTIMER_MODE_REL_PINNED`) and cancelled only when `active_events ==
  0` in `event_del`.
- Handler always `return HRTIMER_RESTART` after
  `cn10k_ddr_pmu_overflow_handler(pmu)`, which dereferences
  `pmu->events[]` and `pmu->base`.
- `perf_pmu_unregister()` in this tree (`kernel/events/core.c`) does
  **not** stop events or cancel driver timers; it only unlists the PMU,
  syncs RCU, and frees PMU context.

**Step 2.4: ASSESS THE FIX QUALITY**

Record:
- **Quality:** obviously correct. `hrtimer_cancel()` on an already-idle
  timer is a no-op; cancelling before cpuhp/PMU teardown is the right
  order.
- **Regression risk:** very low. Callback only does `local_irq_save` +
  MMIO reads; it does not take locks `remove()` holds. No API/data-
  structure change.
- **Red flags:** none in the hunk itself. Series context (3/3 of CN20K)
  is a packaging concern, not a correctness concern — this hunk does not
  use CN20K code.

===============================================================
PHASE 3: GIT HISTORY INVESTIGATION
===============================================================

**Step 3.1: BLAME THE CHANGED LINES**

Record:
- Buggy `cn10k_ddr_perf_remove()` (no timer cancel) introduced in
  `7cf83e222bce0` (`perf/marvell: CN10k DDR performance monitor
  support`, Bharat Bhushan, 2022-03-08).
- `git merge-base --is-ancestor 7cf83e222bce0 HEAD` succeeded; `git
  merge-base --is-ancestor 7cf83e222bce0 v6.1` succeeded.
- Present in this tree from the 6.1 baseline (driver landed in v5.18).

**Step 3.2: FOLLOW THE FIXES: TAG**

Record: No `Fixes:` tag. The introducing commit is `7cf83e222bce0`,
which **is** in this tree.

**Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES**

Record: only four commits on this file in this tree:
- `7cf83e222bce0` CN10k DDR perfmon support
- `35a43326a9e3c` overflow handling
- `68fa55f0e05ce` core ownership
- `6676a42f1e4f1` `!CONFIG_OF` build fix

No later refactor of `remove()`. **Standalone** relative to this tree.
Does **not** need patches 1–2 of the CN20K series.

Related but **separate** bug (v7 of the same series, in patch 2/3):
`event_add` can `hrtimer_start()` then return `-EINVAL` from
`ddr_perf_get_event_bitmap()` without rolling back. That leak is **not**
this commit. This commit still stands alone.

**Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS**

Record: `git log --author=Geetha -- drivers/perf/` is empty in this 6.1
tree. Author is a Marvell engineer extending a Marvell driver originally
by Bharat Bhushan. Will Deacon (ARM perf maintainer) merged it. That is
sufficient maintainer vetting.

**Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS**

Record: **No functional prerequisites.** The only apply wrinkle is 6.1
still has `static int cn10k_ddr_perf_remove(...)` returning `0`; later
kernels converted platform `.remove` to `void`. The added
`hrtimer_cancel()` line and comment apply unchanged.

===============================================================
PHASE 4: MAILING LIST AND EXTERNAL RESEARCH
===============================================================

**Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION**

Record:
- `b4 dig -c HEAD` was the wrong SHA (this commit is not in the 6.1
  checkout). Direct lore fetch returned 403.
- `b4 am` on Message-ID `20260601073318.7098-4-gakula@marvell.com`
  succeeded: v8 series, 3 patches, DKIM-signed, no newer revision
  flagged.
- Lore/mirrors:
  https://patch.msgid.link/20260601073318.7098-1-gakula@marvell.com ,
  openwall, lkml.iu.edu, patchew, ratatoskr.
- Cover letter v8: “Cancel the poll hrtimer in `cn10k_ddr_perf_remove()`
  before `devm` frees `struct cn10k_ddr_pmu` (pre-existing for
  CN10K/Odyssey).”
- **No NAK.** Will Deacon: “Applied to arm64 (for-next/perf)” with git
  id `7dbcb0268d1e` for this patch.
- **No reviewer `Cc: stable` found** (not treated as a negative).

**Step 4.2: CHECK WHO REVIEWED THE PATCH**

Record: To/Cc on the original mail: `linux-perf-users`, `linux-kernel`,
`linux-arm-kernel`, `devicetree`, Mark Rutland, Will Deacon, Krzysztof
Kozlowski. Will Deacon merged. No NAK on 3/3.

**Step 4.3: SEARCH FOR THE BUG REPORT**

Record: No syzbot, bugzilla, or external user report. Bug was found
during CN20K series review/development (added in v8). Still a concrete
UAF, just not fuzzer-reported.

**Step 4.4: CHECK FOR RELATED PATCHES AND SERIES**

Record: Series is:
1. dt-bindings CN20K — feature, not this decision
2. CN20K driver support (+ event_add rollback) — feature / separate leak
   fix
3. **this UAF cancel** — independent 6-line fix

Do **not** pull 1/3 or 2/3 into 6.1. This commit does not call CN20K
pdata/helpers.

**Step 4.5: CHECK STABLE MAILING LIST HISTORY**

Record: lore.kernel.org/stable search returned 403. No evidence on the
public v8 thread that stable rejected this. UNVERIFIED: whether
`-stable` ever discussed this hash by name.

===============================================================
PHASE 5: CODE SEMANTIC ANALYSIS
===============================================================

**Step 5.1: IDENTIFY KEY FUNCTIONS IN THE DIFF**

Record: `cn10k_ddr_perf_remove()` only. Related existing functions:
`cn10k_ddr_perf_event_add`, `cn10k_ddr_perf_event_del`,
`cn10k_ddr_pmu_timer_handler`, `cn10k_ddr_pmu_overflow_handler`.

**Step 5.2: TRACE CALLERS**

Record:
- `cn10k_ddr_perf_remove` is the platform driver’s `.remove`
  (`cn10k_ddr_pmu_driver`). Callers: device unbind, parent device
  teardown, `platform_driver_unregister()` from `cn10k_ddr_pmu_exit()`.
- Timer handler is the hrtimer softirq/callback path, not a syscall.

**Step 5.3: TRACE CALLEES**

Record: `remove()` calls `platform_get_drvdata`, `hrtimer_cancel` (new),
`cpuhp_state_remove_instance_nocalls`, `perf_pmu_unregister`. Handler
calls overflow path which does MMIO `readq_relaxed` on `pmu->base`.

**Step 5.4: FOLLOW THE CALL CHAIN**

Record: Userspace can start the timer via `perf_event_open` on this
uncore PMU (`event_add` when `active_events == 1`). Unbind/unload is
admin-triggered (module unload, device teardown), not an unprivileged
syscall by itself. `event_init` does **not** validate `attr.config`;
`event_add` can start the timer then fail `ddr_perf_get_event_bitmap()`.
`event_sched_in()` on add failure does **not** call `pmu->del()`
(verified at `kernel/events/core.c:2591-2595`). That can leave a running
timer even after a failed `perf_event_open`, after which `rmmod` can run
`remove()` with the timer still live. Reachable from userspace + admin
unload.

**Step 5.5: SEARCH FOR SIMILAR PATTERNS**

Record: In this tree, this driver only cancels the timer in `event_del`.
`drivers/perf/thunderx2_pmu.c` also cancels on CPU offline. Sibling DDR
PMU `fsl_imx8_ddr_perf.c` also does not cancel in `remove()` here —
pattern exists, but that does not make this UAF fictional.

===============================================================
PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE
===============================================================

**Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?**

Record: **Yes.** Local tree is **6.1.188** (`pending-6.1`, `git
describe` `p-6.1-10-g80966a5b14be4`).

```700:710:drivers/perf/marvell_cn10k_ddr_pmu.c
static int cn10k_ddr_perf_remove(struct platform_device *pdev)
{
        struct cn10k_ddr_pmu *ddr_pmu = platform_get_drvdata(pdev);

        cpuhp_state_remove_instance_nocalls(
CPUHP_AP_PERF_ARM_MARVELL_CN10K_DDR_ONLINE,
                                &ddr_pmu->node);

        perf_pmu_unregister(&ddr_pmu->pmu);
        return 0;
}
```

No `hrtimer_cancel()`. Introduced with the driver in `7cf83e222bce0`
(v5.18), present for the whole 6.1 lifetime.

**Step 6.2: CHECK FOR BACKPORT COMPLICATIONS**

Record: **Minor context only.** 6.1 `remove` is `int` and returns `0`;
later kernels use `void`. OF match table in 6.1 has no `.data` / CN20K
entries. The added call does not depend on those. Expected apply:
**minor conflict, trivial rework**.

This tree still has `suppress_bind_attrs = true`, so **sysfs**
bind/unbind is hidden. That does **not** skip `.remove` on parent
teardown or `platform_driver_unregister()`.

**Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE**

Record: No `hrtimer_cancel` in `remove()`. No event_add rollback (`goto
err_free_counter`). Nothing already fixes this UAF.

===============================================================
PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT
===============================================================

**Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY**

Record: `drivers/perf/` Marvell CN10K DDR PMU. **PERIPHERAL** (SoC-
specific uncore PMU). Config `MARVELL_CN10K_DDR_PMU` depends on
`ARCH_THUNDER || (COMPILE_TEST && 64BIT)` — Octeon 10 / Thunder-class
ARM64.

**Step 7.2: ASSESS SUBSYSTEM ACTIVITY**

Record: File is mature and quiet in 6.1 (four commits total). Bug is
old, not a last-month regression.

===============================================================
PHASE 8: IMPACT AND RISK ASSESSMENT
===============================================================

**Step 8.1: DETERMINE WHO IS AFFECTED**

Record: **Driver-specific / config-specific:**
`CONFIG_MARVELL_CN10K_DDR_PMU` on Marvell CN10K (`ARCH_THUNDER`). Not
universal.

**Step 8.2: DETERMINE THE TRIGGER CONDITIONS**

Record:
- Timer starts when the first perf event is added; period default
  **100s** (`poll_period_sec`).
- Classic trigger: device `remove()` while the timer is queued (unbind /
  parent removal / module exit).
- Mitigations in **this** tree: `suppress_bind_attrs = true` (no sysfs
  unbind); successful events `try_module_get` the module so `rmmod`
  waits for last close, and last `event_del` already cancels the timer.
- Remaining realistic triggers: platform device teardown with events
  still open; **failed `event_add` after `hrtimer_start`** leaving a
  live timer so `rmmod` can hit `remove()` without `event_del`.
- Unprivileged user can start/leak the timer via `perf_event_open`;
  teardown is typically admin. Failure mode is still kernel UAF.

**Step 8.3: DETERMINE THE FAILURE MODE SEVERITY**

Record: Timer callback uses freed `cn10k_ddr_pmu` and unmapped MMIO →
**use-after-free / oops / memory corruption**. Severity: **HIGH** (UAF).
Not a guaranteed panic on every boot; when it hits, it is a hard kernel
memory-safety failure.

**Step 8.4: CALCULATE RISK-BENEFIT RATIO**

Record:
- **Benefit:** HIGH for CN10K users who unload/unbind with a live poll
  timer; prevents UAF. Population is small but the bug class is serious.
- **Risk:** VERY LOW (6 lines, no-op if timer idle, no locking change).
- **Ratio:** strongly in favor of backporting.

===============================================================
PHASE 9: FINAL SYNTHESIS
===============================================================

**Step 9.1: COMPILE THE EVIDENCE**

**FOR:**
- Real UAF: poll hrtimer can run after `devm` free of the PMU struct.
- Bug exists in this 6.1 tree since the driver was added
  (`7cf83e222bce0`).
- Surgical, obviously correct (`hrtimer_cancel` before teardown).
- Maintainer-merged (Will Deacon).
- Author/cover letter call it a **pre-existing CN10K** bug, not
  CN20K-only.
- Independent of CN20K patches 1–2.
- Failed `event_add` in this tree can leave the timer running;
  `pmu->add` failure does not call `del()`.
- `hrtimer_cancel` on idle timer is safe.

**AGAINST:**
- Peripheral SoC PMU, not a core path.
- No syzbot/user report.
- `suppress_bind_attrs` hides sysfs unbind; happy-path `rmmod` after
  clean event_del already cancels the timer.
- Packaged as 3/3 of a feature series (but this hunk is independent).
- Trivial `int` vs `void` `remove` context mismatch.

**UNRESOLVED:**
- Could not fetch lore.kernel.org (403) or git.kernel.org (Anubis);
  discussion reconstructed via `b4 am`, patchew, and mirrors.
- No `-stable` thread found (403).
- Exact mainline SHA in Linus’s tree not in this checkout; arm64
  application id `7dbcb0268d1e` from Will’s mail.

**Step 9.2: APPLY THE STABLE RULES CHECKLIST**

1. Obviously correct and tested? **PASS** — one `hrtimer_cancel()`,
   merged by Will Deacon, idle-timer cancel is a no-op.
2. Fixes a real bug that affects users? **PASS** — UAF on remove with a
   live poll timer; code present here.
3. Important issue? **PASS** — use-after-free / crash / memory
   corruption (HIGH). Trigger is not every boot, but severity matches
   stable’s crash/UAF bar.
4. Small and contained? **PASS** — 6 lines, one function, one file.
5. No new features or APIs? **PASS**.
6. Can apply to the local tree? **PASS** — buggy `remove()` is here;
   only `int` vs `void` `remove` needs a one-line context tweak.

**Step 9.3: CHECK FOR EXCEPTION CATEGORIES**

Record: Not a device-ID / quirk / DT / build / docs exception. It is a
normal small UAF fix.

**Step 9.4: MAKE YOUR DECISION**

This should be backported to **this** 6.1 tree. The CN20K feature
patches must stay out; this cancel is self-contained and matches the
code that has been in 6.1 from day one.

===============================================================
What the commit solves, and why it matters here
===============================================================

`cn10k_ddr_perf_remove()` tears down cpuhp and unregisters the PMU but
never stops the overflow-poll hrtimer. The PMU object and MMIO are
`devm`-managed, so they are freed as soon as `remove()` returns. If the
timer is still queued, `cn10k_ddr_pmu_timer_handler()` can run on freed
memory. That is a real UAF on Marvell CN10K systems that use this driver
— exactly the hardware this 6.1 tree already supports.

It meets stable rules: obviously correct, small, no new API, and the
buggy function is in this checkout. Risk is negligible. Benefit is
preventing a kernel UAF. The only backport edit is matching 6.1’s `int`
`remove` callback.

===============================================================
Verification
===============================================================

- [Phase 1] Parsed subject/body/tags: UAF-on-remove; SOBs Geetha
  sowjanya + Will Deacon; no Fixes/Reported-by/Cc-stable.
- [Phase 2] Diff: +6 in `cn10k_ddr_perf_remove()` only; adds
  `hrtimer_cancel()` before cpuhp/PMU teardown.
- [Phase 2] `perf_pmu_unregister()` at `kernel/events/core.c:11587` does
  not cancel driver timers or wait for `event_del`.
- [Phase 2] Handler at lines 600–612 always `HRTIMER_RESTART` and uses
  `pmu->base` / `pmu->events[]`.
- [Phase 3] `git describe HEAD` → `p-6.1-10-g80966a5b14be4`; `make
  kernelversion` → 6.1.188.
- [Phase 3] `git merge-base --is-ancestor 7cf83e222bce0 HEAD` →
  introducing driver commit is in this tree.
- [Phase 3] `git blame` on `remove()` → `7cf83e222bce0` (no cancel) and
  `68fa55f0e05ce` (cpuhp).
- [Phase 3] File history: 4 commits; no existing remove-path timer fix.
- [Phase 4] `b4 am` msgid `20260601073318.7098-4-gakula@marvell.com` →
  v8 3/3; cover letter “pre-existing for CN10K/Odyssey”.
- [Phase 4] Patchew: Will Deacon applied 3/3 as `7dbcb0268d1e`; no NAK.
- [Phase 4] lore.kernel.org and git.kernel.org fetches: 403 / Anubis —
  used b4/patchew/mirrors instead.
- [Phase 5] `event_sched_in` add-failure path (`core.c:2591`) does not
  call `pmu->del()`.
- [Phase 5] Local `event_init` does not validate `attr.config`;
  `event_add` can start the timer then return `-EINVAL`.
- [Phase 6] Read local `cn10k_ddr_perf_remove()`: no `hrtimer_cancel`;
  `devm_kzalloc` + `suppress_bind_attrs = true` confirmed.
- [Phase 7] Kconfig `MARVELL_CN10K_DDR_PMU` depends on `ARCH_THUNDER`.
- [Phase 8] Failure mode: UAF in hrtimer callback after `devm` free —
  HIGH.
- UNVERIFIED: `-stable` list discussion of this exact commit
  (lore/stable 403).
- UNVERIFIED: Linus-tree SHA beyond Will’s arm64 id `7dbcb0268d1e`.

**YES**

 drivers/perf/marvell_cn10k_ddr_pmu.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/perf/marvell_cn10k_ddr_pmu.c b/drivers/perf/marvell_cn10k_ddr_pmu.c
index 72ac17efd846a..9974b62541f0d 100644
--- a/drivers/perf/marvell_cn10k_ddr_pmu.c
+++ b/drivers/perf/marvell_cn10k_ddr_pmu.c
@@ -1088,6 +1088,12 @@ static void cn10k_ddr_perf_remove(struct platform_device *pdev)
 {
 	struct cn10k_ddr_pmu *ddr_pmu = platform_get_drvdata(pdev);
 
+	/*
+	 * Cancel the poll timer before further teardown so the handler
+	 * cannot run after this function returns.
+	 */
+	hrtimer_cancel(&ddr_pmu->hrtimer);
+
 	cpuhp_state_remove_instance_nocalls(
 				CPUHP_AP_PERF_ARM_MARVELL_CN10K_DDR_ONLINE,
 				&ddr_pmu->node);
-- 
2.53.0

