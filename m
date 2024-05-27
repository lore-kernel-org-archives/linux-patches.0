Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA8B51607A5;
	Mon, 27 May 2024 19:12:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716837150; cv=none; b=Q+sirnXJmNeSqB3yHnPATt3HNtOEr0EcIRtE4i0z8KjylosTy+GnCqLXlEdKxAq1p6fwRA3+6rc1tQ6E9hEjD9De++Se1qWNdTjvC+atS/gfZM//Bu6LZGD7yROW9m5EDYj2yK0jWEE4xztCz37rv8LTdwoWdV5p1oogGRTxa8c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716837150; c=relaxed/simple;
	bh=kd04hnsHc+uSFp7/4tpTw+P1iVLsG/8GoR2Objh8W2k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Hg8D14v1unIRy3202iauEHakZxoCvYcEegvp/9dYNAC//ygbiRFUiQllMuOgQcWv1aRI0XwpE6HSJ2Oh+DWFRwv+6tzyBY+DAFpmNxWZ7e9l1BQVLIdHhLd6NBYbPoP55QkIUg6LHjTMaf4PXko0YcEuPQABDsKSzWJrlNpPOZc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZRDQ/p9i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZRDQ/p9i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 810F6C32789;
	Mon, 27 May 2024 19:12:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716837149;
	bh=kd04hnsHc+uSFp7/4tpTw+P1iVLsG/8GoR2Objh8W2k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZRDQ/p9ilGz7OEPDvIy5XR5+fra+kzDaEtZeTPmm/dviRMT6+iMSZPGeoKFbB5Ywx
	 3/vnSgJjJybslk47DwyEv1zdcu7FhdOzhSty9jxs4weeDf9Mqi4J2JIThD3vBh8Hv6
	 sB1HWJHUMzUT3Glh8LYv6FzgXs328v5EUozuEOmQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	"=?UTF-8?q?N=C3=ADcolas=20F . =20R . =20A . =20Prado?=" <nfraprado@collabora.com>,
	Robert Foss <rfoss@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 330/427] drm/bridge: anx7625: Dont log an error when DSI host cant be found
Date: Mon, 27 May 2024 20:56:17 +0200
Message-ID: <20240527185632.188393417@linuxfoundation.org>
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

[ Upstream commit ef4a9204d594fe959cdbc7418273caf4001535c8 ]

Given that failing to find a DSI host causes the driver to defer probe,
make use of dev_err_probe() to log the reason. This makes the defer
probe reason available and avoids alerting userspace about something
that is not necessarily an error.

Fixes: 269332997a16 ("drm/bridge: anx7625: Return -EPROBE_DEFER if the dsi host was not found")
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Reviewed-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Signed-off-by: Nícolas F. R. A. Prado <nfraprado@collabora.com>
Signed-off-by: Robert Foss <rfoss@kernel.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20240415-anx7625-defer-log-no-dsi-host-v3-1-619a28148e5c@collabora.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/analogix/anx7625.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/bridge/analogix/anx7625.c b/drivers/gpu/drm/bridge/analogix/anx7625.c
index 9d96d28d6fe8e..02bf450053076 100644
--- a/drivers/gpu/drm/bridge/analogix/anx7625.c
+++ b/drivers/gpu/drm/bridge/analogix/anx7625.c
@@ -2066,10 +2066,8 @@ static int anx7625_setup_dsi_device(struct anx7625_data *ctx)
 	};
 
 	host = of_find_mipi_dsi_host_by_node(ctx->pdata.mipi_host_node);
-	if (!host) {
-		DRM_DEV_ERROR(dev, "fail to find dsi host.\n");
-		return -EPROBE_DEFER;
-	}
+	if (!host)
+		return dev_err_probe(dev, -EPROBE_DEFER, "fail to find dsi host.\n");
 
 	dsi = devm_mipi_dsi_device_register_full(dev, host, &info);
 	if (IS_ERR(dsi)) {
-- 
2.43.0



