Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B07D53A2560;
	Mon, 20 Apr 2026 13:31:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776691876; cv=none; b=NeTOEJLQ6uF8fFYKu3ic6JzeFzKMl5NK9tLCyTDIgil/SB8LyQcV+SW/StDPOr6wUeYGVhi+2US/t6oaHw4iNhsi7cfqYftVyc8850OFHJ7Dk+mkT5cQ/+BldRWmq8Rbn/ATpRJHAyUxCKEm0kzF3FLUihhnhteU9dMsZTQSfYo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776691876; c=relaxed/simple;
	bh=0AZBXFP3Gue6Qoq8KpSwhCHDauX03K+T/rigRISsjzM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KuAPnvLPxAdZdLmja6zIH5kTzWdXsVynCsdYAv0WodykWGn3kLDIhC/tgSehJJH0zm16+Ss5mfOSr7p+d5HcZpefU+rJyPpz9QbK2sNrGHza+4/I8XamkGMH8bVb7iPVc/kVaRnVw3KcKY/p214HzYIB2N/ZG+ixSRS9q0thniY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NNzuMbb6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NNzuMbb6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32841C2BCB9;
	Mon, 20 Apr 2026 13:31:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776691876;
	bh=0AZBXFP3Gue6Qoq8KpSwhCHDauX03K+T/rigRISsjzM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NNzuMbb6rE47Plsi09+uFBqmFEPFkpzUiCHMMLngcrd0f4OFfCunlbLRe/RqdLVNs
	 qKQn/DGZHWK5I2GOXdC4Pi0CAsLcqDaGJcag2p+YDwQ+bWW+1OheZdi/RH5HuatcM7
	 oBJiXia+fh9ApAAa6y3OKUN9Sh02jnnp3WtCBgO1oiKI3lNYRAttgA2dpThoPJn9TU
	 HYVe1ZFR+Or9tOYJITvV+u8+LEWgKwVr4bGKGSTI3FQWPEorOxu+5JZLli9d6Gx+SV
	 V7YDSaIS0lKQdvZNgswjPj0Wt21/MXdf3sxdRI0r9uGXaWF1EmKJL8sorgeg+TfM6A
	 hn9XaZaoLC5qA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Christian Eggers <ceggers@arri.de>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	marcel@holtmann.org,
	luiz.dentz@gmail.com,
	linux-bluetooth@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0-5.10] Bluetooth: L2CAP: CoC: Disconnect if received packet size exceeds MPS
Date: Mon, 20 Apr 2026 09:20:40 -0400
Message-ID: <20260420132314.1023554-246-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420132314.1023554-1-sashal@kernel.org>
References: <20260420132314.1023554-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 7.0
Content-Transfer-Encoding: 8bit

From: Christian Eggers <ceggers@arri.de>

[ Upstream commit 728a3d128325bad286b1e4f191026e8de8d12a85 ]

Core 6.0, Vol 3, Part A, 3.4.3:
"... If the payload size of any K-frame exceeds the receiver's MPS, the
receiver shall disconnect the channel..."

