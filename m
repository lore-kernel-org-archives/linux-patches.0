Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AAA81772F
	for <patches@lists.linux.dev>; Mon, 15 May 2023 18:01:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB672C433D2;
	Mon, 15 May 2023 18:01:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684173714;
	bh=Tsm850rU7/rC7EYIcmSHAI2raHqCOV1CYD7LlqRaxOs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XNnEexubjGdeG14jjk4j2gO/cqO5A9Z0t6G9iHfjLZr1pr7mcLF35xlwN3kkoT0YR
	 2tDU9rzT9gYUb3so5/dJ8fldtdOqr5cUZXG9jOlcIUHrUKfkVvxy3ey+dmIYefUaTM
	 cpDr1cjax3luUTRP76iougPkRcc+ZkAS1r4DCeok=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Thierry Reding <thierry.reding@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 184/282] pwm: mtk-disp: Dont check the return code of pwmchip_remove()
Date: Mon, 15 May 2023 18:29:22 +0200
Message-Id: <20230515161727.789210341@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161722.146344674@linuxfoundation.org>
References: <20230515161722.146344674@linuxfoundation.org>
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

[ Upstream commit 9b7b5736ffd5da6f8f6329ebe5f1829cbcf8afae ]

pwmchip_remove() returns always 0. Don't use the value to make it
possible to eventually change the function to return void. Also the
driver core ignores the return value of mtk_disp_pwm_remove().

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Signed-off-by: Thierry Reding <thierry.reding@gmail.com>
Stable-dep-of: 36dd7f530ae7 ("pwm: mtk-disp: Disable shadow registers before setting backlight values")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pwm/pwm-mtk-disp.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/pwm/pwm-mtk-disp.c b/drivers/pwm/pwm-mtk-disp.c
index 83b8be0209b74..af63aaab8e153 100644
--- a/drivers/pwm/pwm-mtk-disp.c
+++ b/drivers/pwm/pwm-mtk-disp.c
@@ -240,13 +240,12 @@ static int mtk_disp_pwm_probe(struct platform_device *pdev)
 static int mtk_disp_pwm_remove(struct platform_device *pdev)
 {
 	struct mtk_disp_pwm *mdp = platform_get_drvdata(pdev);
-	int ret;
 
-	ret = pwmchip_remove(&mdp->chip);
+	pwmchip_remove(&mdp->chip);
 	clk_unprepare(mdp->clk_mm);
 	clk_unprepare(mdp->clk_main);
 
-	return ret;
+	return 0;
 }
 
 static const struct mtk_pwm_data mt2701_pwm_data = {
-- 
2.39.2



