Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1504C18455E;
	Tue, 30 Jul 2024 16:50:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722358201; cv=none; b=lNLWVMn6ZOmfrXJT3HLdK/08+jzA4G+SDFOKgfBBwZOZtTmjjvs9QDdgplpIJxgfSbtaGnnqeHdKieVocd1qZ+0z5zCZB+IAofxoLOkbtaj+Wgp+wU40FOzQ0gYllbPekUmOWentVhRR4mKPnqvh52cdtLsVB3uUVCKuAIMgto4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722358201; c=relaxed/simple;
	bh=Wn6m4c9XzqDJBw/AdorFUt44GQ4eoCAA9DA13BokzIk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Sxbs3qt+40Be0XPDSfEyUepJdbOE9r63VCNJEpPaSFRvpcrqA/aPI6ia1qFt80cP/tD9q91MhXV2zNtr8rRAILlj9Bvo0Q8Nz0MkCxajx6tZjdsV9/pgDwgaRuUcqAAA8OkrLepIKwCkKE43XySO2JKCv5PN+uI4c3LT07COa3s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bSzDWT0l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bSzDWT0l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 875F9C4AF10;
	Tue, 30 Jul 2024 16:50:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722358200;
	bh=Wn6m4c9XzqDJBw/AdorFUt44GQ4eoCAA9DA13BokzIk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bSzDWT0lsMjI8FPpf8qdUyP7BTwTL4iQrWsQQnmZH0Hhrn7zzCG5O2zxBdIW4HGEq
	 FI4nwdzHmQKf4n/8zApbtHakuKYCbkayLGxkamfGbb2sPbKljHVwoYTITnRQ0WNqi9
	 HOcefb/hbbD/nGxFrFIb4OY1c6mRB41LSTXp7E/M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Connor Abbott <cwabbott0@gmail.com>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Rob Clark <robdclark@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 334/809] drm/msm/a6xx: Fix A702 UBWC mode
Date: Tue, 30 Jul 2024 17:43:30 +0200
Message-ID: <20240730151737.812322640@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konrad Dybcio <konrad.dybcio@linaro.org>

[ Upstream commit 593f1dd4c81f6932042508a80186dbdea90312a5 ]

UBWC_MODE is a one-bit-wide field, so a value of 2 is obviously bogus.

Replace it with the correct value (0).

Fixes: 18397519cb62 ("drm/msm/adreno: Add A702 support")
Reported-by: Connor Abbott <cwabbott0@gmail.com>
Closes: https://lore.kernel.org/linux-arm-msm/CACu1E7FTN=kwaDJMNiTmFspALzj2+Q-nvsN5ugi=vz4RdUGvGw@mail.gmail.com/
Signed-off-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Patchwork: https://patchwork.freedesktop.org/patch/597359/
Signed-off-by: Rob Clark <robdclark@chromium.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/adreno/a6xx_gpu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/msm/adreno/a6xx_gpu.c b/drivers/gpu/drm/msm/adreno/a6xx_gpu.c
index 973872ad0474e..5383aff848300 100644
--- a/drivers/gpu/drm/msm/adreno/a6xx_gpu.c
+++ b/drivers/gpu/drm/msm/adreno/a6xx_gpu.c
@@ -1409,7 +1409,7 @@ static void a6xx_calc_ubwc_config(struct adreno_gpu *gpu)
 	if (adreno_is_a702(gpu)) {
 		gpu->ubwc_config.highest_bank_bit = 14;
 		gpu->ubwc_config.min_acc_len = 1;
-		gpu->ubwc_config.ubwc_mode = 2;
+		gpu->ubwc_config.ubwc_mode = 0;
 	}
 }
 
-- 
2.43.0



