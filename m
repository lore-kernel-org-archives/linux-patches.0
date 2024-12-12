Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2AEE4F218;
	Thu, 12 Dec 2024 17:18:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734023935; cv=none; b=nDTaNhYRG7Q5ZG919SF/f6aSyeN2UHl3w+zefecpMvyZ5/+hqzz09bMVnMqiL3OTt/pfKw/oR/t7A+8Rm88OoBSm8NWSNOuez3IEYF/uKPJmiOcXLlPoVkqi0z0BMaMYaCJ/Nqy4/NDwdQ7rg5HQBvoXs5zN+Vw0s6GgIf6IZxM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734023935; c=relaxed/simple;
	bh=l+26VUbvVwTV9dq93Gcrj4OszWdaEghw/OlRccKbklA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cB+Xy4SR1bUAPT3luAZeTD80NdKl1wCmTCzU0P/p0UaYQGEhW0nfmpzCeLDJW3b8oHKZwHLkzBNbhvhyJJp6XDxiJhWmL4V/Ql0JlAXZ0A7MiyGd9a1LDQCHoF911bvjTPlT5P+x36Wrst3qvEF2A4QdH2cIlCyCsdRcvw7wUo4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kovS8dY3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kovS8dY3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D3B2C4CECE;
	Thu, 12 Dec 2024 17:18:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734023935;
	bh=l+26VUbvVwTV9dq93Gcrj4OszWdaEghw/OlRccKbklA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kovS8dY31P/CL6rif9CsNuhYos6BmsP86FQKgCfDvF1mAF9lEFU3x3v5g7EJB4fyx
	 Hq4tcfhxU1BEP6p6beNMEH/VN9cCvcdorMFR9/D9u6MfgGwSk+YHgQbtuFS4VqwOLU
	 3Ri+SMYgLzrAyK8PU8jlG8sZPJjmelUxZLrb0Qyg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	Rob Clark <robdclark@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 132/459] drm/msm/adreno: Use IRQF_NO_AUTOEN flag in request_irq()
Date: Thu, 12 Dec 2024 15:57:50 +0100
Message-ID: <20241212144258.716159052@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144253.511169641@linuxfoundation.org>
References: <20241212144253.511169641@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 8d78d95d29fcd..655938df45313 100644
--- a/drivers/gpu/drm/msm/adreno/a6xx_gmu.c
+++ b/drivers/gpu/drm/msm/adreno/a6xx_gmu.c
@@ -1407,15 +1407,13 @@ static int a6xx_gmu_get_irq(struct a6xx_gmu *gmu, struct platform_device *pdev,
 
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



