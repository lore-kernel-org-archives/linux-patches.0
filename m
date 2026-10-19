Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F201B53AE99;
	Mon, 19 Oct 2026 14:05:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418707; cv=none; b=cV5CVV+ZH5sJ38gbjNId4i7JrDc0agNP0eRU9BZMwwN2sG22MPPMjgobxSAjTtHadzEJ6m/46caLbM1IQu4XU0IWU70XkAldYZ9JDc1rtV0jMRC8VYsY1WQu0QLsaJtnHIuwuWIyNK2WhFIGLfGvFt3Dmz+5haMQtA195xhm2bc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418707; c=relaxed/simple;
	bh=UcTgleR38uRA8OqF7YnJModXjOBQQcumCR4Kp99xiQY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EMK/nougpm8nexVorCcFcuUzcXMq87vBjpY9GbOM2srJ4k50sODGZbZ0L1p5zX0mNNwhS7wHqrJh1brs8STe8OWpx3t6z869gmz2LoFdMZu/aj2pD8cfu1PbQL0+NnU9Lk0m7BF99xrbtMQpHWK91H8inGsBKE3UEUVtj3GiNLE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KC7DPrp3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KC7DPrp3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FC8D1F000C7;
	Mon, 19 Oct 2026 14:05:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418704;
	bh=qmcsefOq0crUHlcAtS2yhycjuR5NM8dhM9iIYVK57UY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KC7DPrp3dORk1Lp7BSKBZ5nMB89nHZXrWvr3Hgh3SwrdyAvxMNBgi0ykv6kREbHN2
	 BIGj11ZDCKIRkvlDCWa36+kgSdGHRI1tvxrcgn6C6UeJLj2I7iu15BoMHkoCLz4eR/
	 z0wpNZX3bzyV2VjPaygMNRe1nDJVXftexxVcWxgiunoNgs8kQ0CqLbHc3lE6V9FB97
	 GOraqeNZqJQ83DBhXlTrdLcbNeJ9VDD1sWr3MZE5kLyAHez2Tw11XpbWP22kQPbX0A
	 wT6GUe5FlztAnmJ8sGctnk9CJ0XEwLJpp+oenKpoVJRb1adOLP6CrMZJ/CtoOyIR1V
	 OU3+ki07unU0g==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>,
	sre@kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] hsi: omap_ssi: remove debugfs on port creation failure
Date: Mon, 19 Oct 2026 09:52:08 -0400
Message-ID: <20261019135441.1420968-437-sashal@kernel.org>
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

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit 760318e2e69857214314e94ac477219f0c89106b ]

ssi_probe() creates the controller debugfs tree before creating the SSI
port child devices. If a port device cannot be created, the error path
removes any children and tears down the controller, but leaves the
debugfs tree behind.

Remove the controller debugfs tree on the port creation failure path,
matching the normal remove path.

Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Link: https://patch.msgid.link/20260616004348.97684-1-pengpeng@iscas.ac.cn
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The local tree is **v7.3-rc4** (`7.3.0-rc4`). The change is a 3-line
probe error-path cleanup in `drivers/hsi/controllers/omap_ssi_core.c`.
The buggy probe path has been in this driver since 2014, and the
leftover debugfs files hold a raw pointer that is freed on that path.

===============================================================
PHASE 1: COMMIT MESSAGE FORENSICS
===============================================================

Step 1.1: PARSE THE SUBJECT LINE
Record: **[hsi: omap_ssi:] [remove] [controller debugfs is not torn down
if SSI port child creation fails in `ssi_probe()`]**

Step 1.2: PARSE ALL COMMIT MESSAGE TAGS
Record:
- **Fixes:** none (expected for this review pipeline)
- **Reported-by:** none
- **Tested-by:** none
- **Reviewed-by:** none
- **Acked-by:** none
- **Link:**
  `https://patch.msgid.link/20260616004348.97684-1-pengpeng@iscas.ac.cn`
- **Cc: stable:** none (expected; not treated as a negative)
- **Signed-off-by:** Pengpeng Hou (author); Sebastian Reichel (HSI
  maintainer)
- Pipeline SOBs such as Sasha Levin are ignored

Notable: maintainer SOB, no user/syzbot report. Single standalone patch,
not `N/M`.

