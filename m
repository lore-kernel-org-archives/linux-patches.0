Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 393995571B4;
	Mon, 31 Aug 2026 13:47:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184034; cv=none; b=P+tQaCRG1/KDThY9bXep4NKASIPj7d94hhQVRRvW++szwH/c2yO0oV0FhuoU9ZOyVgXCd7hbGeSIV60SxHd1nIN0bERWtbIOvNFzuEHQ/yEAoKPXWGQLbo1HDepIn5vvP+WNBU40JgCFe5Y566031GkR4PUzrgelYJwuvd/Wlk0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184034; c=relaxed/simple;
	bh=NZVJL/kFdNoz/bS+2afW3gxFY6Fn9WAdk6S0G1T4qJE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qSgRkN9K+yCbnirw+I96FNwTKbZ4u98Jb9Q29rGXjYs+Vh5rspPRtpRyb7K7eNM+8uW013SPPn5RhoJU+c7hoWt9bUda+0Hq/O4HnsqTslA+TCR4j3UDrmKI92aNDrJPMSqe6lPrRLfGbdDzF7VAVmueWg+SWtaj9l1pDb27ogs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Baly7jXk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Baly7jXk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C12D01F00A3D;
	Mon, 31 Aug 2026 13:47:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788184030;
	bh=kmTEh9q0Fmu956k738Dbnq6IcgrvZxhZeUqvD8UqqHo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Baly7jXk+5bQP8vuv693NV1Kx1r3nI2PvExSHB4jza6KJBlXFt/fw1Fivt5uln77f
	 HBI7OHD4scNgnYo69j6bMixRVSeUmgKqTzRCt1dITaiAgpfm7I7335KOyrWEacXb+A
	 zshF0WuhfK/rvNsr9xilYrxa3FPyiSrYvcCDU/fsS3nlxn07rz6sFCQOysJeZyUERS
	 5YWAwuRGR6Fd0cYE4kK68eitxrpTCxVz4dOup/uWIBlylVTvO2iYLM9cjC/LNFboWD
	 tHz/2FBS4ASnL6nZ2S0e8AWBKQfvzLMxMAgcnBSr0usNhF2kOXvHkDNsJdUFNdS8Hy
	 80tj1SXLf0Vnw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Gil Fine <gil.fine@linux.intel.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>,
	andreas.noever@gmail.com,
	westeri@kernel.org,
	YehezkelShB@gmail.com,
	linux-usb@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] thunderbolt: Verify PCIe adapter in detect state before tunnel setup
Date: Mon, 31 Aug 2026 09:27:57 -0400
Message-ID: <20260831133314.4125787-449-sashal@kernel.org>
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

From: Gil Fine <gil.fine@linux.intel.com>

[ Upstream commit 69a7b98770b7e80deec0465d97710611a0e51774 ]

The USB4 Connection Manager guide suggests that a PCIe downstream and
PCIe upstream adapters of the USB4 router is in the Detect state before
setting up a PCIe tunnel.

Add this check by verifying the LTSSM field in ADP_PCIE_CS_0 before
tunnel setup.

Signed-off-by: Gil Fine <gil.fine@linux.intel.com>
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit Message Forensics

**Step 1.1 — Subject line**
Record: `[thunderbolt] [verify] Verify PCIe adapter in detect state
before tunnel setup` — USB4/Thunderbolt driver change that adds a pre-
tunnel LTSSM state check.

**Step 1.2 — Tags**
Record:
- `Signed-off-by: Gil Fine <gil.fine@linux.intel.com>` (author)
- `Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>`
  (subsystem maintainer)
- No `Fixes:`, `Reported-by:`, `Tested-by:`, `Reviewed-by:`, `Acked-
  by:`, `Link:`, or `Cc: stable@vger.kernel.org` (absence of stable tags
  is expected per pipeline instructions)

**Step 1.3 — Body analysis**
Record:
- **Bug described:** PCIe tunnel setup may proceed before USB4 PCIe
  upstream/downstream adapters reach LTSSM DETECT, violating the USB4
  Connection Manager (CM) guide.
- **Symptom/failure mode:** Premature PCIe tunnel activation on USB4
  routers; can cause PCIe tunnel activation failures or unreliable
  Thunderbolt PCIe device bring-up (not explicitly described as
  crash/oops).
