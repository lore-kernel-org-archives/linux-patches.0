Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4A0D18454F;
	Tue, 30 Jul 2024 16:29:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722356980; cv=none; b=IHkS2gBCnu8uGqVzLhNVid0NcdfOHj67Y8XjuqmqsYLHas3Fo0B9F15pVVu9KfbRh3v7yEp0b6QUTRQETW97wLen7oNvatYnB7ghc5vhH+g3m2zacJEv999ZSKEZP1nHETBT4e+WOijXZILDem5lhvskByvAo1impsxmV/KAuA8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722356980; c=relaxed/simple;
	bh=fLKmS5OdUYDRGkxHRX9Cv2YuzcQhOw85f43PB7GJHZo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=C1u+voVI7MI9JqVcov2uMaMp5R6FxmQvdGmxZgxVdwYNyja5P7I3/MJy2f0RnMe24WQrNyDG7xWOiDbHh43FWWZjlqWEZgAVlc4oNcs282bYVtbvZIheCQjbwkwdwpNZo0N7exy+z/virsKnP4iQw04IUFNamoPbeB9uPH/HQuU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HALg+WcI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HALg+WcI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BF15C4AF10;
	Tue, 30 Jul 2024 16:29:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722356980;
	bh=fLKmS5OdUYDRGkxHRX9Cv2YuzcQhOw85f43PB7GJHZo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HALg+WcIT37VZ6igHYzxWPY4IUNm5rj3wtgdHxo0ajdkPAaCKtn/JcnjLs6/u++q4
	 /PCIHWAHrC4udTBL71OPOwAjKppR7Zak+tQMsAN2mQwboHb+cRmjg1cH00NkuDGHGg
	 rUrMNEABFXMyl8KHy+8Fy2FGRv09CkInPT5c1gqM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 247/440] pinctrl: ti: ti-iodelay: Drop if block with always false condition
Date: Tue, 30 Jul 2024 17:48:00 +0200
Message-ID: <20240730151625.497998871@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151615.753688326@linuxfoundation.org>
References: <20240730151615.753688326@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



