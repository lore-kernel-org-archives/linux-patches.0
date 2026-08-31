Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F5C346F489;
	Mon, 31 Aug 2026 13:48:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184117; cv=none; b=DOMrJVQU6qksnDoMRlp36beVi6Z3FAjIib695YSYe1WTG5ZIkEQ8Njo5JPNy5gghFRXYkqvh+xVedYHfNwUThSsUx4XfIY0FQC1DjmXOXugcHJHwyVcqSgwoVtW4375mU5VGfxx/22W7u504YaETJpjz2CbnlNxt0g1Rnk6VabQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184117; c=relaxed/simple;
	bh=kEccnSqcdwaRbdVWv6CyagxOJgt/MHw2pTVWaSzf6tM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NykQkrcKnDS5EJ2TcaP4zu5kofaq8z2WswcNUavUYFbmJG0yJrlXMzpqV7ARRVN6TrAK52g/UHFA+jxoIIt3+YoI0SByHvuuJKAkuR3BkNXN8yX0qcd3aSttd9jfN3uMESjZlNudu4fVkik9LjSC/BZtXSYKiImD+jUUCEZUlrA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mhQhaJQW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mhQhaJQW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA9931F000E9;
	Mon, 31 Aug 2026 13:48:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788184114;
	bh=GKgVBceKmcZzDMFW5Ev+rcocEaNq/rvDzUVuI8VqkqE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mhQhaJQWOTlng5e1r0aNjLvJhKxxUzDBb9iXr5AbSx8mAzIyZlaUZrw81XxYVRrqr
	 LyQM3Kha/tEG+rNONr/AFMiiE4LvofXuANkTcbJwfsXaFG/8sbW15c8ia4EHqJBtBZ
	 KUWakf/XjPgqmBsyyX7ls3j0esf+eFjqGYFQmG09gHEjIEsjWTiUjCc4L2FM51qbMV
	 puZ0jpm+SPt796IPUtn9+oQIrgzgA6luwAMrL3XMVbZptbXZlS/Cqt8rh+n33Ko7mU
	 AHXglxiixsSXmWqD5pvmK7IXirpsrzH8HRYgoUFVlJyYGVEjwrcjHcFuGOI7n56wyg
	 opLE8GJzx1ZHA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] wifi: iwlwifi: bound aligned TLV advance in FW parser
Date: Mon, 31 Aug 2026 09:28:48 -0400
Message-ID: <20260831133314.4125787-500-sashal@kernel.org>
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

[ Upstream commit acad742714bdc70e7fd7f234323807c596828213 ]

Validate ALIGN(tlv_len, 4) against remaining parser length before
consuming bytes from the firmware image.

This avoids length underflow on malformed TLVs.

Assisted-by: GitHubCopilot:GPT-5.3-Codex
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Link: https://patch.msgid.link/20260717173215.393c286488f9.Ia39144dc3ca334325ee4eacb7420901e2446fc23@changeid
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: `wifi: iwlwifi: bound aligned TLV advance in
FW parser`

**Local tree:** `v6.18.44` (linux-6.18.y stable), `HEAD` detached from
`stable/linux-6.18.y`

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Subject line
**Record:** `[wifi: iwlwifi]` **`bound`** (preventive/safety) **`aligned
TLV advance in FW parser`** — validates aligned TLV length before
advancing the firmware parser.

### Step 1.2: Tags
**Record:**
- **Link:** `https://patch.msgid.link/20260717173215.393c286488f9.Ia3914
  4dc3ca334325ee4eacb7420901e2446fc23@changeid`
- **Assisted-by:** GitHubCopilot:GPT-5.3-Codex
- **Signed-off-by:** Emmanuel Grumbach `<emmanuel.grumbach@intel.com>`
- **Signed-off-by:** Miri Korenblit
  `<miriam.rachel.korenblit@intel.com>`
- **No** Fixes:, Reported-by:, Tested-by:, Reviewed-by:, Acked-by:, Cc:
  stable@vger.kernel.org
- Notable: Intel iwlwifi maintainer authorship; no fuzzer/user bug
  report

### Step 1.3: Body analysis
**Record:**
- **Bug:** Parser checks `tlv_len` against remaining length, but
  advances by `ALIGN(tlv_len, 4)`. When `tlv_len` is not 4-byte aligned
  and equals remaining bytes, `len -= ALIGN(tlv_len, 4)` underflows
  `size_t`.