- **Version info:** None in commit message.
- **Root cause (author):** Missing LTSSM state verification on
  `ADP_PCIE_CS_0` before tunnel activation.

**Step 1.4 — Hidden bug fix?**
Record: **Yes.** Although framed as CM-guide compliance, this is a
timing/race fix: activation can run before adapters are ready. It adds a
bounded wait (500 ms) and fails cleanly (`-ETIMEDOUT`) instead of
proceeding in an invalid state.

---

## Phase 2: Diff Analysis

**Step 2.1 — Inventory**
Record:
- `drivers/thunderbolt/tb.h`: +1 line (declare
  `usb4_pci_port_ltssm_state()`)
- `drivers/thunderbolt/tb_regs.h`: +15 lines
  (`ADP_PCIE_CS_0_LTSSM_MASK`, `enum tb_pcie_ltssm_state`)
- `drivers/thunderbolt/tunnel.c`: +35 lines
  (`tb_pci_port_ltssm_state_detect()`, `tb_pci_pre_activate()`, hook
  assignment)
- `drivers/thunderbolt/usb4.c`: +24 lines
  (`usb4_pci_port_ltssm_state()`)
- **Total:** ~75 lines added, 0 removed
- **Functions modified/added:** `tb_pci_port_ltssm_state_detect`,
  `tb_pci_pre_activate`, `tb_tunnel_alloc_pci`,
  `usb4_pci_port_ltssm_state`
- **Scope:** Single-subsystem, surgical fix across 4 related files

**Step 2.2 — Code flow (per hunk)**
Record:
- **tb_regs.h:** Adds LTSSM bitfield mask and state enum for PCIe
  adapter CS register.
- **usb4.c:** New helper reads `ADP_PCIE_CS_0` LTSSM field via
  `tb_port_read()`.
- **tunnel.c — detect helper:** Polls every 50 ms for up to 500 ms until
  `USB4_PCIE_LTSSM_DETECT`; returns 0 on success, `-ETIMEDOUT` on
  timeout.
- **tunnel.c — pre_activate:** For USB4 routers only, checks downstream
  then upstream adapter; non-USB4 routers skip (return 0).
- **tunnel.c — alloc:** Sets `tunnel->pre_activate =
  tb_pci_pre_activate` before activation.
- **tb.h:** Exposes LTSSM read helper.

**Before → After:**
Before: `tb_tunnel_alloc_pci()` goes straight to `tb_tunnel_activate()`
→ path enable → `tb_pci_activate()`.
After: `tb_tunnel_activate()` first calls `pre_activate`, which waits
for DETECT on USB4 PCIe adapters.

**Step 2.3 — Bug mechanism**
Record:
- **Category:** Timing/race / correctness in device initialization
- **Mechanism:** Tunnel activation can start before PCIe adapters are in
  the required LTSSM DETECT state. Fix inserts a synchronization wait in
  the existing `pre_activate` hook (same pattern as DP/USB3 tunnels).

**Step 2.4 — Fix quality**
Record:
- Logic is straightforward and matches existing thunderbolt polling
  patterns (`fsleep`, bounded timeout).
- Minimal, no unrelated changes.
- **Regression risk:** Low–medium. Only applies to `tb_switch_is_usb4()`
  routers; bounded 500 ms wait; failure path is clean abort. Risk of
  false `-ETIMEDOUT` if hardware is never in DETECT at this point is
  unverified but maintainer-reviewed.

---

## Phase 3: Git History Investigation

**Step 3.1 — Blame**
Record: `tb_tunnel_alloc_pci()` dates to 2017 (Mika Westerberg). The
missing LTSSM check has been absent since PCIe tunnel support existed;
USB4-specific exposure grew with USB4 router support (e.g.
`usb4_pci_port_set_ext_encapsulation` from 2024).

**Step 3.2 — Fixes: tag**
Record: Not applicable — no `Fixes:` tag present.

**Step 3.3 — Related file history**
Record:
- Prior related fix in tree: `54967f4177d3d` (2023-12-14) — "Make PCIe
  tunnel setup and teardown follow CM guide"
- `pre_activate` infrastructure added Jan 2025 (`ae765788936d9`,
  `d6d458d42e1e1`) — used by DP/USB3, not yet PCI
- This commit is **patch 5/8** in series "Make the driver follow CM
  guide more closely" (May 2026); patches 4/6/7/8 (path hop order,
  Router Ready bit, timeout increases) are **not** in this tree
