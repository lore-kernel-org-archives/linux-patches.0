Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A85CA22333D;
	Thu, 12 Dec 2024 16:03:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734019395; cv=none; b=fi0r2zRkOTBN/8JgXqpB5GmZUuF2CPFl/0qodFezShXeq54WtkolQNBU8piXf3mkxhFPCVPPpdpR7mbXPDjK7Y3+30jXNlkHPuCI2X3W9kZbo+pXeV4ahL3NAPclZDsKkFlaNenmgcAPIC7aHTO7vzR2HM19d7xuJJqdrYu+vH0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734019395; c=relaxed/simple;
	bh=QSb75KiQlECcfLqeF+76squmyI9CVSXz5WkHwNWbYyM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VA1IVGgJ3DxDlfeP5hbCQdhSXmcNpvXLu+b8r454egZuSL6uhaNJMZqWGs4vx2PG412ZwSfIEzmwLO0E70ydSz7Rfz1W7KlUFEYPxtL1gSTFj8UVJgPCu+KEcwuwtnEtXxg2prat4/dUHZpniCIvAc1YfGihQiPCfYsn3S7xPB0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LjW6l5M9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LjW6l5M9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF719C4CECE;
	Thu, 12 Dec 2024 16:03:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734019395;
	bh=QSb75KiQlECcfLqeF+76squmyI9CVSXz5WkHwNWbYyM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LjW6l5M9Mb3DNxZhHFGS4lkaDAa8M+jvIgH0pHV0BnOfnWhMdqro+a0nRUABxffkY
	 9rImnPiIPR20YV0BIkOQui0VjiLHied0bPFtgvVlAg3txLipbFgmwUJbrALFAsA84F
	 VHcomO7WCxNAM4x1KqxVXv/isXnthAXhdmZOH5ZY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	Rob Clark <robdclark@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 166/772] drm/msm/adreno: Use IRQF_NO_AUTOEN flag in request_irq()
Date: Thu, 12 Dec 2024 15:51:51 +0100
Message-ID: <20241212144356.803857398@linuxfoundation.org>
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

[ Upstream commit 394679f322649d06fea3c646ba65f5a0887f52c3 ]

disable_irq() after request_irq() still has a time gap in which
interrupts can come. request_irq() with IRQF_NO_AUTOEN flag will
disable IRQ auto-enable when request IRQ.

Fixes: 4b565ca5a2cb ("drm/msm: Add A6XX device support")
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
Patchwork: https://patchwork.freedesktop.org/patch/614075/
Signed-off-by: Rob Clark <robdclark@chromium.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/adreno/a6xx_gmu.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/msm/adreno/a6xx_gmu.c b/drivers/gpu/drm/msm/adreno/a6xx_gmu.c
index 870252bef23f3..ee9b32fbe916c 100644
--- a/drivers/gpu/drm/msm/adreno/a6xx_gmu.c
+++ b/drivers/gpu/drm/msm/adreno/a6xx_gmu.c
@@ -1462,15 +1462,13 @@ static int a6xx_gmu_get_irq(struct a6xx_gmu *gmu, struct platform_device *pdev,
 
 	irq = platform_get_irq_byname(pdev, name);
 
-	ret = request_irq(irq, handler, IRQF_TRIGGER_HIGH, name, gmu);
+	ret = request_irq(irq, handler, IRQF_TRIGGER_HIGH | IRQF_NO_AUTOEN, name, gmu);
 	if (ret) {
 		DRM_DEV_ERROR(&pdev->dev, "Unable to get interrupt %s %d\n",
 			      name, ret);
 		return ret;
 	}
 
-	disable_irq(irq);
-
 	return irq;
 }
 
-- 
2.43.0



