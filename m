Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8CB93B47C2;
	Mon, 20 Apr 2026 13:16:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776691012; cv=none; b=npZnbiWNPGvCzd47rXkKnEoKIQmhD65eyXWMvhOoAckrtn75MoQP8IUrTGorMjyPSUviD8iapw51t0ZAHJUCj/n5my/1FSCqhfbP5hflYX3UArff/0Bnt0AVsqBmwAuZhXjfp7D3eUB7bvajmUDOc3uVc7VodUnk/Q9rP+XtR3g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776691012; c=relaxed/simple;
	bh=o9dA1ooCdh+IbsT5sarW2ygoNheFjaid1cQ3J2MAyQo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BmxkFpw8EvAEjhhnK/cFQPTqNFQAkAaqy2kywOqn6160i9L3H1fHH4tdOKME7Ilz1Bwa5KRCM1fWmLgpXy1Rs65JAcLDy7j6BAs+pSv9U99BMkEivyaVFCvruVyKSV8chwE6v4O52LPoqzPKgq7uyDEnNkN4mHsc0Q4oV7Dzink=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=L73l+FXR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="L73l+FXR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40CEAC2BCB7;
	Mon, 20 Apr 2026 13:16:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776691012;
	bh=o9dA1ooCdh+IbsT5sarW2ygoNheFjaid1cQ3J2MAyQo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L73l+FXRBXC25yj1nVd3iCOebu0Yuczn6MwEd4LXj2tSU5iPyQ2mXBEHbL6jd/tp5
	 HbPAIEUI4JA22+qhSN6qdKZgS+Q6oHvlChnEWuiHWspydWNDfcwoHdSEQp1YY8Y+ue
	 w7mO8Y2o4vnOdF+7rawE7uNCwFOWlPrvdvWP8GwJOzWeXfzCL52/N3qGG4bJ5ufxr8
	 S2D5UGj8LufOQokB7BQZUvCfxcIMRfBMph3LvITN+4twfqmhHJJQ+YHUfU5eI3IamB
	 415JhA3sHRA56g0UsZu2yxFQeHkMvkJrf04QHX/W3HHtZ9Wgv7HBmGzYhm4+orQUM2
	 nZRs9/UZjSVVg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Frank Li <Frank.Li@nxp.com>,
	Sasha Levin <sashal@kernel.org>,
	jingoohan1@gmail.com,
	lpieralisi@kernel.org,
	kwilczynski@kernel.org,
	bhelgaas@google.com,
	linux-pci@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0-6.18] PCI: dwc: Proceed with system suspend even if the endpoint doesn't respond with PME_TO_Ack message
Date: Mon, 20 Apr 2026 09:08:28 -0400
Message-ID: <20260420131539.986432-42-sashal@kernel.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>

[ Upstream commit eed390775470ff0db32cce37a681f3acc2b941c3 ]

PCIe spec r7.0, sec 5.3.3.2.1, recommends proceeding with L2/L3 sequence
even if one or devices do not respond with PME_TO_Ack message after 10ms
timeout.

So just print a warning if the timeout happens and proceed with the system
suspend.

Reported-by: Neil Armstrong <neil.armstrong@linaro.org>
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
Signed-off-by: Manivannan Sadhasivam <mani@kernel.org>
Tested-by: Neil Armstrong <neil.armstrong@linaro.org> # on SM8650-HDK
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20260217113142.9140-1-manivannan.sadhasivam@oss.qualcomm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I have enough information to complete the full analysis. Let me
compile my findings.

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Subject Line
- **Subsystem:** PCI: dwc
- **Action verb:** "Proceed" (implies fixing incorrect behavior where it
  was NOT proceeding)
- **Summary:** Continue system suspend when a PCIe endpoint doesn't
  respond with PME_TO_Ack

### Step 1.2: Tags
- **Reported-by:** Neil Armstrong <neil.armstrong@linaro.org> — Linaro
  engineer, real-world issue on Qualcomm SM8650-HDK
- **Tested-by:** Neil Armstrong <neil.armstrong@linaro.org> # on
  SM8650-HDK — Hardware-verified
- **Reviewed-by:** Frank Li <Frank.Li@nxp.com> — Major DWC PCI
  contributor at NXP
