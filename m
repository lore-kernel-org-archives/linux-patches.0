Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB2B058039D;
	Mon, 31 Aug 2026 13:49:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184187; cv=none; b=AwxTmLJAuPwcu6hSuoCernPBtCINfCCMaMYa44+rIdq3ER5YnUd5vom3VhestXtZHNJF54YyExWwhDfSlvKh1T4eve5dUBKRnfrbWde2rr38B7oUs48aYYEPr3hoxnmJOPJ778ghVqXgJKqcAzJkMIS87txT97j/zoaAsm8JVEs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184187; c=relaxed/simple;
	bh=pZu2pCoV6K7ySpvB/3gJkjn9t17/G7T56MdIbHe4DwU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uYSg8jo2959O0djatKCrfjE1u0YMukqZTVmRCSaSL2vetlwWrauVaRJls94Tl2A9i9uPr0aMHioorWOYapgRvORDeoTMt7Y0S8STEZBobrvjpoBmlReCBIS8JKkDqB/hTcIkAM8dHP1WWAwfPXe7YBBNC1pHSOGuDW9siC5jOKo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KgCCOg2t; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KgCCOg2t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F3A71F00A3E;
	Mon, 31 Aug 2026 13:49:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788184185;
	bh=SlSZnePD1C0svI0M8whuH2lg/iVWP+r5DLZy13O4zWE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KgCCOg2tyDCvY7I9hBbOYStF31g6wqtimgCgYQ7JwV/BLH+9ZJqyqd2oogTIaxO2C
	 beW6rV4DL1aFRvgCq3geXcvkhpCGoWIM2fqNlkswzvCopNZoWRBSxaBVIC3o331nAT
	 uqio5RUBbE+b9ASeZR2epjLmulCkWzfK6HCZGGiKkAtnHFBM6TIv8hV0aY6cJRE4zR
	 Ky+qmIXXoL7+zuSg2fxrAMm+bY4VtqWgmu/t5Hbkak0tUPrUeuud6IIsGYn2YVAbqS
	 bBe+Zkan7sSZpSx5dNgw4vDwkKKJQoF+hXxX0m033b87lGgcCECUUIp9NSuVsS96tn
	 fF3e34FIIxAeQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Luka Gejak <luka.gejak@linux.dev>,
	Fernando Fernandez Mancera <fmancera@suse.de>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	davem@davemloft.net,
	edumazet@google.com,
	pabeni@redhat.com,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.1] net: hsr: require valid EOT supervision TLV
Date: Mon, 31 Aug 2026 09:29:30 -0400
Message-ID: <20260831133314.4125787-542-sashal@kernel.org>
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

From: Luka Gejak <luka.gejak@linux.dev>

[ Upstream commit 46d111a3ef3b5972804dcdce0833767143a12192 ]

Supervision frames are only valid if terminated with a zero-length EOT
TLV. The current check fails to reject non-EOT entries as the terminal
TLV, potentially allowing malformed supervision traffic.

Fix this by strictly requiring the terminal TLV to be HSR_TLV_EOT with
a length of zero.

Signed-off-by: Luka Gejak <luka.gejak@linux.dev>
Reviewed-by: Fernando Fernandez Mancera <fmancera@suse.de>
Link: https://patch.msgid.link/20260523130420.62144-1-luka.gejak@linux.dev
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit Message Forensics

### Step 1.1: Subject Line
**Record:** `[net: hsr]` `[require]` — HSR supervision-frame validation:
strictly require a zero-length EOT TLV at the end of the TLV chain.

### Step 1.2: Tags
**Record:**
- **Signed-off-by:** Luka Gejak `<luka.gejak@linux.dev>` (author)
- **Reviewed-by:** Fernando Fernandez Mancera `<fmancera@suse.de>`
  (subsystem reviewer)
- **Link:**
  https://patch.msgid.link/20260523130420.62144-1-luka.gejak@linux.dev
- **Signed-off-by:** Jakub Kicinski `<kuba@kernel.org>` (net maintainer)
- No Fixes:, Reported-by:, Tested-by:, Acked-by:, or Cc: stable tags
- Notable: Reviewed by SUSE HSR contributor; no syzbot or user bug
  report

### Step 1.3: Body Analysis
**Record:**
- **Bug:** Supervision frames must end with a zero-length EOT TLV per
  IEC 62439-3. The existing check only rejects EOT TLVs with non-zero
  length; it does not reject non-EOT TLVs as the terminal entry.
