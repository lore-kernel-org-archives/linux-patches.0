Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E20B2227EA0;
	Mon, 10 Mar 2025 17:59:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741629589; cv=none; b=cYa2pQ8yzCw2JRuV4ptTUWKPvzFf1WKe7Vu3XnHwaoUK3cL9Iqdm8pTxc2WulAUv60FUp/fMKbzgP+E8/smiYjXCMKrnieUUTPHgQr0Xz1MbVe3P0kd7aniiSTciKtVPYuBHdvLoo11xiDaj7+Nhbg02qQZ4HRCe0HtT3sV930g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741629589; c=relaxed/simple;
	bh=nq5Sn8RJboME3L0zriYZcXJTysP8cGVxPj5A0wfZwT4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eQ9z9CmUwuwZUFGF1jmvw9EvpySR5fHKcNkjYHxj4BzvVqpq4eF48aZ+5ft+64uRqWIid5040aP8HYjtZzoXjx5jZ6DinxoQGlA0z0m8xhlp3pc1J8LpZaOxuPzTkxOM+Hsr3vMDf9xzqKchzQAKpRZ8sUwcFYbn+PAL4RBHi+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c2PCO16F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c2PCO16F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A651C4CEE5;
	Mon, 10 Mar 2025 17:59:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741629588;
	bh=nq5Sn8RJboME3L0zriYZcXJTysP8cGVxPj5A0wfZwT4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c2PCO16FMbT3S5YiiecIGo/gcwjFC3TCI3vSsR+dflU7GYUlSmAzYe0/KFpmLY9aZ
	 GiYoXQI5yBJZtr1nf9RC/Fi458Qz4aTJW/cEC8z+0mzTCyt1y1ZTwu3gbiz8l9HwB3
	 geKOmSWQ545nPCvBfrKBWb0KezgJQDO69i8tbK+o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Markus Mayer <mmayer@broadcom.com>,
	Artur Weber <aweber.kernel@gmail.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 345/620] gpio: bcm-kona: Add missing newline to dev_err format string
Date: Mon, 10 Mar 2025 18:03:11 +0100
Message-ID: <20250310170559.230842377@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Artur Weber <aweber.kernel@gmail.com>

[ Upstream commit 615279db222c3ac56d5c93716efd72b843295c1f ]

Add a missing newline to the format string of the "Couldn't get IRQ
for bank..." error message.

Fixes: 757651e3d60e ("gpio: bcm281xx: Add GPIO driver")
Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
Reviewed-by: Markus Mayer <mmayer@broadcom.com>
Signed-off-by: Artur Weber <aweber.kernel@gmail.com>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Link: https://lore.kernel.org/r/20250206-kona-gpio-fixes-v2-3-409135eab780@gmail.com
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-bcm-kona.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpio/gpio-bcm-kona.c b/drivers/gpio/gpio-bcm-kona.c
index 4734749b90860..0c97a8c95e06c 100644
--- a/drivers/gpio/gpio-bcm-kona.c
+++ b/drivers/gpio/gpio-bcm-kona.c
@@ -675,7 +675,7 @@ static int bcm_kona_gpio_probe(struct platform_device *pdev)
 		bank->irq = platform_get_irq(pdev, i);
 		bank->kona_gpio = kona_gpio;
 		if (bank->irq < 0) {
-			dev_err(dev, "Couldn't get IRQ for bank %d", i);
+			dev_err(dev, "Couldn't get IRQ for bank %d\n", i);
 			ret = -ENOENT;
 			goto err_irq_domain;
 		}
-- 
2.39.5



