Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF55A533D0E;
	Mon, 19 Oct 2026 14:04:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418663; cv=none; b=GS7AGb2RNdJWVBrJBznxKQF9WrPWHgeZLXdMvkb6zfGV3PImP3x66r87g+wT1CVAfqFcbYhYyhzuoZhzJXsHEpziljaLbrSI0nKAxLIJTfY1cBi7es7xMlRaKcfMNHqnB9YnQsW+VYpyW/B75lrUbwdlX0Po2hcYNXcY49y/mHQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418663; c=relaxed/simple;
	bh=73Er7CSmyPYNsNtQwb48dnVF30gvsfxqvGylHaXB6XM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=utg7WkH6yncsbAAdq6YW+AiwRv8eft4bl5lKLw8MxXPH8CyBKa5hfusegWiGkACGvWaOqGbwOjVVlGqR+SOmK1obg212M+8th1ucWWuDD/iEZUNusD1ho688eKqDzfuurt5HTNuavq8jow+l754axW3qmqf4r+omM3qhcsvXff0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ads9PKHn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ads9PKHn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 233E31F000C6;
	Mon, 19 Oct 2026 14:04:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418660;
	bh=P/eMcIIduO6+WWMSsiM96gYRHQfbpYWBqVtuTT4A2qI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ads9PKHnq2x883PiU8PqM0SBOq0q8H+5kPPUbw+jDI8hwLjAmNDP84oiTfOTyrTS0
	 nvnyheTuw3FWjjE1zg6XMM5CMgpHMh0DAmD+C2LLvJ3vUIQSB8+7HMI6Fkzl+gyGT9
	 bytBoFYXyWSh7vtzDrH81PyFSNaSkHSil4HjgRRdFvNdcu1jOmPbVh2JyX/XXhTSeG
	 N4XV7CZw48KDwyXMda6q4+jzKXOXXp/DEpQnG0iCKdE7JQ10NRpE342t1APrn/vMOJ
	 LHvt7WMlP4xFeOPgg0bCKjqqYRaBvf4PPK5Bzs1JyX1gQ7D4YkggUm4wlgNX2dBH67
	 HPDOxR8ylAyyw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] wifi: iwlwifi: validate UEFI reduced-power SKU TLV length
Date: Mon, 19 Oct 2026 09:51:38 -0400
Message-ID: <20261019135441.1420968-407-sashal@kernel.org>
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

[ Upstream commit f051995c539582b05276abda4c5874fd4cafd2a5 ]

iwl_uefi_reduce_power_parse() reads an iwl_sku_id from an
IWL_UCODE_TLV_PNVM_SKU payload after only checking that the generic TLV
payload is present.

A short type-specific payload can therefore make the three data[] reads
extend beyond the TLV. Reject SKU TLVs shorter than the structure before
accessing it.

Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Link: https://patch.msgid.link/20260715135916.24417-2-pengpeng@iscas.ac.cn
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

This checkout is **v7.3-rc4** (mainline `7.3.0-rc4`). The analysis below
is only for this tree.

===============================================================
PHASE 1: COMMIT MESSAGE FORENSICS
===============================================================

Step 1.1: PARSE THE SUBJECT LINE
Record: **[iwlwifi / wifi]** **[validate]** — reject a UEFI reduced-
power `IWL_UCODE_TLV_PNVM_SKU` payload shorter than `struct iwl_sku_id`
before reading it. “Validate” here is a bounds check, not a feature add.

Step 1.2: PARSE ALL COMMIT MESSAGE TAGS
Record:
- **Fixes:** none (expected for this review path)
- **Reported-by:** none
- **Tested-by:** none
- **Reviewed-by:** none on the commit; v1 was reviewed on-list by the
  iwlwifi maintainer
- **Acked-by:** none
- **Link:**
  `https://patch.msgid.link/20260715135916.24417-2-pengpeng@iscas.ac.cn`