Step 1.3: ANALYZE THE COMMIT BODY TEXT
Record:
- **Bug:** `ssi_probe()` builds the controller debugfs tree, then
  creates `ti,omap3-ssi-port` children. If `of_platform_device_create()`
  fails, `out3` unregisters children and tears down the controller, but
  does not remove debugfs.
- **Symptom:** leftover `/sys/kernel/debug/ssiN/` after a failed probe.
  The message describes a leak, not a crash.
- **Version info:** none in the message. The mismatch dates to the
  original driver.
- **Root cause (author):** error path does not match `ssi_remove()`.

Step 1.4: DETECT HIDDEN BUG FIXES
Record: **Yes — error-path resource leak, and a UAF if those files are
read.** This is not style cleanup. The body says “leaves the debugfs
tree behind”; the code also leaves `debugfs_create_file(..., ssi, ...)`
nodes whose private pointer is the controller that `out3` then
unregisters and frees.

===============================================================
PHASE 2: DIFF ANALYSIS - LINE BY LINE
===============================================================

Step 2.1: INVENTORY THE CHANGES
Record:
- **File:** `drivers/hsi/controllers/omap_ssi_core.c` (**+3 / −0**)
- **Function:** `ssi_probe()` error label `out3`
- **Scope:** single-file, surgical, one error path

```529:541:drivers/hsi/controllers/omap_ssi_core.c
        return err;
out3:
        device_for_each_child(&pd->dev, NULL, ssi_remove_ports);
#ifdef CONFIG_DEBUG_FS
        ssi_debug_remove_ctrl(ssi);
#endif
out2:
        ssi_remove_controller(ssi);
        pm_runtime_disable(&pd->dev);
```

Step 2.2: UNDERSTAND THE CODE FLOW CHANGE
Record:
- **Before:** `out3` only unregisters child port devices, then falls
  through to `out2` → `ssi_remove_controller(ssi)` (unregister + free
  controller). Controller debugfs created at `ssi_debug_add_ctrl()`
  stays.
- **After:** `out3` also calls `ssi_debug_remove_ctrl(ssi)` **before**
  `ssi_remove_controller()`, same order as `ssi_remove()`.
- **Path:** probe error path only; success and `ssi_remove()` unchanged.

Step 2.3: IDENTIFY THE BUG MECHANISM
Record:
- **Category:** error-path resource leak **and** use-after-free of
  debugfs private data.
- **Mechanism:** `ssi_debug_add_ctrl()` does
  `debugfs_create_dir(dev_name(&ssi->device), NULL)` (debugfs **root**,
  not device-managed) and `debugfs_create_file("regs", ..., ssi,
  &ssi_regs_fops)`. `out3` then `ssi_remove_controller()` →
  `hsi_unregister_controller()` → `device_unregister()` →
  `hsi_controller_release()` → `kfree(hsi)`. The dentries remain;
  `ssi_regs_show()` / `ssi_gdd_regs_show()` still use `m->private` as
  `ssi`.

Step 2.4: ASSESS THE FIX QUALITY
Record:
- **Quality:** obviously correct. Reuses the existing helper already
  used by `ssi_remove()`, placed before free, wrapped in
  `CONFIG_DEBUG_FS` like the add/remove paths.
- **Regression risk:** very low. `debugfs_remove_recursive()` is already
  used on the normal remove path. If `CONFIG_DEBUG_FS=n`, the hunk is
  compiled out. No lock, API, or data-structure change.

===============================================================
PHASE 3: GIT HISTORY INVESTIGATION
===============================================================

Step 3.1: BLAME THE CHANGED LINES
Record:
- Buggy `out3` / port-create loop / debugfs add-before-ports:
  **`b209e047bc7432`** (“HSI: Introduce OMAP SSI driver”, 2014-05-16).
- Later nearby fixes (OF refcount, `pm_runtime_disable` placement) did
  **not** add debugfs teardown on `out3`.
- Bug age: present since the driver was added (~v3.16 era).

Step 3.2: FOLLOW THE FIXES: TAG
Record: **No Fixes: tag.** Introducer is `b209e047bc7432`, confirmed
ancestor of this HEAD. No later alternate fix of the same hole in this
file besides **`760318e2e6985`**.

Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES
Record:
- Same-file probe leak/refcount fixes: `1aff514e1d2bd` (missing
  `hsi_put_controller`), `f5181c35ed7ba` (unbalanced
  `pm_runtime_disable`), `9a2ea132df860` (OF node put on this same
  failure).