- **Standalone:** This patch compiles and functions independently; no
  hard dependency on other series patches

**Step 3.4 — Author context**
Record: Gil Fine is an active Intel thunderbolt contributor; Mika
Westerberg is subsystem maintainer. Multiple prior CM-guide compliance
commits from same authors are already in this tree.

**Step 3.5 — Dependencies**
Record: No prerequisite commits required. Local tree already has
`pre_activate` hook, `tb_switch_is_usb4()`,
`usb4_pci_port_set_ext_encapsulation()`, and `ADP_PCIE_CS_0` register
definitions.

---

## Phase 4: Mailing List and External Research

**Step 4.1 — Original discussion**
Record:
- `b4 dig -c HEAD`: No match (commit not in local tree)
- Web search found patch at [ratatoskr](https://ratatoskr.run/linux-
  usb/2026/05/8999078) as **[PATCH 5/8]** in series sent 2026-05-12 by
  Mika Westerberg
- Series cover: "Make the driver follow CM guide more closely"
- Follow-up from maintainer 2026-05-20; no stable nomination found in
  available metadata
- lore.kernel.org blocked by bot protection; full thread not readable

**Step 4.2 — Reviewers**
Record: Maintainer (Mika Westerberg) is author/submitter of series. Full
recipient list from `b4 dig -w` unavailable (commit not in tree).

**Step 4.3 — Bug reports**
Record: No `Reported-by:`, syzbot, or bugzilla links. Issue inferred
from USB4 CM guide requirement and driver behavior analysis.

**Step 4.4 — Series context**
Record: 8-patch series; this is one CM-compliance piece. Other patches
address DP allocation, lane bonding log, Router Ready bit, path hop
activation order, and timeout increases. This patch is independently
applicable but full CM compliance may need the rest of the series
eventually.

**Step 4.5 — Stable list history**
Record: Could not search lore stable list (bot protection). No stable
nomination found in ratatoskr metadata.

---

## Phase 5: Code Semantic Analysis

**Step 5.1 — Key functions**
Record: `usb4_pci_port_ltssm_state`, `tb_pci_port_ltssm_state_detect`,
`tb_pci_pre_activate`, `tb_tunnel_alloc_pci`, `tb_tunnel_activate`

**Step 5.2 — Callers**
Record:
- `tb_tunnel_alloc_pci()` called from `tb.c:tb_tunnel_pci()` and KUnit
  tests
- `tb_tunnel_activate()` called from `tb.c` at lines 975, 2038, 2298,
  2348, 3156, 3266 — hotplug, chain construction, resume paths
- `pre_activate` invoked in `tb_tunnel_activate()` at
  `tunnel.c:2395-2398` before path activation

**Step 5.3 — Callees**
Record: `usb4_pci_port_ltssm_state` → `tb_port_read()`; detect helper →
`fsleep(50)`; pre_activate → `tb_switch_is_usb4()`

**Step 5.4 — Reachability**
Record: Triggered during Thunderbolt/USB4 device hotplug and PCIe tunnel
creation — common path for docks, eGPUs, NVMe enclosures. Requires
`CONFIG_THUNDERBOLT` and USB4 hardware. Not directly userspace-syscall
reachable, but triggered by normal plug events.

**Step 5.5 — Similar patterns**
Record: DP tunnel uses `tb_dp_pre_activate()` with USB4-specific checks
(`tunnel.c:987-1011`). USB3 uses `tb_usb3_pre_activate()`.
`usb4_port_wait_for_bit()` in `usb4.c` is the established polling
pattern for USB4 register readiness.

---

## Phase 6: Cross-Reference Against Local Tree (v6.18.44)

**Step 6.1 — Buggy code present?**
Record: **Yes.** Local tree is `v6.18.44` (`VERSION=6, PATCHLEVEL=18,
SUBLEVEL=44`). Grep confirms no `ltssm`, `usb4_pci_port_ltssm_state`, or
`tb_pci_pre_activate`. `tb_tunnel_alloc_pci()` at `tunnel.c:504-514`
sets only `tunnel->activate = tb_pci_activate` with no `pre_activate`.
Bug has been present since PCIe tunnel support; USB4 exposure is
relevant for all USB4 routers in this tree.

