Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8857F2F532C;
	Thu,  9 Oct 2025 16:00:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760025640; cv=none; b=C9dtOPcH3oM8Htjl7Rl2D1QdvgEywsuThUToEkh05yyGEBg7zfaiulC+32BvZVuTixq9Ko7DqpOE3Cniw17l9ORVOkkaPKhIl71IiPDPnfmTl0aKuEeCJHeetUsLl2xvHxEXhlbvW6g/tdzcG0Pg0+9OOpLqrBkTiMOo8GZxlJw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760025640; c=relaxed/simple;
	bh=H7pIu2nrF3o5LhSEUg5bYRN/KyD+62BDc7EyqLzyrv4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YmthXFiaD7nLOb+DOVH0DA2L+sy9UAHRulZqvRpSuYbsN8NOmaV0qVjJV6xOsqdYpydt6R9KYr2foP53T0aGaHTY1OUt7dBwSaFQnUGLty3Lg7koL8eNP6ZRUOJ+K5Zy9siaAFNY6n7nplQXmasV7lQwhXq6ep9PpslbwEMvq6Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LLaOyy1N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LLaOyy1N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E9E5C4CEFE;
	Thu,  9 Oct 2025 16:00:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760025640;
	bh=H7pIu2nrF3o5LhSEUg5bYRN/KyD+62BDc7EyqLzyrv4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LLaOyy1NDZkO9IQpiphxxy1CRhcwO66nNv0ARdTZwb6yBqKxKxej5bs/6+sJnG2va
	 SjuPqxfhB/qLkjXAkXJxxuVAWrxRVdR48KKGsXZR3CVOBV+nHReK8wsj/zADAjCP/m
	 QNcWCpH+iKnxLU+vInuOGRY4fZSdAxierDcfq/BJAcJFhRL8af38nJVyEiOoK55Bnc
	 0CzmkB53RaJqIVa6iaB67Ki7pPUr/Ou+tJqWBN2beBcxs4DKmIpaQIQ2gyFB69ZWjZ
	 eAfg7898B2R1Cek9evQ7tRmPGYXubVyLl9ZXJGWZjHtOlHPdWUw4xkdWxUYffcma/W
	 ckqJl+TJj8Now==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Sasha Levin <sashal@kernel.org>,
	tglx@linutronix.de,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.17-5.4] clocksource/drivers/vf-pit: Replace raw_readl/writel to readl/writel
Date: Thu,  9 Oct 2025 11:55:57 -0400
Message-ID: <20251009155752.773732-91-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251009155752.773732-1-sashal@kernel.org>
References: <20251009155752.773732-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Daniel Lezcano <daniel.lezcano@linaro.org>

[ Upstream commit 0b781f527d6f99e68e5b3780ae03cd69a7cb5c0c ]

The driver uses the raw_readl() and raw_writel() functions. Those are
not for MMIO devices. Replace them with readl() and writel()

[ dlezcano: Fixed typo in the subject s/reald/readl/ ]

Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Cc: Arnd Bergmann <arnd@arndb.de>
Link: https://lore.kernel.org/r/20250804152344.1109310-2-daniel.lezcano@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES

- What changed: The commit replaces all `__raw_readl/__raw_writel` uses
  with `readl/writel` in the VF610 PIT timer driver, ensuring proper
  MMIO semantics. Affected spots in `drivers/clocksource/timer-vf-pit.c`
  include:
  - `pit_timer_enable`: `__raw_writel(...)` → `writel(...)`
    (drivers/clocksource/timer-vf-pit.c)
  - `pit_timer_disable`: `__raw_writel(0, ...)` → `writel(0, ...)`
    (drivers/clocksource/timer-vf-pit.c)
  - `pit_irq_acknowledge`: `__raw_writel(PITTFLG_TIF, ...)` →
    `writel(...)` (drivers/clocksource/timer-vf-pit.c)
  - `pit_read_sched_clock`: `~__raw_readl(clksrc_base + PITCVAL)` →
    `~readl(...)` (drivers/clocksource/timer-vf-pit.c)
  - `pit_clocksource_init`: three writes to `PITTCTRL`/`PITLDVAL` switch
    to `writel(...)` (drivers/clocksource/timer-vf-pit.c)
  - `pit_set_next_event`: `__raw_writel(delta - 1, ...)` → `writel(...)`
    (drivers/clocksource/timer-vf-pit.c)
  - `pit_clockevent_init`: writes to `PITTCTRL`/`PITTFLG` switch to
    `writel(...)` (drivers/clocksource/timer-vf-pit.c)
  - `pit_timer_init`: module enable write `__raw_writel(~PITMCR_MDIS,
    ...)` → `writel(...)` (drivers/clocksource/timer-vf-pit.c)

- Why this is a bug fix: `__raw_readl/__raw_writel` are explicitly
  documented as low-level accessors without ordering or byte-order
  semantics and “not for MMIO registers.” Using them on MMIO can lead to
  reordering/posting issues on weakly ordered architectures. This can
  cause:
  - Timer enable occurring before the new `LDVAL` write reaches hardware
    in `pit_set_next_event`, producing incorrect next-event timing.
  - IRQ acknowledge in `pit_timer_interrupt` not being ordered with
    respect to subsequent code, potentially leading to spurious or
    missed interrupts.
  - Sched_clock reads using `__raw_readl` lacking ordering guarantees.
  The correct `readl/writel` include the architecture-defined ordering
