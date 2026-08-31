Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DFD04B1B40;
	Mon, 31 Aug 2026 13:50:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184257; cv=none; b=rjt9J/5USazJtgpyaB+2lCHU3QaECgSc2Ad2sNmLxwK2ooJqbStG18imCCuDvaCxoATaW4oo3AF47gogjLiN4H6TMtY82eM60qFjuKxDZzJQBT9wwkxSH/1qMPwAyIskuAOR52DwVftFnn3tey/9aLWdVUrUrNNAQAKMmd1vyo0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184257; c=relaxed/simple;
	bh=+eSNSs3ChmeOq7/FGRCxinLEQbg1Ni6LIAwdXjUJQBY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TnmwV9IsJKz02fYK7kRir64AwDGAAbIwQmALNVI1lqx3JHwInwh3kAcyUNK8cO8ojUhol2LNHvLPzrFXJomc7d23xUlza4GFS2F7/Ydk61eo+qP5T1c85UWryxzW0zLZwdlFeBN2MtiK+ic0bDyO/Z3wIBB3mK6gcsNdYDX9amc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GBPfp00V; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GBPfp00V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 690DB1F000E9;
	Mon, 31 Aug 2026 13:50:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788184255;
	bh=CUXCA1AVcBmekaYl2KvyNrJjaOnT+ATPgyf3nqmXHi0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GBPfp00V5rWO5M7EAInMPU/KB0YhX56sXCHGxyTcbJ36WwBYUfzV4MalYRf/DnBFW
	 R6tFuto2JFk6JXhRnYvSG2GwoKYnKasH11ufqssRNbGTFtTgPDegaP9xeQFWrTlb95
	 mqCtxEw8X3xjd4nXC7BG9JajBVzlcrQ0pfpi7G8+5xV1dfQM84hBbL29Iw/45msO/6
	 5LyYMGLkwP2JwIdbr2OweyxUd60b4CWqu48mTg3xmIi8njrUASW0Jn+mIuf9wUqC37
	 D5HtxepKr2Yxho68bkvTE3cmlvYtkmKebm+2riTHIsI8O2NTiYedzoZAbWK3ufJOnH
	 Or6rCQRQXNmew==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Sudeep Holla <sudeep.holla@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	arm-scmi@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] firmware: arm_scmi: Validate BASE_ERROR_EVENT payload size
Date: Mon, 31 Aug 2026 09:30:12 -0400
Message-ID: <20260831133314.4125787-584-sashal@kernel.org>
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

From: Sudeep Holla <sudeep.holla@kernel.org>

[ Upstream commit 56e7e64cdd0e7209a58c8ec66028d63387402919 ]

BASE_ERROR_EVENT carries a variable number of message reports,
with the count encoded in error_status. The notification parser used
that count without checking whether the received payload contained all
reported entries.

Reject truncated payloads before copying the report array.

Link: https://patch.msgid.link/20260517-scmi_fixes-v1-2-d86daec4defd@kernel.org
Signed-off-by: Sudeep Holla <sudeep.holla@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit Message Forensics

### Step 1.1: Subject Line
**Record:** `[firmware: arm_scmi]` `[Validate]` — Validate that
`BASE_ERROR_EVENT` notification payloads are large enough for the number
of error reports claimed in `error_status`.

### Step 1.2: Commit Message Tags
**Record:**
- **Link:** `https://patch.msgid.link/20260517-scmi_fixes-v1-2-
  d86daec4defd@kernel.org`
- **Signed-off-by:** Sudeep Holla `<sudeep.holla@kernel.org>` (author;
  SCMI maintainer)
- **Reviewed-by:** Cristian Marussi `<cristian.marussi@arm.com>` (from
  mbox; SCMI co-maintainer)
- **No Fixes:, Reported-by:, Tested-by:, Cc: stable@** on this specific
  patch
- **Series context:** Patch 2/4 of `scmi_fixes-v1` (`20260517_sudeep_hol
  la_firmware_arm_scmi_fix_protocol_parsing_and_validation.mbx`)

