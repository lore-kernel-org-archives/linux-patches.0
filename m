Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07D86223DE5;
	Mon, 23 Jun 2025 22:26:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750717612; cv=none; b=bqsIKmDQOcPFkXkwebnNdYqfxTgePsxOdxZRvlIVkAMfMR5i255k1lZ0ai1ZjoM7rHtsg1DkA5jdRO/rl2MMRJkPrmlW0MdE3JtyZDq0N8cNalTdAnCzWNbMTVvoeQN4fcZdd91vSR1ZDi7r5+yVLvNFtHhItrDa6jxOkwQ+ihQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750717612; c=relaxed/simple;
	bh=ZkXNZmSS9I15eJZbe9iPihMzRSC17FqFkNlY3E/aYfw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uEXxmoDBni4+jOOO3PYIJ+kXaZeslOs8Ib5ar3NPd0/rlCubHqq+F6YGKqCbjiyB9Elb/TRf4/muj9WFegG21/7y8M749fxzQSJ7b51zDyslKcjRAQDZP/BUcHycCWpC0fWHkGbZgRouiUOWi9+AmcBwUfnW+9HdyCug8yB6gRI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qMKKA18T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qMKKA18T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9556EC4CEEA;
	Mon, 23 Jun 2025 22:26:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750717611;
	bh=ZkXNZmSS9I15eJZbe9iPihMzRSC17FqFkNlY3E/aYfw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qMKKA18TOIETbsFd0njaoVi/3cqypGMyeL0XSTda5rgDdDeJVNKcTG8nD1wJtzBdT
	 Z77zN2LL1lEDgOZyeRvYmTwTatan3dMnqIFnJI+vRTqI4gQ5LKFwCpn3BkUGolnNuz
	 Y/SO9lQh7yVUiZLg1lKqLYxwMbvnWwq0P40SMcI8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"James A. MacInnes" <james.a.macinnes@gmail.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 470/508] drm/msm/disp: Correct porch timing for SDM845
Date: Mon, 23 Jun 2025 15:08:35 +0200
Message-ID: <20250623130656.660819548@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130645.255320792@linuxfoundation.org>
References: <20250623130645.255320792@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: James A. MacInnes <james.a.macinnes@gmail.com>

[ Upstream commit 146e87f3e11de0dfa091ff87e34b4bc6eec761a4 ]

Type-C DisplayPort inoperable due to incorrect porch settings.
- Re-used wide_bus_en as flag to prevent porch shifting

Fixes: c943b4948b58 ("drm/msm/dp: add displayPort driver support")
Signed-off-by: James A. MacInnes <james.a.macinnes@gmail.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Patchwork: https://patchwork.freedesktop.org/patch/636945/
Link: https://lore.kernel.org/r/20250212-sdm845_dp-v2-2-4954e51458f4@gmail.com
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../gpu/drm/msm/disp/dpu1/dpu_encoder_phys_vid.c   | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder_phys_vid.c b/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder_phys_vid.c
index aba2488c32fa1..4b7952c4e639f 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder_phys_vid.c
+++ b/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder_phys_vid.c
@@ -91,17 +91,21 @@ static void drm_mode_to_intf_timing_params(
 		timing->vsync_polarity = 0;
 	}
 
-	/* for DP/EDP, Shift timings to align it to bottom right */
-	if (phys_enc->hw_intf->cap->type == INTF_DP) {
+	timing->wide_bus_en = dpu_encoder_is_widebus_enabled(phys_enc->parent);
+	timing->compression_en = dpu_encoder_is_dsc_enabled(phys_enc->parent);
+
+	/*
+	 *  For DP/EDP, Shift timings to align it to bottom right.
+	 *  wide_bus_en is set for everything excluding SDM845 &
+	 *  porch changes cause DisplayPort failure and HDMI tearing.
+	 */
+	if (phys_enc->hw_intf->cap->type == INTF_DP && timing->wide_bus_en) {
 		timing->h_back_porch += timing->h_front_porch;
 		timing->h_front_porch = 0;
 		timing->v_back_porch += timing->v_front_porch;
 		timing->v_front_porch = 0;
 	}
 
-	timing->wide_bus_en = dpu_encoder_is_widebus_enabled(phys_enc->parent);
-	timing->compression_en = dpu_encoder_is_dsc_enabled(phys_enc->parent);
-
 	/*
 	 * for DP, divide the horizonal parameters by 2 when
 	 * widebus is enabled
-- 
2.39.5



