Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 277791459F6;
	Wed,  5 Feb 2025 13:48:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738763323; cv=none; b=AS7e0YJLZ/+YZBJktIwnGSFfUd4eDmg1xPq34ueew4ftJwf8FeQbLj0NSWkrwY2KanqDfcVoXN+Mh4jVE91IJfNkeqJu8Oyp9wMA60zud5rW5e0SNPsw3or2phMCSoEes8ksr6WLV4XOdV/6/rN02m0isLZPLrVI4d7s579kH2M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738763323; c=relaxed/simple;
	bh=L7YTstpm2YhFBROkeOsiXLBWjqcf9PZsv56cIQkyIF0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YISBzUJimabild3cue4B515uA67lNdFZ7F+dauWiVDCvtOueEKTD+z6Y36HCvF8rZFRihR4jVAjEjko3fldQa2RUsiz5ZtmOrdQgfaYZ25tJKp00Qdquf9k2NYj0kCvy5xyULMkXev6utpEDQOR4IH5kmthMRhgLlm3B3vwMGS0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NT/KhPwf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NT/KhPwf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88D6DC4CED1;
	Wed,  5 Feb 2025 13:48:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738763323;
	bh=L7YTstpm2YhFBROkeOsiXLBWjqcf9PZsv56cIQkyIF0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NT/KhPwf55jmiDqgnz3NZr3Jxv2epRTYMlKwJ5I/BzFUuFbg5c9ll+WogtZVAmDre
	 oIeTXOhSrMZhtDQWKm5ifIvX4SRM4E4dC5Ps7NF25FxRqhsozt77nywkjOR4czSAfQ
	 piPu21k5nxm9s9c1YZs1lXCirz/D88NOB+f8VEhA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abhinav Kumar <quic_abhinavk@quicinc.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 041/393] drm/msm/dpu: link DSPP_2/_3 blocks on SM8350
Date: Wed,  5 Feb 2025 14:39:20 +0100
Message-ID: <20250205134421.873415303@linuxfoundation.org>
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

[ Upstream commit 42323d3c9e04c725d27606c31663b80a7cc30218 ]

Link DSPP_2 to the LM_2 and DSPP_3 to the LM_3 mixer blocks. This allows
using colour transformation matrix (aka night mode) with more outputs at
the same time.

Fixes: 0e91bcbb0016 ("drm/msm/dpu: Add SM8350 to hw catalog")
Reviewed-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Patchwork: https://patchwork.freedesktop.org/patch/629959/
Link: https://lore.kernel.org/r/20241220-dpu-fix-catalog-v2-5-38fa961ea992@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/disp/dpu1/catalog/dpu_7_0_sm8350.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/msm/disp/dpu1/catalog/dpu_7_0_sm8350.h b/drivers/gpu/drm/msm/disp/dpu1/catalog/dpu_7_0_sm8350.h
index 428bcbcfbf192..e2f181077d11e 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/catalog/dpu_7_0_sm8350.h
+++ b/drivers/gpu/drm/msm/disp/dpu1/catalog/dpu_7_0_sm8350.h
@@ -163,6 +163,7 @@ static const struct dpu_lm_cfg sm8350_lm[] = {
 		.sblk = &sdm845_lm_sblk,
 		.lm_pair = LM_3,
 		.pingpong = PINGPONG_2,
+		.dspp = DSPP_2,
 	}, {
 		.name = "lm_3", .id = LM_3,
 		.base = 0x47000, .len = 0x320,
@@ -170,6 +171,7 @@ static const struct dpu_lm_cfg sm8350_lm[] = {
 		.sblk = &sdm845_lm_sblk,
 		.lm_pair = LM_2,
 		.pingpong = PINGPONG_3,
+		.dspp = DSPP_3,
 	}, {
 		.name = "lm_4", .id = LM_4,
 		.base = 0x48000, .len = 0x320,
-- 
2.39.5



