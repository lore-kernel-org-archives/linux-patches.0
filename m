Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A4A459B691;
	Mon, 31 Aug 2026 13:51:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184307; cv=none; b=UVPgrlpJDGX6SBdSJN0v8J2Ka45A6hVVeiU/kDafG7qw6hQC03SdHKruXIHTouBqftZT4IU6KI5/hUeOlmHVK50VKqLBtjkGsrYFkqtd0v8zCZyjdmKgPkLWW69IqrvELIjZOQFciRTCvWJZ53IBkPweq7EZKHcuef1lIcvZc6U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184307; c=relaxed/simple;
	bh=asx+tnajV6kiRQ5YLoueVZyB8w5IegjuGZzRs1QzdVs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nQrCpiA5G5aTMN9pikhchfvbytbXwmIxKTqeTtrbsmkckfpQvHBuQfGCAJO2QxZ3jgw4rseMxgipdequfIq/nD35jCODbBJevLFEKkzcKFeoi6a9DKWh26x4/bf1ul7kONcXOd++7CegIFF+efi6DExjYI7ThDRF5WZHxK6qIOA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YpEyyzzP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YpEyyzzP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 210BE1F00ADE;
	Mon, 31 Aug 2026 13:51:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788184301;
	bh=ie6oryPr3WoqCXD6Rq6VNEPbIMuHKh9ed4sfbx6lSJU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YpEyyzzPKIv9Ms7RicXi2HfSsrYtm8sAOLCRfdQxG0FjNJ24nf7Yl8/S16yyT6QLG
	 1KfQW0Z+OZg8NidE41idua7FnayZmHv8DXpOdI48xIMoFIs9r5rYVTkE6966+ZJ9hk
	 9JFkoXjP6qOVU+ElbyEncN6rDHpTklBVKaDRlGDkxzXcguMhqOE6MS8XiWGEfr9Y+U
	 ixQTX2lnPtkqlek61VwzShOqRUKMFCxcY4R9Jc00O+V4Vps0uB0/sUWNSCffVYvy0d
	 OvrvIbvhfqCWedvHEUviMz/FwBcDX3sgtovcr/zFjXYBrar8e4cvTCskcfFOZHlPxz
	 tyPuwGWA0uJSw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Ion Agorria <ion@agorria.com>,
	Svyatoslav Ryhel <clamor95@gmail.com>,
	Thierry Reding <treding@nvidia.com>,
	Sasha Levin <sashal@kernel.org>,
	robh@kernel.org,
	krzk+dt@kernel.org,
	conor+dt@kernel.org,
	thierry.reding@kernel.org,
	jonathanh@nvidia.com,
	devicetree@vger.kernel.org,
	linux-tegra@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.12] ARM: tegra: p880: Lower CPU thermal limit
Date: Mon, 31 Aug 2026 09:30:39 -0400
Message-ID: <20260831133314.4125787-611-sashal@kernel.org>
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

From: Ion Agorria <ion@agorria.com>

[ Upstream commit ece4229e457de4ceeec80890c5c760f0c858eeea ]

Lower the CPU thermal limit for the LG P880, since its chassis has less
thermal dissipation capability than the P895.

Signed-off-by: Ion Agorria <ion@agorria.com>
Signed-off-by: Svyatoslav Ryhel <clamor95@gmail.com>
Signed-off-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit Message Forensics

### Step 1.1: Subject Line
**Record:** `[ARM: tegra: p880]` `[Lower]` — Lower the CPU thermal limit
for the LG Optimus 4X HD (P880) device tree.

### Step 1.2: Commit Message Tags
**Record:**
- **Fixes:** — none
- **Reported-by:** — none
- **Tested-by:** — none
- **Reviewed-by:** — none
- **Acked-by:** — none
- **Link:** — none
- **Cc: stable:** — none (expected for manual review)
- **Signed-off-by:** Ion Agorria, Svyatoslav Ryhel, Thierry Reding
  (ignore pipeline-added SOBs)

Notable: Tegra maintainer Thierry Reding signed off and committed the
patch. No syzbot, bugzilla, or user crash reports.

### Step 1.3: Commit Body Analysis
**Record:**
- **Bug:** P880 inherits CPU thermal trip points from
  `tegra30-lg-x3.dtsi` (shared with P895). P880's chassis has less
  thermal dissipation than P895, so the inherited 75°C passive CPU
  throttle is too high.
- **Symptom:** CPU can run hotter than appropriate before passive
  throttling engages on the CPU diode sensor.
- **Version info:** None in message.
- **Root cause:** Incorrect board-specific thermal description — P880
  reuses P895/X3 thermal profile without board-specific override.