- **Symptom:** Length underflow on malformed TLV firmware images.
- **Root cause:** Mismatch between validation quantity (`tlv_len`) and
  consumption quantity (`ALIGN(tlv_len, 4)`).
- **Version info:** None in message.

### Step 1.4: Hidden bug fix?
**Record:** Yes — described as validation hardening, but it fixes a real
unsigned integer underflow leading to out-of-bounds parsing.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory
**Record:**
- **File:** `drivers/net/wireless/intel/iwlwifi/iwl-drv.c` (+11 / -2,
  net +9)
- **Function:** `iwl_parse_tlv_firmware()`
- **Scope:** Single-file, surgical fix

### Step 2.2: Code flow change
**Record:**
- **Hunk (TLV loop):**
  - **Before:** `if (len < tlv_len)` then `len -= ALIGN(tlv_len, 4)` and
    pointer advance by aligned length.
  - **After:** Compute `aligned_tlv_len = ALIGN(tlv_len, 4)`, validate
    `len >= aligned_tlv_len`, then subtract/advance by aligned length.
- **Path affected:** Firmware TLV parsing loop during ucode load (error
  path on malformed input).

### Step 2.3: Bug mechanism
**Record:**
- **Category:** Buffer safety / integer underflow
- **Mechanism:** With `len == tlv_len` and `tlv_len % 4 != 0`, e.g.
  `len=3, tlv_len=3`: check `3 < 3` fails (passes), but `len -=
  ALIGN(3,4)` → `len -= 4` underflows `size_t` to a huge value. Loop
  continues, `data` advances past buffer → OOB read, potential kernel
  oops.

### Step 2.4: Fix quality
**Record:**
- Obviously correct: validates the same quantity that is consumed.
- Minimal, no unrelated changes.
- **Regression risk:** Very low — only rejects previously-accepted
  malformed input; legitimate Intel firmware uses properly aligned TLVs.

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame
**Record:** Buggy lines blame to `5d324e5159d9e` in this shallow
checkout. Repo is shallow (`true`); full introduction history
unavailable. `iwl_parse_tlv_firmware()` is longstanding core iwlwifi
code present in 6.18.y.

### Step 3.2: Fixes: tag
**Record:** N/A — no Fixes: tag.

### Step 3.3: Related file history
**Record:**
- Fix commit on `autosel` branch: `9121064ed2d94` (upstream
  `acad742714bdc`)
- Part of 5-patch Intel series (`iwlwifi-fixes 07-17-2026`); this is
  patch 1/5
- Related sibling fixes on `autosel`: `8ab01d2f5a78a` (dbg-tlv),
  `4025ad3399772` (SEC_RT TLV) — separate, not prerequisites
- Similar validation fixes already in this 6.18.y tree: `eae7fdf7d4469`,
  `a076b0c457c71`, `dd90880eb5ec5`

### Step 3.4: Author context
**Record:** Emmanuel Grumbach is iwlwifi maintainer. Miri Korenblit is
active iwlwifi contributor. Multiple recent iwlwifi validation fixes
from same authors/backporters in this tree.

### Step 3.5: Dependencies
**Record:** Standalone — no prerequisite commits. Patch 1/5 only touches
`iwl-drv.c`. `git apply --check` passes cleanly on current HEAD.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: Original discussion
**Record:**
- **b4 dig -c 9121064ed2d94:** https://patch.msgid.link/20260717173215.3
  93c286488f9.Ia39144dc3ca334325ee4eacb7420901e2446fc23@changeid
- **Series:** v1 only, patch 1/5 of `iwlwifi-fixes 07-17-2026`
- **Review feedback:** No replies, NAKs, or stable nominations in saved
  thread
- lore.kernel.org blocked by bot protection (Anubis)

### Step 4.2: Reviewers
**Record:** **b4 dig -w** recipients: Miri Korenblit,
johannes@sipsolutions.net, linux-wireless@vger.kernel.org, Emmanuel
Grumbach. Appropriate iwlwifi mailing list coverage.

### Step 4.3: Bug report
**Record:** No external bug report, syzbot, or user Reported-by.
Theoretical/corrupt-firmware trigger.

### Step 4.4: Related patches
**Record:** Series patches 2–5 fix similar patterns elsewhere (`iwl-dbg-
tlv.c`, ACPI WGDS, UEFI PPAG, SEC_RT TLV). Independent of this patch.

