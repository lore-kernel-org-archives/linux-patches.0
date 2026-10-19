Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EB9E638AEE;
	Mon, 19 Oct 2026 14:05:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418754; cv=none; b=stATRH+jArRZwb3+rEjFmUk5gSKRYJ8J/kQLGz8gudqp6T9mdi+1pv+REQtS4ohXliwz/npdsEz0Eaeq51SU19wj8XB48rjX1AxkwAG2+CGTMOUrehWS1ZDyXi/e1anJEz44DggTcrR0dP2M/Nc2EIS8Y1LAjFFNbmSMglldpo4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418754; c=relaxed/simple;
	bh=CsUbPH3jTacXCVO8MlogOfaQDmir9kkrSVKFVFzIRPw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=il6wu4hTDIeNIy2RrkuszsM2pe+gMNDJwbN77kBOUTyJBb7m7GFGcNlMFDB0YKnMprrg/tV957VyBlELgj7qxx0a1awkFCK1q7rnzNUA0th5aQYy48R2h1QxEYPiWxfeQwIQ+WEi1gU42vuzSUe8gD8nBLD9RObhB2Dd35gaNXM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oDvnWbov; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oDvnWbov"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A24291F000C9;
	Mon, 19 Oct 2026 14:05:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418751;
	bh=IJ6/zTLwp21/j+Ltkgr4uo8k0Js/leTHH4yBKPlXV08=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oDvnWbovA1SsJpGApMt1M/fyz1gE7tXtAOXu3Jlt/MURAIdtVkgN/ZF1svdq36MjM
	 ZKUBgs2eY6dKuj59rkIs/6hUDn098wqHEreRfWzim/BTEhsKFrL9TN90CdTok+CS4d
	 daq5ySCHeRnpPIuzRuiozVbFQBGByDiT1Q25XQQFmHaRbuHDAMlsw2eRozxMlhUok0
	 jdRAtu9mNSbEDdaefj1m1gKa2zlsasya8ZtQhh8LbZGz0I2CX7SdFLAZ+HDrZvyP6f
	 t9FtEOyvKqjWWkqDqs10OJQJrOjvN7lOHy7rGH9ZDyKRymd0CCdH429bgJ3KtBr6jH
	 zlJEKzFIA2zug==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Stefan Hansson <newbyte@postmarketos.org>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.6] wifi: rsi: Fix types to appease CFI
Date: Mon, 19 Oct 2026 09:52:41 -0400
Message-ID: <20261019135441.1420968-470-sashal@kernel.org>
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

From: Stefan Hansson <newbyte@postmarketos.org>

[ Upstream commit da308f6e471252ae5e8009dcea16bc5e9c9dc5dd ]

Avoids errors like:

    CFI failure at kthread+0x124/0x1cc (target: rsi_coex_scheduler_thread+0x0/0x1b4 [redpine_91x]; expected type: 0x89fb613d)

As seen in the aforementioned error this was tested using the downstream
redpine_91x driver found in the Librem 5's downstream source tree.
However, it appears that this driver is a modified version of the rsi
driver found in mainline Linux and as such I decided to port the changes
here too.

Signed-off-by: Stefan Hansson <newbyte@postmarketos.org>
Link: https://patch.msgid.link/20260804-rsi-cfi-fix-v2-1-59679a520240@postmarketos.org
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

I have enough to decide: this is a 6.12 tree, the mismatched kthread
types are present, and a CFI failure here is a default kernel BUG.

===============================================================
PHASE 1: COMMIT MESSAGE FORENSICS
===============================================================

Step 1.1: PARSE THE SUBJECT LINE
Record: [wifi: rsi] [Fix] [Correct kthread callback types so Clang CFI
accepts them]

Step 1.2: PARSE ALL COMMIT MESSAGE TAGS
Record:
- Signed-off-by: Stefan Hansson &lt;newbyte@postmarketos.org&gt;
  (author)
