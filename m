Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D85FB4D8DAF;
	Mon, 31 Aug 2026 13:39:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183555; cv=none; b=fQTzDOof/0dlv5jK4B2h90VbY1LIw8uO7flTcS/k7AdNlWwt8qGvSRfjqnjIDBG7AHLuQOorWAiN77rt8aEJtWiggfHEC4v/mNOcWoxDkjpUOojTCWs9wy9DhIuk3leTwsUDycsRlzJc06dy1SxBSmFr8yqe39lqmS6NIpldfDY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183555; c=relaxed/simple;
	bh=lyvCDatf+oYsojCfkpe8tbqrRpEMqXfeyOEyLBHr0E0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iI5b4JKLq968X88YoAPsZ8IybE8HKKwlV0LoDxGeajjqp5sVlGGtYtHcV/QvLy5E339CbSXH0dQS0gK3Y+2SziKt4tX9Dxa5TxzYsaal0Y8jaMb/66yVzSjZkjxqCQUGXR1YgcDJtBhyYjA4V3sNv4zxpRJ2bagMnLJcH6CWR1A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aMJaEw1B; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aMJaEw1B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2CB91F00ADB;
	Mon, 31 Aug 2026 13:39:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183552;
	bh=cEBSzX+d6hFnn7uTSuomyYuIaCgNNKnHO+PUmb2dsLg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aMJaEw1BMIDISV0hNxfJuDoOUZ50rd2uy7BrQwhWGOYq4RIp3RdJvL+hSjqzPuz9O
	 jl1wAsbiurBpiuQne39JMEUMBfgm4uApPHHkITkXSscYmXz4sYyRtJmeBi5wijFc/7
	 48lWr3igdOTbdzfSxfnrU/Otv+ioB2ixjrbi9k+ixT2HH93c8H7kFaUFNV3DlFB2IL
	 XJsS+cZxT9mF3FT8yAjVfDDpRA2T1XQne8myJqfaJffS/OyuRz1kbK9iYQMGxXcDyl
	 8Sc6TLvd9mj6dS1v9zsuBf6JknIZ/DjP0lhEy3kiR3+pe0SJq4ImLLtNKDTvj8/F1U
	 p+wUwG/iQzszA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.1] wifi: iwlwifi: acpi: validate WGDS table revision index
Date: Mon, 31 Aug 2026 09:23:13 -0400
Message-ID: <20260831133314.4125787-165-sashal@kernel.org>
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

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

[ Upstream commit 954e821f42aaca56073ca830c5fd4bcf1a89048c ]

Check tbl_rev bounds before BIT(tbl_rev) to avoid undefined shifts when
firmware reports an invalid revision value.

Assisted-by: GitHubCopilot:GPT-5.3-Codex
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Link: https://patch.msgid.link/20260717173215.52a01f841f2a.Ic0131eaac31d9ff71b169138d9b0865cb39b44a9@changeid
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit Message Forensics

**Step 1.1 — Subject line**
Record: `[wifi: iwlwifi: acpi]` `[validate]` — Validate WGDS ACPI table
revision index before using it in a bit-shift.

**Step 1.2 — Tags**
Record:
- **Fixes:** — none
- **Reported-by:** — none
- **Tested-by:** — none
- **Reviewed-by:** — none
- **Acked-by:** — none
- **Cc: stable@vger.kernel.org:** — none
- **Link:** https://patch.msgid.link/20260717173215.52a01f841f2a.Ic0131e
  aac31d9ff71b169138d9b0865cb39b44a9@changeid
- **Signed-off-by:** Emmanuel Grumbach `<emmanuel.grumbach@intel.com>`,
  Miri Korenblit `<miriam.rachel.korenblit@intel.com>`
- **Assisted-by:** GitHubCopilot:GPT-5.3-Codex

Notable: no fuzzer report, no user report, no explicit stable
nomination.

**Step 1.3 — Body analysis**
Record:
- **Bug:** `tbl_rev` is used in `BIT(tbl_rev)` without validating it is
  a valid bit index for the `u8 revisions` mask.
- **Symptom:** Undefined left-shift if ACPI reports an out-of-range
  revision (commit message says “firmware”; in code the value comes from
  the ACPI WGDS package revision field).
- **Root cause:** `iwl_acpi_get_wifi_pkg_range()` copies the ACPI
  integer into `*tbl_rev` but does not bound-check it;
  `iwl_acpi_get_wgds_table()` then does `BIT(tbl_rev) &
  rev_data[idx].revisions`.