- **Cc: stable:** none (expected)
- **Signed-off-by:** Pengpeng Hou (author); Miri Korenblit (iwlwifi
  maintainer, applied it)
- Ignore pipeline SOBs. Pattern: two-patch series (`24417-1` PNVM
  parser, `24417-2` this UEFI parser); no syzbot.

Step 1.3: ANALYZE THE COMMIT BODY TEXT
Record:
- **Bug:** `iwl_uefi_reduce_power_parse()` treats a PNVM SKU TLV as
  `struct iwl_sku_id` after only checking that the generic TLV payload
  fits in the remaining buffer.
- **Symptom:** three `data[]` reads can extend past the TLV; if
  remaining bytes after the header are also `< 12`, that is a real out-
  of-bounds read of the UEFI blob.
- **Version info:** none in the message.
- **Root cause:** missing type-specific minimum length vs `sizeof(struct
  iwl_sku_id)` (`__le32 data[3]`, 12 bytes).

Step 1.4: DETECT HIDDEN BUG FIXES
Record: Not disguised. It is an explicit length check before the three
SKU word reads.

===============================================================
PHASE 2: DIFF ANALYSIS - LINE BY LINE
===============================================================

Step 2.1: INVENTORY THE CHANGES
Record:
- **File:** `drivers/net/wireless/intel/iwlwifi/fw/uefi.c` — **+6 / −0**
- **Function:** `iwl_uefi_reduce_power_parse()`
- **Scope:** single-file surgical fix

Step 2.2: UNDERSTAND THE CODE FLOW CHANGE
Record:
- **Before:** loop requires `len >= sizeof(*tlv)` (8-byte header). After
  subtracting the header it checks `len < tlv_len` (payload vs remaining
  buffer), then on `IWL_UCODE_TLV_PNVM_SKU` casts the payload to `struct
  iwl_sku_id` and reads `data[0..2]` even if `tlv_len` is 0–11.
- **After:** if `tlv_len < sizeof(*tlv_sku_id)` log and return `-EINVAL`
  before those reads.
- **Path:** firmware/UEFI parse during Intel WiFi PNVM/reduce-power
  load, not a hot datapath.

Step 2.3: IDENTIFY THE BUG MECHANISM
Record: **Memory safety / out-of-bounds read.** Outer check only proves
the claimed TLV payload is inside the remaining buffer, not that it is
12 bytes. If `tlv_len=4` and remaining `len=8`, `8 < 4` is false, then
12 bytes are read from an 8-byte remainder → **allocation OOB**. If
remaining `len >= 12` but `tlv_len < 12`, the reads stay in the
allocation but past this TLV.

Step 2.4: ASSESS THE FIX QUALITY
Record: Obviously correct and minimal (same pattern as the sibling PNVM
check). Regression risk is low: a too-short SKU TLV cannot be used
anyway; `-EINVAL` makes `iwl_pnvm_load_reduce_power_to_trans()` set
`failed_to_load_reduce_power_image` and skip the table. No API or lock
changes.

===============================================================
PHASE 3: GIT HISTORY INVESTIGATION
===============================================================

Step 3.1: BLAME THE CHANGED LINES
Record: The parser dates to **9dad325f9d575** (“iwlwifi: support loading
the reduced power table from UEFI”, 2021-06-21), first in **v5.14-rc1**.
SKU access was later adjusted by **3a68ae0fa2ec13** (“wifi: iwlwifi:
remove sku_id from trans”, 2025-05-04). The six new lines are this
commit (**f051995c53958**, 2026-07-15). The missing min-length check has
been there since the parser was added.

