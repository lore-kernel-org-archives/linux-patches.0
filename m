Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 369D43ECBD2;
	Tue, 24 Mar 2026 11:19:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774351183; cv=none; b=CXuLfgmVJGhauTUN4OloVQjvYbp+Nqh4nxdTioWNDj0E/jGu2e3pu7tdYaqF2Mt20R642feggIKPeCSii3WDJwTU0370R/8HwtqUwxqKrQSBGTTRAZ/9/1rY/tI3VkfxsnZC1J1TiCMdoLkCVG3jQZ6qt4hWilQn4Jaiq+ovqMk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774351183; c=relaxed/simple;
	bh=BKTk3rQ25SsxVZEq48IRP2YHJlexTUbR0Y7iATCy0Lg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cRM+3Tm9ywWuCZG6fbB+N5brg/vhVz00WeUgtgKBqiGLl2C2oSvUagJ+FyFHcCtVYIs/8NGC5q5xlELX+tDN64RXgxFZvaTJQ1Q9KVmaWWZ+/6OwT76SzTIbf+XoTBwZjdS5ZK3HQEcwgkPOnk/Efx49EzFxhUYrXVw1cSqA5JA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HLMyUeoT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HLMyUeoT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D882C2BCB3;
	Tue, 24 Mar 2026 11:19:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774351182;
	bh=BKTk3rQ25SsxVZEq48IRP2YHJlexTUbR0Y7iATCy0Lg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HLMyUeoT/xXwI5EE2IM6ErlhVWOTe7etTAhiGJfzXk+1IwtqZjbZCbPW29bHxDilW
	 f2rlTwKy5iatv9HR9xBBmiHD55diOyOsPc9Ik65jWnB2LoiAhBX8bw1fo1JJRcNoHg
	 TaXgtQVQoCJx6joKaqQjnZR57tooPJLQCJxnl0knOtSAojnxZDq2OXzy1Ygd+bnO6C
	 Mr0IKTCTaRD2XLbO0HGsJf1PcGFP4/YzJgytTPk4FkTy6cfW1yVD6rYt5R1DlkwUmB
	 InNuplX2IgWFkJVCCY767IQELma8Op4P6AKuR8gGiwt7cqwiv2s98qEctkyWXk+Icy
	 BlvGvnhvRKaDA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Mikko Perttunen <mperttunen@nvidia.com>,
	Russell King <rmk+kernel@armlinux.org.uk>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>,
	andi.shyti@kernel.org,
	ldewangan@nvidia.com,
	thierry.reding@gmail.com,
	jonathanh@nvidia.com,
	linux-i2c@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-tegra@vger.kernel.org
Subject: [PATCH AUTOSEL 6.19-6.1] i2c: tegra: Don't mark devices with pins as IRQ safe
Date: Tue, 24 Mar 2026 07:19:16 -0400
Message-ID: <20260324111931.3257972-7-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260324111931.3257972-1-sashal@kernel.org>
References: <20260324111931.3257972-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.19.9
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Mikko Perttunen <mperttunen@nvidia.com>

[ Upstream commit ec69c9e88315c4be70c283f18c2ff130da6320b5 ]

I2C devices with associated pinctrl states (DPAUX I2C controllers)
will change pinctrl state during runtime PM. This requires taking
a mutex, so these devices cannot be marked as IRQ safe.

Add PINCTRL as dependency to avoid build errors.

Signed-off-by: Mikko Perttunen <mperttunen@nvidia.com>
Reported-by: Russell King <rmk+kernel@armlinux.org.uk>
Link: https://lore.kernel.org/all/E1vsNBv-00000009nfA-27ZK@rmk-PC.armlinux.org.uk/
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Record for Phase 6:
- The buggy code exists in ALL active stable trees (v5.15, v6.1, v6.6,
  v6.12)
- The condition varies across trees — backporting needs minor adaptation
  for trees without the ACPI check
- Pinctrl code has been in the driver since v4.9
- The Kconfig change (adding PINCTRL dependency) is needed in all trees
- For v5.15/v6.1: the condition is `if (!i2c_dev->is_vi)` — patch must
  add `&& !i2c_dev->dev->pins`
- For v6.6: `if (!IS_VI(i2c_dev))` — same adaptation needed
- For v6.12+: `if (!IS_VI(i2c_dev) &&
  !has_acpi_companion(i2c_dev->dev))` — closest to mainline, minor
  conflict

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