### Step 4.5: Stable list
**Record:** Could not search lore stable list (bot protection). No
stable discussion found in mbox thread.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Key functions
**Record:** `iwl_parse_tlv_firmware()` modified.

### Step 5.2: Callers
**Record:**
- `iwl_req_fw_callback()` → `iwl_parse_tlv_firmware()` when `ucode->ver
  == 0` (TLV-format firmware)
- `iwl_req_fw_callback()` ← `iwl_request_firmware()` ← `iwl_drv_start()`
  ← PCIe probe path (`iwl_drv_start()` in `pcie/gen1_2/trans.c`)
- Runs during async firmware load at iwlwifi device probe/module init

### Step 5.3: Callees
**Record:** `le32_to_cpu()`, `ALIGN()`,
`set_sec_data()`/`set_sec_size()`/`set_sec_offset()` in TLV switch. No
locks/allocation in the fixed hunk.

### Step 5.4: Reachability
**Record:** Triggered whenever iwlwifi loads TLV-format ucode from
`/lib/firmware/`. Requires malformed/corrupted firmware (not normal
Intel images). Firmware files are root-controlled; unprivileged users
cannot typically substitute firmware. Reachable on probe with bad
firmware → driver load failure or kernel oops.

### Step 5.5: Similar patterns
**Record:** Same `len < tlv_len` + `ALIGN(tlv_len, 4)` pattern exists
unfixed in:
- `iwl-dbg-tlv.c:490-491` (patch 2/5 addresses separately)
- `fw/pnvm.c`, `fw/uefi.c` (other series patches or unfixed)

---

## PHASE 6: CROSS-REFERENCING AGAINST LOCAL TREE

### Step 6.1: Buggy code present?
**Record:** **Yes.** Current HEAD (`v6.18.44`) has buggy code at lines
849–855:

```849:855:drivers/net/wireless/intel/iwlwifi/iwl-drv.c
                if (len < tlv_len) {
                        IWL_ERR(drv, "invalid TLV len: %zd/%u\n",
                                len, tlv_len);
                        return -EINVAL;
                }
                len -= ALIGN(tlv_len, 4);
                data += sizeof(*tlv) + ALIGN(tlv_len, 4);
```

Fix commit `9121064ed2d94` is **not** on current HEAD (only on `autosel`
branch).

### Step 6.2: Backport complications
**Record:** Clean apply confirmed (`git apply --check` exit 0). No
refactoring conflicts in this file region.

### Step 6.3: Related fixes already present?
**Record:** No equivalent aligned-TLV validation fix in `iwl-drv.c`.
Other iwlwifi validation fixes present but not for this specific bug.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

### Step 7.1: Subsystem criticality
**Record:** **drivers/net/wireless/intel/iwlwifi** — IMPORTANT (widely
deployed Intel WiFi hardware; driver-specific).

### Step 7.2: Subsystem activity
**Record:** Active — many iwlwifi fixes backported to this 6.18.y tree
recently (validation, race, OOB fixes).

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: Who is affected
**Record:** Users with Intel iwlwifi hardware (`CONFIG_IWLWIFI`) loading
TLV-format firmware during probe.

### Step 8.2: Trigger conditions
**Record:** Malformed TLV ucode where `tlv_len == remaining_bytes` and
`tlv_len % 4 != 0`. Unlikely with legitimate Intel firmware; possible
with corruption, partial download, or disk errors. Not easily triggered
by unprivileged users.

### Step 8.3: Failure mode severity
**Record:** `size_t` underflow → parser continues with bogus length →
OOB read past firmware buffer → potential kernel oops during driver
probe. **Severity: MEDIUM-HIGH** (crash on probe), not CRITICAL (no
privilege escalation, requires bad firmware).

### Step 8.4: Risk-benefit
**Record:**
- **Benefit:** Prevents kernel crash on malformed firmware; aligns with
  other iwlwifi validation backports in this tree.
- **Risk:** Very low — 9-line validation addition, no behavior change
  for valid firmware.
- **Ratio:** Favorable for stable.

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence summary

**FOR backport:**
- Real bug: unsigned length underflow on malformed TLVs
- Can cause OOB reads / kernel oops during firmware load
- Fix is obviously correct, minimal, standalone
- Buggy code confirmed present in 6.18.44
- Applies cleanly
- Consistent with other iwlwifi validation fixes already in this tree
- Intel maintainer authorship

