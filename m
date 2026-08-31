Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E9EB51B69E;
	Mon, 31 Aug 2026 13:43:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183822; cv=none; b=WlSkQFsjGTptWfE74IftYl7X9p92F/GAXHWPVA0sknGwBwR+cXYRisaELeEjzjYmYkz2/Gd0XHBq3hYBCb0M3ZWbMkg8j2Z7kiZ3UnISnpQa+2csCAMPoAsqfvdM8h5VBp0M7jYOjxBP6c/Y9p5kbUbQV1mkd1j+4qsk2KcCF18=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183822; c=relaxed/simple;
	bh=AK5eEeUqSYLZGKXY59wrC7so5WGOE+BQ4ONDzCjij/0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ADyqSGxJPYui8QpJHS3JSc0Tp5/g+BMCuwUWV0+9SP7bQoLrvvFfDQADkflusqVVdf5clC7bwMXTy861V8ZLqlhAeY3KiYMF3lHmQEmbkyLbsZoXv3ya/C2xwinGhr6NtGN3fiZMzxSC783q9wLEgbyrOwqz+2YdOpCYndcDyAc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iUxDeY8B; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iUxDeY8B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73E631F00A3E;
	Mon, 31 Aug 2026 13:43:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183819;
	bh=7LJkG+kpjZ9ez0s1sDn0OcuhmsrHl/cKaBP3A3vLls4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iUxDeY8B7f0QE71fZ4VUF81k5TKl46PmGrMJ/gPUyNedLaLxMsc+lIdWfU0UtYN/u
	 ckkeJOpa05mTNbOuQmq2HIgrCgQKTeeaGrycsPBRjvFyDKlH4Lo7uk29CY4ox7u0OR
	 jLtcVoR8+ok1I6dXfR+DSTqggSgIcI/gGKDG2q+NYAs9Lq5r7pdM7afl1/D0E3d9Ot
	 VjoyFU7PBUF9rAnHrcoxBN1PGBI6gqvZTmGsSr3B2ql3cwqX0FTXzQy5ECBPlvV5ai
	 wJSNqVYvGOoVBiTRzVG92S4u8i704c3kd8hAse+rl2hnlIGzBVBeOC2m75r1l5J1SA
	 hOeLPYRgf5CBA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: David Yang <mmyangfl@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	vladimir.oltean@nxp.com,
	UNGLinuxDriver@microchip.com,
	andrew@lunn.ch,
	davem@davemloft.net,
	edumazet@google.com,
	pabeni@redhat.com,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] net: mscc: ocelot: validate netdev belongs to switch in .netdev_to_port()
Date: Mon, 31 Aug 2026 09:25:52 -0400
Message-ID: <20260831133314.4125787-324-sashal@kernel.org>
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

From: David Yang <mmyangfl@gmail.com>

[ Upstream commit ea07514700f7a5125db67c9d1cbfb06e65c30a07 ]

The .netdev_to_port() currently takes only a net_device and returns the
port index, without verifying the netdev actually belongs to the switch
being operated on. This can cause flower rule parsing to silently
resolve to a wrong port on the local hardware.

Update both implementations felix_netdev_to_port() and
ocelot_netdev_to_port() to validate ownership. Also update the callers
in ocelot_flower.c to pass through the ocelot context.

Signed-off-by: David Yang <mmyangfl@gmail.com>
Link: https://patch.msgid.link/20260606125247.305167-1-mmyangfl@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit Message Forensics

**Step 1.1 — Subject line**

Record: `[net: mscc: ocelot] [validate] validate netdev belongs to
switch in .netdev_to_port()`

**Step 1.2 — Tags**

Record:
- **Signed-off-by:** David Yang `<mmyangfl@gmail.com>` (author)
- **Link:**
  https://patch.msgid.link/20260606125247.305167-1-mmyangfl@gmail.com
- **Signed-off-by:** Jakub Kicinski `<kuba@kernel.org>` (committer)
- No Fixes:, Reported-by:, Tested-by:, Reviewed-by:, Acked-by:, or Cc:
  stable@vger.kernel.org
