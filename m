Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24BF7145B2C;
	Thu, 13 Jun 2024 12:16:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718281004; cv=none; b=aMqOWHB5Z8yB9bqZwQwWPn3HUV2EF1obSF3Qy+cc6CiYiS+syWE1MGnvhrE1qoAv9bszzWjFBMa+P6yLr2Se84IOd0n5/xupWg6bocWvBdtYR+8TyrjSfYhK4jibhtNxQ1ob0LbAYe/93/qFHej7o6Bh5ECjb/xMsgi4oT4GdmM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718281004; c=relaxed/simple;
	bh=pnOdQHvodkrlH+1fyouVYemxIMuNt4yfhj1BLrAdgds=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qB4yJI7w4E1ZR1nidWdWcC+yGAj04GvjRsjfFlxAJVvc7hpInpyDRSPQYrxEPjIlblVo2PzsAjqD0St8Oy+fiTpbQjWi60NxO4WssIxjH7mWm19kCz9uzVqiEEVOHmQtLffBgPxwvpH8XHBZP/FWnunmYtAKrd+0IbDWuQ4vRv0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z9ZNx+gx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z9ZNx+gx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45E24C2BBFC;
	Thu, 13 Jun 2024 12:16:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718281003;
	bh=pnOdQHvodkrlH+1fyouVYemxIMuNt4yfhj1BLrAdgds=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z9ZNx+gxa9wCxfTHW6PMx6rU0aR4p5cqwSM4Q6PvkXglCz488N7N1mMIBpDsRmwy7
	 slT4aMp6GyWYkNrooj5dwXMFzpAygEAY/8csdOezGnyzR+8nbpyTTNiskkcct/VLtz
	 IGP8eDwyQGzQORsKUG2x+c7nOzhcljIXCNL0RwPY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	"=?UTF-8?q?N=C3=ADcolas=20F . =20R . =20A . =20Prado?=" <nfraprado@collabora.com>,
	Robert Foss <rfoss@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 108/317] drm/bridge: tc358775: Dont log an error when DSI host cant be found
Date: Thu, 13 Jun 2024 13:32:06 +0200
Message-ID: <20240613113251.728476123@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113247.525431100@linuxfoundation.org>
References: <20240613113247.525431100@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nícolas F. R. A. Prado <nfraprado@collabora.com>

[ Upstream commit 272377aa0e3dddeec3f568c8bb9d12c7a79d8ef5 ]

Given that failing to find a DSI host causes the driver to defer probe,
make use of dev_err_probe() to log the reason. This makes the defer
probe reason available and avoids alerting userspace about something
that is not necessarily an error.

Fixes: b26975593b17 ("display/drm/bridge: TC358775 DSI/LVDS driver")
Suggested-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Reviewed-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Signed-off-by: Nícolas F. R. A. Prado <nfraprado@collabora.com>
Signed-off-by: Robert Foss <rfoss@kernel.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20240415-anx7625-defer-log-no-dsi-host-v3-6-619a28148e5c@collabora.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/tc358775.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/bridge/tc358775.c b/drivers/gpu/drm/bridge/tc358775.c
index 2272adcc5b4ad..55697fa4d7c8b 100644
--- a/drivers/gpu/drm/bridge/tc358775.c
+++ b/drivers/gpu/drm/bridge/tc358775.c
@@ -605,10 +605,8 @@ static int tc_bridge_attach(struct drm_bridge *bridge,
 						};
 
 	host = of_find_mipi_dsi_host_by_node(tc->host_node);
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



