Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B418223DE8;
	Mon, 23 Jun 2025 22:21:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750717287; cv=none; b=XOIkBMyYRFRQCk77l4BxxgetoBSUeXyJLF4hSlL9mvW/htECjarKOc2+5ZhlmjKqC4sGHCKevDdZlD4c+yZ6m5G25gM6g0WugJCZtRlLxvEjApvXwy5eDklHntb+TzrELoloyOAxTMaIxo5YZb3OYbYXcNH9A7k4eGVUSZm2Q5M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750717287; c=relaxed/simple;
	bh=uNdxtHlNipq62m2W0srn7Blq6fSS4OgsJvmv/XIxJ4I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u6GxfFd4FiOOui9nporgiltOFK50WEWhB2a71dIjtS3PYb7BvRoysDGZ1PaaOa0jSF7sst8DWD/xMQDagf8/S0ex2nliBfdSLhNKFaY/ZQo67qToHJulAQ+gwtdrt3eWUKvdNU8Ps5JtGF9Rn4wqR2E4Fky72DWDvkTr3MorsDg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=slf4+Ud1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="slf4+Ud1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6A84C4CEEA;
	Mon, 23 Jun 2025 22:21:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750717287;
	bh=uNdxtHlNipq62m2W0srn7Blq6fSS4OgsJvmv/XIxJ4I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=slf4+Ud1FPej2q+tTej1Wd6B+HM0amPJuKmsSoIvCPFOmd9dID6EpN5Ua7oqhSFKh
	 WCDTWpXHo9Zu2TASA3CKqnWEu+hxUYtt1QspiGAkCmb4TSpd/r+4WyZQttVPSvw41H
	 OOe9PbT60ZjrjE45hDoZ1PNySU84WL4m/foSERkk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"James A. MacInnes" <james.a.macinnes@gmail.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 353/414] drm/msm/disp: Correct porch timing for SDM845
Date: Mon, 23 Jun 2025 15:08:10 +0200
Message-ID: <20250623130650.798828979@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130642.015559452@linuxfoundation.org>
References: <20250623130642.015559452@linuxfoundation.org>
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
index d8a2edebfe8c3..b7699ca89dcc5 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder_phys_vid.c
+++ b/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder_phys_vid.c
@@ -94,17 +94,21 @@ static void drm_mode_to_intf_timing_params(
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



