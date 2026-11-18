Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795037727;
	b=W7+AFC7vBF0Gpp3SIx1sGNdUana6r/WtCsQVlEDOhFiXAywSfvCz0ZVxrPK98zHHIv3S
	 N5EGsZQsdtZm3DY+IT687fMiVRiJq1zApd57t5E10KlM0ca/twdi0hfrZVVzYZ3H4H+7Z
	 k08U7W/3+9PBX08mX5g+15YhfvSHcDu2Fwp8zX1XbB4LUKF3EWppn/lq1tIl+DdYCSMmo
	 QknGSRU5YYSaGqf0YuR24tmoWmMYPMZdL1jpH2gnclf68E1B7o38gpFW1SKlB0GIIAIB2
	 s3VlHEfNecESJEYGg68Oo9fdloCzxLEsi5OzWNBa3FPlkSq41ioLD0pynzfdL4AMhJg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795037727;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=VoD7sleK1n2dsJ/As1DqzBbYBZevfNRcbIr6/v2fHzg=;
	b=4wXfumEwpZFkcwCnMpVoi4llSJRg2yoIAM061bBVTOejgrwUqyjyK+zBZltr4+br/vZv
	 HmtiiJaIuU1mrM7w01yiKHgtgC4qpTmXoVCFvrhz2haeoh4t7g/HDG6VEqOKktAW3yPH8
	 WrkWRculjIXERBWg9bDXpddvgLAAfm5klKrAJUON3e8CuzuxbqjGeLFwbyLMdQxoTXole
	 d+1d8nuBbzhob03TaJds7MPn05z88lYrvKMwgUkN5pIJGFUDn3DSfTPtFQALDaxy2RBKu
	 Ciaanq15G9nNVcVFbJsYTzuZ/XuKVhNC5Sx6iaXhb7bkl9MyU/TpcapAiJ+Zu+4rwtA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fu4yxFip;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36C71606A320;
	Wed, 18 Nov 2026 21:35:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fu4yxFip
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BF501F000C4;
	Wed, 18 Nov 2026 21:35:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795037727;
	bh=VoD7sleK1n2dsJ/As1DqzBbYBZevfNRcbIr6/v2fHzg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fu4yxFipAUxM0L8NBzs8Bz3jkKi1bVl/AnwmXe1fGiFioWu5Xt87TewUhE4p/YFTP
	 s3Sx1SAFt/bBnsVu0WGwB0puiDxhvr28CqKlXJOfN3AD0capgFKtE6RwSXv6BuH9E/
	 gy1cDE0H69gA8yDnJgWaSVbnPSRve9vTOhNmLbL4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luca Ceresoli <luca.ceresoli@bootlin.com>,
	Esben Haabendal <esben@geanix.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1497/3318] drm/bridge: nwl-dsi: Cleanup endpoint mux control selection
Date: Wed, 18 Nov 2026 15:35:19 +0100
Message-ID: <20261118150405.822837047@linuxfoundation.org>
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
index 8d54091ec66e4..f92e1808f069c 100644
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