**Step 6.2 — Backport complications**
Record: **Clean apply expected.** `pre_activate` hook,
`tb_switch_is_usb4()`, `ADP_PCIE_CS_0`, and
`usb4_pci_port_set_ext_encapsulation()` all exist. No conflicting recent
churn in the target hunks.

**Step 6.3 — Related fixes already present?**
Record: Prior CM guide fix `54967f4177d3d` (PCIe enable order) is in
tree. This LTSSM check is **not** present. No duplicate fix found.

---

## Phase 7: Subsystem and Maintainer Context

**Step 7.1 — Subsystem criticality**
Record: `drivers/thunderbolt/` — **IMPORTANT** (peripheral driver, but
affects Thunderbolt/USB4 docking, storage, displays, networking on
laptops/workstations).

**Step 7.2 — Activity**
Record: Actively maintained; recent commits include UAF fix
(`67600ccfc4f38`), wake-on-connect fix, documentation updates.

---

## Phase 8: Impact and Risk Assessment

**Step 8.1 — Who is affected**
Record: Users with USB4/Thunderbolt hardware using PCIe tunneling (docks
with PCIe slots, external GPUs, etc.). Config-specific
(`CONFIG_THUNDERBOLT`), platform-specific (systems with TB/USB4
controllers).

**Step 8.2 — Trigger conditions**
Record: USB4 router PCIe tunnel activation during hotplug/chain setup
when adapters have not yet reached LTSSM DETECT. Timing-dependent race —
more likely on slower enumeration or under load. Not unprivileged-
syscall triggered; triggered by physical plug events or resume.

**Step 8.3 — Failure mode severity**
Record:
- **Without fix:** Proceed with tunnel setup in wrong LTSSM state → PCIe
  tunnel activation failure or unreliable PCIe device enumeration.
  Severity: **MEDIUM-HIGH** (functional failure, no proven
  crash/corruption).
- **With fix:** Wait up to 500 ms; succeed when DETECT reached, or fail
  cleanly with `-ETIMEDOUT` → logged "PCIe tunnel activation failed,
  aborting" in `tb.c:2298-2302`.

**Step 8.4 — Risk/benefit**
Record:
- **Benefit:** Prevents incorrect PCIe tunnel activation timing on USB4;
  improves dock/eGPU reliability. Moderate-high for affected users.
- **Risk:** Low — ~75 lines, USB4-only guard, bounded wait, uses
  existing hook pattern.
- **Ratio:** Benefit outweighs risk for this stable tree.

---

## Phase 9: Final Synthesis

**Evidence FOR backport:**
- Fixes a real timing bug in PCIe tunnel activation on USB4 routers
- User-visible impact: Thunderbolt PCIe devices may fail to come up
- Small, self-contained (~75 lines), maintainer-signed
- All prerequisites exist in v6.18.44; expected clean apply
- Follows established `pre_activate` pattern already used for DP/USB3
- Precedent: prior CM-guide PCIe tunnel fix (`54967f4177d3d`) already in
  tree

**Evidence AGAINST backport:**
- No explicit bug report, crash trace, or syzbot finding
- Part of 8-patch CM-guide series; full fix may need companion patches
- Strict stable wording emphasizes crashes/security/corruption; this is
  robustness/functional
- Commit not yet in this tree; limited soak time in this release line

**Unresolved questions:**
- Whether adapters are always expected to reach DETECT within 500 ms at
  this point (maintainer assumption, not independently verified)
- Whether other series patches (4/6/7/8) are needed alongside this for
  complete fix
- Full lore review thread unavailable (bot protection)

### Stable Rules Checklist
1. Obviously correct and tested? **PASS** — clear logic, maintainer-
   reviewed; no `Tested-by`
2. Fixes real bug affecting users? **PASS** — timing bug in USB4 PCIe
   tunnel setup
3. Important issue? **PASS (MEDIUM-HIGH)** — PCIe tunnel failure on
   Thunderbolt hardware, not crash/corruption
4. Small and contained? **PASS** — ~75 lines, 4 files
5. No new features/APIs? **PASS** — internal driver helpers only
6. Can apply to local tree? **PASS** — prerequisites confirmed in
   v6.18.44

### Exception category
Record: Hardware workaround / CM-guide compliance for existing USB4
Thunderbolt hardware (similar to accepted quirk/workaround category).

