Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2ECE2F2C
	for <patches@lists.linux.dev>; Wed, 12 Apr 2023 08:39:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38313C4339B;
	Wed, 12 Apr 2023 08:39:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1681288797;
	bh=3tqKWDOYZheOCgxApj3yWUg5jfqIUXGGOah/Uc7tmtY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u2grCibmOn4Q33Y+ucfvGf2XZFYCazd/pK4JoYlhZuV5iYHn+4U5Jq4nDvU1WkdlY
	 FAknur4/aLO5Jp9f0Fb4l0OFZFdoWMwAjevMmrDeLc4wwi9Hsga20lDyfPCLFhPsrf
	 ldCw9svL8oJQScALkrkIPTcBKvwOmIXA+QIpDnkk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Thierry Reding <thierry.reding@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 013/164] pwm: hibvt: Explicitly set .polarity in .get_state()
Date: Wed, 12 Apr 2023 10:32:15 +0200
Message-Id: <20230412082837.410747995@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230412082836.695875037@linuxfoundation.org>
References: <20230412082836.695875037@linuxfoundation.org>
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

[ Upstream commit 6f57937980142715e927697a6ffd2050f38ed6f6 ]

The driver only both polarities. Complete the implementation of
.get_state() by setting .polarity according to the configured hardware
state.

Fixes: d09f00810850 ("pwm: Add PWM driver for HiSilicon BVT SOCs")
Link: https://lore.kernel.org/r/20230228135508.1798428-2-u.kleine-koenig@pengutronix.de
Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Signed-off-by: Thierry Reding <thierry.reding@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pwm/pwm-hibvt.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/pwm/pwm-hibvt.c b/drivers/pwm/pwm-hibvt.c
index 12c05c155cab0..1b9274c5ad872 100644
--- a/drivers/pwm/pwm-hibvt.c
+++ b/drivers/pwm/pwm-hibvt.c
@@ -146,6 +146,7 @@ static int hibvt_pwm_get_state(struct pwm_chip *chip, struct pwm_device *pwm,
 
 	value = readl(base + PWM_CTRL_ADDR(pwm->hwpwm));
 	state->enabled = (PWM_ENABLE_MASK & value);
+	state->polarity = (PWM_POLARITY_MASK & value) ? PWM_POLARITY_INVERSED : PWM_POLARITY_NORMAL;
 
 	return 0;
 }
-- 
2.39.2



