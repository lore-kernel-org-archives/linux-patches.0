Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 448DB2F24
	for <patches@lists.linux.dev>; Wed, 12 Apr 2023 08:46:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF521C433D2;
	Wed, 12 Apr 2023 08:46:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1681289208;
	bh=PQQcELue9uQ7+nNm45zCnaKAuBP0x5rACdg9SPuWXJ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HwQFDggL9vv3ZpsgYuXGmF928ZpRvbxa0EdiFmW52mAzi8VeyJ9SkCSeJqPZOdWV2
	 C5cSKhzWr9yq/re/r30/4OB+3lSvW8jMGRGE1U1HaDKBZQMqPK7xTrRxIna6a0fG08
	 nr7kAo1CXpUAmit76AiHBIzAOhbl2rTJ0u/fL7ms=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff LaBundy <jeff@labundy.com>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Thierry Reding <thierry.reding@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 012/173] pwm: iqs620a: Explicitly set .polarity in .get_state()
Date: Wed, 12 Apr 2023 10:32:18 +0200
Message-Id: <20230412082838.597652472@linuxfoundation.org>
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

[ Upstream commit b20b097128d9145fadcea1cbb45c4d186cb57466 ]

The driver only supports normal polarity. Complete the implementation of
.get_state() by setting .polarity accordingly.

Fixes: 6f0841a8197b ("pwm: Add support for Azoteq IQS620A PWM generator")
Reviewed-by: Jeff LaBundy <jeff@labundy.com>
Link: https://lore.kernel.org/r/20230228135508.1798428-4-u.kleine-koenig@pengutronix.de
Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Signed-off-by: Thierry Reding <thierry.reding@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pwm/pwm-iqs620a.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/pwm/pwm-iqs620a.c b/drivers/pwm/pwm-iqs620a.c
index 4987ca940b648..01208c2f58843 100644
--- a/drivers/pwm/pwm-iqs620a.c
+++ b/drivers/pwm/pwm-iqs620a.c
@@ -126,6 +126,7 @@ static int iqs620_pwm_get_state(struct pwm_chip *chip, struct pwm_device *pwm,
 	mutex_unlock(&iqs620_pwm->lock);
 
 	state->period = IQS620_PWM_PERIOD_NS;
+	state->polarity = PWM_POLARITY_NORMAL;
 
 	return 0;
 }
-- 
2.39.2