This fixes L2CAP/LE/CFC/BV-27-C (running together with 'l2test -r -P
0x0027 -V le_public -I 100').

Signed-off-by: Christian Eggers <ceggers@arri.de>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Tested-by: Christian Eggers <ceggers@arri.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I have all the information needed for a comprehensive analysis. Let
me compile the findings.

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Parse Subject Line
- **Subsystem**: `Bluetooth: L2CAP: CoC` (Bluetooth L2CAP Connection-
  oriented Channels)
- **Action verb**: "Disconnect" - implies enforcing mandatory protocol
  behavior (a fix for missing behavior)
- **Summary**: Enforce Bluetooth spec-mandated channel disconnect when
  received packet exceeds MPS (Maximum PDU Size)

Record: [Bluetooth: L2CAP: CoC] [Disconnect/fix] [Enforce mandatory MPS
check and channel disconnect per BT Core 6.0 spec]

### Step 1.2: Parse Tags
- **Signed-off-by**: Christian Eggers (author), Luiz Augusto von Dentz
  (Bluetooth subsystem maintainer, committer)
- **Tested-by**: Christian Eggers (author tested the v2 version)
- **No Fixes: tag** - Expected for AUTOSEL review
- **No Cc: stable** - Expected for AUTOSEL review
- **No Reported-by** - This was found through BT Qualification test
  suite compliance testing

Record: Author is Christian Eggers, a regular Bluetooth contributor.
Committed by subsystem maintainer Luiz Augusto von Dentz. Tested by the
author.

### Step 1.3: Analyze Commit Body
- References **Bluetooth Core 6.0, Vol 3, Part A, 3.4.3** specification
  requirement
- The spec mandates: "If the payload size of any K-frame exceeds the
  receiver's MPS, the receiver shall disconnect the channel"
- This fixes **L2CAP/LE/CFC/BV-27-C** Bluetooth test case (a PTS
  qualification test)
- Without this fix, the kernel violates the Bluetooth specification

Record: Bug = missing mandatory MPS check per Bluetooth spec. Symptom =
BT qualification test failure; potential protocol state confusion from
oversized packets. Root cause = l2cap_ecred_data_rcv() never validated
packet size against MPS.

### Step 1.4: Detect Hidden Bug Fixes
This IS a bug fix, not disguised at all. The commit enforces a mandatory
spec requirement that was missing, preventing oversized packets from
being processed.

Record: Yes, this is a genuine spec compliance bug fix.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory
- **Files changed**: `net/bluetooth/l2cap_core.c` (1 file)
- **Lines**: +7 added, 0 removed
- **Function modified**: `l2cap_ecred_data_rcv()`
- **Scope**: Single-file, single-function, surgical addition

### Step 2.2: Code Flow Change
The patch adds a new check between the existing IMTU check and the
credit decrement:

- **Before**: After validating `skb->len <= chan->imtu`, immediately
  decrements rx_credits
- **After**: After IMTU check, also validates `skb->len <= chan->mps`.
  If exceeded, logs error, sends disconnect request, returns -ENOBUFS

### Step 2.3: Bug Mechanism
Category: **Logic/correctness fix** - missing validation per Bluetooth
specification

The ERTM path (`l2cap_data_rcv()` at line 6561) already checks MPS: `if
(len > chan->mps)`. This check was missing from the LE/Enhanced Credit
Based flow control path (`l2cap_ecred_data_rcv()`), which was added in
v5.7.

### Step 2.4: Fix Quality
- **Obviously correct**: Yes - identical pattern to the MPS check in
  `l2cap_data_rcv()` and the IMTU check immediately above
- **Minimal/surgical**: Yes - +7 lines, single check block
- **Regression risk**: Very low - this only rejects oversized packets
  that the spec says must be rejected
- **Red flags**: None

Record: Trivial, obviously correct spec compliance fix.

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame
- `l2cap_ecred_data_rcv()` was created in commit `15f02b91056253`
  ("Bluetooth: L2CAP: Add initial code for Enhanced Credit Based Mode")
  from v5.7-rc1
- The original LE flow control code (`aac23bf63659`) dates from
  v3.14-rc1 (2013)
- The MPS check was never present in the ecred/LE flow control receive
  path

### Step 3.2: Fixes Tag
No Fixes: tag present (expected for AUTOSEL). However, the sibling
commits by the same author (e1d9a66889867, b6a2bf43aa376) reference
`Fixes: aac23bf63659`, which is in v3.14+.

### Step 3.3: File History / Related Changes
The commit is part of a **4-patch series** by Christian Eggers:
1. [PATCH 1/4] `e1d9a66889867` - Disconnect if SDU exceeds IMTU
   (**already in v7.0**)
2. [PATCH 2/4] THIS COMMIT - Disconnect if packet exceeds MPS (reworked
   as v2 by maintainer)
3. [PATCH 3/4] `b6a2bf43aa376` - Disconnect if sum of payload sizes
   exceed SDU (**already in v7.0**)
4. [PATCH 4/4] `0e4d4dcc1a6e8` - SMP test fix (**already in v7.0**)

Patches 1, 3, 4 are in the v7.0 tree. Patch 2 was reworked as a v2 by
the maintainer and applied to bluetooth-next (commit cb75c9a0505b).

### Step 3.4: Author's Context
Christian Eggers is a regular Bluetooth contributor with 8+ commits to
the Bluetooth subsystem. The maintainer (Luiz von Dentz) reworked v1 to
a simpler v2 (using `chan->mps` directly instead of a new `mps_orig_le`
field), demonstrating active review.

### Step 3.5: Dependencies
- **Soft dependency**: Commit `e1d9a66889867` changes the context above
  (reformats IMTU check and adds `l2cap_send_disconn_req`). Without it,
  the patch needs minor context adjustment, but the code logic is
  independent.
- This is functionally standalone - the MPS check is new code that
  doesn't depend on any other check.

Record: The MPS check is functionally standalone. In older stable trees
without e1d9a66889867, the context would differ slightly but the fix can
be adapted.

---

## PHASE 4: MAILING LIST RESEARCH

### Step 4.1: Original Discussion
- **v1** submitted as [PATCH 2/4] at
  `20260225170728.30327-2-ceggers@arri.de`
- v1 introduced a new `mps_orig_le` field (Luiz questioned this
  approach)
- **v2** submitted by Luiz Augusto von Dentz with simplified approach
  using `chan->mps` directly
- Applied to bluetooth-next on Feb 27, 2026

### Step 4.2: Reviewers
- Luiz Augusto von Dentz (Bluetooth subsystem maintainer) personally
  reworked the patch
- Christian Eggers provided Tested-by on v2
- No NAKs or concerns raised

### Step 4.3: No syzbot or user bug reports; found via BT qualification
testing

### Step 4.4: Series Context
The other 3 patches in the series are already in v7.0. This is the only
one remaining to be backported.

### Step 4.5: No stable-specific discussion found.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Key Function
- `l2cap_ecred_data_rcv()` - receives data for LE FlowCtl and Enhanced
  Credit Based modes

### Step 5.2: Callers
Called from `l2cap_data_channel()` at line 6834 for both
`L2CAP_MODE_LE_FLOWCTL` and `L2CAP_MODE_EXT_FLOWCTL` modes. This is the
main L2CAP data receive path for all LE Connection-oriented Channels.

### Step 5.3-5.4: Impact Surface
This function is called on every incoming L2CAP packet for LE CoC
connections. Any Bluetooth device using LE L2CAP (BLE) can trigger this
code path.

### Step 5.5: Similar Patterns
The ERTM path in `l2cap_data_rcv()` (line 6561) already has `if (len >
chan->mps)` with disconnect. The ecred path was missing this analogous
check.

---

## PHASE 6: STABLE TREE ANALYSIS

### Step 6.1: Buggy Code Existence
- `l2cap_ecred_data_rcv()` exists since v5.7 (commit `15f02b91056253`)
- The function exists in ALL active stable trees: v5.10, v5.15, v6.1,
  v6.6, v6.12, v7.0

### Step 6.2: Backport Complications
- For stable trees that already have `e1d9a66889867` (IMTU disconnect
  fix): clean apply
- For trees without it: minor context adjustment needed (the IMTU check
  looks slightly different)

### Step 6.3: No related MPS fix already in stable.

---

## PHASE 7: SUBSYSTEM CONTEXT

### Step 7.1: Subsystem
- **Bluetooth** (`net/bluetooth/`) - IMPORTANT subsystem
- Used by all BLE-capable devices (billions of devices)

### Step 7.2: Activity
Very active - 30+ L2CAP changes in recent history with many security and
correctness fixes.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: Affected Users
All users of Bluetooth Low Energy (BLE) with L2CAP Connection-oriented
Channels. This includes IoT devices, audio devices, input peripherals,
and more.

### Step 8.2: Trigger Conditions
Any remote BLE device sending a K-frame with payload exceeding the
receiver's MPS. This can be triggered by:
- A misbehaving or malicious remote BLE device
- Protocol violations from buggy firmware

### Step 8.3: Failure Mode Severity
Without the fix:
- **Spec violation**: Oversized packets are processed instead of being
  rejected (MEDIUM)
- **Potential protocol state confusion**: Processing oversized data can
  corrupt SDU reassembly (MEDIUM-HIGH)
- **Security implication**: Remote device can send larger-than-expected
  data that gets processed (MEDIUM)
- Severity: **MEDIUM-HIGH**

### Step 8.4: Risk-Benefit Ratio
- **Benefit**: HIGH - enforces mandatory Bluetooth spec requirement,
  fixes qualification test, prevents oversized packet processing
- **Risk**: VERY LOW - +7 lines, identical pattern to existing checks,
  only rejects already-invalid packets
- **Ratio**: Strongly favorable for backport

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence Compilation

**FOR backporting:**
- Fixes missing mandatory Bluetooth Core Spec validation (spec
  compliance bug)
- +7 lines, single function, obviously correct surgical fix
- Follows identical pattern to existing MPS check in ERTM path and IMTU
  check in same function
- Reviewed/reworked by Bluetooth subsystem maintainer
- Tested by the original author
- The companion patches (1/4, 3/4) are already merged, making this
  independent
- Prevents processing oversized packets from remote devices (security-
  adjacent)
- Code exists in all active stable trees (v5.7+)

**AGAINST backporting:**
- Not triggered by syzbot or user crash reports (found via qualification
  testing)
- No explicit Fixes: tag (expected for AUTOSEL)
- Minor context adjustment may be needed for older trees without
  e1d9a66889867

### Step 9.2: Stable Rules Checklist
1. Obviously correct and tested? **YES** - tested by author, pattern-
   matched to existing code
2. Fixes a real bug? **YES** - missing mandatory spec validation
3. Important issue? **YES** - protocol compliance, potential
   security/state confusion
4. Small and contained? **YES** - +7 lines in one function
5. No new features/APIs? **YES** - only adds validation
6. Can apply to stable? **YES** - clean apply to v7.0; minor adjustment
   for older trees

### Step 9.3: Exception Categories
Not an exception category; this is a standard protocol compliance bug
fix.

### Step 9.4: Decision
This is a small, obviously correct fix that enforces a mandatory
Bluetooth specification requirement. It prevents oversized packets from
being processed by the kernel, which is both a spec compliance issue and
a security-adjacent concern. The fix is minimal (+7 lines), follows
established patterns in the same codebase, was reviewed/reworked by the
subsystem maintainer, and tested by the author.

---

## Verification

- [Phase 1] Parsed commit message: references BT Core 6.0, Vol 3, Part
  A, 3.4.3; fixes L2CAP/LE/CFC/BV-27-C test
- [Phase 2] Diff analysis: +7 lines in `l2cap_ecred_data_rcv()`, adds
  MPS size validation with disconnect
- [Phase 3] git blame: `l2cap_ecred_data_rcv()` created in
  `15f02b91056253` (v5.7-rc1), MPS check never present
- [Phase 3] git show: ERTM path at line 6561 already has `if (len >
  chan->mps)` - ecred path missing this
- [Phase 3] Related commits: siblings e1d9a66889867, b6a2bf43aa376
  already in v7.0 with Fixes: aac23bf63659
- [Phase 3] git merge-base: aac23bf63659 is in v3.14+; 15f02b91056253 is
  in v5.7+; both in all active stable trees
- [Phase 4] Mailing list: v1 reworked to v2 by maintainer Luiz von
  Dentz; Christian Eggers confirmed v2 works (Tested-by)
- [Phase 4] Applied to bluetooth-next on Feb 27, 2026 (patchwork-bot
  confirmation)
- [Phase 4] No NAKs or objections raised
- [Phase 5] Callers: `l2cap_data_channel()` for L2CAP_MODE_LE_FLOWCTL
  and L2CAP_MODE_EXT_FLOWCTL
- [Phase 6] Code exists in all active stable trees (v5.10+, v6.1, v6.6,
  v6.12)
- [Phase 8] Impact: all BLE CoC users; trigger: remote device sends
  packet > MPS; severity MEDIUM-HIGH

**YES**

 net/bluetooth/l2cap_core.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/net/bluetooth/l2cap_core.c b/net/bluetooth/l2cap_core.c
index 95c65fece39bd..9916ae6abef04 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -6705,6 +6705,13 @@ static int l2cap_ecred_data_rcv(struct l2cap_chan *chan, struct sk_buff *skb)
 		return -ENOBUFS;
 	}
 
+	if (skb->len > chan->mps) {
+		BT_ERR("Too big LE L2CAP MPS: len %u > %u", skb->len,
+		       chan->mps);
+		l2cap_send_disconn_req(chan, ECONNRESET);
+		return -ENOBUFS;
+	}
+
 	chan->rx_credits--;
 	BT_DBG("chan %p: rx_credits %u -> %u",
 	       chan, chan->rx_credits + 1, chan->rx_credits);
-- 
2.53.0

