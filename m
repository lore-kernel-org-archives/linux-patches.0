Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68A2556FA5E;
	Mon, 31 Aug 2026 13:48:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184119; cv=none; b=CZbDQmZ4uLpaOuF2HuQKTpZYi8JwxDk0Me/e1bwlUh4KcuGxxnP2yCGUacrnSTiO4XjxKb3ZQDMCrVI7UXPDcNR4jEPlBUOrNnBCKh5iXbeZdoVNCP9oPxNNP8OWbaosRW0fJKms6q+mounJ9F8/VuUORVAW3AeWAumH0m2B3EM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184119; c=relaxed/simple;
	bh=oDroo2WiPTU90nvz2/0npryiyyfLGXDy2Hy3NzJEsPM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uLGYorS/cqrGUTwbNi4wYCXJGgeYmGEIxa4SZHbqF7IofSAfrroTCkzMJbHijtC4TxDDxWjzP4Ov9+m43PhPVNJXoMmba0ZwNZXRMZ2HxHDalLG2NqSFt1dBiTAGtYt0BIbPTc+rvCKGJGeSgKIf4RJojyLfxruB4QKqiQBEREs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NipMI7oO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NipMI7oO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E79061F00ACA;
	Mon, 31 Aug 2026 13:48:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788184116;
	bh=sRR5RzAfZF2ygozG/qavqvPeChy7+XYeXV4CDkN88MM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NipMI7oOpWJpEntVg0UXpciHQWk1UP2b8FmPcMFTjVVrCLQR+u1a+ylYhmqi7tBhb
	 AKWlQzqNUuVd+40RZ0B7OHrwZD9nZB3UUrZJL+qsFMOU40KR1+Y/0JaatwTvWQ/QdZ
	 HR5HGZEh48SeSifIPKxDA8kihDyJpMcuTUgyFij8XZwf9b4Y+oWmk5nr98aTlfaNwL
	 UEJmY654ud2HkVlU4J2AEYyagDvUFkRmUR5BSDe5lbrFL/KVrnztChBcSQW5F+Tzr8
	 0136PGo49b8UirOLIn5Qit/Izia1QtgrR8xCRRHOsTCZANjtQjxtQWMYV5g6XvMLod
	 616c3Bb0WWOdQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Wesley Cheng <wesley.cheng@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Abel Vesa <abel.vesa@oss.qualcomm.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	linux-arm-msm@vger.kernel.org,
	linux-phy@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] phy: qcom: m31-eusb2: Make USB repeater optional
Date: Mon, 31 Aug 2026 09:28:49 -0400
Message-ID: <20260831133314.4125787-501-sashal@kernel.org>
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

From: Wesley Cheng <wesley.cheng@oss.qualcomm.com>

[ Upstream commit a62bfbcf2db4ae6eb7a544a40b1075a81784ea41 ]

A repeater is not required for the PHY to function. On systems with
multiple PHY instances connected to a multi-port controller, some PHYs
may be unconnected. All PHYs must still probe successfully even without
attached repeaters, otherwise the controller probe fails.

So make it optional.

