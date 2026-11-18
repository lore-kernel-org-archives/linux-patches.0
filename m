Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795046399;
	b=X3/9oinFYlaFgl2W8p0DvrlMhA8V43q989bvtU9HfeZKR1gq9xrlb7/LRMKt7/vhRJGW
	 vPNEpkEeAAduDWwLWHo/RoT+G4whqiROsyQI8sIIKE1H3OowoV0Nb3/2u1D+zw9znGRV8
	 QOXwK8tYna1Yj3KRT95hQdgSOvQdwcmIQz0zLP6GRdYVc3nypLyKe1vH4pqkNW6EJzZWq
	 tVQm9YK4rH6zdAwBV5Vzl5/rYPTgxujET89S9Od2GmJhmUQ5pFiSisDhtHVo+1doZ9Do1
	 LGK+ZpGuRvnshERIEFSrTfDbNelO/q9LKfYNQpiesWsKDEKrNg9wtqDnYUY/WMIbAww==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795046399;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ZTVblYmvanQCeLVgn3E7nucJb5JZdNf3qrj+81S+mGQ=;
	b=Q75sZafS8AQwslvww97We/XIlZgzxyRP1ZSt4a5oqgxM2OzNyFymjt+jWOghi3dFd96S
	 jWzxO6vJdlEh1JlOP/nnj8cEA6KDQs611gUuZo1wsLOu9bt7QwrXh/+fJdNZ58uo5D6QY
	 reGJrrtji9uJ85lFuvOw79fnGhH593vMJjfz2u+rSLLSlOdMjlVeYSvsJwcqhx3SokGAA
	 TzunvkL2yTlRHF53fFYwUX6QNGTWPCMHFWYsDNCsBBz912TR77xT6d+jXG4fC+44NawXh
	 Xb4FEr0KyGzyOpT8DQ/QcDHIF/QSXl/AEQPgljssSpHk1qxBnijSxPUo+1E8OA3FCFw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DyNxo8hr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C53FB606A31C;
	Wed, 18 Nov 2026 23:59:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DyNxo8hr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 235231F000C4;
	Wed, 18 Nov 2026 23:59:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795046399;
	bh=ZTVblYmvanQCeLVgn3E7nucJb5JZdNf3qrj+81S+mGQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DyNxo8hrnoy6lp5ueSH7UyQkE80zpXg161aHOVEsvC9SLM8Ha7jSl8RnrSfYIJO7f
	 QZUHNpyHVJbSvF0SQY3rmVMpr+vofn4hrp19vytI1PJjf9XDiYf1w8epjUKCuYzi1F
	 tEaYuaKkld6gCe6N6WKB+HkRmbEpexA+FlLPDEBg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luca Ceresoli <luca.ceresoli@bootlin.com>,
	Esben Haabendal <esben@geanix.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1267/2857] drm/bridge: nwl-dsi: Limit LCDIF specific sync override
Date: Wed, 18 Nov 2026 15:38:21 +0100
Message-ID: <20261118150247.144666327@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 54902adec3b03..a9e939bc8c21b 100644
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



