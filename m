Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 030E163C;
	Thu, 15 Aug 2024 14:27:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723732078; cv=none; b=kkRrmNG6lhYWMMKCBzJj5wYGrCB6KsnlxfWeOZAXGogwe4wjemxqE+/lDZimoT7h8AuUZ07TgalbZVbG9e2dXN+Zmd0iJqCW6HR0Y7iR3S9KHErx67HI7fLCCmVjps3VseRoK4Wmb7aZ4V+KRLhfAEKfFa8hfZAArGY0nHoMPKs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723732078; c=relaxed/simple;
	bh=Lwmu+7y6oVzIGg1AiBq+ZaWPzsP8BpXBHRMsXGQIEwU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LCo0acQrL19bUucbTtDZznueGiQn9tybU4AwBYiOMvBKImaZWrpduhbaesoMdEBV/AkLdkkhpy4JB5wOF9BggQEXAxVTYbWibTSUd+KpQqAGI5EfqJRKaNPvy6WGJOzytgjjJNzdR5U0bEviI42K9j3ruopdMCuAg4AwaRNMWMg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N3bkY1KN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N3bkY1KN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 723B6C32786;
	Thu, 15 Aug 2024 14:27:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723732077;
	bh=Lwmu+7y6oVzIGg1AiBq+ZaWPzsP8BpXBHRMsXGQIEwU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N3bkY1KNNOmHdPxBO6IohKskRxs8RgALfcQdDMHZ9gSdljhLJwMu9BLqDhb+pkK+n
	 Liod58KSr5IMxbnyIlmhiWZvJ96iFzJJVqfAVo4KzbY2n4xmArsjgii2JEdzu4i43U
	 t2IoN6doMaRVSmqYm73e3ZH3rt60Ys5Gk+CEQuTc=
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
Subject: [PATCH 5.10 067/352] drm/panel: boe-tv101wum-nl6: Check for errors on the NOP in prepare()
Date: Thu, 15 Aug 2024 15:22:13 +0200
Message-ID: <20240815131921.833315993@linuxfoundation.org>
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
index c448be3d01d16..0a2d5f461aee8 100644
--- a/drivers/gpu/drm/panel/panel-boe-tv101wum-nl6.c
+++ b/drivers/gpu/drm/panel/panel-boe-tv101wum-nl6.c
@@ -553,7 +553,11 @@ static int boe_panel_prepare(struct drm_panel *panel)
 	usleep_range(5000, 10000);
 
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