### Step 7.1: SUBSYSTEM CRITICALITY
- **Subsystem:** drivers/i2c/busses — I2C bus driver (NVIDIA Tegra
  specific)
- **Criticality:** PERIPHERAL — affects Tegra SoC users (NVIDIA Jetson
  platforms, embedded/automotive)
- However, Tegra is a significant embedded platform used in NVIDIA
  Jetson (AI/robotics), automotive (NVIDIA Drive), and Nintendo Switch

### Step 7.2: SUBSYSTEM ACTIVITY
The driver has moderate activity — updated regularly for new Tegra
generations.

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: WHO IS AFFECTED
- Users with Tegra SoCs that have DPAUX I2C controllers (Tegra124,
  Tegra132, Tegra210+)
- Specifically Jetson Xavier NX was reported as affected (Russell King's
  report)
- Platform-specific: only NVIDIA Tegra platforms

### Step 8.2: TRIGGER CONDITIONS
- **Trigger:** Device probe when the I2C controller has associated
  pinctrl states
- **How common:** Happens on every boot for affected hardware — not a
  race condition, not timing-dependent
- **Unprivileged trigger:** No (hardware-dependent, happens at boot)

### Step 8.3: FAILURE MODE SEVERITY
- **Failure:** BUG: sleeping function called from invalid context
  (mutex_lock in atomic context)
- **Severity:** CRITICAL — kernel BUG/panic on every boot for affected
  hardware
- The device cannot be used at all — it crashes during probe

### Step 8.4: RISK-BENEFIT RATIO
- **Benefit:** HIGH — fixes kernel BUG on every boot for DPAUX I2C
  controllers on Tegra
- **Risk:** VERY LOW — adds one additional condition (`!dev->pins`) to
  an existing if-statement, plus a Kconfig dependency
- The fix is obviously correct: if pinctrl operations need a mutex, the
  device cannot be IRQ-safe
- **Ratio:** Strongly favors backporting

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: COMPILE THE EVIDENCE

**Evidence FOR backporting:**
1. Fixes a real BUG (sleeping in atomic context) with stack trace from
   Russell King
2. Affects every boot on affected hardware (not a theoretical race)
3. Fix is extremely small and surgical (one condition added + Kconfig
   dep)
4. Obviously correct — if runtime PM calls mutex, device cannot be IRQ-
   safe
5. Same class of bug was already fixed twice (VI: 9e29420ddb133, ACPI:
   14d069d92951a) — ACPI fix was Cc'd to stable
6. Reported by Russell King, a highly respected ARM kernel developer
7. Merged directly by Linus Torvalds
8. Buggy code exists in all active stable trees (since v4.9)
9. Went through 3 patch iterations — well-reviewed

**Evidence AGAINST backporting:**
1. Tegra-specific — affects only NVIDIA Tegra platform users
2. Requires minor adaptation for older stable trees (different condition
   syntax)
3. The Kconfig PINCTRL dependency might affect COMPILE_TEST
   configurations

**UNRESOLVED:**
- Exact list of hardware models/boards affected (known: Jetson Xavier
  NX)

### Step 9.2: STABLE RULES CHECKLIST
1. **Obviously correct and tested?** YES — reported and tested by
   Russell King, 3 patch iterations, merged by Linus
2. **Fixes a real bug?** YES — BUG: sleeping function called from
   invalid context, with stack trace
3. **Important issue?** YES — kernel BUG/crash on every boot for
   affected hardware
4. **Small and contained?** YES — ~6 lines changed, single condition
   addition + Kconfig dep
5. **No new features or APIs?** CORRECT — no new features
6. **Can apply to stable trees?** With minor adaptation — the condition
   syntax differs across stable trees

### Step 9.3: EXCEPTION CATEGORIES
Not an exception category — this is a standard bug fix that meets all
stable rules.

