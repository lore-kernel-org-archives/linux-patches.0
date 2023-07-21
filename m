Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E23C20F88
	for <patches@lists.linux.dev>; Fri, 21 Jul 2023 19:05:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2F93C433C7;
	Fri, 21 Jul 2023 19:05:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689966344;
	bh=Ucb5BUBDnq3iN6NGj3A3kYKifBDtWdqXd9hdkBkQgfA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MKNh82j/1WOkNk+BXHiVc9c32BgXVPoJgBtKaJ8FnS2/gw7IB3gvX5cFUOWSL8T+h
	 XYz17xtCKAO0TsQ7VobiJAJA6jQi+YEG9x1D4ifziI/u+dRG/0q201oTqGNrrGBnvB
	 RM8uI5PHHfFoQSuMmoC0wLXiBRWomuyZt3wmW7Kw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Linus Walleij <linus.walleij@linaro.org>,
	Thierry Reding <thierry.reding@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 310/532] pwm: ab8500: Fix error code in probe()
Date: Fri, 21 Jul 2023 18:03:34 +0200
Message-ID: <20230721160631.219542146@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230721160614.695323302@linuxfoundation.org>
References: <20230721160614.695323302@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit cdcffafc4d845cc0c6392cba168c7a942734cce7 ]

This code accidentally return positive EINVAL instead of negative
-EINVAL.

Fixes: eb41f334589d ("pwm: ab8500: Fix register offset calculation to not depend on probe order")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Reviewed-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Thierry Reding <thierry.reding@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pwm/pwm-ab8500.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pwm/pwm-ab8500.c b/drivers/pwm/pwm-ab8500.c
index ad37bc46f2721..5fa91f4cda7ac 100644
--- a/drivers/pwm/pwm-ab8500.c
+++ b/drivers/pwm/pwm-ab8500.c
@@ -96,7 +96,7 @@ static int ab8500_pwm_probe(struct platform_device *pdev)
 	int err;
 
 	if (pdev->id < 1 || pdev->id > 31)
-		return dev_err_probe(&pdev->dev, EINVAL, "Invalid device id %d\n", pdev->id);
+		return dev_err_probe(&pdev->dev, -EINVAL, "Invalid device id %d\n", pdev->id);
 
 	/*
 	 * Nothing to be done in probe, this is required to get the
-- 
2.39.2



