Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D3ED7DA78;
	Thu, 15 Aug 2024 13:30:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723728619; cv=none; b=gucFVKZVzdJjLFiKLYJFQnh311uLvVv9GXyPoovf86GZ3I3TUfK9/kKZ2cxAHtzPqMDMUmPIMEw49mdqR4W2e8UUsR0qbvR+G5ZJDpIq2s2M8zo8VAA5o1kNFKuZUsmHvMqDb8EJNDEk/81Sq2d5lC4bVWx2lc3rU0ruzphk14Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723728619; c=relaxed/simple;
	bh=zG2KN2/QwTwUiEf2KkLfDOtckmItxhH4k7s1f3tWTFs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=F6rWsKBbO9Q7srSyZVdqHH1jIaC6KtWjmaCowSuqojJP/hQAKaG1gZdmjbn2+wjfd8vRRj7jSlUDAcMHgwsOXKSGkUuOTqFhb2ZFgqk8ig4mEkc2qKpoU1IfO/Mz/jGQMNq2CbLIXQRoc8MfKfSTW2kRVo8Ie9oWK3a9uAF0FWw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lvRz7X86; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lvRz7X86"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13D76C32786;
	Thu, 15 Aug 2024 13:30:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723728618;
	bh=zG2KN2/QwTwUiEf2KkLfDOtckmItxhH4k7s1f3tWTFs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lvRz7X86DTz/TxkGDYEPoX9h5cwY57VGoI03MPU9IFN6yBX+7hSxeyc/FIVLky9lU
	 ZydKUuyE1wtGLd3CxYH+XKyaZKaZWJZU4UXzyDClBZWYCre0HTo1/L77mSc4GaiCq/
	 Q4WRwUvID/CuXF1ZpBu+oXvxaUzw4iskAR7jnhyY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 057/196] pinctrl: ti: ti-iodelay: Drop if block with always false condition
Date: Thu, 15 Aug 2024 15:22:54 +0200
Message-ID: <20240815131854.259926528@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131852.063866671@linuxfoundation.org>
References: <20240815131852.063866671@linuxfoundation.org>
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
index 4eda888b4d048..1c4196f40e8d6 100644
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



