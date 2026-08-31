Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B77C94766A6;
	Mon, 31 Aug 2026 13:52:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184356; cv=none; b=NEnERCuIWIzRlRI6okHJCu5YYko3ej5qAbR2JIjt/3WtocBu1LrhiRf1R70i1okTopCBILOgnm3rlwV2qOPYzfWV208Wrbl2Yh8Mhj5m6kTKLxJpbxXjAI2DqrYdN7NbzXqT6/LFrceldoFiq2/TzyodvlEL+ZC+oeWemUUFQW4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184356; c=relaxed/simple;
	bh=QbEr+JdR84F7J6wG2HvrufIrBppoZO7MI7U2CyYSOxk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NiD4Onp6yYkOuZEz6cqy/fdSRxLbUGKbuWfmS/K/SndtKEb8+WKtclsBrxsia01FvVDfYInWW+irmZm/HhLX+7nFU84DILnVCjX7PJ5WmTZVPpGGl80w0Z7JDksOmmOMSQEA25Z4jGDWwxGHE63brIIbrJwpU5xsf08tzG+iOZk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lSIogYG9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lSIogYG9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A9F51F00ACF;
	Mon, 31 Aug 2026 13:52:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788184353;
	bh=tPtw9MKqIi0RxLscb3TDV4Yi6JhANjAWDQO3gzTLkOo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lSIogYG9hWnpj2+f1DYM7pWzrQ/CjzSR4illcDIVraBixCjslSo8um+khaUoCg00+
	 mcCZW6ix5h4Agc9TgZdcXFGsfAop9CJkV/djFgbvwuFYJt193L4+Zhuwky1yyTi6KB
	 fdhtXxD9fe29hbpwfpov/yVmeEKmYId/62WXqyaQOsEAPcsC6z/li4aHX5If2YznUP
	 vlNNOEFBERVbCmtG8JiLdlvXBKNmVetmG+LbkGkM12Ge8USkj3FC/Oy3lUD9Fa0/wF
	 r/f7oomRhJI/mUxY8DcPN9iEmk7c4vdXlQTemhk6T5BVz1DbxLveDXHMd5SjchCKXY
	 y2uoyrC1sHn1A==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] wifi: iwlwifi: mld: don't parse a notif before checking its length
Date: Mon, 31 Aug 2026 09:31:11 -0400
Message-ID: <20260831133314.4125787-643-sashal@kernel.org>
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

[ Upstream commit 119c353467d802865e2f5da210b64727c5e334b4 ]

In order to compure the size of the iwl_mcc_update_resp which has a
variable length, we need to know the number of channels.
In order to read the number of channels, we must first check the
payload is long enough to read at least that.

Add this check.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Link: https://patch.msgid.link/20260714141909.c2f644919011.Ic579e9935b92a674c96ccc44713140b5b4bc5d10@changeid
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: `wifi: iwlwifi: mld: don't parse a notif
before checking its length`

**Tree under review:** Linux **6.18.44** (`v6.18.44-1-g2736c32da98b9`,
detached from `stable/linux-6.18.y`)

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Subject line
**Record:** `[wifi: iwlwifi: mld]` `[don't parse / prevent]` — validate
MCC response payload length before reading `n_channels` from a variable-
length firmware notification.

### Step 1.2: Tags
**Record:**
- **Fixes:** — none
- **Reported-by:** — none
- **Tested-by:** — none
- **Reviewed-by:** — none in commit message (series has `Reviewed-by:
  Ilan Peer` on related patches in thread)
- **Acked-by:** — none
- **Link:** https://patch.msgid.link/20260714141909.c2f644919011.Ic579e9
  935b92a674c96ccc44713140b5b4bc5d10@changeid
- **Cc: stable:** — none (expected for manual review)
- **Signed-off-by:** Emmanuel Grumbach, Miri Korenblit (ignore pipeline
  SOBs)

Notable: part of `[PATCH iwlwifi-fixes 04/15]` series; no syzbot report.

### Step 1.3: Body analysis
**Record:**
- **Bug:** `iwl_mld_copy_mcc_resp()` reads `n_channels` and computes
  `struct_size()` before verifying the packet is long enough to contain
  the fixed header.
- **Symptom:** Out-of-bounds read from firmware response buffer on
  truncated/malformed MCC response; possible crash or unpredictable
  `struct_size()` / `kmemdup()` behavior.
- **Root cause:** Variable-length `iwl_mcc_update_resp_v8` parsing
  assumes header is present before accessing `n_channels` (at byte
  offset 24 in the fixed header).

