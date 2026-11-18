Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019436;
	b=KFmiogbVIa1zJri6K2Z9mQQBVh/jmVmEpSOT0gwnd1lohiLr27gJHQj/qE7ymCofOB0e
	 T5pSQmdMEM4gr7fyPBxDRC4WiVrU4CF01z9X0f0+x4fkVg/hWGdFyu2daBn5Cm8+awwmt
	 5q8jB5EpOWnXz/UiIcdONMdROGjXsAJpKXOLJwDL/bRpHxI8BVPyJyfoWadyeGhDmo+Qr
	 9pzUTE88aZz9WgbsQsP4tyjyf99dbpysbDfTTUU7bs6i6SkTZv74n8fP5UDTvnZTmmO6a
	 dajk2c29O+uH9O6lrMXQMrcnweMTooAqc+dNqFcfqyrMmZJC1uS+F7Ju9dFOyBgBrxg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019436;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=cN8XzYy6OANLG+gmeG8ObscmU625bxKB55wtbCjfXWg=;
	b=cazac/KLAQzes5OAz+wQD+BIEr06BG7CJeJIeV0nu+BbNu70rDRjhqjuaLy8yB+8nXsa
	 URp7qWTux0dpAwR/Gfc7gog2Ql06iH9xrYZbTfZK52gBBXIYZsQav2R+N/khD72BrjF3u
	 1f4/2FWWmKvcsjWJFNmtg7zMHmbBViVAP0KrYhtVWQHO+j/t3Jlv9Vqjd+qt3LX90jXoE
	 nD5Cq5E/oIwyXsANM8J/Mt9YI8XV8Fou+Ph5Achh0piTDwZmWKg493GqNnY0jsT7BBleV
	 tBubhG8Mb+0fufKfKLJ2GJ/uXGNPjxSyCewWtU8tuCwkW+j6ANOjxLZDc405IxbnJ/g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yEG+uqM5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46AAA606B568;
	Wed, 18 Nov 2026 16:30:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yEG+uqM5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A9151F000C4;
	Wed, 18 Nov 2026 16:30:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019436;
	bh=cN8XzYy6OANLG+gmeG8ObscmU625bxKB55wtbCjfXWg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yEG+uqM55yoXg6U7zk44cH3HjE6bA3qRFySTsxc6Mrj6Fu6Gdt20rSDS5V304GGOE
	 v4hGAVzMvfy3hksx2WGufzy9wherwUjeiL4Z89JO6yo56MHUFi5SdQaLWWBXRjCIyH
	 KSfOuKQb3zfSXdeidkKutXktBMQYUVBYl5XD/2vQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rahul Pon <theflyingrahul@gmail.com>,
	Rob Clark <robin.clark@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1595/2651] drm/msm/a8xx: report the GMEM size of the active slices
Date: Wed, 18 Nov 2026 15:47:15 +0100
Message-ID: <20261118150345.311623867@linuxfoundation.org>
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

From: Rahul Pon <theflyingrahul@gmail.com>

[ Upstream commit efbda69d92e6a4822c5f2d09910f547872a9498d ]

A8xx GPUs split GMEM evenly between their slices, and parts can have
slices fused off: a8xx_gpu_get_slice_info() reads the active slice mask
and folds the slice count into the chip ID. The GMEM size reported to
userspace (MSM_PARAM_GMEM_SIZE) is still the catalog value for all
slices, so on a part with fused-off slices userspace would size its
tiles and place its CCU caches past the end of the GMEM that exists.

Qualcomm's downstream driver reports GMEM for the active slices:
gen8_get_gmem_size() in KGSL divides the GMEM size by the number of
physical slices and multiplies it by the number of active ones. Do the
same when reading the slice mask. The GMEM protection and UCHE setup
still cover the full range, as in KGSL.

Fixes: 288a93200892 ("drm/msm/adreno: Introduce A8x GPU Support")
Signed-off-by: Rahul Pon <theflyingrahul@gmail.com>
Patchwork: https://patchwork.freedesktop.org/patch/757560/
Message-ID: <20260930183840.1171-1-theflyingrahul@gmail.com>
Signed-off-by: Rob Clark <robin.clark@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/adreno/a8xx_gpu.c   | 3 +++
 drivers/gpu/drm/msm/adreno/adreno_gpu.c | 3 ++-
 drivers/gpu/drm/msm/adreno/adreno_gpu.h | 2 ++
 3 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/msm/adreno/a8xx_gpu.c b/drivers/gpu/drm/msm/adreno/a8xx_gpu.c
index add93c1fa0391..2f6f36fb8ba92 100644
--- a/drivers/gpu/drm/msm/adreno/a8xx_gpu.c
+++ b/drivers/gpu/drm/msm/adreno/a8xx_gpu.c
@@ -112,6 +112,9 @@ void a8xx_gpu_get_slice_info(struct msm_gpu *gpu)
 	/* Chip ID depends on the number of slices available. So update it */
 	adreno_gpu->chip_id |= FIELD_PREP(GENMASK(7, 4), hweight32(slice_mask));
 
+	/* GMEM is split evenly between slices: report the active share */
+	adreno_gpu->gmem = (adreno_gpu->info->gmem / info->max_slices) * hweight32(slice_mask);
+
 	/* Update the gpu-name to reflect the slice config: */
 	const char *name = devm_kasprintf(dev, GFP_KERNEL,
 			"%"ADRENO_CHIPID_FMT,
diff --git a/drivers/gpu/drm/msm/adreno/adreno_gpu.c b/drivers/gpu/drm/msm/adreno/adreno_gpu.c
index 5832dc25d6bf4..dadfe4c694384 100644
--- a/drivers/gpu/drm/msm/adreno/adreno_gpu.c
+++ b/drivers/gpu/drm/msm/adreno/adreno_gpu.c
@@ -379,7 +379,7 @@ int adreno_get_param(struct msm_gpu *gpu, struct msm_context *ctx,
 		*value = adreno_gpu->info->revn;
 		return 0;
 	case MSM_PARAM_GMEM_SIZE:
-		*value = adreno_gpu->info->gmem;
+		*value = adreno_gpu->gmem;
 		return 0;
 	case MSM_PARAM_GMEM_BASE:
 		if (adreno_gpu->info->family >= ADRENO_6XX_GEN3)
@@ -1205,6 +1205,7 @@ int adreno_gpu_init(struct drm_device *drm, struct platform_device *pdev,
 	adreno_gpu->funcs = funcs;
 	adreno_gpu->info = config->info;
 	adreno_gpu->chip_id = config->chip_id;
+	adreno_gpu->gmem = config->info->gmem;
 
 	gpu->allow_relocs = config->info->family < ADRENO_6XX_GEN1;
 	gpu->pdev = pdev;
diff --git a/drivers/gpu/drm/msm/adreno/adreno_gpu.h b/drivers/gpu/drm/msm/adreno/adreno_gpu.h
index bd5c440f1753f..e0d0043cd8ba0 100644
--- a/drivers/gpu/drm/msm/adreno/adreno_gpu.h
+++ b/drivers/gpu/drm/msm/adreno/adreno_gpu.h
@@ -204,6 +204,8 @@ struct adreno_gpu {
 	struct msm_gpu base;
 	const struct adreno_info *info;
 	uint32_t chip_id;
+	/* GMEM size available to userspace, see a8xx_gpu_get_slice_info(): */
+	uint32_t gmem;
 	uint16_t speedbin;
 	const struct adreno_gpu_funcs *funcs;
 
-- 
2.53.0



