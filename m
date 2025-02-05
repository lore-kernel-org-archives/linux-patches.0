Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6243914EC77;
	Wed,  5 Feb 2025 14:05:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738764350; cv=none; b=RsG6dlLKZqNqZ2HalF6VMpm+DfvbcOrCSGCLX+uhb6FEs+mu5ch4yVrKwIDd2R1qwulXhKe4fydXd0twd5W2nYHX8oLJjGBRr8ZC2UjCGsD2vKEVFykowdnwNEZbQVvBJ7TD/7OuNo+RKaLyfVdJW4uxQsCYaHLA8cQZQICADak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738764350; c=relaxed/simple;
	bh=7Knvhry74IJS7ZlZyYhQTmLrL/2v/aN4YyxgKTyAhDE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BgbfrByld4N34twAnAUEPAATq+y+sCsm0Qf8YGRyr6OX8vgOjj4y1wS4Q5I7uRf3Wyd9LwzlvVwQdY+Uc0L7qeD4fWB5NKYpFrZwKNONvOWq0OFHPEb912evyDEaVN6NMLSczLWerawp4qHQd3k9HAeUkSVB/IczELakE3dUZuQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ywiWEJZg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ywiWEJZg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D49FAC4CEE2;
	Wed,  5 Feb 2025 14:05:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738764350;
	bh=7Knvhry74IJS7ZlZyYhQTmLrL/2v/aN4YyxgKTyAhDE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ywiWEJZgMFHnAF4K0HD5x6+vV+vd10Qcxjbsk63HNkmpCDVK41KB+no/wn0vQ1Z4L
	 RbGlF1yOMrLlwK23itF6w4LLi4MaN6WaF2iiXdALxkIAhqRWsoQ6VfGlyU4Aco3IYp
	 SIUPkME7iz6cl/T49VQZ6fs1B5xh+ep1fdw0Xn1w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abhinav Kumar <quic_abhinavk@quicinc.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 070/623] drm/msm/dpu: link DSPP_2/_3 blocks on SM8250
Date: Wed,  5 Feb 2025 14:36:52 +0100
Message-ID: <20250205134458.905542371@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

[ Upstream commit 8252028092f86d413b3a83e5e76a9615073a0c7f ]

Link DSPP_2 to the LM_2 and DSPP_3 to the LM_3 mixer blocks. This allows
using colour transformation matrix (aka night mode) with more outputs at
the same time.

Fixes: 05ae91d960fd ("drm/msm/dpu: enable DSPP support on SM8[12]50")
Reviewed-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Patchwork: https://patchwork.freedesktop.org/patch/629956/
Link: https://lore.kernel.org/r/20241220-dpu-fix-catalog-v2-4-38fa961ea992@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/disp/dpu1/catalog/dpu_6_0_sm8250.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/msm/disp/dpu1/catalog/dpu_6_0_sm8250.h b/drivers/gpu/drm/msm/disp/dpu1/catalog/dpu_6_0_sm8250.h
index a57d50b1f0280..e8916ae826a6d 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/catalog/dpu_6_0_sm8250.h
+++ b/drivers/gpu/drm/msm/disp/dpu1/catalog/dpu_6_0_sm8250.h
@@ -162,6 +162,7 @@ static const struct dpu_lm_cfg sm8250_lm[] = {
 		.sblk = &sdm845_lm_sblk,
 		.lm_pair = LM_3,
 		.pingpong = PINGPONG_2,
+		.dspp = DSPP_2,
 	}, {
 		.name = "lm_3", .id = LM_3,
 		.base = 0x47000, .len = 0x320,
@@ -169,6 +170,7 @@ static const struct dpu_lm_cfg sm8250_lm[] = {
 		.sblk = &sdm845_lm_sblk,
 		.lm_pair = LM_2,
 		.pingpong = PINGPONG_3,
+		.dspp = DSPP_3,
 	}, {
 		.name = "lm_4", .id = LM_4,
 		.base = 0x48000, .len = 0x320,
-- 
2.39.5