- Link: https://patch.msgid.link/20260804-rsi-cfi-
  fix-v2-1-59679a520240@postmarketos.org
- Signed-off-by: Johannes Berg &lt;johannes.berg@intel.com&gt; (linux-
  wireless maintainer)
- No Fixes: tag (expected)
- No Cc: stable (expected)
- No Reported-by / Tested-by / Reviewed-by / Acked-by on the committed
  message
- Ignore any pipeline “Upstream commit” / “Signed-off-by: Sasha Levin”
  markers (none present in the provided message)

Notable: maintainer SOB; author is from postmarketOS; testing mentioned
in the body, not as Tested-by.

Step 1.3: ANALYZE THE COMMIT BODY TEXT
Record:
- Bug: CFI type mismatch when kthread starts
  `rsi_coex_scheduler_thread`.
- Symptom: `CFI failure at kthread+0x124/0x1cc (target:
  rsi_coex_scheduler_thread+0x0/0x1b4 [redpine_91x]; expected type:
  0x89fb613d)`
- Version info: none. Tested on Librem 5 downstream `redpine_91x`,
  described as a modified rsi driver; author ported the same type fix to
  mainline rsi.
- Root cause (from message + code): thread helpers are not `int (*)(void
  *)` as `kthread_run()` requires; `rsi_create_kthread()` takes `void
  *func_ptr`, so the compiler cannot catch it.

Step 1.4: DETECT HIDDEN BUG FIXES
Record: Not a disguised cleanup. The subject says “Fix types”; it is a
real CFI/runtime type-check failure, not style-only.

===============================================================
PHASE 2: DIFF ANALYSIS - LINE BY LINE
===============================================================

Step 2.1: INVENTORY THE CHANGES
Record:
- `drivers/net/wireless/rsi/rsi_91x_coex.c` —
  `rsi_coex_scheduler_thread`
- `drivers/net/wireless/rsi/rsi_91x_main.c` — `rsi_tx_scheduler_thread`
- `drivers/net/wireless/rsi/rsi_91x_sdio_ops.c` — `rsi_sdio_rx_thread`
- `drivers/net/wireless/rsi/rsi_91x_usb_ops.c` — `rsi_usb_rx_thread`
- `drivers/net/wireless/rsi/rsi_common.h` — `rsi_create_kthread`
- `drivers/net/wireless/rsi/rsi_sdio.h` / `rsi_usb.h` — prototypes
- Scope: 7 files, 15 insertions / 11 deletions. Single-driver surgical
  type fix.

Step 2.2: UNDERSTAND THE CODE FLOW CHANGE
Record:
- Before: thread functions are `void foo(struct rsi_common *common)` and
  are passed through `void *func_ptr` into `kthread_run()`.
- After: they are `int foo(void *data)` with `struct rsi_common *common
  = data;`. `rsi_create_kthread()` takes `int (*func_ptr)(void *data)`.
- Bodies are unchanged. They still end in
  `kthread_complete_and_exit(...)`, which is `__noreturn`.
- Path: kthread creation at driver init / coex attach, not an error-only
  path.

Step 2.3: IDENTIFY THE BUG MECHANISM
Record: [Type / CFI mismatch]
- `kthread()` does `ret = threadfn(data)` with type `int (*)(void *)`
  (`kernel/kthread.c`).
- Clang CFI hashes that type. `void (*)(struct rsi_common *)` has a
  different hash → CFI failure.
- Default `CONFIG_CFI_CLANG` (non-permissive) treats that as
  `BUG_TRAP_TYPE_BUG` (`kernel/cfi.c`).
- Fix: match the kthread callback ABI so the type hash matches.

Step 2.4: ASSESS THE FIX QUALITY
Record:
- Obviously correct: this is the documented kthread callback type.
- Minimal: signatures + one local cast; no locking/API/behavior change.
- Regression risk: very low. `kthread_complete_and_exit` is
  `__noreturn`, so no missing `return 0`. Johannes initially worried
  about “control reaches end of non-void function”; that does not apply.
