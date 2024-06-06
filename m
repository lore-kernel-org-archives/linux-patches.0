Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3035196DAB;
	Thu,  6 Jun 2024 14:16:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683378; cv=none; b=KQ97q80aDDYZnkoGG5kSZ4qwaFwxudLec9h6i531TsD40EGbLxH0XD2iBmLWNHSq2QX1CRuKaWa9+XZLWJEMFLzwEpCInme9EyQRAfNeohlLRW3I9fG76pyxFs13hqA2p8+DSEAy8uMlNO8pxfQSQaK9QpgMWtwjSg8jMIaC1Is=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683378; c=relaxed/simple;
	bh=YGPwQTWgWWj+EtqQm8GNUOd4i2s+ejBPfIEvtkbuDBw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bFCQQN+M0sz/khJ0hwehu8PfLe0iU0Z4PNxCMTJbcTYgc5ksk7EOU/w5WHY254lUxEp8DIC4eLZx8a8lBrHbgwO+DKqJ2GLzjCA/tXiJGc3uilm4W+ETQ8g3hrLYq2iPm9UuWRGP6C1iM4+ImTqKi1TAnEBtMEhLduUYzAbtkGI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=omtFO5kP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="omtFO5kP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2123C2BD10;
	Thu,  6 Jun 2024 14:16:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683378;
	bh=YGPwQTWgWWj+EtqQm8GNUOd4i2s+ejBPfIEvtkbuDBw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=omtFO5kP34LxXvDWSdiIjarjiAVMvi8hiIA7aRpUK7V7xk07Zw3OWHBcpxL+uuusj
	 L5PFidLlr2FTiSnzuOQHYhjoOp7nM9AkJSB5TtlsBrbOuBSY/c5pJEMssrFA9CaE8q
	 rkpr61y2wQLMIj4Qu1/rSN2KmVEt4JHWvYYrnvT4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	"=?UTF-8?q?N=C3=ADcolas=20F . =20R . =20A . =20Prado?=" <nfraprado@collabora.com>,
	Robert Foss <rfoss@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 320/744] drm/bridge: icn6211: Dont log an error when DSI host cant be found
Date: Thu,  6 Jun 2024 15:59:52 +0200
Message-ID: <20240606131742.694823883@linuxfoundation.org>
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
index d205e755e524a..5e295f86f2a73 100644
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



