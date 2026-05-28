Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78362304BB3;
	Thu, 28 May 2026 20:06:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779998809; cv=none; b=TcEATk1sK+rnwYnxICajJW1Knot2/JHSc3xpG6UGwbfZf0fNZGgsgqULtFG2xdFNjl/R2dYGgVif9JMKIQb1lTn79yB7FpWfYwEogbz2XELJVoq0FzZeTvYxiUxdsP9CQvIHf2Ovko5++lDdl2HDUWQ0hCxrZthpka07aVpj5Mg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779998809; c=relaxed/simple;
	bh=gci3qXWfMs1+w4Y9smnPvbkKyqekafd1WyYWHPThfyc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uoP7SMkCcDYlgEqTLwFR2j3uDUiRwg4zCyAr+IHbQIELQfSs3BKftxgx0QLQTuBqjDUCXEK9n218liBpEUEfQbAsojCVHdRtDrI9C7tRQjX/mxKjCWaztt37mxzYT0oUE9kA02126MCn4jhudsKw780oamqi5b9PQiNxDm0olD4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wWLQCojx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wWLQCojx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE60E1F000E9;
	Thu, 28 May 2026 20:06:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779998808;
	bh=R7gXULahR6PWrK1h3elYDumNVPPblUsp702TsV1wM4I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wWLQCojxhPxCU80u7QYXiI5wWTyIEYKHKoqLI36ZdycDdvR/BYOYpPoUUqZGBDLbA
	 K9DXKPsXzxVWHXc+B6Rb0LOR+H+Juel20loTGqUmjX+jUI8S3NaG4ThiLZqEnLVdgK
	 eWioBEXV9BSr8yq6qF/Z1CGg3wg0lxBsCfs2muFs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Koskovich <akoskovich@pm.me>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Akhil P Oommen <akhilpo@oss.qualcomm.com>,
	Rob Clark <robin.clark@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 304/461] drm/msm: Fix GMEM_BASE for A650
Date: Thu, 28 May 2026 21:47:13 +0200
Message-ID: <20260528194656.066646093@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194646.819809818@linuxfoundation.org>
References: <20260528194646.819809818@linuxfoundation.org>
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

From: Alexander Koskovich <akoskovich@pm.me>

[ Upstream commit 46e351e84853dda726072bb3d38ba7bd63e7532b ]

Commit dc220915ddb2 ("drm/msm: Fix GMEM_BASE for gen8") changed the
GMEM_BASE check from adreno_is_a650_family() & adreno_is_a740_family()
to family >= ADRENO_6XX_GEN4.

This inadvertently excluded A650 (ADRENO_6XX_GEN3), causing it to report
an incorrect GMEM_BASE which results in severe rendering corruption.

Update check to also include ADRENO_6XX_GEN3 to fix A650.

Fixes: dc220915ddb2 ("drm/msm: Fix GMEM_BASE for gen8")
Signed-off-by: Alexander Koskovich <akoskovich@pm.me>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Reviewed-by: Akhil P Oommen <akhilpo@oss.qualcomm.com>
Patchwork: https://patchwork.freedesktop.org/patch/711880/
Message-ID: <20260314-fix-gmem-base-a650-v1-1-3308f60cf74c@pm.me>
Signed-off-by: Rob Clark <robin.clark@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/adreno/adreno_gpu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/msm/adreno/adreno_gpu.c b/drivers/gpu/drm/msm/adreno/adreno_gpu.c
index 785e99fb5bd5d..8bf19e72e5bcd 100644
--- a/drivers/gpu/drm/msm/adreno/adreno_gpu.c
+++ b/drivers/gpu/drm/msm/adreno/adreno_gpu.c
@@ -376,7 +376,7 @@ int adreno_get_param(struct msm_gpu *gpu, struct msm_context *ctx,
 		*value = adreno_gpu->info->gmem;
 		return 0;
 	case MSM_PARAM_GMEM_BASE:
-		if (adreno_gpu->info->family >= ADRENO_6XX_GEN4)
+		if (adreno_gpu->info->family >= ADRENO_6XX_GEN3)
 			*value = 0;
 		else
 			*value = 0x100000;
-- 
2.53.0



