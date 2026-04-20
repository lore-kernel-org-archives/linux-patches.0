Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63C0B3A6F1E;
	Mon, 20 Apr 2026 13:29:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776691769; cv=none; b=dmeU6mxBsSLIHhfzGyBjVJgSUf+DFGqUmLT8h//cfeU8uYQWMYNGHrSCy2D9DGxC3SrYuBJ4NUVrJ9RKzB4wC4dri3RUxi4u8umBuQsTwuqEQEPMIWFS+7FeENcaSShHedELETzwJ2sgD1OpPQgBCY6C2tc/72QWiIgs22bLugY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776691769; c=relaxed/simple;
	bh=tHZti5mAqn4TNxo9fZndn3N+v+E4Uj4c1I4MpcySLe8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Wy80fMp0thONyOeNn1xEPOfqG2yw8I2CKiI+lvbwVA8FnmuB+QOE1tmV6q4fJzTPbS+Rhf/RjdZ6vvD3T2/a5vwsaeXPzZ7wu5wMkf03fg2hQQheKJ/EUF06qG0oNp8I4Hq09u0lnFGw5Fk4wQf4hGtA8JzU0FD1emWhW/0T4ug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=R8opCKp+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="R8opCKp+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB887C2BCC4;
	Mon, 20 Apr 2026 13:29:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776691769;
	bh=tHZti5mAqn4TNxo9fZndn3N+v+E4Uj4c1I4MpcySLe8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R8opCKp+29pe7DTDWFIDkxZnlyTuMRGHSN4A7VCjVYD3FUZ+h1HdXqTyQ5YFbaxUk
	 laF3YSBi5SFUarTnIIpRfOvfk25QtqQ46zZYAYBsxiqeFOq+qneETPqvyLBZCxtunj
	 va5zTYLq5t5/fHutLzk1oFD3eHszYAJFYef9K1qljIHkZWZRObNo8I0FlWlhX/Q7db
	 pgBG6AdlFqHobNXtZPJRtBXU/eDWFao/qkXiDxbhvvmqHhUOed6HtOHUDRwzLQEuya
	 mRRGLdXdLPnaWfuz7m5HM1/ML1HI3o/6udpj7X/QpuEZJg9oh6wWC7qzCkv3lsPHvM
	 Ls5rgv/a6ma1Q==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Ankit Garg <nktgrg@google.com>,
	Willem de Bruijn <willemb@google.com>,
	Harshitha Ramamurthy <hramamurthy@google.com>,
	Joshua Washington <joshwash@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>,
	andrew+netdev@lunn.ch,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0-6.19] gve: Advertise NETIF_F_GRO_HW instead of NETIF_F_LRO
Date: Mon, 20 Apr 2026 09:19:36 -0400
Message-ID: <20260420132314.1023554-182-sashal@kernel.org>
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

From: Ankit Garg <nktgrg@google.com>

[ Upstream commit e637c244b954426b84340cbc551ca0e2a32058ce ]

The device behind DQO format has always coalesced packets per stricter
hardware GRO spec even though it was being advertised as LRO.

Update advertised capability to match device behavior.

Signed-off-by: Ankit Garg <nktgrg@google.com>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Reviewed-by: Harshitha Ramamurthy <hramamurthy@google.com>
Signed-off-by: Joshua Washington <joshwash@google.com>
Link: https://patch.msgid.link/20260303195549.2679070-2-joshwash@google.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I have all the information needed for a complete analysis. Let me
compile my findings.

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Subject Line
- **Subsystem:** `gve` (Google Virtual Ethernet driver -
  `drivers/net/ethernet/google/gve/`)
- **Action verb:** "Advertise" (correcting what capability is reported)
- **Summary:** Changes the driver to advertise `NETIF_F_GRO_HW` instead
  of `NETIF_F_LRO` since the DQO hardware actually does GRO-compliant
  coalescing.
- Record: [gve] [Advertise (correct)] [Fix incorrect feature flag: LRO →
  GRO_HW for DQO]

### Step 1.2: Tags
- **Signed-off-by:** Ankit Garg (author), Joshua Washington
  (committer/submitter), Paolo Abeni (netdev maintainer)
- **Reviewed-by:** Willem de Bruijn, Harshitha Ramamurthy (Google gve
  developers)
