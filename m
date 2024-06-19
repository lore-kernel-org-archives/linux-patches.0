Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB6E9770F4;
	Wed, 19 Jun 2024 13:30:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718803851; cv=none; b=mF6COAUExji+7NzsD+eRq79QDatDPSsjq6/q1F9WMvRclJfnMA1XGJAdAeJ67eliJ8aeVfznjRDydfx4CD3iNU40noHrKu2eOIEoxHp6qYwyaHQjclWHyIg1TofFjaE6+2SYFAw2Xej7szEiBvGfmFgnHyhWsbrUl8AQ9rSbWDA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718803851; c=relaxed/simple;
	bh=N7/oDHiQwJ0hGM6fFnJl6g/dJzcOvd7g8Aw4GKZq7uE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qD62WYf2NB52TnHJIqK04+tA3EHTmqoLCeQmdXhHIYShcqPznu/n1mQWXP0x3u9Nc4muI2mNmrKIPsmtc/eAENvy3gXFuPkmdXNCRom539Qz8FhJKahEnrhhaY5SYqwcQUZHCqmi3qnCN5SFMv+dxvypg7wwCcYmZJyg9lCdpBc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YIXsADsX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YIXsADsX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5074FC2BBFC;
	Wed, 19 Jun 2024 13:30:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718803851;
	bh=N7/oDHiQwJ0hGM6fFnJl6g/dJzcOvd7g8Aw4GKZq7uE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YIXsADsXlk9x/ggD0vQzqCLA3KW/uP2S8sN502OW4bpwdIcbwtt9tyauJ64OUfSru
	 GhUPIOIX4ssJ9WJAM7POm+yjcvW6ILHS6yzF8NOyU3CLt2EvNCzqQsx0eCaTSsI2wx
	 olP0D1iYjd/QZ2bf8JWIvFv4xgPIwnW+cllSeduI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexandru Ardelean <alex@shruggie.ro>,
	Andrei Coardos <aboutphysycs@gmail.com>,
	Andy Shevchenko <andy.shevchenko@gmail.com>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 125/217] gpio: tqmx86: remove unneeded call to platform_set_drvdata()
Date: Wed, 19 Jun 2024 14:56:08 +0200
Message-ID: <20240619125601.512779878@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125556.491243678@linuxfoundation.org>
References: <20240619125556.491243678@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrei Coardos <aboutphysycs@gmail.com>

[ Upstream commit 0a5e9306b812fe3517548fab92b3d3d6ce7576e5 ]

This function call was found to be unnecessary as there is no equivalent
platform_get_drvdata() call to access the private data of the driver. Also,
the private data is defined in this driver, so there is no risk of it being
accessed outside of this driver file.

Reviewed-by: Alexandru Ardelean <alex@shruggie.ro>
Signed-off-by: Andrei Coardos <aboutphysycs@gmail.com>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Stable-dep-of: 9d6a811b522b ("gpio: tqmx86: introduce shadow register for GPIO output value")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-tqmx86.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/gpio/gpio-tqmx86.c b/drivers/gpio/gpio-tqmx86.c
index e739dcea61b23..f0a2cf4b06796 100644
--- a/drivers/gpio/gpio-tqmx86.c
+++ b/drivers/gpio/gpio-tqmx86.c
@@ -259,8 +259,6 @@ static int tqmx86_gpio_probe(struct platform_device *pdev)
 
 	tqmx86_gpio_write(gpio, (u8)~TQMX86_DIR_INPUT_MASK, TQMX86_GPIODD);
 
-	platform_set_drvdata(pdev, gpio);
-
 	chip = &gpio->chip;
 	chip->label = "gpio-tqmx86";
 	chip->owner = THIS_MODULE;
-- 
2.43.0