### Step 1.4: Hidden bug fix?
**Record:** Yes — despite not using "fix" in subject, this is a
defensive bounds-check bug fix, same class as patch 08/15 in the same
series (`mvm: validate MCC header before n_channels`).

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory
**Record:**
- **File:** `drivers/net/wireless/intel/iwlwifi/mld/mcc.c` (+8 / -2, net
  +6 lines)
- **Function:** `iwl_mld_copy_mcc_resp()`
- **Scope:** Single-file, surgical fix

### Step 2.2: Code flow per hunk
**Record:**
- **Before:** Cast `pkt->data` → immediately read
  `mcc_resp_v8->n_channels` → compute `notif_len` → then check
  `payload_len == notif_len`.
- **After:** Check `payload_len >= sizeof(*mcc_resp_v8)` first → only
  then read `n_channels` and compute `notif_len` → existing exact-size
  check unchanged.
- **Path affected:** Firmware MCC update command response parsing (error
  path on short packets).

### Step 2.3: Bug mechanism
**Record:** **Buffer overflow / out-of-bounds read (memory safety).**
`n_channels` sits at offset 24 in `struct iwl_mcc_update_resp_v8`.
Reading it when `iwl_rx_packet_payload_len(pkt) < 24` reads past the
packet buffer. A garbage `n_channels` can also produce a bogus
`struct_size()` result before the equality check.

### Step 2.4: Fix quality
**Record:** Obviously correct; matches established iwlwifi pattern
(`iwl_rx_packet_payload_len(pkt) < sizeof(*struct)` before field
access). Minimal regression risk — only rejects packets that were
already invalid.

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame
**Record:** Shallow repo limits blame depth; all visible blame points to
merge commit `5d324e5159d9e`. Function `iwl_mld_copy_mcc_resp()` is
present in current tree with the buggy ordering.

### Step 3.2: Fixes: tag
**Record:** N/A — no `Fixes:` tag.

### Step 3.3: Related file history
**Record:** Upstream fix commit
`119c353467d802865e2f5da210b64727c5e334b4` exists but is **not** an
ancestor of HEAD (`merge-base --is-ancestor` exit=1). Part of iwlwifi-
fixes series (patches 01–15, July 2026). This patch (04/15) is
**standalone** — only touches `mcc.c`.

### Step 3.4: Author context
**Record:** Emmanuel Grumbach (Intel iwlwifi maintainer) and Miri
Korenblit (Intel iwlwifi developer). Same authors on a series of
firmware-notification validation fixes.

### Step 3.5: Dependencies
**Record:** None. No prerequisite commits required; patch applies
cleanly to current `mcc.c`.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: Original discussion
**Record:** `b4 dig -c 119c353467d802865e2f5da210b64727c5e334b4` →
[PATCH iwlwifi-fixes 04/15] thread at patch.msgid.link URL above. Series
v1 only (no v2/v3 revisions found).

### Step 4.2: Reviewers
**Record:** `b4 dig -w`: Miri Korenblit, johannes@sipsolutions.net,
linux-wireless@vger.kernel.org, Emmanuel Grumbach CC'd.

### Step 4.3: Bug report
**Record:** No external bug report or syzbot link. Proactive hardening
found during iwlwifi-fixes audit (same series adds similar MCC
validation for mvm in patch 08/15).

### Step 4.4: Related patches
**Record:** Same series includes `mvm: validate MCC header before
n_channels` (08/15) — identical bug class in `iwl_mvm_update_mcc()`.
That mvm fix is a **separate commit**, not a prerequisite for this one.

### Step 4.5: Stable list history
**Record:** Not searched on lore stable list; no stable nomination found
in thread.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Key functions
**Record:** `iwl_mld_copy_mcc_resp()` (modified); callers:
`iwl_mld_update_mcc()`.

### Step 5.2: Callers
**Record:**
- `iwl_mld_update_mcc()` ← `iwl_mld_get_regdomain()`
- `iwl_mld_get_regdomain()` called from:
  - `iwl_mld_init_mcc()` — driver init / firmware start (`fw.c:545`)
  - `iwl_mld_handle_update_mcc()` — async MCC chub notification
    (`notif.c:445` → `mcc.c:278`)
  - `iwl_mld_get_current_regdomain()`, `iwl_mld_apply_last_mcc()`

### Step 5.3: Callees
**Record:** `iwl_rx_packet_payload_len()`, `__le32_to_cpu()`,
`struct_size()`, `kmemdup()`.

### Step 5.4: Reachability
**Record:** Triggered during iwlwifi MLD driver probe/init and runtime
regulatory/MCC updates on `CONFIG_IWLMLD` hardware. Requires truncated
or malformed firmware MCC response — plausible during firmware errors,
race conditions, or hostile/malfunctioning firmware.

