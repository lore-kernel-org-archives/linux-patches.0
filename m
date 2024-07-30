Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF1DE155CB3;
	Tue, 30 Jul 2024 16:47:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722358069; cv=none; b=Iuk80Vva0OiRM0epQtU0yWaDkf88FGM/BHrwnVXvALIRcpsAMfE9zDXNp6oDLNGnzQ724IaAAGytad221JEReVetpAaGQACMsaHAfEfl+TxzvPG9yCbL1tVncEKnModJupNqnQ/cE0MTKnLCMMsbGrxqN5r/y1miyjwtyAVgTxI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722358069; c=relaxed/simple;
	bh=yWLsWTeL7s3VQZ1m2DO2LUdG96sT3A03bdPsbgcb5TU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dwaxCESkltnls84vzjQrUTryTISKlllf5J+SbV0SGcLRArYIy7v6SXWAz4hOK8ApN6LIhbOW/XHDJnQ/LXNpVSnZgiwOnwnz3o7W4ndJAEV9ULb1BDQuHeuaObDutP7yaoccuGEVl/DKkJY0v8PEcLrfyOp+6YvDG3zVzitw9OM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d5yES2/t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d5yES2/t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69741C32782;
	Tue, 30 Jul 2024 16:47:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722358068;
	bh=yWLsWTeL7s3VQZ1m2DO2LUdG96sT3A03bdPsbgcb5TU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d5yES2/tQwkpBMjgYpcTTfCyF/jK6KiMN9k3/mW6rq8zpfiv9lbpoj/bNCmvwZd82
	 R+i/fDoggZmGm+cuUQQ6719ckMLvVHpRivuUb5SbAEJO+zcTxR1ZuEXY06XeMhLDCk
	 +b5KiSmlnxBszCza651NpnjYklfyytGoD5cwIHH0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jacopo Mondi <jacopo.mondi@ideasonboard.com>,
	Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	=?UTF-8?q?Niklas=20S=C3=B6derlund?= <niklas.soderlund+renesas@ragnatech.se>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 320/809] media: rcar-csi2: Cleanup subdevice in remove()
Date: Tue, 30 Jul 2024 17:43:16 +0200
Message-ID: <20240730151737.244583886@linuxfoundation.org>
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

[ Upstream commit f6d64d0d2897ed4e85ac00afe43e45c8b8fc0c44 ]

Cleanup the V4L2 subdevice in the driver's remove function to
ensure its async connection are freed, and guarantee in future that
the subdev active state is cleaned up.

Fixes: 769afd212b16 ("media: rcar-csi2: add Renesas R-Car MIPI CSI-2 receiver driver")
Signed-off-by: Jacopo Mondi <jacopo.mondi@ideasonboard.com>
Reviewed-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Reviewed-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
Tested-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
Link: https://lore.kernel.org/r/20240617161135.130719-4-jacopo.mondi@ideasonboard.com
Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/renesas/rcar-csi2.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/platform/renesas/rcar-csi2.c b/drivers/media/platform/renesas/rcar-csi2.c
index 249e58c771761..2d464e43a5be8 100644
--- a/drivers/media/platform/renesas/rcar-csi2.c
+++ b/drivers/media/platform/renesas/rcar-csi2.c
@@ -1938,6 +1938,7 @@ static void rcsi2_remove(struct platform_device *pdev)
 	v4l2_async_nf_unregister(&priv->notifier);
 	v4l2_async_nf_cleanup(&priv->notifier);
 	v4l2_async_unregister_subdev(&priv->subdev);
+	v4l2_subdev_cleanup(&priv->subdev);
 
 	pm_runtime_disable(&pdev->dev);
 
-- 
2.43.0