### Step 9.4: DECISION
This is a clear bug fix that causes a kernel BUG (crash) on every boot
for affected Tegra hardware. The fix is small, surgical, obviously
correct, and follows the same pattern as two previous fixes for the same
class of bug (one of which was already Cc'd to stable). The previous
ACPI variant (commit 14d069d92951a) was explicitly marked `Cc: stable` —
this is the same bug with a different trigger.

## Verification

- [Phase 1] Parsed tags: Reported-by Russell King, Link to lore, merged
  by Linus Torvalds directly
- [Phase 1] Commit explains: pinctrl state transitions need mutex, IRQ-
  safe marking causes BUG
- [Phase 2] Diff analysis: +1 condition `!i2c_dev->dev->pins` in
  probe(), +2 lines Kconfig PINCTRL dep, +3 lines comment
- [Phase 3] git blame: `pm_runtime_irq_safe()` call existed since VI
  exception was added; pinctrl support added in v4.9 (718917b9875fc)
- [Phase 3] Related fix 14d069d92951a (ACPI variant) had `Cc: stable
  v5.17+` — same class of bug
- [Phase 3] Author Mikko Perttunen is NVIDIA Tegra subsystem contributor
- [Phase 4] Lore link confirms: BUG sleeping function called from
  invalid context, stack trace: tegra_i2c_runtime_suspend →
  pinctrl_pm_select_idle_state → mutex_lock
- [Phase 4] Patch went through v1/v2/v3, kernel test robot found build
  issue leading to PINCTRL Kconfig dep
- [Phase 5] `dev->pins` is `#ifdef CONFIG_PINCTRL` in
  include/linux/device.h:592 — Kconfig dep ensures it compiles
- [Phase 5] `tegra_i2c_probe` is platform driver probe, called during
  device enumeration
- [Phase 6] Verified buggy code exists in v5.15 (`if
  (!i2c_dev->is_vi)`), v6.1 (same), v6.6 (`if (!IS_VI(i2c_dev))`), v6.12
  (has ACPI check) — all need this fix
- [Phase 6] Backport needs minor adaptation for trees without ACPI check
  (v5.15, v6.1, v6.6)
- [Phase 7] Subsystem: Tegra I2C driver, PERIPHERAL but significant
  embedded platform
- [Phase 8] Failure mode: kernel BUG on every boot for affected
  hardware, severity CRITICAL
- [Phase 8] Risk: VERY LOW (one additional condition in existing if-
  statement)

**YES**

 drivers/i2c/busses/Kconfig     | 2 ++
 drivers/i2c/busses/i2c-tegra.c | 5 ++++-
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/i2c/busses/Kconfig b/drivers/i2c/busses/Kconfig
index 09ba55bae1fac..7d0afdc7d8862 100644
--- a/drivers/i2c/busses/Kconfig
+++ b/drivers/i2c/busses/Kconfig
@@ -1220,6 +1220,8 @@ config I2C_TEGRA
 	tristate "NVIDIA Tegra internal I2C controller"
 	depends on ARCH_TEGRA || (COMPILE_TEST && (ARC || ARM || ARM64 || M68K || RISCV || SUPERH || SPARC))
 	# COMPILE_TEST needs architectures with readsX()/writesX() primitives
+	depends on PINCTRL
+	# ARCH_TEGRA implies PINCTRL, but the COMPILE_TEST side doesn't.
 	help
 	  If you say yes to this option, support will be included for the
 	  I2C controller embedded in NVIDIA Tegra SOCs
diff --git a/drivers/i2c/busses/i2c-tegra.c b/drivers/i2c/busses/i2c-tegra.c
index e533460bccc39..a9aed411e3190 100644
--- a/drivers/i2c/busses/i2c-tegra.c
+++ b/drivers/i2c/busses/i2c-tegra.c
@@ -1837,8 +1837,11 @@ static int tegra_i2c_probe(struct platform_device *pdev)
 	 *
 	 * VI I2C device shouldn't be marked as IRQ-safe because VI I2C won't
 	 * be used for atomic transfers. ACPI device is not IRQ safe also.
+	 *
+	 * Devices with pinctrl states cannot be marked IRQ-safe as the pinctrl
+	 * state transitions during runtime PM require mutexes.
 	 */
-	if (!IS_VI(i2c_dev) && !has_acpi_companion(i2c_dev->dev))
+	if (!IS_VI(i2c_dev) && !has_acpi_companion(i2c_dev->dev) && !i2c_dev->dev->pins)
 		pm_runtime_irq_safe(i2c_dev->dev);
 
 	pm_runtime_enable(i2c_dev->dev);
-- 
2.51.0

