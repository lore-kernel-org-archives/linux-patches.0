Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A75C1863
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 15:13:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93D4BC433D2;
	Wed, 28 Dec 2022 15:13:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672240419;
	bh=qwrxr7RPGVR8p5Kz6WWEOmJBqTEzq4p/wuD9A2dHmOU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f5deX6O/duClqwXHgL+GzaOZwoa6RFHQ7ISo6H64uZEWh1uNsW1+7ypN6JMqUxwnX
	 uURDvhSOyLL3OweTn+EBdPM8jH6JLarn8mLC1/yw0JKUPgJeKYkjjXQBPbc2s0k0zx
	 pssaOXM7yLct2Nsrk152Qs/kISXiLQBFW3VYlREY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Tony Lindgren <tony@atomide.com>,
	Daniel Lezcano <daniel.lezcano@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0158/1073] clocksource/drivers/timer-ti-dm: Fix warning for omap_timer_match
Date: Wed, 28 Dec 2022 15:29:06 +0100
Message-Id: <20221228144332.311634660@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Tony Lindgren <tony@atomide.com>

[ Upstream commit 9688498b1648aa98a3ee45d9f07763c099f6fb12 ]

We can now get a warning for 'omap_timer_match' defined but not used.
Let's fix this by dropping of_match_ptr for omap_timer_match.

Reported-by: kernel test robot <lkp@intel.com>
Fixes: ab0bbef3ae0f ("clocksource/drivers/timer-ti-dm: Make timer selectable for ARCH_K3")
Signed-off-by: Tony Lindgren <tony@atomide.com>
Link: https://lore.kernel.org/r/20221028103526.40319-1-tony@atomide.com
Signed-off-by: Daniel Lezcano <daniel.lezcano@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clocksource/timer-ti-dm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clocksource/timer-ti-dm.c b/drivers/clocksource/timer-ti-dm.c
index 469f7c91564b..78c2c038d3ae 100644
--- a/drivers/clocksource/timer-ti-dm.c
+++ b/drivers/clocksource/timer-ti-dm.c
@@ -1081,7 +1081,7 @@ static struct platform_driver omap_dm_timer_driver = {
 	.remove = omap_dm_timer_remove,
 	.driver = {
 		.name   = "omap_timer",
-		.of_match_table = of_match_ptr(omap_timer_match),
+		.of_match_table = omap_timer_match,
 		.pm = &omap_dm_timer_pm_ops,
 	},
 };
-- 
2.35.1



