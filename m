Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D37E3196DAB;
	Thu,  6 Jun 2024 14:16:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683379; cv=none; b=W/OZk7HMClYIHhGSeDmeWcoe7UoC8Dwy2U/lrKM9CT9FraHdak9hFTpfFo9F3dPcxGvhOHqG1qBMe+dsVWJANhADf24wYAJ5b6kDU5MKEd+ywJrNa5IOztLAc8SmXPOmzMbPiYG5afkwH1PLMKhAYHx6R3s62UVVyNDklQb1/DI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683379; c=relaxed/simple;
	bh=qjJXVShm7U9x1e3fMdisAtaMAWSjoAsvKGk4vIRmeCs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TKGdyX9DUxmaJIHm/sa3swe2WftUaypc3FzwYmzcNEuHZrdpr/IgSX6+7eDDXnav/8I74qsIjTOlfbY9s45u+iGgniwQlb0y7BczGevroHxGQAx5kKot05ongqxjug6GucnFNbW1MWS4ayUZef3E0nq406JiKzFncTS9gG3zfHU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KneBD/nn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KneBD/nn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2722C32781;
	Thu,  6 Jun 2024 14:16:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683379;
	bh=qjJXVShm7U9x1e3fMdisAtaMAWSjoAsvKGk4vIRmeCs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KneBD/nn+uOXow6bfMUb/noYF2qQr2KlqjwwsBExOCoHS+vQnC7KVAYEqdA2L9biO
	 O41KFdJ0pDXfktEx3GeBQ9qBVRw1NPyQRb+ztVA99PgodNm+MpNecJR7HxaNkVCVtE
	 DcMy2aKQPjKQ9rNzbkDD4GrNLUyNPyn8vaqygwKQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	"=?UTF-8?q?N=C3=ADcolas=20F . =20R . =20A . =20Prado?=" <nfraprado@collabora.com>,
	Robert Foss <rfoss@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 321/744] drm/bridge: lt8912b: Dont log an error when DSI host cant be found
Date: Thu,  6 Jun 2024 15:59:53 +0200
Message-ID: <20240606131742.735046007@linuxfoundation.org>
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

[ Upstream commit b3b4695ff47c4964d4ccb930890c9ffd8e455e20 ]

Given that failing to find a DSI host causes the driver to defer probe,
make use of dev_err_probe() to log the reason. This makes the defer
probe reason available and avoids alerting userspace about something
that is not necessarily an error.

Fixes: 30e2ae943c26 ("drm/bridge: Introduce LT8912B DSI to HDMI bridge")
Suggested-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Reviewed-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Signed-off-by: Nícolas F. R. A. Prado <nfraprado@collabora.com>
Signed-off-by: Robert Foss <rfoss@kernel.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20240415-anx7625-defer-log-no-dsi-host-v3-3-619a28148e5c@collabora.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/lontium-lt8912b.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/bridge/lontium-lt8912b.c b/drivers/gpu/drm/bridge/lontium-lt8912b.c
index e5839c89a355a..0efcbc73f2a43 100644
--- a/drivers/gpu/drm/bridge/lontium-lt8912b.c
+++ b/drivers/gpu/drm/bridge/lontium-lt8912b.c
@@ -483,10 +483,8 @@ static int lt8912_attach_dsi(struct lt8912 *lt)
 						 };
 
 	host = of_find_mipi_dsi_host_by_node(lt->host_node);
-	if (!host) {
-		dev_err(dev, "failed to find dsi host\n");
-		return -EPROBE_DEFER;
-	}
+	if (!host)
+		return dev_err_probe(dev, -EPROBE_DEFER, "failed to find dsi host\n");
 
 	dsi = devm_mipi_dsi_device_register_full(dev, host, &info);
 	if (IS_ERR(dsi)) {
-- 
2.43.0



