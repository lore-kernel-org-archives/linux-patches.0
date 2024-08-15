Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 936631714D9;
	Thu, 15 Aug 2024 13:47:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723729626; cv=none; b=GTG/YK5tVdyeR0PhnWMADfFONZ12V7JcT4MgeMigfhcxrlPFc4ih0YTdOC9/W5nBIz6a609OVTTI1Va9cdNbE619ZSIwoqiQg7HExCfxpwQhG3/gIAYjKDTo2ycAhdXL5tcLPoO/ILMIZJmzykppHyIwCvyhnP8jQUheofvHZuI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723729626; c=relaxed/simple;
	bh=zKc69SdGdt06k5Ma1gvSURb6CWEZh/CPD6RNTYREIrY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Jl4KIH61EZilP4dx59yeAWOd3Z14sTlE6tQfzbld7DN6TqPXsNcwDTlSNYAG/MbVXNdriXOdG5qfHlZQqbBs9m2YAdaktbxh8HJ/Y/LlV3tGCs8JqHKklFKh+jPDYN0QUwwaRnr1O2l4An+ipoadlgbOTy1bOR9rnzcjfsgBu7o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k0k7Nah+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k0k7Nah+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC068C32786;
	Thu, 15 Aug 2024 13:47:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723729626;
	bh=zKc69SdGdt06k5Ma1gvSURb6CWEZh/CPD6RNTYREIrY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k0k7Nah+6QuJx1+10lS3CeIZekzgLIMJVVUoejUOAXZ882IIjbUSA0LC8ykxW7a9S
	 lO6dBA0gWHK1qA5ndMkpqAnciUkg3oxxSpfiNNA62PvxewGo/VsqL82dhc25A1kxOh
	 uh9QzYEB3pfqKYVc3cV26hdGdH8btAo9qwH1F2nE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 157/484] pinctrl: ti: ti-iodelay: Drop if block with always false condition
Date: Thu, 15 Aug 2024 15:20:15 +0200
Message-ID: <20240815131947.478990299@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131941.255804951@linuxfoundation.org>
References: <20240815131941.255804951@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

[ Upstream commit 88b3f108502bc45e6ebd005702add46759f3f45a ]

ti_iodelay_remove() is only called after ti_iodelay_probe() completed
successfully. In this case platform_set_drvdata() was called with a
non-NULL argument and so platform_get_drvdata() won't return NULL.

Simplify by removing the if block with the always false condition.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Link: https://lore.kernel.org/r/20231009083856.222030-4-u.kleine-koenig@pengutronix.de
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Stable-dep-of: 9b401f4a7170 ("pinctrl: ti: ti-iodelay: fix possible memory leak when pinctrl_enable() fails")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/ti/pinctrl-ti-iodelay.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/pinctrl/ti/pinctrl-ti-iodelay.c b/drivers/pinctrl/ti/pinctrl-ti-iodelay.c
index 4e2382778d38f..75a2243ee87cc 100644
--- a/drivers/pinctrl/ti/pinctrl-ti-iodelay.c
+++ b/drivers/pinctrl/ti/pinctrl-ti-iodelay.c
@@ -908,9 +908,6 @@ static int ti_iodelay_remove(struct platform_device *pdev)
 {
 	struct ti_iodelay_device *iod = platform_get_drvdata(pdev);
 
-	if (!iod)
-		return 0;
-
 	if (iod->pctl)
 		pinctrl_unregister(iod->pctl);
 
-- 
2.43.0