### Problem summary for stable users
Without this check, the driver can activate PCIe tunnels before USB4
PCIe adapters reach LTSSM DETECT, violating the USB4 CM guide
sequencing. That can cause intermittent or complete failure of PCIe
tunnel bring-up — Thunderbolt docks, eGPUs, and NVMe enclosures may not
enumerate. The fix waits up to 500 ms for the correct state and aborts
cleanly on timeout.

---

## Verification

- [Phase 1] Parsed subject, tags, body from provided commit message
- [Phase 1] Confirmed no `Fixes:`, `Reported-by:`, or stable tags
- [Phase 2] Diff analysis: 4 files, ~75 lines, pre_activate hook + LTSSM
  polling
- [Phase 3] `git describe HEAD`: v6.18.44
- [Phase 3] `git blame` on `tb_tunnel_alloc_pci`: function present since
  2017
- [Phase 3] `git log --grep="CM guide"`: found `54967f4177d3d` in tree
- [Phase 3] `git log` on author Gil Fine: multiple thunderbolt commits
  in tree
- [Phase 3] Grep: `pre_activate` hook present since Jan 2025
  (`ae765788936d9`)
- [Phase 4] `b4 dig -c HEAD`: no match (commit not in tree)
- [Phase 4] Web search: found as [PATCH 5/8], series "Make the driver
  follow CM guide more closely", 2026-05-12
- [Phase 4] UNVERIFIED: Full lore thread and stable nominations (bot
  protection)
- [Phase 5] Grep callers: `tb_tunnel_alloc_pci` in `tb.c:2294`,
  `tb_tunnel_activate` at 6 call sites
- [Phase 5] Read `tb_tunnel_activate()`: `pre_activate` called before
  path activation (lines 2395-2398)
- [Phase 5] Read `tb_tunnel_pci()`: activation failure logs and returns
  `-EIO` (lines 2298-2302)
- [Phase 6] Grep: no `ltssm`/`usb4_pci_port_ltssm_state` in tree — buggy
  code confirmed present
- [Phase 6] Grep: `ADP_PCIE_CS_0`,
  `usb4_pci_port_set_ext_encapsulation`, `tb_switch_is_usb4` all present
- [Phase 6] Grep: series patches 4/6/7/8 not in tree
- [Phase 7] `git log -5` on thunderbolt files: active subsystem with
  recent bug fixes
- [Phase 8] Failure mode: PCIe tunnel activation failure, severity
  MEDIUM-HIGH

**YES**

 drivers/thunderbolt/tb.h      |  1 +
 drivers/thunderbolt/tb_regs.h | 15 +++++++++++++++
 drivers/thunderbolt/tunnel.c  | 35 +++++++++++++++++++++++++++++++++++
 drivers/thunderbolt/usb4.c    | 24 ++++++++++++++++++++++++
 4 files changed, 75 insertions(+)

diff --git a/drivers/thunderbolt/tb.h b/drivers/thunderbolt/tb.h
index 8e2762ff8d517..775ed48cc299a 100644
--- a/drivers/thunderbolt/tb.h
+++ b/drivers/thunderbolt/tb.h
@@ -1478,6 +1478,7 @@ int usb4_dp_port_allocate_bandwidth(struct tb_port *port, int bw);
 int usb4_dp_port_requested_bandwidth(struct tb_port *port);
 
 int usb4_pci_port_set_ext_encapsulation(struct tb_port *port, bool enable);
