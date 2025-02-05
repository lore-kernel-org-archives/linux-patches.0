Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E4D0155335;
	Wed,  5 Feb 2025 14:06:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738764360; cv=none; b=mDPVCR79MQmq8QS5MVILmSKZP0jeXDs3X8glt8CHfx5+jAYU+r15tsqZcu5emTztjbUFAERwp/zD4XkwG4TlLOxz93hUOWSebHLyFIGSu+PPrnFzzZeXlAFg11QyZnPWrylUHKYOAXeFld2TmDZjHmJOpYGiOWjn4DinzRQ+9DY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738764360; c=relaxed/simple;
	bh=OzkhrP4e3uqsUrg3bRZSnZYS238JWFZ69/GuUxekMmQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KWvW8wCy11mCEAxdKuNw+tRfenAusicg9wvBoFuk8FX3ts4SDCbNBFkAbtSPiE40Uj5Wzf4tWwsgO3JWQVbne5eiLI/ZbEfZhCutZLA0qgYHGGgPkgyAqhAVmWdXCcIA2GjcM6KjhmicaZBsalHDcQPQzBypIj/a2l/VKXsdTE4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IstP9vvI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IstP9vvI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C69FC4CED1;
	Wed,  5 Feb 2025 14:05:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738764360;
	bh=OzkhrP4e3uqsUrg3bRZSnZYS238JWFZ69/GuUxekMmQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IstP9vvI9rR2hF3ejHFc87a6xOqWXL+omIG56b4u1TuNCrPg7XraBpCfLVXxt8P3R
	 nc+I9caeC14jrK/i2hqhbZ9UxzihVrVsUMJcgs7PqqZziFGmxeh7hKlA5/HsRxC+Jl
	 G4uLmPSU6RFB8h65RrpwL3aVcapa4jTqGvx8Qp2o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abhinav Kumar <quic_abhinavk@quicinc.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 071/623] drm/msm/dpu: link DSPP_2/_3 blocks on SM8350
Date: Wed,  5 Feb 2025 14:36:53 +0100
Message-ID: <20250205134458.943164078@linuxfoundation.org>
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
index aced16e350daa..f7c08e89c8820 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/catalog/dpu_7_0_sm8350.h
+++ b/drivers/gpu/drm/msm/disp/dpu1/catalog/dpu_7_0_sm8350.h
@@ -162,6 +162,7 @@ static const struct dpu_lm_cfg sm8350_lm[] = {
 		.sblk = &sdm845_lm_sblk,
 		.lm_pair = LM_3,
 		.pingpong = PINGPONG_2,
+		.dspp = DSPP_2,
 	}, {
 		.name = "lm_3", .id = LM_3,
 		.base = 0x47000, .len = 0x320,
@@ -169,6 +170,7 @@ static const struct dpu_lm_cfg sm8350_lm[] = {
 		.sblk = &sdm845_lm_sblk,
 		.lm_pair = LM_2,
 		.pingpong = PINGPONG_3,
+		.dspp = DSPP_3,
 	}, {
 		.name = "lm_4", .id = LM_4,
 		.base = 0x48000, .len = 0x320,
-- 
2.39.5



