Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A7D647D940;
	Mon, 20 Apr 2026 13:31:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776691863; cv=none; b=U5KokZoZjzJHT3a9/XIVgdS1WHEoNhKcH+25HJ0vNp69j7pgsia31ISGMUX/1Yt/avPcYxnQNm/4BkWqs2jmBzlR9X3zxG7hNbBjWD6sW0a/t/FY6K+gH7iNY0IxJcQTc6gitNGBjr+pPY4FATqdR1RdqzEnzlbxCcm1DvXkXOE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776691863; c=relaxed/simple;
	bh=CvP8nD4HG2uD44hOmrt8v4Fu61Ks5uwpzaWd/ENKyQk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PKEPIHfPht5VNv2P5WYTm5UMgFH7pKUqVZ44x201lOV3uYus/eacDn7NgpHJCxPw3Pc0U98C0YgFgQPDFXtzucsnQdgiY1kR3W40uVkfz6Aicg/OlsZxmv68akHZNNqn4pv5btJMB7vaBsETEohh1q4lWb96aQUt+G/lrfIRUoU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AS1BmRqn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AS1BmRqn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAE1CC4AF09;
	Mon, 20 Apr 2026 13:31:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776691863;
	bh=CvP8nD4HG2uD44hOmrt8v4Fu61Ks5uwpzaWd/ENKyQk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AS1BmRqnzfDc6gi1O7FJsOUUXUC3zsqXO3qtZhZ+8hVOYN/+YzwSQG6k1tmoOo3Di
	 zWEWM0QMbEn/DNR0ET/lQZqMtZVMjlNsBZoLpYlmlCB8vryiHtOxzt2LRGSICdK/ov
	 82Oi52oInQTnbd2aaGlOzsiIL4iLaZjEYC2DQPrqhj1petG2MbRsiL1YMgOBqYoHHr
	 eRbNIxW9sXFu557arLF9T30WOo5Ai9HBYnklCS4X+SWQf218JxRs5UYZvTyvt8xn6u
	 5GY2Ka5GnQFiiP3jOxvJ3T+fHXYX6x3C/BB8pKQnKR0OGZ0dz7drJeZbeWDRwcPrej
	 XLMsr5GtoB2PA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Fernando Fernandez Mancera <fmancera@suse.de>,
	Luka Gejak <luka.gejak@linux.dev>,
	Felix Maurer <fmaurer@redhat.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0-6.18] net: hsr: emit notification for PRP slave2 changed hw addr on port deletion
Date: Mon, 20 Apr 2026 09:20:32 -0400
Message-ID: <20260420132314.1023554-238-sashal@kernel.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Fernando Fernandez Mancera <fmancera@suse.de>

[ Upstream commit 2ce8a41113eda1adddc1e6dc43cf89383ec6dc22 ]

On PRP protocol, when deleting the port the MAC address change
notification was missing. In addition to that, make sure to only perform
the MAC address change on slave2 deletion and PRP protocol as the
operation isn't necessary for HSR nor slave1.

Note that the eth_hw_addr_set() is correct on PRP context as the slaves
are either in promiscuous mode or forward offload enabled.

Reported-by: Luka Gejak <luka.gejak@linux.dev>
Closes: https://lore.kernel.org/netdev/DHFCZEM93FTT.1RWFBIE32K7OT@linux.dev/
Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>
Reviewed-by: Felix Maurer <fmaurer@redhat.com>
Link: https://patch.msgid.link/20260403123928.4249-2-fmancera@suse.de
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I have all the information needed. Let me compile the full analysis.

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Subject Line
- **Subsystem**: net: hsr (HSR/PRP networking protocol)
- **Action verb**: "emit notification" (implies a missing notification =
  bug fix)
- **Summary**: Adds missing NETDEV_CHANGEADDR notification when PRP
  slave2's MAC is restored during port deletion, and scopes the MAC
  restore to only PRP slave_B.

### Step 1.2: Tags
- **Reported-by**: Luka Gejak <luka.gejak@linux.dev> — real user report
- **Closes**:
  https://lore.kernel.org/netdev/DHFCZEM93FTT.1RWFBIE32K7OT@linux.dev/ —
  links to the bug report
