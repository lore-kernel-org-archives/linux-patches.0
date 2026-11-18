Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795046397;
	b=QeGMyVeMog9jKhNFr2DvXv5R5JzmM0d9Kc/bJb/X1E91hbnJ1WH9QPJkVZCkmcVfrNGP
	 MKipOoFz1U6hmIYbbNXhYm6fqWs0bL9leJCNnBKuSZsdtjfiphX/+qxLD7e8BuF1zsn3b
	 w/fXpbn/UILC/DK1wXkibyMxAwCPSv9bo7u1r0EJ0W8p7vthVmybUmuDg6X0nEvqMf5+1
	 EGJuwOFGXBNfncBVIxGu7xAm/YVBHSgwd4EeDzNJ0X054KrM9kYe9wrjYHAxgih4CwfVv
	 4ZoCVIK13N1MPSxHrX07qnngV0OD2b4LGH/prSgkMAvMKySSlhXBf0F8H9lMuXCx2aw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795046397;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=lTlatybL0beVF85WKFx7taeddDP3Bf2F+1JBuw0I54Q=;
	b=J64cf7p7ffyHrKqZurNVUGQ5FtlNJVsNz20Kb8CInYRLewnB2bAxP1zKB6brjtaOZOvb
	 nDvdoNafTaYZWb41h89WvrE4DVM6gPjHSeA+d3MBjsbbB9Idm5AyZYzo4rA5phvrXsslL
	 4+ZAPx7pVxM1axcLrD7t41i81fX5/kCN4qb8isXpP+ZdMGnJykVKLtTlJBeHAyTZnyRtX
	 DVfCtOVTFw2pl/Rtxf6F9BnUsvmw/EMvsSXUCfbyalb0fKBenMgO/cZwe9LSf8jrW/LGg
	 TyuXG7JZQC17Ao8fFwuof4GEV2ViHoj/93QLIEjVTFKXXPnaYCifowAMmRS5S7apK+g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="t6t/kt6s";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0836F606A320;
	Wed, 18 Nov 2026 23:59:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=t6t/kt6s
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61CD51F000C5;
	Wed, 18 Nov 2026 23:59:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795046396;
	bh=lTlatybL0beVF85WKFx7taeddDP3Bf2F+1JBuw0I54Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=t6t/kt6srsDk3jtYUCLUHhgnDyfWbyV59qfx9BedIDJfBlKSOE5uQLauCFOblw/g6
	 680/87MwAj5ytiTID9n+eA9ujPFBZrkiIIzmvpjv76YeSVk5tJo7COb7OMHcvORNel
	 IFwydwuhXmJld6sfpHuDMKc0rI+jdWqh/nGkdKUU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luca Ceresoli <luca.ceresoli@bootlin.com>,
	Esben Haabendal <esben@geanix.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1266/2857] drm/bridge: nwl-dsi: Cleanup endpoint mux control selection
Date: Wed, 18 Nov 2026 15:38:20 +0100
Message-ID: <20261118150247.110675643@linuxfoundation.org>
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
index 6dc2a4e191d71..54902adec3b03 100644
--- a/drivers/gpu/drm/bridge/nwl-dsi.c
+++ b/drivers/gpu/drm/bridge/nwl-dsi.c
@@ -110,6 +110,8 @@ struct nwl_dsi {
 	int error;
 
 	struct nwl_dsi_transfer *xfer;
+
+	unsigned int endpoint;
 };
 
 static const struct regmap_config nwl_dsi_regmap_config = {
@@ -1089,13 +1091,12 @@ static int nwl_dsi_parse_dt(struct nwl_dsi *dsi)
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
@@ -1104,11 +1105,12 @@ static int nwl_dsi_select_input(struct nwl_dsi *dsi)
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



