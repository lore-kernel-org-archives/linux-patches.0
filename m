Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F5052F236E;
	Tue, 17 Jun 2025 15:48:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750175335; cv=none; b=WOEQAOe1IeBjK+i8TVtihtDcjojiA/3c/g8m0BbFnaz9OsYVuHfcW4wMqaU5vx4rD8LSB0tPRECwSOSQZAnX6V81LxM9KbQOKSnECXw9MZY9h5uE1HV9e20ub+TvfhL137GnHZKEe1tzoosmMX066/gi8PofPmJ3FbApfMMueKc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750175335; c=relaxed/simple;
	bh=RZgaJDfWLpoEGySOCNA2dlVZm7bE74vYkFx4cU3I6D8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hII1F0TFee8pFSgzeMdytH0K6c32t0QXVUjm0GU36j7WN6U86vEchglamM9dIy4m4IJ7hpjoEW6hAFg2XOissgHA7V38U/kSKYkNdyRJl2FtSMB0IHYaikLBUCRmRKRoNQpVFINu88kGk6o2owcqVXPgCjKoOJAezf6a1rhYojc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bElzat0r; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bElzat0r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16807C4CEF0;
	Tue, 17 Jun 2025 15:48:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750175335;
	bh=RZgaJDfWLpoEGySOCNA2dlVZm7bE74vYkFx4cU3I6D8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bElzat0rygcE813cUgY3fu8rMum1ieCPMeXWOSjG0T9zfXi5IWD0Lz8EeZgTH8nMc
	 oQkQa5h4KbnaADSkzo9bZf37FbQ3Uwq3XVcaNvuxPtnGNu9M9KpXUongrUMJVqCCMk
	 bPOXjHM/7s5odDtwMx/LPjK6ZdItBIpt8/kzfmsY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Akhil P Oommen <quic_akhilpo@quicinc.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Rob Clark <robdclark@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 098/512] drm/msm/a6xx: Disable rgb565_predicator on Adreno 7c3
Date: Tue, 17 Jun 2025 17:21:04 +0200
Message-ID: <20250617152423.569894313@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index d903ad9c0b5fb..d2189441aa38a 100644
--- a/drivers/gpu/drm/msm/adreno/a6xx_gpu.c
+++ b/drivers/gpu/drm/msm/adreno/a6xx_gpu.c
@@ -554,7 +554,6 @@ static void a6xx_calc_ubwc_config(struct adreno_gpu *gpu)
 	if (adreno_is_7c3(gpu)) {
 		gpu->ubwc_config.highest_bank_bit = 14;
 		gpu->ubwc_config.amsbc = 1;
-		gpu->ubwc_config.rgb565_predicator = 1;
 		gpu->ubwc_config.uavflagprd_inv = 2;
 		gpu->ubwc_config.macrotile_mode = 1;
 	}
-- 
2.39.5



