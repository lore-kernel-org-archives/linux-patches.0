Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB90C13AD22;
	Wed,  5 Feb 2025 13:48:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738763326; cv=none; b=dipuP4GOaiHwRx2TTxmz6of7FZ1dJV/Lba3McncjD0Rkn6vw1yJck1/Q/Oqi3U2t0+jvNg01LzkiF8weDFRkHVXjIpXiKqmt1s7boyM/esfGrM896nbBtkl8PB40/qLDssG7ynh1Xvn4CVoM0/AnA7hDOOp0yKOI59f6Z4OOvu4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738763326; c=relaxed/simple;
	bh=/cCArfddFIEobu+nfvLYj1Sc1acZLmelsj/wsLCqrc8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tYL6c6eUWF0709eWPVf7MqHJ0aj+Ay+jbYuny8qIYnehyJD2Rf5hEqtNqwOxigoRHYRMBdkc77J9wVU2GWi+ftV3IWDUXEwhVOeGwYe9UXZ71J5ZhVq8I56NgMfllavOvvHvVfvR6SE5o4LKOCnq2rhsqjUJJx55wJSrCEXMVlc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L56/40SB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L56/40SB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2296EC4CED1;
	Wed,  5 Feb 2025 13:48:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738763326;
	bh=/cCArfddFIEobu+nfvLYj1Sc1acZLmelsj/wsLCqrc8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L56/40SBole36UdA5iOH2gr/quUQ+yCcY0pJF99wTnGkpE8zjtDUU3OPcW/QnvCdx
	 teKn+X2HcxMTxtd8v3GwMrZO4eS9gGQsFSijoiNXSWL+MLALFfKlicaX1Hrl/N+xcq
	 fFiWJc3JJzPEBJmBh6L3SBm9U+aVvwt+1Ya9/p2A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abhinav Kumar <quic_abhinavk@quicinc.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 042/393] drm/msm/dpu: link DSPP_2/_3 blocks on SM8550
Date: Wed,  5 Feb 2025 14:39:21 +0100
Message-ID: <20250205134421.911144279@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134420.279368572@linuxfoundation.org>
References: <20250205134420.279368572@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

[ Upstream commit e21f9d85b05361bc343b11ecf84ac12c9cccbc3e ]

Link DSPP_2 to the LM_2 and DSPP_3 to the LM_3 mixer blocks. This allows
using colour transformation matrix (aka night mode) with more outputs at
the same time.

Fixes: efcd0107727c ("drm/msm/dpu: add support for SM8550")
Reviewed-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Patchwork: https://patchwork.freedesktop.org/patch/629961/
Link: https://lore.kernel.org/r/20241220-dpu-fix-catalog-v2-6-38fa961ea992@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/disp/dpu1/catalog/dpu_9_0_sm8550.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/msm/disp/dpu1/catalog/dpu_9_0_sm8550.h b/drivers/gpu/drm/msm/disp/dpu1/catalog/dpu_9_0_sm8550.h
index 7bed819dfc390..69b238ed01b98 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/catalog/dpu_9_0_sm8550.h
+++ b/drivers/gpu/drm/msm/disp/dpu1/catalog/dpu_9_0_sm8550.h
@@ -181,6 +181,7 @@ static const struct dpu_lm_cfg sm8550_lm[] = {
 		.sblk = &sdm845_lm_sblk,
 		.lm_pair = LM_3,
 		.pingpong = PINGPONG_2,
+		.dspp = DSPP_2,
 	}, {
 		.name = "lm_3", .id = LM_3,
 		.base = 0x47000, .len = 0x320,
@@ -188,6 +189,7 @@ static const struct dpu_lm_cfg sm8550_lm[] = {
 		.sblk = &sdm845_lm_sblk,
 		.lm_pair = LM_2,
 		.pingpong = PINGPONG_3,
+		.dspp = DSPP_3,
 	}, {
 		.name = "lm_4", .id = LM_4,
 		.base = 0x48000, .len = 0x320,
-- 
2.39.5



