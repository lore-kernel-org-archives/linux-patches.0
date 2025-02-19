Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7786A1C2DC8;
	Wed, 19 Feb 2025 09:28:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739957299; cv=none; b=XbVxtOnPvY51qTvqLPLJvREMpyRTkAorvPWPsTE+8jrOL0QoF+MA4bboztz+YzeQLecViCJUKn6aVxqBmUsY6Ji5zi4rPm8+reZaJvyNYqM5fW4NPgrjMFESCUYg2CJCOgTvDMOAZA0oOC4teOflmdhlryscpLyNJ4bYOzbYejA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739957299; c=relaxed/simple;
	bh=ZPsDaNznzeWV+JxViRaBFu3J1NIED8ZAqTatLxItU9Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RDUaS3n59y9eOu2qcyVYgjXDHdaVTzdMgTnBKIHb24i+YPTlf3WeBOUgih5BP8611a4IdlsLBZVtrBS2jOcrd2GHN78EGVfdzvI0McqjUlbiUAgqIoNr4aGwc1EOwgjzz/78gEQ1qVU9LNECbGG1hc35lbKsyjF/qFqkDnqK+7A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l3l/Hl1x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l3l/Hl1x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2B77C4CED1;
	Wed, 19 Feb 2025 09:28:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739957299;
	bh=ZPsDaNznzeWV+JxViRaBFu3J1NIED8ZAqTatLxItU9Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l3l/Hl1x21gXeEhH+p3YPpLz+ibA+iG2CtE740LgWyt44byeKImrcJblD0DbvjXq6
	 ogoPpGkotstp7EWquWDGNwGnYZz24NPJ/57P8eap3L9BE2M6IECxrXjZFxMOXHgcxR
	 Kb03Zuis40P5PKziXHpULRkA2c6GxMkumxZ8pjA0=
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
Subject: [PATCH 6.1 477/578] gpio: bcm-kona: Add missing newline to dev_err format string
Date: Wed, 19 Feb 2025 09:28:01 +0100
Message-ID: <20250219082711.767422384@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 602021e3e683e..3373e46e3ba0f 100644
--- a/drivers/gpio/gpio-bcm-kona.c
+++ b/drivers/gpio/gpio-bcm-kona.c
@@ -667,7 +667,7 @@ static int bcm_kona_gpio_probe(struct platform_device *pdev)
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



