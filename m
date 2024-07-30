Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBCCD1A6160;
	Tue, 30 Jul 2024 16:26:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722356805; cv=none; b=lw3EykhJ9u7a1rTh8tNESLZdQb8zPo3CSLmCriXLzhSCOQX8k6mk5jwzwlrGzNtDY/gjffqTliQYm4VzNbiRQbJ0Wck1DYWsvET84rS47QlE2xzvlj3M0BX8JWB7rXx8hfbdEUHSCC310vjkEXPL4zFrAYsHS72/S4OVXQNKRlc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722356805; c=relaxed/simple;
	bh=7BzC81eZabl4DPcK1JMV2Y0+WeL1ko5EAg0IjOrUKk8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HLNxghsyZYo8JNreMdjkx1hLGKCIuw2rrwbsacnGjNTR8h3itOHqFUNz1pNsixnO/DdTOI99KAvNxGe/dxy3LDNwdzXwzpwOWCAPRk6ZO0gQz/5DiUQO85r0n+Eiw9weILd2rwRqgJXHCvjO8SkxEReFYr4FHmB+jYSNXA6r/OQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BPc1A/g9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BPc1A/g9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47B22C32782;
	Tue, 30 Jul 2024 16:26:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722356805;
	bh=7BzC81eZabl4DPcK1JMV2Y0+WeL1ko5EAg0IjOrUKk8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BPc1A/g9845/oKxMTJ1Lv2f0lsSjUXh7u1pGmyerG5zUfh9e2aLoaGOYcIeBoJBkr
	 3FmiyGmBJsLPei4OO7aK8bXOn9fMtFq/omiT0pSHiF3KoOj+5ll2DPLjCM8DWtSPPc
	 CYGMI/KT7X2E8gcR+isn9rTWUqSYePZnVieh9BtI=
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
Subject: [PATCH 6.6 186/568] drm/panel: boe-tv101wum-nl6: Check for errors on the NOP in prepare()
Date: Tue, 30 Jul 2024 17:44:53 +0200
Message-ID: <20240730151647.148736001@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 688efb2253a16..cfa5b54ed6fe7 100644
--- a/drivers/gpu/drm/panel/panel-boe-tv101wum-nl6.c
+++ b/drivers/gpu/drm/panel/panel-boe-tv101wum-nl6.c
@@ -1847,7 +1847,11 @@ static int boe_panel_prepare(struct drm_panel *panel)
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