**Step 1.4 — Hidden bug fix?**
Record: No — this is an explicit defensive validation fix, not cleanup
disguised as a bug fix.

---

## Phase 2: Diff Analysis

**Step 2.1 — Inventory**
Record:
- **Files:** `drivers/net/wireless/intel/iwlwifi/fw/acpi.c` (+5 / -0)
- **Function:** `iwl_acpi_get_wgds_table()`
- **Scope:** Single-file, surgical fix in one loop body

**Step 2.2 — Code flow change**
Record:
- **Before:** On successful `iwl_acpi_get_wifi_pkg_range()`, code
  immediately evaluates `BIT(tbl_rev) & rev_data[idx].revisions`.
- **After:** Rejects `tbl_rev < 0` or `tbl_rev >= 8` (`BITS_PER_BYTE *
  sizeof(u8)`) and `continue`s to the next `rev_data[]` entry.
- **Path affected:** ACPI WGDS table parsing during driver
  regulatory/SAR init (normal probe path, not error-only).

**Step 2.3 — Bug mechanism**
Record:
- **Category:** Memory safety / undefined behavior (invalid shift),
  logic/correctness.
- **Mechanism:** `tbl_rev` is assigned from a 64-bit ACPI integer into
  an `int` (`acpi.c:249`). Large values can truncate to negative; large
  positive values can be `>= BITS_PER_LONG`. `BIT(nr)` is `(UL(1) <<
  (nr))` (`include/vdos/bits.h`), so out-of-range shifts are undefined
  in C. The `revisions` field is `u8`, so only bits 0–7 are meaningful.

**Step 2.4 — Fix quality**
Record:
- Fix is minimal and matches an existing pattern in the same file
  (`iwl_acpi_get_tas_table()` already checks `tbl_rev < 0 || tbl_rev >
  2` at line 304).
- Regression risk is very low: invalid revisions are skipped instead of
  provoking UB.
- No API or behavior change for valid ACPI tables.

---

## Phase 3: Git History Investigation

**Step 3.1 — Blame**
Record: The vulnerable `BIT(tbl_rev)` line is at `acpi.c:764` in this
tree. `git blame` attributes it to merge commit `5d324e5159d9e` (shallow
history artifact). The same `rev_data` + `BIT(tbl_rev)` pattern is
present in tag `v6.18`, so the bug exists since the 6.18 release in this
series.

**Step 3.2 — Fixes: tag**
Record: N/A — no `Fixes:` tag.

**Step 3.3 — Related file history**
Record:
- Commit `954e821f42aac` is on `master` but not in stable `HEAD`
  (6.18.44).
- Related mainline-only WGDS work (`f951689793e6c`, `c5cc3d3717783`) is
  **not** in this 6.18.y tree.
- This fix is patch **3/5** of an iwlwifi-fixes series, but the 5-line
  hunk is standalone and does not depend on the other series members for
  correctness.

**Step 3.4 — Author context**
Record: Emmanuel Grumbach is a senior Intel iwlwifi developer; Miri
Korenblit committed it. No other recent acpi.c commits from this author
in the shallow stable history.

**Step 3.5 — Dependencies**
Record: No prerequisites. `git cherry-pick --no-commit 954e821f42aac`
auto-merged cleanly on stable `HEAD` (5 lines added, 1 file).

---

## Phase 4: Mailing List and External Research

**Step 4.1 — Original discussion**
Record:
- `b4 dig -c 954e821f42aac` → https://patch.msgid.link/20260717173215.52
  a01f841f2a.Ic0131eaac31d9ff71b169138d9b0865cb39b44a9@changeid
- Part of `[PATCH iwlwifi-fixes 3/5]` series (v1 only in b4 `-a`
  output).
- Mbox saved to `/tmp/wgds_thread.mbox`; thread contains patch
  submissions only — no review replies, no stable nominations, no NAKs
  found.

**Step 4.2 — Reviewers**
Record: `b4 dig -w` shows To/Cc: Miri Korenblit,
johannes@sipsolutions.net, linux-wireless@vger.kernel.org, Emmanuel
Grumbach. No `Reviewed-by:` in the committed version.

**Step 4.3 — Bug report**
Record: N/A — no external bug report linked.

**Step 4.4 — Series context**
Record: 5-patch iwlwifi-fixes series (FW parser bounds, PNVM, this WGDS
fix, SEC_RT TLV, etc.). This patch is independently applicable.

**Step 4.5 — Stable list**
Record: No stable-list discussion found (WebFetch to lore blocked by bot
protection; mbox grep found no “stable” mentions).

---