- Red flags: none.

===============================================================
PHASE 3: GIT HISTORY INVESTIGATION
===============================================================

Step 3.1: BLAME THE CHANGED LINES
Record:
- `rsi_tx_scheduler_thread` / `rsi_create_kthread`: `dad0d04fa7ba41`
  (“rsi: Add RS9113 wireless driver”, 2014-03-17) — present since the
  driver was added.
- `rsi_coex_scheduler_thread`: `2108df3c4b1856` (“rsi: add coex
  support”, 2018-03-13).
- Long-lived bug, not recent churn.

Step 3.2: FOLLOW THE FIXES: TAG
Record: No Fixes: tag. Buggy pattern is original driver code, not a
later regression.

Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES
Record:
- Related in-tree: `16d9f674c6198` “wifi: rsi: fix kthread lifetime race
  between self-exit and external-stop” (already in this tree). That
  changes stop/wait, not signatures. No prerequisite conflict.
- This CFI fix is not in the tree (`git log --grep` on
  `drivers/net/wireless/rsi` found nothing).
- Standalone; v2 only added kernel-doc, not extra code deps.

Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS
Record: Stefan Hansson is not the rsi maintainer; patch is from
postmarketOS/Librem 5. Applied by Johannes Berg. No other rsi CFI
commits by this author in this tree.

Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS
Record: None. Uses existing `kthread_run` / `kthread_complete_and_exit`.
Can apply standalone.

===============================================================
PHASE 4: MAILING LIST AND EXTERNAL RESEARCH
===============================================================

Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION
Record:
- `b4 dig -c &lt;sha&gt;` not usable (candidate SHA not in this
  checkout).
- `b4 mbox` on msgid `20260804-rsi-cfi-
  fix-v2-1-59679a520240@postmarketos.org`: v2, 1-message thread.
- v1: https://patch.msgid.link/20260802-rsi-cfi-
  fix-v1-1-5821d2cb54ee@postmarketos.org
- v2 vs v1: kernel-doc only (`@common` → `@data`, `Return: 0`).
- Reviewers: Jeff Johnson (kernel-doc / From: vs SOB mismatch; said he
  was going to R-B after fixing many Android CFI type bugs). Johannes
  Berg first complained about nipa kernel-doc, then confirmed it builds,
  then applied v2. No NAK. No Cc: stable in review.

Step 4.2: CHECK WHO REVIEWED THE PATCH
Record: Recipients: linux-wireless, linux-kernel, phone-devel,
postmarketos/upstreaming. Maintainer Johannes Berg applied it. Jeff
Johnson (Qualcomm/ath) reviewed v1.

Step 4.3: SEARCH FOR THE BUG REPORT
Record: No syzbot/bugzilla. Concrete CFI log from Librem 5 downstream
`redpine_91x`. Same mismatch exists in mainline rsi (verified in this
tree).

Step 4.4: CHECK FOR RELATED PATCHES AND SERIES
Record: Single patch, v1→v2 kernel-doc only. Not a multi-patch series.

Step 4.5: CHECK STABLE MAILING LIST HISTORY
Record: lore.kernel.org/stable search returned 403. Web search found no
stable-list discussion of this CFI fix. No evidence it was rejected for
stable.

===============================================================
PHASE 5: CODE SEMANTIC ANALYSIS
===============================================================

Step 5.1: IDENTIFY KEY FUNCTIONS IN THE DIFF
Record: `rsi_coex_scheduler_thread`, `rsi_tx_scheduler_thread`,
`rsi_sdio_rx_thread`, `rsi_usb_rx_thread`, `rsi_create_kthread`.

Step 5.2: TRACE CALLERS
Record:
- `rsi_create_kthread()` → `kthread_run(func_ptr, common, ...)`
- Callers: `rsi_91x_init` (Tx-Thread), `rsi_coex_attach` (Coex-Tx-
  Thread), SDIO probe (`rsi_sdio_rx_thread`), USB init
  (`rsi_usb_rx_thread`).
