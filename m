Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 235EC14A4CC;
	Wed,  5 Feb 2025 13:48:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738763330; cv=none; b=jwwaLYDefbJdOpicuAUJcvy63Y+2QlXATU3vPc0Kc8UMSnqeHiiVVMfs/XZURB7JJ8oXx3gwQmR/YcZTHpR35SoNO3162NfzSvEd7V+1JltGVEXfN+HVXMzhHXGbaT4bTcOU0w/m6Xna2Pxe9Zs9LXZcwmCcJSK8CPXMP62Qx/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738763330; c=relaxed/simple;
	bh=tHaMPafDCkHEhzF4Qc10lV5NK8LWaozxUNRPyNTTJVU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iXByJq7mUDZ01fhn95rpqxOJS2kVq4i6Gagy0bkmO7Ej53cmGpXCRgBqCrRjsKmXpN3d/pNppNqGO7HyeNfSGhepGx53AVU4AQzWUnUMPXtywBfXp4HRfBcvmsA5fWHj2a/nTwl3KDPUhORZpeGA1zwsDfwDFexO2rEzsx32HBo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i8P1ulim; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i8P1ulim"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F69BC4CED6;
	Wed,  5 Feb 2025 13:48:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738763330;
	bh=tHaMPafDCkHEhzF4Qc10lV5NK8LWaozxUNRPyNTTJVU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i8P1ulimEj1NOYi3wqsh5lGvmLEW2St1E3gKQpsMzjw+Bcjta5DNp9LfSHiSEukgr
	 3b8LkiVkpd72Dr5jVZis+fgZIpOIu//L9z9f7tRFFAhjm9MX9qY5TmdAYREEeKOllH
	 dPALzAvRqOznezUmKUQ2k90V/Vr/ryw39RHt626I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sui Jingfeng <sui.jingfeng@linux.dev>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 043/393] drm/msm: Check return value of of_dma_configure()
Date: Wed,  5 Feb 2025 14:39:22 +0100
Message-ID: <20250205134421.949909048@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134420.279368572@linuxfoundation.org>
References: <20250205134420.279368572@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Sui Jingfeng <sui.jingfeng@linux.dev>

[ Upstream commit b34a7401ffaee45354e81b38a4d072794079cfd6 ]

Because the of_dma_configure() will returns '-EPROBE_DEFER' if the probe
procedure of the specific platform IOMMU driver is not finished yet. It
can also return other error code for various reasons.

Stop pretending that it will always suceess, quit if it fail.

Signed-off-by: Sui Jingfeng <sui.jingfeng@linux.dev>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Fixes: 29ac8979cdf7 ("drm/msm/a6xx: use msm_gem for GMU memory objects")
Fixes: 5a903a44a984 ("drm/msm/a6xx: Introduce GMU wrapper support")
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Patchwork: https://patchwork.freedesktop.org/patch/622782/
Link: https://lore.kernel.org/r/20241104090738.529848-1-sui.jingfeng@linux.dev
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/adreno/a6xx_gmu.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/msm/adreno/a6xx_gmu.c b/drivers/gpu/drm/msm/adreno/a6xx_gmu.c
index c9edaa6d76369..9009442b543dd 100644
--- a/drivers/gpu/drm/msm/adreno/a6xx_gmu.c
+++ b/drivers/gpu/drm/msm/adreno/a6xx_gmu.c
@@ -1510,7 +1510,9 @@ int a6xx_gmu_wrapper_init(struct a6xx_gpu *a6xx_gpu, struct device_node *node)
 
 	gmu->dev = &pdev->dev;
 
-	of_dma_configure(gmu->dev, node, true);
+	ret = of_dma_configure(gmu->dev, node, true);
+	if (ret)
+		return ret;
 
 	pm_runtime_enable(gmu->dev);
 
@@ -1574,7 +1576,9 @@ int a6xx_gmu_init(struct a6xx_gpu *a6xx_gpu, struct device_node *node)
 
 	gmu->dev = &pdev->dev;
 
-	of_dma_configure(gmu->dev, node, true);
+	ret = of_dma_configure(gmu->dev, node, true);
+	if (ret)
+		return ret;
 
 	/* Fow now, don't do anything fancy until we get our feet under us */
 	gmu->idle_level = GMU_IDLE_STATE_ACTIVE;
-- 
2.39.5