+int usb4_pci_port_ltssm_state(struct tb_port *port);
 
 static inline bool tb_is_usb4_port_device(const struct device *dev)
 {
diff --git a/drivers/thunderbolt/tb_regs.h b/drivers/thunderbolt/tb_regs.h
index 4e43b47f9f119..97404d8d878bf 100644
--- a/drivers/thunderbolt/tb_regs.h
+++ b/drivers/thunderbolt/tb_regs.h
@@ -473,10 +473,25 @@ struct tb_regs_port_header {
 
 /* PCIe adapter registers */
 #define ADP_PCIE_CS_0				0x00
+#define ADP_PCIE_CS_0_LTSSM_MASK		GENMASK(28, 25)
 #define ADP_PCIE_CS_0_PE			BIT(31)
 #define ADP_PCIE_CS_1				0x01
 #define ADP_PCIE_CS_1_EE			BIT(0)
 
+enum tb_pcie_ltssm_state {
+	USB4_PCIE_LTSSM_DETECT,
+	USB4_PCIE_LTSSM_POLLING,
+	USB4_PCIE_LTSSM_CONFIG,
+	USB4_PCIE_LTSSM_CONFIG_IDLE,
+	USB4_PCIE_LTSSM_RECOVERY,
+	USB4_PCIE_LTSSM_RECOVERY_IDLE,
+	USB4_PCIE_LTSSM_L0,
+	USB4_PCIE_LTSSM_L1,
+	USB4_PCIE_LTSSM_L2,
+	USB4_PCIE_LTSSM_DISABLED,
+	USB4_PCIE_LTSSM_HOT_RESET,
+};
+
 /* USB adapter registers */
 #define ADP_USB3_CS_0				0x00
 #define ADP_USB3_CS_0_V				BIT(30)
diff --git a/drivers/thunderbolt/tunnel.c b/drivers/thunderbolt/tunnel.c
index bfa0607b55744..6066355388b7f 100644
--- a/drivers/thunderbolt/tunnel.c
+++ b/drivers/thunderbolt/tunnel.c
@@ -296,6 +296,40 @@ static inline void tb_tunnel_changed(struct tb_tunnel *tunnel)
 			tunnel->src_port, tunnel->dst_port);
 }
 
+static int tb_pci_port_ltssm_state_detect(struct tb_port *port)
+{
+	ktime_t timeout = ktime_add_ms(ktime_get(), 500);
+
+	do {
+		int ret;
+
+		ret = usb4_pci_port_ltssm_state(port);
+		if (ret < 0)
+			return ret;
+		if (ret == USB4_PCIE_LTSSM_DETECT)
+			return 0;
+
+		fsleep(50);
+	} while (ktime_before(ktime_get(), timeout));
+
+	return -ETIMEDOUT;
+}
+
+static int tb_pci_pre_activate(struct tb_tunnel *tunnel)
+{
+	struct tb_port *down = tunnel->src_port;
+	struct tb_port *up = tunnel->dst_port;
+	int ret;
+
+	ret = tb_switch_is_usb4(down->sw) ?
+		tb_pci_port_ltssm_state_detect(down) : 0;
+	if (ret)
+		return ret;
+
+	return tb_switch_is_usb4(up->sw) ?
+		tb_pci_port_ltssm_state_detect(up) : 0;
+}
+
 static int tb_pci_set_ext_encapsulation(struct tb_tunnel *tunnel, bool enable)
 {
 	struct tb_port *port = tb_upstream_port(tunnel->dst_port->sw);
@@ -511,6 +545,7 @@ struct tb_tunnel *tb_tunnel_alloc_pci(struct tb *tb, struct tb_port *up,
 	if (!tunnel)
 		return NULL;
 
+	tunnel->pre_activate = tb_pci_pre_activate;
 	tunnel->activate = tb_pci_activate;
 	tunnel->src_port = down;
 	tunnel->dst_port = up;
diff --git a/drivers/thunderbolt/usb4.c b/drivers/thunderbolt/usb4.c
index 76f01713a8754..276c25c7d37e6 100644
--- a/drivers/thunderbolt/usb4.c
+++ b/drivers/thunderbolt/usb4.c
@@ -3145,3 +3145,27 @@ int usb4_pci_port_set_ext_encapsulation(struct tb_port *port, bool enable)
 	return tb_port_write(port, &val, TB_CFG_PORT,
 			     port->cap_adap + ADP_PCIE_CS_1, 1);
 }
+
+/**
+ * usb4_pci_port_ltssm_state() - Read PCIe adapter LTSSM state
+ * @port: PCIe adapter
+ *
+ * Return:
+ * * LTSSM state of @port.
+ * * Negative errno - On failure.
+ */
+int usb4_pci_port_ltssm_state(struct tb_port *port)
+{
+	u32 val;
+	int ret;
+
+	if (!tb_port_is_pcie_down(port) && !tb_port_is_pcie_up(port))
+		return -EINVAL;
+
+	ret = tb_port_read(port, &val, TB_CFG_PORT,
+			   port->cap_adap + ADP_PCIE_CS_0, 1);
+	if (ret)
+		return ret;
+
+	return FIELD_GET(ADP_PCIE_CS_0_LTSSM_MASK, val);
+}
-- 
2.53.0

