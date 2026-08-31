Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FEBE4B5CA9;
	Mon, 31 Aug 2026 13:52:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184374; cv=none; b=QtDyLI0lGYyCCKPyt97UWK0gbXs6BAAi5Sngd/FVf2TI1DV2B6zAMgM5hFveYSb6PzRkbaGrGeBOIaWvsO0hwYWmkWsraQtlwbhyvipJ97TcD2a7kQXgvppqzqkACVHgL3Ro2hZsSBmEDzeFTVQqp6/GHy+ZVKZWtSPORyAPWUE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184374; c=relaxed/simple;
	bh=GJKZsagINGbAfCvbUWB4JFHUz8lF7dLWSE0cxNDqIzY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KSngdHSthDveoZLmbIP4WTKguhxCQJ5oI2LxIFw2qGwqwAdxdApwfXST55zWGQBpGYSgjL76ilVpagGsPaWbhp5rgxgcSd/BXhXxkyN9MFXA+7NgTsH8WphwDuvUGme0HbWKBkdTek4Mp4Z7vFl+eXXFfoHhISw0/FLozj2IHIY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OJWJKGyh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OJWJKGyh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98ECE1F00ACA;
	Mon, 31 Aug 2026 13:52:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788184371;
	bh=ru+y3VsnwZyW241M3oLoGIaoPFwI+bohzgb+M2d7EqU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OJWJKGyhjJ6D4pSg1XkFpHG1vHwqvU86CdhKm+W0qeSrU2knygo+WJ9Cxico2NOSX
	 Fkavj46geAcOwGoWEE6e0lC5VWU5hsFSfl0JSroK2h4s/ai1gZmJX/NGoWv9VS2C33
	 6eFquKwUNDnnEMrydmwTvteWwBP0H1PVdk/32p10WhR94VceDRaRLJs97OszEAuXhP
	 c0zbSIt6VT/Chr8W/g/o5SZ4Q7lSl753Kyj67Fq2Y+1bD+Hf/5bPihV7h0JpbAoH8i
	 5Y8YNGhbZz/R3BYqQMf3jjyovE1C8zLFWZlEgrASOD2kcyMsEY3X1VLmzn5bReQiHu
	 iqoNURHi647wQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: George Moussalem <george.moussalem@outlook.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	olteanv@gmail.com,
	davem@davemloft.net,
	edumazet@google.com,
	pabeni@redhat.com,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.6] net: dsa: qca8k: Add support for force mode for fixed link topology
Date: Mon, 31 Aug 2026 09:31:22 -0400
Message-ID: <20260831133314.4125787-654-sashal@kernel.org>
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

From: George Moussalem <george.moussalem@outlook.com>

[ Upstream commit e0a77b1ed9001bdd0c73b99c67abb90f4bd7d7f5 ]

