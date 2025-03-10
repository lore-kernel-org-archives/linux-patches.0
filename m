Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C56052F28;
	Mon, 10 Mar 2025 17:18:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741627098; cv=none; b=DcR+IwcoxILpvULujJKKquWVm+6I6/4+4D33cEYTvMlJmFRoExTVoywAVDQJVptFigxvg6BpZ5KnUAVTKzrYrI7Y5ZUMYLj5ko6ZUk8WJ3+m73LExW5sGK4DoJ4yr/LXDlS0V83d8jKMrn0txGoG3x5qTagkMxCdhP7D6pDZQaY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741627098; c=relaxed/simple;
	bh=S7tqza+pQJdNoPSYk0v9orRusJzhdj/fcleJsXhYQ+8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lCrEGwbUlohafbjCB6XJU/9XU8VgUdBORi/lno/PSVoyxm6+KvXdSR3kZB3JydbM/Pv53Pfi5TJ8MzamT3AY5DyE5Pyd9/iH4yL7wIlQ63DH7gCH180HwvqR/EpZbUaEFUA3O0vkaS9Ycg6YKronzbwPHEj8b/h6i3czrsWSwl4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HJRYIVZn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HJRYIVZn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41DF7C4CEE5;
	Mon, 10 Mar 2025 17:18:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741627098;
	bh=S7tqza+pQJdNoPSYk0v9orRusJzhdj/fcleJsXhYQ+8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HJRYIVZntOby8AIOj8TbkofbzIXFHCDghp/DyfS79I5gET3q+AEpwG1t10wcJ0oic
	 SMYf3CZ3zckeYFXJyzxJcY79Muv+tZ4cUrN3FjK9kdcpQC8M+yEGeSHivT/88oPI6p
	 3pinMPJq+qaPyRdoONsi/VrVkmxXJOzp3UzwQSOQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Walleij <linus.walleij@linaro.org>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 005/269] gpio: vf610: use generic device_get_match_data()
Date: Mon, 10 Mar 2025 18:02:38 +0100
Message-ID: <20250310170457.920437316@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170457.700086763@linuxfoundation.org>
References: <20250310170457.700086763@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>

[ Upstream commit 1b35c124f961b355dafb1906c591191bd0b37417 ]

There's no need to use the OF-specific variant to get the match data.
Switch to using device_get_match_data() and with that remove the of.h
include. Also remove of_irq.h as none of its interfaces is used here and
order the includes in alphabetical order.

Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Link: https://lore.kernel.org/r/20241007102549.34926-1-brgl@bgdev.pl
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Stable-dep-of: 4e667a196809 ("gpio: vf610: add locking to gpio direction functions")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-vf610.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/gpio/gpio-vf610.c b/drivers/gpio/gpio-vf610.c
index 27eff741fe9a2..c4f34a347cb6e 100644
--- a/drivers/gpio/gpio-vf610.c
+++ b/drivers/gpio/gpio-vf610.c
@@ -15,10 +15,9 @@
 #include <linux/io.h>
 #include <linux/ioport.h>
 #include <linux/irq.h>
-#include <linux/platform_device.h>
-#include <linux/of.h>
-#include <linux/of_irq.h>
 #include <linux/pinctrl/consumer.h>
+#include <linux/platform_device.h>
+#include <linux/property.h>
 
 #define VF610_GPIO_PER_PORT		32
 
@@ -297,7 +296,7 @@ static int vf610_gpio_probe(struct platform_device *pdev)
 	if (!port)
 		return -ENOMEM;
 
-	port->sdata = of_device_get_match_data(dev);
+	port->sdata = device_get_match_data(dev);
 
 	dual_base = port->sdata->have_dual_base;
 
-- 
2.39.5