Step 3.2: FOLLOW THE FIXES: TAG
Record: No `Fixes:` tag. Introduction commit **9dad325f9d575** is an
ancestor of this HEAD. No intermediate SKU-length check on this function
before this patch.

Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES
Record: Immediate parent is sibling **7410e4548a17b** (“wifi: iwlwifi:
validate PNVM SKU TLV length”) — same author, same date, same check in
`iwl_pnvm_parse()`. Independent; this UEFI patch does not need that
hunk. Nearby **daec24a5ed5da** is a different length check in
`iwl_pnvm_complete_fn()`. Standalone as a 2/2 series member.

Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS
Record: Pengpeng Hou has these two iwlwifi validation commits in this
tree. Applied by **Miri Korenblit**, listed iwlwifi maintainer in
MAINTAINERS.

Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS
Record: Uses existing `tlv_sku_id`, `tlv_len`, `IWL_ERR`, `-EINVAL`. No
new helpers. Can apply standalone wherever
`iwl_uefi_reduce_power_parse()` still has this loop.

===============================================================
PHASE 4: MAILING LIST AND EXTERNAL RESEARCH
===============================================================

Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION
Record:
- **v2 (applied):**
  https://patch.msgid.link/20260715135916.24417-2-pengpeng@iscas.ac.cn
- **v1:** 2026-06-30,
  https://lore.kernel.org/all/2026063008051412.5-ccfa108-0020-wifi-
  iwlwifi-validate-UEFI--pengpeng@iscas.ac.cn/
- v1 used `tlv_len < 3 * sizeof(__le32)`; Miri asked for
  `sizeof(*tlv_sku_id)`; v2 did that. No NAK. b4 mbox for v2 is the
  patch only (no further replies).

Step 4.2: CHECK WHO REVIEWED THE PATCH
Record: To/Cc: Miri Korenblit, linux-wireless, linux-kernel. Maintainer
reviewed v1 and applied v2.

Step 4.3: SEARCH FOR THE BUG REPORT
Record: No syzbot, bugzilla, or user crash report. Author-found parser
hole. Syzbot CI on v2: KASAN build/boot passed; fuzz skipped.

Step 4.4: CHECK FOR RELATED PATCHES AND SERIES
Record: Pair with **7410e4548a17b** (`24417-1`, `iwl_pnvm_parse()`).
Same bug class, different file. This patch does not depend on that one.

Step 4.5: CHECK STABLE MAILING LIST HISTORY
Record: No stable-list discussion found for this subject. Absence of
`Cc: stable` is expected here.

===============================================================
PHASE 5: CODE SEMANTIC ANALYSIS
===============================================================

Step 5.1: IDENTIFY KEY FUNCTIONS IN THE DIFF
Record: `iwl_uefi_reduce_power_parse()` only.

Step 5.2: TRACE CALLERS
Record:
- Declared in `fw/uefi.h` under `#ifdef CONFIG_EFI` (stub `-EOPNOTSUPP`
  otherwise).
- Only caller: `iwl_pnvm_load_reduce_power_to_trans()` in `fw/pnvm.c`.
- That is called from `iwl_pnvm_load()`, exported and used from
  `mvm/fw.c` and `mld/fw.c` during firmware/PNVM init.
- Not IRQ; process context during WiFi bring-up.

Step 5.3: TRACE CALLEES
Record: Reads UEFI blob from `iwl_uefi_get_reduced_power()` →
`iwl_uefi_get_verified_variable()` (`kmalloc`/`kmemdup` of EFI var). On
SKU match, `iwl_uefi_reduce_power_section()`. Fix only adds a length
check and error return.

Step 5.4: FOLLOW THE CALL CHAIN
Record: Device probe / firmware start → `iwl_pnvm_load()` → reduce-power
UEFI parse. Not a syscall parser. Trigger needs Intel iwlwifi,
`CONFIG_EFI`, runtime EFI `GetVariable`, and a Reduced Power variable
with a short PNVM_SKU TLV. Unprivileged userspace cannot normally forge
that; root/firmware can. Still a kernel OOB on bad firmware/BIOS data.

