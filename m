Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 442773214;
	Thu, 15 Aug 2024 14:27:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723732075; cv=none; b=b7/ZfPjKywW5KEkQT95GDHhIc2sb/i7KmSZuERSoxRYy2UO4e5CBtCqLl8Alr5unkGlcLVDdfRnSdrmQVP3WfMAPTwy+QTqVl+ZOHZ4d8pI6xOKXcd4eKaKuicUNLijoAZB3WOVNPBNciS2+6M35MyF8TYLgWbxT95AV1NHSg48=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723732075; c=relaxed/simple;
	bh=6v9adXiWeHWnmeKE8AdZGJxAlKKnnKMNXDdGlwIVOO0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XTEP3Czss8HrCqiuu0W1G5BRX6U2QEIZNE59WzRnxDDaWJekzXs+P6g+RSNRAXHCgjrOy4ZDOQ16IYxKvvdTGNdw1bmqB7T60oDraCrlHY6ETf4bP4pwAsr3hAQZCunSF6fgk/jsJAD9hAjpUKEgT1D6mwFBfSkuy/7+yu2ei9Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BC/k7buW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BC/k7buW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BAFBC4AF0D;
	Thu, 15 Aug 2024 14:27:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723732074;
	bh=6v9adXiWeHWnmeKE8AdZGJxAlKKnnKMNXDdGlwIVOO0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BC/k7buWIYuOex+75XLPkCCGfAecjB9QSErlt2jzw0KL440QPoQFR4UuS/WgvdL9p
	 SMeI7L5rxtg3dQs3II5LoSNsNhcWgYuJRd5yi6pkakN1nC8TaDTH7p0vYBxKuwV2Ip
	 IBNaeUZVe9TzxSj+hINDE90xxwEREL5IqH0clekY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Douglas Anderson <dianders@chromium.org>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Linus Walleij <linus.walleij@linaro.org>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 066/352] drm/panel: boe-tv101wum-nl6: If prepare fails, disable GPIO before regulators
Date: Thu, 15 Aug 2024 15:22:12 +0200
Message-ID: <20240815131921.794613256@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131919.196120297@linuxfoundation.org>
References: <20240815131919.196120297@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 9e518213a54ff..c448be3d01d16 100644
--- a/drivers/gpu/drm/panel/panel-boe-tv101wum-nl6.c
+++ b/drivers/gpu/drm/panel/panel-boe-tv101wum-nl6.c
@@ -574,13 +574,13 @@ static int boe_panel_prepare(struct drm_panel *panel)
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