A fixed link topology is commonly used to connect this switch (on port
0 or 6) to a SoC's MAC over SGMII. When inband negotiation is not used,
the switch needs to be configured to operate in force mode. As such,
enable support for force mode.

Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: George Moussalem <george.moussalem@outlook.com>
Link: https://patch.msgid.link/20260605-qca8337-force-mode-v2-1-d9a6b6545bfa@outlook.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: `net: dsa: qca8k: Add support for force mode
for fixed link topology`

**Local tree:** `v6.18.44` (Linux 6.18.44)
**Commit under review:** `e0a77b1ed9001` (on `master`/`net-next`,
**not** in current HEAD)

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Subject line
**Record:** `[net: dsa: qca8k]` `[Add]` — Add SGMII force-mode register
programming for QCA8337 when phylink uses out-of-band/fixed-link
negotiation.

### Step 1.2: Tags
**Record:**
- **Reviewed-by:** Andrew Lunn `<andrew@lunn.ch>` (DSA maintainer)
- **Signed-off-by:** George Moussalem, Jakub Kicinski
- **Link:** https://patch.msgid.link/20260605-qca8337-force-
  mode-v2-1-d9a6b6545bfa@outlook.com
- **No** Fixes:, Reported-by:, Tested-by:, Cc: stable@vger.kernel.org,
  syzbot links

Notable: reviewed by DSA maintainer; no user bug report or fuzzer
report.

### Step 1.3: Body analysis
**Record:**
- **Bug described:** QCA8337 switches connected to a SoC MAC over SGMII
  via fixed-link (ports 0 or 6) require hardware “force mode” when in-
  band negotiation is not used.
- **Symptom/failure mode:** CPU-port SGMII link does not come up;
  switch-to-SoC connectivity broken (functional failure, not a kernel
  crash).
- **Root cause:** `qca8k_pcs_config()` never programs
  `QCA8K_PORT_PAD_SGMII_FORCE_MODE` (BIT(3)) for
  `PHYLINK_PCS_NEG_OUTBAND` on QCA8337.
- **Version info:** None in commit message.

### Step 1.4: Hidden bug fix?
**Record:** Yes, despite “Add support” wording. This is missing required
hardware register programming — a driver omission that breaks a common,
documented topology. Functionally a hardware workaround/quirk, not a new
API or subsystem.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory
**Record:**
- `drivers/net/dsa/qca/qca8k-8xxx.c`: +16/−6 (22 lines touched)
- `drivers/net/dsa/qca/qca8k.h`: +1 line (new
  `QCA8K_PORT_PAD_SGMII_FORCE_MODE` define)
- **Functions modified:** `qca8k_pcs_config()`
- **Scope:** Single-file surgical driver fix + one register-bit define

### Step 2.2: Code flow change
**Record:**
- **Hunk 1 (mask refactor):** Before: `qca8k_rmw()` only ran when clock-
  phase `val` was non-zero, with a fixed mask. After: builds `mask`
  dynamically; `qca8k_rmw()` runs whenever `mask` is non-zero.
- **Hunk 2 (force mode):** For `QCA8K_ID_QCA8337` only, when `neg_mode
  == PHYLINK_PCS_NEG_OUTBAND`, sets `QCA8K_PORT_PAD_SGMII_FORCE_MODE` in
  `val` and includes it in `mask`. Force-mode bit always written to
  PORT0 PAD register (ports 0 and 6).
- **Path affected:** PCS configuration during phylink bring-up for
  fixed-link / out-of-band negotiation.

### Step 2.3: Bug mechanism
**Record:** **[h] Hardware workaround / logic correctness** — QCA8337
SGMII fixed-link requires force-mode bit; driver never set it. Phylink
passes `PHYLINK_PCS_NEG_OUTBAND` for fixed-link (`MLO_AN_FIXED`),
confirmed in `phylink.c:1150`.

### Step 2.4: Fix quality
**Record:** Obviously correct and minimal. QCA8337-only guard (v2 review
feedback) avoids touching undocumented bits on other switch IDs. Low
regression risk; only affects QCA8337 PCS config path. Minor note: `ret`
from final `qca8k_rmw()` is not checked (pre-existing pattern).

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame
**Record:** `qca8k_pcs_config()` dates to Russell King, Feb 2022
(`9612a8f9154f1a`). `neg_mode` handling added Jun 2023
(`bfa0a3ac05b69`). Force mode was never implemented — omission since PCS
support landed, not a recent regression.

### Step 3.2: Fixes: tag
**Record:** N/A — no Fixes: tag.

### Step 3.3: Related file history
**Record:** Recent qca8k changes include phylink `neg_mode` API updates
(`de38503b74e28`, `c6739623c91bb`) — all present in 6.18.44. No related
force-mode fix already in tree. Standalone 1/1 patch (v1→v2 series, v2
is final).

### Step 3.4: Author context
**Record:** George Moussalem has limited qca8k history (`10e05634ddc19`
LED fix). Patch reviewed by Andrew Lunn (DSA maintainer).

### Step 3.5: Dependencies
**Record:** Requires `PHYLINK_PCS_NEG_OUTBAND` (present since
`f99d471afa03f`, in tree), `qca8k_pcs_config()` with `neg_mode` param
(present), `QCA8K_ID_QCA8337` support (present). No series dependencies.
`git format-patch -1 e0a77b1ed9001 | git apply --check` succeeds on
current tree.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: Original discussion
**Record:** `b4 dig -c e0a77b1ed9001` →
https://patch.msgid.link/20260605-qca8337-force-
mode-v2-1-d9a6b6545bfa@outlook.com. Series: v1 (2026-06-03), v2
(2026-06-05, committed version). v2 changes: QCA8337-only guard + PORT0
PAD register comment. Thread contains only patch submission + patchwork-
bot “applied” notice — no NAKs, no stable nomination, no user bug
reports in thread.

### Step 4.2: Reviewers
**Record:** `b4 dig -w`: CC'd Andrew Lunn, Vladimir Oltean, David
Miller, Eric Dumazet, Jakub Kicinski, Paolo Abeni, netdev@, linux-
kernel@. Andrew Lunn Reviewed-by.

### Step 4.3: Bug reports
**Record:** None found. No syzbot, no bugzilla, no user Reported-by.

### Step 4.4: Related patches
**Record:** Standalone; v2 is final revision.

### Step 4.5: Stable list history
**Record:** Not searched separately; no stable discussion found in patch
thread.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Key functions
**Record:** `qca8k_pcs_config()` (modified),
`QCA8K_PORT_PAD_SGMII_FORCE_MODE` (new define).

### Step 5.2: Callers
**Record:** `qca8k_pcs_config` is registered as `.pcs_config` in
`qca8k_pcs_ops`, called via phylink’s `phylink_pcs_config()` →
`pcs->ops->pcs_config()`. Triggered during device probe/link
configuration (`phylink_mac_initial_config` → `phylink_major_config` →
`phylink_pcs_config`). Common device-init path.

### Step 5.3: Callees
**Record:** `qca8k_rmw()`, `qca8k_mac_config_setup_internal_delay()`,
`qca8k_read()`, `qca8k_write()` — standard register I/O.

### Step 5.4: Call chain / reachability
**Record:** DT with `fixed-link` → `MLO_AN_FIXED` → phylink sets
`PHYLINK_PCS_NEG_OUTBAND` → `qca8k_pcs_config()` with that `neg_mode`.
Reachable on every boot for affected boards. In-tree example:
`arch/arm/boot/dts/broadcom/bcm958625-meraki-alamo.dtsi` — two QCA8337
switches, `phy-mode = "sgmii"`, `fixed-link` on port@0 (since
`af413758ea718`, Aug 2021).

### Step 5.5: Similar patterns
**Record:** No other force-mode handling in qca8k driver. SerDes AEN
disable already handled separately via `QCA8K_PWS_SERDES_AEN_DIS`; force
mode is an additional QCA8337-specific requirement.

---

## PHASE 6: CROSS-REFERENCING AGAINST LOCAL TREE (6.18.44)

### Step 6.1: Buggy code exists?
**Record:** **Yes.** Current HEAD (`v6.18.44`) has `qca8k_pcs_config()`
without force-mode logic (lines 1534–1620).
`QCA8K_PORT_PAD_SGMII_FORCE_MODE` absent from `qca8k.h`. Commit
`e0a77b1ed9001` is **not** an ancestor of HEAD (`git merge-base --is-
ancestor` returns 1).

### Step 6.2: Backport complications
**Record:** **Clean apply** — `git format-patch -1 e0a77b1ed9001 | git
apply --check` passes. No refactoring conflicts expected.

### Step 6.3: Related fixes already present?
**Record:** None. `git log --grep="force mode"` on qca driver returns
empty.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

### Step 7.1: Subsystem criticality
**Record:** `drivers/net/dsa/qca/` — **IMPORTANT** (networking/DSA).
Affects embedded routers and appliances with QCA8337 switches.

### Step 7.2: Subsystem activity
**Record:** Actively maintained; recent phylink PCS API updates in
6.18.y.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: Who is affected
**Record:** **Platform-specific** — users of QCA8337 with SGMII fixed-
link CPU ports. Confirmed in-tree: Meraki MX65 series
(`bcm958625-meraki-alamo.dtsi`). Turris Omnia uses QCA8337 with fixed-
link but over RGMII (different interface; force-mode bit is SGMII-
specific).

### Step 8.2: Trigger conditions
**Record:** Boot/probe with `fixed-link` + SGMII on QCA8337 port 0 or 6.
Common embedded topology. Unprivileged users cannot trigger directly;
affects system networking at boot.

### Step 8.3: Failure mode severity
**Record:** **HIGH** for affected platforms (CPU switch uplink non-
functional — appliance effectively loses switch connectivity to SoC).
**LOW** globally (narrow hardware/config subset). Not a kernel crash,
UAF, or data corruption.

### Step 8.4: Risk-benefit
**Record:**
- **Benefit:** Restores networking on real in-tree hardware (Meraki MX65
  and similar).
- **Risk:** Very low — 17 net lines, QCA8337-guarded, reviewed by
  maintainer.
- **Ratio:** Good benefit for affected users, minimal risk.

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence compile

**FOR backport:**
- Fixes real hardware breakage on in-tree platforms (Meraki MX65 QCA8337
  + SGMII + fixed-link).
- Small, surgical, obviously correct register programming.
- Reviewed by DSA maintainer (Andrew Lunn).
- Applies cleanly to 6.18.44; all prerequisites present.
- Hardware workaround / quirk category (stable exception).
- No new APIs or userspace-visible changes.

**AGAINST backport:**
- Wording is “Add support” — looks like feature completion.
- No user bug reports, syzbot, or Fixes: tag.
- Not a crash/corruption/security/deadlock per strict stable criterion
  #3.
- Long-standing omission (since ~2022); not a regression.
- Narrow hardware scope.

**Unresolved:** No independent confirmation of user-facing failure
reports; no Tested-by on real hardware in commit.

### Step 9.2: Stable rules checklist
1. Obviously correct and tested? **PASS** (reviewed; logically sound; no
   runtime test tag)
2. Fixes a real bug affecting users? **PASS** (missing register config
   breaks SGMII fixed-link on QCA8337)
3. Important issue? **PASS** (complete networking failure on affected
   appliances — functional severity high for those users, though not a
   kernel crash)
4. Small and contained? **PASS** (2 files, ~17 lines)
5. No new features/APIs? **PASS** (uses existing phylink negotiation
   modes)
6. Can apply to local tree? **PASS** (clean apply verified)

### Step 9.3: Exception categories
**Record:** **Hardware quirk/workaround** — programs a silicon-required
force-mode bit for QCA8337 SGMII fixed-link topology.

### Step 9.4: Decision rationale

This commit programs a mandatory QCA8337 hardware register bit for the
common fixed-link SGMII topology described in the commit message and
present in in-tree DTS (Meraki MX65). Without it, the switch CPU port
link cannot establish when in-band negotiation is not used. While not a
kernel crash fix, it is a hardware-specific workaround that restores
networking on deployed embedded appliances — exactly the class of fix
stable trees accept under the quirk/workaround exception. The patch is
minimal, reviewed, dependency-free, and applies cleanly to 6.18.44.

---

## Verification

- [Phase 1] Parsed subject, tags (Reviewed-by Andrew Lunn, Link to
  lore), body; no Fixes/Reported-by/syzbot
- [Phase 2] Diff: 2 files, `qca8k_pcs_config()` modified, +17/−6 lines;
  force-mode bit for QCA8337 + `PHYLINK_PCS_NEG_OUTBAND`
- [Phase 3] `git blame`: `qca8k_pcs_config` from 2022; force mode never
  implemented
- [Phase 3] No Fixes: tag to follow
- [Phase 3] `git log -20 drivers/net/dsa/qca/qca8k-8xxx.c`: no duplicate
  fix
- [Phase 3] Prerequisites `de38503`, `f99d471` confirmed ancestors of
  HEAD
- [Phase 3] `git format-patch -1 e0a77b1ed9001 | git apply --check`:
  **passes**
- [Phase 4] `b4 dig -c e0a77b1ed9001`: lore URL found; v1→v2 series
- [Phase 4] `b4 dig -w`: netdev maintainers CC'd; Andrew Lunn reviewed
- [Phase 4] `/tmp/qca8337-force.mbox`: v2 changelog (QCA8337 guard); no
  stable nomination, no NAKs
- [Phase 5] `grep PHYLINK_PCS_NEG_OUTBAND drivers/net/phy/phylink.c`:
  fixed-link → out-of-band at line 1150
- [Phase 5] Meraki DTS: `bcm958625-meraki-alamo.dtsi` has qca8337 +
  sgmii + fixed-link on port@0
- [Phase 6] `git describe HEAD`: v6.18.44
- [Phase 6] `git merge-base --is-ancestor e0a77b1ed9001 HEAD`: **not in
  tree** (exit 1)
- [Phase 6] Current `qca8k-8xxx.c:1614-1618`: old code without force
  mode confirmed
- [Phase 6] `QCA8K_PORT_PAD_SGMII_FORCE_MODE`: absent from current
  `qca8k.h`
- [Phase 8] Meraki DTS added `af413758ea718` (Aug 2021), confirmed
  ancestor of HEAD

**YES**

 drivers/net/dsa/qca/qca8k-8xxx.c | 22 ++++++++++++++++------
 drivers/net/dsa/qca/qca8k.h      |  1 +
 2 files changed, 17 insertions(+), 6 deletions(-)

diff --git a/drivers/net/dsa/qca/qca8k-8xxx.c b/drivers/net/dsa/qca/qca8k-8xxx.c
index a36b8b07030e3..4c928983b8623 100644
--- a/drivers/net/dsa/qca/qca8k-8xxx.c
+++ b/drivers/net/dsa/qca/qca8k-8xxx.c
@@ -1538,7 +1538,7 @@ static int qca8k_pcs_config(struct phylink_pcs *pcs, unsigned int neg_mode,
 {
 	struct qca8k_priv *priv = pcs_to_qca8k_pcs(pcs)->priv;
 	int cpu_port_index, ret, port;
-	u32 reg, val;
+	u32 mask, reg, val;
 
 	port = pcs_to_qca8k_pcs(pcs)->port;
 	switch (port) {
@@ -1611,11 +1611,21 @@ static int qca8k_pcs_config(struct phylink_pcs *pcs, unsigned int neg_mode,
 	if (priv->ports_config.sgmii_tx_clk_falling_edge)
 		val |= QCA8K_PORT0_PAD_SGMII_TXCLK_FALLING_EDGE;
 
-	if (val)
-		ret = qca8k_rmw(priv, reg,
-				QCA8K_PORT0_PAD_SGMII_RXCLK_FALLING_EDGE |
-				QCA8K_PORT0_PAD_SGMII_TXCLK_FALLING_EDGE,
-				val);
+	mask = (val) ? (QCA8K_PORT0_PAD_SGMII_RXCLK_FALLING_EDGE |
+			QCA8K_PORT0_PAD_SGMII_TXCLK_FALLING_EDGE) : 0;
+
+	/*
+	 * (Un)set force mode on QCA8337 only, don't include it in the mask for
+	 * others. It is written to the PORT0 PAD register for both port 0 and 6.
+	 */
+	if (priv->switch_id == QCA8K_ID_QCA8337) {
+		if (neg_mode == PHYLINK_PCS_NEG_OUTBAND)
+			val |= QCA8K_PORT_PAD_SGMII_FORCE_MODE;
+		mask |= QCA8K_PORT_PAD_SGMII_FORCE_MODE;
+	}
+
+	if (mask)
+		ret = qca8k_rmw(priv, reg, mask, val);
 
 	return 0;
 }
diff --git a/drivers/net/dsa/qca/qca8k.h b/drivers/net/dsa/qca/qca8k.h
index d046679265fa4..ed8f0b49812c4 100644
--- a/drivers/net/dsa/qca/qca8k.h
+++ b/drivers/net/dsa/qca/qca8k.h
@@ -58,6 +58,7 @@
 #define	  QCA8K_PORT_PAD_RGMII_TX_DELAY_EN		BIT(25)
 #define   QCA8K_PORT_PAD_RGMII_RX_DELAY_EN		BIT(24)
 #define   QCA8K_PORT_PAD_SGMII_EN			BIT(7)
+#define   QCA8K_PORT_PAD_SGMII_FORCE_MODE		BIT(3)
 #define QCA8K_REG_PWS					0x010
 #define   QCA8K_PWS_POWER_ON_SEL			BIT(31)
 /* This reg is only valid for QCA832x and toggle the package
-- 
2.53.0

