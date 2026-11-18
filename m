Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795025649;
	b=U4X5WY5eC6yxd3DIu3p3T8EJwpLj+Se30vgt5Ajz2mFKEbmAigmCtFitN0cvpiTYftk4
	 37A2i6s2E/mfCcjZbeeR7BPNfWjsHtaRxfch/B2JA97UQG04wFwRI4cJkvzqw5sczYuyv
	 24fFnPkol8RjD2Hsj4g2MlXpIr7jk3KeOLkuG56e1419jidruGxwkGzdbzs0p3nLT/D2L
	 3thsAfdYD8m4bFXIiZ06WgbME1wAnnj34Olp9fkjmRGBLGFihqSuSbVuZaIkIno5sp20v
	 pwo7Y6QBYKKwq0Tq5tOrfhF2rzCHG6wjNwuR3Fd2Vvfm0qLSOYKf0bhgBzXd/QdHw4w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795025649;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=DqDdT2p26Oit05rrQfyIkqP/PT3sdAIN7ml8wQBpdSA=;
	b=WjrWJP7uH/41LhT5vln8SAiOg/K7vn5N+SN/M3iIXPUstIOMIzRihTf4SUsOQ5mJu11g
	 lxPmU2pR22jwTKt6prMgLBhDm7nfwziFWzTFYrHM0HhJzPefunIFfuCDCIdfaM93zCJCc
	 ZjpMrnQe604wUikh5a+Lh0OZjvFZmMlaH4+CvnrCtBIDZcLw4M7p3JbsZT0QQrBIobh9o
	 x4hdIW7+qUL2CFpr9i4X1rSp/TFJYebcDi26nV8MLDc3c66Z+tT+0d+NF65qD3hZFX/A6
	 hH5ubuoWynj2nNggxfN2eEb+ibyHCIGWjoT0BlJLcOQP4scl+iyXntTQKjzO7fbY+3A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fZOFmkXI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB338606A320;
	Wed, 18 Nov 2026 18:14:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fZOFmkXI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 088A21F000C4;
	Wed, 18 Nov 2026 18:14:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795025649;
	bh=DqDdT2p26Oit05rrQfyIkqP/PT3sdAIN7ml8wQBpdSA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fZOFmkXIjPw6ouvBNyI5gyPge/r/jc9e9G4UMZCOg+H3uqnmQerDrYV5SQoMAzJvL
	 oNsMN0eEhSnjJl0n//B24wnoLlyrypA2b8/AywmPNUICx6gmnrRhcTBzGT4KjAf5lK
	 VPaGUslOGTuFuBz9Ey8Bnccw1tu1XmzuIhkANUhk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Roman Demidov <roman.demidov.nn@gmail.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Rob Clark <robin.clark@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1112/2151] drm/msm/a6xx: check pm_runtime_resume_and_get during resume
Date: Wed, 18 Nov 2026 15:47:27 +0100
Message-ID: <20261118150202.740355125@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index a2aae30f7d117..94543360c982a 100644
--- a/drivers/gpu/drm/msm/adreno/a6xx_gpu.c
+++ b/drivers/gpu/drm/msm/adreno/a6xx_gpu.c
@@ -2238,44 +2238,48 @@ static int a6xx_pm_resume(struct msm_gpu *gpu)
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



