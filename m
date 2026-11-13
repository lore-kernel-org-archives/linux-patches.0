Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590371;
	b=VYEFafK97gptJyhaKaRa4tpHF+b2Vq98vFnoof5dnVnWJsveM8bn9qo1C2h24GEJvDqN
	 mESZ43iU04MGrLq9dLldxP5ze3N+cbBTfhhSXlLaRVTOjHOOoqUOmfthsQZlbp/2IMNeM
	 LUzsNi1dFtyuOyHwRlOa9j0vZKz840HN9gDHmO1bEc+FJtfI4gbpzkhgzYB4fsm240LQ2
	 3Oq4q40Yzc9EP310FzWPA9vUsoWiCVj8zpBpcVOO9CgIGKQnLUlTL+7VF3xA4/IVqlCeP
	 oglsjw6HGbfLLiBbr3CjweEM6SuAXe+W4sQHlINrFTz1kQPx+uhT7gWoKp1meNbHXzg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590371;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Jdv/+6Ee4m+5rFnGUG+l2ishKamekGWvQuAClXD5PPA=;
	b=mRtVBZvPVkSpHfAjPt52NAInTHo3adqvQooLZwZjhjRikOydXNLPNz+lu/1yiuWRA/wt
	 LCfUjGtua5pv6uu61CGe9l/RK/xz+MGOuWqAX1Jd1zWxetgV05Cg0iFYwiVBR8aCGLyeW
	 3Vvl4P9qN3WIpi216a6tq397pm1bH1hbhGgPidoPh+Op522hNKapAFcI4G+UprJf9BwxR
	 Gh2qB8RRgOTu1hl7BKR8ofolWvRgDSX+WroEVtxOQ+0jaHe8cgpdY/s/tzE63dEJz+o7w
	 jsLNgGCwTs9jnIZso0gILeoZNM1iIHRU6+6U0EL8n7lrUDE7lC8FidlT2qPR8DaDz8Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=S2vqhxyS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12ECF606B340;
	Fri, 13 Nov 2026 17:19:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=S2vqhxyS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A34BE1F000C7;
	Fri, 13 Nov 2026 17:19:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590370;
	bh=Jdv/+6Ee4m+5rFnGUG+l2ishKamekGWvQuAClXD5PPA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=S2vqhxySY2Hz3KGZjy0M0svgPNTz64Qy2eOLlYmeLi01nZLZNGbHQXof5EZIL3Pq9
	 dS3UQyXJ5YeK2m/ZzOKgdo/wvJC4K4Qqu4qsDKUkAMn4OxrBcXy448lsMvo8XlALeM
	 tAZTXNc5mhhS/5Nwnnj13DLd9Aen3VTOiJTL693M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luca Ceresoli <luca.ceresoli@bootlin.com>,
	Esben Haabendal <esben@geanix.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 344/686] drm/bridge: nwl-dsi: Limit LCDIF specific sync override
Date: Fri, 13 Nov 2026 10:47:57 -0500
Message-ID: <20261113153832.587947008@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 29f175c0d118c..38bc83e7af475 100644
--- a/drivers/gpu/drm/bridge/nwl-dsi.c
+++ b/drivers/gpu/drm/bridge/nwl-dsi.c
@@ -823,10 +823,13 @@ static int nwl_dsi_bridge_atomic_check(struct drm_bridge *bridge,
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



