Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD66E36A357;
	Wed, 20 May 2026 16:40:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779295259; cv=none; b=aV/LmPG4jzMkpNdY9Gh7bzNHD6P5ddUyphej0F3N6tZVhWdQcz1qM52vXRP0LjcxubLRS6VqeKaiDtqxzq5qamcHbioziTdrJSvenwruq/wuFVJ0e0fv1FvmurQ3JbifUCKioCffMDnowqkatoiVX6toSv9r8AMbyAsn2gxOtVs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779295259; c=relaxed/simple;
	bh=6jSuLTqGHPqolENk5vrPKjP3h2+lXAmmoDplTz3R6KY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zn8wcHEXbGm7AHg8KvUbB/krt0uLW7hFWIDQj/JkmD+Dq/Sex3UCbCpmTmClunN7IvbaooS7N43/p+KePg1523A0ItETskyFh/OBqmO/cYqt9joUFkiI9nyqT7Jt2v7lbAalEZuZkLPpcCmmpdyk7KfDkGsV9wx3rEuvNlA874E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KMD2tZSE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KMD2tZSE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D9C01F000E9;
	Wed, 20 May 2026 16:40:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779295258;
	bh=/ZQj9dt09rYI+KG8x8OGPUgknpSaELrIRNWQa3O1+Yw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KMD2tZSEnarKVqixku7ZZDfXlFeCx0jRx554taT00Faj7DrGfziFF6bR+31liMZvN
	 4KtTtV7brWY/NASfbEll+25BitaXkfGt8QO2NLqW+nGm2zhfqnWPziji7nO5FrLQOX
	 o8VuT4xfHPlxtfysD9ZrvAa4rfhmdJgtCXLCRGek=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rob Clark <robin.clark@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Akhil P Oommen <akhilpo@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0352/1146] drm/msm/a6xx: Add missing aperture_lock init
Date: Wed, 20 May 2026 18:10:02 +0200
Message-ID: <20260520162156.166085793@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rob Clark <robin.clark@oss.qualcomm.com>

[ Upstream commit d4ef6d77bb1ef92bdbfb70c7a5d08072848357d8 ]

Looks like this was somehow missed when introducing gen8 support.

Fixes: 288a93200892 ("drm/msm/adreno: Introduce A8x GPU Support")
Signed-off-by: Rob Clark <robin.clark@oss.qualcomm.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Reviewed-by: Akhil P Oommen <akhilpo@oss.qualcomm.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Patchwork: https://patchwork.freedesktop.org/patch/713545/
Message-ID: <20260323161603.1165108-1-robin.clark@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/adreno/a6xx_gpu.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/msm/adreno/a6xx_gpu.c b/drivers/gpu/drm/msm/adreno/a6xx_gpu.c
index d6dfe6337bc34..f17bb5e78e0b9 100644
--- a/drivers/gpu/drm/msm/adreno/a6xx_gpu.c
+++ b/drivers/gpu/drm/msm/adreno/a6xx_gpu.c
@@ -2656,6 +2656,7 @@ static struct msm_gpu *a6xx_gpu_init(struct drm_device *dev)
 	gpu = &adreno_gpu->base;
 
 	mutex_init(&a6xx_gpu->gmu.lock);
+	spin_lock_init(&a6xx_gpu->aperture_lock);
 
 	adreno_gpu->registers = NULL;
 
-- 
2.53.0



