Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DEA61519AA;
	Wed,  5 Feb 2025 14:05:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738764337; cv=none; b=f14qUjC2sRvaYou9886vJj83bIdQ7EnM10aPtvod8+rpPQZrW76R6HahnV0+r/CbKoS6H/T4N+16c+T/vGX2ilMYWi6icUSwxjTtsaQX+I9DY+nOqfO1+QXt0U3fJJoB1dnYRQV4tMH8fG6RL+yDcIT2MSqi3NP23OCudK0g1bQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738764337; c=relaxed/simple;
	bh=wgPqjUKi/vbc4oHyPAGUAvWhJnrDvX5sLuCxEq5i4IE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G89g753QK0vE4v0R12uUK0KWiJ/e7/uQ1AjxAvMYM+oiraNh/peX5CWOFTFDBLozsSQQQnkLAj3/NQOcHAuqpgI3zH6hvOhfZWjQewvpbFCHNVKReKn90LxQKPcWSbnEd2WuPEo5Tvh9dow0fVBhFkNp4/LxIjr4qBkKiq7CnCk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P8o+ePoO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P8o+ePoO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2034C4CED1;
	Wed,  5 Feb 2025 14:05:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738764337;
	bh=wgPqjUKi/vbc4oHyPAGUAvWhJnrDvX5sLuCxEq5i4IE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P8o+ePoOI2SANJx/h2HSB7BZWW3iIDFvnBl/h3HoXz5Wy2R44Peen2AJRdJeYjAQ4
	 iupWV5oIWZ02mgEOEUsFiqHJZi3r5632EdAxy8huJ3SZnrkYH394TdfItAla7Rc/iG
	 NClDB1PT+AOh8NXmSXp89VdI/UL1sjCJRG4edOz0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abhinav Kumar <quic_abhinavk@quicinc.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 069/623] drm/msm/dpu: link DSPP_2/_3 blocks on SC8180X
Date: Wed,  5 Feb 2025 14:36:51 +0100
Message-ID: <20250205134458.867017100@linuxfoundation.org>
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

[ Upstream commit 0986163245df6bece47113e506143a7e87b0097d ]

Link DSPP_2 to the LM_2 and DSPP_3 to the LM_3 mixer blocks. This allows
using colour transformation matrix (aka night mode) with more outputs at
the same time.

Fixes: f5abecfe339e ("drm/msm/dpu: enable DSPP and DSC on sc8180x")
Reviewed-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Patchwork: https://patchwork.freedesktop.org/patch/629954/
Link: https://lore.kernel.org/r/20241220-dpu-fix-catalog-v2-3-38fa961ea992@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/disp/dpu1/catalog/dpu_5_1_sc8180x.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/msm/disp/dpu1/catalog/dpu_5_1_sc8180x.h b/drivers/gpu/drm/msm/disp/dpu1/catalog/dpu_5_1_sc8180x.h
index bab19ddd1d4f9..641023b102bf5 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/catalog/dpu_5_1_sc8180x.h
+++ b/drivers/gpu/drm/msm/disp/dpu1/catalog/dpu_5_1_sc8180x.h
@@ -163,6 +163,7 @@ static const struct dpu_lm_cfg sc8180x_lm[] = {
 		.sblk = &sdm845_lm_sblk,
 		.lm_pair = LM_3,
 		.pingpong = PINGPONG_2,
+		.dspp = DSPP_2,
 	}, {
 		.name = "lm_3", .id = LM_3,
 		.base = 0x47000, .len = 0x320,
@@ -170,6 +171,7 @@ static const struct dpu_lm_cfg sc8180x_lm[] = {
 		.sblk = &sdm845_lm_sblk,
 		.lm_pair = LM_2,
 		.pingpong = PINGPONG_3,
+		.dspp = DSPP_3,
 	}, {
 		.name = "lm_4", .id = LM_4,
 		.base = 0x48000, .len = 0x320,
-- 
2.39.5