- Context: process context at probe/init, not IRQ.

Step 5.3: TRACE CALLEES
Record: `rsi_wait_event` / `rsi_reset_event`, TX/RX processing, then
`kthread_complete_and_exit`. No alloc/lock changes.

Step 5.4: FOLLOW THE CALL CHAIN
Record: Userspace-reachable via loading the rsi USB/SDIO module and
bringing the interface up. With CFI, failure is at kthread start
(`threadfn(data)` in `kthread()`), i.e. as soon as the driver creates
its threads.

Step 5.5: SEARCH FOR SIMILAR PATTERNS
Record: All four rsi kthread entry points had the same wrong type; this
patch fixes all of them. Precedent in-tree: `e1ea6db35fc3b` “wifi:
brcmsmac: avoid function pointer casts” (KCFI / clang-16). Jeff Johnson
noted many similar Android CFI callback-type fixes.

===============================================================
PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE
===============================================================

Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?
Record: Yes. Local tree is **6.12.111** (`git describe`:
`p-6.12-2-gd38d58a4e0359`). Current signatures are still `void
foo(struct rsi_common *)` and `void *func_ptr`. Introduced 2014/2018;
both are ancestors of HEAD. CFI exists here: `CONFIG_CFI_CLANG` in
`arch/Kconfig`; arm64/x86_64/arm select `ARCH_SUPPORTS_CFI_CLANG`.

Step 6.2: CHECK FOR BACKPORT COMPLICATIONS
Record: Context matches the patch hunks. Expected apply: **clean**.
Nearby `16d9f674c6198` does not touch these signatures.

Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE
Record: Kthread lifetime UAF fix is here; this CFI type fix is not. No
alternate CFI workaround in rsi.

===============================================================
PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT
===============================================================

Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY
Record: [wifi rsi / `drivers/net/wireless/rsi`] [PERIPHERAL] —
Redpine/Silabs RS911x USB/SDIO. Used on some phones/SBCs (Librem 5). Not
core mm/net. No dedicated MAINTAINERS entry; linux-wireless (Johannes
Berg) applied it.

Step 7.2: ASSESS SUBSYSTEM ACTIVITY
Record: Mature, low-churn driver with occasional stable-worthy fixes
(OOB, kthread UAF). Bug is old, not from recent refactor.

===============================================================
PHASE 8: IMPACT AND RISK ASSESSMENT
===============================================================

Step 8.1: DETERMINE WHO IS AFFECTED
Record: Driver-specific + config-specific: `CONFIG_RSI_91X` and
`CONFIG_CFI_CLANG`. Default CFI is not permissive. CFI is common on
Android GKI and hardened/mobile builds; not in this tree’s arch
defconfigs.

Step 8.2: DETERMINE THE TRIGGER CONDITIONS
Record: Driver probe / thread create. Common if you have the hardware
and CFI. Unprivileged users do not set this up; loading the driver
(boot/hotplug) is enough. Not a race.

Step 8.3: DETERMINE THE FAILURE MODE SEVERITY
Record: Non-permissive CFI → `BUG_TRAP_TYPE_BUG` → kernel oops/panic
when the thread starts. WiFi (and coex BT) does not come up. Severity:
**HIGH** for CFI+rsi; **none** without CFI (wrong types happen to work
on normal ABIs).

Step 8.4: CALCULATE RISK-BENEFIT RATIO
Record:
- Benefit: prevents CFI panics on rsi probe; restores WiFi on CFI
  kernels.
- Risk: very low (~15 lines, type-only, no behavior change without CFI).
- Ratio: favorable. Small correctness fix, real crash for the configs
  that hit it.

===============================================================
PHASE 9: FINAL SYNTHESIS
===============================================================

