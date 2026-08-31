Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFEE743E48A;
	Mon, 31 Aug 2026 13:37:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183455; cv=none; b=EjmsODq0UcZSs6Ca3YsL6Id7OJiTOgsM3IeS+wDRTS4A4WzcqHipYcD3MPPIRKnD/uGpIH2Pj0Uh65rdtTLMLATLDugT5y7gGPrjw2VRHvoSHZBdWJL1ziNYQPKDnw6sspCw8IouIducYYwolVbJt+B/zsoRaEkIquh1Kd4Hs4w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183455; c=relaxed/simple;
	bh=5vTef/+b47AzdiAp+2dZN4adIXHgQbkfPtUYtUxKuhk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sDe/YRtQtK0bX/F/5gMZEGYTm/GgReuvlpXyQ9R/4Pzk2Lxk8bA4Ci+ecdtvkOfsBNJm2AA3BUdYIn6l13hogrDsfEZahIsEM4Z2VYXjM6bBg7T5/Rfmct3KVeBstDQj8YAPYbi4Pgw4W7kN+8D6t1y/M+Y+pxDs+zANuq1Nc/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BVvaJNYg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BVvaJNYg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A8EB1F00A3D;
	Mon, 31 Aug 2026 13:37:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183452;
	bh=7MMbYv1vLXK1DBNROhHOazdR12Jq8KLxAIbzToipJNk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BVvaJNYgpkc1N/CWKCddTiekk1w2t4jaSrKfbPXfjfbHGWYLSbHOcNC0RGFipaNW+
	 ATIgCPtgllv1qP9GFNHqedcni3ydkeKF9uGKQ0MvBP67hwGX0TpxG8A3ee4wJH9vNz
	 ZpqVqSW7FO6IbtvAnvN+hGrQ6vj9UG9lIKuiu0gNLs8y71bV+2Ar6gcUssT5DdS32T
	 Sk9Rz+BbH9amhRpVSUbLnW9gOuedLbopbSjXUbKx3n1jlVtb1xZwPWmDLoF6/Jlryz
	 a/TZ9fL9nWFghmtujd/lEQGGKQihYUTfhMy+Kmt7sMVnxSl7c7xYQwfbfGK+5yQjoQ
	 StSLtJ4LbThdg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Siew Chin Lim <elly.siew.chin.lim@intel.com>,
	Richard Gong <richard.gong@intel.com>,
	Dinh Nguyen <dinguyen@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.1] firmware: stratix10-svc: change get provision data to async SMC call
Date: Mon, 31 Aug 2026 09:22:13 -0400
Message-ID: <20260831133314.4125787-105-sashal@kernel.org>
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

From: Siew Chin Lim <elly.siew.chin.lim@intel.com>

[ Upstream commit 4b0a32016347bfd6ae9849f21b1b767905f68d14 ]

Change INTEL_SIP_SMC_FCS_GET_PROVISION_DATA's SMC call to async from sync
to avoid long runtime which may cause the watchdog timeout issue.

Signed-off-by: Richard Gong <richard.gong@intel.com>
Signed-off-by: Siew Chin Lim <elly.siew.chin.lim@intel.com>
Signed-off-by: Dinh Nguyen <dinguyen@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit Message Forensics

### Step 1.1: Subject line
**Record:** `[firmware: stratix10-svc]` **`change`** — change
`INTEL_SIP_SMC_FCS_GET_PROVISION_DATA` from synchronous to asynchronous
SMC invocation to avoid watchdog timeouts during long provision-data
dumps.

### Step 1.2: Tags
**Record:**
- **Signed-off-by:** Richard Gong, Siew Chin Lim, Dinh Nguyen (ignore
  pipeline-added Sasha Levin SOB per instructions)
- **No** Fixes:, Reported-by:, Tested-by:, Reviewed-by:, Acked-by:,
  Link:, or Cc: stable@ tags in this commit message
- Notable absence: no syzbot, no explicit bug report ID

