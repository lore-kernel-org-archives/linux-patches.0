Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64F4A4A3870;
	Mon, 31 Aug 2026 13:42:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183751; cv=none; b=FHAaPZLYVBMK2Yt1SNtY5g87Z87yKHb01PhcyuYK3qSE5WewrUMTdFxRG2rLS1+ypElf+NlPqV2CXC4JJFYdluD5bBEAe3cHNutFlU8tkPz9wfF6X+tZ21ovuL8TFwipbUOlvL3ln0FTfzzuQxl2RQW0W2d/B6/ZLYxYSvRQQdE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183751; c=relaxed/simple;
	bh=SAnlAci/Bj1w92m9W0EwI/gzdUBxEIknHGb08pfIo1M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=m64TsT3S3u/4wkHT+9fuD0yfvxfCIvYKxezMNiI4bCiE10rSJzzAIk1ErO9PqTSuabiIWwDhOH3djCfAfDzcrMoHb8Q6sJeXSH4nUD7GrEWC38PWBilc8W/cBmUY53Vr9mCoWbAKKEnXhOYhE+J+9J7QdHBHjYGBraMdmtsE7GE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=A+OssN7Z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="A+OssN7Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C2D81F00A3F;
	Mon, 31 Aug 2026 13:42:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183748;
	bh=y/XpQkTwD7YDfNmRf1hxIgdzel+6jf6KqkpHKItv8lM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=A+OssN7ZVEq0NqScoLE2gyJpxokH+0sDfeq99qxiTvN8aDg7oihGAdUXzXm8qwvYZ
	 12n/zekeBfjUZHCgWHvxtjceNm6T/KQPsj5hJiVKrrWmMbH/C9IXTrFM0F1kPYmywG
	 ksPBKm5ES1Wm2Ffi6tRmRFea3sVSSqLisG8dBvLBfWJuG8ObQHyO/jz+msl8b4x4EA
	 hWwMJQA0CjrbZnXLuEyFFjId14lE0pnOSwiMqpmDqcLT9FFydZYpOSuQilBs1lVlN9
	 rF1l33+APq1WWTieigv0wF9DKF5JcSdmT4JqeN45Msc3LwcHW8NlIv21YoNpihTJ0N
	 pRw1rWIGwj7HQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Rinitha S <sx.rinitha@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	przemyslaw.kitszel@intel.com,
	andrew+netdev@lunn.ch,
	davem@davemloft.net,
	edumazet@google.com,
	pabeni@redhat.com,
	intel-wired-lan@lists.osuosl.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] ice: pass the return value of skb_checksum_help()
Date: Mon, 31 Aug 2026 09:25:08 -0400
Message-ID: <20260831133314.4125787-280-sashal@kernel.org>
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

From: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>

[ Upstream commit 2d19302f628853742c4828381abbd668c1315598 ]

skb_checksum_help() can fail. Pass its return value back to the caller.

Commonize this software path in goto.

Instead of just returning error try calculating software checksum first.
There is a check for TSO in checksum_sw_fb.

Reviewed-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Signed-off-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Tested-by: Rinitha S <sx.rinitha@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Link: https://patch.msgid.link/20260717185340.3595286-4-anthony.l.nguyen@intel.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit Message Forensics

**Step 1.1 — Subject line**
Record: `[ice]` `[pass]` — propagate `skb_checksum_help()` return value
in `ice_tx_csum()`.

**Step 1.2 — Tags**
Record:
- `Reviewed-by:` Aleksandr Loktionov (Intel)
- `Tested-by:` Rinitha S (Intel)
- `Signed-off-by:` Michal Swiatkowski, Tony Nguyen, Jakub Kicinski
- `Link:` https://patch.msgid.link/20260717185340.3595286-4-
  anthony.l.nguyen@intel.com
- No `Fixes:`, `Reported-by:`, `Cc: stable@vger.kernel.org`, or `Acked-
  by:` on this specific patch
- Part of `[PATCH net 03/13]` series (not a multi-part dependency for
  this hunk)

**Step 1.3 — Body analysis**
Record:
- **Bug:** `skb_checksum_help()` can fail, but `ice_tx_csum()` ignored
  its return value and returned `0`.
- **Symptom:** On software-checksum fallback failure, the TX path
  continues as if checksum handling succeeded; the skb may remain
  `CHECKSUM_PARTIAL` and be transmitted without a valid checksum.
- **Root cause:** Error paths called `skb_checksum_help(skb); return 0;`
  instead of propagating the error.