Step 9.1: COMPILE THE EVIDENCE
FOR:
- Real CFI failure log; default CFI is a kernel BUG.
- Buggy signatures are in this 6.12 tree and date to 2014/2018.
- Tiny, obviously correct ABI match to `kthread_run`.
- Applies cleanly; no deps.
- Johannes Berg applied v2; Jeff Johnson reviewed v1.
- Same class as other KCFI function-type fixes (e.g. brcmsmac).
- Real hardware path (Librem 5 / postmarketOS).

AGAINST:
- Only crashes with `CONFIG_CFI_CLANG`; most generic 6.12 distro configs
  leave CFI off.
- Niche driver; tested on downstream `redpine_91x`, not a mainline rsi
  repro (mainline still has the same types).
- No Fixes:/Cc: stable (not a negative by itself).
- No syzbot.

UNRESOLVED:
- Could not `b4 dig -c` a mainline SHA (commit not in this checkout).
- lore.kernel.org fetches returned 403; reviews recovered from
  openwall/lkml.iu.edu/spinics.
- No stable-list discussion found.

Step 9.2: APPLY THE STABLE RULES CHECKLIST
1. Obviously correct and tested? **PASS** — types match kthread API; CFI
   failure observed; maintainer applied v2.
2. Fixes a real bug that affects users? **PASS** — CFI kernels panic at
   rsi thread start.
3. Important issue? **PASS** — kernel BUG/panic (HIGH for CFI+rsi).
4. Small and contained? **PASS** — 7 files, ~26 lines, one driver.
5. No new features or APIs? **PASS**
6. Can apply to the local tree? **PASS** — 6.12.111 has the buggy code;
   context matches.

Step 9.3: CHECK FOR EXCEPTION CATEGORIES
Record: Not a device-ID/quirk/DT/docs exception. Closest: type-
correctness / CFI crash fix (normal stable bugfix).

Step 9.4: MAKE YOUR DECISION
This is a real, user-visible panic on CFI-enabled 6.12 systems that use
rsi, not a compiler-warning cleanup. The local tree has CFI and the
mismatched callbacks. The change is a surgical signature fix with
negligible regression risk. That meets the stable bar for this tree.

===============================================================
What the commit solves (for this tree)
===============================================================

On 6.12, `kthread()` indirectly calls the thread function as `int
(*)(void *)`. rsi hid `void (*)(struct rsi_common *)` behind `void
*func_ptr`. With `CONFIG_CFI_CLANG`, that is a type-hash mismatch and a
kernel BUG as soon as Tx/Rx/coex threads start. The patch makes the
callbacks match the kthread ABI. Without CFI the mismatch is latent;
with CFI it is a crash. Benefit vs risk is strongly in favor of
backporting.

Verification:
- [Phase 1] Parsed subject/tags/body: CFI failure log; SOB Hansson +
  Johannes Berg; Link to v2 msgid; no Fixes/Cc:stable/Reported-by
- [Phase 2] Diff: four thread fns `void (struct rsi_common *)` → `int
  (void *)`; `rsi_create_kthread` `void *` → `int (*)(void *)`; ~15/+11
  lines
- [Phase 2] `include/linux/kthread.h`: `kthread_run` /
  `kthread_create_on_node` take `int (*threadfn)(void *data)`
- [Phase 2] `kernel/kthread.c:389`: `ret = threadfn(data);` — CFI-
  checked indirect call
- [Phase 2] `kernel/cfi.c`: default non-permissive path returns
  `BUG_TRAP_TYPE_BUG`; `CFI_PERMISSIVE` is warn-only
- [Phase 2] `kthread_complete_and_exit` is `__noreturn` in
  `include/linux/kthread.h:101`
- [Phase 3] blame: `dad0d04fa7ba41` (2014) and `2108df3c4b1856` (2018);
  both ancestors of HEAD
- [Phase 3] `git log --grep='wifi: rsi: Fix types to appease CFI' --
  drivers/net/wireless/rsi`: not in this tree
- [Phase 3] Related `16d9f674c6198` kthread lifetime fix is already
  here; no signature overlap
- [Phase 4] `b4 mbox` msgid: v2 saved; v2 changelog = kernel-doc only;
  v1 Link in changelog