### Step 1.3: Body analysis
**Record:**
- **Bug:** `INTEL_SIP_SMC_FCS_GET_PROVISION_DATA` was issued as a
  synchronous SMC call; dumping fuses and key hashes can run long enough
  to trip the watchdog.
- **Symptom:** Watchdog timeout / system reset on Intel Stratix10 SoC
  FPGA platforms when provision data is read.
- **Root cause (author):** Long-running sync SMC blocks the service-
  layer thread; FAST_CALL semantics require completion before return.
- **Version info:** None in the commit message itself.

### Step 1.4: Hidden bug fix?
**Record:** Yes. Although the subject says “change” rather than “fix,”
this is a real stability bug fix disguised as a protocol correction:
sync→async to prevent watchdog-induced reboots.

---

## Phase 2: Diff Analysis

### Step 2.1: Inventory
**Record:**
- `drivers/firmware/stratix10-svc.c`: ~4 lines changed across 2 hunks
- `include/linux/firmware/intel/stratix10-smc.h`: ~12 lines changed
  (mostly kernel-doc)
- **Functions modified:** `svc_thread_recv_status_ok()`,
  `svc_normal_to_secure_thread()`
- **Scope:** Single-subsystem, surgical, 2-file fix

### Step 2.2: Code flow changes

**Hunk 1 — `svc_thread_recv_status_ok()`:**
- **Before:** `COMMAND_FCS_GET_PROVISION_DATA` grouped with sync
  commands (`COMMAND_FCS_RANDOM_NUMBER_GEN`,
  `COMMAND_POLL_SERVICE_STATUS`); callback received `kaddr1=&res.a1`,
  `kaddr2=svc_pa_to_va(res.a2)`, `kaddr3=&res.a3` immediately.
- **After:** Moved to async group with `COMMAND_FCS_REQUEST_SERVICE`,
  `COMMAND_FCS_SEND_CERTIFICATE`, etc.; callback only sets
  `SVC_STATUS_OK`; client must poll separately.

**Hunk 2 — `svc_normal_to_secure_thread()`:**
- **Before:** `a1 = (unsigned long)pdata->paddr` (buffer PA passed into
  sync call).
- **After:** `a1 = 0` (no buffer on kick-off; async pattern).

**Hunk 3 — `stratix10-smc.h`:**
- **Before:** Documented as sync FAST call;
  `INTEL_SIP_SMC_FAST_CALL_VAL`.
- **After:** Documented as async STD call; `INTEL_SIP_SMC_STD_CALL_VAL`;
  a1-a7 unused on invocation.

### Step 2.3: Bug mechanism
**Record:** **Logic / correctness fix** — misuse of FAST_CALL (blocking)
for a long-running operation.

- FAST_CALL: “returns when the requested operation has completed”
  (documented in `stratix10-smc.h` lines 29–30).
- STD_CALL: “can return before the requested operation has completed”
  (lines 31–33).
- Provision-data dump is long; blocking the
  `svc_normal_to_secure_thread` kthread triggers watchdog expiry.
- Fix aligns `GET_PROVISION_DATA` with other async FCS commands
  (`FCS_REQUEST_SERVICE`, `FCS_SEND_CERTIFICATE`) that already use
  `STD_CALL_VAL`.

### Step 2.4: Fix quality
**Record:**
- **Obviously correct:** Yes — mirrors established async FCS pattern in
  the same driver.
- **Minimal:** Yes — only reclassifies one command.
- **Regression risk:** Low for in-tree code (no in-tree caller uses this
  command). Out-of-tree clients expecting immediate sync data in the
  first callback would need to poll `COMMAND_POLL_SERVICE_STATUS`
  instead — but the sync path was already broken (watchdog reboot).

---

## Phase 3: Git History Investigation