- **Additional intent:** Consolidate fallback paths under
  `checksum_sw_fb`; for some paths that previously returned `-1`, try
  software checksum first (unless TSO).

**Step 1.4 — Hidden bug fix?**
Record: **Yes.** Although framed as error propagation/cleanup, this
fixes a real TX correctness bug: continuing transmission after
`skb_checksum_help()` failure.

---

## Phase 2: Diff Analysis

**Step 2.1 — Inventory**
Record:
- **File:** `drivers/net/ethernet/intel/ice/ice_txrx.c` (+9 / -11)
- **Function:** `ice_tx_csum()`
- **Scope:** Single-file, single-function surgical change

**Step 2.2 — Code flow changes**
Record per hunk:
1. **Encapsulated IPv6 `ipv6_skip_exthdr()` failure:** `return -1` →
   `goto checksum_sw_fb` (try SW checksum before drop, unless TSO).
2. **Unknown outer transport (default):** inline `skb_checksum_help();
   return 0` → `goto checksum_sw_fb`.
3. **Neither IPv4 nor IPv6 inner header:** `return -1` → `goto
   checksum_sw_fb`.
4. **Unknown inner L4 protocol (default):** inline `skb_checksum_help();
   return 0` → `goto checksum_sw_fb`.
5. **New label `checksum_sw_fb`:** TSO still returns `-1`; otherwise
   `return skb_checksum_help(skb)`.

**Step 2.3 — Bug mechanism**
Record: **Error-path / logic correctness fix.**
`skb_checksum_help()` returns `0` on success or negative on failure
(`-EINVAL`, `-EFAULT`, `-ENOMEM`, etc., per `net/core/dev.c`). Old code
always returned `0` after calling it. Caller `ice_xmit_frame_ring()`
only drops on `csum < 0`, so failures were treated as success.

**Step 2.4 — Fix quality**
Record: **Obviously correct and minimal.** Matches the pattern used in
`fm10k` (checks `skb_checksum_help()` return). Low regression risk; TSO
paths still fail hard. Minor behavioral broadening on paths that
previously dropped immediately now attempt software checksum first.

---

## Phase 3: Git History Investigation

**Step 3.1 — Blame**
Record: Buggy `skb_checksum_help(); return 0` lines blame to
`5d324e5159d9e` (merge artifact; `ice_txrx.c` content is present
throughout this 6.18.y tree). The ignored-return pattern exists in
current `HEAD`.

**Step 3.2 — Fixes: tag**
Record: N/A — no `Fixes:` tag present.

**Step 3.3 — Related file history**
Record: Recent `ice_txrx.c` changes in this tree include double-free
fix, jumbo_remove revert, etc. No duplicate fix for this issue. Commit
`2d19302f6288` is **not** in `HEAD`.

**Step 3.4 — Author context**
Record: Intel wired-LAN team (Michal Swiatkowski, Tony Nguyen).
Reviewed/tested internally. netdev maintainers (Davem, Kuba, netdev
list) were CC'd per `b4 dig -w`.

**Step 3.5 — Dependencies**
Record: **Standalone.** Only touches `ice_tx_csum()` in `ice_txrx.c`.
Patch is 03/13 of a larger pull request, but this hunk has no structural
dependency on other series patches. `git apply --check` succeeds cleanly
on this tree.

---

## Phase 4: Mailing List and External Research

**Step 4.1 — Original discussion**
Record:
- `b4 dig -c 2d19302f6288`: https://patch.msgid.link/20260717185340.3595
  286-4-anthony.l.nguyen@intel.com
- Earlier v2 series: `[PATCH iwl-next v2 0/4]` from May 2026
- Applied version is the July 2026 netdev 03/13 submission

**Step 4.2 — Reviewers**
Record: netdev maintainers CC'd (davem, kuba, pabeni, edumazet,
andrew+netdev). Intel reviewers on patch.

**Step 4.3 — Bug reports**
Record: No syzbot/user bug report. Issue identified by code review /
driver maintainers.

**Step 4.4 — Series context**
Record: Part of 13-patch Intel wired-LAN pull. Sibling patches (PTP
crash, ptype bounds, etc.) explicitly carry `Cc:
stable@vger.kernel.org`; **this patch does not**, which is a mild
negative signal but not decisive per review instructions.

**Step 4.5 — Stable list**
Record: No stable-list discussion found specifically for this patch.
Other patches in the same series were stable-nominated.

---

## Phase 5: Code Semantic Analysis

**Step 5.1 — Key functions**
Record: `ice_tx_csum()` (modified), `checksum_sw_fb` (new label).

