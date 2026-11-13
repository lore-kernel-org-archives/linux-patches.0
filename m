Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591159;
	b=s5dHlC3UO5MMAxbWEbltPea70PXDGIvy0QXkbZ8bJXZNQbzukl6JuM8j+WSb+B/I9M2S
	 brK/rg+L6QLHfKjK3a3g0UeERdVXPnLKm6xRY/U1FAzbH1ojnxYuEgJXcAa4CjG7lLuyB
	 c6Buza9bfTWvYqKdvm+8baxu4aXqsF975oelBKaMFG4LBGi/78lvAOOg3Bkz7HcWSR3z/
	 KxUari66CdH8BnV1pbAcCkLXjVzc/2ezWORj0oWXKvroswWKqYzvojT0yIPgOLUAKo7ME
	 3CiaogL/w4zFe6aJsbSO74IBM83m2NqS63gITWZSEAMg6GhrEfszt2LZEv3cssQAM7Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591159;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=AexwS1lU08fXRBR7wxwfSZH+cas6VGoQVYPmdZKCgmQ=;
	b=xjGF7gG09iU02YFx6I1Cssy4k3E08O5E/UEug9X8Hpi6vYgxKO+I3a0QVFl+obb/Smxq
	 3i9wFWJQ7V/Wh+7rkKQ9GgdUutC5rvmStC3/3zX1gdzGOZrG0FLsjCkqkFQBYGrN9LJm1
	 G+xOdbrHCb7H21NH07naExjisQGZY7RsTh562qbKvzV8+ccBfmo5GTJjKVXYwn3nZbw6f
	 51jlLu3nBR/JyHayGg1cZEqL8tFhTCunxC2oNyS/k9XXgHPkS2jI1GwY2WdubuUOlpKKB
	 gFX6V+fpEzTJwyCEBYMwZtRlHxtDRj2KsH4S7Z+HSxydON+viEOAfPcMq/l3/Lo1WPg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QMMiIyF6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6152606BD2A;
	Fri, 13 Nov 2026 17:32:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QMMiIyF6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70BC01F000C9;
	Fri, 13 Nov 2026 17:32:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591159;
	bh=AexwS1lU08fXRBR7wxwfSZH+cas6VGoQVYPmdZKCgmQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QMMiIyF6F9AhcIUMFjhO7jWm6eHCFUgpREVC2+vGr09KqLYk7f+QZXBZbhp7HaA5m
	 x1Jae+12Kfh7OqkkNcrhQ0yCYAdsA3MPK021bshRz+PTIM2zgSX9WWTFcl3see2TUZ
	 JmxF3MahsVJSNxF/1wOzTKPSXr7x+eyCQ8gHt7DI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luca Ceresoli <luca.ceresoli@bootlin.com>,
	Esben Haabendal <esben@geanix.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 303/670] drm/bridge: nwl-dsi: Limit LCDIF specific sync override
Date: Fri, 13 Nov 2026 10:47:47 -0500
Message-ID: <20261113153822.189396450@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Esben Haabendal <esben@geanix.com>

[ Upstream commit 54a88d9afcca66221d14f438d0960472984968ec ]

When using DCSS with NWL, overriding the mode flags to enforce active high
sync is preventing the use of active low with downstream bridges, such as
ti-sn65dsi83, which will not see such mode flags set by the panel.

Fixes: 44cfc6233447 ("drm/bridge: Add NWL MIPI DSI host controller support")
Cc: stable@vger.kernel.org
Reviewed-by: Luca Ceresoli <luca.ceresoli@bootlin.com>
Signed-off-by: Esben Haabendal <esben@geanix.com>
Link: https://patch.msgid.link/20261027-nwl-dsi-fixes-v5-2-b6d1d3d2d356@geanix.com
Signed-off-by: Luca Ceresoli <luca.ceresoli@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/nwl-dsi.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/bridge/nwl-dsi.c b/drivers/gpu/drm/bridge/nwl-dsi.c
index ffe738e93deb7..00622febf01c6 100644
--- a/drivers/gpu/drm/bridge/nwl-dsi.c
+++ b/drivers/gpu/drm/bridge/nwl-dsi.c
@@ -824,10 +824,13 @@ static int nwl_dsi_bridge_atomic_check(struct drm_bridge *bridge,
 				       struct drm_connector_state *conn_state)
 {
 	struct drm_display_mode *adjusted_mode = &crtc_state->adjusted_mode;
+	struct nwl_dsi *dsi = bridge_to_dsi(bridge);
 
 	/* At least LCDIF + NWL needs active high sync */
-	adjusted_mode->flags |= (DRM_MODE_FLAG_PHSYNC | DRM_MODE_FLAG_PVSYNC);
-	adjusted_mode->flags &= ~(DRM_MODE_FLAG_NHSYNC | DRM_MODE_FLAG_NVSYNC);
+	if (dsi->endpoint == NWL_DSI_ENDPOINT_LCDIF) {
+		adjusted_mode->flags |= (DRM_MODE_FLAG_PHSYNC | DRM_MODE_FLAG_PVSYNC);
+		adjusted_mode->flags &= ~(DRM_MODE_FLAG_NHSYNC | DRM_MODE_FLAG_NVSYNC);
+	}
 
 	/*
 	 * Do a full modeset if crtc_state->active is changed to be true.
-- 
2.53.0



