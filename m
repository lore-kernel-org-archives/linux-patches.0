Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA67C34FF51;
	Tue, 16 Dec 2025 11:56:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765886167; cv=none; b=BAmUoKdc2VrLUK9mZ4Ode6qRl15tx+LICm7m8TVDQmrbh05CEo5LGXhSuOfoFHRJt1bokbVbfL3OdLrdkdzQ6MIxH8rWcpl6k/eAIOdGJaUnJjdR8ozmn03pcqIZsRvnvs/KxBXbEZUKWjaw1py1wVQ2XHoJO37ZI0U82xK4odI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765886167; c=relaxed/simple;
	bh=Fh1paKlnYwh5qG1YgZJwKz1JBBTKJHA9hotI/z0MWUU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m1UHFyvuwj45268WR16/n/9yD3kJW3oWa45/6KsiqmYBDjg3uqwLvOwdKpey+f8mUn6gM2avAdYBHJDM6iRlkHaGIOXtaFZRzNsyMlcWDtHGL46eRh8c1q8BAcOCI9XJKZ/yFLCOV4X2jEqDaQkeBnIZsn1m5OxDAvFS1PSKghM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FjXXf9KX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FjXXf9KX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3607C4CEF1;
	Tue, 16 Dec 2025 11:56:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765886166;
	bh=Fh1paKlnYwh5qG1YgZJwKz1JBBTKJHA9hotI/z0MWUU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FjXXf9KX02cF15wjHE0WWRo0QtjsxqHq1nxkpXTGpniFWpZkg86PkumSTHzjiUg1i
	 8yzX/4Jtb2s7TSmvhlIYrKpxhWA4uoG6n6tj/AOqGBd2+8BiT/PECavkLCFyHVkBdK
	 adeO83LoepojnOm+T3rWvKw66y7ePGgbdCwc2oFo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>,
	Daniel Lezcano <daniel.lezcano@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 358/507] clocksource/drivers/nxp-stm: Fix section mismatches
Date: Tue, 16 Dec 2025 12:13:19 +0100
Message-ID: <20251216111358.426324424@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

[ Upstream commit b452d2c97eeccbf9c7ac5b3d2d9e80bf6d8a23db ]

Platform drivers can be probed after their init sections have been
discarded (e.g. on probe deferral or manual rebind through sysfs) so the
probe function must not live in init. Device managed resource actions
similarly cannot be discarded.

The "_probe" suffix of the driver structure name prevents modpost from
warning about this so replace it to catch any similar future issues.

Fixes: cec32ac75827 ("clocksource/drivers/nxp-timer: Add the System Timer Module for the s32gx platforms")
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: stable@vger.kernel.org	# 6.16
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
Link: https://patch.msgid.link/20251017054943.7195-1-johan@kernel.org
Stable-dep-of: 6a2416892e89 ("clocksource/drivers/nxp-stm: Prevent driver unbind")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clocksource/timer-nxp-stm.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/clocksource/timer-nxp-stm.c b/drivers/clocksource/timer-nxp-stm.c
index 8bca183abe8f2..bbb671b6e0284 100644
--- a/drivers/clocksource/timer-nxp-stm.c
+++ b/drivers/clocksource/timer-nxp-stm.c
@@ -177,15 +177,15 @@ static void nxp_stm_clocksource_resume(struct clocksource *cs)
 	nxp_stm_clocksource_enable(cs);
 }
 
-static void __init devm_clocksource_unregister(void *data)
+static void devm_clocksource_unregister(void *data)
 {
 	struct stm_timer *stm_timer = data;
 
 	clocksource_unregister(&stm_timer->cs);
 }
 
-static int __init nxp_stm_clocksource_init(struct device *dev, struct stm_timer *stm_timer,
-					   const char *name, void __iomem *base, struct clk *clk)
+static int nxp_stm_clocksource_init(struct device *dev, struct stm_timer *stm_timer,
+				    const char *name, void __iomem *base, struct clk *clk)
 {
 	int ret;
 
@@ -295,9 +295,9 @@ static void nxp_stm_clockevent_resume(struct clock_event_device *ced)
 	nxp_stm_module_get(stm_timer);
 }
 
-static int __init nxp_stm_clockevent_per_cpu_init(struct device *dev, struct stm_timer *stm_timer,
-						  const char *name, void __iomem *base, int irq,
-						  struct clk *clk, int cpu)
+static int nxp_stm_clockevent_per_cpu_init(struct device *dev, struct stm_timer *stm_timer,
+					   const char *name, void __iomem *base, int irq,
+					   struct clk *clk, int cpu)
 {
 	stm_timer->base = base;
 	stm_timer->rate = clk_get_rate(clk);
@@ -384,7 +384,7 @@ static irqreturn_t nxp_stm_module_interrupt(int irq, void *dev_id)
 	return IRQ_HANDLED;
 }
 
-static int __init nxp_stm_timer_probe(struct platform_device *pdev)
+static int nxp_stm_timer_probe(struct platform_device *pdev)
 {
 	struct stm_timer *stm_timer;
 	struct device *dev = &pdev->dev;
@@ -480,14 +480,14 @@ static const struct of_device_id nxp_stm_of_match[] = {
 };
 MODULE_DEVICE_TABLE(of, nxp_stm_of_match);
 
-static struct platform_driver nxp_stm_probe = {
+static struct platform_driver nxp_stm_driver = {
 	.probe	= nxp_stm_timer_probe,
 	.driver	= {
 		.name		= "nxp-stm",
 		.of_match_table	= nxp_stm_of_match,
 	},
 };
-module_platform_driver(nxp_stm_probe);
+module_platform_driver(nxp_stm_driver);
 
 MODULE_DESCRIPTION("NXP System Timer Module driver");
 MODULE_LICENSE("GPL");
-- 
2.51.0



