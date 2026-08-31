Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CDA55650EC;
	Mon, 31 Aug 2026 13:47:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184076; cv=none; b=dVCC68eECbdOumxdd3lvKug7u1ypCZ+1Y3u5s7Aivsigp7pr0HRBf6MjhYnZNOEoAh13EAicpKrZkacFsr5zFoPvsiSSXxDhr5LEB1LidH71PsMVrFXmTBrYA31q8J+XN9iuKv1drrrrJTAZpYxwAEjCePoTysmf84aeb7T27jI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184076; c=relaxed/simple;
	bh=B8jXb2kB+MvImiJHPQN+DD76LkGnzGIfTZlmh916Lzg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JJ0ftkrf5zTrlGFwoUObvG5yiPxGzopY9tBpUQ3q/GNDs+YXnIZihUVWgadGPZ+GRlURrbmv6hgGe4AJ0EGZI1z0SlZpJbF9c1cNtOrNB4JYYTLvzz4KkuppaDN2/tEU+kb/QD+4HjvSSj0YAj7AeNYdekFBAjV23StnVMil1EI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mNbhbZW2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mNbhbZW2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81FC81F00A3D;
	Mon, 31 Aug 2026 13:47:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788184074;
	bh=50s9L/q2gc6UqpjOQy0K5eDvQc3IehRiRxZgThDfxkA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mNbhbZW2Kfpw1j611greWItmLtWvyQw3U4iaQVadedGFpuupy4LS200ZwdbQscZsI
	 lVw17MBO09vbwFwUbH+pg5GpCjoe1ZRI5YY6h1HcvRwcOM5eK32VclD40kh//mZib4
	 jcuMh3XTcRfMGmtk3jk5ytnZ6dFUDLXnJmbJwPiV0X6JI65QGyBRWZNoSt/KjoWSkD
	 SG7Oa6L9b19POTIycRaDlNFLXWzOJxJgqes5eC7/roF2uJOH9hLwjdTzO6CfqASnV3
	 R1Gq8hbcpyxjZQvYSUcUG1HQE38Crr2099L7PqYztcappMpByxYp9fyNsqST7txRil
	 JrKD8mjunSpcg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	Miriam Rachel Korenblit <miriam.rachel.korenblit@intel.com>,
	Ilan Peer <ilan.peer@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	johannes@sipsolutions.net,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] wifi: cfg80211: harden cfg80211_defragment_element()
Date: Mon, 31 Aug 2026 09:28:23 -0400
Message-ID: <20260831133314.4125787-475-sashal@kernel.org>
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

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit e48223525a54d3a3182d2d9a497dca022b942b4d ]

A previous commit changed mac80211 to no longer make wrong
calls to cfg80211_defragment_element() with the element
pointing outside of the buffer. Additionally, harden this
function itself against that and always return -EINVAL in
case the element isn't inside the source buffer.