- `c3eddf5e8c30a` dropped debugfs create error checks (debugfs API is
  error-safe); **not** a prerequisite for calling
  `ssi_debug_remove_ctrl()`.
- **Standalone**, not `N/M`. Follow-ups `659287caa77a7` /
  `e81250ec6b692` are unrelated.

Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS
Record:
- Pengpeng Hou: this is the only `drivers/hsi/` commit in this tree.
- Applied by **Sebastian Reichel**, HSI maintainer (`MAINTAINERS`: HSI
  SUBSYSTEM).

Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS
Record:
- Needs `ssi_debug_remove_ctrl()`, `out3`, and `ssi_debug_add_ctrl()` —
  all from the original driver.
- **Can apply standalone** on any tree that still has this probe layout.

===============================================================
PHASE 4: MAILING LIST AND EXTERNAL RESEARCH
===============================================================

Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION
Record:
- **Lore/msgid:**
  `https://patch.msgid.link/20260616004348.97684-1-pengpeng@iscas.ac.cn`
- **Revisions:** v1 only (`b4 dig -a`).
- **Review:** no technical comments, no NAK, no `Cc: stable` request.
  Maintainer reply 2026-07-26: “Applied, thanks!” → `760318e2e6985`.
- lore.kernel.org HTML fetch returned **403**; thread recovered via `b4
  dig -m`.

Step 4.2: CHECK WHO REVIEWED THE PATCH
Record (`b4 dig -w`): To/Cc were **Sebastian Reichel** and **linux-
kernel@**. Correct maintainer; no extra reviewers.

Step 4.3: SEARCH FOR THE BUG REPORT
Record: **No bugzilla/syzbot/user report.** Code-inspection fix.
Severity inferred from the error path, not from a crash report.

Step 4.4: CHECK FOR RELATED PATCHES AND SERIES
Record: **Standalone 1/1.** Port debugfs is added in `ssi_port_probe()`
and already removed in `ssi_port_remove()`; `out3` already unregisters
children. The hole is **controller** debugfs only.

Step 4.5: CHECK STABLE MAILING LIST HISTORY
Record: lore.kernel.org/stable HTML also **403**. `b4` thread has **no**
stable discussion. **UNVERIFIED** whether anyone asked for/against
stable inclusion on the stable list.

===============================================================
PHASE 5: CODE SEMANTIC ANALYSIS
===============================================================

Step 5.1: IDENTIFY KEY FUNCTIONS IN THE DIFF
Record: **`ssi_probe()`** only. Helper **`ssi_debug_remove_ctrl()`** is
called, not modified.

Step 5.2: TRACE CALLERS
Record:
- `ssi_probe` is `.probe` of `omap_ssi` (`compatible = "ti,omap3-ssi"`).
- Called from platform device probe (boot / module load / DT populate).
- Not IRQ, not a syscall hot path.

Step 5.3: TRACE CALLEES
Record: `device_for_each_child(..., ssi_remove_ports)` then
`ssi_debug_remove_ctrl()` → `debugfs_remove_recursive(omap_ssi->dir)`
then `ssi_remove_controller()` → `hsi_unregister_controller()` /
`device_unregister()` / `kfree(hsi)`.

Step 5.4: FOLLOW THE CALL CHAIN
Record:
- Reachable when `CONFIG_OMAP_SSI` probes a `ti,omap3-ssi` node (see
  `arch/arm/boot/dts/ti/omap/omap3.dtsi`) and a `ti,omap3-ssi-port`
  child fails `of_platform_device_create()` (typically ENOMEM /
  `of_device_add` failure).
- Userspace cannot force this sysfs/ioctl path; it is a **boot/probe**
  failure. After that, **root** can open leftover debugfs and hit UAF.
  `CONFIG_DEBUG_FS` required.

Step 5.5: SEARCH FOR SIMILAR PATTERNS
Record: Port debugfs is already balanced in `ssi_port_remove()`. No
second copy of this controller leak in `drivers/hsi/`.

===============================================================
PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE
===============================================================

Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?
Record:
- Tree: **`v7.3-rc4-27-gf0100363d8c37`**, `make kernelversion` =
  **7.3.0-rc4**.
