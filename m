Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018695;
	b=SlqsurwJkQJr3QRroU6901mOxOvzgoU23knUtKEpQcK1KK6/RbTAqo216Kd7lgaZDRJj
	 EEFcaO429dfrnt1NTcvg+73djiUUj5OJlaBSh6/UPDY3LUyKcBUpI1B87mtBZ9Pq3ulq7
	 jB1H5QdWL5Gi9+tCzLXrQLDG7DX/AKVZLkUYrGmPze6cD9zzGhVFkeomLtRIAQOBmVs/8
	 qEzbUBAY0iwk9if5aC6lpzffMISTJOT+VW39S4KEbjCDYfnmjy9LlaGn5cy7wTTc663Li
	 CZAcTTENzXsijY7wL0wdlfg96AFbJChyw4aWoF2TfcokehnX+/pfp0f3F8rmN+HbXgw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018695;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8SHWsZ6LTfgmub6o5SRF0JPcEHAI0LiURIs3FEF3WeA=;
	b=dOMJXUOV1HzVfHQrnlgn4GzvEzL8lW6Bb/m9WG1UUirRfvSNQlENENZ6vFSrEZ6X2O4D
	 W+EKlSUIM1MazVFBh+wknY659VfRRaqPIYz8oYoKHORfo1dujzpNOUIPf73zgOgNPEvNj
	 /lCgXIg1gSP3LYvAeK6bs3KmFCgXhMYeRzaosO0wjP+En3YM9j1YmEpAh9papEVVcvsfG
	 PM0TcA30d0NavtVK62s0NVIIpa+kY7+dTgA5Zp81v0Cp2l9CdOAnUzeG8e6jvT8aWDGZM
	 GyMoTrjCJwem/aLjF7jtJSeycay7bC4K4zB8duhmJoi2pgghG9UUoWxWUZvt4XDZhVg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Vk1PfnKq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E6F8606A325;
	Wed, 18 Nov 2026 16:18:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Vk1PfnKq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33B391F000C8;
	Wed, 18 Nov 2026 16:18:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018694;
	bh=8SHWsZ6LTfgmub6o5SRF0JPcEHAI0LiURIs3FEF3WeA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Vk1PfnKqr0IoST3eLmwVeFH47JA4XVwE0ttiXEGKuDD6vZ4KF6abMCO6Ee74Pamdr
	 ATAiNkYiItSUEhfQhU+qqr7CIwzOQMhn3Mz1j+GYFIiHH8hUTBgMFGgVuzf1WeWkX1
	 QXK6/O1YndT3ORYUxKSCAkJzqZCQEJsopvSaG/Gw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Roman Demidov <roman.demidov.nn@gmail.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Rob Clark <robin.clark@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1331/2651] drm/msm/a6xx: check pm_runtime_resume_and_get during resume
Date: Wed, 18 Nov 2026 15:42:51 +0100
Message-ID: <20261118150335.924011285@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Roman Demidov <roman.demidov.nn@gmail.com>

[ Upstream commit e2f57c576f14f96449cfee840860cb9707501d23 ]

The return values of pm_runtime_resume_and_get() calls in a6xx_pm_resume()
are not checked, which can lead to hardware access on suspended devices
and PM reference underflows.

Fix this by checking the return value of each pm_runtime_resume_and_get()
call and properly unwinding the previously acquired resources on failure.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: 5a903a44a984 ("drm/msm/a6xx: Introduce GMU wrapper support")
Signed-off-by: Roman Demidov <roman.demidov.nn@gmail.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Patchwork: https://patchwork.freedesktop.org/patch/757106/
Message-ID: <20260929142103.81854-2-roman.demidov.nn@gmail.com>
Signed-off-by: Rob Clark <robin.clark@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/adreno/a6xx_gpu.c | 38 +++++++++++++++------------
 1 file changed, 21 insertions(+), 17 deletions(-)

diff --git a/drivers/gpu/drm/msm/adreno/a6xx_gpu.c b/drivers/gpu/drm/msm/adreno/a6xx_gpu.c
index 33424eb8cd9df..1f04503f718ce 100644
--- a/drivers/gpu/drm/msm/adreno/a6xx_gpu.c
+++ b/drivers/gpu/drm/msm/adreno/a6xx_gpu.c
@@ -2181,44 +2181,48 @@ static int a6xx_pm_resume(struct msm_gpu *gpu)
 	opp = dev_pm_opp_find_freq_ceil(&gpu->pdev->dev, &freq);
 	if (IS_ERR(opp)) {
 		ret = PTR_ERR(opp);
-		goto err_set_opp;
+		goto err_unlock;
 	}
 
 	/* Set the core clock and bus bw, having VDD scaling in mind */
 	dev_pm_opp_set_opp(&gpu->pdev->dev, opp);
 	dev_pm_opp_put(opp);
 
-	pm_runtime_resume_and_get(gmu->dev);
-	pm_runtime_resume_and_get(gmu->gxpd);
+	ret = pm_runtime_resume_and_get(gmu->dev);
+	if (ret < 0)
+		goto err_opp_clear;
+	ret = pm_runtime_resume_and_get(gmu->gxpd);
+	if (ret < 0)
+		goto err_put_dev;
 
 	ret = clk_bulk_prepare_enable(gpu->nr_clocks, gpu->grp_clks);
 	if (ret)
-		goto err_bulk_clk;
+		goto err_put_gxpd;
 
 	ret = clk_bulk_prepare_enable(gmu->nr_clocks, gmu->clocks);
 	if (ret) {
 		clk_bulk_disable_unprepare(gpu->nr_clocks, gpu->grp_clks);
-		goto err_bulk_clk;
+		goto err_put_gxpd;
 	}
 
 	if (adreno_is_a619_holi(adreno_gpu))
 		a6xx_sptprac_enable(gmu);
 
-	/* If anything goes south, tear the GPU down piece by piece.. */
-	if (ret) {
-err_bulk_clk:
-		pm_runtime_put(gmu->gxpd);
-		pm_runtime_put(gmu->dev);
-		dev_pm_opp_set_opp(&gpu->pdev->dev, NULL);
-	}
-err_set_opp:
 	mutex_unlock(&a6xx_gpu->gmu.lock);
+	msm_devfreq_resume(gpu);
+	a6xx_llc_activate(a6xx_gpu);
 
-	if (!ret) {
-		msm_devfreq_resume(gpu);
-		a6xx_llc_activate(a6xx_gpu);
-	}
+	return 0;
 
+	/* If anything goes south, tear the GPU down piece by piece.. */
+err_put_gxpd:
+	pm_runtime_put(gmu->gxpd);
+err_put_dev:
+	pm_runtime_put(gmu->dev);
+err_opp_clear:
+	dev_pm_opp_set_opp(&gpu->pdev->dev, NULL);
+err_unlock:
+	mutex_unlock(&a6xx_gpu->gmu.lock);
 	return ret;
 }
 
-- 
2.53.0