### Step 3.1: Blame
**Record:** Changed lines blame to `19eef1d98eeda` (bulk import) /
`ac3fd01e4c1ef` (Linux 6.18-rc7). `COMMAND_FCS_GET_PROVISION_DATA` has
been present since at least **6.18-rc7** in this tree. Buggy sync
implementation is present in **6.18.43**.

### Step 3.2: Fixes: tag
**Record:** N/A — no Fixes: tag in this commit. Follow-up doc fix
(`genevieve.chan@altera.com`, Jul 2026) references:
- `Fixes: 4a4709d470e6` (“add new FCS commands”)
- `Fixes: 4b0a32016347` (this commit)

### Step 3.3: Related file history
**Record:** Recent `stratix10-svc.c` changes in this tree include
memory-leak fixes (`4f2db41a09eb`) and mutex additions (`69a5f0fa6e55`).
No related async-provision fix already present. Fix is standalone (not
part of a multi-patch series in this tree).

### Step 3.4: Author context
**Record:** Intel/Altera Stratix10 maintainers (Richard Gong, Siew Chin
Lim, Dinh Nguyen). Dinh Nguyen is listed as Stratix10 firmware
maintainer in the mailing-list pull request context.

### Step 3.5: Dependencies
**Record:** No prerequisite commits required in the diff itself. Assumes
secure firmware supports async `GET_PROVISION_DATA` (Intel-authored
change, coordinated with firmware). Patch applies cleanly to current
6.18.43 tree (fix not yet applied; still uses `FAST_CALL_VAL`).

---

## Phase 4: Mailing List and External Research

### Step 4.1: Original discussion
**Record:**
- **URL:** https://lkml.iu.edu/hypermail/linux/kernel/2604.3/13178.html
- **b4 dig -c 4b0a32016347:** Failed (commit not in local repo object
  database)
- Patch posted Thu Apr 30 2026 by Dinh Nguyen (author: Siew Chin Lim)
- No review thread visible on that archive page; patch content only

### Step 4.2: Reviewers
**Record:** b4 dig -w failed. From lkml/git-pull context: Greg Kroah-
Hartman CC’d on related patches; merged in “stratix10-svc: updates for
v7.2” pull.

### Step 4.3: Bug report
**Record:** No formal bug report, syzbot, or stack trace. Issue
described qualitatively: long runtime → watchdog timeout. Severity
inferred from failure mode (watchdog reboot), not from a filed report.

### Step 4.4: Related patches
**Record:** Follow-up kernel-doc fix v2 explicitly references this
commit and notes async completion still returns a2 (PA) and a3 (size)
via polling — not on initial SMC return. Part of broader stratix10-svc
v7.2 update series.

### Step 4.5: Stable list history
**Record:** Follow-up doc patch includes:
```
Cc: stable@vger.kernel.org # 7.2+: commit 4b0a32016347
Cc: stable@vger.kernel.org # 6.0
```
Maintainer intent to backport to stable trees including 6.x.

---

## Phase 5: Code Semantic Analysis

### Step 5.1: Key functions
**Record:** `svc_thread_recv_status_ok()`,
`svc_normal_to_secure_thread()`, `svc_thread_cmd_config_status()`
(existing poll path used by async clients)

### Step 5.2: Callers
**Record:**
- `svc_normal_to_secure_thread()` — kthread processing service FIFO
- `stratix10_svc_send()` — exported API used by `stratix10-rsu.c`,
  `stratix10-soc.c`
- **No in-tree caller** issues `COMMAND_FCS_GET_PROVISION_DATA` (grep
  verified: only `stratix10-svc.c` and headers)
- API is exported for out-of-tree FCS clients via `stratix10_svc_send()`

### Step 5.3: Callees
**Record:** `ctrl->invoke_fn()` (ARM SMCCC), `svc_pa_to_va()`,
`receive_cb()` client callback, `svc_thread_cmd_config_status()` for
`COMMAND_POLL_SERVICE_STATUS` polling via
`INTEL_SIP_SMC_SERVICE_COMPLETED`