**Step 5.2 — Callers**
Record: `ice_xmit_frame_ring()` at line 2648:
```c
csum = ice_tx_csum(first, &offload);
if (csum < 0)
    goto out_drop;
```
Called from `ice_start_xmit()` → standard netdev TX hot path
(userspace/network stack packet transmission).

**Step 5.3 — Callees**
Record: `ipv6_skip_exthdr()`, `skb_checksum_help()` (can
allocate/linearize skb, validate offsets).

**Step 5.4 — Reachability**
Record: **Userspace-reachable** via normal packet transmission on Intel
E810/ice NICs with `CHECKSUM_PARTIAL` skbs that cannot use hardware
offload (unusual L4, encapsulation edge cases, memory pressure during
linearization).

**Step 5.5 — Similar patterns**
Record: Same ignored-return pattern exists in sibling Intel drivers
(`i40e`, `iavf`, `idpf`, `ixgbe`, etc.). `fm10k` correctly checks the
return value. This fix addresses ice only.

---

## Phase 6: Cross-Reference Against Local Tree

**Step 6.1 — Buggy code present?**
Record: **Yes.** Local tree is `v6.18.44` (`linux-6.18.y`).
`ice_tx_csum()` at lines 2106-2107 and 2221-2222 has the buggy pattern.
Fix commit `2d19302f6288` is **not** merged.

**Step 6.2 — Backport complications**
Record: **Clean apply** — `git apply --check` on `2d19302f6288` passes
with no conflicts.

**Step 6.3 — Related fixes already present?**
Record: **No** equivalent fix in this tree.

---

## Phase 7: Subsystem and Maintainer Context

**Step 7.1 — Subsystem**
Record: `drivers/net/ethernet/intel/ice` — **IMPORTANT** (widely
deployed datacenter 10/25/100GbE driver).

**Step 7.2 — Activity**
Record: Actively maintained; multiple ice fixes already in 6.18.y (PTP,
ptype, memory leaks, etc.).

---

## Phase 8: Impact and Risk Assessment

**Step 8.1 — Who is affected**
Record: Systems using Intel ice NICs (`CONFIG_ICE`) transmitting
`CHECKSUM_PARTIAL` packets that hit software-checksum fallback paths.

**Step 8.2 — Trigger conditions**
Record:
- Unusual/unsupported L4 in encapsulated packets
- `ipv6_skip_exthdr()` parse failures
- `skb_checksum_help()` failures: bad offsets (`-EINVAL`), unreadable
  frags (`-EFAULT`), OOM during linearize (`-ENOMEM`)
- **Frequency:** Uncommon edge cases, not every packet
- **Unprivileged trigger:** Yes, via normal network traffic patterns

**Step 8.3 — Failure mode severity**
Record: **MEDIUM-HIGH** — not a kernel oops/panic, but transmits packets
with invalid/missing checksums when software checksum computation fails
(outbound data integrity corruption). Caller should drop; old code did
not.

**Step 8.4 — Risk-benefit**
Record:
- **Benefit:** Correct error handling on common TX path; prevents
  corrupt outbound packets on failure
- **Risk:** Very low — 20-line change, Intel-reviewed/tested, applies
  cleanly
- **Ratio:** Favorable for backport

---

## Phase 9: Final Synthesis

**Evidence FOR:**
- Real, verifiable bug (ignored error return)
- Affects standard TX path on widely used driver
- Small, self-contained, applies cleanly to 6.18.44
- Reviewed and tested by Intel; merged to netdev
- Caller already handles negative returns correctly (`out_drop`)
- Prevents transmitting `CHECKSUM_PARTIAL` skbs after checksum setup
  failed

**Evidence AGAINST:**
- No crash/oops/security report; impact is network correctness on rare
  paths
- Not explicitly `Cc: stable` (unlike several sibling patches in same
  series)
- Slight behavior change: some previously-dropped paths now attempt
  software checksum first

**Stable rules checklist:**
1. Obviously correct and tested? **PASS** (Intel Reviewed-by/Tested-by;
   logic is straightforward)
2. Fixes a real bug? **PASS**
3. Important issue? **PASS** (outbound packet integrity corruption on
   error paths)
4. Small and contained? **PASS** (1 file, ~20 lines)
5. No new features/APIs? **PASS**
6. Can apply to local tree? **PASS** (verified clean apply)

**Exception category:** N/A (not device ID/quirk/build/doc fix).

---

## Problem Summary for Stable Users

