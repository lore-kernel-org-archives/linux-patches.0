Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D905BA32
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 17:25:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1B59C433D2;
	Tue,  7 Mar 2023 17:25:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678209908;
	bh=KwFGdCYbYuVH9Aynu4h8kWq0fsdAd4+m7iBkQDGVmLo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YgQ7gyMkp85fUd4HP+qCzeeA8yk7uglgzJo7tC9zsmoR/+SUIrbFcjJtNQmscgf2A
	 NgfRo4YxFBlfBQn0rkiQi0C0H13ZCs/AqMPmwFtjdK1MW9ppz1ZwosC1TZKvFJu1aj
	 zKozAzyQsY8TJPVTfzsZduUOEzEDIaOt55B9RO6g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0371/1001] drm/bridge: lt9611: pass a pointer to the of node
Date: Tue,  7 Mar 2023 17:52:23 +0100
Message-Id: <20230307170037.470694440@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

[ Upstream commit b0a7f8736789935f62d6df32d441cdf05a5c05d2 ]

Pass a pointer to the OF node while registering lt9611 MIPI device.

Fixes: 23278bf54afe ("drm/bridge: Introduce LT9611 DSI to HDMI bridge")
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20230118081658.2198520-7-dmitry.baryshkov@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/lontium-lt9611.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/bridge/lontium-lt9611.c b/drivers/gpu/drm/bridge/lontium-lt9611.c
index e2799a0df8f8b..3b77238ca4aff 100644
--- a/drivers/gpu/drm/bridge/lontium-lt9611.c
+++ b/drivers/gpu/drm/bridge/lontium-lt9611.c
@@ -769,7 +769,7 @@ static const struct drm_connector_funcs lt9611_bridge_connector_funcs = {
 static struct mipi_dsi_device *lt9611_attach_dsi(struct lt9611 *lt9611,
 						 struct device_node *dsi_node)
 {
-	const struct mipi_dsi_device_info info = { "lt9611", 0, NULL };
+	const struct mipi_dsi_device_info info = { "lt9611", 0, lt9611->dev->of_node};
 	struct mipi_dsi_device *dsi;
 	struct mipi_dsi_host *host;
 	struct device *dev = lt9611->dev;
-- 
2.39.2



