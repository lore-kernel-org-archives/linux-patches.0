Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 836C1155327;
	Wed,  5 Feb 2025 14:00:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738764024; cv=none; b=bBukGVKEG7KO9WR+4iX6DLK7oHdKSaGQg64bG9P8gqVFSOlysnI6RlOCG/c4wuv1uIyAifAzWUGaI5ekcQzks5BTWmo1qCdiKzGNhb/cT5/6aRXiVX68dgImSkKYEical6uwTytVJcBwXg3EPXwOJZC8MoIr7PIC8I44fGr4O3k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738764024; c=relaxed/simple;
	bh=JcQ1qezCeCe5wLD6mZE4dyZUTENwCKaN38laOUQRmlI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hh1sqSWDrtM63sbQ5kIDCEP/VzgERUSc/oZkGhzqySICYthEuOueQfWBiT9HuAt/cOorr7t1P53dZX8MDby4xp1czAngRPNbIJ6n5GAI99rxT3MXjbADXFIOm/N+4buiHNIjDIJT/qOtOSzyqii3xB+Xnjl3gZc9sJuqod4jmeE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SC6xwjly; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SC6xwjly"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03349C4CED1;
	Wed,  5 Feb 2025 14:00:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738764024;
	bh=JcQ1qezCeCe5wLD6mZE4dyZUTENwCKaN38laOUQRmlI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SC6xwjlyxwX1ldkbWdX2UZYyUf1iWn3QBj2Wqb+WynpKI2/G+KUG2V1XLROuKt8sU
	 vS68VpyNMnbVIg2LW4i5+VC9nRsII6oz7X36R2houqaQRJ0FBYve/ppJ71lMb+TIua
	 zOxrlmkAK4ukvQxA7WykLYxn91JZ+a9+U77DXXkY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abhinav Kumar <quic_abhinavk@quicinc.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 064/590] drm/msm/dpu: link DSPP_2/_3 blocks on SM8650
Date: Wed,  5 Feb 2025 14:36:59 +0100
Message-ID: <20250205134457.705300668@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
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

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

[ Upstream commit 3d3ca0915aa3692a837f7235ca9d12db26f09911 ]

Link DSPP_2 to the LM_2 and DSPP_3 to the LM_3 mixer blocks. This allows
using colour transformation matrix (aka night mode) with more outputs at
the same time.

Fixes: b94747f7d8c7 ("drm/msm/dpu: add support for SM8650 DPU")
Reviewed-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Patchwork: https://patchwork.freedesktop.org/patch/629962/
Link: https://lore.kernel.org/r/20241220-dpu-fix-catalog-v2-7-38fa961ea992@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/disp/dpu1/catalog/dpu_10_0_sm8650.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/msm/disp/dpu1/catalog/dpu_10_0_sm8650.h b/drivers/gpu/drm/msm/disp/dpu1/catalog/dpu_10_0_sm8650.h
index eb5dfff2ec4f4..e187e7b1cef16 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/catalog/dpu_10_0_sm8650.h
+++ b/drivers/gpu/drm/msm/disp/dpu1/catalog/dpu_10_0_sm8650.h
@@ -160,6 +160,7 @@ static const struct dpu_lm_cfg sm8650_lm[] = {
 		.sblk = &sdm845_lm_sblk,
 		.lm_pair = LM_3,
 		.pingpong = PINGPONG_2,
+		.dspp = DSPP_2,
 	}, {
 		.name = "lm_3", .id = LM_3,
 		.base = 0x47000, .len = 0x400,
@@ -167,6 +168,7 @@ static const struct dpu_lm_cfg sm8650_lm[] = {
 		.sblk = &sdm845_lm_sblk,
 		.lm_pair = LM_2,
 		.pingpong = PINGPONG_3,
+		.dspp = DSPP_3,
 	}, {
 		.name = "lm_4", .id = LM_4,
 		.base = 0x48000, .len = 0x400,
-- 
2.39.5



