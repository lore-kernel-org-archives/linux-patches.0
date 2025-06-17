Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF6B62F2346;
	Tue, 17 Jun 2025 16:00:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750176032; cv=none; b=GY6Bahz7VWRTHVAltcmbQe/re+VC5iksl20/TTG0mTHwQn/l8HBwU3nQZHjwcj9ejY7yUPHmEpdnZP5xtbbqlsG/lzshjQ730dNS97oFu0SKGadE6Mb+fh/FS2gwOTJ+cDIBBMFlKD+tcPR8NvBmeOYtaO1NY65szMVHjScddOg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750176032; c=relaxed/simple;
	bh=a84EBeaHRiQkh+0elfnmRohm/PIbOtkzeNRllRVnWUI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BuMW/wd83ljWemD3yjTV6LLIzOh5pHiEnVmnZ5ovHTyCF++1c5/MytN9FmR09kIrLN+NWDrYWaWsJ3xehcfPRjh01Rx/RMbtljt3I/WEWnd0fJPJM0B2F9He2bI5gcBKzZU1MoQNAzeDZ4Nhu9bSA51My+7svpMVEjXrJZfi7WU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LeByX9vj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LeByX9vj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12F5AC4CEF1;
	Tue, 17 Jun 2025 16:00:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750176031;
	bh=a84EBeaHRiQkh+0elfnmRohm/PIbOtkzeNRllRVnWUI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LeByX9vjh1t/7hL0+F2++CdCBtIhW98l9GoCsA0NjiJpBOlwSdTdX99RqNvXpqySz
	 9VAOK2BB8/ypgeGDn+bm6cwMq8JlKK1AQ6krgAaWcpALtbL13xw4YH7GlsYv6EnjlQ
	 Xk41TmCYsDCTwBAbJGM+8FYUn5gC6Ruz+AgL9ZQ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Akhil P Oommen <quic_akhilpo@quicinc.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Rob Clark <robdclark@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 145/780] drm/msm/a6xx: Disable rgb565_predicator on Adreno 7c3
Date: Tue, 17 Jun 2025 17:17:33 +0200
Message-ID: <20250617152457.413334965@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>

[ Upstream commit 5a9c1bea011fb42088ba08ceaa252fb20e695626 ]

This feature is supposed to be enabled with UBWC v4 or later.
Implementations of this SKU feature an effective UBWC version of 3, so
disable it, in line with the BSP kernel.

Reported-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Reviewed-by: Akhil P Oommen <quic_akhilpo@quicinc.com>
Fixes: 192f4ee3e408 ("drm/msm/a6xx: Add support for Adreno 7c Gen 3 gpu")
Signed-off-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Patchwork: https://patchwork.freedesktop.org/patch/651759/
Signed-off-by: Rob Clark <robdclark@chromium.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/adreno/a6xx_gpu.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/gpu/drm/msm/adreno/a6xx_gpu.c b/drivers/gpu/drm/msm/adreno/a6xx_gpu.c
index 242d02d48c0cd..90991ba5a4ae1 100644
--- a/drivers/gpu/drm/msm/adreno/a6xx_gpu.c
+++ b/drivers/gpu/drm/msm/adreno/a6xx_gpu.c
@@ -655,7 +655,6 @@ static void a6xx_calc_ubwc_config(struct adreno_gpu *gpu)
 	if (adreno_is_7c3(gpu)) {
 		gpu->ubwc_config.highest_bank_bit = 14;
 		gpu->ubwc_config.amsbc = 1;
-		gpu->ubwc_config.rgb565_predicator = 1;
 		gpu->ubwc_config.uavflagprd_inv = 2;
 		gpu->ubwc_config.macrotile_mode = 1;
 	}
-- 
2.39.5