- **Signed-off-by:** Manivannan Sadhasivam — DWC PCI subsystem
  maintainer (both @oss.qualcomm.com and @kernel.org)
- **Link:** patch.msgid.link for the v2 patch
- **No Fixes: tag** — expected for autosel candidates
- **No Cc: stable** — expected for autosel candidates

### Step 1.3: Commit Body
The commit references PCIe spec r7.0, sec 5.3.3.2.1, which explicitly
recommends proceeding with L2/L3 sequence even when devices don't
respond with PME_TO_Ack within 10ms. The current code aborts system
suspend entirely when this timeout occurs, which is overly conservative
and blocks real-world hardware.

**Bug:** System suspend fails when any PCIe endpoint doesn't respond
with PME_TO_Ack within 10ms timeout.
**Symptom:** `dev_err` + return error from `dw_pcie_suspend_noirq()`,
preventing suspend.
**Root cause:** Code treated a non-fatal timeout as fatal, contrary to
spec recommendation.

### Step 1.4: Hidden Bug Fix Assessment
This is a clear behavior fix. "Proceed with system suspend" = "stop
incorrectly aborting suspend". This is a real bug fix where the
implementation deviates from the PCIe specification.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory
- **Files changed:** 1 (`drivers/pci/controller/dwc/pcie-designware-
  host.c`)
- **Lines changed:** ~7 lines modified within a single error-handling
  block
- **Functions modified:** `dw_pcie_suspend_noirq()`
- **Scope:** Single-file, surgical fix to one error path

### Step 2.2: Code Flow Change
**Before:** When `read_poll_timeout()` returns error (endpoint didn't
reach L2 state in 10ms):
- `dev_err()` prints an error
- `return ret;` aborts the entire suspend

**After:**
- `dev_warn()` prints a warning
- `ret = 0;` clears the error
- Execution continues through `udelay(1)`, `dw_pcie_stop_link()`, and
  `deinit()` to complete suspend

### Step 2.3: Bug Mechanism
Category: **Logic/correctness fix** — the code was treating a non-fatal
spec-compliant condition as fatal. The PCIe spec explicitly says to
proceed with L2/L3 sequence even without PME_TO_Ack.

### Step 2.4: Fix Quality
- **Obviously correct:** Yes — directly implements PCIe spec r7.0
  recommendation
- **Minimal:** Yes — 2-line essential change (dev_err→dev_warn,
  return→ret=0)
- **Regression risk:** Very low — previous behavior blocked suspend
  entirely; new behavior allows suspend to proceed per spec
- **Red flags:** None

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame
The error-returning code was introduced by commit `4774faf854f534`
("PCI: dwc: Implement generic suspend/resume functionality") by Frank
Li, merged in v6.6. The comment was modified by `112aba9a79345a`
(Richard Zhu, v6.15).

**Record:** Buggy code present since v6.6 in all stable trees through
v6.16.

### Step 3.2: No Fixes tag to follow (expected).

### Step 3.3: File History
Related recent commits in this area:
- `58a17b2647ba5` — skip_l23_ready flag (v7.0 only, Cc: stable)
- `cfd2fdfd0a8da` — skip PME_Turn_Off if link not up (v7.0 only)
- `112aba9a79345a` — additional LTSSM state checks (v6.15)
- `4774faf854f534` — original implementation (v6.6)

### Step 3.4: Author
Manivannan Sadhasivam IS the DWC PCI subsystem maintainer. He signed-off
with both his Qualcomm and kernel.org addresses. He applied his own
patch to his tree (commit `eed390775470ff0db32cce37a681f3acc2b941c3`).

### Step 3.5: Dependencies
The core fix applies independently of other commits. The same `if (ret)
{ dev_err(); return ret; }` pattern exists in all versions from v6.6
through v7.0. Context lines differ slightly between versions, requiring
minor conflict resolution but no functional dependencies.

---

## PHASE 4: MAILING LIST RESEARCH

### Step 4.1: Original Submission
Found via web search and spinics.net mirrors:
- **v1:** Missing `ret = 0`, would pass error to callers
- **v2:** Added `ret = 0` to properly clear the error (applied version)
- Applied by maintainer on Feb 26, 2026

