Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793210772;
	b=sAPnCdP2xnnpASnX00rxytaduqfeSGbL0XXA0+MHFw8FDA2yI4QFQTDoZs6GeOzSyA34
	 FQA7zujBYVaGCYpR157xpreYwJd7yUTkYOaDXL5/vJUGgc4Wf1H9F37Un2OLDMabUhxNg
	 o4A9skL6HqQeg2Hxa0pWD+WkbrhUd/pOWAj6QDA3TE8whay9IxAlHH16CfqDW6aRHbYKr
	 yrR8l/pWIVSNmmw3qG/BuIfZhA/AG02LXrOw6Cf1t7rxKddWuqj/NZt88ms9BssIYfJRg
	 98rm5kzfQeqYV2yfNJ3cyurKwRt38sYfdfFoFoQEaZlct9D8IYn4n+OuBg1oX2pMjGw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793210772;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=w5kmJFEPQ+hLtjSSr9xRDViN5MmT4AouuD4ib3JZgck=;
	b=CGWr/nsWLLU0m+BIKE+XsCG4961hFat6Tb2hk0qhHx9mbXIvVQ4P3FsFptWx+Yiujq1J
	 4oMRK+WXAjEG76Q53NEFIhmwarLAMXdi0GkO72D3SAWACY4W3rRURSLlAZ9bc68ociIIS
	 8Gt4xfMypyZTIMoDOYKtj5eANLAlv38cvLtS21jFLj9zSCHCfiKqKdmCkMmVVjSBTk4Fm
	 R8P5lA0t+K7YOcWF76TJzH0OpGeqFtP1eknnha3czCbpWmtQ5LkQdy6sS3HUuEXCn7btu
	 5wVsHP/yhSXUfDAIyeOS+R1uTohkkWt6N9J7GfM2ik5FclzfsRDrdC8RkLFqX2k9cyA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zgyeRWnG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1148C606A31A;
	Wed, 28 Oct 2026 18:06:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zgyeRWnG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E0B81F01825;
	Wed, 28 Oct 2026 18:06:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793210771;
	bh=w5kmJFEPQ+hLtjSSr9xRDViN5MmT4AouuD4ib3JZgck=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zgyeRWnGPzFEAlZaADvkMh8TBougQlyU+w4L9wB5uuKkY5nUCUUBSBm5wt+k99zTi
	 hGOdt/2mFPX0DGnJfD7QSIaT6FE7ozpHckj7DoyxTdyT0bQBjL1J5/Rtn2DJplI7O/
	 aCPrtKQvYn8EV7qzLrFUyyN4q+UfMTmzhObMs7a8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Rob Clark <robdclark@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 144/571] drm/msm/adreno: Assign msm_gpu->pdev earlier to avoid nullptrs
Date: Wed, 28 Oct 2026 17:54:51 +0100
Message-ID: <20261028170011.432166557@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 37e6984a89ced..ef046d30ed02a 100644
--- a/drivers/gpu/drm/msm/adreno/adreno_gpu.c
+++ b/drivers/gpu/drm/msm/adreno/adreno_gpu.c
@@ -934,6 +934,8 @@ int adreno_gpu_init(struct drm_device *drm, struct platform_device *pdev,
 	adreno_gpu->revn = adreno_gpu->info->revn;
 	adreno_gpu->rev = config->rev;
 
+	gpu->pdev = pdev;
+
 	adreno_gpu_config.ioname = "kgsl_3d0_reg_memory";
 
 	adreno_gpu_config.nr_rings = nr_rings;
diff --git a/drivers/gpu/drm/msm/msm_gpu.c b/drivers/gpu/drm/msm/msm_gpu.c
index 8250d86d11e7a..eec4ee4be93c1 100644
--- a/drivers/gpu/drm/msm/msm_gpu.c
+++ b/drivers/gpu/drm/msm/msm_gpu.c
@@ -900,7 +900,6 @@ int msm_gpu_init(struct drm_device *drm, struct platform_device *pdev,
 	if (IS_ERR(gpu->gpu_cx))
 		gpu->gpu_cx = NULL;
 
-	gpu->pdev = pdev;
 	platform_set_drvdata(pdev, &gpu->adreno_smmu);
 
 	msm_devfreq_init(gpu);
-- 
2.53.0



