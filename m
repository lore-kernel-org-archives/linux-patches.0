Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 891D22566
	for <patches@lists.linux.dev>; Tue, 18 Apr 2023 12:32:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1850C433EF;
	Tue, 18 Apr 2023 12:32:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1681821172;
	bh=GKB8Fg5BhBrJz591pcrSacYRAGNU/BYkRp+3a2UG5WQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H1TE63847oz3CsTmpDJOlYko+oAfFVkoaZDY9neblkoeOm0vLzzLj1R3TpKN0Pc1b
	 PW8Or0kyOX4eTvk2tU661dOLYHk9JMuwVKsQg8yVv2CpwR1/TgOh0/rTCy8VvLe09Y
	 EvGT3J/yU8jY3uY8poP+yV+XAcfm+UpRjaji8Va0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Thierry Reding <thierry.reding@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 004/124] pwm: sprd: Explicitly set .polarity in .get_state()
Date: Tue, 18 Apr 2023 14:20:23 +0200
Message-Id: <20230418120309.736067486@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120309.539243408@linuxfoundation.org>
References: <20230418120309.539243408@linuxfoundation.org>
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

[ Upstream commit 2be4dcf6627e1bcbbef8e6ba1811f5127d39202c ]

The driver only supports normal polarity. Complete the implementation of
.get_state() by setting .polarity accordingly.

Fixes: 8aae4b02e8a6 ("pwm: sprd: Add Spreadtrum PWM support")
Link: https://lore.kernel.org/r/20230228135508.1798428-5-u.kleine-koenig@pengutronix.de
Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Signed-off-by: Thierry Reding <thierry.reding@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pwm/pwm-sprd.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/pwm/pwm-sprd.c b/drivers/pwm/pwm-sprd.c
index 9eeb59cb81b68..b23456d38bd22 100644
--- a/drivers/pwm/pwm-sprd.c
+++ b/drivers/pwm/pwm-sprd.c
@@ -109,6 +109,7 @@ static void sprd_pwm_get_state(struct pwm_chip *chip, struct pwm_device *pwm,
 	duty = val & SPRD_PWM_DUTY_MSK;
 	tmp = (prescale + 1) * NSEC_PER_SEC * duty;
 	state->duty_cycle = DIV_ROUND_CLOSEST_ULL(tmp, chn->clk_rate);
+	state->polarity = PWM_POLARITY_NORMAL;
 
 	/* Disable PWM clocks if the PWM channel is not in enable state. */
 	if (!state->enabled)
-- 
2.39.2



