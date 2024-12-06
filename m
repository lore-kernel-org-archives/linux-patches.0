Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0EE610E0;
	Fri,  6 Dec 2024 14:58:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733497138; cv=none; b=IOr228VvTbbfWfdUD/1/X9j4NYJ2NjRerXUcKDeb+s+zAReRl8OfoxH7VJ5DApfmFgEFP8UADYHpLHLgYrDRsl3b5ZucZtTKEi9GiW/LZEbNqxtda6mmFzBzQnSIMrqtu9fRvkFPun4UHQCbCdaxcPm3O75CSsQMMc5ShjE1TtU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733497138; c=relaxed/simple;
	bh=zUGB+xaBsM4Qw2nlRp1XowwuzutWAcVe8BkMLBLlJCE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TwKWdM2S14TkK5vENZEX8huDWi+rjSUXD2VNqWn25wqraXZ5rz8sQKsEDHdAxUU7TjzDc3ntZqyXy+awswhLYbuoZOk6GzehYYVXLZCihsPVl9MvmBfbh2fahFmURxz+YYwI1RVAXFk/fhR6v3Z+X5ZKDZNJCf/VBf503+BvSxo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dvCeb2QY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dvCeb2QY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C39DC4CED1;
	Fri,  6 Dec 2024 14:58:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733497138;
	bh=zUGB+xaBsM4Qw2nlRp1XowwuzutWAcVe8BkMLBLlJCE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dvCeb2QYcL7fu4GvccwN4pSO+Xc6C3mTqz1b9n1BhvEQSF/8jmwGMRpBTRbYBRVdJ
	 W9Gh5RvudUobE5EIP1kFNJVAomlZRxqlLU0v+iGa+zgPbyKL9SwmN7NC+k7gW6LLHt
	 yZ3YHJnVv07xRMb8xCS1HvVZePTKHU73K3yIQTCg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abhinav Kumar <quic_abhinavk@quicinc.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 205/676] drm/msm/dpu: drop LM_3 / LM_4 on MSM8998
Date: Fri,  6 Dec 2024 15:30:24 +0100
Message-ID: <20241206143701.351457097@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

[ Upstream commit c59afe50773d5c972f6684f9bbd9a2ddb2fb92fa ]

On the MSM8998 platform ther are no LM_3 and LM_4 blocks. Drop them from
the MSM8998 catalog.

Fixes: 94391a14fc27 ("drm/msm/dpu1: Add MSM8998 to hw catalog")
Reported-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Reviewed-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Patchwork: https://patchwork.freedesktop.org/patch/612585/
Link: https://lore.kernel.org/r/20240905-dpu-fix-sdm845-catalog-v1-3-3363d03998bd@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../gpu/drm/msm/disp/dpu1/catalog/dpu_3_0_msm8998.h  | 12 ------------
 1 file changed, 12 deletions(-)

diff --git a/drivers/gpu/drm/msm/disp/dpu1/catalog/dpu_3_0_msm8998.h b/drivers/gpu/drm/msm/disp/dpu1/catalog/dpu_3_0_msm8998.h
index 43c47a19cd94f..a857ce8e385fc 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/catalog/dpu_3_0_msm8998.h
+++ b/drivers/gpu/drm/msm/disp/dpu1/catalog/dpu_3_0_msm8998.h
@@ -157,18 +157,6 @@ static const struct dpu_lm_cfg msm8998_lm[] = {
 		.sblk = &msm8998_lm_sblk,
 		.lm_pair = LM_5,
 		.pingpong = PINGPONG_2,
-	}, {
-		.name = "lm_3", .id = LM_3,
-		.base = 0x47000, .len = 0x320,
-		.features = MIXER_MSM8998_MASK,
-		.sblk = &msm8998_lm_sblk,
-		.pingpong = PINGPONG_NONE,
-	}, {
-		.name = "lm_4", .id = LM_4,
-		.base = 0x48000, .len = 0x320,
-		.features = MIXER_MSM8998_MASK,
-		.sblk = &msm8998_lm_sblk,
-		.pingpong = PINGPONG_NONE,
 	}, {
 		.name = "lm_5", .id = LM_5,
 		.base = 0x49000, .len = 0x320,
-- 
2.43.0