- Notable: no syzbot/reporter tags; no explicit stable nomination

**Step 1.3 — Body analysis**

Record:
- **Bug:** `.netdev_to_port()` maps a `net_device` to a port index
  without checking that netdev belongs to the `ocelot` switch instance
  being configured.
- **Symptom:** tc-flower rule parsing can **silently** resolve to the
  wrong port on the local switch hardware.
- **Root cause:** Both `felix_netdev_to_port()` (DSA) and
  `ocelot_netdev_to_port()` (standalone) accept any netdev of the
  correct driver type, regardless of which switch instance owns it.
- **Fix approach:** Pass `struct ocelot *` into both implementations and
  validate ownership (`dp->ds != ds` for Felix; `priv->port.ocelot !=
  ocelot` for standalone ocelot); update `ocelot_ops` callback and
  `ocelot_flower.c` callers.

**Step 1.4 — Hidden bug fix?**

Record: **Yes.** Despite “validate” wording rather than “fix”, this is a
real logic/correctness bug in hardware offload parsing, not cosmetic
cleanup.

---

## Phase 2: Diff Analysis

**Step 2.1 — Inventory**

Record:
- **Files:** 6 files, +12 / −8 lines
- **Functions modified:** `felix_netdev_to_port()`,
  `ocelot_netdev_to_port()`, `ocelot_flower_parse_egress_port()`,
  `ocelot_flower_parse_indev()`
- **Headers:** `ocelot_ops.netdev_to_port` signature changed
- **Scope:** Single-subsystem, surgical fix

**Step 2.2 — Code flow per hunk**

Record:
- **`felix_netdev_to_port()`:** Before: any DSA user port netdev → port
  index. After: rejects netdevs belonging to a different `dsa_switch`
  (`dp->ds != ds`).
- **`ocelot_netdev_to_port()`:** Before: any netdev with
  `ocelot_port_netdev_ops` → port index. After: also requires
  `priv->port.ocelot == ocelot`.
- **`ocelot_flower_parse_egress_port()`:** Before:
  `netdev_to_port(a->dev)`. After: `netdev_to_port(ocelot, a->dev)` so
  validation is switch-scoped.
- **`ocelot_flower_parse_indev()`:** Same change for ingress-ifindex
  matching.

**Step 2.3 — Bug mechanism**

Record: **Logic / correctness fix** in tc-flower hardware offload path.
On systems with multiple Ocelot/Felix switches, a rule installed on
switch A referencing a netdev from switch B could return switch B’s port
index and program switch A’s VCAP hardware with that index — wrong
redirect, mirror, or ingress-port match.

**Step 2.4 — Fix quality**

Record: Fix is obviously correct and minimal. Regression risk is very
low: single-switch systems always pass the new checks. The internal
`ocelot_ops` signature change is fully contained within this patch (all
implementations and callers updated). No deadlock or hot-path
performance concern.

---

## Phase 3: Git History Investigation

**Step 3.1 — Blame**

Record: `ocelot_netdev_to_port()` introduced in `319e4dd11a207`
(2020-10-02, “introduce conversion helpers between port and netdev”).
The missing ownership check has been present since introduction.
`priv->port.ocelot` field exists in `struct ocelot_port` since the port
structure was defined.

**Step 3.2 — Fixes: tag**

Record: Not applicable — no Fixes: tag in commit message.

**Step 3.3 — Related file history**

Record: `ocelot_flower.c` has active tc-flower development (mirred-to-
foreign-interfaces in `49a09073cb23e`, control-flag validation, etc.).
This fix is standalone — not part of a multi-patch series.

**Step 3.4 — Author context**

Record: David Yang; subsystem maintainers (Vladimir Oltean, Andrew Lunn,
netdev maintainers) were CC’d on submission per `b4 dig -w`. No other
commits from this author in the mscc/ocelot paths in this tree.

**Step 3.5 — Dependencies**