Signed-off-by: Wesley Cheng <wesley.cheng@oss.qualcomm.com>
[abel.vesa@oss.qualcomm.com: commit re-worded to reflect actual reason]
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Reviewed-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Abel Vesa <abel.vesa@oss.qualcomm.com>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://patch.msgid.link/20260302-phy-qcom-m31-eusb2-make-repeater-optional-v2-1-dbf714c72056@oss.qualcomm.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: `phy: qcom: m31-eusb2: Make USB repeater
optional`

**Local tree:** Linux **6.18.43** (`v6.18.43-1-gc7f0dac02d232`)
**Commit under review:** `dd085bf278421` (upstream `a62bfbcf2db4`) —
**not yet in this tree**

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Subject line
**Record:** `[phy: qcom: m31-eusb2]` `[make]` — Make the USB repeater
optional in the Qualcomm M31 eUSB2 PHY driver probe path.

### Step 1.2: Tags
**Record:**
- **Fixes:** — absent
- **Reported-by:** — absent
- **Tested-by:** — absent
- **Reviewed-by:** Dmitry Baryshkov, Bjorn Andersson, Neil Armstrong,
  Konrad Dybcio
- **Acked-by:** — absent
- **Link:** https://patch.msgid.link/20260302-phy-qcom-m31-eusb2-make-
  repeater-optional-v2-1-dbf714c72056@oss.qualcomm.com
- **Cc: stable:** — absent (expected for manual review)
- **Signed-off-by:** Wesley Cheng, Abel Vesa, Vinod Koul (ignore
  pipeline SOBs)

Notable: multiple subsystem maintainers reviewed; no syzbot/fuzzer
report.

### Step 1.3: Body analysis
**Record:**
- **Bug:** Driver requires an eUSB2 repeater at probe time via
  `devm_of_phy_get_by_index()`, but repeaters are not always present.
- **Symptom:** On multi-port controllers with multiple PHY instances,
  PHYs without attached repeaters fail probe; that can fail the whole
  USB controller probe.
- **Root cause:** Repeater treated as mandatory when hardware/DT allows
  it to be absent.
- **Version info:** None in message; driver targets
  `qcom,sm8750-m31-eusb2-phy`.

### Step 1.4: Hidden bug fix?
**Record:** Yes. Despite “make optional” wording, this is a real probe-
failure bug fix, not a feature. The DT binding already lists `phys` as
optional (not in `required:`), but the driver enforced it as mandatory.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory
**Record:**
- **File:** `drivers/phy/qualcomm/phy-qcom-m31-eusb2.c` (+1 / -1)
- **Function:** `m31eusb2_phy_probe()`
- **Scope:** Single-file, single-line surgical change

### Step 2.2: Code flow change
**Record:**
- **Before:** `devm_of_phy_get_by_index(dev, dev->of_node, 0)` returns
  `-ENODEV` when no `phys` property → probe fails.
- **After:** `devm_phy_optional_get(dev, NULL)` converts `-ENODEV` to
  `NULL` → probe succeeds.
- **Path affected:** Platform device probe during boot/module init.

### Step 2.3: Bug mechanism
**Record:** **Logic / correctness fix** — mandatory resource lookup for
an optional component. Category: driver/DT mismatch causing cascading
probe failure.

With repeater present, both APIs resolve index 0 via `_of_phy_get()`
(verified in `phy_get()` and `devm_of_phy_get_by_index()`).

### Step 2.4: Fix quality
**Record:**
- Fix is minimal and matches established pattern in `phy-snps-eusb2.c`
  (`devm_of_phy_optional_get`).
- `phy_init()`, `phy_exit()`, and `phy_set_mode_ext()` all accept `NULL`
  and return 0 (verified in `phy-core.c`).
- No new deadlock/locking risk.
- `IS_ERR()` check after optional get remains correct (only real errors
  propagate).

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame
**Record:** Repeater lookup introduced in `5d324e5159d9e` (6.18 merge,
Nov 2025). Buggy line present at `drivers/phy/qualcomm/phy-
qcom-m31-eusb2.c:288` in this tree.

### Step 3.2: Fixes: tag
**Record:** N/A — no `Fixes:` tag.

### Step 3.3: Related file history
**Record:** Recent history in this tree:
- `09e1c96594afb` — PLL_EN suspend power fix (backported, `Cc: stable`)
- `37ef11ab2cf3c` — init sequence update
- Driver arrived via `5d324e5159d9e` (6.18)

Standalone one-patch fix; not part of a multi-patch dependency series.

### Step 3.4: Author context
**Record:** Wesley Cheng is the driver author and DT binding maintainer.
Abel Vesa committed v2. Vinod Koul (PHY maintainer) merged. Multiple
Qualcomm/ARM maintainers reviewed.

### Step 3.5: Dependencies
**Record:** No prerequisites. `devm_phy_optional_get()` exists in this
tree’s `phy-core.c`. Fix applies cleanly to current `68f1ba8fec4ad`
index state.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: Original discussion
**Record:**
- **b4 dig:** https://patch.msgid.link/20260227-phy-qcom-m31-eusb2-make-
  repeater-optional-v1-1-07a086bbaba4@oss.qualcomm.com
- **Revisions:** v1 (2026-02-27), v2 (2026-03-02, committed version)
- **Feedback:** Reviewed-by from Dmitry Baryshkov and Bjorn Andersson on
  v1; no NAKs found
- **Stable nomination in thread:** none found

### Step 4.2: Reviewers
**Record:** CC’d: `linux-phy@lists.infradead.org`, `linux-arm-
msm@vger.kernel.org`, Vinod Koul, Bjorn Andersson, Dmitry Baryshkov —
appropriate maintainer coverage.

### Step 4.3: Bug report
**Record:** No external bug report or syzbot link. Bug described from
hardware/DT design requirements.

### Step 4.4: Related patches
**Record:** Separate follow-up on master: `361f533a2dce2` (“Fix return
value of init call”) — fixes unrelated error-path return bug; **not** a
prerequisite for this change.

### Step 4.5: Stable list
**Record:** No stable-list discussion found for this specific patch.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Key functions
**Record:** `m31eusb2_phy_probe()` modified; downstream users of
`phy->repeater`: `m31eusb2_phy_init()`, `m31eusb2_phy_exit()`,
`m31eusb2_phy_set_mode()`.

### Step 5.2: Callers
**Record:** `m31eusb2_phy_probe` registered as `platform_driver`
`.probe` → called during device enumeration for
`qcom,sm8750-m31-eusb2-phy` nodes.

### Step 5.3: Callees
**Record:** `devm_phy_optional_get()` → `devm_phy_get()` →
`_of_phy_get(dev->of_node, 0)` for DT devices.

### Step 5.4: Reachability
**Record:** Triggered at boot on Qualcomm platforms with
`CONFIG_PHY_QCOM_M31_EUSB=y/m`. Affects kernel init / module probe, not
a syscall path.

### Step 5.5: Similar patterns
**Record:** `drivers/phy/phy-snps-eusb2.c:589` uses
`devm_of_phy_optional_get()` for the same repeater pattern.

---

## PHASE 6: CROSS-REFERENCE WITH LOCAL TREE (6.18.43)

### Step 6.1: Buggy code present?
**Record:** **Yes.** Current tree still has:
```288:291:drivers/phy/qualcomm/phy-qcom-m31-eusb2.c
        phy->repeater = devm_of_phy_get_by_index(dev, dev->of_node, 0);
        if (IS_ERR(phy->repeater))
                return dev_err_probe(dev, PTR_ERR(phy->repeater),
                                     "failed to get repeater\n");
