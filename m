Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3048C3B19DE;
	Mon, 20 Apr 2026 13:16:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776691002; cv=none; b=ObeSGuLhMcLo+B8HDlNVjMhfrHESeyFDLi8EncHQuvZhc3SADo4t92CqgVs5aXgeXxJuje6yez70cgIADo+0qaitnqLLyT562JUEvUWwDDOi/qIDAnlOzHV4wuNYJa9Ti+juJYJr/llkZ6RLkhIH4nJqVimVUEePpzy7/c75bjs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776691002; c=relaxed/simple;
	bh=4fm3Gyb0p2DaPrFH/qZW5DbR/7n8ndjmgcuZvV4tNeA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qlwRQxLao82myxtnrWQmqiMs1CYZ5r+FNvBifR+V5jTo8AGqEFH6XOJBhFv2cSoBU5Ojm3rjQaEF456lHbsQGcNVLUwdD9REtxVG34FkDG6BDJwtGU46GmhOIlbCr1pRnNC4tRJwUVgYVlgCLvnca9WwtE2RGnpAQqGmchgx/3w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=csfSLa5i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="csfSLa5i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78FA2C19425;
	Mon, 20 Apr 2026 13:16:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776691001;
	bh=4fm3Gyb0p2DaPrFH/qZW5DbR/7n8ndjmgcuZvV4tNeA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=csfSLa5iKXF6arfQcylvSOF0nKv2jGK4S9jhPl4AjQcg515JJu7f5gfRptF7g1oon
	 ++fu0XkGIqGbHCprKkmaYBh+vHubTSlrVJUB5clKz2JwobLnX+g425En16rwP+cCf2
	 36hwG+1CcGJhDjnkgEU44qbW7v3UVQVx0iJmwa4peABALj882iMm3cqbXDTISsNgN2
	 lqkk6aiWJ/MS+GZx51bKRDw7vi3OZKJoO10jSEbQNW02Q8EOUNjUqGWHiZMNPdOoni
	 dJl/V/WslP1kS7XDeyyLRQoO91HG8029WVVIjMPwx405/TYYOVelPiSPGR2lECrc3V
	 LFOR5dYfDVVyg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Rosen Penev <rosenp@gmail.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	marcin.s.wojtas@gmail.com,
	andrew+netdev@lunn.ch,
	davem@davemloft.net,
	edumazet@google.com,
	pabeni@redhat.com,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0-5.15] net: mvneta: support EPROBE_DEFER when reading MAC address
Date: Mon, 20 Apr 2026 09:08:22 -0400
Message-ID: <20260420131539.986432-36-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420131539.986432-1-sashal@kernel.org>
References: <20260420131539.986432-1-sashal@kernel.org>
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

From: Rosen Penev <rosenp@gmail.com>

[ Upstream commit 73a864352570fd30d942652f05bfe9340d7a2055 ]

If nvmem loads after the ethernet driver, mac address assignments will
not take effect. of_get_ethdev_address returns EPROBE_DEFER in such a
case so we need to handle that to avoid eth_hw_addr_random.

Add extra goto section to just free stats as they are allocated right
above.

Signed-off-by: Rosen Penev <rosenp@gmail.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20260307031709.640141-1-rosenp@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I have all the information needed for the full analysis.

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Subject Line
- **Subsystem**: `net: mvneta:` (Marvell NETA ethernet driver)
- **Action verb**: "support" - enabling proper handling of an error
  condition
- **Summary**: Handle EPROBE_DEFER from `of_get_ethdev_address()` in
  mvneta probe

Record: [net: mvneta] [support] [Handle EPROBE_DEFER to avoid incorrect
random MAC assignment when nvmem loads after ethernet driver]

### Step 1.2: Tags
- **Signed-off-by**: Rosen Penev (author), Jakub Kicinski (net
  maintainer)
- **Reviewed-by**: Simon Horman (networking reviewer) - strong quality
  signal
- **Link**:
  https://patch.msgid.link/20260307031709.640141-1-rosenp@gmail.com
  (lore blocked by Anubis)