- **Link:** `https://patch.msgid.link/20260303195549.2679070-2-
  joshwash@google.com` (patch 2 of a series)
- No Fixes: tag (expected for autosel candidates)
- No Reported-by: tag
- No Cc: stable tag
- Record: Reviewed by two GVE developers. Applied by netdev maintainer
  Paolo Abeni. Part of a series (patch 2).

### Step 1.3: Commit Body Analysis
- The commit states: "The device behind DQO format has always coalesced
  packets per stricter hardware GRO spec even though it was being
  advertised as LRO."
- The fix corrects the advertised capability to match actual device
  behavior.
- Bug: NETIF_F_LRO is incorrectly advertised when the hardware does GRO.
- Symptom: The kernel treats the feature as LRO and disables it
  unnecessarily in forwarding/bridging scenarios.
- Record: Bug = incorrect feature flag. Symptom = unnecessary disabling
  of hardware offload in forwarding/bridging.

### Step 1.4: Hidden Bug Fix Detection
YES - this IS a hidden bug fix. While described as "Update advertised
capability," the practical consequence of the incorrect flag is that:
1. When IP forwarding is enabled, `dev_disable_lro()` disables the
   hardware coalescing unnecessarily.
2. When the device is bridged, the same happens.
3. When used under upper devices, `NETIF_F_UPPER_DISABLES` (which
   includes `NETIF_F_LRO` but NOT `NETIF_F_GRO_HW`) forces it off.

This is exactly the same bug class fixed in virtio-net (commit
`dbcf24d153884`) which carried a `Fixes:` tag.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory
- **Files:** `gve_adminq.c` (+2/-2 effective), `gve_main.c` (+6/-5
  effective)
- **Functions modified:**
  - `gve_adminq_get_create_rx_queue_cmd()` - 1 line change
  - `gve_adminq_describe_device()` - 2 line change (comment + feature
    flag)
  - `gve_verify_xdp_configuration()` - 2 line change (check + error
    message)
  - `gve_set_features()` - 5 line changes
- **Scope:** Single-driver surgical fix, ~10 meaningful line changes
- Record: 2 files, 4 functions, single-driver scope, very small.

### Step 2.2: Code Flow Changes
1. **`gve_adminq_get_create_rx_queue_cmd`:** `enable_rsc` now checks
   `NETIF_F_GRO_HW` instead of `NETIF_F_LRO` — correct, since the
   hardware feature maps to GRO.
2. **`gve_adminq_describe_device`:** Advertises `NETIF_F_GRO_HW` in
   `hw_features` instead of `NETIF_F_LRO` for DQO queue format.
3. **`gve_verify_xdp_configuration`:** Checks `NETIF_F_GRO_HW` and
   updates error message.
4. **`gve_set_features`:** Handles `NETIF_F_GRO_HW` toggle instead of
   `NETIF_F_LRO`.

### Step 2.3: Bug Mechanism
**Category:** Logic/correctness fix — incorrect feature flag used
throughout driver.

The kernel networking stack treats LRO and GRO_HW differently:
- `NETIF_F_LRO` is in `NETIF_F_UPPER_DISABLES` — forcibly disabled when
  forwarding/bridging
- `NETIF_F_GRO_HW` is NOT in `NETIF_F_UPPER_DISABLES` — stays enabled
  (safe for forwarding)
- `dev_disable_lro()` is called by bridge (`br_if.c`), IP forwarding
  (`devinet.c`), IPv6, OVS, HSR
- This incorrectly disables GVE DQO's hardware packet coalescing in
  those scenarios

### Step 2.4: Fix Quality
- The fix is obviously correct: pure 1:1 substitution of `NETIF_F_LRO` →
  `NETIF_F_GRO_HW`
- Minimal and surgical
- Very low regression risk — the hardware behavior doesn't change; only
  the correct flag is used
- Identical pattern to the well-accepted virtio-net fix
- Record: High quality, low regression risk.

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame
- The `NETIF_F_LRO` usage was introduced by:
  - `5e8c5adf95f8a5` (Bailey Forrest, 2021-06-24) "gve: DQO: Add core
    netdev features" — the `hw_features` and `set_features` usage
  - `1f6228e459f8bc` (Bailey Forrest, 2021-06-24) "gve: Update adminq
    commands to support DQO queues" — the `enable_rsc` usage
