Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCFD4215060;
	Tue, 29 Apr 2025 17:54:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745949280; cv=none; b=H/3xNpYfU0eVbGlhZBcEvGj2i6mTNUJOXKcZjsjc7PYwinuYP8ob3K4ASFWlDXZfiiB6JTSBrFuKW3rXtlKcYnTwB0N6PS/v7mT56lMLqjs5kdzui6NfN6ZVD4AhltM3Z0XhF9+DteB5eUuEd6xFDNjGTjLgDnMfe8fdycTaulI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745949280; c=relaxed/simple;
	bh=5N6EVp7o0GgjefxHnQ0J63yYgHlQA3ZI1Ho+yEkIjkM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rQgVZBe557qsH9Zp6QBQ5XdON12dTWLRmvIURloDJo9y8H4L2In0W7P7gYeFTfDUmkO8lmsqIRYrv9VYuN1PKrBP1AgSCd8IuhzCD/VCTvgqmitdOQn6CUBlIElQ8NOLTShWzFOJ3aYh0ivtN7iyvZ5h6SA/+GSIcxZPn1Rc0NA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VOKd8D42; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VOKd8D42"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5815BC4CEE3;
	Tue, 29 Apr 2025 17:54:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745949280;
	bh=5N6EVp7o0GgjefxHnQ0J63yYgHlQA3ZI1Ho+yEkIjkM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VOKd8D42gaxJoiHgCNB11blPaj5ImS8OOLa3l7RC7LlWuBH/LA/WuN4HgAeqkBmFJ
	 D8QBOvtEOWPKK4DugYf/srw7o1OD+p/Ic/mjtZx3fYgQStFI6OpftCQ5+/NjhaSB1k
	 5ekRggtGK2v0SFAPFgOqgpApchYF3/zj9HORXfD8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Daniel Thompson <daniel.thompson@linaro.org>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 268/373] backlight: led_bl: Convert to platform remove callback returning void
Date: Tue, 29 Apr 2025 18:42:25 +0200
Message-ID: <20250429161134.145741327@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161123.119104857@linuxfoundation.org>
References: <20250429161123.119104857@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

[ Upstream commit c4c4fa57fd3cc00020152baa169337521f90b2ad ]

The .remove() callback for a platform driver returns an int which makes
many driver authors wrongly assume it's possible to do error handling by
returning an error code. However the value returned is (mostly) ignored
and this typically results in resource leaks. To improve here there is a
quest to make the remove callback return void. In the first step of this
quest all drivers are converted to .remove_new() which already returns
void.

Trivially convert this driver from always returning zero in the remove
callback to the void returning variant.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Reviewed-by: Daniel Thompson <daniel.thompson@linaro.org>
Signed-off-by: Lee Jones <lee@kernel.org>
Link: https://lore.kernel.org/r/20230308073945.2336302-7-u.kleine-koenig@pengutronix.de
Stable-dep-of: 276822a00db3 ("backlight: led_bl: Hold led_access lock when calling led_sysfs_disable()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/backlight/led_bl.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/video/backlight/led_bl.c b/drivers/video/backlight/led_bl.c
index f54d256e2d548..a1b6a2ad73a07 100644
--- a/drivers/video/backlight/led_bl.c
+++ b/drivers/video/backlight/led_bl.c
@@ -217,7 +217,7 @@ static int led_bl_probe(struct platform_device *pdev)
 	return 0;
 }
 
-static int led_bl_remove(struct platform_device *pdev)
+static void led_bl_remove(struct platform_device *pdev)
 {
 	struct led_bl_data *priv = platform_get_drvdata(pdev);
 	struct backlight_device *bl = priv->bl_dev;
@@ -228,8 +228,6 @@ static int led_bl_remove(struct platform_device *pdev)
 	led_bl_power_off(priv);
 	for (i = 0; i < priv->nb_leds; i++)
 		led_sysfs_enable(priv->leds[i]);
-
-	return 0;
 }
 
 static const struct of_device_id led_bl_of_match[] = {
@@ -245,7 +243,7 @@ static struct platform_driver led_bl_driver = {
 		.of_match_table	= of_match_ptr(led_bl_of_match),
 	},
 	.probe		= led_bl_probe,
-	.remove		= led_bl_remove,
+	.remove_new	= led_bl_remove,
 };
 
 module_platform_driver(led_bl_driver);
-- 
2.39.5