### Step 1.4: Hidden Bug Fix Detection
**Record:** Yes — described as a thermal limit adjustment, but it
corrects an incorrect hardware description in the device tree. This is a
hardware-tuning bug fix, not a cosmetic change.

---

## Phase 2: Diff Analysis

### Step 2.1: Change Inventory
**Record:**
- **Files:** `arch/arm/boot/dts/nvidia/tegra30-lg-p880.dts` (+13 / -0)
- **Functions:** N/A (device tree nodes)
- **Scope:** Single-file, board-specific surgical DT override

### Step 2.2: Code Flow Change
**Record:**
- **Hunk (end of board DTS):** Before — P880 inherits `cpu-thermal`
  trips from included `tegra30-lg-x3.dtsi` (`cpu-alert` passive trip at
  75°C). After — board DTS overrides `cpu-alert` to 60°C passive with
  200 m°C hysteresis.
- **Path affected:** Thermal framework passive throttling on CPU diode
  sensor for P880 only.

### Step 2.3: Bug Mechanism
**Record:**
- **Category:** Hardware workaround / DT correctness fix
- **Mechanism:** P880 `#include`s `tegra30-lg-x3.dtsi`, which defines
  `cpu-alert` at 75000 m°C (75°C). The board override lowers this to
  60000 m°C (60°C) to match P880's poorer thermal dissipation. Skin-
  thermal still throttles at 50°C and shuts down at 60°C on the skin
  sensor, but the CPU diode can run hotter than skin temperature during
  bursts; the inherited 75°C CPU trip was too permissive for this
  chassis.

### Step 2.4: Fix Quality
**Record:** Fix is minimal, obviously correct, and follows established
DT override patterns used on other Tegra boards. Zero impact on non-P880
systems. Regression risk is very low — only makes throttling more
conservative on one board.

---

## Phase 3: Git History Investigation

### Step 3.1: Blame / Introduction of Buggy Code
**Record:** Inherited `cpu-alert` at 75°C introduced in `b68e6e0d50c5d`
("ARM: tegra: Add device-tree for LG Optimus Vu (P895)", Feb 2024) in
`tegra30-lg-x3.dtsi`. P880 DTS added in `ea5e97e9ce046` (Feb 2024)
without a board-specific CPU thermal override. Both commits are
ancestors of the current tree.

### Step 3.2: Fixes: Tag
**Record:** N/A — no Fixes: tag present.

### Step 3.3: Related File History
**Record:**
- `ea5e97e9ce046` — initial P880 DTS
- `b49a73a08100a` — prior P880 board fix (touchscreen clipping), already
  in 6.18.44
- `ece4229e457de` — this thermal fix (mainline, not yet in 6.18.44)
- Part of series "ARM: tegra: complete a few Tegra30 device trees"
  (patch 3/9), but this hunk only touches `tegra30-lg-p880.dts` and is
  functionally standalone.

### Step 3.4: Author Context
**Record:** Svyatoslav Ryhel is the primary P880/P895 DT author. Thierry
Reding (Tegra maintainer) committed the fix. Ion Agorria is the hardware
expert who identified the thermal issue.

### Step 3.5: Dependencies
**Record:** No code dependencies on other patches in the 3/9 series.
Verified with `git apply --check` — applies cleanly to the current
6.18.44 tree.

---

## Phase 4: Mailing List and External Research

### Step 4.1: Original Patch Discussion
**Record:**
- **b4 dig URL:**
  https://patch.msgid.link/20260511074859.24930-4-clamor95@gmail.com
- **Series revisions:** v1 original (Apr 2026) and v1 RESEND (May 2026)
- **Reviewer feedback:** No NAKs found in available thread content;
  patch merged by maintainer
- **Stable nominations:** None found in thread

### Step 4.2: Reviewers
**Record:** CC'd: Rob Herring, Krzysztof Kozlowski, Conor Dooley,
Thierry Reding, Jonathan Hunter, devicetree@, linux-tegra@, linux-
kernel@. Appropriate maintainers were included.

### Step 4.3: Bug Reports
**Record:** No external bug report, syzbot link, or user crash report.
Issue identified through hardware comparison (P880 vs P895 chassis
thermal characteristics).

### Step 4.4: Related Patches
**Record:** Part of 9-patch Tegra30 DT completion series. This patch is
self-contained. Prior P880 fix (`b49a73a08100a`, touchscreen clipping)
is already in this stable tree.

### Step 4.5: Stable Mailing List
**Record:** No stable-specific discussion found for this patch.

---

## Phase 5: Code Semantic Analysis

