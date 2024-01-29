Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D795576C68;
	Mon, 29 Jan 2024 17:17:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548647; cv=none; b=i99NVq0n0KSKyjQwQHVAb0svwE4NY6CVPWRrJVuOLKHXaN1PTT6RV6XxyhRHuAhOMM8hX5jaEXr+3n8Pih8g8Jd71SZLvfWF0GuP+gSEGlLiyqbmz/r4tv8ri/v2a6v3yvkeuvONi4II9dzqOlu873mAjV+v/vFS4IfWq0jTvXk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548647; c=relaxed/simple;
	bh=6rhfOhyKgu2rE7fiAmlSEUSr3Qjd58i0Dv+lUM0nnOs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TXsLWUzZ2mCQGjYTA73YR5dj3hVTNyiZlftBmexboe5ED9dQxYfH9eBgIAryWhxnHWz/+x0e0P4FWHsaWt0IpAolT8m2SakLzh4JuqXkgiQeL59z4STWw+Ytcas6Uem2ef68X5WKBfS131hqCZPEPAvonl261bHz7ed8ADAkxPI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jk8qbBxg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jk8qbBxg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F201C433B2;
	Mon, 29 Jan 2024 17:17:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548647;
	bh=6rhfOhyKgu2rE7fiAmlSEUSr3Qjd58i0Dv+lUM0nnOs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jk8qbBxg3ZztBePQzL8ldU6clRhmz2jrIAW1W5ZM/0NTIvV2jgTtmvpJ/U3BBeMbb
	 Dr1Vqz/XpFIGZb2JZE4h8NQhknO0wwQeDKNsGxg+QyBajwZeFMabOXFNiky7flElLA
	 Yn2fZ0GDhv5tiZEdwhDn+CXC/ibO0qiy1unIhg/0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jessica Zhang <quic_jesszhan@quicinc.com>,
	Artur Weber <aweber.kernel@gmail.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 302/331] drm/panel: samsung-s6d7aa0: drop DRM_BUS_FLAG_DE_HIGH for lsl080al02
Date: Mon, 29 Jan 2024 09:06:06 -0800
Message-ID: <20240129170023.708002175@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170014.969142961@linuxfoundation.org>
References: <20240129170014.969142961@linuxfoundation.org>
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

From: Artur Weber <aweber.kernel@gmail.com>

[ Upstream commit 62b143b5ec4a14e1ae0dede5aabaf1832e3b0073 ]

It turns out that I had misconfigured the device I was using the panel
with; the bus data polarity is not high for this panel, I had to change
the config on the display controller's side.

Fix the panel config to properly reflect its accurate settings.

Fixes: 6810bb390282 ("drm/panel: Add Samsung S6D7AA0 panel controller driver")
Reviewed-by: Jessica Zhang <quic_jesszhan@quicinc.com>
Signed-off-by: Artur Weber <aweber.kernel@gmail.com>
Link: https://lore.kernel.org/r/20240105-tab3-display-fixes-v2-2-904d1207bf6f@gmail.com
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20240105-tab3-display-fixes-v2-2-904d1207bf6f@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panel/panel-samsung-s6d7aa0.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/panel/panel-samsung-s6d7aa0.c b/drivers/gpu/drm/panel/panel-samsung-s6d7aa0.c
index ea5a85779382..f23d8832a1ad 100644
--- a/drivers/gpu/drm/panel/panel-samsung-s6d7aa0.c
+++ b/drivers/gpu/drm/panel/panel-samsung-s6d7aa0.c
@@ -309,7 +309,7 @@ static const struct s6d7aa0_panel_desc s6d7aa0_lsl080al02_desc = {
 	.off_func = s6d7aa0_lsl080al02_off,
 	.drm_mode = &s6d7aa0_lsl080al02_mode,
 	.mode_flags = MIPI_DSI_MODE_VSYNC_FLUSH | MIPI_DSI_MODE_VIDEO_NO_HFP,
-	.bus_flags = DRM_BUS_FLAG_DE_HIGH,
+	.bus_flags = 0,
 
 	.has_backlight = false,
 	.use_passwd3 = false,
-- 
2.43.0



