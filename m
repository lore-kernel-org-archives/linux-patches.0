Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585654;
	b=D+6qJk9xzZdxmiUYokLoA8Blw3aIVrOzM4f95QL5qCtEDu7aIrSaJlyl+B0RK/cNR18y
	 hqP4KrUj+ynjp5dpuUThVG17PrgU1W3JhMgn8I4OHo7fOFbRyqA8/kX1TcO2EUZL97gnh
	 0dIxrEEYSEp+7tpUGOi5BQPGd20Gz8KHCoM4xrvp3Tf+TsRiGatBRgiaRpfl5ac/Vu4Us
	 ui80J8VFtcNkpeuL5haJwjUVlQNxjEiCRc+/FMx6oeZcY+clH9uif4zVimJIKZfxsD7Ge
	 XYB44lhx5piLgFcrDizPIb7hQLs1rHcwhBZ9x9qyRK/VjOY98o/ndO0lKSoLo+e7jGw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585654;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=mCTNVIueeE+yVLVClk6TjB3nMrZ4m8lv3C6X7luKJcg=;
	b=W/N3UGE/s8UYTGvV3u0d7+bFc0S+Oi8z/8K/C2hw2lISNF6tNczbh0Y/qaiuhp8cTHiQ
	 1qMcM/bKeRKhjaF/o31Aa3YTGaxOqHRwmDe3hyHgeqXg3Ry40q7fybVeM+ZKGViHSu/qB
	 XfEDUS4VjoK0oJ3CEPC9HCH5QjMcA+yEyv+fZT29VxabNxWwbr/rehUw3+1IbuVUXafgx
	 /sAmsu6amoVn9vdK1hqEyM1wQeA1S164TYZGFU8yGXq9NToq4vGb9UoEykwrTbyMUpZJA
	 oV1AtwpmzxLHdWZo8UB006mndAp8dnChK/J7qWpstMG6m34qKuDtNT9ArjUasRyuRaw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0BDokFpH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F58B606B2E0;
	Fri, 13 Nov 2026 16:00:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0BDokFpH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B8EB1F000C4;
	Fri, 13 Nov 2026 16:00:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585654;
	bh=mCTNVIueeE+yVLVClk6TjB3nMrZ4m8lv3C6X7luKJcg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0BDokFpH6HhI1r5DtyhtPXzQpFRrRmwgZSd1uAoDhutULIqzRnvB7Zo+dkzirzfr5
	 TsPFK3dHNJKWZrBNHPLhNwXwSBvAlN5Po5O2/6RMYZS5uHz1ArKDVI62WA/5vSR/UO
	 h4GyYRt80OXx/d6Tx6o2LmihBmYffXVKA1jHbuhc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luca Ceresoli <luca.ceresoli@bootlin.com>,
	Esben Haabendal <esben@geanix.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 269/507] drm/bridge: nwl-dsi: Cleanup endpoint mux control selection
Date: Fri, 13 Nov 2026 10:49:33 -0500
Message-ID: <20261113153803.768854746@linuxfoundation.org>
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
index 09992529f3d85..80e26a947ae69 100644
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