- **Symptom:** Malformed supervision traffic can be accepted as valid.
- **Root cause:** Inverted conditional logic — accepts any terminal TLV
  that is not `(EOT && length != 0)`.
- **Version info:** None in message.

### Step 1.4: Hidden Bug Fix Detection
**Record:** Explicit protocol-validation bug fix, not disguised cleanup.
The inverted `&&` vs `||`/`!=` is a classic logic error.

---

## Phase 2: Diff Analysis

### Step 2.1: Inventory
**Record:**
- **Files:** `net/hsr/hsr_forward.c` (+1 / -1)
- **Function:** `is_supervision_frame()`
- **Scope:** Single-file, single-line surgical fix

### Step 2.2: Code Flow Change
**Record:**
- **Before:** Reject only if `type == HSR_TLV_EOT && length != 0`. All
  other terminal TLVs (including non-EOT with length 0 or non-zero) are
  accepted.
- **After:** Reject unless `type == HSR_TLV_EOT && length == 0`. Only a
  proper EOT terminator is accepted.
- **Path:** Receive path in `is_supervision_frame()`, called for every
  HSR/PRP frame.

### Step 2.3: Bug Mechanism
**Record:**
- **Category:** Logic / protocol correctness
- **Mechanism:** De Morgan inversion. Comment says “end of tlvs must
  follow at the end,” but old code only filtered malformed EOT entries,
  not non-EOT terminal TLVs.

### Step 2.4: Fix Quality
**Record:** Obviously correct, minimal, no API changes. Regression risk
is very low — only makes validation stricter (rejects more malformed
frames). No deadlock or locking changes.

---

## Phase 3: Git History Investigation

### Step 3.1: Blame
**Record:** Buggy EOT check introduced in `eafaa88b3eb7` (“net: hsr: Add
support for redbox supervision frames”, Oct 2021). Present in this tree
since that commit. `eafaa88b3eb7` is an ancestor of HEAD.

### Step 3.2: Fixes: Tag
**Record:** N/A — no Fixes: tag in commit message.

### Step 3.3: Related File History
**Record:** Related stable commits on `stable/linux-6.18.y`:
- `fbd0662f9c9a6` — “net: hsr: fix potential OOB access in supervision
  frame handling” (same author, same day, already in this tree)
- `eafaa88b3eb7` — introduced the buggy EOT check
- `51dd4ee037222`, `295de650d3aaf` — earlier supervision parsing fixes

### Step 3.4: Author Context
**Record:** Luka Gejak has multiple stable backports in this tree
(`fbd0662f9c9a6`, `1fe371a34e801`, rtw88 fixes). Active HSR contributor.

### Step 3.5: Dependencies
**Record:** Standalone. Originally part of a larger series (v1–v3), but
from v4 onward it is a standalone 1/2 or single patch. No structural
prerequisites. Applies cleanly on top of current tree (`git apply
--check` passed).

---

## Phase 4: Mailing List and External Research

### Step 4.1: Original Discussion
**Record:** `b4 dig -c 46d111a3ef3b5` found thread at
https://patch.msgid.link/20260523130420.62144-1-luka.gejak@linux.dev.
Series evolved v1–v7; committed version is v7 (latest). No NAKs found in
saved mbox. No explicit stable nomination in thread.

### Step 4.2: Reviewers
**Record:** `b4 dig -w`: CC'd netdev maintainers (Miller, Dumazet,
Kicinski, Abeni, Horman) and Felix Maurer (HSR maintainer). Reviewed-by
from Fernando Fernandez Mancera (SUSE).

### Step 4.3: Bug Report
**Record:** No external bug report, syzbot, or Bugzilla link. Author-
identified logic bug.

### Step 4.4: Series Context
**Record:** v1–v3 bundled with “serialize seq_blocks merge”; v4+ split
out as standalone EOT fix. No other series patches required.

### Step 4.5: Stable List
**Record:** No stable-list discussion found. Companion OOB fix
(`fbd0662f9c9a6`) was already backported to this tree.

---

## Phase 5: Code Semantic Analysis

### Step 5.1: Key Functions
**Record:** `is_supervision_frame()` modified.

### Step 5.2: Callers
**Record:** Called from `fill_frame_info()` (line 691), which is called
from `hsr_forward_skb()` (line 739). `hsr_forward_skb()` is invoked
from:
- `hsr_slave.c` — slave port receive
- `hsr_device.c` — master/interlink receive

Every HSR/PRP received frame goes through this path.

