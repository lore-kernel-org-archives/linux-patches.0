Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A0A1638AEB;
	Mon, 19 Oct 2026 14:05:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418753; cv=none; b=rnQtSPkNEEz8CeBsnXeWk5ohHliknMmtQKSn6JfcsIclLsNmXmA/CTaFVTl6hDD91MMA1ymzx3LlijadlP1K265OhLzQLM7SKj5TzgCU8KbJCo0WlaMxoIJx6zklAEMJ0bfoCrG5LxcxHJ/s8ieG0atwL/QcY+/vpTz5mLo8Rig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418753; c=relaxed/simple;
	bh=TJvedbCkqGa1iw2aQfd1OaZlFgb+PqzropNjljRtHDI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mLWFOyVCrUIUp3D9G0yjir7/d2ihtF0s32cTyQkuatvZ3yLATvU0JZSyzQ0f81eR5LPtbXvGDzGKGj8S4OrwuW7RTv0eIHeRWThKkz5MbXOTeRtv3Sa3Lu+LLa5Yy737MOhJOU9m0HegPXMuUjn2uCcGNV8gY+M9sYK2iJL2qb0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hvNSIA3X; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hvNSIA3X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48BF61F000C4;
	Mon, 19 Oct 2026 14:05:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418750;
	bh=Gk3r/Dv24HSmgxi6LbpPOC79rkhyt3fEBmrPC21hpr8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hvNSIA3XgzvD3VfNqG9j0qup4dH/ZsNQuSBeTPzDTzUVqLqihwHpUHKBngMSeeEh7
	 XM2eimAkmpkBpeJvL9cSzrH3NnyZ5CTyiTWa0260byXMXolmrkPXasJXv8bmxqRXoF
	 GVNsLe397g3nP7kmygRwDHQgpD9ZZib1MlIY4v8BoqODRF45Pj5GDSWM9qxJdOGnaJ
	 +VXFDcKfL2WLhoAgcr1ogHc0wPe58u1ul4A1r2eSSTEuvhYAiEPhghu6m0qL1wSVwM
	 F2ArjFPAXy9pdjHxN64P4XxKtHcBuTXGZ3KvKHxkhtBKfTtGzTBGU1Jt2YidiavmSh
	 ge8EpxWfXXefw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] wifi: iwlwifi: validate PNVM SKU TLV length
Date: Mon, 19 Oct 2026 09:52:40 -0400
Message-ID: <20261019135441.1420968-469-sashal@kernel.org>
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

[ Upstream commit 7410e4548a17bd868dfc60b48f2e78eacde3ad78 ]

iwl_pnvm_parse() reads an iwl_sku_id from an
IWL_UCODE_TLV_PNVM_SKU payload after only checking that the generic TLV
payload is present.

A short type-specific payload can therefore make the three data[] reads
extend beyond the TLV. Reject SKU TLVs shorter than the structure before
accessing it.

Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Link: https://patch.msgid.link/20260715135916.24417-1-pengpeng@iscas.ac.cn
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

This checkout is mainline **7.3.0-rc4**. The candidate is a six-line
bounds check in `iwl_pnvm_parse()` that rejects a short
`IWL_UCODE_TLV_PNVM_SKU` payload before reading `struct iwl_sku_id`.
That is a real out-of-bounds read on truncated PNVM data, and the parser
(and the surrounding length-check style) is present in this tree.

===============================================================
PHASE 1: COMMIT MESSAGE FORENSICS
===============================================================

**Step 1.1: PARSE THE SUBJECT LINE**
Record: **[wifi: iwlwifi]** **[validate]** **reject PNVM SKU TLVs
shorter than `struct iwl_sku_id` before reading `data[0..2]`**
- Subsystem: `wifi: iwlwifi`
- Verb: “validate” — defensive length check, i.e. a bounds fix, not a
  feature

**Step 1.2: PARSE ALL COMMIT MESSAGE TAGS**
Record (from `git log -1 --format='%B' 7410e4548a17b`):
- **Fixes:** none (expected for this review)
- **Reported-by / Tested-by / Reviewed-by / Acked-by:** none
- **Cc: stable:** none (expected)
- **Link:**
  `https://patch.msgid.link/20260715135916.24417-1-pengpeng@iscas.ac.cn`
  (v2, patch 1 of a 2-patch series)
