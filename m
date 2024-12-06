Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A43591F8F13;
	Fri,  6 Dec 2024 14:57:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733497062; cv=none; b=ZdbFFqxxOp9+jBbvFqv3h0azKEAf/2aeb/VcPGq95SvelU9x+hl2aY/zZfWkDPxDpdPfQpm+3QgQoGba5nilXL63TOIB2Xj3um7M73DfFTEHIMgJkzyO3oDSqhgdZ6jMdcT5h7xR457GY9OXcmVQcsC2ggFbef7/xmSSMkttI6o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733497062; c=relaxed/simple;
	bh=OQM+jw3LnnFfRXMdG1aj0K3pPJ4F8xK881UfShb1+GY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=clg7NVyYWKBgcCRuIzJaHaWe8FcCMVWerLegqZjxXQh28s3FbXGlBmKYiMVEge8YE5PI0UkSn4Ld31/ZhOfKr0njJMJtDyD/qQIRYnhwH76vO6RzKHtBy+VUgBkXvX+pOjhs2VfvKPnxg9XhYTbrBZBVxYubHtT+3tUmX99VjTo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gGt0vVo7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gGt0vVo7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FE79C4CED1;
	Fri,  6 Dec 2024 14:57:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733497062;
	bh=OQM+jw3LnnFfRXMdG1aj0K3pPJ4F8xK881UfShb1+GY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gGt0vVo7eODBjg1LTw3NGHRDMjkLuOmeW3tUooZ2tV5twkAkVxSBCz92Kmf5UFuS6
	 Agh0dRUEooaNI/30hsu9MP1M9XY4EI9Jp7DnQ8b2e/cZCjnyA+2oNSlHQXbmIROvZ+
	 aCle4Tjn9cMT9zABLP0SrcRh/eipZfs0cXAto1ao=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 176/676] drm/imx/ipuv3: Use IRQF_NO_AUTOEN flag in request_irq()
Date: Fri,  6 Dec 2024 15:29:55 +0100
Message-ID: <20241206143700.222214545@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jinjie Ruan <ruanjinjie@huawei.com>

[ Upstream commit 40004709a3d3b07041a473a163ca911ef04ab8bd ]

disable_irq() after request_irq() still has a time gap in which
interrupts can come. request_irq() with IRQF_NO_AUTOEN flag will
disable IRQ auto-enable when request IRQ.

Fixes: 47b1be5c0f4e ("staging: imx/drm: request irq only after adding the crtc")
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
Reviewed-by: Philipp Zabel <p.zabel@pengutronix.de>
Link: https://patchwork.freedesktop.org/patch/msgid/20240912083020.3720233-4-ruanjinjie@huawei.com
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/imx/ipuv3/ipuv3-crtc.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/imx/ipuv3/ipuv3-crtc.c b/drivers/gpu/drm/imx/ipuv3/ipuv3-crtc.c
index 89585b31b985e..5f423a2e0ede3 100644
--- a/drivers/gpu/drm/imx/ipuv3/ipuv3-crtc.c
+++ b/drivers/gpu/drm/imx/ipuv3/ipuv3-crtc.c
@@ -410,14 +410,12 @@ static int ipu_drm_bind(struct device *dev, struct device *master, void *data)
 	}
 
 	ipu_crtc->irq = ipu_plane_irq(ipu_crtc->plane[0]);
-	ret = devm_request_irq(ipu_crtc->dev, ipu_crtc->irq, ipu_irq_handler, 0,
-			"imx_drm", ipu_crtc);
+	ret = devm_request_irq(ipu_crtc->dev, ipu_crtc->irq, ipu_irq_handler,
+			       IRQF_NO_AUTOEN, "imx_drm", ipu_crtc);
 	if (ret < 0) {
 		dev_err(ipu_crtc->dev, "irq request failed with %d.\n", ret);
 		return ret;
 	}
-	/* Only enable IRQ when we actually need it to trigger work. */
-	disable_irq(ipu_crtc->irq);
 
 	return 0;
 }
-- 
2.43.0