## Phase 5: Code Semantic Analysis

**Step 5.1 — Key functions**
Record: `iwl_acpi_get_wgds_table()`, called via
`iwl_acpi_get_wifi_pkg_range()`.

**Step 5.2 — Callers**
Record:
- `iwl_bios_get_wgds_table()` — macro-generated in `fw/regulatory.c:35`,
  tries UEFI then ACPI.
- Called from:
  - `mvm/fw.c:1231,1252` during MVM firmware/SAR table load
  - `mld/regulatory.c:39,58` during MLD regulatory init

**Step 5.3 — Callees**
Record: `iwl_acpi_get_object()`, `iwl_acpi_get_wifi_pkg_range()`, ACPI
package parsing, `kfree()` on exit.

**Step 5.4 — Reachability**
Record: Reachable at Intel WiFi driver probe/init on ACPI platforms
(`CONFIG_ACPI`, `CONFIG_IWLMVM` or `CONFIG_IWLMLD`). Trigger requires
malformed WGDS ACPI data, not a direct syscall — but it runs on every
boot for affected hardware.

**Step 5.5 — Similar patterns**
Record: `iwl_acpi_get_tas_table()` already validates `tbl_rev` bounds
(`acpi.c:304`). This fix brings WGDS parsing in line with that
precedent.

---

## Phase 6: Cross-Reference Against Local Tree

**Step 6.1 — Buggy code present?**
Record: **Yes.** Local tree is **6.18.44** (`git describe HEAD` →
`v6.18.44-2-g1b9e1abadee04`, `make kernelversion` → `6.18.44`), detached
from `stable/linux-6.18.y`. Vulnerable line confirmed at `acpi.c:764`:

```764:765:drivers/net/wireless/intel/iwlwifi/fw/acpi.c
                        if (!(BIT(tbl_rev) & rev_data[idx].revisions))
                                continue;
```

**Step 6.2 — Backport complications**
Record: **Clean apply** — verified by test cherry-pick. No conflicts.

**Step 6.3 — Fix already present?**
Record: **No.** `git log HEAD --grep="validate WGDS"` returns nothing;
bounds check not in current `acpi.c`.

---

## Phase 7: Subsystem and Maintainer Context

**Step 7.1 — Subsystem**
Record: `drivers/net/wireless/intel/iwlwifi` — **IMPORTANT** (Intel
WiFi, widely deployed on laptops).

**Step 7.2 — Activity**
Record: Active stable backports in this tree include several recent
iwlwifi validation fixes (`eae7fdf7d4469`, `a076b0c457c71`,
`1de92789ce31e`, etc.).

---

## Phase 8: Impact and Risk Assessment

**Step 8.1 — Who is affected**
Record: Intel WiFi users on ACPI platforms (laptops/desktops) during
driver initialization.

**Step 8.2 — Trigger conditions**
Record: ACPI WGDS table with revision integer outside 0–7 (or negative
due to truncation). Uncommon but plausible with buggy OEM ACPI. Not
user-triggerable via normal syscalls; ACPI is the input source.

**Step 8.3 — Failure mode severity**
Record: **HIGH** potential (undefined behavior → possible oops/panic at
probe); **MEDIUM** likelihood (requires bad ACPI). Not data corruption,
but can prevent WiFi from loading or crash the kernel during probe.

**Step 8.4 — Risk vs benefit**
Record:
- **Benefit:** Eliminates UB on a real probe path; aligns with existing
  in-file validation style.
- **Risk:** Very low — 5 lines, skip-invalid-and-continue semantics.
- **Ratio:** Favorable for stable.

---

## Phase 9: Final Synthesis

**Step 9.1 — Evidence summary**

FOR backport:
- Real UB bug in production code present since 6.18.0
- Probe-time path on common hardware
- Tiny, obviously correct, applies cleanly
- Consistent with existing `tbl_rev` validation elsewhere in same file
- iwlwifi stable tree already accepts similar validation fixes

AGAINST backport:
- No syzbot/user report
- Requires malformed ACPI (uncommon)
- Part of a larger series (though this hunk is independent)
- Commit message slightly mislabels ACPI revision as “firmware”

Unresolved: No runtime crash report confirming the bug was hit in the
field.

**Step 9.2 — Stable rules checklist**
1. Obviously correct and tested? **PASS** — logic is clear; no Tested-by
   but pattern is established in-file.
2. Fixes a real bug? **PASS** — C undefined shift on invalid index.
3. Important issue? **PASS** — probe-time UB with potential kernel
   crash.
