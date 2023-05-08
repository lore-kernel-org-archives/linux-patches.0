Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39E791549F
	for <patches@lists.linux.dev>; Mon,  8 May 2023 10:12:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2610C433D2;
	Mon,  8 May 2023 10:12:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683540748;
	bh=7EUzsX8JrcFemhdwca7bezGO5URyHPSzWt/iPLv0KYk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sFQMM18Q/Tc+NMK1TNUBcYPuqGvFLVeya0S4m7n3JmWBLp/q3D6w/NDqj5dr6xA60
	 lDjnazfdS1hMoynSuGOw4U5IRTxxo669t+9b92tEjkGhKH5wzwZlZNETwvHpAHtOIl
	 B+R11YwHG48SLUsG7YeMMI6QcfQmVpv4vOT/HEWU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 481/611] rtc: omap: include header for omap_rtc_power_off_program prototype
Date: Mon,  8 May 2023 11:45:23 +0200
Message-Id: <20230508094437.718616242@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094421.513073170@linuxfoundation.org>
References: <20230508094421.513073170@linuxfoundation.org>
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
index 4d4f3b1a73093..73634a3ccfd3b 100644
--- a/drivers/rtc/rtc-omap.c
+++ b/drivers/rtc/rtc-omap.c
@@ -25,6 +25,7 @@
 #include <linux/platform_device.h>
 #include <linux/pm_runtime.h>
 #include <linux/rtc.h>
+#include <linux/rtc/rtc-omap.h>
 
 /*
  * The OMAP RTC is a year/month/day/hours/minutes/seconds BCD clock
-- 
2.39.2



