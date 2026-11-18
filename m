Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795059088;
	b=shG0l85jrR52xduBYZ1t6g4pdme3uYwBC6hn/sSEopVI7bT4sAHVtONjxwCJ4jn1iPYk
	 HOxKtX2iJWjE8xy05t9XL+6f2HEzeUj1O7K3Ng7J2m1I322KvfYbblXAmn+Y79tEjdYkB
	 NHC/AUaKj7NMcXRbsqOPhBUGj4OsDbmzEWJ4o+OqaE04pCyk+rQtBdud2i7mvwrVSPnik
	 UK60p+qC034DEbBH9/NSQPjuRcTVGYE3D0BsadJb+D4Ydf4ApGDxfrvaIcATDkMvq97rc
	 YsT02/VUzjUSUHWrH8r2+FJHgN3Sb9rcj7gmikz5HlQJcVBikOLiV97eWIe4EVR7RUQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795059088;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=mtNHCx6EjdjeRVK2gBiX2r9iQL+weEmaE0ZmVOyIdZQ=;
	b=GlcDvKC6pIsnmeFP1gHVrU4SD38MOqz0BkpO0ynBi/mwX6eQcSZ7VnYyRv6P4X1xMa7n
	 EUyczsXYdSrtKx9HYgzIXohmQZOkFBZJcmBKe6agwsFzrFYl0IVeqONHkO5dqiMV6tL6D
	 jtQGlXmZc0iuzLjxI/B2IFF5HauY/Sp5pA4ZFGQqK4+6M1HnNn0Ex5iUK4arScAjDYa4r
	 a5FcGPWTJrk3D/tq6AxrkgL3YFlhMNdi0Y0O/+wAP8cgJWz/gGPr5c9EasHrX+YYfF5ks
	 +CMSMUzIJFxMz6QwtqEAHMTQh6Q+R41Tec1Er0zf0vSbjFw2jpzwQUKLv3YWl8wKU5A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="PKr3Zj/F";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EE39606A320;
	Thu, 19 Nov 2026 03:31:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PKr3Zj/F
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76EC11F000C4;
	Thu, 19 Nov 2026 03:31:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795059088;
	bh=mtNHCx6EjdjeRVK2gBiX2r9iQL+weEmaE0ZmVOyIdZQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PKr3Zj/FJeQt2a4sDM/TS2o92qK7Fn1gdb/BIq3eDQ0B6rcf54qPgEt2Zs+FaB93E
	 ONpLUgvAhpm6eheC+jHHAe8Muxtkk1KqgCm8SMxfhfep8L/gF1Peyi0gw8rkvwikMC
	 MWZcqSLbFUzf+NEIRKnaPlPu+83KQT6aZKbrPHBE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luca Ceresoli <luca.ceresoli@bootlin.com>,
	Esben Haabendal <esben@geanix.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0718/1848] drm/bridge: nwl-dsi: Cleanup endpoint mux control selection
Date: Wed, 18 Nov 2026 15:45:56 +0100
Message-ID: <20261118145945.889987818@linuxfoundation.org>
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
index b68d335981588..0b2dfdd5d3233 100644
--- a/drivers/gpu/drm/bridge/nwl-dsi.c
+++ b/drivers/gpu/drm/bridge/nwl-dsi.c
@@ -116,6 +116,8 @@ struct nwl_dsi {
 	int error;
 
 	struct nwl_dsi_transfer *xfer;
+
+	unsigned int endpoint;
 };
 
 static const struct regmap_config nwl_dsi_regmap_config = {
@@ -1087,13 +1089,12 @@ static int nwl_dsi_parse_dt(struct nwl_dsi *dsi)
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
@@ -1102,11 +1103,12 @@ static int nwl_dsi_select_input(struct nwl_dsi *dsi)
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