Step 5.5: SEARCH FOR SIMILAR PATTERNS
Record: Identical hole and fix in `iwl_pnvm_parse()` (`pnvm.c` lines
208–212 in this tree). Same systematic miss.

===============================================================
PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE
===============================================================

Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?
Record: Yes. `iwl_uefi_reduce_power_parse()` is in `uefi.c` from v5.14.
This tree is **v7.3-rc4**; the fix itself is already an ancestor (`git
merge-base --is-ancestor f051995c53958 HEAD` succeeded) and first
appeared in **v7.3-rc1**. The parser and the OOB path exist in this
lineage.

Step 6.2: CHECK FOR BACKPORT COMPLICATIONS
Record: **Clean apply** on this tree’s pre-image (original commit).
Context is the long-standing TLV loop; no local conflicts.

Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE
Record: This is the fix. Sibling PNVM check is also here. No earlier
substitute for the UEFI parser.

===============================================================
PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT
===============================================================

Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY
Record: **iwlwifi** (`drivers/net/wireless/intel/iwlwifi/`).
**IMPORTANT** — common Intel WiFi driver, not core mm/VFS, not staging.

Step 7.2: ASSESS SUBSYSTEM ACTIVITY
Record: Actively developed (UEFI/PNVM/regulatory churn through 2026).
The missing check is old (2021); this is hardening of mature parse
logic, not a bug in brand-new code.

===============================================================
PHASE 8: IMPACT AND RISK ASSESSMENT
===============================================================

Step 8.1: DETERMINE WHO IS AFFECTED
Record: **Driver-specific + config-specific:** Intel iwlwifi +
`CONFIG_EFI` + platforms that expose the Reduced Power UEFI variable.

Step 8.2: DETERMINE THE TRIGGER CONDITIONS
Record: WiFi firmware/PNVM load with a short `IWL_UCODE_TLV_PNVM_SKU` in
that UEFI blob. Uncommon on good OEM tables; realistic with
corrupt/malicious EFI data. Not a normal unprivileged syscall.

Step 8.3: DETERMINE THE FAILURE MODE SEVERITY
Record: Out-of-bounds **read** of up to ~12 bytes. Can KASAN/oops if the
SKU TLV sits near the end of the `kmemdup` buffer; otherwise reads the
next TLV and can mis-match SKU / skip reduce-power. **HIGH** for the
true OOB case (crash on probe), not data corruption of user files.

Step 8.4: CALCULATE RISK-BENEFIT RATIO
Record:
- **Benefit:** high for affected laptops/APs — avoids OOB during WiFi
  init on bad UEFI data; check is cheap.
- **Risk:** very low — 6 lines, error path only, maintainer-acked form.
- **Ratio:** favorable.

===============================================================
PHASE 9: FINAL SYNTHESIS
===============================================================

Step 9.1: COMPILE THE EVIDENCE
**For:**
- Real type-specific length hole; OOB read of `iwl_sku_id` (12 bytes) is
  visible in the code.
- Six-line, obviously correct check; v2 matches maintainer review
  (`sizeof(*tlv_sku_id)`).
- iwlwifi maintainer applied it; same fix already used in
  `iwl_pnvm_parse()`.
- Parser present since v5.14; this tree has it.
- Applies cleanly; no new API; no extra dependency for *this* hunk.

**Against:**
- No user/syzbot report; trigger is malformed UEFI, not a common
  syscall.
- Reduce-power table is not the data path; failed parse already degrades
  to skipping the image.
- `CONFIG_EFI` only.

**Unresolved:** lore.kernel.org HTML fetch returned 403; discussion
recovered via b4 mbox, msgid.link, and LKML mirrors. No stable-list
thread found.

Step 9.2: APPLY THE STABLE RULES CHECKLIST
1. Obviously correct and tested? **PASS** — size check before
   `data[0..2]`; v2 from maintainer review; in iwlwifi-next then
   mainline.
