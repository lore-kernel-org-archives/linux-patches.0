Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EC3B1E2834;
	Wed, 25 Feb 2026 01:31:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983106; cv=none; b=mVKFxs87ed8fKOhsEMwv6hRnI5gtXvTHgLi28dOt3P23k76SrrC+sQEA9j8TuD6IZpDnBYULEvTR3BfxNjb3ZFZA6G3GH7KWJ89QTlv4xleYrd297yzsQfiLfI1mCf9bK0s0dVHxDZKCKf8qtHARJRQgeODEP6g1x5iDgQn8zUM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983106; c=relaxed/simple;
	bh=DKlNsy6T1Lw1jOAdIzz0cg53XACcuxEtUGmF2X5i/GU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Yse5gtK8a7VeDEgcSA46r5/cE302kPH4sBBGx8PzLHXzj7THHogbd6qUlF2B14pNYeAcquxQmOcXrlxOT/UjMzZ1inf52UsZZyCr7hj9XE6MVhUlS4VHHrl6aEslEVx76jzrAmn6YqF97vAgnA3nvXHIV0ahXmnDWEbRr0evm44=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=koVs2nQx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="koVs2nQx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8D9BC116D0;
	Wed, 25 Feb 2026 01:31:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983105;
	bh=DKlNsy6T1Lw1jOAdIzz0cg53XACcuxEtUGmF2X5i/GU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=koVs2nQxaImOvU/WHmhr7u1WRekxoFNwpMMIoJUW6gbh8H+0+UQKVTxgwRmZYWzrr
	 gjj3T1TwEmepghGr5vdNUDuyMGFUFcCjFa6KZKGF4zBBOVufpXnj7N0IjW9m374/jO
	 Nhy9WkZrMq/ox4RRVxI+20p7PCetUwL66O0rQt7k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rob Clark <robin.clark@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 267/781] drm/msm: Fix GMEM_BASE for gen8
Date: Tue, 24 Feb 2026 17:16:16 -0800
Message-ID: <20260225012406.247677855@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rob Clark <robin.clark@oss.qualcomm.com>

[ Upstream commit dc220915ddb2d1c646a7d0816b398e73ed5a5d50 ]

This should also be zero for gen8.  This does change a7xx-gen1 to zero.
It was almost certainly incorrect before, but we have no such devices in
CI currently.

Fixes: 288a93200892 ("drm/msm/adreno: Introduce A8x GPU Support")
Signed-off-by: Rob Clark <robin.clark@oss.qualcomm.com>
Patchwork: https://patchwork.freedesktop.org/patch/697779/
Message-ID: <20260109153730.130462-3-robin.clark@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/adreno/adreno_gpu.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/msm/adreno/adreno_gpu.c b/drivers/gpu/drm/msm/adreno/adreno_gpu.c
index 1c80909e63cab..d5fe6f6f0decc 100644
--- a/drivers/gpu/drm/msm/adreno/adreno_gpu.c
+++ b/drivers/gpu/drm/msm/adreno/adreno_gpu.c
@@ -376,8 +376,7 @@ int adreno_get_param(struct msm_gpu *gpu, struct msm_context *ctx,
 		*value = adreno_gpu->info->gmem;
 		return 0;
 	case MSM_PARAM_GMEM_BASE:
-		if (adreno_is_a650_family(adreno_gpu) ||
-		    adreno_is_a740_family(adreno_gpu))
+		if (adreno_gpu->info->family >= ADRENO_6XX_GEN4)
 			*value = 0;
 		else
 			*value = 0x100000;
-- 
2.51.0