- **Signed-off-by**: Fernando Fernandez Mancera <fmancera@suse.de>
  (author, SUSE), Paolo Abeni <pabeni@redhat.com> (networking
  maintainer)
- **Reviewed-by**: Felix Maurer <fmaurer@redhat.com>
- **Link**:
  https://patch.msgid.link/20260403123928.4249-2-fmancera@suse.de
- **Fixes: b65999e7238e** ("net: hsr: sync hw addr of slave2 according
  to slave1 hw addr on PRP") — found in the original mbox, targets the
  commit that introduced the bug

### Step 1.3: Commit Body
The commit explains that on PRP protocol, when deleting a port, the
NETDEV_CHANGEADDR notification was missing. The commit also restricts
the MAC address restoration to only slave_B on PRP (since only slave_B's
MAC is changed at setup time). The commit author explicitly notes that
`eth_hw_addr_set()` is correct since PRP slaves are in promiscuous mode
or have forward offload enabled.

### Step 1.4: Hidden Bug Fix
This is an explicit bug fix — a missing notification and an overly-broad
MAC address restoration.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory
- **File**: `net/hsr/hsr_slave.c` (single file)
- **Lines**: +5, -1 (net 4 lines added)
- **Function**: `hsr_del_port()`
- **Scope**: Single-file surgical fix

### Step 2.2: Code Flow Change
**Before**: The unconditional `eth_hw_addr_set(port->dev,
port->original_macaddress)` was called for ALL non-master ports (both
HSR and PRP, both slave_A and slave_B), and no NETDEV_CHANGEADDR
notification was emitted.

**After**: The MAC restoration is conditional on `hsr->prot_version ==
PRP_V1 && port->type == HSR_PT_SLAVE_B`, and a
`call_netdevice_notifiers(NETDEV_CHANGEADDR, port->dev)` is emitted.

### Step 2.3: Bug Mechanism
**Category**: Logic/correctness fix — missing notification + overly
broad MAC restoration
- The creation path (`hsr_dev_finalize()` and `hsr_netdev_notify()`)
  correctly calls `call_netdevice_notifiers(NETDEV_CHANGEADDR, ...)` but
  the deletion path did not.
- The MAC address was restored even for ports that never had their MAC
  changed (HSR ports, PRP slave_A).

### Step 2.4: Fix Quality
- Obviously correct — symmetric with the creation path behavior
- Minimal and surgical — 4 net lines
- No regression risk — restricts behavior to only the case where it's
  needed
- Reviewed by Felix Maurer (Red Hat), applied by Paolo Abeni (networking
  maintainer)

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame
The buggy line (`eth_hw_addr_set(port->dev, port->original_macaddress)`)
was introduced by commit `b65999e7238e6` (Fernando Fernandez Mancera,
2025-04-09).

### Step 3.2: Fixes Target
Commit `b65999e7238e6` ("net: hsr: sync hw addr of slave2 according to
slave1 hw addr on PRP") first appeared in v6.16. It added PRP MAC
synchronization: setting slave_B's MAC to match slave_A's during
creation, propagating MAC changes from slave_A to slave_B, and restoring
the original MAC during deletion. The deletion path was incomplete — no
notification and no scope restriction.

### Step 3.3: File History
Between `b65999e7238e6` and HEAD, `hsr_del_port()` was NOT modified —
the buggy code persists unchanged in current HEAD.

### Step 3.4: Author
Fernando Fernandez Mancera is both the author of the original buggy
commit and the fix. He has multiple HSR-related commits in the tree.
He's now at SUSE (was at riseup.net).

### Step 3.5: Dependencies
This is a standalone fix. The only prerequisite is `b65999e7238e6` which
introduced the code being fixed. No other patches needed.

---

## PHASE 4: MAILING LIST RESEARCH

### Step 4.1: Original Discussion
The original patch `b65999e7238e6` (v3, net-next) was reviewed on the
mailing list. Luka Gejak posted a detailed review pointing out the exact
issues this fix addresses: missing `call_netdevice_notifiers()` in
`hsr_del_port()` and the use of `eth_hw_addr_set()` vs
`dev_set_mac_address()`. Despite these review comments, the patch was
merged by David S. Miller.

### Step 4.2: Fix Review
The fix was reviewed by Felix Maurer (Red Hat) and applied by Paolo
Abeni (Red Hat, networking maintainer). DKIM verified.

### Step 4.3: Bug Report
The Closes: tag references Luka Gejak's review of the original commit
where he identified the missing notification and other issues.

### Step 4.4: Series Context
b4 confirms this is a single standalone patch (Total patches: 1),
despite the message-id suffix "-2".

### Step 4.5: Stable Discussion
The author noted in the patch: "routed through net-next tree as the next
net tree as rc6 batch is already out." The original mbox contains a
`Fixes:` tag targeting `b65999e7238e`.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Functions Modified
Only `hsr_del_port()` is modified.

### Step 5.2: Callers
`hsr_del_port()` is called during HSR/PRP interface teardown. This is
the standard port deletion path triggered by userspace via netlink.

### Step 5.3: Consistency
The creation path in `hsr_dev_finalize()` (line 798-800) correctly does:
```c
if (protocol_version == PRP_V1) {
    eth_hw_addr_set(slave[1], slave[0]->dev_addr);
    call_netdevice_notifiers(NETDEV_CHANGEADDR, slave[1]);
}
```
The fix makes the deletion path symmetric with this.

### Step 5.5: Similar Patterns
The `hsr_netdev_notify()` handler (lines 82-88) also correctly calls
`call_netdevice_notifiers(NETDEV_CHANGEADDR, ...)` when propagating MAC
changes to slave_B. The deletion path was the only one missing the
notification.

---

## PHASE 6: STABLE TREE ANALYSIS

### Step 6.1: Buggy Code in Stable
The buggy commit `b65999e7238e6` first appeared in v6.16. It is present
in v6.16.y, v6.17.y, v6.18.y, v6.19.y, and v7.0.y stable trees.

### Step 6.2: Backport Difficulty
The `hsr_del_port()` function has NOT changed between v6.16 and v7.0.
The patch applies cleanly to v6.16.y.

### Step 6.3: No prior fix exists for this issue in stable.

---

## PHASE 7: SUBSYSTEM CONTEXT

### Step 7.1: Subsystem
- **Subsystem**: net/hsr (HSR/PRP networking protocol)
- **Criticality**: IMPORTANT — industrial Ethernet redundancy protocol
  used in factory automation and critical infrastructure

### Step 7.2: Activity
The HSR subsystem has seen steady development (20+ commits since
b65999e7238e6), indicating active maintenance.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: Who is Affected
PRP (Parallel Redundancy Protocol) users — industrial networking
deployments that rely on PRP for redundancy. Not a huge user base, but
the users who need this need it to work correctly.

### Step 8.2: Trigger Conditions
The bug is triggered every time a PRP interface is deleted. This is a
common administrative operation.

### Step 8.3: Failure Mode Severity
- Userspace doesn't receive NETDEV_CHANGEADDR notification, meaning
  network management tools have stale MAC information after PRP teardown
  — **MEDIUM** severity
- Unnecessary MAC restoration on HSR/PRP slave_A — **LOW** (no-op in
  practice since the MAC matches)

### Step 8.4: Risk-Benefit Ratio
- **Benefit**: Fixes missing notification for PRP users, makes teardown
  path consistent with creation
- **Risk**: Very low — 4 lines, single function, restricts behavior to
  where it's needed
- **Ratio**: Favorable

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence Summary
**FOR backporting:**
- Fixes a real bug introduced by `b65999e7238e6` (missing
  NETDEV_CHANGEADDR notification)
- Has Fixes: tag in original patch
- Reported by a user (Luka Gejak)
- Reviewed by Felix Maurer (Red Hat)
- Applied by Paolo Abeni (networking maintainer)
- Small, surgical fix (4 net lines, single file, single function)
- Consistent with the creation path behavior
- Standalone — no dependencies beyond the already-present buggy commit

**AGAINST backporting:**
- MEDIUM severity (missing notification, not a crash or security issue)
- Affects a niche subsystem (PRP)

### Step 9.2: Stable Rules Checklist
1. Obviously correct? **YES** — makes deletion symmetric with creation
2. Fixes a real bug? **YES** — missing notification reported by a user
3. Important issue? **YES** — incorrect behavior visible to userspace
4. Small and contained? **YES** — 4 lines, single function
5. No new features or APIs? **YES** — no new features
6. Can apply to stable trees? **YES** — code unchanged since v6.16

### Step 9.3: Exception Categories
Not applicable — this is a standard bug fix, not a hardware quirk or
device ID.

### Step 9.4: Decision
The fix is small, obviously correct, fixes a real user-reported bug
(missing NETDEV_CHANGEADDR notification during PRP port deletion), has a
Fixes: tag, is reviewed, and applies cleanly to affected stable trees.

---

## Verification

- [Phase 1] Parsed tags: Reported-by from Luka Gejak, Closes link to
  lore, Reviewed-by Felix Maurer, Link to patch.msgid.link, applied by
  Paolo Abeni
- [Phase 2] Diff analysis: +5/-1 lines in `hsr_del_port()` in
  `net/hsr/hsr_slave.c`, adds PRP_V1+SLAVE_B condition and
  `call_netdevice_notifiers()` call
- [Phase 3] git blame: buggy line introduced by `b65999e7238e6`
  (2025-04-09), first in v6.16
- [Phase 3] git show b65999e7238e6: confirmed original commit adds MAC
  sync for PRP but misses notification in deletion path
- [Phase 3] git tag --contains: b65999e7238e6 is in v6.16, v6.17, v6.18,
  v6.19, v7.0
- [Phase 3] git diff v6.16: `hsr_del_port()` unchanged between v6.16 and
  v7.0, patch applies cleanly
- [Phase 4] b4 dig -c b65999e7238e6: found original submission at
  https://patch.msgid.link/20250409101911.3120-1-ffmancera@riseup.net
- [Phase 4] b4 dig -a: v1 and v3 revisions found for original commit
- [Phase 4] Read /tmp/hsr_thread.mbox: Luka Gejak's review explicitly
  identified the missing notification bug
- [Phase 4] b4 am: fix is standalone (Total patches: 1), Reviewed-by and
  DKIM verified
- [Phase 4] Original mbox contains Fixes: b65999e7238e tag
- [Phase 5] Creation path in hsr_device.c:798-800 does call
  `call_netdevice_notifiers()` — deletion should too
- [Phase 5] Notification path in hsr_main.c:82-88 also calls
  `call_netdevice_notifiers()` — consistent pattern
- [Phase 6] Bug exists in v6.16+ stable trees, patch applies cleanly to
  v6.16
- [Phase 8] Failure mode: missing userspace notification on PRP port
  deletion, severity MEDIUM

**YES**

 net/hsr/hsr_slave.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/net/hsr/hsr_slave.c b/net/hsr/hsr_slave.c
index 44f83c8c56a79..d9af9e65f72f0 100644
--- a/net/hsr/hsr_slave.c
+++ b/net/hsr/hsr_slave.c
@@ -243,7 +243,11 @@ void hsr_del_port(struct hsr_port *port)
 		if (!port->hsr->fwd_offloaded)
 			dev_set_promiscuity(port->dev, -1);
 		netdev_upper_dev_unlink(port->dev, master->dev);
-		eth_hw_addr_set(port->dev, port->original_macaddress);
+		if (hsr->prot_version == PRP_V1 &&
+		    port->type == HSR_PT_SLAVE_B) {
+			eth_hw_addr_set(port->dev, port->original_macaddress);
+			call_netdevice_notifiers(NETDEV_CHANGEADDR, port->dev);
+		}
 	}
 
 	kfree_rcu(port, rcu);
-- 
2.53.0