### Step 5.1: Key Nodes Modified
**Record:** `thermal-zones/cpu-thermal/trips/cpu-alert` in board DTS
root node.

### Step 5.2: Callers / Impact Surface
**Record:** Consumed by kernel thermal framework (`drivers/thermal`) for
P880 DTB only. Triggered when `nct72` sensor 1 (CPU diode) crosses trip
temperature during normal operation.

### Step 5.3: Callees
**Record:** Standard DT thermal zone properties; no new kernel code
paths.

### Step 5.4: Reachability
**Record:** Triggered during normal device use on LG P880 when running
Linux with this DTB. Not userspace-syscall reachable, but affects all
runtime thermal management on this hardware.

### Step 5.5: Similar Patterns
**Record:** Same override pattern exists on other Tegra boards. `arm64:
dts: rockchip: reduce thermal limits on rk3399-pinephone-pro` (in this
tree) is a directly analogous DT thermal-limit correction for a tightly-
packaged mobile device.

---

## Phase 6: Cross-Reference Against Local Tree (6.18.44)

### Step 6.1: Does Buggy Code Exist?
**Record:** **Yes.** Local tree is **v6.18.44**.
`arch/arm/boot/dts/nvidia/tegra30-lg-p880.dts` exists (490 lines) and
includes `tegra30-lg-x3.dtsi`, which defines `cpu-alert` at 75°C. No
board-specific override is present. Bug present since P880 support
landed (`ea5e97e9ce046`, Feb 2024).

### Step 6.2: Backport Complications
**Record:** **Clean apply.** `git format-patch -1 ece4229e457d | git
apply --check` succeeded with no conflicts. File ends at the same
structural point (`sound { ... };` then closing `};`).

### Step 6.3: Related Fixes Already Present?
**Record:** `b49a73a08100a` (P880 touchscreen clipping) is in tree. This
thermal fix (`ece4229e457d`) is **not** in the current 6.18.44 branch
(present on `master` only).

---

## Phase 7: Subsystem Context

### Step 7.1: Subsystem and Criticality
**Record:** **ARM device tree / Tegra30 mobile platform.** Criticality:
**PERIPHERAL** — affects one specific 2012-era smartphone board.

### Step 7.2: Subsystem Activity
**Record:** Active — P880 received a board fix in 2025 (touchscreen
clipping) already merged into this stable series.

---

## Phase 8: Impact and Risk Assessment

### Step 8.1: Who Is Affected
**Record:** **Driver/board-specific** — only users running mainline
Linux on LG Optimus 4X HD (P880) with `tegra30-lg-p880.dtb`.

### Step 8.2: Trigger Conditions
**Record:** Sustained or bursty CPU load causing CPU diode temperature
to rise. Common during normal phone use. Not security-relevant;
unprivileged workload heat is the trigger.

### Step 8.3: Failure Mode Severity
**Record:** Without fix: delayed CPU passive throttling (75°C vs 60°C).
Skin sensor still provides 50°C passive / 60°C critical shutdown, but
CPU diode can exceed skin temperature. Severity: **MEDIUM** — potential
overheating, accelerated throttling only at higher temps, possible
discomfort or thermal stress; not a kernel crash or data corruption.

### Step 8.4: Risk-Benefit
**Record:**
- **Benefit:** Correct thermal protection for P880; prevents running
  with P895-inappropriate limits. Matches maintainer and hardware-author
  intent.
- **Risk:** Very low — 13-line DT-only change, board-scoped, more
  conservative throttling only.
- **Ratio:** Modest benefit (small user base) vs very low risk. Fits DT
  hardware-description correction category.

---

## Phase 9: Final Synthesis

### Step 9.1: Evidence Summary

**FOR backport:**
- Corrects incorrect DT hardware description for board already supported
  in 6.18.y
- Small (13 lines), surgical, maintainer-approved
- Applies cleanly to this tree
- DT exception category: fix for incorrect hardware description
- Precedent: similar P880 board fix already in this tree; analogous
  pinephone-pro thermal DT fix exists
- Prevents P880 from using P895 thermal profile inappropriate for its
  chassis

**AGAINST backport:**
- Very niche hardware (2012 phone, tiny mainline user base)
- No crash, corruption, security issue, or user bug report
- Skin thermal already provides some protection
- More aggressive throttling is a behavior change (performance tradeoff)
- Not in the "critical" severity categories stable rules emphasize most

**Unresolved:** No quantitative data on how often P880 exceeds 60°C CPU
temperature in practice without this fix.

### Step 9.2: Stable Rules Checklist
1. **Obviously correct and tested?** **PASS** — maintainer-merged,
   hardware-author identified issue, standard DT override pattern.