### Step 4.2: Reviewers
- **Frank Li (NXP):** Gave Reviewed-by, major DWC PCI contributor
- **Neil Armstrong (Linaro):** Reporter and tester on SM8650-HDK
- No NAKs or objections

### Step 4.3: Bug Report
Neil Armstrong reported the issue. His Tested-by comment says: "Allows
ath12k to go into d3cold" — the WiFi chip (ath12k) on Qualcomm
SM8650-HDK doesn't respond with PME_TO_Ack in time, blocking suspend.

### Step 4.4: Related Patches
The skip_l23_ready patch (58a17b2647ba5) is a separate fix for
i.MX6QP/i.MX7D platforms and was explicitly tagged Cc: stable. This
PME_TO_Ack patch is a different fix addressing a broader issue.

### Step 4.5: Stable Discussion
The skip_l23_ready patch was Cc'd to stable with explicit `Fixes:` tag.
This patch was not Cc'd to stable, which is why it's under review.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Functions Modified
Only `dw_pcie_suspend_noirq()` is modified.

### Step 5.2: Callers
Verified callers in each stable tree:
- **v6.6:** `pci-layerscape.c`
- **v6.12:** `pci-layerscape.c`
- **v6.15:** `pci-layerscape.c`, `pci-imx6.c`
- **v6.16:** `pci-layerscape.c`, `pci-imx6.c`
- **v7.0:** `pci-layerscape.c`, `pci-imx6.c`, `pcie-stm32.c`, `pcie-
  nxp-s32g.c`

### Step 5.3: Call chain
`dw_pcie_suspend_noirq()` is called during system suspend from platform-
specific PM callbacks. This is triggered whenever the system enters
suspend (e.g., `echo mem > /sys/power/state`).

### Step 5.4: Reachability
Reachable from userspace via system suspend on any platform with a DWC
PCIe controller and an endpoint that doesn't respond to PME_TO_Ack in
time.

---

## PHASE 6: STABLE TREE ANALYSIS

### Step 6.1: Buggy Code in Stable
The buggy `return ret;` on L2 timeout exists in ALL stable trees from
v6.6 through v6.16. Verified by examining the function body in each
version.

