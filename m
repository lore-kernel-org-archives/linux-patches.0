Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9452381A5
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 20:46:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pwqSaXrz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A683C433C7;
	Wed, 15 Nov 2023 20:46:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700081172;
	bh=XmrxugOBN7/OmjTpqPKpjlhydAUbQzfGrB7eVm0znTg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pwqSaXrzV8YSSdfzhzSlJjxM9i/3cXhfDP67qS2+TcoKHtlrGD0QlQIMYhP71E9Ha
	 +N54tLMeVJDSYJCUcGvW8iHDKAJBONWisnBdbVBV2UUy4ExEOw73UBkXKx60hWstmM
	 w4PbU6uaRUwMKlAuf6YDq/CDBD1rebP9vzApqaag=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <uwe@kleine-koenig.org>,
	Jeff LaBundy <jeff@labundy.com>,
	Pavel Machek <pavel@ucw.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 47/88] leds: pwm: simplify if condition
Date: Wed, 15 Nov 2023 15:35:59 -0500
Message-ID: <20231115191428.992111819@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191426.221330369@linuxfoundation.org>
References: <20231115191426.221330369@linuxfoundation.org>
User-Agent: quilt/0.67
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Uwe Kleine-König <uwe@kleine-koenig.org>

[ Upstream commit b43a8f01fccbfdddbc7f9b2bbad11b7db3fda4e1 ]

.pwm_period_ns is an unsigned integer. So when led->pwm_period_ns > 0
is false, we now assign 0 to a value that is already 0, so it doesn't
hurt and we can skip checking the actual value.

Signed-off-by: Uwe Kleine-König <uwe@kleine-koenig.org>
Tested-by: Jeff LaBundy <jeff@labundy.com>
Signed-off-by: Pavel Machek <pavel@ucw.cz>
Stable-dep-of: 76fe464c8e64 ("leds: pwm: Don't disable the PWM when the LED should be off")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/leds/leds-pwm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/leds/leds-pwm.c b/drivers/leds/leds-pwm.c
index 5d3faae51d59e..dc5c6100a419f 100644
--- a/drivers/leds/leds-pwm.c
+++ b/drivers/leds/leds-pwm.c
@@ -117,7 +117,7 @@ static int led_pwm_add(struct device *dev, struct led_pwm_priv *priv,
 	pwm_get_args(led_data->pwm, &pargs);
 
 	led_data->period = pargs.period;
-	if (!led_data->period && (led->pwm_period_ns > 0))
+	if (!led_data->period)
 		led_data->period = led->pwm_period_ns;
 
 	ret = led_classdev_register(dev, &led_data->cdev);
-- 
2.42.0