- These are in v5.14+, meaning the bug exists in stable trees 5.15.y,
  6.1.y, 6.6.y, 6.12.y, 6.19.y.
- Record: Buggy code present since v5.14 (2021). Affects all active
  stable trees.

### Step 3.2: Fixes Tag
No Fixes: tag present (expected).

### Step 3.3: File History
Recent GVE file changes are mostly unrelated (stats, buffer sizes, XDP,
ethtool). No conflicting changes affecting the LRO/GRO_HW flag.
- Record: Standalone fix, no prerequisites identified.

### Step 3.4: Author
Ankit Garg is a regular GVE contributor (8+ commits in the driver).
Joshua Washington is the primary GVE maintainer/submitter. Both are
Google engineers working on the driver.
- Record: Fix from driver maintainers — high confidence.

### Step 3.5: Dependencies
The change is a pure flag substitution. `NETIF_F_GRO_HW` has existed
since commit `fb1f5f79ae963` (kernel v4.16). No dependencies on other
patches.
- Record: Self-contained. NETIF_F_GRO_HW exists in all active stable
  trees.

---

## PHASE 4: MAILING LIST RESEARCH

### Step 4.1-4.5:
b4 dig could not find the commit (not yet in the tree being analyzed).
Lore.kernel.org was inaccessible due to bot protection. However, the
virtio-net precedent (`dbcf24d153884`) provides strong context — that
commit was:
- Tagged with `Fixes:`
- Had `Reported-by:` and `Tested-by:` from a user who hit the issue
- Described the exact same symptoms: unnecessary feature disabling in
  bridging/forwarding
- Record: Could not access lore directly. Virtio-net precedent strongly
  supports this as a bug fix.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1-5.4: Impact Surface
The key behavioral difference stems from the kernel networking core:
- `netif_disable_lro()` (`net/core/dev.c:1823`) clears `NETIF_F_LRO`
  from `wanted_features`
- Called from: `net/bridge/br_if.c` (bridging), `net/ipv4/devinet.c`
  (forwarding), `net/ipv6/addrconf.c`, `net/openvswitch/vport-netdev.c`,
  `net/hsr/hsr_slave.c`
- `NETIF_F_UPPER_DISABLES` includes `NETIF_F_LRO` but NOT
  `NETIF_F_GRO_HW`
- Result: Any GVE DQO device used in bridging, forwarding, OVS, or HSR
  has its hardware receive coalescing incorrectly disabled.

### Step 5.5: Similar Patterns
The exact same fix was applied to: virtio-net (`dbcf24d153884`), bnxt_en
(`1054aee823214`), bnx2x (`3c3def5fc667f`), qede (`18c602dee4726`). All
converted from LRO to GRO_HW.
- Record: Well-established fix pattern across multiple drivers.

---

## PHASE 6: STABLE TREE ANALYSIS

### Step 6.1: Code Existence
The buggy `NETIF_F_LRO` code was introduced in v5.14 and exists in all
active stable trees (5.15.y through 6.19.y).
`NETIF_F_GRO_HW` was introduced in v4.16 and exists in all active stable
trees.

### Step 6.2: Backport Complications
The diff is a straightforward flag substitution. Should apply cleanly to
most stable trees. Some context lines may differ (e.g., newer features
added around the changed lines), but the core changes are against code
that has been stable since 2021.
- Record: Expected clean apply or minor fuzz for older trees.

### Step 6.3: Related Fixes in Stable
No GVE LRO→GRO_HW fix exists in stable.

---

## PHASE 7: SUBSYSTEM CONTEXT

### Step 7.1: Subsystem
- **Subsystem:** Network device driver
  (drivers/net/ethernet/google/gve/)
- **Criticality:** IMPORTANT — GVE is the virtual NIC for Google Cloud
  VMs, used by a very large number of cloud workloads.
- Record: Network driver, IMPORTANT criticality.

### Step 7.2: Activity
220+ commits to GVE since v5.15. Very actively developed.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: Who Is Affected
All Google Cloud VM users running GVE DQO format with bridging, IP
forwarding, OVS, or HSR configurations.
- Record: GVE-driver-specific, but large user base in cloud.

### Step 8.2: Trigger Conditions
- Triggered whenever IP forwarding is enabled OR device is bridged
- Very common in cloud deployments (VPN gateways, container networking,
  virtual routing)
