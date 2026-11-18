Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795037730;
	b=0E8RLvYq95Iv+le4OX9oCN1X5Yq+fhmk04W3vRIvNEwInsnsoYBs+T9hlXrt4FF0TXk8
	 czWPYch7+C/zPt6Kn5fmb+m4AX/SPcVkZVWmEzAvJ109jXpogPG6aGs79WKBzOrZYt6bg
	 ITZCK8/DQe1vYmpPM5kcg0eC8rDuLpmqDTQR+szg/r58aOewgdF0rMEgPxCpGsaWoWGIF
	 NBVfyMdATlGlsJo+OC8Vb9q8QXBEkqt4lMYhMlpF3oWXyvn8Z9l9UzOQuB+UFRXqjU+N8
	 8zJwS7Os/ApUUO5TuzOyMxX8qTSx6ZGHomRWa8hJNUjSMs9awYGWbhRKQFB+Wfmm/tw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795037730;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=HIu26SZZfUtG/2jbNUk5NFLzbpUl5yjsWqjvQHiWv7s=;
	b=3su3zWOItag24K6EoGZKYyKK8lGL9kEfGiYwCdT5gljxEDpd4DSuby8h5lCZy+G05IoQ
	 4xQLBfgtmbWl5P/Np0q2I9umuyxUuk2Yl4lJrcD2Fw0/6916Wfx/VK2cVu4NnDJxQtWqC
	 LrxtLORh/asrWDU2H0YLrZmSgPqSBTPZsjFbw10TQkzt9NK2b86RFCG2dk7ZY5lfJcA72
	 62riyX/2fALuDfh3Us3ShQ7ChaH8V4lgNr0LSrcvt7IJytNnQeY7l+lOFSeh7+HbPM/Ul
	 JDFF/5mKrQSPMlvuNa28Ga6T/qZ/bXCGnACvnr6ztU1/idSaf6kkVccrIy1L1vlM14w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RtVDlyID;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D021606A31C;
	Wed, 18 Nov 2026 21:35:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RtVDlyID
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 691481F000C4;
	Wed, 18 Nov 2026 21:35:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795037730;
	bh=HIu26SZZfUtG/2jbNUk5NFLzbpUl5yjsWqjvQHiWv7s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RtVDlyID/unsVCHbVFvzPvg7C3VPhQtrQrPKt6Z7MPq7sU7XrWlDOMDPbo+zjwvHy
	 EYG9m+Y+UZ8ZWreeoICml22xObkbyEv6pkDNAQeO3GpbZaagjUj5BONubSWA6ace+b
	 sdTE1+74POuNkDxbIMPBTGCRK2WgDMgfgKNfA7QM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luca Ceresoli <luca.ceresoli@bootlin.com>,
	Esben Haabendal <esben@geanix.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1498/3318] drm/bridge: nwl-dsi: Limit LCDIF specific sync override
Date: Wed, 18 Nov 2026 15:35:20 +0100
Message-ID: <20261118150405.855375419@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index f92e1808f069c..06c0a9b12087d 100644
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



