Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019558;
	b=bJxlJ8kjWWchwOMEA+nwsH6fqoxcCXjph2JntiVJ2UkkZu9Xljb34XCPTgri8NVyd6hw
	 9XhgW7qtGkXY6BggdTacOj3/VIXAV1oxFzItRdMAqgp3u9DGAwd5Y9w38r62Lx83vHDhm
	 jxL5UWRV8jEznZn18FtSVh2W4h2pVzqpHWRzMAWy9MGulbvwVMHtv2o0cDof1G7P9sRFy
	 6OMEISPbiD8XFzidwxmBnDxxw08D6dYFmqfF+J4xiVtidknLgAHbQ8eZef3B3lzjImjkZ
	 fpShj73PmMKGrEXLCpPCeM2yVGM279sSlvYE3IccaR2apUzVX14GmhLiVPx0R5bpQkA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019558;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=DRhbTeDJVvi8/N9R3RjKFtQcB8bwZINXv7ePJJzuKW0=;
	b=G9cBXydF1VWoJVHgNvcswz4GGDS6V/ejpzHgWdm6DJNaDaT1MBJE4cFQuleGj8wefGDe
	 Al/39QUZURvwd1iDgfyJnY8Qvc+9ymjA5twxj9Z1tpiTTzj8aKTagVNLUC1qflEp/4NSf
	 mXeFH4HHDWzImtxmgZ2//gfZIET7c7k/v8/wiFocOVP8oRqS/GV1iXalTwbZrkXTscEWu
	 WgzFjxsth0syDr+/b+oYScuu7naVUwN1RV9TkpajpNBSz8DcuRLQqn1/sX29RSwf0ebdJ
	 Sckf0RQVapsUcqdaCpKv6ZXQTAi7pqPa2xjIdD4Vj1pKBINqZeMZsWu5A9BxoyMdcmw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HfV0NqCQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 563B9606A7DB;
	Wed, 18 Nov 2026 16:32:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HfV0NqCQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B33351F00925;
	Wed, 18 Nov 2026 16:32:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019558;
	bh=DRhbTeDJVvi8/N9R3RjKFtQcB8bwZINXv7ePJJzuKW0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HfV0NqCQ+X/xTC8anixXdO0umf/nMAnN0ilzbslGjzmdxG+33gVYTTY+WCnZl1JcG
	 Toj8Bcszyds2SAdRnbt+3SHngh6frU68r6LY8DZrXwzIJrdgpYXRIkC4s8lLwHWA8e
	 6mCMiqFiY9MgbbGWB7kuJufI1W8kVT1ufHNRvA94=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maud Spierings <maud_spierings@hotmail.com>,
	=?UTF-8?q?Robin=20R=C3=A4ber?= <robin.raebi@gmail.com>,
	Cristian Ciocaltea <cristian.ciocaltea@collabora.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>,
	Diederik de Haas <diederik@cknow-tech.com>,
	Igor Paunovic <royalnet026@gmail.com>
Subject: [PATCH 7.3 1639/2651] drm/rockchip: dw_hdmi_qp: Add missing newlines in dev_err_probe() messages
Date: Wed, 18 Nov 2026 15:47:59 +0100
Message-ID: <20261118150346.832437797@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cristian Ciocaltea <cristian.ciocaltea@collabora.com>

[ Upstream commit 7554a1cb23148a3ab0b74c7edd47356c26b40ead ]

Add the missing trailing newlines to a couple of dev_err_probe() calls
in dw_hdmi_qp_rockchip_bind().

Fixes: b6736a4ea3fa ("drm/rockchip: dw_hdmi_qp: Improve error handling with dev_err_probe()")
Fixes: e1f7b7cbd74c ("drm/rockchip: dw_hdmi_qp: Switch to drmm_encoder_init()")
Tested-by: Maud Spierings <maud_spierings@hotmail.com>
Tested-by: Diederik de Haas <diederik@cknow-tech.com>  # NanoPC-T6 LTS, Rock 5B
Tested-by: Robin Räber <robin.raebi@gmail.com>
Tested-by: Igor Paunovic <royalnet026@gmail.com> # RK3588 Orange Pi 5 Plus, dual HDMI
Signed-off-by: Cristian Ciocaltea <cristian.ciocaltea@collabora.com>
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Link: https://patch.msgid.link/20261005-dw-hdmi-qp-scramb-v12-8-195157ba0b40@collabora.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/rockchip/dw_hdmi_qp-rockchip.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/rockchip/dw_hdmi_qp-rockchip.c b/drivers/gpu/drm/rockchip/dw_hdmi_qp-rockchip.c
index 42f2627e1a052..df0e2bb1eedc6 100644
--- a/drivers/gpu/drm/rockchip/dw_hdmi_qp-rockchip.c
+++ b/drivers/gpu/drm/rockchip/dw_hdmi_qp-rockchip.c
@@ -681,12 +681,12 @@ static int dw_hdmi_qp_rockchip_bind(struct device *dev, struct device *master,
 	drm_encoder_helper_add(encoder, &dw_hdmi_qp_rockchip_encoder_helper_funcs);
 	ret = drmm_encoder_init(drm, encoder, NULL, DRM_MODE_ENCODER_TMDS, NULL);
 	if (ret)
-		return dev_err_probe(hdmi->dev, ret, "Failed to init encoder");
+		return dev_err_probe(hdmi->dev, ret, "Failed to init encoder\n");
 
 	hdmi->hdmi = dw_hdmi_qp_bind(pdev, encoder, &plat_data);
 	if (IS_ERR(hdmi->hdmi))
 		return dev_err_probe(hdmi->dev, PTR_ERR(hdmi->hdmi),
-				     "Failed to bind dw-hdmi-qp");
+				     "Failed to bind dw-hdmi-qp\n");
 
 	connector = drm_bridge_connector_init(drm, encoder);
 	if (IS_ERR(connector))
-- 
2.53.0