- No Fixes: tag (expected for this review pipeline)
- No Cc: stable (expected)

Record: Reviewed by Simon Horman (experienced networking reviewer),
committed by Jakub Kicinski (net maintainer). No syzbot, no multiple
reporters.

### Step 1.3: Body Text
The commit explains that when nvmem loads after the ethernet driver,
`of_get_ethdev_address()` returns `-EPROBE_DEFER`. Without handling
this, the driver falls through to `eth_hw_addr_random`, assigning a
random MAC address instead of deferring probe. The fix adds an
`err_free_stats` goto section to properly clean up.

Record: Bug: EPROBE_DEFER not handled, causing random MAC assignment
instead of probe deferral. Symptom: Device gets a random MAC instead of
its stored nvmem MAC. Root cause: Missing EPROBE_DEFER check after
`of_get_ethdev_address()`.

### Step 1.4: Hidden Bug Fix Detection
This is a real bug fix despite using "support" rather than "fix".
Without this, users get a non-deterministic MAC address that changes
every boot, breaking network configurations.

Record: YES - this is a real bug fix. The consequence is a random MAC
address instead of the correct one from nvmem storage.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory
- **Files changed**: 1 (`drivers/net/ethernet/marvell/mvneta.c`)
- **Lines added**: 3 (2 lines for EPROBE_DEFER check + 1 label)
- **Functions modified**: `mvneta_probe()` only
- **Scope**: Single-file surgical fix

### Step 2.2: Code Flow Change
**Hunk 1** (around line 5622): After `of_get_ethdev_address()`, adds
check for EPROBE_DEFER to jump to cleanup.
- Before: EPROBE_DEFER falls into the `else` branch and assigns a random
  MAC.
- After: EPROBE_DEFER causes probe to fail and return -EPROBE_DEFER.

**Hunk 2** (around line 5758): Adds `err_free_stats:` label before
`free_percpu(pp->stats)`.
- This provides a proper cleanup path that frees stats, ports, phylink,
  clocks, and IRQ.

### Step 2.3: Bug Mechanism
Category: **Logic/correctness fix** - missing error path handling. The
`of_get_ethdev_address()` call can return `-EPROBE_DEFER` when the nvmem
provider isn't loaded yet. Without handling this specific error, the
driver proceeds with a random MAC address. The fix returns the error so
the driver framework retries probe later when nvmem is available.

### Step 2.4: Fix Quality
- Obviously correct - follows established pattern used in macb,
  ucc_geth, gianfar, airoha, mtk_eth_soc
- Minimal (3 lines), surgical, well-contained
- No regression risk - the new `err_free_stats` cleanup path correctly
  unwinds only what was allocated (stats, ports, phylink, clocks, IRQ)
- No red flags

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame
- `of_get_ethdev_address()` call was introduced by commit 9ca01b25dffffe
  ("ethernet: use of_get_ethdev_address()") in v5.16
- The original MAC address reading pattern has been present since commit
  8cc3e439ab9207 (2013)
- The nvmem path in `of_get_mac_address()` was present since ~v5.0
  (`of_get_mac_address_nvmem()`)
- Bug has been present since v5.16 when mvneta switched to
  `of_get_ethdev_address()`

### Step 3.2: Fixes Tag
No Fixes: tag present. The implicit "fixes" target would be
9ca01b25dffffe (v5.16) which exists in all active stable trees (6.1,
6.6, 6.12).

### Step 3.3: Related Changes
The author (Rosen Penev) has been systematically fixing this same
pattern across drivers:
- `b2d9544070d05` "net: gianfar: fix NVMEM mac address" (v6.12)
- `2575897640328` "net: ucc_geth: fix usage with NVMEM MAC address"
  (v6.13)
- `be04024a24a93` "net: ag71xx: support probe deferral for getting MAC
  address"

This mvneta fix is standalone and does not depend on other patches.

