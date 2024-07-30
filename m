Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5302018951A;
	Tue, 30 Jul 2024 16:10:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722355843; cv=none; b=Zl9myhkD8sxLp1UInkS2sihQSk1F7PFxMN2jctllQpAk7zJ/26MgZREmCMbmgJusLJTpHusoAK9Ji4MoEGefIEt32+xuwunYKoUS2afWr8IwJGd9GxcQaZo/Pv+HWEC/ZjbacRUMVFLw5fNPih9NBmk8PuyRljyHZLXfDerzq+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722355843; c=relaxed/simple;
	bh=bXIZQ2mEyTQ3vpskPrQ6D2BwDM6eElZdJs0eJ1dhYxw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iCjUrUrFMkdZPkuvdWqZA1Vv/ZHu32p4XBy6uMFr6qeVhCSpBssbB1mp3jos/97wrWcoLL2PrJW0qDxEOmcX/LRRJK+zkNdxGfXV3a5rwBsNAVecA6a4g1YTZXFxZ2ZvEHvI2uYCUIDO+Atx/YCRpptB2Qd8JdPMs7lAjnd/dEI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U8ZJkdel; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U8ZJkdel"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB343C32782;
	Tue, 30 Jul 2024 16:10:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722355843;
	bh=bXIZQ2mEyTQ3vpskPrQ6D2BwDM6eElZdJs0eJ1dhYxw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U8ZJkdelaPF5wWF1GAiIvO7d8oSGM0T6kAV8I/rAuZJwwZ0kWRU/Spvgq+2WxdWqV
	 ePltFaBIuK2o59T/TD4CHPpC1+LCKvAi+QMcsWcoBuNB9DeCGSjM5cpjdRefyaaHdW
	 fKSAXJ/FUtdBr/SyhRXGzU7YvPUyu9lQoTcVHs0g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Douglas Anderson <dianders@chromium.org>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Linus Walleij <linus.walleij@linaro.org>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 135/440] drm/panel: boe-tv101wum-nl6: Check for errors on the NOP in prepare()
Date: Tue, 30 Jul 2024 17:46:08 +0200
Message-ID: <20240730151621.156974379@linuxfoundation.org>
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

[ Upstream commit 6320b9199dd99622668649c234d4e8a99e44a9c8 ]

The mipi_dsi_dcs_nop() function returns an error but we weren't
checking it in boe_panel_prepare(). Add a check. This is highly
unlikely to matter in practice. If the NOP failed then likely later
MIPI commands would fail too.

Found by code inspection.

Fixes: 812562b8d881 ("drm/panel: boe-tv101wum-nl6: Fine tune the panel power sequence")
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Link: https://lore.kernel.org/r/20240517143643.3.Ibffbaa5b4999ac0e55f43bf353144433b099d727@changeid
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20240517143643.3.Ibffbaa5b4999ac0e55f43bf353144433b099d727@changeid
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panel/panel-boe-tv101wum-nl6.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/panel/panel-boe-tv101wum-nl6.c b/drivers/gpu/drm/panel/panel-boe-tv101wum-nl6.c
index b26c4a09d0912..820d8d29b62bd 100644
--- a/drivers/gpu/drm/panel/panel-boe-tv101wum-nl6.c
+++ b/drivers/gpu/drm/panel/panel-boe-tv101wum-nl6.c
@@ -1271,7 +1271,11 @@ static int boe_panel_prepare(struct drm_panel *panel)
 	usleep_range(10000, 11000);
 
 	if (boe->desc->lp11_before_reset) {
-		mipi_dsi_dcs_nop(boe->dsi);
+		ret = mipi_dsi_dcs_nop(boe->dsi);
+		if (ret < 0) {
+			dev_err(&boe->dsi->dev, "Failed to send NOP: %d\n", ret);
+			goto poweroff;
+		}
 		usleep_range(1000, 2000);
 	}
 	gpiod_set_value(boe->enable_gpio, 1);
-- 
2.43.0