4. Small and contained? **PASS** — 5 lines, 1 file.
5. No new features/APIs? **PASS** — pure validation.
6. Can apply to local tree? **PASS** — verified clean cherry-pick.

**Step 9.3 — Exception categories**
Record: None (not device ID, quirk, DT, build, or docs).

**Step 9.4 — Problem and decision**

This commit adds a bounds check on `tbl_rev` before `BIT(tbl_rev)` in
`iwl_acpi_get_wgds_table()`. Without it, a malformed ACPI WGDS revision
field can cause undefined bit-shifts during Intel WiFi driver
initialization on 6.18.y systems. The fix is minimal, self-contained,
matches existing validation in the same driver file, and applies cleanly
to the checked-out **linux-6.18.y (6.18.44)** tree where the vulnerable
code is present and the fix is not yet applied.

---

## Verification

- [Phase 1] Parsed commit `954e821f42aac`: subject, body, Link tag,
  SOBs; no Reported-by/syzbot/Fixes/stable tags
- [Phase 2] Read diff: +5 lines in `iwl_acpi_get_wgds_table()` before
  `BIT(tbl_rev)`
- [Phase 2] Read `iwl_acpi_get_wifi_pkg_range()` at `acpi.c:249`:
  `*tbl_rev = data->package.elements[0].integer.value`
- [Phase 2] Confirmed `BIT()` definition in `include/vdso/bits.h`:
  `(UL(1) << (nr))`
- [Phase 3] `git describe HEAD` → `v6.18.44-2-g1b9e1abadee04`; `make
  kernelversion` → `6.18.44`
- [Phase 3] `git log HEAD..master --
  drivers/net/wireless/intel/iwlwifi/fw/acpi.c` → fix commit
  `954e821f42aac` not in stable HEAD
- [Phase 3] `git show v6.18:.../acpi.c | grep rev_data` → buggy pattern
  present in v6.18.0
- [Phase 3] Cherry-pick test: clean auto-merge, 5 lines added
- [Phase 3] `f951689793e6c`, `c5cc3d3717783` confirmed **NOT** in
  v6.18/HEAD (mainline-only related work)
- [Phase 4] `b4 dig -c 954e821f42aac` → lore URL found; patch 3/5 of
  iwlwifi-fixes series
- [Phase 4] `b4 dig -a`, `b4 dig -w` → v1 series; CC list includes
  linux-wireless and Johannes
- [Phase 4] Mbox grep: no stable/Reviewed/Acked/Tested replies in thread
- [Phase 5] `grep iwl_bios_get_wgds_table` → callers in `mvm/fw.c`,
  `mld/regulatory.c`; loader in `fw/regulatory.c:35`
- [Phase 5] Existing precedent: `acpi.c:304` validates `tbl_rev` for
  WTAS table
- [Phase 6] Confirmed vulnerable code at `acpi.c:764` in current tree;
  fix absent
- [Phase 8] Assessed severity: UB at probe, ACPI-triggered, Intel WiFi
  laptops

**YES**The background checks finished and line up with the earlier
analysis:

- **`iwl_acpi_get_wgds_table()`** goes back to the UEFI/SAR table work
  (e.g. `427661e4c4888` / `2594e4d9e1a2d`); the `rev_data` +
  `BIT(tbl_rev)` path is already in **6.18.y**.
- Related mainline WGDS commits (`f951689793e6c`, `c5cc3d3717783`,
  `f863093a914c4`) are **not** in this **6.18.44** tree — only the small
  bounds-check fix is needed here.
- This checkout is **detached from `stable/linux-6.18.y`** at
  **6.18.44**, well behind `master`.

**Verdict unchanged: YES** — backport `954e821f42aac`; it applies
cleanly and fixes real undefined-shift behavior on the ACPI WGDS probe
path.

 drivers/net/wireless/intel/iwlwifi/fw/acpi.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/acpi.c b/drivers/net/wireless/intel/iwlwifi/fw/acpi.c
index 52edc19d8cdd5..852c5ac36c221 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/acpi.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/acpi.c
@@ -761,6 +761,11 @@ int iwl_acpi_get_wgds_table(struct iwl_fw_runtime *fwrt)
 						       min_size, max_size,
 						       &tbl_rev);
 		if (!IS_ERR(wifi_pkg)) {
+			if (tbl_rev < 0 ||
+			    tbl_rev >= BITS_PER_BYTE *
+			    sizeof(rev_data[idx].revisions))
+				continue;
+
 			if (!(BIT(tbl_rev) & rev_data[idx].revisions))
 				continue;
 
-- 
2.53.0