```
Driver and Kconfig (`PHY_QCOM_M31_EUSB`) both exist. `git merge-base
--is-ancestor dd085bf278421 HEAD` → **NOT_IN_TREE**.

### Step 6.2: Backport complications
**Record:** Clean one-line apply expected. No refactor conflicts in
probe path.

### Step 6.3: Related fixes already present?
**Record:** PLL_EN suspend fix (`09e1c96594afb`) already backported —
shows maintainers are already carrying m31-eusb2 fixes into 6.18.y. Init
return-value fix (`361f533a2dce2`) is **not** in this tree (separate
issue).

---

## PHASE 7: SUBSYSTEM CONTEXT

### Step 7.1: Subsystem / criticality
**Record:** `drivers/phy/qualcomm/` — **PERIPHERAL** (platform-specific
Qualcomm USB PHY driver). Impact is limited to `ARCH_QCOM` +
`CONFIG_PHY_QCOM_M31_EUSB`.

### Step 7.2: Activity
**Record:** New driver in 6.18; actively receiving fixes (PLL_EN, init
sequence, this repeater fix on mainline).

---

## PHASE 8: IMPACT AND RISK

### Step 8.1: Who is affected
**Record:** Users of Qualcomm SM8750 (`qcom,sm8750-m31-eusb2-phy`) with
multi-PHY USB controllers where some PHY instances lack repeaters.
Config-specific, platform-specific.

### Step 8.2: Trigger conditions
**Record:** DT node for M31 eUSB2 PHY without `phys` property (or no
connected repeater). Common on multi-port designs with unconnected
ports. Triggered at every boot for affected boards.

### Step 8.3: Failure mode / severity
**Record:** PHY probe returns `-ENODEV` → USB controller probe may fail
→ **USB completely non-functional** on affected ports/boards. Not a
crash/UAF/security issue, but a **HIGH functional impact** for affected
hardware. Severity: **HIGH** (hardware broken), not CRITICAL (no memory
corruption/panic).

### Step 8.4: Risk vs benefit
**Record:**
- **Benefit:** Enables USB on valid hardware configs; aligns driver with
  DT binding; prevents cascading probe failure.
- **Risk:** Very low — one line, reviewed, NULL-safe downstream via phy
  core.
- **Ratio:** High benefit for affected users, negligible risk.

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence summary

**FOR backport:**
- Real bug: mandatory repeater breaks probe when absent
- Driver exists in 6.18.43
- DT binding already marks `phys` optional
- One-line, reviewed fix
- Phy core handles NULL repeater safely
- Prior m31-eusb2 fix already backported to this tree
- Matches snps-eusb2 established pattern

**AGAINST backport:**
- Very new, platform-specific driver (SM8750 only)
- No syzbot/user bug report
- Not a security/crash/data-corruption issue
- No in-tree DTS examples yet for this PHY
- Limited 6.18 stable user base for this hardware

**Unresolved:** No production deployment data for SM8750 on 6.18.y
(unverifiable).

### Step 9.2: Stable rules checklist
1. Obviously correct and tested? **PASS** — reviewed by PHY/ARM
   maintainers; semantics verified against phy core.
2. Fixes a real bug? **PASS** — probe failure on valid hardware configs.
3. Important issue? **PASS** — USB controller/PHY probe failure renders
   USB non-functional on affected boards.
4. Small and contained? **PASS** — 1 line, 1 file.
5. No new features/APIs? **PASS** — corrects driver to match existing
   optional DT property.
6. Can apply to local tree? **PASS** — driver and APIs present; clean
   apply.

### Step 9.3: Exception category
**Record:** Hardware workaround / driver-DT mismatch fix (similar to
quirk category). Not a new device ID, but fixes hardware enablement for
existing driver.

### Step 9.4: Decision rationale

For **this 6.18.43 tree**, the driver is present and the bug is present.
The fix is trivial, correct, and safe. While the audience is narrow
(Qualcomm SM8750), the failure mode is complete USB probe failure on
valid multi-port designs — exactly the kind of contained hardware-
enablement fix stable trees accept when the driver already ships in that
series. The DT binding never required `phys`; the driver was wrong from
introduction.

---

## Verification

- **[Phase 1]** Parsed commit `dd085bf278421` message and all tags via
  `git show`
- **[Phase 1]** Confirmed no Reported-by/syzbot/Fixes:/Cc: stable tags
- **[Phase 2]** Verified diff: 1 line in `m31eusb2_phy_probe()`
- **[Phase 2]** Verified `phy_init(NULL)`, `phy_exit(NULL)`,
  `phy_set_mode_ext(NULL)` return 0 in `drivers/phy/phy-
  core.c:232,272,386`
- **[Phase 2]** Verified `devm_phy_optional_get()` converts `-ENODEV` to
  NULL in `phy-core.c:841-848`
- **[Phase 2]** Verified `phy_get(dev, NULL)` uses index 0 via
  `_of_phy_get()` in `phy-core.c:767-773`
- **[Phase 3]** `git blame -L 288,291`: buggy code from `5d324e5159d9e`
- **[Phase 3]** `git log --oneline -- drivers/phy/qualcomm/phy-
  qcom-m31-eusb2.c`: driver history in 6.18.y
- **[Phase 3]** `git merge-base --is-ancestor dd085bf278421 HEAD` →
  NOT_IN_TREE
- **[Phase 4]** `b4 dig -c dd085bf278421`: found v1/v2 lore threads
- **[Phase 4]** `b4 dig -w`: confirmed maintainer CC list
- **[Phase 4]** `b4 dig -m /tmp/m31-eusb2-repeater.mbox`: no stable
  nomination, no NAKs
- **[Phase 5]** Read `m31eusb2_phy_init/exit/set_mode` — all pass
  `phy->repeater` to NULL-safe phy core APIs
- **[Phase 5]** Compared with `phy-snps-eusb2.c:589` optional repeater
  pattern
- **[Phase 6]** `git describe HEAD` → v6.18.43; `Makefile` → 6.18.43
- **[Phase 6]** Read current `phy-qcom-m31-eusb2.c` — buggy
  `devm_of_phy_get_by_index` still present
- **[Phase 6]** Read
  `Documentation/devicetree/bindings/phy/qcom,m31-eusb2-phy.yaml` —
  `phys` not in `required`
- **[Phase 6]** `grep` for `sm8750-m31-eusb2` in `*.dts*` → no in-tree
  DTS (driver/bindings only)
- **[Phase 6]** Confirmed `CONFIG_PHY_QCOM_M31_EUSB` exists in
  `drivers/phy/qualcomm/Kconfig`
- **[Phase 6]** Confirmed prior stable backport `09e1c96594afb` (PLL_EN)
  already in this tree
- **[Phase 8]** Assessed failure mode as probe failure → USB non-
  functional (not kernel crash)

**YES**

 drivers/phy/qualcomm/phy-qcom-m31-eusb2.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/phy/qualcomm/phy-qcom-m31-eusb2.c b/drivers/phy/qualcomm/phy-qcom-m31-eusb2.c
index 9434bd22ef32d..275df38256de3 100644
--- a/drivers/phy/qualcomm/phy-qcom-m31-eusb2.c
+++ b/drivers/phy/qualcomm/phy-qcom-m31-eusb2.c
@@ -285,7 +285,7 @@ static int m31eusb2_phy_probe(struct platform_device *pdev)
 
 	phy_set_drvdata(phy->phy, phy);
 
-	phy->repeater = devm_of_phy_get_by_index(dev, dev->of_node, 0);
+	phy->repeater = devm_phy_optional_get(dev, NULL);
 	if (IS_ERR(phy->repeater))
 		return dev_err_probe(dev, PTR_ERR(phy->repeater),
 				     "failed to get repeater\n");
-- 
2.53.0

