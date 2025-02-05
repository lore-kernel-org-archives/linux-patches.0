Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E13614D28C;
	Wed,  5 Feb 2025 13:57:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738763874; cv=none; b=HA8p4CGDupYVkBeyLSNpkwQuUwC/fMUQGUhsAy3GIbac8OgyWT3ewEH7bbVuDP9dI56TBpWEd+47zFPzecDh/8HUvV0o+B3clXEBEC9Fp4TXAzLH+ls35fjAHE2PDTW/Fv75NsmkmbV4Zx+NqtRmna9C31xzkAwJBOAlfEFN2Sg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738763874; c=relaxed/simple;
	bh=zZDfu6Zj0/ojkkhk+zeekD9cwqYKUQluwNKbUyrpr60=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zl1S3MX42d9HbXlWhb4nHV1tEK7pKk7rIX+gKQZQw2K8vyIwE5wSWN3vDHjQqRu1w1vAafwqKSODjvMbDiZxwziAwghgJjMCMhurPQdzxIkbw48tVu1wsFaqRhpVCJ9pqeLVOaw5S1MOyPbxZgIBSEwJIDzSps1zRmWhPwJLjEk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bURrGW/J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bURrGW/J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D234C4CED6;
	Wed,  5 Feb 2025 13:57:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738763874;
	bh=zZDfu6Zj0/ojkkhk+zeekD9cwqYKUQluwNKbUyrpr60=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bURrGW/J8C55s24fwJix3CBFnrUMBhOXb1LOMmQc6e/JoFY9qymQvIyXyCgh0mqco
	 xxN/HdervnDpGvnRTTu2wTVeoLdv1TpkbPapmUiyCDvhOWWxUYaqEXKuMpB8MWm0gk
	 w/twRACfZi4+vr9uviVKMROVah6TVWEmC0lLNP8o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abhinav Kumar <quic_abhinavk@quicinc.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 062/590] drm/msm/dpu: link DSPP_2/_3 blocks on SM8350
Date: Wed,  5 Feb 2025 14:36:57 +0100
Message-ID: <20250205134457.630144484@linuxfoundation.org>
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



