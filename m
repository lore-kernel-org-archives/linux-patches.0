Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590369;
	b=T2d83tQbm10rn25FZci+h4LRvxcANiBz8HhJvticbMwvF9JuG0BpecZ6E/HPcGziPp6I
	 a8/W9GsTNJlDPVlRDVp573KMKQhaQE9O9fJ2WdJX0eVRxC2R0k2ipL3JL46fSOf/gnRKg
	 iFS9aNuwqmv4qkdEY9amMS8IuglRS8gMkv5DvSf2Flbva+DnzC2ulNLIVtKf4g/+euj07
	 FVpWa+67AFwci0KI94c5NkCxdct30s0tFVH3NQsT1O+F9SW/xvSxc5X4AzlqMxQfcSeoh
	 BTJDXkumWqxaAG/+QDXCzVhk2JvUa/NzPJv0YORe74pek1OUc+mBgM7zJMrFd9vTvbQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590369;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ghjoh31S3Abc55e4k2Zm/DlBVIp6y9Bq1sttNIhkn+0=;
	b=zaS+NI8ky5y54rrzBbddSWEO3EpHZ9ztMy1hg+pOlNNAnWfxUfEm/p+21bvrMoq+PKLM
	 UKugaJcP75ztD5dDoOFjtw6uOnTEYkUspZKToSHhly0xeUoCKdBCRvpMVTwHWrPIlUM8c
	 peBYj+F2xey72top1rlUJmVV9nsNJb1pXtOt8uojvxKqVbhsRhtLfj+iHMdvuEyvUP0x7
	 zmqmfgapO89i7FGX0nG1pBHC/d1/81oUDbn6TWQQOihgL8p2/o6u88/e3ltsH6wXE4ktv
	 JiHejMDFnQtCIyMXp6iJoWWOtBbJoZYOYPBIK82MCQaCEVm8k4Fa4vri/qwYa/kAcPw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XXBNdiSC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF0BD606B341;
	Fri, 13 Nov 2026 17:19:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XXBNdiSC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A5BC1F000C7;
	Fri, 13 Nov 2026 17:19:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590369;
	bh=ghjoh31S3Abc55e4k2Zm/DlBVIp6y9Bq1sttNIhkn+0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XXBNdiSCNIZDPCTQQVHIAojQ03V3nMYXF4Baj3bWpDuOEC/n/3dPZYO64Y//vCF57
	 GreoK+mkfJabdlLbSv4icWWxSUnYkGbQEPMX7AIRVQuQ0nKO1/PCjL6cfXeXH3GX/3
	 XDVZU51TtZi9m1dEbzj4lkBwAdFTmZC0pecUaMSI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luca Ceresoli <luca.ceresoli@bootlin.com>,
	Esben Haabendal <esben@geanix.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 343/686] drm/bridge: nwl-dsi: Cleanup endpoint mux control selection
Date: Fri, 13 Nov 2026 10:47:56 -0500
Message-ID: <20261113153832.554283508@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 2f7429b24fc20..29f175c0d118c 100644
--- a/drivers/gpu/drm/bridge/nwl-dsi.c
+++ b/drivers/gpu/drm/bridge/nwl-dsi.c
@@ -110,6 +110,8 @@ struct nwl_dsi {
 	int error;
 
 	struct nwl_dsi_transfer *xfer;
+
+	unsigned int endpoint;
 };
 
 static const struct regmap_config nwl_dsi_regmap_config = {
@@ -1088,13 +1090,12 @@ static int nwl_dsi_parse_dt(struct nwl_dsi *dsi)
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
@@ -1103,11 +1104,12 @@ static int nwl_dsi_select_input(struct nwl_dsi *dsi)
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



