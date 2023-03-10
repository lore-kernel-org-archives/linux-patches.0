Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 307858820
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 14:53:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90FBFC4339B;
	Fri, 10 Mar 2023 14:53:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678459997;
	bh=gVM/sQb3b/ii4lOzWcwoMNziz5kQc2Nju5sWYmrNyjI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KV2o737+zwWvTxo29J4J99/3ugQMTREFyR/HIgcLKFfuO+Gl31te8RsLpjvho3BpP
	 uMDrBXBhhn0uhjVE8N2frkTuYUkuTGsC1zI08kNXTGPaz9Izd0+TJ+huO3oAmsM+i7
	 0WsK7BTaUGZBzDK7W8vkWqdIvj70auhTopUgR9u4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Stefan Wahren <stefan.wahren@i2se.com>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 181/529] pinctrl: bcm2835: Remove of_node_put() in bcm2835_of_gpio_ranges_fallback()
Date: Fri, 10 Mar 2023 14:35:24 +0100
Message-Id: <20230310133813.339205887@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133804.978589368@linuxfoundation.org>
References: <20230310133804.978589368@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit 2d578dd27871372f7159dd3206149ec616700d87 ]

Remove wrong of_node_put() in bcm2835_of_gpio_ranges_fallback(),
there is no counterpart of_node_get() for it.

Fixes: d2b67744fd99 ("pinctrl: bcm2835: implement hook for missing gpio-ranges")
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reviewed-by: Stefan Wahren <stefan.wahren@i2se.com>
Tested-by: Stefan Wahren <stefan.wahren@i2se.com>
Tested-by: Florian Fainelli <f.fainelli@gmail.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Acked-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Link: https://lore.kernel.org/r/20230113215352.44272-3-andriy.shevchenko@linux.intel.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/bcm/pinctrl-bcm2835.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/pinctrl/bcm/pinctrl-bcm2835.c b/drivers/pinctrl/bcm/pinctrl-bcm2835.c
index 39d2024dc2ee5..c7ae9f900b532 100644
--- a/drivers/pinctrl/bcm/pinctrl-bcm2835.c
+++ b/drivers/pinctrl/bcm/pinctrl-bcm2835.c
@@ -356,8 +356,6 @@ static int bcm2835_of_gpio_ranges_fallback(struct gpio_chip *gc,
 {
 	struct pinctrl_dev *pctldev = of_pinctrl_get(np);
 
-	of_node_put(np);
-
 	if (!pctldev)
 		return 0;
 
-- 
2.39.2