Record: No prerequisites. Commit is self-contained. `git show
ea07514700f7a | git apply --check` succeeds on this tree.

---

## Phase 4: Mailing List and External Research

**Step 4.1 — Original discussion**

Record:
- **URL:**
  https://patch.msgid.link/20260606125247.305167-1-mmyangfl@gmail.com
- **Series:** v2 only (v1 referenced at
  https://lore.kernel.org/r/20260603024234.66603-1-mmyangfl@gmail.com)
- **Review feedback:** Thread contains only the patch and patchwork-bot
  “applied to net-next” notice — no human review replies, no stable
  nominations, no NAKs in saved mbox

**Step 4.2 — Reviewers**

Record: CC list includes Vladimir Oltean (NXP ocelot maintainer), Andrew
Lunn, Jakub Kicinski, netdev list. No Reviewed-by/Acked-by in final
commit.

**Step 4.3 — Bug reports**

Record: No external bug report, syzbot link, orbugzilla reference. Bug
identified by code inspection.

**Step 4.4 — Related patches**

Record: v1 also fixed `ocelot_netdev_to_port()`; v2 is the committed
version. Standalone one-patch fix.

**Step 4.5 — Stable list**

Record: Not searched on lore stable list (no indicators in thread). No
prior stable discussion found.

---

## Phase 5: Code Semantic Analysis

**Step 5.1 — Key functions**

Record: `felix_netdev_to_port()`, `ocelot_netdev_to_port()`,
`ocelot_flower_parse_egress_port()`, `ocelot_flower_parse_indev()`,
`ocelot_cls_flower_replace()` (caller chain entry)

**Step 5.2 — Callers**

Record:
- `netdev_to_port` is only invoked via `ocelot->ops->netdev_to_port()`
  from `ocelot_flower.c` (2 call sites).
- Flower offload reached from userspace via `ndo_setup_tc` →
  `ocelot_setup_tc_cls_flower()` → `ocelot_cls_flower_replace()`
  (`ocelot_net.c:197-209`) and Felix DSA `felix_port_setup_tc()` →
  `ocelot_cls_flower_replace()` (`felix.c:1961`).
- Requires `CAP_NET_ADMIN` for tc rule installation.

**Step 5.3 — Callees**

Record: `dsa_port_from_netdev()`, `ocelot_netdevice_dev_check()`,
`netdev_priv()`, port-index extraction.

**Step 5.4 — Reachability**

Record: Userspace `tc filter add` / netlink FLOW_CLS_REPLACE on an
ocelot/Felix port netdev → flower parse → `netdev_to_port()`. Reachable
on any system with MSCC ocelot or Felix DSA hardware and tc-flower
offload enabled.

**Step 5.5 — Similar patterns**

Record: `port_to_netdev()` already takes `struct ocelot *` and is
switch-scoped; `netdev_to_port()` was the asymmetric missing half.
`ocelot_netdevice_dev_check()` only validates driver type (same
`netdev_ops` for all instances), which is why cross-instance netdevs
were accepted.

---

## Phase 6: Cross-Referencing Against Local Tree

**Step 6.1 — Buggy code present?**

Record: **Yes.** Local tree is **Linux 6.18.44** (`git describe HEAD` →
`v6.18.44`). Commit `ea07514700f7a` is **not** in this tree (`git merge-
base --is-ancestor` returns false). Buggy code confirmed at
`ocelot_net.c:987-996`, `felix.c:2382-2390`, `ocelot_flower.c:237,583`.

**Step 6.2 — Backport complications**

Record: **Clean apply expected** — verified with `git apply --check`. No
conflicting refactors in these functions between this tree and mainline
patch.

**Step 6.3 — Related fixes already present?**

Record: No equivalent ownership validation found in this tree.

---

## Phase 7: Subsystem and Maintainer Context

**Step 7.1 — Subsystem criticality**

Record: **IMPORTANT** — MSCC Ocelot / NXP Felix DSA Ethernet switch
drivers. Not core kernel, but hardware datapath offload for managed
switches used in embedded/industrial/TSN (NXP Layerscape boards,
Microchip switches).

**Step 7.2 — Subsystem activity**

Record: Actively maintained in 6.18.y (recent commits: lock protection
in xmit, FDMA paths, timestamping, mirred support).

---

## Phase 8: Impact and Risk Assessment

**Step 8.1 — Who is affected**

Record: **Driver-specific, config-specific** — users of MSCC ocelot or
Felix DSA hardware with **multiple switch instances** on one system who
install **tc-flower hardware offload rules** referencing netdevs
(redirect, mirror, or `ingress_ifindex` match).

**Step 8.2 — Trigger conditions**

Record:
- Install tc-flower rule on switch A’s port
- Rule references a netdev belonging to switch B (another ocelot/Felix
  instance)
- Common in multi-switch automotive/industrial boards; uncommon on
  generic servers
- Requires root/CAP_NET_ADMIN; not unprivileged trigger

**Step 8.3 — Failure mode severity**

Record:
- **Failure mode:** Silent misprogramming of VCAP hardware filters —
  traffic redirected/mirrored to wrong port, or ingress matching on
  wrong port index
- **Severity: MEDIUM-HIGH** for affected deployments (wrong datapath
  behavior, broken network policy/isolation), but **not CRITICAL** (no
  kernel oops, hang, or memory corruption)

**Step 8.4 — Risk-benefit**

Record:
- **Benefit:** Prevents insidious silent hardware offload errors on
  multi-switch systems; bug present since 2020
- **Risk:** Very low — ~20 lines, no behavior change for correct single-
  switch configurations
- **Ratio:** Good benefit/risk for affected users; limited benefit for
  typical single-switch deployments

---

## Phase 9: Final Synthesis

**Step 9.1 — Evidence compile**

**FOR backport:**
- Real, verifiable logic bug in hardware offload path
- Silent wrong port programming — “oh, that’s not good” per stable-
  kernel-rules.rst
- Bug present since 2020 in this 6.18.44 tree
- Small (20 lines), obviously correct, applies cleanly
- Zero regression risk on single-switch systems
- Affects production embedded/TSN multi-switch deployments (Felix on NXP
  SoCs)

**AGAINST backport:**
- No user reports, syzbot, or CVE
- Requires uncommon multi-switch + tc-flower configuration
- No kernel crash/oops/memory corruption
- Niche driver subsystem
- No reviewer stable nomination

**Unresolved:** No reproduction report from a deployed system; exact
prevalence of multi-switch Felix/Ocelot configs in 6.18.y production is
unverified.

**Step 9.2 — Stable rules checklist**

1. Obviously correct and tested? **PASS** — logic is straightforward; no
   Tested-by but maintainer merged to netdev
2. Fixes a real bug affecting users? **PASS** — silent wrong hardware
   port mapping on multi-switch tc-flower offload
3. Important issue? **PASS (borderline)** — wrong datapath steering /
   broken offload policy; not crash-level but serious functional
   incorrectness for affected users
4. Small and contained? **PASS** — 6 files, 20 lines net
5. No new features or APIs? **PASS** — internal callback signature
   change only
6. Can apply to local tree? **PASS** — `git apply --check` succeeds

**Step 9.3 — Exception categories**

Record: None (not device ID, quirk, DT, build fix, or docs fix).

**Step 9.4 — Decision rationale**

This commit fixes a longstanding correctness bug where tc-flower
hardware offload on one Ocelot/Felix switch can silently program the
wrong port when a rule references a netdev from a different switch
instance. The failure mode is insidious mis-steering of traffic rather
than a kernel crash, but for managed-switch deployments relying on
hardware offload for redirect, mirror, or ingress-port matching, that is
a serious functional defect. The fix is minimal, self-contained, applies
cleanly to Linux 6.18.44, and is zero-risk for the common single-switch
case.

---

## Verification

- [Phase 1] Parsed commit message tags from provided diff and `git show
  ea07514700f7a`
- [Phase 2] Diff analysis: 6 files, +12/−8; ownership checks in
  `felix_netdev_to_port` and `ocelot_netdev_to_port`
- [Phase 3] `git blame` on `ocelot_net.c:987-997`: introduced
  `319e4dd11a207` (2020-10-02)
- [Phase 3] `git show 319e4dd11a207`: original commit introducing
  helpers without ownership check
- [Phase 3] `git show ea07514700f7a | git apply --check`: patch applies
  cleanly
- [Phase 3] `git merge-base --is-ancestor ea07514700f7a HEAD`: exit 1 —
  fix NOT in 6.18.44
- [Phase 4] `b4 dig -c ea07514700f7a`: lore URL found
- [Phase 4] `b4 dig -c ea07514700f7a -a`: v2 series only
- [Phase 4] `b4 dig -c ea07514700f7a -w`: maintainers CC’d (Oltean,
  Lunn, Kicinski, netdev)
- [Phase 4] `b4 dig -m /tmp/ocelot_netdev.mbox`: thread has patch + bot
  apply notice only; no stable nomination
- [Phase 5] `grep netdev_to_port`: only 2 call sites in
  `ocelot_flower.c`; ops table assignments in felix/ocelot drivers
- [Phase 5] Read `ocelot_net.c:197-216`: userspace tc path via
  `ndo_setup_tc`
- [Phase 5] Read `felix.c:1961,2023`: DSA tc-flower path
- [Phase 5] Read `ocelot_flower.c:231-254,550-593`: egress
  redirect/mirror and ingress-ifindex parse paths
- [Phase 6] `git describe HEAD`: v6.18.44
- [Phase 6] Read current buggy code at `ocelot_net.c:987-996`,
  `felix.c:2382-2390`
- [Phase 6] Verified `priv->port.ocelot` field in
  `include/soc/mscc/ocelot.h:772-773`
- [Phase 8] Failure mode: silent wrong VCAP port programming, severity
  MEDIUM-HIGH for multi-switch offload users

**YES**

 drivers/net/dsa/ocelot/felix.c            | 6 ++++--
 drivers/net/dsa/ocelot/felix.h            | 2 +-
 drivers/net/ethernet/mscc/ocelot.h        | 2 +-
 drivers/net/ethernet/mscc/ocelot_flower.c | 4 ++--
 drivers/net/ethernet/mscc/ocelot_net.c    | 4 +++-
 include/soc/mscc/ocelot.h                 | 2 +-
 6 files changed, 12 insertions(+), 8 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index 20ab558fde247..c4f1b6b335a24 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -2379,12 +2379,14 @@ struct net_device *felix_port_to_netdev(struct ocelot *ocelot, int port)
 }
 EXPORT_SYMBOL_GPL(felix_port_to_netdev);
 