On Intel ice NICs in this 6.18.y tree, when hardware checksum offload
cannot handle a `CHECKSUM_PARTIAL` packet and the driver falls back to
`skb_checksum_help()`, a failure in that function is silently ignored.
The driver returns success, and the packet may be transmitted without a
valid checksum. The fix propagates the error so `ice_xmit_frame_ring()`
drops the skb instead of sending a corrupt packet. This is a low-risk,
high-correctness fix appropriate for stable.

## Verification

- [Phase 1] Parsed commit message and tags from provided diff + `git
  show 2d19302f6288`
- [Phase 2] Read current `ice_tx_csum()` and `skb_checksum_help()` in
  tree
- [Phase 3] `git describe HEAD` → `v6.18.44`; `git blame` on lines
  2102-2107, 2218-2222
- [Phase 3] `git merge-base` check: fix NOT in HEAD
- [Phase 3] `git apply --check` on `2d19302f6288` → clean
- [Phase 4] `b4 dig -c 2d19302f6288` → lore URL found
- [Phase 4] `b4 dig -a` → v2 iwl-next series + v1 net 01/13 series
- [Phase 4] `b4 dig -w` → netdev maintainers CC'd
- [Phase 4] Saved mbox; confirmed patch 03/13 lacks explicit `Cc:
  stable`
- [Phase 5] Traced caller `ice_xmit_frame_ring()` lines 2648-2650
- [Phase 5] Read `skb_checksum_help()` return paths in
  `net/core/dev.c:3555-3606`
- [Phase 5] Compared with `fm10k_main.c:810` (checks return value)
- [Phase 6] Confirmed buggy code at `ice_txrx.c:2106-2107, 2221-2222`
- [Phase 8] Assessed failure mode as outbound packet corruption, not
  kernel crash

**YES**The analysis is complete for commit `2d19302f6288` (`ice: pass
the return value of skb_checksum_help()`) against the local **v6.18.44**
(`linux-6.18.y`) tree.

**Verdict: YES** — backport it.

**Why:** In `ice_tx_csum()`, `skb_checksum_help()` failures were ignored
and the function returned `0`, so `ice_xmit_frame_ring()` could transmit
`CHECKSUM_PARTIAL` packets without a valid checksum. The fix is small
(one function in `ice_txrx.c`), applies cleanly here, and is
reviewed/tested by Intel.

**Local state:** The buggy code is still present; the fix is not in this
tree yet.

 drivers/net/ethernet/intel/ice/ice_txrx.c | 20 +++++++++-----------
 1 file changed, 9 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.c b/drivers/net/ethernet/intel/ice/ice_txrx.c
index 73f08d02f9c76..b843f66c4a6e0 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx.c
+++ b/drivers/net/ethernet/intel/ice/ice_txrx.c
@@ -2081,7 +2081,7 @@ int ice_tx_csum(struct ice_tx_buf *first, struct ice_tx_offload_params *off)
 			ret = ipv6_skip_exthdr(skb, exthdr - skb->data,
 					       &l4_proto, &frag_off);
 			if (ret < 0)
-				return -1;
+				goto checksum_sw_fb;
 		}
 
 		/* define outer transport */
@@ -2100,11 +2100,7 @@ int ice_tx_csum(struct ice_tx_buf *first, struct ice_tx_offload_params *off)
 			l4.hdr = skb_inner_network_header(skb);
 			break;
 		default:
-			if (first->tx_flags & ICE_TX_FLAGS_TSO)
-				return -1;
-
-			skb_checksum_help(skb);
-			return 0;
+			goto checksum_sw_fb;
 		}
 
 		/* compute outer L3 header size */
@@ -2163,7 +2159,7 @@ int ice_tx_csum(struct ice_tx_buf *first, struct ice_tx_offload_params *off)
 			ipv6_skip_exthdr(skb, exthdr - skb->data, &l4_proto,
 					 &frag_off);
 	} else {
-		return -1;
+		goto checksum_sw_fb;
 	}
 
 	/* compute inner L3 header size */
@@ -2216,15 +2212,17 @@ int ice_tx_csum(struct ice_tx_buf *first, struct ice_tx_offload_params *off)
 		break;
 
 	default:
-		if (first->tx_flags & ICE_TX_FLAGS_TSO)
-			return -1;
-		skb_checksum_help(skb);
-		return 0;
+		goto checksum_sw_fb;
 	}
 
 	off->td_cmd |= cmd;
 	off->td_offset |= offset;
 	return 1;
+
+checksum_sw_fb:
+	if (first->tx_flags & ICE_TX_FLAGS_TSO)
+		return -1;
+	return skb_checksum_help(skb);
 }
 
 /**
-- 
2.53.0

