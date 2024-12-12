Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 890A4243540;
	Thu, 12 Dec 2024 15:59:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734019165; cv=none; b=qUPB/4GLygiUvW7Yu+K3PHlxWP0rZelRrM87xkbOLVmqaBX1AKpXB7oh7Hv02764lKdAzSXvBTA1SzK3sdy3b4rZi+tFoVzjXUpZvf51HRBeZG79WZZ5RG7QvJG2QYmH03mbJUBkt57fvJ4M40y2GdOU0R8HM6LmPWJwJkI7t3I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734019165; c=relaxed/simple;
	bh=HHJzmbOvJu+uG9H+6yisiHtUKsO8y9q1nQyN7YgUupI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j0nb5m26IuyTkCk54H32jGqE4PJ7U90Kdn6Pd4WzaEdpzZ8yy7eRWuUS3XoqaXJ4r69SL6ZyDfViM/gfZfJRZrQBM20mhkUok65gek9Pqs9W400pcY8l8rz48v4fnTIqr+9I3lAWW3Jus0N4+HO4/8Ui35dFz8EP9kVwesnvLVw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Vrc+oTpA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Vrc+oTpA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DE75C4CECE;
	Thu, 12 Dec 2024 15:59:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734019165;
	bh=HHJzmbOvJu+uG9H+6yisiHtUKsO8y9q1nQyN7YgUupI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Vrc+oTpAh8G+wbCO/wE4qStPurVZwAeVfGaf2EHYGhI1sr3SHL/0qSg28BabbhWuB
	 zbRi+LFmwxHlWKi2FLMP9y3nyy8mGaX4uAWEPJJIPWdA45EoVkKbx9wh3qgRoDl0yx
	 UlSC8BzBsi+Qi4lzUzxTG5KZy8qr1M+TrnsrM2b0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	Laurentiu Palcu <laurentiu.palcu@oss.nxp.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 136/772] drm/imx/dcss: Use IRQF_NO_AUTOEN flag in request_irq()
Date: Thu, 12 Dec 2024 15:51:21 +0100
Message-ID: <20241212144355.557673280@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jinjie Ruan <ruanjinjie@huawei.com>

[ Upstream commit 1af01e14db7e0b45ae502d822776a58c86688763 ]

disable_irq() after request_irq() still has a time gap in which
interrupts can come. request_irq() with IRQF_NO_AUTOEN flag will
disable IRQ auto-enable when request IRQ.

Fixes: 9021c317b770 ("drm/imx: Add initial support for DCSS on iMX8MQ")
Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
Reviewed-by: Laurentiu Palcu <laurentiu.palcu@oss.nxp.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240912083020.3720233-2-ruanjinjie@huawei.com
[DB: fixed the subject]
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/imx/dcss/dcss-crtc.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/imx/dcss/dcss-crtc.c b/drivers/gpu/drm/imx/dcss/dcss-crtc.c
index 31267c00782fc..af91e45b5d13b 100644
--- a/drivers/gpu/drm/imx/dcss/dcss-crtc.c
+++ b/drivers/gpu/drm/imx/dcss/dcss-crtc.c
@@ -206,15 +206,13 @@ int dcss_crtc_init(struct dcss_crtc *crtc, struct drm_device *drm)
 	if (crtc->irq < 0)
 		return crtc->irq;
 
-	ret = request_irq(crtc->irq, dcss_crtc_irq_handler,
-			  0, "dcss_drm", crtc);
+	ret = request_irq(crtc->irq, dcss_crtc_irq_handler, IRQF_NO_AUTOEN,
+			  "dcss_drm", crtc);
 	if (ret) {
 		dev_err(dcss->dev, "irq request failed with %d.\n", ret);
 		return ret;
 	}
 
-	disable_irq(crtc->irq);
-
 	return 0;
 }
 
-- 
2.43.0