Reviewed-by: Miriam Rachel Korenblit <miriam.rachel.korenblit@intel.com>
Reviewed-by: Ilan Peer <ilan.peer@intel.com>
Link: https://patch.msgid.link/20260529102644.198945754054.I5ae8fdebf9008abc6e15d0b0f10c3a7b73d02eab@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: `wifi: cfg80211: harden
cfg80211_defragment_element()`

**Local tree:** Linux **6.18.44** (`stable/linux-6.18.y`, detached HEAD)
**Upstream commit:** `e48223525a54d` (not in this tree; patch applies
cleanly)

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Subject line
**Record:** `[wifi: cfg80211]` `[harden]` — add bounds validation to
`cfg80211_defragment_element()` so `elem` must lie fully inside the
`ies` buffer.

### Step 1.2: Tags
**Record:**
| Tag | Value |
|-----|-------|
| Fixes: | None |
| Reported-by: | None |
| Tested-by: | None |
| Reviewed-by: | Miriam Rachel Korenblit, Ilan Peer |
| Acked-by: | None |
| Link: | https://patch.msgid.link/20260529102644.198945754054.I5ae8fdeb
f9008abc6e15d0b0f10c3a7b73d02eab@changeid |
| Cc: stable@vger.kernel.org | None (expected for manual review) |
| Signed-off-by: | Johannes Berg (author) |

Notable: two Intel wireless reviewers; no syzbot/user bug report; no
explicit stable nomination.

### Step 1.3: Body analysis
**Record:**
- **Bug described:** Callers could pass an `elem` pointer outside the
  `ies` source buffer; the function did not validate containment before
  dereferencing `elem->datalen` and calling `memmove()`.
- **Symptom:** Out-of-bounds reads/copies when `elem` and `ies` refer to
  different buffers or when the element length extends past `ies +
  ieslen`.
- **Root cause:** Missing input validation in an `EXPORT_SYMBOL` helper
  that processes untrusted 802.11 Information Elements.
- **Dependency:** References a prior mac80211 commit that stopped
  passing mismatched `elem`/`ies` pairs (that fix is **already in
  6.18.y** as `55c479aae99b1`).

### Step 1.4: Hidden bug fix?
**Record:** Yes. “Harden” is defense-in-depth, but it enforces the
documented API contract (`@ies: elements where @elem is contained`) and
prevents OOB access if callers pass inconsistent pointers or if
`elem->datalen` would extend past the buffer end.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory
**Record:**
| File | Changes | Functions |
|------|---------|-----------|
| `net/wireless/scan.c` | +4 / -2 (net +2 functional) |
`cfg80211_defragment_element()` |

**Scope:** Single-file, surgical fix.

### Step 2.2: Code flow change
**Record:**
- **Before:** Only `if (!elem) return -EINVAL;`, then immediately read
  `elem->datalen` and `memmove()` from `elem->data`.
- **After:** Also reject when:
  1. `(const u8 *)elem < ies`
  2. Element header extends past `ies + ieslen`
  3. Full element (`header + elem->datalen`) extends past `ies + ieslen`
- **Path affected:** Entry validation on all callers before any data
  access or copy.

### Step 2.3: Bug mechanism
**Record:** **Memory safety / buffer overflow prevention (d).** The
function trusted caller-supplied `elem`/`ies` pairing. The already-
backported mac80211 bug (`55c479aae99b1`) passed a defragmented `elem`
with the original frame’s `ies`/`ieslen`, enabling heap-adjacent OOB
reads/copies. This patch validates containment at the API boundary.

### Step 2.4: Fix quality
**Record:** Obviously correct. Checks are ordered so `elem->datalen` is
only read after the element header is confirmed in-bounds. Minimal, no
API change (still returns `-EINVAL`). Very low regression risk — only
rejects previously-undefined invalid input.

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame
**Record:** Original `if (!elem)` from `f837a653a0970` (“wifi: cfg80211:
add element defragmentation helper”, June 2023). Function has been in
this tree since well before 6.18 branched.

### Step 3.2: Fixes: tag
**Record:** N/A — no `Fixes:` tag. Related buggy caller introduced by
`4d70e9c5488dd` (May 2024, in this tree), fixed by `55c479aae99b1`
(already in 6.18.y).

### Step 3.3: Related file history
**Record:** Related commits in this tree:
- `55c479aae99b1` — mac80211 MLE defragmentation caller fix (IN TREE)
- `023c1f2f06092` — cfg80211 MLE defragmentation OOB fix (IN TREE, had
  `Cc: stable`)
- `11ac7a5e75f51` — bound element ID read when checking non-inheritance
  (recent hardening pattern)

This hardening patch is standalone (only touches `scan.c`); it does not
require other patches from wireless-next 07/16 series.

### Step 3.4: Author context
**Record:** Johannes Berg is cfg80211/mac80211 maintainer. He authored
both the mac80211 caller fix and this cfg80211 hardening as companion
changes.

### Step 3.5: Dependencies
**Record:** The mac80211 caller fix (`55c479aae99b1`) is already in
6.18.y. This patch applies standalone (`git apply --check` passes). No
structural prerequisites missing.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: Original discussion
**Record:** `b4 dig -c e48223525a54d` → https://patch.msgid.link/2026052
9102644.198945754054.I5ae8fdebf9008abc6e15d0b0f10c3a7b73d02eab@changeid
Part of wireless-next series patch **07/16**; this specific hunk is
self-contained. No thread replies found in mbox. No `Cc: stable` in
submission.

### Step 4.2: Reviewers
**Record:** `b4 dig -w` — CC’d to Miriam Rachel Korenblit and Ilan Peer;
both Reviewed-by on the patch.

### Step 4.3: Bug report
**Record:** No external bug report, syzbot, or crash log. Bug mechanism
documented in companion commit `55c479aae99b1` (“potentially overrun the
heap data”).

### Step 4.4: Series context
**Record:** Patch 07/16 of a 16-patch UHR/wireless-next series. Only
`net/wireless/scan.c` changed; no dependency on patches 08–16.

### Step 4.5: Stable list
**Record:** No stable-list discussion found for this specific patch. The
companion mac80211 fix was already backported to 6.18.y.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Key functions
**Record:** `cfg80211_defragment_element()` (modified).

### Step 5.2: Callers
**Record:** In-tree callers (all reachable from WiFi frame processing):
| Caller | File | Context |
|--------|------|---------|
| MLE per-sta profile defrag | `net/mac80211/parse.c:860` | Beacon/probe
IE parsing |
| Basic MLE defrag | `net/mac80211/parse.c:909` | EHT ML element parsing
|
| Reconf/EPCS MLE defrag | `net/mac80211/parse.c:968` | Post-`55c479`
fixed path |
| STA profile enumeration | `net/mac80211/mlme.c:7266,7295` | ML STA
setup |
| EPCS per-link parsing | `net/mac80211/mlme.c:11018` | EPCS response
handling |
| Internal MLE defrag | `net/wireless/scan.c:2726,2768` | Scan/BSS
inform paths |

Also `EXPORT_SYMBOL` — external modules may call it. KUnit tests in
`net/wireless/tests/fragmentation.c`.

### Step 5.3: Callees
**Record:** `memmove()` for data copy; fragment loop walks subsequent
elements.

### Step 5.4: Reachability
**Record:** Reachable from processing received 802.11 management frames
(beacons, probe responses, ML reconfiguration). Remote AP/client can
supply crafted IE data. **Userspace-reachable via WiFi traffic**
(unprivileged on wireless networks).

### Step 5.5: Similar patterns
**Record:** Same subsystem recently backported `11ac7a5e75f51` (bound
element ID reads) and `55c479aae99b1` (MLE defragmentation caller fix).
Consistent hardening pattern for WiFi IE parsing.

---

## PHASE 6: CROSS-REFERENCE WITH LOCAL TREE (6.18.44)

### Step 6.1: Buggy code present?
**Record:** **Yes.** Current code at lines 2629–2630 only checks
`!elem`:

```2629:2634:net/wireless/scan.c
        if (!elem)
                return -EINVAL;

        /* elem might be invalid after the memmove */
        next = (void *)(elem->data + elem->datalen);
        elem_datalen = elem->datalen;
