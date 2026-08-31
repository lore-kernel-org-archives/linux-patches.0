Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99E2A470455;
	Mon, 31 Aug 2026 13:35:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183310; cv=none; b=RfkxnXWiG5lYznF84jXcm/9Ur7wJUbdB2sUGRnFOaIsFhFJY0WmG+E7nV7ljJxwm3nPTC6Oco04+icFQuc0YU340LngiUbdG5HAyYS7+uapTMh4SXPXUAnuj3sRxxvjo75jDXChd017Zt7MVIb6Zk2GapSkHC/3A/xZ5n4/o2QU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183310; c=relaxed/simple;
	bh=OVjf06JRCvFuzAm1UXqhHuLNphqfsIpKEiv5TW9BQa0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=C7KQwxELPKWHMskuXK2zP2J9Hz6lHqFdCh7E3vyn29PZzdyw/vWwPj+UMsrC0k6oi592Dqqh2JVFodetnziOUfXxN/zehhokMDcU4dMljjKuqjh2XkhtRUQlMthBGYAUDsw1tFI5j6TEUAO51q09FlPttsLm2HtwSyF4IT6u2lg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZBbswKlJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZBbswKlJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CEC31F00A3E;
	Mon, 31 Aug 2026 13:35:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183308;
	bh=J0Nq366BAGIG1gcnherdZDA/ld6mwmg+zHYtKePa+cE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZBbswKlJ4rdo4IKp9NMsXKRk0ZQ7icsFk+HJRMzUY2zkVwg1jHDlanjy/+Pgu98qT
	 fAKCtQSvsu5FJnug8Yajld+MyuKhi+67wJcxHWW5q0/WpXfoRsAbPWlqwGFC8UI5OJ
	 Q6K9CNqJ1vktWTqN+I+22qcY491sslAxA1bgh/GH6Vg0nOc8qAILoCPVQlDKdrMKyW
	 Qdw+Q6BloaVr0aS3Sd6sc8E73FmIYSnFCnz62KsfzxkEHsF05/4bsgg6c7ZJd225Ic
	 M3WYhOGNlL6/dOaCBsnimDQTduOMWB/cW6w3ExsleCTgy4c1FyCK3e4vCObvEpWaSx
	 4U4+BPg07bnaA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Adrian Ng Ho Yin <adrian.ho.yin.ng@altera.com>,
	Dinh Nguyen <dinguyen@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	sboyd@kernel.org,
	bmasney+clk@redhat.com,
	jbrunet+clk@baylibre.com,
	linux-clk@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] clk: socfpga: agilex: implement l3_main_free_clk
Date: Mon, 31 Aug 2026 09:21:39 -0400
Message-ID: <20260831133314.4125787-71-sashal@kernel.org>
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

From: Adrian Ng Ho Yin <adrian.ho.yin.ng@altera.com>

[ Upstream commit 1e7f56205813a2c48cdb3e9a4b0a24f49fd9a548 ]

The AGILEX_L3_MAIN_FREE_CLK is defined in the dt-bindings header but
was never implemented in the clock driver. Per the Agilex TRM,
l3_main_free_clk has no divider or mux and is a fixed 1:1 derivative
of noc_free_clk that clocks most of the interconnect datapath.

