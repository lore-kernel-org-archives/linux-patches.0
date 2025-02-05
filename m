Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF8851494DF;
	Wed,  5 Feb 2025 13:48:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738763319; cv=none; b=Sqrt87I8KklJ/nnaxzn0w/1ANdMLRO690vGz/TgMyV46T5fs1HU40t5nkP7PRdqeILMEqP+PWjm1ugkMNIqNEQY1ASqCq+zWJlNcgYR9rVGisbhWDWnh6uTDlSkRai9MnJLL3xb4sjDmSpL6BsSSMo//g27mrAaiDeQJeHKD2b0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738763319; c=relaxed/simple;
	bh=FeH52IWE1kq3YxEd58ji2H1kwLwdjCqRINltz7w/0SM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LyJln1TYyMb9co3gcWU6BxxOFobIpsA/6ij/vM8y442uKcCrdS4QY6rmykWcrpF4b6/33AjfWgwxae6q7Dv1Umb3VGnIBscydD6aFTN1Z7bsQzgsZsJhZ87ZCt5J8qQBzjg7BdgitA9dmChSjBbomg05w4+ajRDbHY/m6jkqXYM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r8yWA5EF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r8yWA5EF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A803C4CED1;
	Wed,  5 Feb 2025 13:48:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738763319;
	bh=FeH52IWE1kq3YxEd58ji2H1kwLwdjCqRINltz7w/0SM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r8yWA5EFQakqgljKoxgaCnOm2ul1aLonCGt/wgx6QaK0tVG3OeXiD/R9qQD1P3Quk
	 XgNDrKvCtkMKzusV6D9abjgqVKcMW2rURDc77gnG0wpMSHIetV5/IgUsIGubI+kagT
	 tpuxhkl6JbRRQulK+B1Q3s/ET5jHo46A1sruWz9s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abhinav Kumar <quic_abhinavk@quicinc.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 040/393] drm/msm/dpu: link DSPP_2/_3 blocks on SM8250
Date: Wed,  5 Feb 2025 14:39:19 +0100
Message-ID: <20250205134421.835287699@linuxfoundation.org>
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
index ee781037ada93..a38fb057ceda6 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/catalog/dpu_6_0_sm8250.h
+++ b/drivers/gpu/drm/msm/disp/dpu1/catalog/dpu_6_0_sm8250.h
@@ -163,6 +163,7 @@ static const struct dpu_lm_cfg sm8250_lm[] = {
 		.sblk = &sdm845_lm_sblk,
 		.lm_pair = LM_3,
 		.pingpong = PINGPONG_2,
+		.dspp = DSPP_2,
 	}, {
 		.name = "lm_3", .id = LM_3,
 		.base = 0x47000, .len = 0x320,
@@ -170,6 +171,7 @@ static const struct dpu_lm_cfg sm8250_lm[] = {
 		.sblk = &sdm845_lm_sblk,
 		.lm_pair = LM_2,
 		.pingpong = PINGPONG_3,
+		.dspp = DSPP_3,
 	}, {
 		.name = "lm_4", .id = LM_4,
 		.base = 0x48000, .len = 0x320,
-- 
2.39.5



