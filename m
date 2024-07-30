Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BE12189902;
	Tue, 30 Jul 2024 16:10:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722355829; cv=none; b=AchPka8HjN9H+Q1D0/puBSzS61qgQUMEg/aaeMrymJr/grz0U4s3cbWct5BVQljpphxLvGFvyRzesgKAVNS/pluXFUBdY/JkvL/ygmO/+5q19Zi3PSmAEjpFEby+xE5CMLv5Jb0EFAue2jg5aRCci9aAS+1jSk+mZRCs3TjnHvE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722355829; c=relaxed/simple;
	bh=itqwuvuZZeYG6jEYho+F45xCOmyPapLBLGQZAS5m1Gs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IbRKOQiSqBuam7+xKg3ApuCsZc91bkNVBntbyghMjiWdezP/f49xfdrra1BJTg1jC90yMIG0cc39wtUgfARuY6gIy8nzhwgB/EVbIfCRxH2n6W8eAA5AR+EkFQhmLdMLn+PuGTYJM33MkkYE40dDUQaSLTL7VNbO/3gZF1bh2jE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rus7w9cD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rus7w9cD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BD6AC32782;
	Tue, 30 Jul 2024 16:10:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722355829;
	bh=itqwuvuZZeYG6jEYho+F45xCOmyPapLBLGQZAS5m1Gs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rus7w9cD2qFi1qp44THQdo1CinNbyeKHf5MKM5TERmM7hK1rT6g/8MjwuNUvmf52Z
	 0iFa8c516N8zY+pT+Q1aE8Vh1IkXmD5EdJLwCNSoYgE55lLLUAtbeopVsJmxmtT4zo
	 TpM6CaZ22vWUEyEVxPs3QJB+G/fukAaJw7JBwDbw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Douglas Anderson <dianders@chromium.org>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Linus Walleij <linus.walleij@linaro.org>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 134/440] drm/panel: boe-tv101wum-nl6: If prepare fails, disable GPIO before regulators
Date: Tue, 30 Jul 2024 17:46:07 +0200
Message-ID: <20240730151621.117125079@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Douglas Anderson <dianders@chromium.org>

[ Upstream commit 587c48f622374e5d47b1d515c6006a4df4dee882 ]

The enable GPIO should clearly be set low before turning off
regulators. That matches both the inverse order that things were
enabled and also the order in unprepare().

Fixes: a869b9db7adf ("drm/panel: support for boe tv101wum-nl6 wuxga dsi video mode panel")
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Link: https://lore.kernel.org/r/20240517143643.2.Ieac346cd0f1606948ba39ceea06b55359fe972b6@changeid
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20240517143643.2.Ieac346cd0f1606948ba39ceea06b55359fe972b6@changeid
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panel/panel-boe-tv101wum-nl6.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/panel/panel-boe-tv101wum-nl6.c b/drivers/gpu/drm/panel/panel-boe-tv101wum-nl6.c
index 1c008bd9102ff..b26c4a09d0912 100644
--- a/drivers/gpu/drm/panel/panel-boe-tv101wum-nl6.c
+++ b/drivers/gpu/drm/panel/panel-boe-tv101wum-nl6.c
@@ -1292,13 +1292,13 @@ static int boe_panel_prepare(struct drm_panel *panel)
 	return 0;
 
 poweroff:
+	gpiod_set_value(boe->enable_gpio, 0);
 	regulator_disable(boe->avee);
 poweroffavdd:
 	regulator_disable(boe->avdd);
 poweroff1v8:
 	usleep_range(5000, 7000);
 	regulator_disable(boe->pp1800);
-	gpiod_set_value(boe->enable_gpio, 0);
 
 	return ret;
 }
-- 
2.43.0