- [Phase 4] Jeff Johnson v1 review (openwall): kernel-doc; would R-B;
  Android CFI type-fix experience
- [Phase 4] Johannes Berg (lkml.iu.edu): nipa kernel-doc confusion, then
  confirmed build, applied
- [Phase 4] lore.kernel.org WebFetch: 403; stable-list discussion
  UNVERIFIED via lore
- [Phase 5] Callers: `rsi_91x_init`, `rsi_coex_attach`, SDIO probe, USB
  init — all `rsi_create_kthread`
- [Phase 6] `git describe HEAD` = `p-6.12-2-gd38d58a4e0359`; `make
  kernelversion` = 6.12.111
- [Phase 6] Current rsi files still have the old signatures; patch
  context matches
- [Phase 6] `CONFIG_CFI_CLANG` present; arm64/x86_64/arm support CFI
- [Phase 7] rsi has no MAINTAINERS stanza; linux-wireless took the patch
- [Phase 8] Failure mode: CFI BUG at kthread start, HIGH for CFI+rsi
- UNVERIFIED: mainline SHA (not in this checkout); whether Android GKI
  6.12 enables rsi; live mainline rsi CFI repro (same types verified
  here)

**YES**

 drivers/net/wireless/rsi/rsi_91x_coex.c     | 3 ++-
 drivers/net/wireless/rsi/rsi_91x_main.c     | 7 ++++---
 drivers/net/wireless/rsi/rsi_91x_sdio_ops.c | 3 ++-
 drivers/net/wireless/rsi/rsi_91x_usb_ops.c  | 7 ++++---
 drivers/net/wireless/rsi/rsi_common.h       | 2 +-
 drivers/net/wireless/rsi/rsi_sdio.h         | 2 +-
 drivers/net/wireless/rsi/rsi_usb.h          | 2 +-
 7 files changed, 15 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_coex.c b/drivers/net/wireless/rsi/rsi_91x_coex.c
index 372eaaa2b9efc..05525d5e2edb1 100644
--- a/drivers/net/wireless/rsi/rsi_91x_coex.c
+++ b/drivers/net/wireless/rsi/rsi_91x_coex.c
@@ -50,8 +50,9 @@ static void rsi_coex_sched_tx_pkts(struct rsi_coex_ctrl_block *coex_cb)
 	} while (coex_q != RSI_COEX_Q_INVALID);
 }
 
