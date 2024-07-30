Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49FF91A6192;
	Tue, 30 Jul 2024 16:41:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722357709; cv=none; b=oKpdJNubryd0oKOc3ASDu6Q8SgKrAQOShUanNwaYzLn04bsgqza6/Upnfze5luuEt9IlUDmljPHX+fcykLB04V0rk8mVtMrt1uP7CZmD+iGjN5i/knKEy+3zwqK15IqPUtxwqs5kPjqWtmmYT3wZOoLrS9CWCXfYyxPOfDvxEdM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722357709; c=relaxed/simple;
	bh=5Gckq29uDa9Wx7PnryvNvf2sff0YSuU3IsFLVV31A8Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c1EeCKqvFZzbE/h462gw5Mf+VwGi9g0aNUqGlx9kKioXdZOI+M+Z9jZ5XfpgeJLfBXQuhCr7ZXc578um2PgOtzVWiCAQmfHnfICsDiVz9gvEqlXdaUOcLKid4WU/tQqETafT33mA8Uw+yQmj3onfLRaOHs2Yev7aIglG2vTc4VE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rMPZsUg2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rMPZsUg2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C10D2C32782;
	Tue, 30 Jul 2024 16:41:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722357709;
	bh=5Gckq29uDa9Wx7PnryvNvf2sff0YSuU3IsFLVV31A8Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rMPZsUg2SXHUWauvXFoa6b5HdpbMz+99cAWBHYBeJ7qZ6mTODiO2oeXeGJOKQhVD1
	 RmYjECM1g9vptkheLbtFeCZJmTuV8rrJ0lFAA6s5YFVa62hW5oabxuVUyYmAgHiczy
	 kxRWoPXQY0FebChVoDvFIY70hyBo5nuXyEva4WD8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Douglas Anderson <dianders@chromium.org>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Linus Walleij <linus.walleij@linaro.org>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 281/809] drm/panel: ilitek-ili9882t: Check for errors on the NOP in prepare()
Date: Tue, 30 Jul 2024 17:42:37 +0200
Message-ID: <20240730151735.689867712@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Douglas Anderson <dianders@chromium.org>

[ Upstream commit 6a7bd6cde73f0fb7e5faa964dbdeb45b55c64698 ]

The mipi_dsi_dcs_nop() function returns an error but we weren't
checking it in ili9882t_prepare(). Add a check. This is highly
unlikely to matter in practice. If the NOP failed then likely later
MIPI commands would fail too.

Found by code inspection.

Fixes: e2450d32e5fb ("drm/panel: ili9882t: Break out as separate driver")
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Link: https://lore.kernel.org/r/20240517143643.5.I323476ba9fa8cc7a5adee4c1ec95202785cc5686@changeid
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20240517143643.5.I323476ba9fa8cc7a5adee4c1ec95202785cc5686@changeid
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panel/panel-ilitek-ili9882t.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/panel/panel-ilitek-ili9882t.c b/drivers/gpu/drm/panel/panel-ilitek-ili9882t.c
index 5762eba73955c..35ea5494e0eb8 100644
--- a/drivers/gpu/drm/panel/panel-ilitek-ili9882t.c
+++ b/drivers/gpu/drm/panel/panel-ilitek-ili9882t.c
@@ -560,7 +560,11 @@ static int ili9882t_prepare(struct drm_panel *panel)
 	usleep_range(10000, 11000);
 
 	// MIPI needs to keep the LP11 state before the lcm_reset pin is pulled high
-	mipi_dsi_dcs_nop(ili->dsi);
+	ret = mipi_dsi_dcs_nop(ili->dsi);
+	if (ret < 0) {
+		dev_err(&ili->dsi->dev, "Failed to send NOP: %d\n", ret);
+		goto poweroff;
+	}
 	usleep_range(1000, 2000);
 
 	gpiod_set_value(ili->enable_gpio, 1);
-- 
2.43.0



