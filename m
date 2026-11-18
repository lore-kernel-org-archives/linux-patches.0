Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795059090;
	b=GqVhiDu/MscwhW3No7gbaihZN72Hx7sYUmW5ZN4JJRv8PYCa0QARZitUZfxJ69i0LLdG
	 TVV1e3hJLRy74wYXYDwFZNk+NHiYPkjEJSHP1kx0jMxwBH7XGdvUOdj2ApVt2WL4QRXrB
	 xWeQCsccirOb5B3qNO0zlkiXSfA2dsFihkQbvEHwWwoLquq+V2/199e+4bFlsasY22d/p
	 K2pcqRAfxjZzho2Mba0eJ3reZGVzZoLbM7F02XENaF0wq/IVkEiK3UxPAo4o1vuQi3cfG
	 n8bRysShaIoSwFkZDgINmYIh2vOfCzEZeOY3OteqSCQjOnuZ9tTxARnqHgX9mAqoy+Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795059090;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=SGcA1vreaKHW6uTxRUuKsPnzc7LrXxSqAOMQOjgPTm8=;
	b=o3JDNncUMNG+ZWEHnuO5Yi09o/0+EttRD0qjjNBYA9bVMS0biHbD4xfIY4NCWCKHC1WC
	 bnNtSybZ/PzBG7ejtFVx+VyQJT5TL0kqy2A92ZVrUZCnMHX0QnBYhzZrgpAucTp9ddp06
	 Yd8NYUuw1ZGcfZ2VCtYyelYhXt9bxZxrrG7NFsY/7iYTcFAoMPTl6MXqB37ISl7KM5oks
	 cPNX6oBRDfUCBoedLj9iVJsG+nx81omJhplVO7EAxxh5HNklAI8ilEVJryTpFWHFQtKhg
	 7kTcfUyUhk6zAgq9oL8uRCXJ1rvIhrBM7pcsgDiOS0cBkVWDD5Xqj65bs4NCgwAx6WA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ej9Lt5EO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5785606A31C;
	Thu, 19 Nov 2026 03:31:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ej9Lt5EO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 375621F000C4;
	Thu, 19 Nov 2026 03:31:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795059090;
	bh=SGcA1vreaKHW6uTxRUuKsPnzc7LrXxSqAOMQOjgPTm8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ej9Lt5EOy6T+0c7eZnNmjmaDShC6SKP+1ZZG+3XEbg5UVA6Im86lTAVFTyytZv57Y
	 a4x1xwx+hp80fqxLHr6JeruUOItOa1M2LHA0ltNHtQH11F2S/ABpkYv/1BT8yHDonR
	 KZnkXzHgpis6IVD+3apdTobfWoGOmToil+6oaaxw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luca Ceresoli <luca.ceresoli@bootlin.com>,
	Esben Haabendal <esben@geanix.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0719/1848] drm/bridge: nwl-dsi: Limit LCDIF specific sync override
Date: Wed, 18 Nov 2026 15:45:57 +0100
Message-ID: <20261118145945.929058768@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 0b2dfdd5d3233..f9b6b8a3f6e67 100644
--- a/drivers/gpu/drm/bridge/nwl-dsi.c
+++ b/drivers/gpu/drm/bridge/nwl-dsi.c
@@ -831,10 +831,13 @@ static int nwl_dsi_bridge_atomic_check(struct drm_bridge *bridge,
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
 
 	/* Do a full modeset if crtc_state->active is changed to be true. */
 	if (crtc_state->active_changed && crtc_state->active)
-- 
2.53.0