-int felix_netdev_to_port(struct net_device *dev)
+int felix_netdev_to_port(struct ocelot *ocelot, struct net_device *dev)
 {
+	struct felix *felix = ocelot_to_felix(ocelot);
+	struct dsa_switch *ds = felix->ds;
 	struct dsa_port *dp;
 
 	dp = dsa_port_from_netdev(dev);
-	if (IS_ERR(dp))
+	if (IS_ERR(dp) || dp->ds != ds)
 		return -EINVAL;
 
 	return dp->index;
diff --git a/drivers/net/dsa/ocelot/felix.h b/drivers/net/dsa/ocelot/felix.h
index a657b190c5d7b..19addcfd62bec 100644
--- a/drivers/net/dsa/ocelot/felix.h
+++ b/drivers/net/dsa/ocelot/felix.h
@@ -104,6 +104,6 @@ int felix_register_switch(struct device *dev, resource_size_t switch_base,
 			  enum dsa_tag_protocol init_tag_proto,
 			  const struct felix_info *info);
 struct net_device *felix_port_to_netdev(struct ocelot *ocelot, int port);
-int felix_netdev_to_port(struct net_device *dev);
+int felix_netdev_to_port(struct ocelot *ocelot, struct net_device *dev);
 
 #endif
diff --git a/drivers/net/ethernet/mscc/ocelot.h b/drivers/net/ethernet/mscc/ocelot.h
index e50be508c1663..42d2c456f7128 100644
--- a/drivers/net/ethernet/mscc/ocelot.h
+++ b/drivers/net/ethernet/mscc/ocelot.h
@@ -92,7 +92,7 @@ int ocelot_mact_learn(struct ocelot *ocelot, int port,
 int ocelot_mact_forget(struct ocelot *ocelot,
 		       const unsigned char mac[ETH_ALEN], unsigned int vid);
 struct net_device *ocelot_port_to_netdev(struct ocelot *ocelot, int port);
-int ocelot_netdev_to_port(struct net_device *dev);
+int ocelot_netdev_to_port(struct ocelot *ocelot, struct net_device *dev);
 
 int ocelot_probe_port(struct ocelot *ocelot, int port, struct regmap *target,
 		      struct device_node *portnp);
diff --git a/drivers/net/ethernet/mscc/ocelot_flower.c b/drivers/net/ethernet/mscc/ocelot_flower.c
index 986b1f150e3b3..e80ede65f81ad 100644
--- a/drivers/net/ethernet/mscc/ocelot_flower.c
+++ b/drivers/net/ethernet/mscc/ocelot_flower.c
@@ -233,8 +233,8 @@ ocelot_flower_parse_egress_port(struct ocelot *ocelot, struct flow_cls_offload *
 				const struct flow_action_entry *a, bool mirror,
 				struct netlink_ext_ack *extack)
 {
+	int egress_port = ocelot->ops->netdev_to_port(ocelot, a->dev);
 	const char *act_string = mirror ? "mirror" : "redirect";
-	int egress_port = ocelot->ops->netdev_to_port(a->dev);
 	enum flow_action_id offloadable_act_id;
 
 	offloadable_act_id = mirror ? FLOW_ACTION_MIRRED : FLOW_ACTION_REDIRECT;
@@ -580,7 +580,7 @@ static int ocelot_flower_parse_indev(struct ocelot *ocelot, int port,
 		return -ENOENT;
 	}
 
-	ingress_port = ocelot->ops->netdev_to_port(indev);
+	ingress_port = ocelot->ops->netdev_to_port(ocelot, indev);
 	if (ingress_port < 0) {
 		NL_SET_ERR_MSG_MOD(extack,
 				   "Can only offload an ocelot ingress port");
diff --git a/drivers/net/ethernet/mscc/ocelot_net.c b/drivers/net/ethernet/mscc/ocelot_net.c
index 1b82693204640..4d45e136f08f5 100644
--- a/drivers/net/ethernet/mscc/ocelot_net.c
+++ b/drivers/net/ethernet/mscc/ocelot_net.c
@@ -984,7 +984,7 @@ static bool ocelot_netdevice_dev_check(const struct net_device *dev)
 	return dev->netdev_ops == &ocelot_port_netdev_ops;
 }
 
-int ocelot_netdev_to_port(struct net_device *dev)
+int ocelot_netdev_to_port(struct ocelot *ocelot, struct net_device *dev)
 {
 	struct ocelot_port_private *priv;
 
@@ -992,6 +992,8 @@ int ocelot_netdev_to_port(struct net_device *dev)
 		return -EINVAL;
 
 	priv = netdev_priv(dev);
+	if (priv->port.ocelot != ocelot)
+		return -EINVAL;
 
 	return priv->port.index;
 }
diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
index 48d6deb3efd71..05a8191b148e9 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -650,7 +650,7 @@ struct device_node;
 
 struct ocelot_ops {
 	struct net_device *(*port_to_netdev)(struct ocelot *ocelot, int port);
-	int (*netdev_to_port)(struct net_device *dev);
+	int (*netdev_to_port)(struct ocelot *ocelot, struct net_device *dev);
 	int (*reset)(struct ocelot *ocelot);
 	u16 (*wm_enc)(u16 value);
 	u16 (*wm_dec)(u16 value);
-- 
2.53.0

