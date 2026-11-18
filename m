Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795053496;
	b=DReT8a47r+7grqzgU0DrUOH6ZixYGrGJUJV4MBCtUIFEW83QPCDUkQ7lgdlv5yJfVGFr
	 IGEH0UceGG9Ss58VXFI1I4tEV1oPBzOTb352SW/TwzzZ+Fg4HmHAagZupFlNnYq5C/ZGq
	 XRWjvJTkV02AjVVHhp5ylCnNAStJp3zD+mw58eUmbDfaDn7PbPhkW7mqmg/iRANt9mUmF
	 N9GxF4gp0l672TF7ofDYoguMVYgxTdyFjuDksndKX2RivfSjvJ2D+Cvdl0/8WxbudW6/X
	 Wf+Z2QPVZrBqhLLN6WI4F0tzAZWb+Q6lCuNjxKMFmacR2GkD/TBceT6fjmU/3MiDXYQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795053496;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=KdO81jxFwY2tTvb1XxTaHPDkwZlidL4sVlR6bek5jeU=;
	b=zmVhgZieIfU9I8V8xSyakihmpVlWs2Xq3SXYUMQuaERHsL8qTP+mgSgu/kcEf8iMd41g
	 K0+GybuB2aD+OHt7CSuReFq5IVT9U08NjR40rZjdTslT78J87rwYUY74qYb7Dj6WGytpg
	 UKo3ZROVKXEXGBgEq8xxZw5UKbqiTsSLYaRnwuSyIb8hR+spSCW2MrKeugNXIA7aAgkW0
	 vAdKdY0zBnvKPlrHQFoFvZEqQbUF8rylGnNkZHEuWh7qRQEq2wHN4tTgmQUaN2wWAPl5S
	 gxeEODtwUVW7VuPOYCuvgeWfRLhOafVm4Bbh0okOUM7Ewo2RKPvtc93inB5MpuTbvrA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RKFqJOkO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1634F606A31C;
	Thu, 19 Nov 2026 01:58:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RKFqJOkO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62D711F000C4;
	Thu, 19 Nov 2026 01:58:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795053495;
	bh=KdO81jxFwY2tTvb1XxTaHPDkwZlidL4sVlR6bek5jeU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RKFqJOkORtB4n7ngYFHLi6MtaNtqy8zYgSLkmCS4w18Kd/CGy4eqhlYAa0PNw9OSY
	 nT30WKtMkLu/aljQ85Sn5lKomCJ7/ZiC6no2XI5QHH3wXrC1pQumxyItv5162kQiun
	 ZFcPVcMXpz7WW0D7WdUaziHrP4fZ4hx5tvMCeiS0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luca Ceresoli <luca.ceresoli@bootlin.com>,
	Esben Haabendal <esben@geanix.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0890/2214] drm/bridge: nwl-dsi: Limit LCDIF specific sync override
Date: Wed, 18 Nov 2026 15:42:46 +0100
Message-ID: <20261118150047.903930687@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 3de8204230af3..194e00657ae92 100644
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