- **Signed-off-by:** Pengpeng Hou (author); Miri Korenblit (iwlwifi
  maintainer, applied it)
- Notable: no syzbot, no CVE, no user crash report. Maintainer SOB is a
  strong quality signal.

**Step 1.3: ANALYZE THE COMMIT BODY TEXT**
Record:
- **Bug:** `iwl_pnvm_parse()` treats a present generic TLV payload as
  enough, then reads three `__le32` SKU words.
- **Symptom:** short type-specific payload → `tlv_sku_id->data[0..2]`
  reads past the TLV (and, if remaining file bytes `< 12`, past the
  allocated buffer).
- **Version info:** none in the message.
- **Root cause:** missing type-specific minimum length vs `sizeof(struct
  iwl_sku_id)`.
- **Fix:** `if (tlv_len < sizeof(*tlv_sku_id)) return -EINVAL` before
  the three reads.

**Step 1.4: DETECT HIDDEN BUG FIXES**
Record: Not disguised. Explicit bounds validation. Same class as the
existing `tlv_len < sizeof(...)` checks on `IWL_UCODE_TLV_PNVM_VERSION`
and `IWL_UCODE_TLV_HW_TYPE` in `iwl_pnvm_handle_section()`.

===============================================================
PHASE 2: DIFF ANALYSIS - LINE BY LINE
===============================================================

**Step 2.1: INVENTORY THE CHANGES**
Record:
- File: `drivers/net/wireless/intel/iwlwifi/fw/pnvm.c` — **+6 / −0**
- Function: `iwl_pnvm_parse()`
- Scope: **single-file surgical fix**

**Step 2.2: UNDERSTAND THE CODE FLOW CHANGE**
Verified against `7410e4548a17b^` and current `pnvm.c`:

Before: after `len < tlv_len` (payload fits in remaining buffer), a
`IWL_UCODE_TLV_PNVM_SKU` TLV is cast to `struct iwl_sku_id` and
`data[0]`, `data[1]`, `data[2]` are read with **no** `tlv_len >= 12`
check.

After: if `tlv_len < sizeof(*tlv_sku_id)` (12 bytes), log and `return
-EINVAL`. Valid Intel PNVM SKU TLVs are unchanged.

Path: firmware-init parse of PNVM from BIOS, `.pnvm` file, or embedded
`.ucode` — error path only for a short SKU TLV.

**Step 2.3: IDENTIFY THE BUG MECHANISM**
Record: **[Memory safety: buffer over-read / OOB]**

`struct iwl_sku_id` is `{ __le32 data[3]; } __packed`
(`fw/api/alive.h`). Generic check is `len < tlv_len` only.

Concrete OOB (verified): file size 10, header 8 bytes, `tlv_len=0`,
`tlv_type=PNVM_SKU`. After the header, `len=2`. `2 < 0` is false, then
12 bytes are read from a 2-byte remainder → **true kernel buffer over-
read**. If remainder ≥ 12 but `tlv_len < 12`, the read stays in the file
but past this TLV (wrong SKU / wrong section match).

**Step 2.4: ASSESS THE FIX QUALITY**
Record: Obviously correct and matches sibling TLV checks. No
API/lock/refcount change. Regression risk: **very low**. Valid SKU TLV
length is 12; those still parse. A short SKU now fails closed (`-EINVAL`
→ `fail_to_parse_pnvm_image`), which is the intended defense.

===============================================================
PHASE 3: GIT HISTORY INVESTIGATION
===============================================================

**Step 3.1: BLAME THE CHANGED LINES**
Record:
- SKU TLV loop: **6972592850c00e** (`iwlwifi: read and parse PNVM file`,
  Luca Coelho, 2020-10-08) — first in **v5.10-rc1**.
- `struct iwl_sku_id` cast / `data[0..2]` compares: **3a68ae0fa2ec13**
  (2025) — same 12-byte read, still unchecked.
- Length check: **7410e4548a17b** (this commit, 2026-07-15), first
  contained in **v7.3-rc1**.

**Step 3.2: FOLLOW THE FIXES: TAG**
Record: No `Fixes:` tag. Introducer is 6972592850c00e; `git merge-base
--is-ancestor 6972592850c00e HEAD` succeeded. Bug is old, not post-
branch.

**Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES**
Record:
- **f051995c53958** — same author, patch 2/2, same check in
  `iwl_uefi_reduce_power_parse()` (`uefi.c`). Not a prerequisite for
  this hunk.
- **daec24a5ed5da** — nearby `iwl_pnvm_complete_fn` payload-length
  check; independent.
- `iwl_pnvm_handle_section()` already length-checks other TLV types.
  This fills the SKU hole in the outer parser.
- Standalone: applies without patch 2.

**Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS**
Record: Pengpeng Hou has these two iwlwifi commits here (SKU length in
`pnvm.c` and `uefi.c`). Applied by **Miri Korenblit**, listed in
MAINTAINERS as Intel wireless maintainer.

**Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS**
Record: Uses existing `tlv_len`, `tlv_sku_id`, `IWL_ERR`, `-EINVAL`. No
new helpers. **Applies standalone.**

===============================================================
PHASE 4: MAILING LIST AND EXTERNAL RESEARCH
===============================================================

**Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION**
Record:
- `b4 dig -c 7410e4548a17b` →
  https://patch.msgid.link/20260715135916.24417-1-pengpeng@iscas.ac.cn
- `b4 dig -a`: **v1** 2026-06-30 (`3 * sizeof(__le32)`); **v2**
  2026-07-15 (`sizeof(*tlv_sku_id)`).
- v1 mbox: Miri: `Sizeof(*tlv_sku_id)` — no NAK, no stable debate.
- Applied version is v2. WebFetch to lore returned **403**; discussion
  recovered via `b4 mbox`.

**Step 4.2: CHECK WHO REVIEWED THE PATCH**
Record (`b4 dig -w`): To/Cc Pengpeng Hou, **Miri Korenblit**, linux-
wireless, linux-kernel. Right maintainer and list. Miri both reviewed v1
and signed off v2.

**Step 4.3: SEARCH FOR THE BUG REPORT**
Record: No Reported-by, syzbot, or bugzilla. Issue is from code
inspection. Trigger is malformed/truncated PNVM, not a published user
crash.

**Step 4.4: CHECK FOR RELATED PATCHES AND SERIES**
Record: v2 msgid `...24417-1...` is patch 1/2. Patch 2 is f051995c53958
on `uefi.c`. This commit does not need patch 2.

**Step 4.5: CHECK STABLE MAILING LIST HISTORY**
Record: `WebFetch https://lore.kernel.org/stable/?q=...` returned
**403**. **UNVERIFIED** whether stable@ discussed it. No `Cc: stable` on
the patch.

===============================================================
PHASE 5: CODE SEMANTIC ANALYSIS
===============================================================

**Step 5.1: IDENTIFY KEY FUNCTIONS IN THE DIFF**
Record: **`iwl_pnvm_parse()`** only (static).

**Step 5.2: TRACE CALLERS**
Record (grep in this tree):
- `iwl_pnvm_parse()` ← `iwl_pnvm_load_pnvm_to_trans()`
- ← `iwl_pnvm_load()` (exported)
- ← `iwl_mvm` `mvm/fw.c` and `iwl_mld` `mld/fw.c` after firmware alive

Called on WiFi bring-up / fw restart for AX210+ when SKU_ID is non-zero
— **common device-init path**, process context, not IRQ.

**Step 5.3: TRACE CALLEES**
Record: `le32_to_cpu`, `IWL_DEBUG_FW`/`IWL_ERR`,
`iwl_pnvm_handle_section()` on SKU match. New path only returns
`-EINVAL`. Image sources: UEFI/BIOS, `firmware_request_nowarn()`
`.pnvm`, or embedded `fw->pnvm_data`.

**Step 5.4: FOLLOW THE CALL CHAIN**
Record: `iwl_mvm_load_rt_fw` / `iwl_mld_run_fw_init_sequence` →
`iwl_pnvm_load` → parse. Unprivileged userspace cannot feed an arbitrary
blob without replacing firmware (usually root). Truncated/corrupt
firmware or bad BIOS PNVM is still a realistic field case. **Reachable
on every Intel AX210+ bring-up that has PNVM.**

**Step 5.5: SEARCH FOR SIMILAR PATTERNS**
Record: Same `tlv_len < sizeof(*tlv_sku_id)` in
`iwl_uefi_reduce_power_parse()` (`uefi.c`, added by patch 2).
`iwl_pnvm_handle_section()` already length-checks VERSION/HW_TYPE. `iwl-
drv.c` does similar TLV size checks for ucode.