### Step 5.3: Callees / Downstream Effects
**Record:** When `is_supervision_frame()` returns true:
- `hsr_get_node()` runs with `is_sup=true` (affects node DB, SAN info)
- `hsr_handle_sup_frame()` called on master for non-proxy supervision
  (node merging)
- Supervision-specific forwarding: dropped on interlink, special path ID
  (0xf) for HSRv0
- `prp_check_lsdu_size()` uses `is_supervision` flag

### Step 5.4: Reachability
**Record:** Reachable from network receive on any HSR/PRP-configured
interface. Attacker on the HSR/PRP segment can send crafted frames.
HSR/PRP is config-specific (`CONFIG_HSR`), not universal.

### Step 5.5: Similar Patterns
**Record:** No similar inverted EOT check elsewhere in `net/hsr/`.
`is_proxy_supervision_frame()` does not perform EOT validation
(different purpose).

---

## Phase 6: Cross-Reference Against Local Tree

### Step 6.1: Buggy Code Present?
**Record:** YES. Local tree is **v6.18.44** (`git describe HEAD`). Buggy
code at lines 113–115 of `net/hsr/hsr_forward.c`:

```113:115:net/hsr/hsr_forward.c
        if (hsr_sup_tlv->HSR_TLV_type == HSR_TLV_EOT &&
            hsr_sup_tlv->HSR_TLV_length != 0)
                return false;
```

Bug present since `eafaa88b3eb7` (2021). Fix commit `46d111a3ef3b5` is
NOT in this tree.

### Step 6.2: Backport Complications
**Record:** Clean apply expected. OOB fix (`fbd0662f9c9a6`) already
changed `pskb_may_pull()` offsets but left the EOT check unchanged. `git
format-patch -1 46d111a3ef3b5 --stdout | git apply --check` succeeded.

### Step 6.3: Related Fixes Already Present?
**Record:** OOB fix `fbd0662f9c9a6` is in tree (companion fix, same
author/day). EOT logic fix is not.

---

## Phase 7: Subsystem Context

### Step 7.1: Subsystem Criticality
**Record:** `net/hsr` — HSR/PRP redundancy protocol for
industrial/utility networks. **IMPORTANT** for that niche;
**PERIPHERAL** globally (requires `CONFIG_HSR`).

### Step 7.2: Activity
**Record:** Active development in 6.18.y (VLAN support, OOB fix, memory
leak fix, RedBox support).

---

## Phase 8: Impact and Risk Assessment

### Step 8.1: Who Is Affected
**Record:** Users running HSR/PRP (`CONFIG_HSR`) — industrial
automation, power grid, substation networking.

### Step 8.2: Trigger Conditions
**Record:** Malformed supervision frame on the HSR/PRP network with a
non-EOT terminal TLV (any type other than EOT=0 with length 0). Attacker
or faulty device on the L2 segment. Config-specific, not every kernel
user.

### Step 8.3: Failure Mode Severity
**Record:** Malformed frames accepted as valid supervision → incorrect
node DB updates, node merging via `hsr_handle_sup_frame()`, altered
forwarding/drop behavior. **Severity: MEDIUM-HIGH** for HSR deployments
(protocol state corruption / redundancy disruption), but not a kernel
crash, OOB, or UAF. No memory-safety issue.

### Step 8.4: Risk-Benefit
**Record:**
- **Benefit:** Correct IEC 62439-3 validation; completes supervision
  hardening alongside already-backported OOB fix; protects node DB
  integrity.
- **Risk:** Very low — one-line logic inversion, only rejects more bad
  frames.
- **Ratio:** Favorable for HSR users; low global risk.

---

## Phase 9: Final Synthesis

### Step 9.1: Evidence Summary

**FOR backport:**
- Clear logic bug since 2021 (inverted conditional)
- Real protocol validation failure with node DB / forwarding impact
- 1-line, obviously correct, applies cleanly
- Reviewed by HSR contributor and net maintainer
- Companion OOB fix from same author already in v6.18.44
- Standalone, no dependencies

**AGAINST backport:**
- No crash, syzbot report, or user bug report
- Niche subsystem (`CONFIG_HSR`)
- Impact is protocol/state correctness, not memory safety
- No explicit stable nomination

**Unresolved:** No field reports quantifying real-world exploitation.

### Step 9.2: Stable Rules Checklist
1. Obviously correct and tested? **PASS** — logic inversion is self-
   evident; Reviewed-by present; no runtime test reported.
2. Fixes a real bug? **PASS** — inverted conditional since
   `eafaa88b3eb7`.
