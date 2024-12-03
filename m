Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8AE72C80;
	Tue,  3 Dec 2024 15:47:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733240859; cv=none; b=EW1xUSDRZxfzlv4zo49XYtPYZ3hzXudss58VNiWV9P7rVKJUwBKjOVE6pp2zcMi17nBpyWMFN9FLqXbi93qwoEeoEzJp1jXUKrxCcpDCDjZAFzwJjBsDvcEIkrukQDYecm3AF+yqRcnIuLL37LktHTBdEi8nl8txF62prTIvdgE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733240859; c=relaxed/simple;
	bh=7r4kXU2LyeQpwOKTx2pIz9YxC6/dAgJQdv0ZR7ug26c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZEZ/ebkGefmSu4s9di7kKfhSxQJ6A2Ibs7G4tsn5lO9Xt4LTxtKiuSBKKaH+2nSVbR0F9vETijmBa+jXy+A/sLoXk4GEZR6itxJ22gy3qk+7UqSdEXdrtqi4gp60K1tAB7tGBq4+do4GUNSRJ3mTR6PEiMGVAhH8YdIEbq9FbDs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=si6EKDPA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="si6EKDPA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55BAFC4CECF;
	Tue,  3 Dec 2024 15:47:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733240859;
	bh=7r4kXU2LyeQpwOKTx2pIz9YxC6/dAgJQdv0ZR7ug26c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=si6EKDPAI+h20E2wHJEVMG5FJ5VCmXLX090pYK3+VaABUJyTYxqKL/yFejIqi2OmN
	 G5/JHEnLM6IzZhs99Wqk+QinT3zyliv2+L2udh5Dwu3LmyPcODwd2U1BOLmrjki9fK
	 pa8c346Weob5655pNr28TF8hEQJs5OmhdvHZ8moc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Abhinav Kumar <quic_abhinavk@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 257/826] drm/msm/dpu: drop LM_3 / LM_4 on SDM845
Date: Tue,  3 Dec 2024 15:39:44 +0100
Message-ID: <20241203144753.791367559@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

[ Upstream commit d39271061d67c6fcbe8f361c532b493069232cf8 ]

On the SDM845 platform ther are no LM_3 and LM_4 blocks. Drop them from
the SDM845 catalog.

Fixes: 25fdd5933e4c ("drm/msm: Add SDM845 DPU support")
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Reviewed-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Patchwork: https://patchwork.freedesktop.org/patch/612586/
Link: https://lore.kernel.org/r/20240905-dpu-fix-sdm845-catalog-v1-2-3363d03998bd@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../gpu/drm/msm/disp/dpu1/catalog/dpu_4_0_sdm845.h   | 12 ------------
 1 file changed, 12 deletions(-)

diff --git a/drivers/gpu/drm/msm/disp/dpu1/catalog/dpu_4_0_sdm845.h b/drivers/gpu/drm/msm/disp/dpu1/catalog/dpu_4_0_sdm845.h
index 59eeea3dd2e9f..72bd4f7e9e504 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/catalog/dpu_4_0_sdm845.h
+++ b/drivers/gpu/drm/msm/disp/dpu1/catalog/dpu_4_0_sdm845.h
@@ -155,18 +155,6 @@ static const struct dpu_lm_cfg sdm845_lm[] = {
 		.lm_pair = LM_5,
 		.pingpong = PINGPONG_2,
 		.dspp = DSPP_2,
-	}, {
-		.name = "lm_3", .id = LM_3,
-		.base = 0x0, .len = 0x320,
-		.features = MIXER_SDM845_MASK,
-		.sblk = &sdm845_lm_sblk,
-		.pingpong = PINGPONG_NONE,
-	}, {
-		.name = "lm_4", .id = LM_4,
-		.base = 0x0, .len = 0x320,
-		.features = MIXER_SDM845_MASK,
-		.sblk = &sdm845_lm_sblk,
-		.pingpong = PINGPONG_NONE,
 	}, {
 		.name = "lm_5", .id = LM_5,
 		.base = 0x49000, .len = 0x320,
-- 
2.43.0