===============================================================
PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE
===============================================================

**Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?**
Record: **Yes.** `drivers/net/wireless/intel/iwlwifi/fw/pnvm.c`
`iwl_pnvm_parse()` SKU handling is here (lines 201–234). Introduced
v5.10; this tree is 7.3-rc4. Unfixed form is `7410e4548a17b^`; HEAD
already includes the six-line check (commit is an ancestor of HEAD;
first tag **v7.3-rc1**). That is origin history, not a stable-queue
marker.

**Step 6.2: CHECK FOR BACKPORT COMPLICATIONS**
Record: On this tree the hunk is already applied and matches the
candidate. Context (`reduced_cap_sku`, `sku_id[]` compare) is present.
**Clean apply** here. Older stables may still need a trivial context
tweak; that is out of scope for *this* checkout.

**Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE**
Record: This exact check is already in HEAD. No alternate SKU-length
fix. UEFI twin is a separate commit. No competing fix to skip this one
on merit.

===============================================================
PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT
===============================================================

**Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY**
Record: **iwlwifi firmware/PNVM loader**
(`drivers/net/wireless/intel/iwlwifi/`). **IMPORTANT** (not mm/net core;
Intel WiFi is extremely common).

**Step 7.2: ASSESS SUBSYSTEM ACTIVITY**
Record: Active (`iwlwifi-next` merges, PNVM source/embed work). Parser
itself dates to 2020; this is a late bounds check on old logic, not a
fix to brand-new code.

===============================================================
PHASE 8: IMPACT AND RISK ASSESSMENT
===============================================================

**Step 8.1: DETERMINE WHO IS AFFECTED**
Record: **Driver-specific** — Intel iwlwifi with PNVM (AX210 and later;
BIOS/external/embedded). Large laptop/desktop population.

**Step 8.2: DETERMINE THE TRIGGER CONDITIONS**
Record: PNVM blob with `IWL_UCODE_TLV_PNVM_SKU` and `length < 12`
(truncated file, corrupt UEFI, bad image). Not every boot with good
linux-firmware. Unprivileged trigger only if firmware can be replaced
without privilege (normally no). Timing: not a race.

**Step 8.3: DETERMINE THE FAILURE MODE SEVERITY**
Record: **OOB read** of up to 12 bytes. Can KASAN-oops if the remaining
buffer is short; otherwise reads past the TLV into neighboring bytes
(wrong SKU match). **Severity: HIGH** (memory safety / possible oops),
not a guaranteed panic on healthy firmware.

**Step 8.4: CALCULATE RISK-BENEFIT RATIO**
Record:
- **Benefit:** High for a 6-line check: stops a real over-read in a
  widely used driver; same pattern as neighboring TLV checks.
- **Risk:** Very low; fail closed on invalid TLV; valid 12-byte SKU
  unchanged.
- **Ratio:** Strongly favors applying it.

===============================================================
PHASE 9: FINAL SYNTHESIS
===============================================================

**Step 9.1: COMPILE THE EVIDENCE**

FOR:
- Real OOB read: `tlv_len` can be 0–11 while the code reads 12 bytes.
- iwlwifi PNVM parse exists in this tree since v5.10; bug is not newer
  than this branch.
- 6 lines, one function, fail closed — obviously correct.
- Maintainer (Miri) requested `sizeof(*tlv_sku_id)` and applied v2.
- Completes length checks already used for other PNVM TLV types.
- Intel AX210+ WiFi is a large user base; PNVM comes from
  files/UEFI/embedded ucode, which can be truncated.

AGAINST:
- No syzbot/CVE/user oops in the message.
- Typical trigger is malformed firmware, often needing root to plant.
- Part of a 2-patch series (UEFI twin is independent, not required).
- HEAD already contains 7410e4548a17b because this *is* the 7.3 mainline
  line that merged iwlwifi-next — not used as a “already queued for
  stable” reason.

UNRESOLVED:
- lore.kernel.org HTTP 403; stable@ discussion not fetched. Review
  recovered via `b4`.

**Step 9.2: APPLY THE STABLE RULES CHECKLIST**
1. Obviously correct and tested? **PASS** — maintainer-reviewed v2;
   logic matches existing TLV checks.