### Step 3.4: Author
Rosen Penev is a regular contributor with multiple accepted patches in
the networking subsystem, especially around nvmem MAC address handling.
Not the subsystem maintainer but an experienced contributor.

### Step 3.5: Dependencies
No dependencies. The fix uses existing infrastructure
(`of_get_ethdev_address()` and error labels already in the function).
Applies standalone.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1-4.5
b4 dig did not find the submission. Lore was blocked by Anubis anti-
scraping. However, the commit metadata is clear:
- Reviewed by Simon Horman (experienced networking reviewer)
- Accepted by Jakub Kicinski (netdev maintainer)
- This is part of an established series by the same author fixing the
  same pattern in multiple drivers

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Key Functions
- `mvneta_probe()` - the sole modified function

### Step 5.2: Callers
`mvneta_probe()` is called by the platform driver framework during
device enumeration. This is a standard probe path for all Marvell NETA
Ethernet controllers.

### Step 5.3-5.4: Call Chain
`of_get_ethdev_address()` -> `of_get_mac_address()` ->
`of_get_mac_address_nvmem()` -> `of_nvmem_cell_get()` which returns
`-EPROBE_DEFER` when the nvmem provider hasn't been loaded yet. This is
a standard Linux device model flow.

### Step 5.5: Similar Patterns
Multiple other drivers handle this pattern correctly:
- `drivers/net/ethernet/mediatek/mtk_eth_soc.c` - handles EPROBE_DEFER
- `drivers/net/ethernet/freescale/ucc_geth.c` - handles EPROBE_DEFER
- `drivers/net/ethernet/cadence/macb_main.c` - handles EPROBE_DEFER
- `drivers/net/ethernet/airoha/airoha_eth.c` - handles EPROBE_DEFER

mvneta was an outlier in NOT handling it.

---

## PHASE 6: CROSS-REFERENCING AND STABLE TREE ANALYSIS

### Step 6.1: Buggy Code in Stable
The `of_get_ethdev_address()` call in mvneta was introduced in v5.16
(commit 9ca01b25dffffe). All active stable trees (6.1.y, 6.6.y, 6.12.y)
contain this buggy code.

### Step 6.2: Backport Complications
The fix is very small (3 lines) and only uses existing infrastructure.
The error cleanup chain structure has been stable since 2022. Expected
to apply cleanly.

### Step 6.3: Related Fixes Already in Stable
No prior fix for this specific issue in mvneta.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

### Step 7.1: Subsystem
- **Subsystem**: Network drivers (drivers/net/ethernet/marvell/)
- **Criticality**: IMPORTANT - Marvell NETA is a widely used Ethernet
  controller in Armada SoCs, common in embedded/networking appliances
  (routers, NAS devices, network gateways)

### Step 7.2: Subsystem Activity
The mvneta driver is actively maintained with regular updates.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: Who Is Affected
Users with Marvell NETA Ethernet controllers whose MAC address is stored
in nvmem (common in embedded devices). These are typically ARM-based
platforms.

### Step 8.2: Trigger Conditions
Triggered when:
- Device tree specifies MAC in nvmem (common configuration)
- nvmem driver loads after mvneta driver (depends on module load order,
  kernel config)
- This is a real-world scenario, especially on systems with complex
  device tree dependencies

### Step 8.3: Failure Mode Severity
- **Without fix**: Random MAC address assigned, networking may break
  (DHCP gets new IP, static configs fail, MAC-based filtering fails)
- **Severity**: HIGH for affected users - unstable MAC address across
  reboots can cause network connectivity failures and operational issues
  in embedded deployments
- Not a crash, but a functional correctness issue with real-world impact

### Step 8.4: Risk-Benefit Ratio
- **Benefit**: HIGH - restores correct MAC address behavior for embedded
  users
- **Risk**: VERY LOW - 3-line change, follows established pattern,
  proper cleanup
- **Ratio**: Strongly favorable

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence Summary