3. Important issue? **PASS (moderate)** — HSR node DB / redundancy state
   corruption for industrial users, not kernel panic.
4. Small and contained? **PASS** — 1 line, 1 file.
5. No new features/APIs? **PASS**.
6. Can apply to local tree? **PASS** — verified with `git apply
   --check`.

### Step 9.3: Exception Categories
**Record:** None (not device ID, quirk, DT, build, or docs).

### Step 9.4: Decision Rationale

This is a longstanding logic inversion in HSR supervision-frame
validation. Since 2021, any terminal TLV that is not “EOT with non-zero
length” has been accepted, violating IEC 62439-3 and allowing malformed
supervision traffic to drive node DB updates and supervision-specific
forwarding. The fix is a one-line De Morgan correction with negligible
regression risk.

The companion OOB fix from the same author on the same day is already in
v6.18.44; leaving this EOT validation gap incomplete is inconsistent.
For HSR/PRP deployments — used in safety-critical industrial
infrastructure — protocol validation that protects node state integrity
is appropriate stable material even without a crash report.

---

## Verification

- [Phase 1] Parsed subject, tags, body from commit `46d111a3ef3b5`
- [Phase 1] No syzbot/Reported-by; Reviewed-by: Fernando Fernandez
  Mancera
- [Phase 2] Diff: 1 line in `is_supervision_frame()`, logic inversion
  confirmed
- [Phase 2] Read current buggy code at lines 113–115 of
  `net/hsr/hsr_forward.c`
- [Phase 3] `git show eafaa88b3eb7`: buggy EOT check introduced Oct 2021
- [Phase 3] `git merge-base --is-ancestor eafaa88b3eb7 HEAD`: bug-
  introducing commit in tree
- [Phase 3] `git merge-base --is-ancestor 46d111a3ef3b5 HEAD`: fix NOT
  in tree
- [Phase 3] `git log stable/linux-6.18.y -- net/hsr/hsr_forward.c`:
  related OOB fix `fbd0662f9c9a6` present
- [Phase 3] `git merge-base --is-ancestor fbd0662f9c9a6 HEAD`: OOB fix
  in tree
- [Phase 4] `b4 dig -c 46d111a3ef3b5`: lore thread found, v7 is latest
- [Phase 4] `b4 dig -a`: series v1–v7; standalone from v4 onward
- [Phase 4] `b4 dig -w`: netdev maintainers CC'd
- [Phase 4] Mbox grep: Reviewed-by confirmed; no stable nomination or
  NAK
- [Phase 5] `grep is_supervision_frame`: caller chain `fill_frame_info`
  → `hsr_forward_skb` → slave/master receive
- [Phase 5] Read `hsr_handle_sup_frame()`, `hsr_get_node()`,
  `hsr_forward_do()` for downstream impact
- [Phase 6] `git describe HEAD`: v6.18.44
- [Phase 6] Buggy code confirmed present in stable release commit
  `1efe5d048a391`
- [Phase 6] `git format-patch -1 46d111a3ef3b5 --stdout | git apply
  --check`: applies cleanly
- [Phase 8] Assessed severity as protocol state corruption for HSR
  users, not kernel memory safety

**YES**The background checks finished and match what the analysis
already used:

- **Mainline search** found commit `46d111a3ef3b5` (“net: hsr: require
  valid EOT supervision TLV”) on master/linux-next.
- **Author history on stable/linux-6.18.y** shows the companion OOB fix
  (`fbd0662f9c9a6`) is already in v6.18.44, while this EOT logic fix is
  not.

Verdict for this tree (v6.18.44): **YES** — one-line protocol validation
fix, applies cleanly, and completes the supervision-frame hardening
started by the already-backported OOB patch.

 net/hsr/hsr_forward.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/hsr/hsr_forward.c b/net/hsr/hsr_forward.c
index 299de290ddaa5..901eb85c112d1 100644
--- a/net/hsr/hsr_forward.c
+++ b/net/hsr/hsr_forward.c
@@ -110,7 +110,7 @@ static bool is_supervision_frame(struct hsr_priv *hsr, struct sk_buff *skb)
 	}
 
 	/* end of tlvs must follow at the end */
-	if (hsr_sup_tlv->HSR_TLV_type == HSR_TLV_EOT &&
+	if (hsr_sup_tlv->HSR_TLV_type != HSR_TLV_EOT ||
 	    hsr_sup_tlv->HSR_TLV_length != 0)
 		return false;
 
-- 
2.53.0

