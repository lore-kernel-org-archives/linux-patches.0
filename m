Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 637F913B5A9;
	Mon,  4 Aug 2025 00:29:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754267392; cv=none; b=F9Dz2l64GtPyozMvvGEeg05YpCAR0xbN/AFYwDBcuwbQGWExGOKZXoZ8zchHlpeKLC3kkUOsjaEOXpNdOA5TKyTHEge56pJ7QWJ0aF0qVBvyhfS8U5iH8Idr+IlKkvyIeDg3eQ5Kk0L16y136pmiGMiiyiRNROIJ8AUOddwa05g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754267392; c=relaxed/simple;
	bh=Uc9EBAVZwmoaPxZJPpgW3Ltv9yh0rdtJrmC4OXA0/04=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=eInGfyA9/RvJWD26eGtYMPX7er16DqZkICYxI0yoUVo5HLQvaF/BQpGPRtiuFNknvtV6jZUE9riDTWKf44EugvCeRigJXjgbCO9pVqr47DOupGHIgajt5XilJvarZCqKh3r23JCodybkS4LNYWE1z7X6oX8tuC9T7/68cnO81g8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Oz75oLPO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Oz75oLPO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 029B2C4CEEB;
	Mon,  4 Aug 2025 00:29:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754267392;
	bh=Uc9EBAVZwmoaPxZJPpgW3Ltv9yh0rdtJrmC4OXA0/04=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Oz75oLPOEYzhzYVLWELFjKStuXMd8gF1RjxvExST3K296ppfWefyacpu4taSRZTs5
	 APbTDCWpTC69Wx7poFlRkXIPbjw+JKyqINtzDDJeqtKHB84m0nBRPWvOqm4igXgP0l
	 EaqFGc53l3mSMSZPoX5PQzJ0yGRUMTkghq3pwPYnLr/YF2tGIKyy8R5WYZHUeLu4Ob
	 DFPSljn9m53KbDpglzMfXdgf/qPQmGSKSanvUUGALSA1OoNwRYZUDK9txpekQxRJPd
	 ocrc1Y6bRhLDMKrlogQD9BNxnoo9cUEUagcO9IVAcEq7EG8Niz4N/1OSwB19+KMdeu
	 +LvCqOomqyrDg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Biju Das <biju.das.jz@bp.renesas.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Sasha Levin <sashal@kernel.org>,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.15 48/80] irqchip/renesas-rzv2h: Enable SKIP_SET_WAKE and MASK_ON_SUSPEND
Date: Sun,  3 Aug 2025 20:27:15 -0400
Message-Id: <20250804002747.3617039-48-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250804002747.3617039-1-sashal@kernel.org>
References: <20250804002747.3617039-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.15.9
Content-Transfer-Encoding: 8bit

From: Biju Das <biju.das.jz@bp.renesas.com>

[ Upstream commit de2942828e7670526289f098df7e50b112e8ff1e ]

The interrupt controller found on RZ/G3E doesn't provide any facility to
configure the wakeup sources. That's the reason why the driver lacks the
irq_set_wake() callback for the interrupt chip.

But this prevent to properly enter power management states like "suspend to
idle".

Enable the flags IRQCHIP_SKIP_SET_WAKE and IRQCHIP_MASK_ON_SUSPEND so the
interrupt suspend logic can handle the chip correctly.

Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://lore.kernel.org/all/20250701105923.52151-1-biju.das.jz@bp.renesas.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

**Backport Status: YES**

This commit should be backported to stable kernel trees. Here's my
extensive analysis:

## Summary
This commit fixes a real bug where the Renesas RZ/G3E interrupt
controller prevents the system from properly entering power management
states like "suspend to idle" due to missing irqchip flags.

## Detailed Analysis

### 1. **Bug Fix Nature**
The commit clearly fixes a functional bug as stated in the commit
message:
- "But this prevent to properly enter power management states like
  'suspend to idle'"