- Driver and `out3` path exist. Commit **`760318e2e6985` is already an
  ancestor of HEAD** (merged via `hsi-for-7.3` on 2026-08-21). Pre-fix
  `out3` is still in history (`760318e2e6985^`).
- Bug introduced **2014** (`b209e047bc7432`), long before this tree.

Step 6.2: CHECK FOR BACKPORT COMPLICATIONS
Record: **Clean apply** on this layout. Same `out3`/`out2` labels since
the original driver. Context in older stables may lack later DMA-mask
lines; the hunk itself does not depend on them.

Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE
Record: OF-put / pm_runtime / `hsi_put_controller` fixes are present and
**do not** remove controller debugfs on `out3`. No earlier equivalent of
this fix.

===============================================================
PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT
===============================================================

Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY
Record: **HSI / OMAP SSI controller driver.** **PERIPHERAL.**
`CONFIG_OMAP_SSI` depends on `HSI && OF && COMMON_CLK` and `ARCH_OMAP3
|| COMPILE_TEST`. Legacy APE↔modem SSI (Nokia/OMAP3). Not mm/net/fs
core.

Step 7.2: ASSESS SUBSYSTEM ACTIVITY
Record: **Low-churn, maintained.** Recent HSI work is small fixes;
maintainer still applying patches.

===============================================================
PHASE 8: IMPACT AND RISK ASSESSMENT
===============================================================

Step 8.1: DETERMINE WHO IS AFFECTED
Record: **Driver-specific + config-specific:** OMAP3 boards with SSI in
DT, `CONFIG_OMAP_SSI`, and `CONFIG_DEBUG_FS`. Not universal.

Step 8.2: DETERMINE THE TRIGGER CONDITIONS
Record:
- Trigger: **failed child port device create during probe** (uncommon;
  not every boot).
- Not a race. Unprivileged users cannot reach the create-failure
  themselves; they also typically cannot read debugfs.
- Reprobe after failure can also leave a stale `ssiN` debugfs name at
  the debugfs root.

Step 8.3: DETERMINE THE FAILURE MODE SEVERITY
Record:
- Leftover debugfs dentries: leak until reboot.
- Read of leftover `regs` after `kfree(hsi)`: **UAF** (and possible MMIO
  via a stale `sys` pointer).
- **Severity: HIGH if triggered** (UAF), **likelihood LOW** (rare probe
  fail + DEBUG_FS + debugfs access). Not a normal-path panic.

Step 8.4: CALCULATE RISK-BENEFIT RATIO
Record:
- **Benefit:** medium for affected hardware (closes leak + UAF on a real
  error path that has been wrong since 2014); population is small.
- **Risk:** very low (3 lines, same as `ssi_remove()`).
- **Ratio:** favorable. Cost of backport is tiny; leaving a dangling
  debugfs ops table is a real memory-safety bug.

===============================================================
PHASE 9: FINAL SYNTHESIS
===============================================================

Step 9.1: COMPILE THE EVIDENCE

**FOR:**
- Real probe error-path bug: debugfs created, never removed on `out3`.
- Verified UAF: files keep `ssi` as private; `out3` frees the controller
  via `hsi_controller_release()`.
- 3-line, mirrors `ssi_remove()`, helper already exists.
- Bug in-tree since 2014; this checkout still has the driver.
- Maintainer applied v1 with no objections.
- Same class as other `ssi_probe()` leak/refcount stable-style fixes.

**AGAINST:**
- Niche OMAP3 SSI, `CONFIG_DEBUG_FS` only, rare
  `of_platform_device_create()` failure.
- No syzbot/user report; message only calls it a leak.
- No explicit stable nomination (not a negative per pipeline rules).

**UNRESOLVED:**
- Stable-list discussion (lore/stable HTTP 403).
- Exact rate of `of_platform_device_create()` failure on real OMAP3
  hardware.

Step 9.2: APPLY THE STABLE RULES CHECKLIST
1. Obviously correct and tested? **PASS** — matches existing remove
   path; maintainer applied.
2. Fixes a real bug that affects users? **PASS** — leak + UAF on failed
   SSI port create with debugfs.
3. Important issue (crash, security, corruption, deadlock)? **PASS** —
   UAF is crash/memory-safety; trigger is rare, but the class is in-
   scope for stable.
4. Small and contained? **PASS** — +3 lines, one function.
5. No new features or APIs? **PASS**
6. Can apply to the local tree? **PASS** — same `out3` structure; no
   missing helpers.

