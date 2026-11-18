Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795053360;
	b=p+6Jhe+tOBneB/N227lvuzOnZHknBePEl7Nxjo0QmEYlfERP7bHw+JWsEK1GF7oTUVFE
	 umO088BJLqNn/HakeZL7J0oUumeAH1azPp1Fit/Tg6aAF/PLJimctTdTWGQqOypJfnt1S
	 P4hAm2jiUTk4e+tAU3m69Ld4NQn4CPv3uKdyUraXf8ExTGDoxs8anR/VDagKdmiD9H+mZ
	 JCcms0f0taPUpfmUxn4b0UB8Bwo4alG0NWzsAjW4cHYBSEtXagw1pqAYMqaIbFv9dkgA/
	 bwqZPl1BSyb9ZnLRph2ySo1yDVBS5Y3I2Dq76tn8Dih5pz/l5GbPLzrCfYCyUaURLGw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795053360;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=UjZoNCvgqKCfhnRYnZpETDmCn4TmFdEQuyuFX0cFxRM=;
	b=MB9AJEFz+yzyukjVnUZEqf3HowsEdmH2Mav5B2G3uHo7VnAobqWy/xbLr0Jp9PHTv3li
	 UQXNKhbCpu6DzEqloCpVH3xRS2ZLbmzvjlFpPMBw7OZ25tYVkW/kyR01hsVGzO1kHZLcu
	 lwERpV3NFbfMGT9REJw3W/9Lqew6cth5krRvMtYJdbAuobqPo7gCceBI46ZV7yAKfEUOQ
	 h9N0gIDtKrs60jrGQgTMzaxaLDlEiJZvaTqWUelJnmlrwjGl26jP7PvOmjsqiwxKYmp5w
	 Pmt+/71pOKwVlXBmORE94houFCkksKjEPTYoP1JqFJfjxRCR6bozEzZN6GzfaiHti+w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZUZzhq0C;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAA13606A339;
	Thu, 19 Nov 2026 01:56:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZUZzhq0C
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DE341F000C4;
	Thu, 19 Nov 2026 01:55:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795053360;
	bh=UjZoNCvgqKCfhnRYnZpETDmCn4TmFdEQuyuFX0cFxRM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZUZzhq0CWa31dmqqt4zMZ4wHtbqRsiZEeaVwgK7zzw1Ue4lPAxHOte3x+Qjp8oJYc
	 NDDZpQAMNac5snuqiQoDER0PJkCeipsLz/P0xPCXAz65N3G+MRFTesH4hQKiIPzRsV
	 GLWzBf5KE35kQ2EP7OpEpmAK2LOvNFpAgEX0j0aw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luca Ceresoli <luca.ceresoli@bootlin.com>,
	Esben Haabendal <esben@geanix.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0889/2214] drm/bridge: nwl-dsi: Cleanup endpoint mux control selection
Date: Wed, 18 Nov 2026 15:42:45 +0100
Message-ID: <20261118150047.845773023@linuxfoundation.org>
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

[ Upstream commit 8dad0ebd822f54102aadc6ca4f0f8777112d175d ]

Using the endpoint define values makes it more clear that the argument to
mux_control_try_select() must be valid state integers, and not something
that looks like a boolean.

The endpoint value is kept, as it will be used in a following patch that
changes behavior slightly based on which endpoint is selected.

Cc: stable@vger.kernel.org
Reviewed-by: Luca Ceresoli <luca.ceresoli@bootlin.com>
Signed-off-by: Esben Haabendal <esben@geanix.com>
Link: https://patch.msgid.link/20261027-nwl-dsi-fixes-v5-1-b6d1d3d2d356@geanix.com
Signed-off-by: Luca Ceresoli <luca.ceresoli@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/nwl-dsi.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/bridge/nwl-dsi.c b/drivers/gpu/drm/bridge/nwl-dsi.c
index 691039aba87f4..3de8204230af3 100644
--- a/drivers/gpu/drm/bridge/nwl-dsi.c
+++ b/drivers/gpu/drm/bridge/nwl-dsi.c
@@ -111,6 +111,8 @@ struct nwl_dsi {
 	int error;
 
 	struct nwl_dsi_transfer *xfer;
+
+	unsigned int endpoint;
 };
 
 static const struct regmap_config nwl_dsi_regmap_config = {
@@ -1109,13 +1111,12 @@ static int nwl_dsi_parse_dt(struct nwl_dsi *dsi)
 static int nwl_dsi_select_input(struct nwl_dsi *dsi)
 {
 	struct device_node *remote;
-	u32 use_dcss = 1;
 	int ret;
 
 	remote = of_graph_get_remote_node(dsi->dev->of_node, 0,
 					  NWL_DSI_ENDPOINT_LCDIF);
 	if (remote) {
-		use_dcss = 0;
+		dsi->endpoint = NWL_DSI_ENDPOINT_LCDIF;
 	} else {
 		remote = of_graph_get_remote_node(dsi->dev->of_node, 0,
 						  NWL_DSI_ENDPOINT_DCSS);
@@ -1124,11 +1125,12 @@ static int nwl_dsi_select_input(struct nwl_dsi *dsi)
 				      "No valid input endpoint found\n");
 			return -EINVAL;
 		}
+		dsi->endpoint = NWL_DSI_ENDPOINT_DCSS;
 	}
 
 	DRM_DEV_INFO(dsi->dev, "Using %s as input source\n",
-		     (use_dcss) ? "DCSS" : "LCDIF");
-	ret = mux_control_try_select(dsi->mux, use_dcss);
+		     (dsi->endpoint == NWL_DSI_ENDPOINT_DCSS) ? "DCSS" : "LCDIF");
+	ret = mux_control_try_select(dsi->mux, dsi->endpoint);
 	if (ret < 0)
 		DRM_DEV_ERROR(dsi->dev, "Failed to select input: %d\n", ret);
 
-- 
2.53.0