### Step 5.5: Similar patterns
**Record:** Same pattern already used in `mld/rx.c`, `mld/thermal.c`,
`mld/ptp.c`, `fw/pnvm.c`, `fw/dhc-utils.h`. The mvm path has the same
pre-check gap (patch 08/15 addresses it separately).

---

## PHASE 6: CROSS-REFERENCE AGAINST LOCAL TREE (6.18.y)

### Step 6.1: Buggy code present?
**Record:** **Yes.** Current `mcc.c` lines 20–23 read `n_channels`
before any length check:

```20:26:drivers/net/wireless/intel/iwlwifi/mld/mcc.c
        const struct iwl_mcc_update_resp_v8 *mcc_resp_v8 = (const void
*)pkt->data;
        int n_channels = __le32_to_cpu(mcc_resp_v8->n_channels);
        struct iwl_mcc_update_resp_v8 *resp_cp;
        int notif_len = struct_size(resp_cp, channels, n_channels);

        if (iwl_rx_packet_payload_len(pkt) != notif_len)
```

`IWLMLD` and `mld/mcc.c` are both present in this tree.

### Step 6.2: Backport complications
**Record:** **Clean apply expected.** Diff matches current file; no
conflicting changes observed.

### Step 6.3: Related fixes already present?
**Record:** Fix commit `119c353467d80` / stable-queue `7aec4baa547f6` is
**not** in HEAD. No equivalent length check found in current `mcc.c`.

---

## PHASE 7: SUBSYSTEM CONTEXT

### Step 7.1: Subsystem criticality
**Record:** **IMPORTANT** — `drivers/net/wireless/intel/iwlwifi/mld/`
(Intel WiFi driver, MLD/MLO path for newer hardware). Not core kernel,
but affects all users of IWLMLD-supported devices.

### Step 7.2: Subsystem activity
**Record:** Actively maintained; multiple recent iwlwifi mld stable
fixes already in this tree (e.g. `3a74aaad04735` null-deref fix,
`1de92789ce31e` sta_mask validation).

---

## PHASE 8: IMPACT AND RISK

### Step 8.1: Who is affected
**Record:** Users with `CONFIG_IWLMLD` Intel WiFi devices (newer chips
using the MLD driver path).

### Step 8.2: Trigger conditions
**Record:** Firmware returns MCC update response shorter than 24 bytes
(fixed header size). Uncommon in normal operation; realistic during
firmware malfunction, error recovery, or edge-case races. Not directly
userspace-triggerable, but firmware-facing validation is standard
iwlwifi hardening.

### Step 8.3: Failure mode severity
**Record:** Out-of-bounds kernel read → **HIGH** (potential oops with
KASAN; possible info leak or crash without sanitizers). Not data
corruption, but can take down WiFi subsystem or panic kernel.

### Step 8.4: Risk-benefit
**Record:**
- **Benefit:** MEDIUM-HIGH for IWLMLD users — prevents OOB read on a
  real code path during init and regulatory updates.
- **Risk:** VERY LOW — 6-line addition, early `-EINVAL` return, no
  API/behavior change for valid packets.
- **Ratio:** Favorable for stable inclusion.

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence summary

**FOR backport:**
- Real, verifiable OOB-read bug in existing 6.18.y code
- Small, obviously correct, self-contained fix
- Matches iwlwifi conventions and sibling fix in same series (mvm MCC)
- Called from driver init and runtime MCC/regulatory paths
- Applies cleanly; no dependencies
- Intel maintainer-authored validation fix

**AGAINST backport:**
- No syzbot/user crash report (proactive hardening)
- Only affects `CONFIG_IWLMLD` hardware (subset of iwlwifi users)
- Requires malformed/truncated firmware response (not everyday path)

**Unresolved:** Exact commit that introduced `iwl_mld_copy_mcc_resp()` —
shallow repo prevented full `git log -S` history (command hung). Not
needed for 6.18.y decision since buggy code is confirmed present.

### Step 9.2: Stable rules checklist
1. Obviously correct and tested? **PASS** — logic is standard; no
   Tested-by but pattern is well-established in iwlwifi.
2. Fixes a real bug? **PASS** — OOB read before bounds check.
3. Important issue? **PASS** — HIGH severity memory safety on firmware
   parsing path.
4. Small and contained? **PASS** — 6 net lines, one function.
5. No new features or APIs? **PASS** — validation only.
6. Can apply to local tree? **PASS** — code exists, clean apply.