Signed-off-by: Adrian Ng Ho Yin <adrian.ho.yin.ng@altera.com>
Signed-off-by: Dinh Nguyen <dinguyen@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Connection lost, reconnecting to https://agentn.us.api5.cursor.sh
(attempt 1)...
Retry attempt 1...
# Stable Backport Analysis: `clk: socfpga: agilex: implement
l3_main_free_clk`

**Local tree:** `v6.18.44` (`linux-6.18.y`, detached at
`stable/linux-6.18.y`)
**Commit under review:** `1e7f56205813a2c48cdb3e9a4b0a24f49fd9a548` (not
present in this tree; `merge-base --is-ancestor` exit code 1)

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Subject line
**Record:** `[clk/socfpga/agilex] [implement] [register missing
l3_main_free_clk clock in Agilex clock driver]`

### Step 1.2: Tags
**Record:**
- **Fixes:** none
- **Reported-by:** none
- **Tested-by:** none
- **Reviewed-by:** none
- **Acked-by:** none
- **Link:** none
- **Cc: stable:** none
- **Signed-off-by:** Adrian Ng Ho Yin, Dinh Nguyen (ignore pipeline SOB
  markers)

No syzbot, no user reports, no explicit stable nomination.

### Step 1.3: Body analysis
**Record:**
- **Bug:** `AGILEX_L3_MAIN_FREE_CLK` is defined in `agilex-clock.h` but
  never registered in `clk-agilex.c`.
- **Symptom:** Any device tree node requesting clock index 18 from
  `clkmgr` gets `-ENOENT` from the clock provider.
- **Root cause:** Incomplete driver implementation; per Agilex TRM,
  `l3_main_free_clk` is a fixed 1:1 derivative of `noc_free_clk` with no
  mux/divider register.
- **Version info:** Merged to mainline for v7.2 (May 2026); absent from
  this 6.18.y tree.

### Step 1.4: Hidden bug fix?
**Record:** Yes. Subject says "implement," but this closes a DT/driver
mismatch: bindings and DTS reference a clock the provider never exposes.
That is a functional bug, not cosmetic cleanup.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory
**Record:**
- **Files:** `drivers/clk/socfpga/clk-agilex.c` (+2 lines)
- **Function/table:** `agilex_main_perip_cnt_clks[]`
- **Scope:** Single-file, surgical (2-line addition)

### Step 2.2: Code flow change
**Record:**
- **Before:** `agilex_main_perip_cnt_clks[]` jumps from
  `AGILEX_NOC_FREE_CLK` (19) to `AGILEX_L4_SYS_FREE_CLK` (3). Index 18
  (`AGILEX_L3_MAIN_FREE_CLK`) is never registered; `hws[18]` stays
  `ERR_PTR(-ENOENT)`.
- **After:** Index 18 is registered as `"l3_main_free_clk"` with parent
  `"noc_free_clk"`, `num_parents=1`, `offset=0`, `fixed_divider=1` (1:1
  passthrough, no HW register).
- **Path affected:** Clock provider registration at `clkmgr` probe;
  consumers resolving phandle index 18.

### Step 2.3: Bug mechanism
**Record:**
- **Category:** Logic/correctness — incomplete clock provider vs. DT
  bindings.
- **Mechanism:** `agilex_clkmgr_init()` initializes all `hws[i]` to
  `ERR_PTR(-ENOENT)`; only registered clocks are filled. Missing
  registration leaves index 18 unusable.

### Step 2.4: Fix quality
**Record:**
- **Quality:** High. Matches existing `stratix10_perip_cnt_clock`
  pattern; `fixed_divider=1` + `offset=0` correctly models a register-
  less 1:1 clock.
- **Regression risk:** Very low. Adds one leaf clock derived from
  already-registered `noc_free_clk`.

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame
**Record:** `agilex_main_perip_cnt_clks[]` present in current tree
without `L3_MAIN_FREE_CLK` entry (blame points to base v6.18 import).
Omission present since Agilex clock driver landed in this tree.

### Step 3.2: Fixes: tag
**Record:** N/A — no `Fixes:` tag.

### Step 3.3: Related file history
**Record:** Shallow clone limits history depth. Verified on current
tree: `AGILEX_L3_MAIN_FREE_CLK` exists in `include/dt-
bindings/clock/agilex-clock.h` (id 18) and
`arch/arm64/boot/dts/intel/socfpga_agilex.dtsi` (SMMU `clocks`
property). Driver never registered it. Standalone one-patch fix (not
part of a series).

### Step 3.4: Author context
**Record:** Adrian Ng Ho Yin (Altera/Intel). Dinh Nguyen
(`dinguyen@kernel.org`) is SoCFPGA clk maintainer and committed the
patch. No other related fixes found in this tree from same author.

### Step 3.5: Dependencies
**Record:** No prerequisites. Patch applies cleanly (`git apply --check`
exit 0). All structures (`stratix10_perip_cnt_clock`,
`s10_register_cnt_periph`) exist in this tree.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: Original discussion
**Record:**
- **b4 dig URL:** https://patch.msgid.link/9f35b944a8bfc79ff17e645d2d366
  2824e57cffa.1779439821.git.adrian.ho.yin.ng@altera.com
- **Series:** v1 only (2026-05-22)
- **Review feedback:** Could not read thread (Anubis bot wall on
  patch.msgid.link). No replies visible via b4.

### Step 4.2: Reviewers CC'd
**Record:** Adrian Ng Ho Yin, Dinh Nguyen, Michael Turquette, Stephen
Boyd, Brian Masney, linux-clk@, linux-kernel@ — appropriate clk
maintainers included.

### Step 4.3: Bug reports
**Record:** None found. No syzbot, no bugzilla, no user reports.

### Step 4.4: Related patches
**Record:** Standalone; pulled via `socfpga_clk_update_for_v7.2` tag. No
other patches required.

### Step 4.5: Stable list history
**Record:** Not searched (no stable nomination found; lore inaccessible
for full thread).

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Key functions
**Record:** `agilex_main_perip_cnt_clks[]`,
`agilex_clk_register_cnt_perip()`, `s10_register_cnt_periph()`,
`agilex_clkmgr_init()`

### Step 5.2: Callers
**Record:** `agilex_clk_register_cnt_perip()` called from
`agilex_clkmgr_init()` during `clkmgr` platform probe. Consumers use OF
phandle indices via `of_clk_add_hw_provider(..., of_clk_hw_onecell_get,
...)`.

### Step 5.3: Callees
**Record:** `s10_register_cnt_periph()` → `clk_hw_register()` with
`peri_cnt_clk_ops` (`clk_peri_cnt_clk_recalc_rate` uses `fixed_div` when
set).

### Step 5.4: Reachability
**Record:**
- **Consumer:** `smmu: iommu@fa000000` in `socfpga_agilex.dtsi` lists
  `<&clkmgr AGILEX_L3_MAIN_FREE_CLK>` as second of three clocks.
- **Driver:** `arm-smmu.c` calls `devm_clk_bulk_get_all()` at probe;
  failure returns error and aborts probe (`"failed to get clocks %d"`).
- **Trigger:** Enabling SMMU (`status = "okay"`) on an Agilex board.
- **Current in-tree boards:** `socfpga_agilex_socdk.dts`,
  `socfpga_agilex_n6000.dts` do **not** enable `&smmu`; base dtsi has
  `status = "disabled"`.

### Step 5.5: Similar patterns
**Record:** Stratix10 driver has similar fixed-parent entries (e.g.
`STRATIX10_MAIN_EMACA_CLK` with single parent, `fixed_divider=0`).
Agilex `noc_free_clk` neighbor entries use mux tables; L3 entry
correctly uses direct parent instead.

---

## PHASE 6: CROSS-REFERENCING AGAINST LOCAL TREE

### Step 6.1: Buggy code exists?
**Record:** **Yes.** Verified in v6.18.44:
- `include/dt-bindings/clock/agilex-clock.h:32` defines
  `AGILEX_L3_MAIN_FREE_CLK` as 18
- `socfpga_agilex.dtsi:446-448` references it for SMMU
- `clk-agilex.c:257-279` omits it from `agilex_main_perip_cnt_clks[]`

### Step 6.2: Backport complications
**Record:** Clean apply expected (verified with `git apply --check`). No
structural conflicts; insertion point between `NOC_FREE_CLK` and
`L4_SYS_FREE_CLK` matches mainline context.

### Step 6.3: Related fixes already present?
**Record:** None. `git log --grep="l3_main_free"` returns no matches in
this tree.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

### Step 7.1: Subsystem criticality
**Record:** `drivers/clk/socfpga/` — **PERIPHERAL** (Intel SoCFPGA
Agilex platform-specific clock driver).

### Step 7.2: Subsystem activity
**Record:** Agilex platform actively maintained; this is a gap in
existing support, not new subsystem introduction.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: Who is affected
**Record:** Users of Intel SoCFPGA Agilex with SMMU enabled in device
tree. Not universal; platform- and config-specific.

### Step 8.2: Trigger conditions
**Record:** SMMU node enabled + `arm,smmu-v2` probe runs +
`devm_clk_bulk_get_all()` resolves three `clocks` entries. **Not
triggered** on default in-tree Agilex boards (SMMU disabled). Custom DT
or future boards enabling IOMMU would hit this.

### Step 8.3: Failure mode severity
**Record:** SMMU probe failure (`-ENOENT` from clock core). **Severity:
MEDIUM** — blocks IOMMU enablement, not a kernel panic on default boot.
IOMMU is a security/isolation feature when enabled.

### Step 8.4: Risk-benefit
**Record:**
- **Benefit:** MEDIUM — unblocks SMMU on Agilex; corrects longstanding
  DT/driver inconsistency.
- **Risk:** VERY LOW — 2 lines, no API change, no locking changes.
- **Ratio:** Favorable for backport given trivial fix and verified
  correctness.

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence summary

**FOR backport:**
- Verified DT/driver mismatch: binding + DTS reference clock id 18;
  driver never registers it.
- Verified failure path: `arm-smmu` `devm_clk_bulk_get_all()` fails
  probe when clock missing.
- Fix is 2 lines, applies cleanly, matches TRM (1:1 `noc_free_clk`
  derivative).
- Obviously correct; maintainer-committed.
- Low regression risk.

**AGAINST backport:**
- No user reports, syzbot, or `Cc: stable`.
- SMMU `status = "disabled"` on base dtsi; no in-tree Agilex board
  enables it today.
- Default boot unaffected; impact only when SMMU explicitly enabled.
- Commit message frames this as "implement" (completing missing
  support).
- Peripheral platform; narrow user base.

**Unresolved:** Full lore review thread (bot-blocked). No confirmation
of production SMMU deployments on 6.18.y Agilex.

### Step 9.2: Stable rules checklist
1. Obviously correct and tested? **PASS** — matches TRM and existing
   driver patterns; no Tested-by but logic is straightforward.
2. Fixes a real bug affecting users? **PASS** — DT references clock
   provider does not expose; SMMU probe fails when enabled.
3. Important issue? **PASS (borderline)** — probe failure blocking IOMMU
   (MEDIUM severity), not crash/corruption on default config.
4. Small and contained? **PASS** — 2 lines, one file.
5. No new features or APIs? **PASS** — completes existing binding; no
   new uapi.
6. Can apply to local tree? **PASS** — verified clean apply.

### Step 9.3: Exception categories
**Record:** None strictly. Closest analog is hardware/platform
enablement completeness (not a device-ID or quirk entry).

### Step 9.4: Decision rationale

This is a verified driver bug: device tree and bindings promise
`AGILEX_L3_MAIN_FREE_CLK`, but the clock provider leaves index 18 as
`-ENOENT`. Enabling the Agilex SMMU (already described in
`socfpga_agilex.dtsi`) will fail probe. While no in-tree board enables
SMMU today, the inconsistency has been present since Agilex support
landed in this tree, and the two-line fix is trivial, correct, and risk-
free. Stable trees routinely take such platform driver completeness
fixes when they unblock real hardware paths defined in shipped DTS.

---

## Verification

- **[Phase 1]** Parsed commit message and tags from `git show
  1e7f562058`
- **[Phase 2]** Read diff and `clk-agilex.c`, `clk-periph-s10.c`,
  `stratix10-clk.h` in tree
- **[Phase 3]** `git describe HEAD` → `v6.18.44`; `merge-base --is-
  ancestor 1e7f562058 HEAD` → exit 1 (not in tree)
- **[Phase 3]** `git blame` on `agilex_main_perip_cnt_clks[]` — L3 entry
  absent
- **[Phase 3]** `git apply --check` on patch → exit 0 (clean apply)
- **[Phase 4]** `b4 dig -c 1e7f562058` → lore URL found; v1 only; CC
  list retrieved
- **[Phase 4]** `b4 dig -w` → maintainers CC'd
- **[Phase 4]** WebFetch lore → blocked by Anubis (UNVERIFIED: review
  thread content)
- **[Phase 5]** Grep `AGILEX_L3_MAIN_FREE_CLK` — binding + DTS present,
  driver absent
- **[Phase 5]** Read `arm-smmu.c:2178-2187` — `devm_clk_bulk_get_all()`
  fails probe on missing clock
- **[Phase 5]** Read `socfpga_agilex.dtsi:402-449` — SMMU uses clock,
  `status = "disabled"`
- **[Phase 5]** Grep board DTS files — no `&smmu { status = "okay" }` in
  intel agilex boards
- **[Phase 6]** Confirmed buggy omission in v6.18.44 checkout
- **[Phase 6]** `git show origin/master:clk-agilex.c` — fix present on
  mainline
- **[Phase 8]** Assessed SMMU-disabled default → MEDIUM not CRITICAL
  severity

**YES****Verdict: YES** — backport to this tree (`linux-6.18.y` /
v6.18.44).

`AGILEX_L3_MAIN_FREE_CLK` is defined in the dt-bindings and referenced
by the Agilex SMMU node in `socfpga_agilex.dtsi`, but `clk-agilex.c`
never registers it. If SMMU is enabled, `arm-smmu` probe fails on
`devm_clk_bulk_get_all()` because clock index 18 stays `-ENOENT`.

The fix is two lines, applies cleanly, and matches the TRM (fixed 1:1
derivative of `noc_free_clk`). No in-tree Agilex boards enable SMMU
today, but the DT/driver mismatch is real and the change is low risk.

 drivers/clk/socfpga/clk-agilex.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/clk/socfpga/clk-agilex.c b/drivers/clk/socfpga/clk-agilex.c
index 8dd94f64756b9..2bdea1997b5ef 100644
--- a/drivers/clk/socfpga/clk-agilex.c
+++ b/drivers/clk/socfpga/clk-agilex.c
@@ -259,6 +259,8 @@ static const struct stratix10_perip_cnt_clock agilex_main_perip_cnt_clks[] = {
 	   0, 0x3C, 0, 0, 0},
 	{ AGILEX_NOC_FREE_CLK, "noc_free_clk", NULL, noc_free_mux, ARRAY_SIZE(noc_free_mux),
 	  0, 0x40, 0, 0, 0},
+	{ AGILEX_L3_MAIN_FREE_CLK, "l3_main_free_clk", "noc_free_clk", NULL,
+	  1, 0, 0, 1, 0, 0},
 	{ AGILEX_L4_SYS_FREE_CLK, "l4_sys_free_clk", NULL, noc_mux, ARRAY_SIZE(noc_mux), 0,
 	  0, 4, 0x30, 1},
 	{ AGILEX_EMAC_A_FREE_CLK, "emaca_free_clk", NULL, emaca_free_mux, ARRAY_SIZE(emaca_free_mux),
-- 
2.53.0

