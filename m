Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585656;
	b=CwSHOFjy/MUQgiVVnH9fRGzJr36StBqj6ikqHjP1aCIQ4U5m6JPhqzSTU2x51cFa7FpF
	 AcLkzwGYC2PbazVng2LzwtuK1t+faqHC3ccBkZLzlb69XVRb1XrQfyYzqHGzrDynIZoRH
	 jyHc++H5bWgbe9TgxOO3JX5wWFUauBOG0Yz5j/bIDBfUAfeTRJNxIgq5KuJemvag6m/gD
	 kvq4F16I3lyEtlRTQ+JIXDpveqVeYnsBsNaWWc8yKr4jDI4PkjOTW9YVFUg0J1w5RB6jr
	 WPFJTw3gGqAtIM/oJ27EHXntPFnyyUeULMGsRQXXNOBv6gzXHMZt+aLpojfh7/fONQg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585656;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=y+trSZzJEAFBxGvnNX7EerhuCj9X+Q1zXDC3HFBDZ3M=;
	b=HvIqw5Chz5Uu0ZUt7gdL7oOUk8DgTj4U7p9u2GHI/dxGLVgHAQUjiCZruBhMwxMzij03
	 tvfKxTYO+FFBfthLONnVw/O47xTD7AuKFDFPWT2ubKPbvwygBPHWbGfWWELXbPNdxFPxW
	 HFxXSVzKDfM3PynSjlAdwk382vQtjRciKMVhE7tOqkiS9Uguvx7tT9/2gJl1P5jwY3xHO
	 V4gtmGmRuvxy061krLzjpXN//Fshj2rJXICWSgm1ZDj7wilTdvPRTVhsi9Ndss+6CvbYI
	 gdsYYaiR4qxbcCN3iE/y8AtXCpg1bNEio169s61Lh9jjAQW+emy5lAzoxHP4X2YzUoQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hZNZIqMa;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF14E606B2EB;
	Fri, 13 Nov 2026 16:00:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hZNZIqMa
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B2E41F000C4;
	Fri, 13 Nov 2026 16:00:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585656;
	bh=y+trSZzJEAFBxGvnNX7EerhuCj9X+Q1zXDC3HFBDZ3M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hZNZIqMaRENVBmIsuT7OXCvCWFVW7SNSNi18LjRQWtDlIx0RTIDGizrTx/uABw7gg
	 NYq93dLm06pmSmfmO2J07kUP/c0S1yuR2mB2OoGAy0GMl9Cu9nl0+SzqxLdcLs9boa
	 vE0ojuhqH4v3OFWSv+xu+//6/rUrQ6R53V6CFD0o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luca Ceresoli <luca.ceresoli@bootlin.com>,
	Esben Haabendal <esben@geanix.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 270/507] drm/bridge: nwl-dsi: Limit LCDIF specific sync override
Date: Fri, 13 Nov 2026 10:49:34 -0500
Message-ID: <20261113153803.797938345@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 80e26a947ae69..1aab46e1a1687 100644
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