### Step 9.3: Exception categories
**Record:** None (not a quirk/DT/build/doc fix) — standard bug fix.

### Step 9.4: Decision rationale

This commit fixes a genuine out-of-bounds read in
`iwl_mld_copy_mcc_resp()` on the Linux 6.18.y tree. The buggy code is
present at HEAD; the fix is not. The change is minimal, follows existing
iwlwifi validation patterns, and guards firmware-response parsing during
driver initialization and regulatory-domain updates — paths that matter
for IWLMLD hardware stability. While no crash report was cited, the bug
mechanism is clear and the fix is low-risk.

---

## Verification

- [Phase 1] Parsed subject, tags, body from provided commit message and
  `git show 7aec4baa547f6`
- [Phase 2] Read current `mcc.c`; confirmed buggy ordering at lines
  20–25
- [Phase 2] Calculated fixed header size = 24 bytes from `nvm-reg.h`
  struct layout
- [Phase 3] `git describe HEAD` → v6.18.44; branch detached from
  `stable/linux-6.18.y`
- [Phase 3] `git merge-base --is-ancestor 119c353467d80 HEAD` → exit 1
  (fix not in tree)
- [Phase 3] `git show 7aec4baa547f6` — confirmed diff matches proposed
  fix
- [Phase 4] `b4 dig -c 119c353467d802865e2f5da210b64727c5e334b4` — found
  patch 04/15 thread
- [Phase 4] `b4 dig -w` — confirmed CC list (linux-wireless, Grumbach,
  Korenblit)
- [Phase 4] `b4 dig -a` — v1 series only
- [Phase 4] `b4 dig -m /tmp/iwl_mcc_fix.mbox` — downloaded thread; found
  series context and mvm patch 08/15
- [Phase 5] Traced call chain: `fw.c:545` → `iwl_mld_init_mcc` →
  `iwl_mld_get_regdomain` → `iwl_mld_update_mcc` →
  `iwl_mld_copy_mcc_resp`
- [Phase 5] `notif.c:445` — MCC chub handler routes to
  `iwl_mld_handle_update_mcc`
- [Phase 6] Confirmed `CONFIG_IWLMLD` in Kconfig; `mcc.c` in
  `mld/Makefile`
- [Phase 6] Confirmed mvm `nvm.c` has same pre-check gap (separate fix
  in series 08/15)
- [Phase 8] `include/linux/overflow.h` — `struct_size()` returns
  `SIZE_MAX` on overflow
- UNVERIFIED: Exact introduction commit of `iwl_mld_copy_mcc_resp`
  (shallow repo; `git log -S` hung)

**YES**Three background git history commands timed out on this shallow
checkout, but the important check already completed in the foreground:

- **`merge-base --is-ancestor 119c353467d80 HEAD`** returned exit code 1
  — the fix is **not** in the current 6.18.44 tree.
- **`git log -S`** / **`git branch --contains`** on the fix commit hung
  before finishing, so the exact introduction commit of
  `iwl_mld_copy_mcc_resp()` was not determined.

That gap does not change the verdict: the buggy code is present in
`mld/mcc.c` today, and the fix is a small, self-contained bounds check
that applies cleanly.

**YES** for backport to this 6.18.y tree.

 drivers/net/wireless/intel/iwlwifi/mld/mcc.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mld/mcc.c b/drivers/net/wireless/intel/iwlwifi/mld/mcc.c
index 8502129abe493..830c251f43afc 100644
--- a/drivers/net/wireless/intel/iwlwifi/mld/mcc.c
+++ b/drivers/net/wireless/intel/iwlwifi/mld/mcc.c
@@ -18,9 +18,15 @@ static struct iwl_mcc_update_resp_v8 *
 iwl_mld_copy_mcc_resp(const struct iwl_rx_packet *pkt)
 {
 	const struct iwl_mcc_update_resp_v8 *mcc_resp_v8 = (const void *)pkt->data;
-	int n_channels = __le32_to_cpu(mcc_resp_v8->n_channels);
 	struct iwl_mcc_update_resp_v8 *resp_cp;
-	int notif_len = struct_size(resp_cp, channels, n_channels);
+	int n_channels;
+	int notif_len;
+
+	if (iwl_rx_packet_payload_len(pkt) < sizeof(*mcc_resp_v8))
+		return ERR_PTR(-EINVAL);
+
+	n_channels = __le32_to_cpu(mcc_resp_v8->n_channels);
+	notif_len = struct_size(resp_cp, channels, n_channels);
 
 	if (iwl_rx_packet_payload_len(pkt) != notif_len)
 		return ERR_PTR(-EINVAL);
-- 
2.53.0