2. Fixes a real bug that affects users? **PASS** — OOB read in PNVM
   parse on short SKU TLV.
3. Important (crash, security, corruption, deadlock)? **PASS** — buffer
   over-read / possible oops; HIGH, not theoretical.
4. Small and contained? **PASS** — +6 lines, one file.
5. No new features or APIs? **PASS**
6. Can apply to the local tree? **PASS** — code and context are here
   (already the applied form).

**Step 9.3: CHECK FOR EXCEPTION CATEGORIES**
Record: None of device-ID / quirk / DT / build / docs. Ordinary memory-
safety fix.

**Step 9.4: MAKE YOUR DECISION**
This tree has `iwl_pnvm_parse()` and the SKU TLV path. The bug is a
missing type-specific length check, present since PNVM parsing landed.
The fix is minimal, reviewed, and fail-closed. That meets stable rules
for *this* checkout’s iwlwifi code.

------------------------------------------------
What the commit solves for users of this tree
------------------------------------------------
On Intel WiFi bring-up, PNVM is parsed from BIOS, a `.pnvm` file, or
embedded ucode. A SKU TLV shorter than 12 bytes made the driver read
`data[0..2]` past the TLV and, if the buffer was also short, past the
allocation. That is a kernel over-read (KASAN/oops) or a wrong SKU
comparison. The patch rejects those TLVs with `-EINVAL` before the
reads. Valid 12-byte SKU TLVs are unchanged.

Risk vs benefit: six lines on an error path vs a real OOB in a common
driver — benefit dominates. No prerequisites. Patch 2 (`uefi.c`) is the
same idea elsewhere, not required here.

Verification:
- [Phase 1] Tags: Link to msgid 24417-1; SOB Pengpeng Hou, Miri
  Korenblit; no Fixes/Reported-by/Cc: stable
- [Phase 2] Diff: +6 in `iwl_pnvm_parse()`; parent lacks the check;
  `iwl_sku_id` is 3×`__le32`
- [Phase 2] OOB: `tlv_len=0` with remaining `len=2` still passes `len <
  tlv_len`, then 12-byte read
- [Phase 3] Blame: 6972592850c00e (v5.10-rc1) introduced SKU parse; `git
  merge-base --is-ancestor` yes
- [Phase 3] No Fixes tag; sibling f051995c53958 is uefi.c only
- [Phase 4] `b4 dig -c 7410e4548a17b`: lore msgid 24417-1; v1→v2; Miri
  asked for `sizeof(*tlv_sku_id)`
- [Phase 4] `b4 dig -w`: linux-wireless + Miri; WebFetch lore/stable
  **403** (UNVERIFIED)
- [Phase 5] Callers: `iwl_pnvm_load` → mvm/mld fw alive; sources BIOS /
  fs / embedded
- [Phase 6] `git describe HEAD` = **v7.3-rc4-27-gf0100363d8c37**; `make
  kernelversion` = **7.3.0-rc4**; buggy parser present; fix already
  ancestor (v7.3-rc1)
- [Phase 7] iwlwifi, Miri listed in MAINTAINERS
- [Phase 8] Failure: OOB read / possible oops on short SKU TLV; severity
  HIGH; risk very low
- UNVERIFIED: stable@ mailing-list thread (HTTP 403)

**YES**

 drivers/net/wireless/intel/iwlwifi/fw/pnvm.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/pnvm.c b/drivers/net/wireless/intel/iwlwifi/fw/pnvm.c
index 5de3a9c0b3ef0..f623f1b679367 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/pnvm.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/pnvm.c
@@ -205,6 +205,12 @@ static int iwl_pnvm_parse(struct iwl_trans *trans, const u8 *data,
 			IWL_DEBUG_FW(trans,
 				     "Got IWL_UCODE_TLV_PNVM_SKU len %d\n",
 				     tlv_len);
+			if (tlv_len < sizeof(*tlv_sku_id)) {
+				IWL_ERR(trans, "invalid PNVM SKU TLV len: %u\n",
+					tlv_len);
+				return -EINVAL;
+			}
+
 			IWL_DEBUG_FW(trans, "sku_id 0x%0x 0x%0x 0x%0x\n",
 				     le32_to_cpu(tlv_sku_id->data[0]),
 				     le32_to_cpu(tlv_sku_id->data[1]),
-- 
2.53.0