2. Fixes a real bug that affects users? **PASS** — OOB read of a kernel
   buffer parsed at WiFi init.
3. Important issue? **PASS** — OOB can oops; severity HIGH, not LOW
   cosmetics.
4. Small and contained? **PASS** — +6 lines, one function.
5. No new features or APIs? **PASS**.
6. Can apply to the local tree? **PASS** — this tree already contains
   the original commit; pre-image matches.

Step 9.3: CHECK FOR EXCEPTION CATEGORIES
Record: Not a device-ID/quirk/DT/docs exception. Ordinary memory-safety
fix.

Step 9.4: MAKE YOUR DECISION
This tree’s iwlwifi UEFI reduce-power parser has the hole; the patch is
a small, reviewed bounds check that prevents a real OOB read. That meets
stable rules for **this** checkout.

What it solves for this tree: `iwl_uefi_reduce_power_parse()` can read
12 bytes from a PNVM SKU TLV whose declared length is shorter, and can
walk off the UEFI blob when remaining length is also `< 12`. That
matters on Intel WiFi + EFI machines with a bad Reduced Power variable
(crash/KASAN on init). The change is six lines, no new ABI, no extra
commits required, and the sibling PNVM check is independent.

Risk vs benefit: very low regression risk vs preventing an OOB on a
widely used driver. Main caveat is the uncommon trigger; that does not
make the hole theoretical in the code.

Verification:
- [Phase 1] Subject/body/tags: validate SKU TLV length; SOB Hou +
  Korenblit; Link `24417-2`; no Fixes/Reported-by/Cc:stable
- [Phase 2] Diff: +6 in `iwl_uefi_reduce_power_parse()`; `if (tlv_len <
  sizeof(*tlv_sku_id)) return -EINVAL`
- [Phase 2] `struct iwl_sku_id` is `__le32 data[3]` in `fw/api/alive.h`;
  `iwl_ucode_tlv` is 8-byte header + `data[]` in `fw/file.h`
- [Phase 3] `git describe HEAD` / Makefile: v7.3-rc4 / 7.3.0-rc4
- [Phase 3] `git merge-base --is-ancestor f051995c53958 HEAD` → yes
- [Phase 3] Blame: parser from 9dad325f9d575 (v5.14-rc1); fix lines from
  f051995c53958 (v7.3-rc1)
- [Phase 3] Sibling 7410e4548a17b is patch 1/2 on `pnvm.c`, not a apply-
  prereq
- [Phase 4] `b4 dig -c f051995c53958`: v1 2026-06-30, v2 2026-07-15;
  mbox is the patch
- [Phase 4] LKML mirror: Miri “Please use sizeof(*tlv_sku_id)”; no NAK
- [Phase 4] Stable lore search: no discussion of this subject
- [Phase 5] Only caller `iwl_pnvm_load_reduce_power_to_trans` ←
  `iwl_pnvm_load` ← mvm/mld fw init; gated on CONFIG_EFI
- [Phase 5] Buffer from `iwl_uefi_get_reduced_power` / verified EFI
  variable (`kmalloc` then `kmemdup`)
- [Phase 6] Buggy parser present; fix already in this tree; would apply
  cleanly
- [Phase 7] iwlwifi, maintainer Miri Korenblit
- [Phase 8] Failure: OOB read / possible oops on WiFi init; HIGH;
  trigger EFI-malformed
- UNVERIFIED: lore.kernel.org HTTP 403 on direct thread fetch; content
  recovered from b4 and LKML mirrors

**YES**

 drivers/net/wireless/intel/iwlwifi/fw/uefi.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/uefi.c b/drivers/net/wireless/intel/iwlwifi/fw/uefi.c
index 4ae4d215e633e..395973c3f2bf8 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/uefi.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/uefi.c
@@ -248,6 +248,12 @@ int iwl_uefi_reduce_power_parse(struct iwl_trans *trans,
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

