Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1899217727;
	Mon, 27 May 2024 19:34:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716838468; cv=none; b=i1C6dmrAQGZ3+t2VNetxcjFjUzC+1r6YV2nk785VIBQU2ApQUIdlLLSLI2GsbCqvFHx2tUcUkzBJwvfyoqQN72VUu+kwCBVQt2ESAutzqxtHrM64uauaXW3odKpzHtfO11B7n2xtts7q8Dz5b6s10V+QEQ0E9cB/ag+alBEiYms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716838468; c=relaxed/simple;
	bh=NnrpeJKnMJ8S6OJ7YHX04QMMDI2nNs/l8s1KqiaeFqY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jbuPnDM+Qu9CPNYsuBFqjB2EM8mbYxT6El10degnPefwLgyXI37WXFg2tWFViojaU+RxfiRUFFbIjHQT+JsBooMXocJ2xw8CuLvdqao3PYEvcDWHJXePP1YWhCCc5wtkg4FpiswnqWhWlyPSQoVpxWQTqk75bHVH2hr6EpDaWYU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tORUpDyw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tORUpDyw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6906EC2BBFC;
	Mon, 27 May 2024 19:34:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716838467;
	bh=NnrpeJKnMJ8S6OJ7YHX04QMMDI2nNs/l8s1KqiaeFqY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tORUpDywGZ3diRN9JCGn35GsSSPs9RocXh0EgAE2wX3YQpnAyQrm7u7GBy6i2mrtV
	 G8Jnyk4tf1/PDeijOlr4vBz49/ZzDiL6AMx0uaydOTZPTiWXvTFp8EyGdYG8PG/oWn
	 dB+OjbwuBIqWPs59Sb50V1q933HAgC31PamI6/G4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	"=?UTF-8?q?N=C3=ADcolas=20F . =20R . =20A . =20Prado?=" <nfraprado@collabora.com>,
	Robert Foss <rfoss@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 405/493] drm/bridge: icn6211: Dont log an error when DSI host cant be found
Date: Mon, 27 May 2024 20:56:47 +0200
Message-ID: <20240527185643.534345869@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185626.546110716@linuxfoundation.org>
References: <20240527185626.546110716@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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



