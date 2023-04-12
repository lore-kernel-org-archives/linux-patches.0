Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABF8D2F24
	for <patches@lists.linux.dev>; Wed, 12 Apr 2023 08:46:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31760C433EF;
	Wed, 12 Apr 2023 08:46:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1681289205;
	bh=35mf5ffV2Hsiw9nanuW/NjMbpglLvEal+H70pxjnGMU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zcHKTT1YO6pDXz+nBk10uctnCz7dGfCRUm8bom401FWYLm5iZrPD/sdby/2K38pgm
	 6RrPN+nWwMc2qVmmMM6kcBvfC9Oj6/sBOtC3BvgGKsfhsucDwYSxiAmYzFqGhAZF8Q
	 0DHTwPyT45rXYbbViO+3+NTV4g3TePRADGyNNwQ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guenter Roeck <groeck@chromium.org>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Thierry Reding <thierry.reding@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 011/173] pwm: cros-ec: Explicitly set .polarity in .get_state()
Date: Wed, 12 Apr 2023 10:32:17 +0200
Message-Id: <20230412082838.566969979@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230412082838.125271466@linuxfoundation.org>
References: <20230412082838.125271466@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

[ Upstream commit 30006b77c7e130e01d1ab2148cc8abf73dfcc4bf ]

The driver only supports normal polarity. Complete the implementation of
.get_state() by setting .polarity accordingly.

Reviewed-by: Guenter Roeck <groeck@chromium.org>
Fixes: 1f0d3bb02785 ("pwm: Add ChromeOS EC PWM driver")
Link: https://lore.kernel.org/r/20230228135508.1798428-3-u.kleine-koenig@pengutronix.de
Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Signed-off-by: Thierry Reding <thierry.reding@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pwm/pwm-cros-ec.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/pwm/pwm-cros-ec.c b/drivers/pwm/pwm-cros-ec.c
index 86df6702cb835..ad18b0ebe3f1e 100644
--- a/drivers/pwm/pwm-cros-ec.c
+++ b/drivers/pwm/pwm-cros-ec.c
@@ -198,6 +198,7 @@ static int cros_ec_pwm_get_state(struct pwm_chip *chip, struct pwm_device *pwm,
 
 	state->enabled = (ret > 0);
 	state->period = EC_PWM_MAX_DUTY;
+	state->polarity = PWM_POLARITY_NORMAL;
 
 	/*
 	 * Note that "disabled" and "duty cycle == 0" are treated the same. If
-- 
2.39.2



