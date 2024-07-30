Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65CA717D8BB;
	Tue, 30 Jul 2024 16:47:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722358059; cv=none; b=BUffc951nxzR7oFZ/Lr/392jzP/yYs/hWsYr+GA4u6+uTafrl06VL93bVC6neTiyr0+IzZ37fKtIGPd6NArRnw5FdDakRXN7wAJJWDW3pF7DxB2Y8BPeL4oYu4ZTKUuAdNiklTtESIHv/V42rKnZz3O9V5qbG2PcamNhaT+cT0g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722358059; c=relaxed/simple;
	bh=lYozzUB9GJ2ADJxHTJelyRo8HPCOqEXmiHhDGx42HP0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JeN77cPnImEKq2elycnqcrCHuJqGBiqxM7j357UAeBnssgSygOlNBIi2u9SGtBzQ+bHDTkr5mFfp+PyjW9qXZscDV9qKyuP0whRIvkapyhj7I1Nra7FkxsaQ+FX/LdDOCCHGqbTrU7vumK76LiQrXhb6Ky6AIjXIQdSJYT3sNPs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xGM1LlvW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xGM1LlvW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBA67C4AF0C;
	Tue, 30 Jul 2024 16:47:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722358059;
	bh=lYozzUB9GJ2ADJxHTJelyRo8HPCOqEXmiHhDGx42HP0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xGM1LlvWcGCg+JxVQJY0QJjpLOvRNEujy+2mkjjbYRdI1Otiwj+NE9K9zFOXWHw7L
	 t2/CC5Rkp/gWpbMoe4K+J61K2eMdkS5XmLlqbF/JulKNWOWKKIJk7yt1sRyIB7p9n4
	 HzDydbmPfyh46bhsTcFvUYGEldmCFl/Zprfx5+B8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jacopo Mondi <jacopo.mondi@ideasonboard.com>,
	Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	=?UTF-8?q?Niklas=20S=C3=B6derlund?= <niklas.soderlund+renesas@ragnatech.se>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 319/809] media: rcar-csi2: Disable runtime_pm in probe error
Date: Tue, 30 Jul 2024 17:43:15 +0200
Message-ID: <20240730151737.203705679@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jacopo Mondi <jacopo.mondi@ideasonboard.com>

[ Upstream commit e306183628f7c2e95f9bf853d8fcb86288f606de ]

Disable pm_runtime in the probe() function error path.

Fixes: 769afd212b16 ("media: rcar-csi2: add Renesas R-Car MIPI CSI-2 receiver driver")
Signed-off-by: Jacopo Mondi <jacopo.mondi@ideasonboard.com>
Reviewed-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Reviewed-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
Tested-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
Link: https://lore.kernel.org/r/20240617161135.130719-3-jacopo.mondi@ideasonboard.com
Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/renesas/rcar-csi2.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/renesas/rcar-csi2.c b/drivers/media/platform/renesas/rcar-csi2.c
index 582d5e35db0e5..249e58c771761 100644
--- a/drivers/media/platform/renesas/rcar-csi2.c
+++ b/drivers/media/platform/renesas/rcar-csi2.c
@@ -1914,12 +1914,14 @@ static int rcsi2_probe(struct platform_device *pdev)
 
 	ret = v4l2_async_register_subdev(&priv->subdev);
 	if (ret < 0)
-		goto error_async;
+		goto error_pm_runtime;
 
 	dev_info(priv->dev, "%d lanes found\n", priv->lanes);
 
 	return 0;
 
+error_pm_runtime:
+	pm_runtime_disable(&pdev->dev);
 error_async:
 	v4l2_async_nf_unregister(&priv->notifier);
 	v4l2_async_nf_cleanup(&priv->notifier);
-- 
2.43.0



