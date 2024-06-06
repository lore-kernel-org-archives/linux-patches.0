Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E920196C6F;
	Thu,  6 Jun 2024 14:16:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683384; cv=none; b=TYmwWjmWvT5YqVe8ddlcz7W6apKn8ZypG5GH2uNIPplgOKRXE1O8f9EoixwVX6+fd/iy1qp5957svPtactcRPJbxAo7SPwfoROdi/J4bWxd6Y8288Dcvr9h/ibT1C3JtWwyVD/j8wUQ+XTL3UlMbqKfRwXuLXPCejoRzb7rQISQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683384; c=relaxed/simple;
	bh=X0tn2SAI2rZovVk3vHtxee2mn4ZztOxkSxnCtZzRHU8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hhbRZ6IULVFoCIBknMeh3mSMxZFZ2Hsn7vwVwTlQMCeJ67XMZjCM5eCCGcYzQ0EiETuh2yXzzt285T76sx1S2IGlVxu34UfylIU4uml0E29Cy98X1m2aH0qSL+nRAbpd0JAzzCV2l48WyuWHNIMhKgjvX/IOMoxup41K2P52P2c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=USPZs8MM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="USPZs8MM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C098C2BD10;
	Thu,  6 Jun 2024 14:16:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683384;
	bh=X0tn2SAI2rZovVk3vHtxee2mn4ZztOxkSxnCtZzRHU8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=USPZs8MM2yAF+oB0PQqPPD9+SY+Whf+8zcRVV4PedxUr1ScQHLasJKbwNqfS6VPn9
	 DfF8N1rzIGN988mvByJG2nSTDZmwwHkPjQsobonudrsBEGveJddzly/ZvIB4JEdeml
	 9ipXA9IIx7SJ4+Ay9XKDJ5DC5tQ7SQtzSbt3Ubi0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	"=?UTF-8?q?N=C3=ADcolas=20F . =20R . =20A . =20Prado?=" <nfraprado@collabora.com>,
	Robert Foss <rfoss@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 325/744] drm/bridge: dpc3433: Dont log an error when DSI host cant be found
Date: Thu,  6 Jun 2024 15:59:57 +0200
Message-ID: <20240606131742.862214078@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nícolas F. R. A. Prado <nfraprado@collabora.com>

[ Upstream commit 24f4f575214de776539d346b99b8717bffa8ebba ]

Given that failing to find a DSI host causes the driver to defer probe,
make use of dev_err_probe() to log the reason. This makes the defer
probe reason available and avoids alerting userspace about something
that is not necessarily an error.

Also move the "failed to attach" error message so that it's only printed
when the devm_mipi_dsi_attach() call fails.

Fixes: 6352cd451ddb ("drm: bridge: Add TI DLPC3433 DSI to DMD bridge")
Suggested-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Reviewed-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Signed-off-by: Nícolas F. R. A. Prado <nfraprado@collabora.com>
Signed-off-by: Robert Foss <rfoss@kernel.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20240415-anx7625-defer-log-no-dsi-host-v3-7-619a28148e5c@collabora.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/ti-dlpc3433.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/gpu/drm/bridge/ti-dlpc3433.c b/drivers/gpu/drm/bridge/ti-dlpc3433.c
index b65632ec7e7da..3f933ba294682 100644
--- a/drivers/gpu/drm/bridge/ti-dlpc3433.c
+++ b/drivers/gpu/drm/bridge/ti-dlpc3433.c
@@ -319,12 +319,11 @@ static int dlpc_host_attach(struct dlpc *dlpc)
 		.channel = 0,
 		.node = NULL,
 	};
+	int ret;
 
 	host = of_find_mipi_dsi_host_by_node(dlpc->host_node);
-	if (!host) {
-		DRM_DEV_ERROR(dev, "failed to find dsi host\n");
-		return -EPROBE_DEFER;
-	}
+	if (!host)
+		return dev_err_probe(dev, -EPROBE_DEFER, "failed to find dsi host\n");
 
 	dlpc->dsi = mipi_dsi_device_register_full(host, &info);
 	if (IS_ERR(dlpc->dsi)) {
@@ -336,7 +335,11 @@ static int dlpc_host_attach(struct dlpc *dlpc)
 	dlpc->dsi->format = MIPI_DSI_FMT_RGB565;
 	dlpc->dsi->lanes = dlpc->dsi_lanes;
 
-	return devm_mipi_dsi_attach(dev, dlpc->dsi);
+	ret = devm_mipi_dsi_attach(dev, dlpc->dsi);
+	if (ret)
+		DRM_DEV_ERROR(dev, "failed to attach dsi host\n");
+
+	return ret;
 }
 
 static int dlpc3433_probe(struct i2c_client *client)
@@ -367,10 +370,8 @@ static int dlpc3433_probe(struct i2c_client *client)
 	drm_bridge_add(&dlpc->bridge);
 
 	ret = dlpc_host_attach(dlpc);
-	if (ret) {
-		DRM_DEV_ERROR(dev, "failed to attach dsi host\n");
+	if (ret)
 		goto err_remove_bridge;
-	}
 
 	return 0;
 
-- 
2.43.0