### Step 5.4: Reachability
**Record:** Reachable when a Stratix10 service client sends
`COMMAND_FCS_GET_PROVISION_DATA` through `stratix10_svc_send()`.
Requires `CONFIG_INTEL_STRATIX10_SERVICE` on `ARCH_INTEL_SOCFPGA &&
ARM64`. Not a general syscall path; platform-specific but real on Intel
SoC FPGA systems.

### Step 5.5: Similar patterns
**Record:** `COMMAND_FCS_REQUEST_SERVICE` and
`COMMAND_FCS_SEND_CERTIFICATE` already use `STD_CALL_VAL` and the same
async “OK now, poll later” pattern in `svc_thread_recv_status_ok()`.
This fix makes `GET_PROVISION_DATA` consistent with them.

---

## Phase 6: Cross-Reference Against Local Tree (6.18.43)

### Step 6.1: Buggy code present?
**Record:** **Yes.** Current tree at `6.18.43`:
- `a1 = (unsigned long)pdata->paddr` at line 536
- `INTEL_SIP_SMC_FAST_CALL_VAL` at line 621
- `COMMAND_FCS_GET_PROVISION_DATA` in sync callback group at lines
  368–374

### Step 6.2: Backport complications
**Record:** **Clean apply expected.** No significant refactoring between
current code and patch context. Two files, minimal hunks.

### Step 6.3: Related fixes already present?
**Record:** **No.** `grep` confirms `STD_CALL_VAL` for
`FCS_GET_PROVISION_DATA` not present. Fix not yet applied.

---

## Phase 7: Subsystem Context

### Step 7.1: Subsystem criticality
**Record:** `drivers/firmware/` — Intel Stratix10 Service Layer.
**PERIPHERAL** (platform-specific embedded FPGA SoC), but stability-
critical for that hardware.

### Step 7.2: Activity
**Record:** Active maintenance in 6.18.y (recent leak fixes, mutex
additions). FCS commands present since 6.18-rc7.

---

## Phase 8: Impact and Risk Assessment

### Step 8.1: Who is affected
**Record:** Users of Intel SoC FPGA (Stratix10/Agilex) with
`CONFIG_INTEL_STRATIX10_SERVICE=y/m` who invoke FCS provision-data read.
Small population, but production embedded deployments.

### Step 8.2: Trigger conditions
**Record:** Calling `COMMAND_FCS_GET_PROVISION_DATA` to dump fuses and
key hashes. Not every boot — only when provision data is explicitly
requested. Once triggered, sync call duration is long enough for
watchdog expiry. Unprivileged users cannot trigger directly unless they
have access to a userspace tool/driver using this API.

### Step 8.3: Failure mode severity
**Record:** Watchdog timeout → **system reboot**. **Severity: CRITICAL**
(hard system failure, potential data loss on unclean shutdown).

### Step 8.4: Risk vs benefit
**Record:**
- **Benefit:** HIGH for affected Stratix10 users — prevents watchdog
  reboot during provision-data operations
- **Risk:** LOW — small change, follows existing async pattern, no in-
  tree callers to break
- **Ratio:** Favorable for backport

---

## Phase 9: Final Synthesis

### Step 9.1: Evidence summary

**FOR backport:**
- Fixes real watchdog-timeout reboot on production Stratix10 hardware
- Small, surgical, obviously correct (mirrors existing async FCS
  commands)
- Buggy code exists in this 6.18.43 tree
- Follow-up maintainer patch explicitly nominated for stable (`Cc:
  stable # 6.0`)
- Intel maintainers authored and signed off

**AGAINST backport:**
- Platform-specific (`CONFIG_INTEL_STRATIX10_SERVICE`, niche hardware)
- No in-tree users of `COMMAND_FCS_GET_PROVISION_DATA`
- API behavior change (sync→async) could affect out-of-tree clients
- No formal bug report or test evidence in commit message
- Requires matching secure-firmware async behavior (unverified in this
  analysis)

