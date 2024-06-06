Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37C9E1B1434;
	Thu,  6 Jun 2024 14:16:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683382; cv=none; b=YoJDyEdjFUaY07auYKpj908JaOFy9xp4e7TMdA9UpwC+Uk/g/Qmop3xDNyXziwkVuxTFtkxjWN+sVvtCfs4eJmRLYNh64ERYFbOwZn6HvkGsW/c9AALRmK7psuNz3WZqbwClJatnisvzPMaNFp0vy+btO70Li5B0AwuOI7oqZ/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683382; c=relaxed/simple;
	bh=pxJwpigC2SbfSlvGEgsEqAFMl6YIuu4WAUHffdgi+JU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=R6yXk4R2Ppyz8yqz2lYEt1cHJQ2gTMS/WK2FNbDtx84agRL7beTTsM2qT9EIN4YVaJ8dvCydRmRMK4OKux0SpVrGIqJNrxzTrNPyRPlxXWVLukfOziFWsmWLQDzz/4Bub7pHV/fJGOgT9u4sX/KqJM5J1mKvl1zy288HvHNWuKA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=etScAy3N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="etScAy3N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16E52C2BD10;
	Thu,  6 Jun 2024 14:16:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683382;
	bh=pxJwpigC2SbfSlvGEgsEqAFMl6YIuu4WAUHffdgi+JU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=etScAy3N+/Rokn9SlfHGlxzP20E4VCxNyi6qX2KKJFApReAjeGxPJqovKEjWfi+g3
	 RJwm6FIU6E3YdyGHy62ai1OajwSFAEWhJ3KH5cQjgbR+JpvAwJmm7dGS34ElsyxQSb
	 ukMenqvHwli2IQGriJxKSERMn/w5ldFPJTXmekfw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	"=?UTF-8?q?N=C3=ADcolas=20F . =20R . =20A . =20Prado?=" <nfraprado@collabora.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Robert Foss <rfoss@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 323/744] drm/bridge: lt9611uxc: Dont log an error when DSI host cant be found
Date: Thu,  6 Jun 2024 15:59:55 +0200
Message-ID: <20240606131742.800764952@linuxfoundation.org>
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

[ Upstream commit 6d9e877cde7e9b516a9a99751b8222c87557436d ]

Given that failing to find a DSI host causes the driver to defer probe,
make use of dev_err_probe() to log the reason. This makes the defer
probe reason available and avoids alerting userspace about something
that is not necessarily an error.

Fixes: 0cbbd5b1a012 ("drm: bridge: add support for lontium LT9611UXC bridge")
Suggested-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Reviewed-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Signed-off-by: Nícolas F. R. A. Prado <nfraprado@collabora.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Robert Foss <rfoss@kernel.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20240415-anx7625-defer-log-no-dsi-host-v3-5-619a28148e5c@collabora.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/lontium-lt9611uxc.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/bridge/lontium-lt9611uxc.c b/drivers/gpu/drm/bridge/lontium-lt9611uxc.c
index 6f33bb0dd32aa..c41ffd0bc0494 100644
--- a/drivers/gpu/drm/bridge/lontium-lt9611uxc.c
+++ b/drivers/gpu/drm/bridge/lontium-lt9611uxc.c
@@ -265,10 +265,8 @@ static struct mipi_dsi_device *lt9611uxc_attach_dsi(struct lt9611uxc *lt9611uxc,
 	int ret;
 
 	host = of_find_mipi_dsi_host_by_node(dsi_node);
-	if (!host) {
-		dev_err(dev, "failed to find dsi host\n");
-		return ERR_PTR(-EPROBE_DEFER);
-	}
+	if (!host)
+		return ERR_PTR(dev_err_probe(dev, -EPROBE_DEFER, "failed to find dsi host\n"));
 
 	dsi = devm_mipi_dsi_device_register_full(dev, host, &info);
 	if (IS_ERR(dsi)) {
-- 
2.43.0