### Step 1.3: Commit Body Analysis
**Record:**
- **Bug:** `BASE_ERROR_EVENT` has a variable-length payload;
  `error_status` encodes how many `msg_reports[]` entries follow, but
  the parser used that count without verifying the received `payld_sz`
  covered all entries.
- **Symptom:** Truncated notifications are parsed anyway; the loop
  copies `msg_reports[i]` beyond the valid received bytes.
- **Root cause:** Only an upper-bound check existed (`payld_sz <=
  sizeof(*p)`); no lower-bound check based on `cmd_count`.
- **Version info:** None in the commit message.

### Step 1.4: Hidden Bug Fix Detection
**Record:** Not disguised — this is an explicit validation/hardening fix
for out-of-bounds reads on a variable-length protocol payload.

---

## Phase 2: Diff Analysis

### Step 2.1: Change Inventory
**Record:**
- **File:** `drivers/firmware/arm_scmi/base.c` (+13 / -2 per mbox;
  user's diff is equivalent)
- **Function modified:** `scmi_base_fill_custom_report()`
- **Scope:** Single-file, surgical fix (~15 lines)

### Step 2.2: Code Flow Change
**Record:**
- **Hunk 1 (before):** After checking `payld_sz` is not larger than the
  max struct, immediately read `error_status`, derive `cmd_count`, and
  loop over `p->msg_reports[i]`.
- **Hunk 1 (after):** Compute minimum size for header fields; reject if
  `payld_sz` too small; then derive `cmd_count`; compute `expected_sz +=
  cmd_count * sizeof(msg_reports[0])`; reject truncated payloads; only
  then copy reports.
- **Path affected:** Deferred notification worker path for
  `SCMI_EVENT_BASE_ERROR_EVENT`.

### Step 2.3: Bug Mechanism
**Record:**
- **Category:** Buffer over-read / out-of-bounds access on variable-
  length payload (memory safety).
- **Mechanism:** `ERROR_CMD_COUNT(error_status)` can claim N report
  entries while `payld_sz` only contains the fixed header (8 bytes) or a
  partial array. The loop reads `p->msg_reports[i]` past the valid
  received message boundary.

### Step 2.4: Fix Quality
**Record:**
- **Quality:** Obviously correct; mirrors existing SCMI validation style
  (e.g. `scmi_system_fill_custom_report()`).
- **Regression risk:** Very low — well-formed firmware messages are
  unchanged; malformed ones are rejected (return `NULL`, event dropped
  with existing error logging in `scmi_process_event_payload()`).
- **Note:** Mbox uses `sizeof(p->agent_id) + sizeof(p->error_status)`;
  user's diff uses `offsetof(typeof(*p), msg_reports)` — functionally
  equivalent.

---

## Phase 3: Git History Investigation

### Step 3.1: Blame
**Record:** Buggy logic introduced in `585dfab3fb80e` ("firmware:
arm_scmi: Add base notifications support", 2020-07-01, Cristian
Marussi). Confirmed ancestor of current HEAD.

### Step 3.2: Fixes: Tag
**Record:** N/A — no `Fixes:` tag on this commit.

### Step 3.3: Related File History
**Record:**
- `3b0041f6e10e5` — "Validate BASE_DISCOVER_LIST_PROTOCOLS response"
  (same subsystem, same validation pattern; already in this tree)
- `11daac2817dca` — "Fix OOB in scmi_power_name_get()" (already
  backported to this 6.18.y tree)
- `bac3e70c2fb10` — patch 1/4 of the same series (sensor config width
  fix) is already in this tree; **patch 2/4 (this fix) is not**

### Step 3.4: Author Context
**Record:** Sudeep Holla is the SCMI subsystem maintainer. Recent SCMI
commits in this tree include multiple validation and OOB fixes.

### Step 3.5: Dependencies
**Record:** Standalone — only touches `base.c`. Does not depend on patch
1/4 (sensors), 3/4, or 4/4. Applies independently.

---

## Phase 4: Mailing List and External Research

### Step 4.1: Original Discussion
**Record:** `b4 dig` could not be used (commit not in tree).
Lore/patch.msgid.link fetch blocked (403/bot protection). Used local
mbox: `20260517_sudeep_holla_firmware_arm_scmi_fix_protocol_parsing_and_
validation.mbx`. Series v1, patch 2/4.

### Step 4.2: Reviewers
**Record:** Reviewed-by Cristian Marussi on patch 2/4. Cover letter Cc's
`arm-scmi@vger.kernel.org`, `linux-arm-kernel@lists.infradead.org`.

### Step 4.3: Bug Report
**Record:** No external bug report or syzbot link. Issue found during
spec-compliance review per cover letter ("checking the driver message
layouts against the SCMI specification").

### Step 4.4: Series Context
**Record:** 4-patch series; each patch is independently valuable. Patch
1 already present in tree; patches 2–4 are separate fixes.

### Step 4.5: Stable List History
**Record:** Not searched (lore blocked). Cover letter does not
explicitly request stable, but that is not a negative signal per
instructions.

---

## Phase 5: Code Semantic Analysis

### Step 5.1: Key Functions
**Record:** `scmi_base_fill_custom_report()` (modified); callers via
`REVT_FILL_REPORT` macro.

### Step 5.2: Callers
**Record:** Called from `scmi_process_event_payload()` in `notify.c`
(line 495), which runs in a workqueue context after `scmi_notify()`
queues firmware events from interrupt context.

### Step 5.3: Callees
**Record:** `le32_to_cpu()`, `le64_to_cpu()`, `IS_FATAL_ERROR()`,
`ERROR_CMD_COUNT()`, field access on `payld` and `report` buffers.

### Step 5.4: Reachability
**Record:**
- `scmi_notify()` ← SCMI transport RX path (firmware/platform
  notifications)
- Not directly userspace-syscall reachable, but triggered by SCMI
  platform firmware on ARM systems using SCMI
- Affects any platform where `BASE_ERROR_EVENT` notifications are
  enabled

### Step 5.5: Similar Patterns
**Record:** `scmi_system_fill_custom_report()` already validates
`payld_sz == expected_sz`. `3b0041f6e10e5` validates variable-length
protocol list responses. Same hardening pattern.

---

## Phase 6: Cross-Reference Against Local Tree

### Step 6.1: Buggy Code Exists?
**Record:** **Yes.** Local tree is **v6.18.44** (`git describe HEAD`).
`scmi_base_fill_custom_report()` at lines 322–350 in `base.c` lacks
`expected_sz` validation. Bug present since v5.7-era introduction
(2020).

### Step 6.2: Backport Complications
**Record:** Expected **clean apply** — current `base.c` matches the
patch context exactly. No `expected_sz` present. Mbox patch context
matches current file structure.

### Step 6.3: Related Fixes Already Present?
**Record:** Patch 1/4 (`bac3e70c2fb10`) is in tree. This specific
BASE_ERROR_EVENT validation is **not** present. No duplicate fix found.

---

## Phase 7: Subsystem Context

### Step 7.1: Subsystem Criticality
**Record:** `drivers/firmware/arm_scmi/` — **IMPORTANT** subsystem for
ARM/ARM64 platforms (servers, embedded, mobile SoCs using SCMI to talk
to SCP/EL3 firmware).

### Step 7.2: Subsystem Activity
**Record:** Actively maintained; recent commits include OOB fixes, NULL
deref fixes, and validation hardening.

---

## Phase 8: Impact and Risk Assessment

### Step 8.1: Who Is Affected
**Record:** Platforms using SCMI with `BASE_ERROR_EVENT` notifications
enabled (`CONFIG_ARM_SCMI_PROTOCOL`). Driver-specific / platform-
specific, but SCMI is widespread on modern ARM hardware.

### Step 8.2: Trigger Conditions
**Record:** Firmware sends a `BASE_ERROR_EVENT` where `error_status`
claims more `msg_reports` than the actual payload contains. Can result
from buggy firmware, transport corruption, or malformed messages. Not
directly triggerable by unprivileged userspace, but firmware input is
treated as untrusted in hardening contexts.

### Step 8.3: Failure Mode Severity
**Record:**
- **Without fix:** Reads beyond valid received payload into the pre-
  allocated scratch buffer (`pd->eh`, sized to max payload). This can
  return **stale/uninitialized kernel data** as error reports to
  registered event handlers — information leak and incorrect error
  reporting.
- **With fix:** Returns `NULL`; event is dropped with `"report not
  available"` error (existing path).
- **Severity:** **HIGH** (out-of-bounds read / info leak pattern); crash
  is less likely because scratch buffer is pre-allocated to max size,
  but corrupted reports are a real correctness and security concern.

### Step 8.4: Risk-Benefit
**Record:**
- **Benefit:** HIGH for affected ARM SCMI platforms — prevents parsing
  truncated firmware notifications and leaking stale data.
- **Risk:** VERY LOW — small, obviously correct validation; no behavior
  change for well-formed messages.
- **Ratio:** Strong benefit, minimal risk.

---

## Phase 9: Final Synthesis

### Step 9.1: Evidence Summary

**FOR backport:**
- Real memory-safety bug in variable-length notification parsing
- Long-standing (since 2020), present in v6.18.44
- Small, surgical, maintainer-reviewed fix
- Matches established SCMI validation pattern already in this tree
- Precedent: similar SCMI OOB/validation fixes already backported here
  (`11daac2817dca`, `3b0041f6e10e5`)
- Standalone — no series dependencies
- No functional change for correct firmware

**AGAINST backport:**
- Trigger requires malformed firmware notification (not common in
  production, but possible)
- Not syzbot-reported or user-reported with crash trace
- Patch 2/4 lacks the extensive `Tested-by:` list that patch 1/4 has
  (though it has `Reviewed-by`)

**Unresolved:**
- Could not access lore.kernel.org directly (403/bot protection)
- `b4 dig` not usable without commit in tree

### Step 9.2: Stable Rules Checklist
1. Obviously correct and tested? **PASS** — logic is straightforward;
   Reviewed-by subsystem co-maintainer
2. Fixes a real bug affecting users? **PASS** — truncated payload
   parsing on real ARM SCMI hardware
3. Important issue? **PASS** — out-of-bounds read / stale data leak
   (HIGH)
4. Small and contained? **PASS** — ~15 lines, one file, one function
5. No new features or APIs? **PASS**
6. Can apply to local tree? **PASS** — buggy code confirmed present;
   patch is standalone

### Step 9.3: Exception Categories
**Record:** N/A — standard bug fix, not a device-ID/quirk/DT/build/docs
exception.

### Step 9.4: Problem Summary for Stable Users

On ARM systems using SCMI, `BASE_ERROR_EVENT` notifications report
firmware errors with a variable number of 64-bit report words. The
kernel driver trusted the count in `error_status` without verifying the
received message was large enough. A truncated notification could cause
the driver to read beyond the valid payload into scratch-buffer memory
and forward garbage/stale data to event handlers.

The fix adds minimum-size checks before parsing — the same defensive
pattern already used elsewhere in SCMI (e.g. system power-state
notifications, protocol list discovery). It is small, maintainer-
reviewed, and appropriate for the v6.18.y stable tree where the
vulnerable code is present.

---

## Verification

- **[Phase 1]** Parsed subject, tags, body from user-provided commit and
  local mbox `20260517_sudeep_holla_firmware_arm_scmi_fix_protocol_parsi
  ng_and_validation.mbx`
- **[Phase 1]** Found Reviewed-by: Cristian Marussi in mbox patch 2/4
- **[Phase 2]** Read current `scmi_base_fill_custom_report()` at lines
  322–350 in `drivers/firmware/arm_scmi/base.c` — missing validation
- **[Phase 2]** Confirmed `SCMI_BASE_MAX_CMD_ERR_COUNT` = 1024, struct
  layout with variable reports
- **[Phase 3]** `git blame -L 322,350`: buggy code from `585dfab3fb80e`
  (2020-07-01)
- **[Phase 3]** `git merge-base --is-ancestor 585dfab3fb80e HEAD`:
  confirmed in tree
- **[Phase 3]** `git log --oneline -20 --
  drivers/firmware/arm_scmi/base.c`: related validation commit
  `3b0041f6e10e5` present
- **[Phase 3]** Confirmed `bac3e70c2fb10` (series patch 1/4) in tree;
  patch 2/4 not in tree
- **[Phase 4]** `b4 dig -c HEAD`: failed (commit not in tree)
- **[Phase 4]** WebFetch lore/patch.msgid.link: blocked (403/bot
  protection)
- **[Phase 4]** Read local mbox cover letter and patch 2/4 content
- **[Phase 5]** Traced call chain: `scmi_notify()` → workqueue →
  `scmi_process_event_payload()` → `REVT_FILL_REPORT()` →
  `scmi_base_fill_custom_report()`
- **[Phase 5]** Read `scmi_process_event_payload()` NULL-report handling
  at lines 498–502 in `notify.c`
- **[Phase 5]** Read `scmi_system_fill_custom_report()` validation
  pattern in `system.c`
- **[Phase 5]** Read scratch buffer allocation in
  `scmi_allocate_registered_events_desc()` — `eh_sz` = max payload +
  header
- **[Phase 6]** `git describe HEAD`: v6.18.44
- **[Phase 6]** `grep expected_sz drivers/firmware/arm_scmi/base.c`: no
  matches — fix not applied
- **[Phase 6]** Patch context in mbox matches current `base.c` structure
- **[Phase 7]** Confirmed SCMI is active subsystem with recent security
  fixes in this tree
- **[Phase 8]** Assessed failure mode: OOB read of stale scratch-buffer
  data, not typical kmalloc overflow
- **UNVERIFIED:** Direct lore.kernel.org thread content (blocked)
- **UNVERIFIED:** Whether this exact commit SHA exists on mainline
  (evaluated from patch content against local tree)

**YES**

 drivers/firmware/arm_scmi/base.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/firmware/arm_scmi/base.c b/drivers/firmware/arm_scmi/base.c
index 86b376c50a13f..25aa52746bd10 100644
--- a/drivers/firmware/arm_scmi/base.c
+++ b/drivers/firmware/arm_scmi/base.c
@@ -325,6 +325,8 @@ static void *scmi_base_fill_custom_report(const struct scmi_protocol_handle *ph,
 					  void *report, u32 *src_id)
 {
 	int i;
+	u32 error_status;
+	size_t expected_sz;
 	const struct scmi_base_error_notify_payld *p = payld;
 	struct scmi_base_error_report *r = report;
 
@@ -338,10 +340,19 @@ static void *scmi_base_fill_custom_report(const struct scmi_protocol_handle *ph,
 	if (evt_id != SCMI_EVENT_BASE_ERROR_EVENT || sizeof(*p) < payld_sz)
 		return NULL;
 
+	expected_sz = offsetof(typeof(*p), msg_reports);
+	if (payld_sz < expected_sz)
+		return NULL;
+
 	r->timestamp = timestamp;
 	r->agent_id = le32_to_cpu(p->agent_id);
-	r->fatal = IS_FATAL_ERROR(le32_to_cpu(p->error_status));
-	r->cmd_count = ERROR_CMD_COUNT(le32_to_cpu(p->error_status));
+	error_status = le32_to_cpu(p->error_status);
+	r->fatal = IS_FATAL_ERROR(error_status);
+	r->cmd_count = ERROR_CMD_COUNT(error_status);
+	expected_sz += r->cmd_count * sizeof(p->msg_reports[0]);
+	if (payld_sz < expected_sz)
+		return NULL;
+
 	for (i = 0; i < r->cmd_count; i++)
 		r->reports[i] = le64_to_cpu(p->msg_reports[i]);
 	*src_id = 0;
-- 
2.53.0

