Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C397746F
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 20:37:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2AB7C433C7;
	Sun, 17 Sep 2023 20:37:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694983027;
	bh=fCptCeZLtHi26O6GA/NKAWcLtMDhByEgTS5QW6ElClQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=symrcXbBsxtdrXpx/45OBE0GJK+axpYkmxue7+ECyZyWzR4QYc4+9AHvjJKFCxQls
	 IYRI5VIXjElSEGapgO/rByy9elPtYhXexOExel4z+MG1yT8fhAcC0SC2IWKqTNfK56
	 Exu3DeG/JnO7/fEIhLNjTVtbPimAAL+KxlWHfik4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liu Ying <victor.liu@nxp.com>,
	Andy Shevchenko <andy@kernel.org>,
	Linus Walleij <linus.walleij@linaro.org>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 416/511] backlight: gpio_backlight: Drop output GPIO direction check for initial power state
Date: Sun, 17 Sep 2023 21:14:03 +0200
Message-ID: <20230917191123.825488287@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191113.831992765@linuxfoundation.org>
References: <20230917191113.831992765@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Ying Liu <victor.liu@nxp.com>

[ Upstream commit fe1328b5b2a087221e31da77e617f4c2b70f3b7f ]

So, let's drop output GPIO direction check and only check GPIO value to set
the initial power state.

Fixes: 706dc68102bc ("backlight: gpio: Explicitly set the direction of the GPIO")
Signed-off-by: Liu Ying <victor.liu@nxp.com>
Reviewed-by: Andy Shevchenko <andy@kernel.org>
Acked-by: Linus Walleij <linus.walleij@linaro.org>
Acked-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Link: https://lore.kernel.org/r/20230721093342.1532531-1-victor.liu@nxp.com
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/backlight/gpio_backlight.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/video/backlight/gpio_backlight.c b/drivers/video/backlight/gpio_backlight.c
index 5c5c99f7979e3..30ec5b6845335 100644
--- a/drivers/video/backlight/gpio_backlight.c
+++ b/drivers/video/backlight/gpio_backlight.c
@@ -87,8 +87,7 @@ static int gpio_backlight_probe(struct platform_device *pdev)
 		/* Not booted with device tree or no phandle link to the node */
 		bl->props.power = def_value ? FB_BLANK_UNBLANK
 					    : FB_BLANK_POWERDOWN;
-	else if (gpiod_get_direction(gbl->gpiod) == 0 &&
-		 gpiod_get_value_cansleep(gbl->gpiod) == 0)
+	else if (gpiod_get_value_cansleep(gbl->gpiod) == 0)
 		bl->props.power = FB_BLANK_POWERDOWN;
 	else
 		bl->props.power = FB_BLANK_UNBLANK;
-- 
2.40.1