**AGAINST backport:**
- No user report or syzbot reproduction
- Requires malformed firmware (root-controlled resource)
- Legitimate Intel firmware unlikely to trigger
- Same pattern exists in other iwlwifi files (not fixed by this single
  patch)

**Unresolved:**
- Exact commit/version that introduced the buggy check (shallow repo
  limits history)
- No mailing list review discussion retrieved (lore blocked)

### Step 9.2: Stable rules checklist
1. Obviously correct and tested? **PASS** — logic is clear; no Tested-by
   but pattern is standard validation.
2. Fixes a real bug? **PASS** — integer underflow with OOB parsing
   consequence.
3. Important issue? **PASS** — kernel oops on driver probe (MEDIUM-
   HIGH).
4. Small and contained? **PASS** — 1 file, ~9 net lines.
5. No new features/APIs? **PASS** — validation only.
6. Can apply to local tree? **PASS** — clean apply verified.

### Step 9.3: Exception categories
**Record:** None (not device ID, quirk, DT, build, or docs). Standard
bug fix.

### Step 9.4: Decision rationale
For linux-6.18.y, the buggy TLV parser code exists, the fix is surgical
and self-contained, and it prevents a real firmware-parsing underflow
that can crash the kernel during iwlwifi probe. While triggering
requires malformed firmware, the kernel must reject such input safely —
matching the pattern of other iwlwifi validation fixes already accepted
into this stable tree. Risk is minimal; benefit is meaningful for
robustness.

---

## Verification

- **[Phase 1]** Parsed subject, tags, body from user-provided commit
  message
- **[Phase 2]** Read diff and current `iwl-drv.c` lines 788–875;
  confirmed underflow mechanism
- **[Phase 3]** `git describe HEAD` → v6.18.44; shallow repo confirmed;
  `git blame -L 849,855` → 5d324e5159d9e; `git show 9121064ed2d94` on
  autosel branch; `git merge-base --is-ancestor` → fix NOT on HEAD
- **[Phase 3]** `git log --grep="iwlwifi"` — multiple validation fixes
  already in tree
- **[Phase 4]** `b4 dig -c 9121064ed2d94` — lore URL found; `b4 dig -a`
  — v1, patch 1/5; `b4 dig -w` — linux-wireless CC'd; mbox saved and
  parsed — no review replies or stable nominations
- **[Phase 4]** lore.kernel.org fetch blocked by Anubis bot protection
- **[Phase 5]** `grep iwl_parse_tlv_firmware` — caller chain via
  `iwl_req_fw_callback` → `iwl_drv_start`; `grep ALIGN(tlv_len, 4)` —
  same pattern in iwl-dbg-tlv.c, pnvm.c, uefi.c
- **[Phase 6]** Buggy code present at iwl-drv.c:849-855; `git apply
  --check` from 9121064ed2d94 → passes
- **[Phase 6]** Fix not on HEAD; only on autosel branch
- **[Phase 8]** Failure mode: size_t underflow → OOB read → probe-time
  oops; trigger requires malformed firmware

**YES**

 drivers/net/wireless/intel/iwlwifi/iwl-drv.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-drv.c b/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
index 0f002ef261fcc..3a4bcfd60905c 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
@@ -803,6 +803,7 @@ static int iwl_parse_tlv_firmware(struct iwl_drv *drv,
 	u32 build, paging_mem_size;
 	int num_of_cpus;
 	bool usniffer_req = false;
+	size_t aligned_tlv_len;
 
 	if (len < sizeof(*ucode)) {
 		IWL_ERR(drv, "uCode has invalid length: %zd\n", len);
@@ -851,8 +852,16 @@ static int iwl_parse_tlv_firmware(struct iwl_drv *drv,
 				len, tlv_len);
 			return -EINVAL;
 		}
-		len -= ALIGN(tlv_len, 4);
-		data += sizeof(*tlv) + ALIGN(tlv_len, 4);
+
+		aligned_tlv_len = ALIGN(tlv_len, 4);
+		if (len < aligned_tlv_len) {
+			IWL_ERR(drv, "invalid aligned TLV len: %zd/%zu\n",
+				len, aligned_tlv_len);
+			return -EINVAL;
+		}
+
+		len -= aligned_tlv_len;
+		data += sizeof(*tlv) + aligned_tlv_len;
 
 		switch (tlv_type) {
 		case IWL_UCODE_TLV_INST:
-- 
2.53.0

