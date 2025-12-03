Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9EC732AAC4;
	Wed,  3 Dec 2025 15:59:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764777570; cv=none; b=GDSRKIQlA+eW0IyIQsrM9/YUkxE4QGCUN3Daw2yHwOqhqRbTrZfI4XuyHzw0HmVeevn1B3l9fcxp5146EaP3j+fhWL5dfGriK8pyJLvxJB50f02A5My7mz1xFR0FXT1tqOP+r7w1XLR6M3utpu6RBV9Ihu47OEomKhryCgpsvns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764777570; c=relaxed/simple;
	bh=4UfoMDj5eYQKGeInyz6HdrCNNReZ8jBJCn3kllMmQzQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EfcZ5mVrWD0DkyWK9kqavGBi+SRUWMn+8R4OwAV2DfYUJ9i0OEvoiWWGLCY+Cx+3/00Vl6e32hkY3DAHUOg8oct6euPji2RqMXfAxbrR43XjBD7ZQW2YLB8Hn6XdthGTTb1ghO4f+qzBvkvtZL5/n/JVQFPI6uxzPP7NWAn7dGM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rfp0uQkc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rfp0uQkc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29A95C116B1;
	Wed,  3 Dec 2025 15:59:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764777570;
	bh=4UfoMDj5eYQKGeInyz6HdrCNNReZ8jBJCn3kllMmQzQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rfp0uQkcSnPcHbHIjPbbs3fgZIeplBldgM0cTP+DUG+LHA+HA0D/Geo3nwCfp74tA
	 d04h5x+8/iKttJnVSIw0VyRkrwxH5spaLEES6U0mYqydIFJNww7qPTg4ziXmB3zFhc
	 9CNnaAyc7KdlkrhYuYlvwr337gSGClB8TTsBLUwQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Lezcano <daniel.lezcano@linaro.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 079/392] clocksource/drivers/vf-pit: Replace raw_readl/writel to readl/writel
Date: Wed,  3 Dec 2025 16:23:49 +0100
Message-ID: <20251203152417.011648117@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152414.082328008@linuxfoundation.org>
References: <20251203152414.082328008@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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



