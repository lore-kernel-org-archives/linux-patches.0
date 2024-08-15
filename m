Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC17244376;
	Thu, 15 Aug 2024 14:14:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723731294; cv=none; b=IgYCaDNPSh32YQm6scFFRHRAuoLAGxUKsFN23GZsepvEZtqmFYwiiFz7yjW8LrPmM/xuuTrdDAPyLRULo6FsH48asyvjunAK7rcrabR8Xq11qqA0Sz0C5WMkMV9Xe98cx2lNrLdVu7w8o56X6gj4Y1cZo65glfPhew92ueLrI2M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723731294; c=relaxed/simple;
	bh=r0rZSvwnjA+NEFgatorQn2JtgXlrI+8Fq5jo9lDq0DA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pvuEYTYALusz7St3BEr95b2y/id0vgOTKiKRroff/8w0nEPMeP/Ha+Sy7U8fUyaBZ56oHMy/Rvk0rP46q+KM62ZgKrLCiJcO0lYG7iISfvEeI+i++SRE4OqFm2Y21Au1vwQDvnM4MnCxUwhFX+DafbwTNKxxyK30j25oX1cIp8s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xVFU/vmX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xVFU/vmX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46E7DC32786;
	Thu, 15 Aug 2024 14:14:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723731293;
	bh=r0rZSvwnjA+NEFgatorQn2JtgXlrI+8Fq5jo9lDq0DA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xVFU/vmXuSoGOtQwvybTX0CSWJfVvFXTUku1jimrd9HMyc5q71+8cKujns3AnYeP3
	 eJRkdVDcTUpih5QsE8E1+fEKGGsDYukGkhGZLghMUEFHgT2RcBqp617I07xjheNEeS
	 NLB8yC4siIGzKn++SEr7DOZ2pp9CRKEe46Dn7M9A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 083/259] pinctrl: ti: ti-iodelay: Drop if block with always false condition
Date: Thu, 15 Aug 2024 15:23:36 +0200
Message-ID: <20240815131906.007859083@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131902.779125794@linuxfoundation.org>
References: <20240815131902.779125794@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index b522ca0103325..b597504ae6a46 100644
--- a/drivers/pinctrl/ti/pinctrl-ti-iodelay.c
+++ b/drivers/pinctrl/ti/pinctrl-ti-iodelay.c
@@ -906,9 +906,6 @@ static int ti_iodelay_remove(struct platform_device *pdev)
 {
 	struct ti_iodelay_device *iod = platform_get_drvdata(pdev);
 
-	if (!iod)
-		return 0;
-
 	if (iod->pctl)
 		pinctrl_unregister(iod->pctl);
 
-- 
2.43.0



