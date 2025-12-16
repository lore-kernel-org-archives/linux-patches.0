Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C54034F491;
	Tue, 16 Dec 2025 12:28:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765888114; cv=none; b=Bu4rsKjSCKrFcKLup4yk9PLXx9Djx+k0lyHcY6Bgbmx+wqMcaTUD9e14bu9jJ8gSiI6B6peSRUCbvRSnSvW8Qnpr2l8I1ifYmcdy5B/LQwA4teEGTMC9kFmiTWh9e61eU375RlWGnbvuF7a/hDQnQuRNF/HU9n4n0dHka9VjAl8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765888114; c=relaxed/simple;
	bh=TnykhzhBJ3QmAXvYYOTFiWS9Roj82xExLv09GySZKfY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tgi4K28LVpnf2QYHW00+UxdHpq/OvFX5XhTAZ+rXzQz81cUwHahKIbTfmcQtTTePYrMsOOeK//cNxxf98DqyKs/rNVymmUCin9ARYRvS4rqSnBTb2GA+TWY8Fb0y1YzOn8CjegpDseJvbfco3RNCbte9ODt3H/S2hGAj1Pmi7PM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bwmcgc22; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bwmcgc22"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED987C4CEF1;
	Tue, 16 Dec 2025 12:28:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765888114;
	bh=TnykhzhBJ3QmAXvYYOTFiWS9Roj82xExLv09GySZKfY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bwmcgc22o4KbKTjWDVhzo5CA9CatZ3LwitbfcHUkfUv5vL69ZHf76QbibD6gDEEwR
	 KwxDotQu7EaQ3WFO4g+lAeIaINxJrZACOCvoQaBtImaxvtm8uqtiqgL/gXI179B8W1
	 QQihZVve7POSjt2njrFWcNTnR6fm80J7QRT+nyik=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>,
	Daniel Lezcano <daniel.lezcano@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 436/614] clocksource/drivers/nxp-stm: Fix section mismatches
Date: Tue, 16 Dec 2025 12:13:23 +0100
Message-ID: <20251216111417.170854004@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 16d52167e949b..c320d764b12e2 100644
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
 
@@ -296,9 +296,9 @@ static void nxp_stm_clockevent_resume(struct clock_event_device *ced)
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
@@ -386,7 +386,7 @@ static irqreturn_t nxp_stm_module_interrupt(int irq, void *dev_id)
 	return IRQ_HANDLED;
 }
 
-static int __init nxp_stm_timer_probe(struct platform_device *pdev)
+static int nxp_stm_timer_probe(struct platform_device *pdev)
 {
 	struct stm_timer *stm_timer;
 	struct device *dev = &pdev->dev;
@@ -482,14 +482,14 @@ static const struct of_device_id nxp_stm_of_match[] = {
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



