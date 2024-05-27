Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DC3A17E90E;
	Mon, 27 May 2024 19:12:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716837152; cv=none; b=TCS5Dj6SzdVS/IEUL5fgB0z3v9+B3ku2uTVR6qM7GSekSmQv6M8+KMqBKFLZfMg47NogjSm7kQltnR666x66Yos/SkTB+Yh73k6+A7IpMx37A7Lv0wR67qmfuvSDClR8358V+xamUqfnX+Q2Ws02hXTX+KCz6tDOuOiRYdjyWkQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716837152; c=relaxed/simple;
	bh=46CwIsBC26I1DRsuEAZJEjJVUpujsHpQZVFtw3d32DU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EBBhsD6b6tnjeuWcm25qfl81uiFSgjMj4nGEPwfxonvhTD2L8vAftgcPAYkbznp2D0/iWugRm4cMlFwgUbQl1E5AdLE3yEfrVSwYWTdM1s88RYg5IkiNA5qNbP6Tz4W+5buohVzI3E7JPsH82ZRp9fDw5G+pU6MCscrq7AlMzcs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v9DtJw4D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v9DtJw4D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 074A6C2BBFC;
	Mon, 27 May 2024 19:12:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716837152;
	bh=46CwIsBC26I1DRsuEAZJEjJVUpujsHpQZVFtw3d32DU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v9DtJw4DaL+OJrbxwXV5ZyDjARxLRERzqSKbxWxVLUv3Xcpn2QGlE0ADcZi5qAoN6
	 kMf0P4akawRYVm8FotrrltvZ6BFzXJ+Cdo+vBGTGRtZp/xBTFl/tJxQgnVniU2rPqf
	 pqtMzHMR+7m+Bu+FtocVACSThkbV5v81oPJeFAqo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	"=?UTF-8?q?N=C3=ADcolas=20F . =20R . =20A . =20Prado?=" <nfraprado@collabora.com>,
	Robert Foss <rfoss@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 331/427] drm/bridge: icn6211: Dont log an error when DSI host cant be found
Date: Mon, 27 May 2024 20:56:18 +0200
Message-ID: <20240527185632.249728831@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185601.713589927@linuxfoundation.org>
References: <20240527185601.713589927@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nícolas F. R. A. Prado <nfraprado@collabora.com>

[ Upstream commit 275fafe58faa7fdb10fa245412696ecef676aac5 ]

Given that failing to find a DSI host causes the driver to defer probe,
make use of dev_err_probe() to log the reason. This makes the defer
probe reason available and avoids alerting userspace about something
that is not necessarily an error.

Fixes: 8dde6f7452a1 ("drm: bridge: icn6211: Add I2C configuration support")
Suggested-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Reviewed-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Signed-off-by: Nícolas F. R. A. Prado <nfraprado@collabora.com>
Signed-off-by: Robert Foss <rfoss@kernel.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20240415-anx7625-defer-log-no-dsi-host-v3-2-619a28148e5c@collabora.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/chipone-icn6211.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/bridge/chipone-icn6211.c b/drivers/gpu/drm/bridge/chipone-icn6211.c
index 82d23e4df09eb..ff3284b6b1a37 100644
--- a/drivers/gpu/drm/bridge/chipone-icn6211.c
+++ b/drivers/gpu/drm/bridge/chipone-icn6211.c
@@ -563,10 +563,8 @@ static int chipone_dsi_host_attach(struct chipone *icn)
 
 	host = of_find_mipi_dsi_host_by_node(host_node);
 	of_node_put(host_node);
-	if (!host) {
-		dev_err(dev, "failed to find dsi host\n");
-		return -EPROBE_DEFER;
-	}
+	if (!host)
+		return dev_err_probe(dev, -EPROBE_DEFER, "failed to find dsi host\n");
 
 	dsi = mipi_dsi_device_register_full(host, &info);
 	if (IS_ERR(dsi)) {
-- 
2.43.0



