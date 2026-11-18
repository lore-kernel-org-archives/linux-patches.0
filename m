Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052527;
	b=lCofoZ3PlM0t0JogfywGAfM8qfYKLccvljF6+N3I+svHc61n+6rK2KoPGBfa11AIRJ8E
	 HqKlTwHeA4vRlZpC1m7v0125D7jhUVxBDS5ox9m+GxWWRcQTa3XjXaP73DUjCFpDO3rL2
	 9DC+w7mt46MKLJQWMhUFgHkUxN+bF5qQeHN+Y885bz11ei0BtJYnh82QJdaTe3HT1UO/m
	 tJ6d9zPu1FIEqg02fHFuPbeVg2c5Qv8YZepc5JSzad5BAaGWnmDGGHrAvLb4DWk2WdV2X
	 QV9+BDbMwimKklHW4j9ZJWsJ0VyR51SZ8dFCgvq0zhaUzG/K0xnOj3loxmdnag/tIYQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052527;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=sY0B3waRAe89OD/g6y+Lj7B6TNe4cwFcL0v7oMQu064=;
	b=0dHzatNL2OaMFP9zsplgudu/rC/QxhBiFeYc93xOQi5oMeYCR9ncaWaOwRUL7vOXgJNb
	 mPFJF7p/gOiWREGkJw4aUpbqjy1eImTcxCN+r4QYoatTrOLgJcnVY2JSj+NvbpDXystLB
	 SeSj4Ou4/eAViHrQAIEvmIJxHFjHUdE27ZvBkxFkjLqhyrg0wn9gk9gg4hB9fK7KIkkVE
	 xrRNgFb/T0Y9PRSzowyhhaeSSmBwN4M9GIe+kSVO4qp/jdAuFHkAA0tiNRwW6+sqbxXgk
	 hfSRP/TVu5x3tuK9Ze6hWNBrE4BIpgNvwm8x9kA876u24D1sovTP/YqgLRIRtlFcbWw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=btlpEc2i;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46CF7606A31C;
	Thu, 19 Nov 2026 01:42:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=btlpEc2i
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98F051F000C4;
	Thu, 19 Nov 2026 01:42:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052527;
	bh=sY0B3waRAe89OD/g6y+Lj7B6TNe4cwFcL0v7oMQu064=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=btlpEc2iPIa7LRHSLvC+SuKkS6nJ/EB6Uyhj4EGmUGPdj9Avn31CvYRBfyAVhdrA9
	 IxWyp/TxtNH0G1QZvKtOJ2FuvD2Vl2oYfoUD3bOIbS70SIf5oTJXUybG9QSd0CjjUX
	 aUCM2mx8hFeraKNYSpIEBSJ5t1XGk7SKvUtiXe5c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Daniel Lezcano <daniel.lezcano@kernel.org>,
	Baruch Siach <baruch@tkos.co.il>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0595/2214] clocksource/drivers/digicolor: Fix clk reference leak on request_irq failure
Date: Wed, 18 Nov 2026 15:37:51 +0100
Message-ID: <20261118150034.773695134@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wentao Liang <vulab@iscas.ac.cn>

[ Upstream commit 9cc2e18b32f12d26ae6729c62a03640423956b17 ]

digicolor_timer_init() obtains the timer clock with of_clk_get() and
enables it, but the request_irq() failure path returns without releasing
the clock reference, leaking both the enable/prepare state and the
reference itself.

Disable and put the clock before returning on the request_irq() failure
path. The success path keeps the clock enabled for the lifetime of the
timer and is left untouched.

Fixes: 9b8bb7736b78 ("clocksource: Driver for Conexant Digicolor SoC timer")
Cc: stable@vger.kernel.org
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Signed-off-by: Daniel Lezcano <daniel.lezcano@kernel.org>
Acked-by: Baruch Siach <baruch@tkos.co.il>
Link: https://patch.msgid.link/20260915045242.1726702-1-vulab@iscas.ac.cn
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clocksource/timer-digicolor.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/clocksource/timer-digicolor.c b/drivers/clocksource/timer-digicolor.c
index 1e984a4d8ad00..ae758b3059cc1 100644
--- a/drivers/clocksource/timer-digicolor.c
+++ b/drivers/clocksource/timer-digicolor.c
@@ -193,6 +193,8 @@ static int __init digicolor_timer_init(struct device_node *node)
 			  &dc_timer_dev.ce);
 	if (ret) {
 		pr_warn("request of timer irq %d failed (%d)\n", irq, ret);
+		clk_disable_unprepare(clk);
+		clk_put(clk);
 		return ret;
 	}
 
-- 
2.53.0