### Step 6.2: Backport Complexity
The core fix (`dev_err→dev_warn`, `return ret→ret=0`) applies to the
same code pattern in all versions. Context lines differ (skip_l23_ready
block doesn't exist in v6.6-v6.16, DETECT_WAIT check only in v6.15+), so
the patch won't apply cleanly but needs trivial adjustment.

### Step 6.3: Related Fixes
No other fix for this specific issue is in stable. The skip_l23_ready
patch (Cc: stable) is a different fix for different hardware.

---

## PHASE 7: SUBSYSTEM CONTEXT

### Step 7.1: Subsystem
PCI controller driver (DWC — DesignWare Core). This is an IMPORTANT
subsystem — DWC is the most widely used PCIe IP block, found in
Qualcomm, NXP (LayerScape, i.MX), STM32, Samsung, and many other SoCs.

### Step 7.2: Activity
Very actively developed, with significant refactoring between versions.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: Affected Users
Users of DWC-based PCIe platforms (LayerScape, i.MX, STM32, S32G) who
attempt system suspend with endpoints that don't respond to PME_TO_Ack
within 10ms.

### Step 8.2: Trigger
System suspend on a DWC PCIe platform with a non-compliant or slow-
responding PCIe endpoint. The ath12k WiFi chip is a known trigger.

### Step 8.3: Severity
**Failure mode:** System suspend fails entirely — the system cannot
enter sleep.
**Severity:** HIGH — prevents power management on affected hardware.

### Step 8.4: Risk-Benefit
- **Benefit:** HIGH — prevents suspend failure on real hardware, aligns
  with PCIe spec
- **Risk:** VERY LOW — 2-line change, obviously correct per spec, no
  possible crash or data corruption from the fix itself (it only allows
  suspend to proceed as the spec recommends)

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence Summary
**FOR backporting:**
- Fixes real-world suspend failure reported by Linaro engineer on
  SM8650-HDK
- PCIe spec r7.0 explicitly recommends this behavior
- Fix is 2 essential lines (dev_err→dev_warn, return ret→ret=0)
- Author is DWC PCI subsystem maintainer
- Reviewed-by from NXP contributor, Tested-by from reporter
- Buggy code exists in all stable trees v6.6+
- No regression risk — the alternative (current behavior) is worse
  (blocks suspend)

**AGAINST backporting:**
- No explicit Cc: stable or Fixes: tag (expected)
- Behavior change rather than crash fix (but prevents functional
  failure)
- Minor context conflicts in older stable trees (trivially resolvable)
- Limited callers in older stable trees (mainly layerscape in
  v6.6-v6.12)

### Step 9.2: Stable Rules Checklist
1. **Obviously correct and tested?** YES — per PCIe spec, tested on
   hardware
2. **Fixes a real bug?** YES — suspend failure with certain endpoints
3. **Important issue?** YES — prevents system from suspending
4. **Small and contained?** YES — 2-line change in one function
5. **No new features?** CORRECT — no new features
6. **Can apply to stable?** YES — with trivial context adjustments

### Step 9.3: Exception Categories
Not a standard exception category, but this is a straightforward bug fix
that aligns implementation with PCIe specification.

---

## Verification

- [Phase 1] Parsed tags: Reported-by Neil Armstrong (Linaro), Tested-by
  Neil Armstrong on SM8650-HDK, Reviewed-by Frank Li (NXP)
- [Phase 2] Diff analysis: 2-line essential change in error handler of
  `dw_pcie_suspend_noirq()`: dev_err→dev_warn, return ret→ret=0
- [Phase 3] git blame: buggy code introduced in 4774faf854f534 (v6.6),
  confirmed present in v6.6 through v6.16
- [Phase 3] git merge-base: confirmed 4774faf854f534 is in v6.6, v6.7,
  ..., v6.16
- [Phase 3] Author (Manivannan Sadhasivam) is the DWC PCI subsystem
  maintainer, applied his own patch
- [Phase 4] Found v1 and v2 on spinics.net; v1 missed `ret = 0`, v2
  fixed it. Applied on Feb 26, 2026
- [Phase 4] Frank Li gave Reviewed-by; Neil Armstrong confirmed it fixes
  ath12k D3cold on SM8650-HDK
- [Phase 4] No NAKs, no objections in review
- [Phase 5] Callers verified: layerscape (v6.6+), imx6 (v6.15+),
  stm32/s32g (v7.0 only)
- [Phase 6] Buggy `dev_err(); return ret;` pattern verified in v6.6,
  v6.12, v6.15, v6.16 — all return error on timeout
- [Phase 6] Backport complexity: minor context differences, trivially
  resolvable
- [Phase 8] Failure mode: system suspend blocked entirely; severity HIGH
  for affected users
- UNVERIFIED: Exact set of PCIe endpoints that trigger this timeout
  (only ath12k confirmed); does not affect decision

The fix is small, surgical, spec-compliant, tested on real hardware,
authored and merged by the subsystem maintainer, and prevents real-world
suspend failures on DWC PCIe platforms.

**YES**

 drivers/pci/controller/dwc/pcie-designware-host.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/pci/controller/dwc/pcie-designware-host.c b/drivers/pci/controller/dwc/pcie-designware-host.c
index 6ae6189e9b8a9..ba183fc3e77cd 100644
--- a/drivers/pci/controller/dwc/pcie-designware-host.c
+++ b/drivers/pci/controller/dwc/pcie-designware-host.c
@@ -1256,9 +1256,13 @@ int dw_pcie_suspend_noirq(struct dw_pcie *pci)
 				PCIE_PME_TO_L2_TIMEOUT_US/10,
 				PCIE_PME_TO_L2_TIMEOUT_US, false, pci);
 	if (ret) {
-		/* Only log message when LTSSM isn't in DETECT or POLL */
-		dev_err(pci->dev, "Timeout waiting for L2 entry! LTSSM: 0x%x\n", val);
-		return ret;
+		/*
+		 * Failure is non-fatal since spec r7.0, sec 5.3.3.2.1,
+		 * recommends proceeding with L2/L3 sequence even if one or more
+		 * devices do not respond with PME_TO_Ack after 10ms timeout.
+		 */
+		dev_warn(pci->dev, "Timeout waiting for L2 entry! LTSSM: 0x%x\n", val);
+		ret = 0;
 	}
 
 	/*
-- 
2.53.0