```

Function present since 2023; buggy caller path existed from
`4d70e9c5488dd` until `55c479aae99b1` (caller fix now in tree, API
validation still missing).

### Step 6.2: Backport complications
**Record:** **Clean apply** — `git show e48223525a54d | git apply
--check` succeeds. Only incidental copyright year change (2025→2026).

### Step 6.3: Related fixes already present?
**Record:**
- `55c479aae99b1` (mac80211 caller fix) — **IN TREE**
- `023c1f2f06092` (cfg80211 MLE OOB) — **IN TREE**
- `e48223525a54d` (this hardening) — **NOT IN TREE**

---

## PHASE 7: SUBSYSTEM CONTEXT

### Step 7.1: Subsystem criticality
**Record:** **net/wireless (cfg80211)** — IMPORTANT. WiFi stack
processes untrusted over-the-air data on virtually all
laptops/phones/embedded devices with WiFi.

### Step 7.2: Activity
**Record:** Actively maintained; multiple recent WiFi IE parsing
hardening fixes in 6.18.y.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: Who is affected?
**Record:** All systems with `CONFIG_CFG80211` / WiFi enabled processing
multi-link (EHT) elements or fragmented IEs.

### Step 8.2: Trigger conditions
**Record:**
- **Known (now fixed at caller):** Mismatched `elem`/`ies` buffers in
  mac80211 reconf/EPCS paths.
- **Remaining:** Any caller bug, `EXPORT_SYMBOL` misuse, or element
  whose declared length extends past the `ies` buffer — function
  previously proceeded to `memmove()`.
- **Likelihood post-`55c479`:** Primary known trigger closed; API-level
  hole remains for edge cases and external callers.

### Step 8.3: Failure mode severity
**Record:** Out-of-bounds kernel memory read/copy from WiFi IE
processing. **Severity: HIGH** (potential info leak or crash; WiFi
parsing is a classic remote attack surface). Companion mac80211 commit
explicitly documented heap-adjacent overrun risk.

### Step 8.4: Risk-benefit
**Record:**
- **Benefit:** Closes API-level OOB class; companion to already-
  backported mac80211 fix; protects `EXPORT_SYMBOL` boundary.
- **Risk:** Very low — 3-line bounds check, returns `-EINVAL` for
  invalid input only.
- **Ratio:** Favorable for stable.

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence summary

**FOR backport:**
- Real OOB bug class documented in companion fix already in 6.18.y
- WiFi IE parsing = remote attack surface
- Tiny, obviously correct, applies cleanly
- Maintainer-authored, reviewed by subsystem developers
- Enforces documented API contract on `EXPORT_SYMBOL` function
- Consistent with recent WiFi hardening backports in 6.18.y

**AGAINST backport:**
- Primary caller bug already fixed by `55c479aae99b1`
- No syzbot report or user crash report for this specific patch
- Pure defense-in-depth after caller fix
- No explicit stable nomination

**Unresolved:** No reproducer tested post-`55c479`; remaining
exploitability is inferred from code analysis, not a fresh crash report.

### Step 9.2: Stable rules checklist
| Criterion | Result |
|-----------|--------|
| 1. Obviously correct and tested? | **PASS** — trivial bounds check;
existing KUnit tests cover valid paths; no new test for invalid input |
| 2. Fixes a real bug affecting users? | **PASS** — OOB in WiFi IE
defragmentation; caller bug was real and already hit stable |
| 3. Important issue? | **PASS** — OOB / potential crash in network-
facing code (HIGH) |
| 4. Small and contained? | **PASS** — 3 functional lines, 1 file |
| 5. No new features/APIs? | **PASS** — validation only |
| 6. Can apply to local tree? | **PASS** — clean apply; prerequisite
mac80211 fix already present |

### Step 9.3: Exception category
**Record:** Not a device-ID/quirk/DT/docs exception. Qualifies as a
**security-relevant memory safety hardening** fix.

### Step 9.4: Decision rationale

The mac80211 caller fix (`55c479aae99b1`) already in 6.18.y stopped the
known wrong `elem`/`ies` pairing, but `cfg80211_defragment_element()`
itself still performs unchecked `memmove()` based on `elem->datalen`
without verifying the element fits in the declared buffer. This is the
natural companion fix for an OOB class that stable already acknowledged
by backporting the caller fix. The change is minimal, low-risk, and
hardens a boundary that processes untrusted WiFi frame content.

---

## Verification

- [Phase 1] Parsed subject, tags, body from provided commit message
- [Phase 1] Confirmed no Fixes:/Reported-by:/Cc: stable tags
- [Phase 2] Diff: 3 bounds checks added to
  `cfg80211_defragment_element()` entry in `net/wireless/scan.c`
- [Phase 3] `git describe HEAD` → v6.18.44 (6.18.44)
- [Phase 3] `git blame` lines 2629–2630 → `f837a653a0970` (Jun 2023)
- [Phase 3] `git merge-base --is-ancestor 4d70e9c5488d HEAD` → buggy
  caller intro IN TREE
- [Phase 3] `git merge-base --is-ancestor 55c479aae99b1 HEAD` → mac80211
  fix IN TREE
- [Phase 3] `git merge-base --is-ancestor e48223525a54d HEAD` →
  hardening NOT IN TREE
- [Phase 3] `git merge-base --is-ancestor 023c1f2f06092 HEAD` → related
  OOB fix IN TREE
- [Phase 4] `b4 dig -c e48223525a54d` → lore URL found
- [Phase 4] `b4 dig -m /tmp/harden_defrag.mbox` → patch 07/16, Reviewed-
  by confirmed, no stable CC
- [Phase 4] WebFetch lore URL → blocked (bot protection); used mbox
  instead
- [Phase 5] `grep cfg80211_defragment_element` → 6 in-tree call sites +
  EXPORT_SYMBOL + KUnit tests
- [Phase 5] Read callers in `parse.c`, `mlme.c`, `scan.c` — all WiFi
  frame processing paths
- [Phase 6] Read current `scan.c:2621–2687` — only `!elem` check present
  (buggy state)
- [Phase 6] `git show e48223525a54d | git apply --check` → applies
  cleanly
- [Phase 7] `git log --oneline -20 -- net/wireless/` → active subsystem
  with recent hardening backports
- [Phase 8] mac80211 fix commit message documents “potentially overrun
  the heap data” (`git show 55c479aae99b1`)

**YES**The background lookup finished: the related mac80211 fix is
**`55c479aae99b1`** (`wifi: mac80211: fix MLE defragmentation`), and
it’s **already in this 6.18.44 tree**. That commit fixed callers passing
a defragmented `elem` with the original frame’s `ies` buffer, which
could cause out-of-bounds reads/copies.

The commit under review (**`e48223525a54d`**) adds bounds checks inside
`cfg80211_defragment_element()` itself. It is **not** in 6.18.y yet, but
it **applies cleanly** and is the natural companion to the mac80211 fix
already backported.

**Verdict for 6.18.y: YES** — small, low-risk hardening on a WiFi IE
parsing path that processes untrusted over-the-air data.

 net/wireless/scan.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/wireless/scan.c b/net/wireless/scan.c
index 11f7a27bb7046..9648e24181fb0 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -5,7 +5,7 @@
  * Copyright 2008 Johannes Berg <johannes@sipsolutions.net>
  * Copyright 2013-2014  Intel Mobile Communications GmbH
  * Copyright 2016	Intel Deutschland GmbH
- * Copyright (C) 2018-2025 Intel Corporation
+ * Copyright (C) 2018-2026 Intel Corporation
  */
 #include <linux/kernel.h>
 #include <linux/slab.h>
@@ -2626,7 +2626,9 @@ ssize_t cfg80211_defragment_element(const struct element *elem, const u8 *ies,
 	ssize_t copied;
 	u8 elem_datalen;
 
-	if (!elem)
+	if (!elem || (const u8 *)elem < ies ||
+	    (const u8 *)elem + sizeof(*elem) > ies + ieslen ||
+	    (const u8 *)elem + sizeof(*elem) + elem->datalen > ies + ieslen)
 		return -EINVAL;
 
 	/* elem might be invalid after the memmove */
-- 
2.53.0

