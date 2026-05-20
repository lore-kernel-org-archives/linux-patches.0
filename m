Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8437372B31;
	Wed, 20 May 2026 16:41:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779295304; cv=none; b=R/SIOcg5mSAxCkxTHwTRhB2sCAi7Kog/eKmnVJ58QgmJ6dc9rlYhIPads/AF4XIY9eDEfGcXg0E3LP2jNdSkid9eHFlGe9rOgjQqBzcCzjBK+LBDC5LmudiUqbPERpGQhe8npO8XbCGRUpKDZUinEcnwp0jdRuIYxpAOqIQ/o30=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779295304; c=relaxed/simple;
	bh=YgDYFhd/v3/yUOL1cDhg0PG5JY1MvNQJmrPtw6IZSAs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VODumibHwhYKajc8MbAxlXa9E+a1DrtDRm3oX0LM5lhaUJ/nUiwMuCmjr5h9EBdZe+4jVblfHCO5u4A1dHarW+B2dkGZLEpZz3Qx3AH9WnGVn/En7MUvYjpYrghuk9nbI9bFp9NVvUzCACbQZdyGrSJUfaErUqA7rHB6fiVgIFs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SDQXOH3K; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SDQXOH3K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29E811F000E9;
	Wed, 20 May 2026 16:41:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779295303;
	bh=SadrXLWub/UCfZJ/NV3P2yk/LWdBZOrHIUfbl/Ue56s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SDQXOH3Kt/PMSweskbe+PO8IN2bQxdOVxpBZ+4lkvBakUim+ze/C9+EP6HKAWwAYf
	 q3gTOEsw6vw5XF+0kvMM5K2AjflqLIE8tYThjCTWeSKu/QpLOzCG+q2ydyf28JJ/UA
	 ie7LTtmfCuunxIxN91VzKC81sV40S2TFVCVGuc/A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0368/1146] drm/msm/dpu: drop INTF_0 on MSM8953
Date: Wed, 20 May 2026 18:10:18 +0200
Message-ID: <20260520162156.529338122@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>

[ Upstream commit 7090420420d5a7d7c88b21d16962f2a230be3ef3 ]

There is no INTF_0 on MSM8953. Currently catalog lists dummy INTF_NONE
entry for it. Drop it from the catalog.

Fixes: 7a6109ce1c2c ("drm/msm/dpu: Add support for MSM8953")
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Patchwork: https://patchwork.freedesktop.org/patch/713990/
Link: https://lore.kernel.org/r/20260325-drop-8953-intf-v1-1-d80e214a1a75@oss.qualcomm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/disp/dpu1/catalog/dpu_1_16_msm8953.h | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/drivers/gpu/drm/msm/disp/dpu1/catalog/dpu_1_16_msm8953.h b/drivers/gpu/drm/msm/disp/dpu1/catalog/dpu_1_16_msm8953.h
index b44d02b48418f..2162ff917b0f8 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/catalog/dpu_1_16_msm8953.h
+++ b/drivers/gpu/drm/msm/disp/dpu1/catalog/dpu_1_16_msm8953.h
@@ -121,13 +121,6 @@ static const struct dpu_dspp_cfg msm8953_dspp[] = {
 
 static const struct dpu_intf_cfg msm8953_intf[] = {
 	{
-		.name = "intf_0", .id = INTF_0,
-		.base = 0x6a000, .len = 0x268,
-		.type = INTF_NONE,
-		.prog_fetch_lines_worst_case = 14,
-		.intr_underrun = DPU_IRQ_IDX(MDP_SSPP_TOP0_INTR, 24),
-		.intr_vsync = DPU_IRQ_IDX(MDP_SSPP_TOP0_INTR, 25),
-	}, {
 		.name = "intf_1", .id = INTF_1,
 		.base = 0x6a800, .len = 0x268,
 		.type = INTF_DSI,
-- 
2.53.0