Step 9.3: CHECK FOR EXCEPTION CATEGORIES
Record: **Not** an ID/quirk/DT/build/docs exception. Ordinary small
driver bugfix.

Step 9.4: MAKE YOUR DECISION
This tree contains the OMAP SSI driver and the long-standing `out3`
hole. The patch is a minimal, obviously correct error-path teardown that
also prevents debugfs from retaining a freed `hsi_controller`. That is
enough for stable even though the hardware is legacy and the trigger is
uncommon. Risk is negligible.

What it solves for stable users: a failed `ti,omap3-ssi-port` create no
longer leaves `/sys/kernel/debug/ssiN/` pointing at freed memory after
`ssi_remove_controller()`.

Risk vs benefit: 3 lines vs a real UAF/leak; apply should be clean.

Concerns: none that block backport; no extra commits required. Absence
of `Fixes:` / `Cc: stable` is expected here and was not used as a reason
to reject.

Verification:
- [Phase 1] Parsed message/tags: author Pengpeng Hou, maintainer SOB
  Sebastian Reichel, Link msgid 20260616004348.97684-1, no
  Fixes/Reported-by/Cc:stable
- [Phase 2] Diff: +3 lines in `ssi_probe()` `out3`; calls
  `ssi_debug_remove_ctrl(ssi)` under `CONFIG_DEBUG_FS`
- [Phase 2] Confirmed `ssi_debug_add_ctrl()` uses parent `NULL` and
  private `ssi`; `ssi_regs_show()` dereferences that pointer
- [Phase 2] Confirmed `hsi_controller_release()` `kfree`s the controller
  after `device_unregister()`
- [Phase 3] `git blame` on pre-fix file: `out3` from `b209e047bc7432`
  (2014); that commit is an ancestor of HEAD
- [Phase 3] `git merge-base --is-ancestor 760318e2e6985 HEAD` →
  IS_ANCESTOR (source commit lives in this tree)
- [Phase 3] `git describe HEAD` → v7.3-rc4-27-gf0100363d8c37; `make
  kernelversion` → 7.3.0-rc4
- [Phase 3] Related probe fixes (`9a2ea132df860`, `f5181c35ed7ba`,
  `1aff514e1d2bd`) do not cover debugfs on `out3`
- [Phase 4] `b4 dig -c 760318e2e6985` →
  patch.msgid.link/20260616004348.97684-1-pengpeng@iscas.ac.cn
- [Phase 4] `b4 dig -a`: v1 only
- [Phase 4] `b4 dig -w`: To Sebastian Reichel + linux-kernel
- [Phase 4] `b4 dig -m`: maintainer “Applied, thanks!”; no NAK; no
  stable mention
- [Phase 4] WebFetch lore.kernel.org → 403; used mbox instead
- [Phase 5] `ssi_probe` is platform `.probe`; DT compatible
  `ti,omap3-ssi` in `omap3.dtsi`
- [Phase 6] Pre-fix `out3` verified with `git show
  760318e2e6985^:drivers/hsi/controllers/omap_ssi_core.c`
- [Phase 7] Kconfig: `OMAP_SSI` depends on `ARCH_OMAP3 || COMPILE_TEST`
- [Phase 8] Failure mode: leftover debugfs + UAF on read after free;
  severity HIGH if hit, trigger rare
- UNVERIFIED: stable@ mailing list archive (HTTP 403)
- UNVERIFIED: how often port `of_platform_device_create()` fails on real
  hardware

**YES**

 drivers/hsi/controllers/omap_ssi_core.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/hsi/controllers/omap_ssi_core.c b/drivers/hsi/controllers/omap_ssi_core.c
index 47826315d7d62..3163a063aaa23 100644
--- a/drivers/hsi/controllers/omap_ssi_core.c
+++ b/drivers/hsi/controllers/omap_ssi_core.c
@@ -535,6 +535,9 @@ static int ssi_probe(struct platform_device *pd)
 	return err;
 out3:
 	device_for_each_child(&pd->dev, NULL, ssi_remove_ports);
+#ifdef CONFIG_DEBUG_FS
+	ssi_debug_remove_ctrl(ssi);
+#endif
 out2:
 	ssi_remove_controller(ssi);
 	pm_runtime_disable(&pd->dev);
-- 
2.53.0

