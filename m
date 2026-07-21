Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D71D146D2D1;
	Tue, 21 Jul 2026 18:07:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784657273; cv=none; b=e2GK1vB2iNLY3UsfyYrKGgXqTGHB1SCm0P5WgzEQdeixjSrd2I83px7v4/HW4s4GCiO4IoRnu9H7sZdtfhUaA2VKHDrJHCviPTqahp2dDS6NNaIcbzZgHlNejs5t1MsojSHYjNKxAUe8IxHYch390cpzpdfTMEuLU1EMZEI7WeA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784657273; c=relaxed/simple;
	bh=fU1z0li/o6ly3Nrrrnb7r1A05q0+TuC3SKj6jkvp3JM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Kj0Z/QA3Ysy0HGgihz4RfPWufE6cBE1jG7CRmo7CdIBdflQnjk6ZxMw0zjBnyXc2JcD34yxHc8KxvQJhXvt0yUwU4UEjThe6qPfQCe1R1PzDeapbp4ftc7O2mmZ3QjRgJfaCkLTlfkTbHgFjNZkTKYuvk+rugAELHbkj2Dco9j8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BA9iueYx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BA9iueYx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38F6F1F00A3F;
	Tue, 21 Jul 2026 18:07:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784657271;
	bh=omWrXdZL9lqsnFCKK56bR7cZSA3LmMsnfxVugzGnEus=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BA9iueYxBYnx8KKWw98v7vJy9cBB7LqWTQaa/K0S1plouhIiwC/ZxKwfaIsIPMXKI
	 tRAaE53AE34ZL9J0h8OdWdprGqyvPxTJRGLt5NPoGd7Ly0aqCLkqT7XHn+cvfHdpzj
	 bcWVHxj9I0u/RMlBHLweQXwmAv613ehX6T66X6KY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Icenowy Zheng <zhengxingda@iscas.ac.cn>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0658/1611] dmaengine: qcom: gpi: set DMA_PRIVATE capability
Date: Tue, 21 Jul 2026 17:12:54 +0200
Message-ID: <20260721152530.185948302@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Icenowy Zheng <zhengxingda@iscas.ac.cn>

[ Upstream commit 4e351f408743354d54ee1af5193fc78234f2044e ]

The GPI DMA controller is only responsible for QUP peripherals, and
cannot work as a general-purpose DMA accelerator.

Set DMA_PRIVATE capability for it.

This fixes error messages about GPI being shown when an async-tx
consumer is loaded.

Fixes: 5d0c3533a19f ("dmaengine: qcom: Add GPI dma driver")
Signed-off-by: Icenowy Zheng <zhengxingda@iscas.ac.cn>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Link: https://patch.msgid.link/20260602070344.3707256-1-zhengxingda@iscas.ac.cn
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/qcom/gpi.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/dma/qcom/gpi.c b/drivers/dma/qcom/gpi.c
index 8908b7c7190074..51d52a140c1b3a 100644
--- a/drivers/dma/qcom/gpi.c
+++ b/drivers/dma/qcom/gpi.c
@@ -2253,6 +2253,7 @@ static int gpi_probe(struct platform_device *pdev)
 	/* clear and Set capabilities */
 	dma_cap_zero(gpi_dev->dma_device.cap_mask);
 	dma_cap_set(DMA_SLAVE, gpi_dev->dma_device.cap_mask);
+	dma_cap_set(DMA_PRIVATE, gpi_dev->dma_device.cap_mask);
 
 	/* configure dmaengine apis */
 	gpi_dev->dma_device.directions = BIT(DMA_DEV_TO_MEM) | BIT(DMA_MEM_TO_DEV);
-- 
2.53.0