2. **Fixes a real bug affecting users?** **PASS** — incorrect thermal
   limits for supported hardware; real for P880 users.
3. **Important issue?** **PASS (borderline)** — thermal safety /
   hardware protection, not crash/corruption, but prevents running with
   wrong thermal envelope.
4. **Small and contained?** **PASS** — 13 lines, one file.
5. **No new features or APIs?** **PASS** — board-specific DT property
   override only.
6. **Can apply to local tree?** **PASS** — verified clean apply to
   6.18.44.

### Step 9.3: Exception Category
**Record:** **Device tree update** — correction of incorrect hardware
thermal description for existing supported board.

### Step 9.4: Decision Rationale

This commit fixes a real device-tree bug: P880 inherits P895/X3 CPU
thermal trip points that are too high for its chassis. The fix is
minimal, board-scoped, maintainer-approved, applies cleanly to Linux
6.18.44, and follows the same pattern as the P880 touchscreen clipping
fix already present in this stable tree. While the user base is small
and severity is thermal-tuning rather than kernel crash, stable rules
explicitly include DT fixes for incorrect hardware descriptions, and the
risk of backporting is negligible.

---

## Verification

- **[Phase 1]** Parsed subject, tags, body from provided commit message
  and `git show ece4229e457d`
- **[Phase 2]** Diff analysis: +13 lines in `tegra30-lg-p880.dts`, adds
  `thermal-zones/cpu-thermal/trips/cpu-alert` override
- **[Phase 3]** `git describe HEAD`: v6.18.44 / kernel 6.18.44
- **[Phase 3]** `git blame tegra30-lg-x3.dtsi:1777-1790`: inherited 75°C
  trip from `b68e6e0d50c5d` (Feb 2024)
- **[Phase 3]** `git merge-base --is-ancestor ea5e97e9ce046 HEAD`: P880
  DTS present in tree
- **[Phase 3]** `git merge-base --is-ancestor ece4229e457d HEAD`:
  thermal fix NOT in 6.18.44
- **[Phase 3]** `git apply --check`: patch applies cleanly to current
  tree
- **[Phase 4]** `b4 dig -c ece4229e457d`: lore URL found
- **[Phase 4]** `b4 dig -a`: v1 and v1 RESEND revisions found, part of
  9-patch series
- **[Phase 4]** `b4 dig -w`: DT and Tegra maintainers CC'd
- **[Phase 5]** Read `tegra30-lg-x3.dtsi:1727-1810`: confirmed inherited
  trips (skin 50°C/60°C, CPU 75°C/90°C)
- **[Phase 5]** Grep `tegra30-lg-p895.dts`: no board-specific thermal
  override (uses shared dtsi)
- **[Phase 6]** Read current `tegra30-lg-p880.dts`: no `thermal-zones`
  override present (490 lines)
- **[Phase 6]** `b49a73a08100a` confirmed in tree as prior P880 board
  fix
- **[Phase 7]** Subsystem: ARM Tegra30 DT, peripheral/niche
- **[Phase 8]** Failure mode: delayed CPU thermal throttling, severity
  MEDIUM

**YES**Those background searches finished and matched what the main
analysis already used:

- **Thermal limit commit search:** No `Lower CPU thermal limit` / `cpu-
  alert` override is in the 6.18.44 tree yet; the fix exists only on
  mainline as `ece4229e457d`.
- **Ion Agorria commits:** Only unrelated `drm/tegra` probe/remove PM
  work showed up locally — nothing overlapping this DTS change.

The backport recommendation stands: **YES** — a small, board-specific DT
correction that applies cleanly to 6.18.44.

 arch/arm/boot/dts/nvidia/tegra30-lg-p880.dts | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/arch/arm/boot/dts/nvidia/tegra30-lg-p880.dts b/arch/arm/boot/dts/nvidia/tegra30-lg-p880.dts
index c6ef0a20c19f3..4f57e43af6428 100644
--- a/arch/arm/boot/dts/nvidia/tegra30-lg-p880.dts
+++ b/arch/arm/boot/dts/nvidia/tegra30-lg-p880.dts
@@ -486,4 +486,17 @@ sound {
 
 		nvidia,int-mic-en-gpios = <&gpio TEGRA_GPIO(I, 6) GPIO_ACTIVE_HIGH>;
 	};
+
+	thermal-zones {
+		cpu-thermal {
+			trips {
+				cpu-alert {
+					/* throttle at 60C until temperature drops to 59.8C */
+					temperature = <60000>;
+					hysteresis = <200>;
+					type = "passive";
+				};
+			};
+		};
+	};
 };
-- 
2.53.0

