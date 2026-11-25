Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795625272;
	b=XogH0CjJL+d+l86194AAEvO2jxnU3SqQfz4L93uPozUjkqwhuMJzj0JDPoo99/PF1KYr
	 I+lNLCfDDHbMRWgSdP5FZi4RZ3FRZYJCaqbw/0nhAHfnslk87SE9Byd9VfHZTIhY7skVJ
	 lmGMuPZmBQNDvHT5YxlkgbaBXRlFwfyHpNmBuZNos0dydVC7492C6gqg5tKcw5nxyQUbf
	 2GNVHshdImbbKqxwNr+TV2s25Fl5rFA8tSgL26CrohPxTaFRurgTDZs35q8vdECuXszVu
	 8LawrrYa47UwnVFo78Px8wdAvSFAuxN9M2+V77BFpq+id3IeyN84PpI+A+wbqcGgA7A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795625272;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jpaw04szNdRoliptqBvHXYurziX3FT5R6yNaYhEEkrU=;
	b=bSuEoEv4JCa/fKoF9S6ipuCIDOnEDIJExro7mADdknG3GCXfkNAUiIwDaK4EZSoJ5Yr4
	 TxHMKofA7PwcOC6jJlnDIXc+ZTEOh90uN8VNH2fALtgifxrTXVR4eHLPU48OLEGFw7n52
	 +UUEBi004UlMOMWsev8e9Ob4yMCbaCpdogT1ydtlbwzauFGi6EeFPLmxTFoJ787bNlugk
	 QESu1ETaDK//HbnudCRm5buowhROBuh7bM4Ts+5jBnOU5cG7gOQ/QekSWHWi6wTV/OE6P
	 hng8EnTzufsd8RSju2JxGCNVgjcChQvTQU0YcZrGKm8PRUZPuNNCapvJggvN/GDHS4g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=K6QAXXxe;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E7BF606A32E;
	Wed, 25 Nov 2026 16:47:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=K6QAXXxe
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 809181F00A19;
	Wed, 25 Nov 2026 16:47:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795625272;
	bh=jpaw04szNdRoliptqBvHXYurziX3FT5R6yNaYhEEkrU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=K6QAXXxeLl2S22ChsqTJJjf48Vq01qr+kWkmIJob6EYB71edhNLAcPHOsR3BTsGzT
	 PFcmX/BKE+jyi2IuwPmvKzFz3508duw6nwvhxdOEWfdedolQsRjKNeLn/Nw6Q92D63
	 KOi2uZu3RiJc6k4IBEFAw1jIjG5Ht1Y0ndrlTV0w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Roman Demidov <roman.demidov.nn@gmail.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Rob Clark <robin.clark@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 460/816] drm/msm/a6xx: check pm_runtime_resume_and_get during resume
Date: Wed, 25 Nov 2026 15:33:28 +0100
Message-ID: <20261125143859.841059524@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: omitted the gmu->clocks bulk-enable error path and the a6xx_llc_activate() call because this tree's a6xx_pm_resume() lacks both, so only the PM resume return checks and unwind labels were applied. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/adreno/a6xx_gpu.c | 33 +++++++++++++++------------
 1 file changed, 19 insertions(+), 14 deletions(-)

diff --git a/drivers/gpu/drm/msm/adreno/a6xx_gpu.c b/drivers/gpu/drm/msm/adreno/a6xx_gpu.c
index 4dc095f74c32b..f924d633809a5 100644
--- a/drivers/gpu/drm/msm/adreno/a6xx_gpu.c
+++ b/drivers/gpu/drm/msm/adreno/a6xx_gpu.c
@@ -1877,36 +1877,41 @@ static int a6xx_pm_resume(struct msm_gpu *gpu)
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
 
-	if (!ret)
-		msm_devfreq_resume(gpu);
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



