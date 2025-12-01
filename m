Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14A5B2F290A;
	Mon,  1 Dec 2025 11:26:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764588416; cv=none; b=WYzrcxN7umarPo4/BaUpd8E6pD41IhkmyHnSCCH5CGHT8AI7wZf3XLJpctHGUj5kulnqVemzpYls3hK7nCZFjykwXsUJ/8O51mScvPBFWsDrh+hu1Cjfo4JIxRXgaWTDCoksM51vwhpY3qrdLIHqH1F5VCML/feF2LQ/u+H37X8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764588416; c=relaxed/simple;
	bh=BF7WgrpPcfF3SVrLy46uJ8n7Xf4lhm+SjnSj73mpa64=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gVKwNTI+ImSkDDtPukAyM5JF3i8XQVU991ygVgFngM8mwtGybQk8ufkBa8HACXkaaElTZgiC40t9ZvXtn3Se8EK+GBYv/PvaYOVoMhQKk9psGwCI5t89A2lpHKPyYvgw2ZMhMiH6i7hk1vBjBWGKS+qFuERr44vtI4D3dTF/1iI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s/Fan1ES; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s/Fan1ES"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 758F1C113D0;
	Mon,  1 Dec 2025 11:26:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764588415;
	bh=BF7WgrpPcfF3SVrLy46uJ8n7Xf4lhm+SjnSj73mpa64=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s/Fan1EStBxhsQ4R//gGNdMCj7ShpN+DsO6GFFszwARUDPv3tr9c/En0rtqtSyaXZ
	 UIX39iZhwgKTEsCKxRWjwhBFdgRa3X8JpV1IUOnXHmWfafi7aoW14ITKCP2dbfDGIt
	 uJRCw8Ylt+HigZWlfS/P5XKrKOhPEvmjw7j6P13I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Lezcano <daniel.lezcano@linaro.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 039/187] clocksource/drivers/vf-pit: Replace raw_readl/writel to readl/writel
Date: Mon,  1 Dec 2025 12:22:27 +0100
Message-ID: <20251201112242.661343426@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251201112241.242614045@linuxfoundation.org>
References: <20251201112241.242614045@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

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
 drivers/clocksource/timer-vf-pit.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/clocksource/timer-vf-pit.c b/drivers/clocksource/timer-vf-pit.c
index fef0bb4e0c8c3..c37afdfb477f0 100644
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
@@ -132,8 +132,8 @@ static struct irqaction pit_timer_irq = {
 
 static int __init pit_clockevent_init(unsigned long rate, int irq)
 {
-	__raw_writel(0, clkevt_base + PITTCTRL);
-	__raw_writel(PITTFLG_TIF, clkevt_base + PITTFLG);
+	writel(0, clkevt_base + PITTCTRL);
+	writel(PITTFLG_TIF, clkevt_base + PITTFLG);
 
 	BUG_ON(setup_irq(irq, &pit_timer_irq));
 
@@ -189,7 +189,7 @@ static int __init pit_timer_init(struct device_node *np)
 	cycle_per_jiffy = clk_rate / (HZ);
 
 	/* enable the pit module */
-	__raw_writel(~PITMCR_MDIS, timer_base + PITMCR);
+	writel(~PITMCR_MDIS, timer_base + PITMCR);
 
 	ret = pit_clocksource_init(clk_rate);
 	if (ret)
-- 
2.51.0