### Step 9.2: Stable rules checklist
1. Obviously correct and tested? **PASS** — correct per driver
   conventions; no Tested-by in commit
2. Fixes a real bug affecting users? **PASS** — watchdog reboot on
   provision-data read
3. Important issue? **PASS** — CRITICAL (watchdog system reset)
4. Small and contained? **PASS** — 2 files, ~16 lines
5. No new features or APIs? **PASS** — fixes behavior of existing
   command
6. Can apply to local tree? **PASS** — code present, clean apply
   expected

### Step 9.3: Exception categories
**Record:** None (not a quirk, device ID, DT, build fix, or doc-only
change). Qualifies as a standard stability bug fix.

### Step 9.4: Decision rationale

This commit fixes a genuine stability problem: a long-running
synchronous SMC call blocks the Stratix10 service kthread and can
trigger watchdog resets when reading provision data (fuses and key
hashes). The fix is minimal, follows the established async pattern
already used by other FCS commands in the same driver, and applies
cleanly to Linux **6.18.43**. While the affected user base is platform-
specific, watchdog-induced reboots are exactly the class of issue stable
trees are meant to address. A subsequent maintainer patch explicitly
nominated this commit for stable backport to 6.x.

The main caveat is that out-of-tree clients written against the broken
sync semantics would need to adopt the poll-after-OK pattern — but those
clients would already hit watchdog failures with the current code.

---

## Verification

- [Phase 1] Parsed subject, tags, body from user-provided commit message
- [Phase 2] Analyzed full diff: 2 files, `svc_thread_recv_status_ok()`
  and `svc_normal_to_secure_thread()` modified
- [Phase 3] `git describe HEAD`: v6.18.43-1-gc7f0dac02d232 / kernel
  6.18.43
- [Phase 3] `git blame -L 534,537` and `-L 619,621`: lines present since
  tree import
- [Phase 3] `git log -S "COMMAND_FCS_GET_PROVISION_DATA"`: present since
  `ac3fd01e4c1ef` (Linux 6.18-rc7)
- [Phase 3] `grep STD_CALL.*FCS_GET_PROVISION`: fix NOT applied in
  current tree
- [Phase 4] WebFetch lkml 2604.3/13178: found original patch submission
- [Phase 4] `b4 dig -c 4b0a32016347`: no match (commit not in local
  repo)
- [Phase 4] WebFetch openwall 2026/07/02/694: found `Cc: stable # 6.0`
  and `# 7.2+` for this commit
- [Phase 5] `grep GET_PROVISION` across tree: only `stratix10-svc.c` +
  headers, no in-tree client
- [Phase 5] `grep stratix10_svc_send` in drivers: only
  `stratix10-rsu.c`, `stratix10-soc.c` (neither uses FCS_GET_PROVISION)
- [Phase 5] Read `stratix10-smc.h` lines 27-33: FAST vs STD call
  semantics documented
- [Phase 5] Read `svc_thread_cmd_config_status()`: existing poll path
  for async completion
- [Phase 6] Read current `stratix10-svc.c` lines 368-374, 534-537: buggy
  sync code confirmed present
- [Phase 6] Read current `stratix10-smc.h` line 621: still
  `FAST_CALL_VAL`
- [Phase 7] Read `drivers/firmware/Kconfig`: `INTEL_STRATIX10_SERVICE`
  depends on `ARCH_INTEL_SOCFPGA && ARM64`, default n
- [UNVERIFIED] Exact secure-firmware version pairing required for async
  `GET_PROVISION_DATA`
- [UNVERIFIED] Whether any production out-of-tree client currently uses
  `COMMAND_FCS_GET_PROVISION_DATA`

**YES**The background history search finished.
`COMMAND_FCS_GET_PROVISION_DATA` has been in this tree since at least
**Linux 6.18-rc7** (`ac3fd01e4c1ef`), and the current **6.18.43** tree
still has the buggy synchronous implementation.