required for MMIO and fix these subtle, real-world bugs. See
documentation: `Documentation/driver-api/device-io.rst` (section
describing `__raw_*` accessors).

- Scope and risk: The change is small, mechanical, and confined to a
  single driver file. It does not alter logic, APIs, or data structures.
  It only corrects the MMIO accessor choice. While the timer/clocksource
  subsystem is critical, this is the minimally invasive, intended API
  usage and aligns with how other clocksource drivers operate.

- Upstream context: This exact change is upstream as commit
  0b781f527d6f9 (“clocksource/drivers/vf-pit: Replace raw_readl/writel
  to readl/writel”), acknowledged by the timekeeping maintainer. The
  driver later evolves/renames to `drivers/clocksource/timer-nxp-pit.c`,
  which consistently uses `readl/writel`, reinforcing that this is the
  intended, correct pattern.

- Stable backport criteria:
  - Fixes a real bug that can affect users (ordering on MMIO timer
    registers).
  - Minimal and contained patch; no feature additions or architectural
    changes.
  - Low regression risk; behavior becomes more robust per documented
    MMIO rules.
  - No explicit “Cc: stable”, but it corrects improper API usage present
    since the driver’s introduction (initial support commit
    c19672492d233), making it broadly applicable to stable trees that
    still have `timer-vf-pit.c`.

Given the above, this is a good candidate for stable backport.

 drivers/clocksource/timer-vf-pit.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/clocksource/timer-vf-pit.c b/drivers/clocksource/timer-vf-pit.c
index 911c92146eca6..8041a8f62d1fa 100644
--- a/drivers/clocksource/timer-vf-pit.c
+++ b/drivers/clocksource/timer-vf-pit.c
@@ -35,30 +35,30 @@ static unsigned long cycle_per_jiffy;
 
 static inline void pit_timer_enable(void)
 {
-	__raw_writel(PITTCTRL_TEN | PITTCTRL_TIE, clkevt_base + PITTCTRL);
+	writel(PITTCTRL_TEN | PITTCTRL_TIE, clkevt_base + PITTCTRL);
 }
 
 static inline void pit_timer_disable(void)
 {
-	__raw_writel(0, clkevt_base + PITTCTRL);
+	writel(0, clkevt_base + PITTCTRL);
 }
 
 static inline void pit_irq_acknowledge(void)
 {
-	__raw_writel(PITTFLG_TIF, clkevt_base + PITTFLG);
+	writel(PITTFLG_TIF, clkevt_base + PITTFLG);
 }
 
 static u64 notrace pit_read_sched_clock(void)
 {
-	return ~__raw_readl(clksrc_base + PITCVAL);
+	return ~readl(clksrc_base + PITCVAL);
 }
 
 static int __init pit_clocksource_init(unsigned long rate)
 {
 	/* set the max load value and start the clock source counter */
-	__raw_writel(0, clksrc_base + PITTCTRL);
-	__raw_writel(~0UL, clksrc_base + PITLDVAL);
-	__raw_writel(PITTCTRL_TEN, clksrc_base + PITTCTRL);
+	writel(0, clksrc_base + PITTCTRL);
+	writel(~0UL, clksrc_base + PITLDVAL);
+	writel(PITTCTRL_TEN, clksrc_base + PITTCTRL);
 
 	sched_clock_register(pit_read_sched_clock, 32, rate);
 	return clocksource_mmio_init(clksrc_base + PITCVAL, "vf-pit", rate,
@@ -76,7 +76,7 @@ static int pit_set_next_event(unsigned long delta,
 	 * hardware requirement.
 	 */
 	pit_timer_disable();
-	__raw_writel(delta - 1, clkevt_base + PITLDVAL);
+	writel(delta - 1, clkevt_base + PITLDVAL);
 	pit_timer_enable();
 
 	return 0;
@@ -125,8 +125,8 @@ static struct clock_event_device clockevent_pit = {
 
 static int __init pit_clockevent_init(unsigned long rate, int irq)
 {
-	__raw_writel(0, clkevt_base + PITTCTRL);
-	__raw_writel(PITTFLG_TIF, clkevt_base + PITTFLG);
+	writel(0, clkevt_base + PITTCTRL);
+	writel(PITTFLG_TIF, clkevt_base + PITTFLG);
 
 	BUG_ON(request_irq(irq, pit_timer_interrupt, IRQF_TIMER | IRQF_IRQPOLL,
 			   "VF pit timer", &clockevent_pit));
@@ -183,7 +183,7 @@ static int __init pit_timer_init(struct device_node *np)
 	cycle_per_jiffy = clk_rate / (HZ);
 
 	/* enable the pit module */
-	__raw_writel(~PITMCR_MDIS, timer_base + PITMCR);
+	writel(~PITMCR_MDIS, timer_base + PITMCR);
 
 	ret = pit_clocksource_init(clk_rate);
 	if (ret)
-- 
2.51.0