- Not a crash, but an unnecessary performance degradation
- Record: Common trigger in cloud/container/forwarding scenarios.

### Step 8.3: Failure Mode
- **Severity: MEDIUM** — performance degradation (hardware receive
  offload unnecessarily disabled), not a crash or data corruption
- No kernel panic, no data loss, no security issue
- The hardware coalescing is silently disabled, reducing network
  throughput
- Record: Performance degradation. Severity MEDIUM.

### Step 8.4: Risk-Benefit
- **Benefit:** MEDIUM — fixes unnecessary performance degradation for
  forwarding/bridging GVE users
- **Risk:** VERY LOW — pure flag substitution, no logic changes, same
  pattern as 4+ other drivers
- **Ratio:** Favorable, but not critical
- Record: Low risk, medium benefit.

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence Summary

**FOR backporting:**
- Fixes a real, long-standing bug (incorrect feature flag since v5.14)
- Very small, surgical, obviously correct change
- Identical fix pattern successfully applied to 4+ other drivers
  (virtio-net had Fixes: tag)
- Fix from driver maintainers, reviewed by two developers, applied by
  netdev maintainer
- Zero regression risk — hardware behavior unchanged, only correct flag
  used
- Affects significant user base (Google Cloud)
- Self-contained, no dependencies, should apply cleanly

**AGAINST backporting:**
- Not fixing a crash, security issue, or data corruption
- Impact is performance degradation, not a hard failure
- Only affects specific configurations (bridging/forwarding)
- No Reported-by, suggesting no one explicitly complained about this
- Commit message frames it as correctness improvement, not urgent fix
- Part of a series (patch 2), though appears self-contained

### Step 9.2: Stable Rules Checklist
1. Obviously correct and tested? **YES** — pure flag substitution,
   reviewed by 2, well-established pattern
2. Fixes a real bug? **YES** — incorrect feature advertisement causes
   wrong kernel behavior
3. Important issue? **BORDERLINE** — not crash/security, but real
   performance impact in common configs
4. Small and contained? **YES** — ~10 lines in 2 files, single driver
5. No new features or APIs? **YES** — corrects existing feature flag
6. Can apply to stable? **YES** — clean change, NETIF_F_GRO_HW exists in
   all stable trees

### Step 9.3: Exception Categories
Does not fall into automatic exception categories.

### Step 9.4: Decision
This is borderline. It IS a correctness bug fix (same class as the
Fixes:-tagged virtio-net commit), and it IS small and obviously correct.
However, the impact is performance degradation rather than
crash/corruption/security. For cloud users running GVE with
forwarding/bridging (a common scenario), this is a meaningful fix. The
risk is essentially zero.

Given the low risk and the fact that this fixes demonstrably incorrect
kernel behavior (unnecessarily disabling hardware offload), and that the
identical pattern was treated as a bug fix for virtio-net with a Fixes:
tag, this leans YES.

---

## Verification

- [Phase 1] Parsed tags: Reviewed-by from two GVE developers, SOB from
  netdev maintainer, Link to patch msgid
- [Phase 2] Diff analysis: ~10 lines changed across 2 files, pure
  NETIF_F_LRO → NETIF_F_GRO_HW substitution in 4 functions
- [Phase 3] git blame: buggy code introduced in commits 5e8c5adf95f8a5
  and 1f6228e459f8bc (v5.14, 2021-06-24), present in all stable trees
- [Phase 3] git merge-base: confirmed buggy code is in v5.14 and v5.15
  trees
- [Phase 3] git log --author: Ankit Garg is a regular GVE contributor
  (8+ commits)
- [Phase 4] b4 dig: could not find the commit directly (not yet in this
  tree)
- [Phase 4] lore: inaccessible due to bot protection
- [Phase 5] Verified NETIF_F_UPPER_DISABLES includes NETIF_F_LRO but not
  NETIF_F_GRO_HW (netdev_features.h:236)
- [Phase 5] Verified dev_disable_lro() called from br_if.c, devinet.c,
  addrconf.c, OVS, HSR
- [Phase 5] Confirmed netif_disable_lro() only clears NETIF_F_LRO,
  dev_disable_gro_hw() separately handles NETIF_F_GRO_HW
