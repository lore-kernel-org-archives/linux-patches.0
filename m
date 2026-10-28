Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212538;
	b=t9dkasj9g6RCteYomD77S7vFtB7DrCKLy1uUTcyHOf8KCn/gPwtqDfIidUXzUwC/Mvoj
	 4+49sEZhnSUWbj/L1V0xRFSaJ3g6BRXfwu2qynWGygkCF8HvbIu6w/KUoQ9b5fBo/wV9n
	 CsGUvv69tbIA0U9On/iErjtWgP1kIDdAUr0Y+pbjt3m9+Wtts2CxGFsiis9jBXuplwKxX
	 EqAGe++82tYsvK7KBzqPQS1FbbVNaHw6kh8gKqAOkGGB3fYciAqo6IKnwgtHmHAARBm8o
	 Tk17SrtPzNx637dRa6Vpu19txT2DNjB4AUAwpLut0FmYEn/fnSnCw3X4gwvuXgxAmfg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212538;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ymmZrncgv2MRlt7i8vCduf/j7gViFHXqMAyOyGClxCQ=;
	b=dTBLYzGF3u+e87K0L6JXx/guUdDEEzorJCYa0my2R/EZZp4V26J+R7bFIr1l2ZRFr3Hd
	 Lva+C/yNXmM51ZvKLoUxKoWbRe9sDIqGiHMGVm0Y8jq0DXjK7CnCUeOhCzGuxYc797Pvd
	 aouc+DTqSGsU1iRlt2ucO57PdtG8gimEPwN1s0xZubxLzJmabFcGFpL65OV5SsiCdseaw
	 FFSbL/mcJPM1cOQIqzMp4v0dfjOubHt55e5d81RK7R0SqpeYheiSRXN/hrBiazONCuk+x
	 AOuiWIz4damD8AM0TnM9rXAW+BBcsHQ1J0nljGUnUx30J4wj+M1DZmgnmTOYhZi3wgA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="pm/Rxi04";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A025606A31C;
	Wed, 28 Oct 2026 18:35:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pm/Rxi04
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA31C1F01825;
	Wed, 28 Oct 2026 18:35:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212538;
	bh=ymmZrncgv2MRlt7i8vCduf/j7gViFHXqMAyOyGClxCQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pm/Rxi04DOrNbp6B/TreKlGSzr2vWK8oqzD71q8oecZcu8wc620RwwhGBJtVzZk/C
	 dhTK/1JD4ZQhUNEgz2GDeW7n2J/xqlRPoIagWoPY3Jey28Zhme+yIcMbRyI6DsBw8a
	 mB2nhITg7HqlxqdhARa07yFVme4+LxHubDLieEtk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Rob Clark <robdclark@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0188/1887] drm/msm/adreno: Assign msm_gpu->pdev earlier to avoid nullptrs
Date: Wed, 28 Oct 2026 17:38:04 +0100
Message-ID: <20261028170503.512891335@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 396f12b550479..8ff98efb0e8d8 100644
--- a/drivers/gpu/drm/msm/adreno/adreno_gpu.c
+++ b/drivers/gpu/drm/msm/adreno/adreno_gpu.c
@@ -1052,6 +1052,8 @@ int adreno_gpu_init(struct drm_device *drm, struct platform_device *pdev,
 	adreno_gpu->revn = adreno_gpu->info->revn;
 	adreno_gpu->rev = *rev;
 
+	gpu->pdev = pdev;
+
 	if (adreno_read_speedbin(dev, &speedbin) || !speedbin)
 		speedbin = 0xffff;
 	adreno_gpu->speedbin = (uint16_t) (0xffff & speedbin);
diff --git a/drivers/gpu/drm/msm/msm_gpu.c b/drivers/gpu/drm/msm/msm_gpu.c
index 3802495003258..9385419a78dbf 100644
--- a/drivers/gpu/drm/msm/msm_gpu.c
+++ b/drivers/gpu/drm/msm/msm_gpu.c
@@ -938,7 +938,6 @@ int msm_gpu_init(struct drm_device *drm, struct platform_device *pdev,
 	gpu->cx_collapse = devm_reset_control_get_optional_exclusive(&pdev->dev,
 			"cx_collapse");
 
-	gpu->pdev = pdev;
 	platform_set_drvdata(pdev, &gpu->adreno_smmu);
 
 	msm_devfreq_init(gpu);
-- 
2.53.0