-static void rsi_coex_scheduler_thread(struct rsi_common *common)
+static int rsi_coex_scheduler_thread(void *data)
 {
+	struct rsi_common *common = data;
 	struct rsi_coex_ctrl_block *coex_cb = common->coex_cb;
 	u32 timeout = EVENT_WAIT_FOREVER;
 
diff --git a/drivers/net/wireless/rsi/rsi_91x_main.c b/drivers/net/wireless/rsi/rsi_91x_main.c
index 2112d8d277a99..0b4d691580054 100644
--- a/drivers/net/wireless/rsi/rsi_91x_main.c
+++ b/drivers/net/wireless/rsi/rsi_91x_main.c
@@ -246,12 +246,13 @@ EXPORT_SYMBOL_GPL(rsi_read_pkt);
 /**
  * rsi_tx_scheduler_thread() - This function is a kernel thread to send the
  *			       packets to the device.
- * @common: Pointer to the driver private structure.
+ * @data: Pointer to the driver private structure.
  *
- * Return: None.
+ * Return: 0.
  */
-static void rsi_tx_scheduler_thread(struct rsi_common *common)
+static int rsi_tx_scheduler_thread(void *data)
 {
+	struct rsi_common *common = data;
 	struct rsi_hw *adapter = common->priv;
 	u32 timeout = EVENT_WAIT_FOREVER;
 
diff --git a/drivers/net/wireless/rsi/rsi_91x_sdio_ops.c b/drivers/net/wireless/rsi/rsi_91x_sdio_ops.c
index 597b238e22949..18a28aa974460 100644
--- a/drivers/net/wireless/rsi/rsi_91x_sdio_ops.c
+++ b/drivers/net/wireless/rsi/rsi_91x_sdio_ops.c
@@ -62,8 +62,9 @@ int rsi_sdio_master_access_msword(struct rsi_hw *adapter, u16 ms_word)
 
 static void rsi_rx_handler(struct rsi_hw *adapter);
 
-void rsi_sdio_rx_thread(struct rsi_common *common)
+int rsi_sdio_rx_thread(void *data)
 {
+	struct rsi_common *common = data;
 	struct rsi_hw *adapter = common->priv;
 	struct rsi_91x_sdiodev *sdev = adapter->rsi_dev;
 
diff --git a/drivers/net/wireless/rsi/rsi_91x_usb_ops.c b/drivers/net/wireless/rsi/rsi_91x_usb_ops.c
index 25c2b232394a6..e899631b9aed2 100644
--- a/drivers/net/wireless/rsi/rsi_91x_usb_ops.c
+++ b/drivers/net/wireless/rsi/rsi_91x_usb_ops.c
@@ -21,12 +21,13 @@
 /**
  * rsi_usb_rx_thread() - This is a kernel thread to receive the packets from
  *			 the USB device.
- * @common: Pointer to the driver private structure.
+ * @data: Pointer to the driver private structure.
  *
- * Return: None.
+ * Return: 0.
  */
-void rsi_usb_rx_thread(struct rsi_common *common)
+int rsi_usb_rx_thread(void *data)
 {
+	struct rsi_common *common = data;
 	struct rsi_hw *adapter = common->priv;
 	struct rsi_91x_usbdev *dev = adapter->rsi_dev;
 	int status;
diff --git a/drivers/net/wireless/rsi/rsi_common.h b/drivers/net/wireless/rsi/rsi_common.h
index c40f8101febcb..4f6738ba72be2 100644
--- a/drivers/net/wireless/rsi/rsi_common.h
+++ b/drivers/net/wireless/rsi/rsi_common.h
@@ -58,7 +58,7 @@ static inline void rsi_reset_event(struct rsi_event *event)
 
 static inline int rsi_create_kthread(struct rsi_common *common,
 				     struct rsi_thread *thread,
-				     void *func_ptr,
+				     int (*func_ptr)(void *data),
 				     u8 *name)
 {
 	init_completion(&thread->completion);
diff --git a/drivers/net/wireless/rsi/rsi_sdio.h b/drivers/net/wireless/rsi/rsi_sdio.h
index 7c91b126b350f..eb2b7f36a7e4c 100644
--- a/drivers/net/wireless/rsi/rsi_sdio.h
+++ b/drivers/net/wireless/rsi/rsi_sdio.h
@@ -134,5 +134,5 @@ int rsi_sdio_master_access_msword(struct rsi_hw *adapter, u16 ms_word);
 void rsi_sdio_ack_intr(struct rsi_hw *adapter, u8 int_bit);
 int rsi_sdio_determine_event_timeout(struct rsi_hw *adapter);
 int rsi_sdio_check_buffer_status(struct rsi_hw *adapter, u8 q_num);
-void rsi_sdio_rx_thread(struct rsi_common *common);
+int rsi_sdio_rx_thread(void *data);
 #endif
diff --git a/drivers/net/wireless/rsi/rsi_usb.h b/drivers/net/wireless/rsi/rsi_usb.h
index 961851748bc4c..78067eaffe8b1 100644
--- a/drivers/net/wireless/rsi/rsi_usb.h
+++ b/drivers/net/wireless/rsi/rsi_usb.h
@@ -81,5 +81,5 @@ static inline int rsi_usb_event_timeout(struct rsi_hw *adapter)
 	return EVENT_WAIT_FOREVER;
 }
 
-void rsi_usb_rx_thread(struct rsi_common *common);
+int rsi_usb_rx_thread(void *data);
 #endif
-- 
2.53.0