- [Phase 5] Verified identical fix pattern in virtio-net
  (dbcf24d153884), bnxt_en, bnx2x, qede
- [Phase 6] NETIF_F_GRO_HW introduced in v4.16 (fb1f5f79ae963), exists
  in all stable trees
- [Phase 6] Confirmed the change is self-contained with no dependencies
- [Phase 8] Failure mode: performance degradation (hardware offload
  unnecessarily disabled), severity MEDIUM
- UNVERIFIED: Whether anyone reported this as a problem (no Reported-by
  tag, could not access lore)
- UNVERIFIED: Whether other patches in the series are needed (msgid
  suggests patch 2, but change appears standalone)

**YES**

 drivers/net/ethernet/google/gve/gve_adminq.c |  6 +++---
 drivers/net/ethernet/google/gve/gve_main.c   | 15 ++++++++-------
 2 files changed, 11 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/google/gve/gve_adminq.c b/drivers/net/ethernet/google/gve/gve_adminq.c
index b72cc0fa2ba2b..873672f680e3a 100644
--- a/drivers/net/ethernet/google/gve/gve_adminq.c
+++ b/drivers/net/ethernet/google/gve/gve_adminq.c
@@ -791,7 +791,7 @@ static void gve_adminq_get_create_rx_queue_cmd(struct gve_priv *priv,
 		cmd->create_rx_queue.rx_buff_ring_size =
 			cpu_to_be16(priv->rx_desc_cnt);
 		cmd->create_rx_queue.enable_rsc =
-			!!(priv->dev->features & NETIF_F_LRO);
+			!!(priv->dev->features & NETIF_F_GRO_HW);
 		if (priv->header_split_enabled)
 			cmd->create_rx_queue.header_buffer_size =
 				cpu_to_be16(priv->header_buf_size);
@@ -1127,9 +1127,9 @@ int gve_adminq_describe_device(struct gve_priv *priv)
 
 	gve_set_default_rss_sizes(priv);
 
-	/* DQO supports LRO. */
+	/* DQO supports HW-GRO. */
 	if (!gve_is_gqi(priv))
-		priv->dev->hw_features |= NETIF_F_LRO;
+		priv->dev->hw_features |= NETIF_F_GRO_HW;
 
 	priv->max_registered_pages =
 				be64_to_cpu(descriptor->max_registered_pages);
diff --git a/drivers/net/ethernet/google/gve/gve_main.c b/drivers/net/ethernet/google/gve/gve_main.c
index 9eb4b3614c4f5..9cae4fc88a2ff 100644
--- a/drivers/net/ethernet/google/gve/gve_main.c
+++ b/drivers/net/ethernet/google/gve/gve_main.c
@@ -1717,9 +1717,9 @@ static int gve_verify_xdp_configuration(struct net_device *dev,
 	struct gve_priv *priv = netdev_priv(dev);
 	u16 max_xdp_mtu;
 
-	if (dev->features & NETIF_F_LRO) {
+	if (dev->features & NETIF_F_GRO_HW) {
 		NL_SET_ERR_MSG_MOD(extack,
-				   "XDP is not supported when LRO is on.");
+				   "XDP is not supported when HW-GRO is on.");
 		return -EOPNOTSUPP;
 	}
 
@@ -2136,12 +2136,13 @@ static int gve_set_features(struct net_device *netdev,
 
 	gve_get_curr_alloc_cfgs(priv, &tx_alloc_cfg, &rx_alloc_cfg);
 
-	if ((netdev->features & NETIF_F_LRO) != (features & NETIF_F_LRO)) {
-		netdev->features ^= NETIF_F_LRO;
-		if (priv->xdp_prog && (netdev->features & NETIF_F_LRO)) {
+	if ((netdev->features & NETIF_F_GRO_HW) !=
+	    (features & NETIF_F_GRO_HW)) {
+		netdev->features ^= NETIF_F_GRO_HW;
+		if (priv->xdp_prog && (netdev->features & NETIF_F_GRO_HW)) {
 			netdev_warn(netdev,
-				    "XDP is not supported when LRO is on.\n");
-			err =  -EOPNOTSUPP;
+				    "HW-GRO is not supported when XDP is on.");
+			err = -EOPNOTSUPP;
 			goto revert_features;
 		}
 		if (netif_running(netdev)) {
-- 
2.53.0