- The interrupt controller lacks an `irq_set_wake()` callback, which is
  necessary for proper suspend/resume functionality

### 2. **Small and Contained Change**
The code change is minimal and well-contained:
```c
.flags = IRQCHIP_SET_TYPE_MASKED,
```
changed to:
```c
.flags = IRQCHIP_MASK_ON_SUSPEND |
         IRQCHIP_SET_TYPE_MASKED |
         IRQCHIP_SKIP_SET_WAKE,
```

This is a simple addition of two flags to the interrupt chip structure.

### 3. **Clear Understanding of Flags**
From the kernel documentation in include/linux/irq.h:
- **IRQCHIP_MASK_ON_SUSPEND**: "Mask non wake irqs in the suspend path"
  - This ensures interrupts that shouldn't wake the system are properly
  masked during suspend
- **IRQCHIP_SKIP_SET_WAKE**: "Skip chip.irq_set_wake(), for this irq
  chip" - This tells the kernel to skip calling the non-existent
  irq_set_wake() callback

### 4. **Pattern Consistency**
Looking at the similar Renesas driver (irq-renesas-rzg2l.c:446-448), we
can see the same flags are used:
```c
.flags = IRQCHIP_MASK_ON_SUSPEND |
         IRQCHIP_SET_TYPE_MASKED |
         IRQCHIP_SKIP_SET_WAKE,
```
This shows it's a well-established pattern for Renesas interrupt
controllers that lack wakeup source configuration.

### 5. **No Side Effects**
The change only adds flags that:
- Enable proper masking of interrupts during suspend (preventing
  spurious interrupts)
- Tell the kernel to skip calling a non-existent function
- No functional changes beyond fixing the suspend issue
- No API changes or new features

### 6. **Affects Users**
This bug directly affects users trying to use power management features
on RZ/G3E hardware. Without this fix, the system cannot properly enter
suspend states, which impacts:
- Power consumption
- Battery life (on battery-powered devices)
- System reliability during suspend/resume cycles

### 7. **Low Risk**
The change has minimal risk of regression because:
- It only adds standard irqchip flags that are well-tested in the kernel
- The same flags are used in other similar drivers
- It doesn't modify any existing logic, just adds proper flag
  configuration
- The flags only affect suspend/resume paths, not normal operation

### 8. **Driver Maturity**
While this is a relatively new driver (added in 2024), the fix addresses
a clear oversight in the initial implementation. The driver is already
in mainline, so systems using this hardware need this fix for proper
operation.

## Conclusion
This commit meets all the criteria for stable backporting:
- Fixes a real bug that affects users
- Minimal, well-understood change
- No architectural changes or new features
- Low risk of regression
- Follows established patterns in similar drivers

The fix enables proper power management functionality on affected
hardware, which is important for system operation and user experience.

 drivers/irqchip/irq-renesas-rzv2h.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/irqchip/irq-renesas-rzv2h.c b/drivers/irqchip/irq-renesas-rzv2h.c
index 0f0fd7d4dfdf..f1f7869b49cb 100644
--- a/drivers/irqchip/irq-renesas-rzv2h.c
+++ b/drivers/irqchip/irq-renesas-rzv2h.c
@@ -394,7 +394,9 @@ static const struct irq_chip rzv2h_icu_chip = {
 	.irq_retrigger		= irq_chip_retrigger_hierarchy,
 	.irq_set_type		= rzv2h_icu_set_type,
 	.irq_set_affinity	= irq_chip_set_affinity_parent,
-	.flags			= IRQCHIP_SET_TYPE_MASKED,
+	.flags			= IRQCHIP_MASK_ON_SUSPEND |
+				  IRQCHIP_SET_TYPE_MASKED |
+				  IRQCHIP_SKIP_SET_WAKE,
 };
 
 static int rzv2h_icu_alloc(struct irq_domain *domain, unsigned int virq, unsigned int nr_irqs,
-- 
2.39.5