**FOR backporting:**
- Fixes a real functional bug (wrong MAC address assignment)
- Tiny change: 3 lines added
- Follows an established pattern already used by 4+ other drivers
- Same author has had identical fixes accepted in other drivers
- Reviewed by Simon Horman, committed by Jakub Kicinski
- Affects all stable trees (6.1+)
- No dependencies, standalone fix
- Proper cleanup path (no resource leaks)
- Real-world impact on embedded/ARM devices using nvmem for MAC storage

**AGAINST backporting:**
- Not a crash, security, or data corruption issue
- Affects a specific hardware platform (Marvell NETA SoCs with nvmem
  MAC)
- Could be seen as "enabling a feature" (nvmem MAC support), but nvmem
  support has been present since v5.0 - this just fixes the error
  handling

### Step 9.2: Stable Rules Checklist
1. Obviously correct and tested? **YES** - trivial pattern, reviewed by
   expert
2. Fixes a real bug? **YES** - wrong MAC address when nvmem loads late
3. Important issue? **YES** - networking breaks with wrong MAC
4. Small and contained? **YES** - 3 lines, 1 file
5. No new features? **CORRECT** - this enables existing nvmem MAC
   feature to work correctly
6. Can apply to stable? **YES** - no dependencies, clean apply expected

### Step 9.3: Exception Categories
Not strictly an exception category, but this is a straightforward
correctness fix.

### Step 9.4: Decision
This is a small, obviously correct fix for a real functional bug. It
follows an established pattern already used in multiple other drivers.
The risk is minimal and the benefit is significant for embedded users
with Marvell NETA hardware using nvmem MAC addresses.

---

## Verification

- [Phase 1] Parsed tags: Reviewed-by Simon Horman, signed by Jakub
  Kicinski. No Fixes: tag (expected).
- [Phase 2] Diff analysis: 3 lines added - 2 lines for EPROBE_DEFER
  check, 1 err_free_stats label in mvneta_probe()
- [Phase 3] git blame: `of_get_ethdev_address()` call introduced by
  9ca01b25dffffe (v5.16), present in all active stable trees
- [Phase 3] git log author: Rosen Penev has multiple identical fixes
  accepted (ucc_geth v6.13, gianfar v6.12)
- [Phase 3] File history: no prerequisites or conflicts identified
- [Phase 4] b4 dig: could not find match; lore blocked by Anubis
- [Phase 5] Grep for similar patterns: confirmed 4+ other drivers handle
  EPROBE_DEFER from of_get_ethdev_address() correctly (macb, ucc_geth,
  airoha, mtk_eth_soc)
- [Phase 5] of_get_ethdev_address() -> of_get_mac_address() ->
  of_get_mac_address_nvmem() can return -EPROBE_DEFER (verified in
  net/core/of_net.c lines 61-97, 126-147, 162-171)
- [Phase 6] Code exists in all active stable trees (6.1+), verified via
  git describe --contains for 9ca01b25dffffe (v5.16-rc1)
- [Phase 6] Expected clean apply - fix uses only existing error labels
  and infrastructure
- [Phase 7] mvneta is a widely-used Marvell Armada SoC ethernet driver
- [Phase 8] Failure mode: random MAC assignment instead of correct nvmem
  MAC, severity HIGH for embedded users
- UNVERIFIED: Could not access mailing list discussion due to Anubis
  blocking

**YES**

 drivers/net/ethernet/marvell/mvneta.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
index 9ba4aef7080c0..0c061fb0ed072 100644
--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -5620,6 +5620,8 @@ static int mvneta_probe(struct platform_device *pdev)
 	}
 
 	err = of_get_ethdev_address(dn, dev);
+	if (err == -EPROBE_DEFER)
+		goto err_free_stats;
 	if (!err) {
 		mac_from = "device tree";
 	} else {
@@ -5755,6 +5757,7 @@ static int mvneta_probe(struct platform_device *pdev)
 				       1 << pp->id);
 		mvneta_bm_put(pp->bm_priv);
 	}
+err_free_stats:
 	free_percpu(pp->stats);
 err_free_ports:
 	free_percpu(pp->ports);
-- 
2.53.0