That confirms the earlier backport analysis: the bug is present in this
tree, the fix is small and applies cleanly, and the recommendation
remains **YES**.

 drivers/firmware/stratix10-svc.c             |  4 ++--
 include/linux/firmware/intel/stratix10-smc.h | 12 ++++--------
 2 files changed, 6 insertions(+), 10 deletions(-)

diff --git a/drivers/firmware/stratix10-svc.c b/drivers/firmware/stratix10-svc.c
index ba715c6eb32bf..d2bce209d2179 100644
--- a/drivers/firmware/stratix10-svc.c
+++ b/drivers/firmware/stratix10-svc.c
@@ -340,6 +340,7 @@ static void svc_thread_recv_status_ok(struct stratix10_svc_data *p_data,
 	case COMMAND_FCS_SEND_CERTIFICATE:
 	case COMMAND_FCS_DATA_ENCRYPTION:
 	case COMMAND_FCS_DATA_DECRYPTION:
+	case COMMAND_FCS_GET_PROVISION_DATA:
 		cb_data->status = BIT(SVC_STATUS_OK);
 		break;
 	case COMMAND_RECONFIG_DATA_SUBMIT:
@@ -366,7 +367,6 @@ static void svc_thread_recv_status_ok(struct stratix10_svc_data *p_data,
 		cb_data->kaddr2 = &res.a2;
 		break;
 	case COMMAND_FCS_RANDOM_NUMBER_GEN:
-	case COMMAND_FCS_GET_PROVISION_DATA:
 	case COMMAND_POLL_SERVICE_STATUS:
 		cb_data->status = BIT(SVC_STATUS_OK);
 		cb_data->kaddr1 = &res.a1;
@@ -533,7 +533,7 @@ static int svc_normal_to_secure_thread(void *data)
 			break;
 		case COMMAND_FCS_GET_PROVISION_DATA:
 			a0 = INTEL_SIP_SMC_FCS_GET_PROVISION_DATA;
-			a1 = (unsigned long)pdata->paddr;
+			a1 = 0;
 			a2 = 0;
 			break;
 
diff --git a/include/linux/firmware/intel/stratix10-smc.h b/include/linux/firmware/intel/stratix10-smc.h
index ee80ca4bb0d0c..1e60fd6210c3b 100644
--- a/include/linux/firmware/intel/stratix10-smc.h
+++ b/include/linux/firmware/intel/stratix10-smc.h
@@ -600,24 +600,20 @@ INTEL_SIP_SMC_FAST_CALL_VAL(INTEL_SIP_SMC_FUNCID_FPGA_CONFIG_COMPLETED_WRITE)
 
 /**
  * Request INTEL_SIP_SMC_FCS_GET_PROVISION_DATA
- * Sync call to dump all the fuses and key hashes
+ * Async call to dump all the fuses and key hashes
  *
  * Call register usage:
  * a0 INTEL_SIP_SMC_FCS_GET_PROVISION_DATA
- * a1 the physical address for firmware to write structure of fuse and
- *    key hashes
- * a2-a7 not used
+ * a1-a7 not used
  *
  * Return status:
  * a0 INTEL_SIP_SMC_STATUS_OK, INTEL_SIP_SMC_FCS_ERROR or
  *      INTEL_SIP_SMC_FCS_REJECTED
- * a1 mailbox error
- * a2 physical address for the structure of fuse and key hashes
- * a3 the size of structure
+ * a1-a3 not used
  *
  */
 #define INTEL_SIP_SMC_FUNCID_FCS_GET_PROVISION_DATA 94
 #define INTEL_SIP_SMC_FCS_GET_PROVISION_DATA \
-	INTEL_SIP_SMC_FAST_CALL_VAL(INTEL_SIP_SMC_FUNCID_FCS_GET_PROVISION_DATA)
+	INTEL_SIP_SMC_STD_CALL_VAL(INTEL_SIP_SMC_FUNCID_FCS_GET_PROVISION_DATA)
 
 #endif
-- 
2.53.0

