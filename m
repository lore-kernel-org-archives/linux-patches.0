Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13BC43FB1B;
	Mon, 23 Jun 2025 21:57:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750715827; cv=none; b=Up64l5B/bSj0FQaxT1hCAyzJYUZtimVgmArKxEa8vFwMahOul+QrnzUs5/NUIeMmWCwXELV7JuP3Zdbn4i5x5kLbcQjKQHT1Mc/CKrjUpxUEacEQ1/DtLaMMLF/Iwzlwtw1ynSK9aq2k9QtIM9LGeOk3cRXbOxRhP/1g0b9Jyx4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750715827; c=relaxed/simple;
	bh=am+gENgPEoAH2gHsqG1n7jGrb6VDEFw6W4u4Gb5ZAWg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R6ZV6MtR6imlD/Cg5BgT3t3GEdw3IIFDmkxlDXXyWbYwI3euWRGXuojqRHmNbp6D7FJXMiZ4PyF42gdn6xRnaRA+1HgpD9p7M+PhuD/GqcjcLUb1bVgUbXVIpZO0rxwRSve5Y8BvLizVORcjTTZ0+8yrGjEvbKK6cPMnWvCTsw8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ka9OfhaL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ka9OfhaL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0618C4CEEA;
	Mon, 23 Jun 2025 21:57:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750715827;
	bh=am+gENgPEoAH2gHsqG1n7jGrb6VDEFw6W4u4Gb5ZAWg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ka9OfhaLczQn2e/xw/07zN7k9TrKwfj4yF2RxK/FkA158eR+YAU8Imi5T/aVp6S7o
	 Ghbf/MP0MSzpA8yxvW052YWu57Dpf6xu0AMq73lEuI6RdK8B5bhSTXIUyrEe5u4IRR
	 dSx7oAnL98MsQYkzqpQi1dDZUWu2hyuVWd/torAE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"James A. MacInnes" <james.a.macinnes@gmail.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 244/290] drm/msm/disp: Correct porch timing for SDM845
Date: Mon, 23 Jun 2025 15:08:25 +0200
Message-ID: <20250623130634.266574600@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.910356556@linuxfoundation.org>
References: <20250623130626.910356556@linuxfoundation.org>
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
index 20c8b9af7a219..2cda9bbf68f96 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder_phys_vid.c
+++ b/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder_phys_vid.c
@@ -93,17 +93,21 @@ static void drm_mode_to_intf_timing_params(
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



