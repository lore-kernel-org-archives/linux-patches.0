Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591158;
	b=DE2zCuNu09ZVEAPHvVddnKENY9sLyC3GEIE3XAffx4ksa/lgETZvVyU/v+DhhRdmAajC
	 EVdwuU6dSomchChY6g2VSCcAUOg/V+bj7pc7PRd2Lh5OyaSD4qgCVR5QUlnA+1Edl2ekA
	 lGHpdR5R/BUXKyLeJtmRfC5v4LiBtVxiOn53hsn4f1wTHjRMst9Oy2lVKdFioa58KRICm
	 1tdg7ZDqwgLYvpd82QqJPGUHARW5oBIeFwtl+9e3RGVOm9YQwyS1AvCvR4UuxCSbBz+pu
	 yKgHFY4HWhc8D0PncMcvDQt08gvyR8ipbfj22SrSu0HUdEKzBQMCakTRy4P5rra5/Tg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591158;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=JVebGlnwQMjLSuR3sZcmJp7LhnNAE3UpoCJKmADsqSY=;
	b=P4XdBamlGA5c4lgGspYqfWtQ1p0xYAEGYm6QtUJ6jTk6yMRvUXADa/CXIgroDEjFYDH3
	 TFJcNxb3lecxsYBuIjtSHFqE7eNCTs7V7rYvfim3Z8KbobrDuQboMuDzcWFAE/vK1AItH
	 v63xXqDbZ+X6RzjjnYR8GYxNF71t1LZhkwYWMukv3+tJ2R28sJq8c+hJzLk9/lWKI+u25
	 cZjNMKoDDRsdJQVrJGQ2ddbHDwf3uZnC/74+c9KebVm1sPMIWm2hGxdF1Xs6ItpOsPztg
	 jBv4/7W6D4u76/56uVmWB/UC/yaDRwPoa/GmWZZZ1XP7YQmLF58MnYhxGL/LCX4MZsA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=g9Judy4W;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF199606BD2A;
	Fri, 13 Nov 2026 17:32:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=g9Judy4W
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 315111F000C6;
	Fri, 13 Nov 2026 17:32:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591158;
	bh=JVebGlnwQMjLSuR3sZcmJp7LhnNAE3UpoCJKmADsqSY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=g9Judy4WBV3imSnx6Ger+8ZFlQ2u2jzHvwtgPfcsn6/oRC7uxrpkbpejTQaPV0r+4
	 yCxk8OmZSahGwGLyMisZvOaPhMxZ2eS30mVBeCWTVHPigin+77bxPoWxgrlNa52D/2
	 /dzkILvy7oDXcOT319ijYwx02eeZt5wlIwZI9pPU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luca Ceresoli <luca.ceresoli@bootlin.com>,
	Esben Haabendal <esben@geanix.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 302/670] drm/bridge: nwl-dsi: Cleanup endpoint mux control selection
Date: Fri, 13 Nov 2026 10:47:46 -0500
Message-ID: <20261113153822.154506401@linuxfoundation.org>
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
index 5f05647a3beab..ffe738e93deb7 100644
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



