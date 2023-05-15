Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3C6F156E8
	for <patches@lists.linux.dev>; Mon, 15 May 2023 18:00:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1D47C433EF;
	Mon, 15 May 2023 18:00:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684173655;
	bh=96ri945r7+nJC4Ob5qW2MqOtvCBFydGQhJiyymX/5Mw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WGaDpvn2IFKORth/VTSuJJROfsPj9F0/C5qspeo2EclNyUiHW6jfqbtejEsOxXUoh
	 zZal2xIM/m9mG6OaOuy2sfBanstugiBtHa7B7QBsYRvSvAKxG7ZfdpHTmz8XRuGV5W
	 14Rot+qE+pdSFv9mAw+a+rauSU0fdvCg0YDRAqO4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 163/282] rtc: omap: include header for omap_rtc_power_off_program prototype
Date: Mon, 15 May 2023 18:29:01 +0200
Message-Id: <20230515161727.097539075@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161722.146344674@linuxfoundation.org>
References: <20230515161722.146344674@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

[ Upstream commit f69c2b5420497b7a54181ce170d682cbeb1f119f ]

Non-static functions should have a prototype:

  drivers/rtc/rtc-omap.c:410:5: error: no previous prototype for ‘omap_rtc_power_off_program’ [-Werror=missing-prototypes]

Fixes: 6256f7f7f217 ("rtc: OMAP: Add support for rtc-only mode")
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Link: https://lore.kernel.org/r/20230311094021.79730-1-krzysztof.kozlowski@linaro.org
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rtc/rtc-omap.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/rtc/rtc-omap.c b/drivers/rtc/rtc-omap.c
index a2941c875a064..bf502fcd60772 100644
--- a/drivers/rtc/rtc-omap.c
+++ b/drivers/rtc/rtc-omap.c
@@ -26,6 +26,7 @@
 #include <linux/platform_device.h>
 #include <linux/pm_runtime.h>
 #include <linux/rtc.h>
+#include <linux/rtc/rtc-omap.h>
 
 /*
  * The OMAP RTC is a year/month/day/hours/minutes/seconds BCD clock
-- 
2.39.2



