Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208636;
	b=aTSiRe8hgkHzrCN6Eldo8Is7I3qPpMLu8DswX4eAzIwUCmYpQbqnYUJglMO/C48NOgPT
	 KUzgC6/HVD5DujrJ86qATKYz4/HZaOxHquFcof6DujnJXtEATMPcaAj8rS268yjSZ93cm
	 bIqd4TCeTTFeObigsxdWT683BGtONbN/4Q5p4dg1VJpA/x3kPV8bZRIu09y4EmBzsC0pd
	 A2yKicr7T3UR8qp8gylqEP4L+v7i74d3Ah3GPVFG1+Jusp5ggG3Ir6KFuYc2o7YML/R0d
	 hEwtUGZx211pIKcrbEa9jFDGRdnC3R0RMy/Afp+a+csVivjCiWmapUffCXqu711cJWQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208636;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Xam+ebvFAbQZ2UPa9ff404fYhWj+bt1lHf9fHftgQM8=;
	b=Col+TBAGQH8u/s5Cgut646ONA9PJjGDMHrVjol9OAeb1v5q6Iwsxgm7tSLv7lwUaJkIe
	 d+LD0zrVrrKD02bzorenc4d5yn1cQ+RAtKq+bLD8yeXxd+tx5z0iJiRug8ojCFm8/zVnY
	 4FbmYqsMYnC2dLtrE2LvvDoYozrvpcRDBWk05Xk6oLEHKCO22pTuNTAWClMAMmMuuCtgU
	 ezuNJHglwVgTHYuR5tzc8uVWSLuX0wqGpkit7YLJr6paAvTmstrVEVQ9uj3LdKj+ui8wG
	 qXV0il5Q4BgACvgO6yIhGlA76nOgzPW3eOPJ+rMg27XsX26p4RffQ4drVuYiRZ1I33Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=B2fTGlJg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64C80606A31E;
	Wed, 28 Oct 2026 17:30:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=B2fTGlJg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9A791F01825;
	Wed, 28 Oct 2026 17:30:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208636;
	bh=Xam+ebvFAbQZ2UPa9ff404fYhWj+bt1lHf9fHftgQM8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=B2fTGlJgVbDgdFOc0gDDPIyVyoIIIMsrKF/3nzciHhmacmXkMjvQXxewIwCO5zA7I
	 xhG84bAKkuPt8YlGwAwri40UKvs0PVHM3jkrNJkbEDxYOr6oKSzZ/07rwWpi2l1Iut
	 XLh0/wXGeuDIW5vbw+LMOVuZKdoy7+yDhHYO+DJk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Rob Clark <robdclark@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 146/516] drm/msm/adreno: Assign msm_gpu->pdev earlier to avoid nullptrs
Date: Wed, 28 Oct 2026 17:54:58 +0100
Message-ID: <20261028170006.967946279@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konrad Dybcio <konrad.dybcio@linaro.org>

[ Upstream commit 16007768551d5bfe53426645401435ca8d2ef54f ]

There are some cases, such as the one uncovered by Commit 46d4efcccc68
("drm/msm/a6xx: Avoid a nullptr dereference when speedbin setting fails")
where

msm_gpu_cleanup() : platform_set_drvdata(gpu->pdev, NULL);

is called on gpu->pdev == NULL, as the GPU device has not been fully
initialized yet.

Turns out that there's more than just the aforementioned path that
causes this to happen (e.g. the case when there's speedbin data in the
catalog, but opp-supported-hw is missing in DT).

Assigning msm_gpu->pdev earlier seems like the least painful solution
to this, therefore do so.

Signed-off-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Patchwork: https://patchwork.freedesktop.org/patch/602742/
Signed-off-by: Rob Clark <robdclark@chromium.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/adreno/adreno_gpu.c | 2 ++
 drivers/gpu/drm/msm/msm_gpu.c           | 1 -
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/msm/adreno/adreno_gpu.c b/drivers/gpu/drm/msm/adreno/adreno_gpu.c
index 83d5917180e1a..68523f8a8bfbd 100644
--- a/drivers/gpu/drm/msm/adreno/adreno_gpu.c
+++ b/drivers/gpu/drm/msm/adreno/adreno_gpu.c
@@ -907,6 +907,8 @@ int adreno_gpu_init(struct drm_device *drm, struct platform_device *pdev,
 	adreno_gpu->revn = adreno_gpu->info->revn;
 	adreno_gpu->rev = config->rev;
 
+	gpu->pdev = pdev;
+
 	adreno_gpu_config.ioname = "kgsl_3d0_reg_memory";
 
 	adreno_gpu_config.nr_rings = nr_rings;
diff --git a/drivers/gpu/drm/msm/msm_gpu.c b/drivers/gpu/drm/msm/msm_gpu.c
index c5f3c561ecc6a..7124f4fb1fc80 100644
--- a/drivers/gpu/drm/msm/msm_gpu.c
+++ b/drivers/gpu/drm/msm/msm_gpu.c
@@ -921,7 +921,6 @@ int msm_gpu_init(struct drm_device *drm, struct platform_device *pdev,
 	if (IS_ERR(gpu->gpu_cx))
 		gpu->gpu_cx = NULL;
 
-	gpu->pdev = pdev;
 	platform_set_drvdata(pdev, &gpu->adreno_smmu);
 
 	msm_devfreq_init(gpu);
-- 
2.53.0



