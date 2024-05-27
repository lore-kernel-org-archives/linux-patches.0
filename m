Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 166D617727;
	Mon, 27 May 2024 19:34:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716838483; cv=none; b=Idd3VZ6RmZUMT5FzLiqy+ZgPcDBEnZUP6LI0P5zOPsXNOEZozIDTXMRGNZNNoSyPQCUsYs3u1dBp9m7DmoGhbikPQ7wKDarQiN1XurCa2lODcXDYlGTOEjc1S8+fHr/1eq9rEAWN2f6tFSHlCZ1AS1t379keHf/93P1QWluE+hA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716838483; c=relaxed/simple;
	bh=lL4SfcHlW2BCkb5h3jBkJNNQjji9wo+uUOq/S6ldrxQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=p62gQBxSwYmomIkBW4zRunxxrQXX8Qfj73DHXY3bYY6cMWxnlxlr9cgVcDNaGKn6Nm9fu9/QB10ptsejtBWR5a2NpehdCTbU3Ywvm88dRJwaVIyXcf+ZArpGLrlpMc0a9eCJsuyYbcftwttiK6r01hcKjceS52G5ROq78JOSYRE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=euVfisvu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="euVfisvu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94B80C2BBFC;
	Mon, 27 May 2024 19:34:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716838482;
	bh=lL4SfcHlW2BCkb5h3jBkJNNQjji9wo+uUOq/S6ldrxQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=euVfisvu2Dqll9U9Qg439iYbZR627W4/rE3K5JbWFN8QiR9hodAIftZ2yL8SR1nvn
	 OUww3n0y12yfQ76an4p4+caM9s6tQnijDgbedyKFVUHeVE63wVwcGuO5+JFthxM0i0
	 bKkIFSqEzm4dIipt9mxjcGzF5gJwbk5jXo+j3ioY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	"=?UTF-8?q?N=C3=ADcolas=20F . =20R . =20A . =20Prado?=" <nfraprado@collabora.com>,
	Robert Foss <rfoss@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 411/493] drm/panel: novatek-nt35950: Dont log an error when DSI host cant be found
Date: Mon, 27 May 2024 20:56:53 +0200
Message-ID: <20240527185643.737505391@linuxfoundation.org>
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

[ Upstream commit 5ff5505b9a2d827cae3f95dceba258c963138175 ]

Given that failing to find a DSI host causes the driver to defer probe,
make use of dev_err_probe() to log the reason. This makes the defer
probe reason available and avoids alerting userspace about something
that is not necessarily an error.

Fixes: 623a3531e9cf ("drm/panel: Add driver for Novatek NT35950 DSI DriverIC panels")
Suggested-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Reviewed-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Signed-off-by: Nícolas F. R. A. Prado <nfraprado@collabora.com>
Signed-off-by: Robert Foss <rfoss@kernel.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20240415-anx7625-defer-log-no-dsi-host-v3-8-619a28148e5c@collabora.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panel/panel-novatek-nt35950.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/panel/panel-novatek-nt35950.c b/drivers/gpu/drm/panel/panel-novatek-nt35950.c
index 648ce92014265..028fdac293f77 100644
--- a/drivers/gpu/drm/panel/panel-novatek-nt35950.c
+++ b/drivers/gpu/drm/panel/panel-novatek-nt35950.c
@@ -556,10 +556,8 @@ static int nt35950_probe(struct mipi_dsi_device *dsi)
 		}
 		dsi_r_host = of_find_mipi_dsi_host_by_node(dsi_r);
 		of_node_put(dsi_r);
-		if (!dsi_r_host) {
-			dev_err(dev, "Cannot get secondary DSI host\n");
-			return -EPROBE_DEFER;
-		}
+		if (!dsi_r_host)
+			return dev_err_probe(dev, -EPROBE_DEFER, "Cannot get secondary DSI host\n");
 
 		nt->dsi[1] = mipi_dsi_device_register_full(dsi_r_host, info);
 		if (!nt->dsi[1]) {
-- 
2.43.0



