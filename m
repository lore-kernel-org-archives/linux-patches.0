Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 569DC3FB1B;
	Mon, 23 Jun 2025 21:56:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750715817; cv=none; b=DSaBDOVMkjS4rbECcKyVw3KG/xTyvten1hJ5HdJ7arX4aQ4pqJVkvBJyf6UwMV0QMTWgtFh/MG3iLT43R15MeTDpT0sPSGEHkA/SBGnlETi5V8lqnpvELy0LsZDVuN71FE9cc9hxwyAtTmTdL7m5aU2EgFmh+sBByuBTz1wIfxc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750715817; c=relaxed/simple;
	bh=GngQU8SYndPBYKr0bqyZ+rDvaDIzX6EKwDMt8tl0OpI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FHJmI8niWr9E23xMqgiDxjFU+5ALcWWvgadHxPKa7fxbKKfl+wZxzKpqpa1iOGBgCVail+ue2PeUUH1r4zsYMffTyJIz7j34FWT9vdkT4iANPqdDvBs/XG9ADuvlLExOGIMRAkmIDehcJzJ0AxW0YqQL8Wa85uWuJRvWN9cKAPc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OmC/16qr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OmC/16qr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB38EC4CEEA;
	Mon, 23 Jun 2025 21:56:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750715817;
	bh=GngQU8SYndPBYKr0bqyZ+rDvaDIzX6EKwDMt8tl0OpI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OmC/16qrjPhxkPKZCa/JzAwq5uSbSE75hDU7rHlkxShkInMhubAkawhIVWmghmUiK
	 2bI+/+RoNxmAnDg70HeBWDSyTaZNEBez+z3kd25iiHGiWrwD7RfBl7b4d6onS5yf2W
	 WoR2hA5iY0xvM4vH/zUu9VEr25fHK48omOLZDZ1M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"James A. MacInnes" <james.a.macinnes@gmail.com>,
	Abhinav Kumar <quic_abhinavk@quicinc.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 505/592] drm/msm/dp: Disable wide bus support for SDM845
Date: Mon, 23 Jun 2025 15:07:43 +0200
Message-ID: <20250623130712.446993054@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: James A. MacInnes <james.a.macinnes@gmail.com>

[ Upstream commit 83c4c67076c209787515e06fffd41dd0bdab09b9 ]

When widebus was enabled for DisplayPort in commit c7c412202623
("drm/msm/dp: enable widebus on all relevant chipsets") it was clarified
that it is only supported on DPU 5.0.0 onwards which includes SC7180 on
DPU revision 6.2.  However, this patch missed that the description
structure for SC7180 is also reused for SDM845 (because of identical
io_start address) which is only DPU 4.0.0, leading to a wrongly enbled
widebus feature and corruption on that platform.

Create a separate msm_dp_desc_sdm845 structure for this SoC compatible,
with the wide_bus_supported flag turned off.

Fixes: c7c412202623 ("drm/msm/dp: enable widebus on all relevant chipsets")
Signed-off-by: James A. MacInnes <james.a.macinnes@gmail.com>
[DB: reworded commit text following Marijn's suggestion]
Reviewed-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Patchwork: https://patchwork.freedesktop.org/patch/636944/
Link: https://lore.kernel.org/r/20250212-sdm845_dp-v2-1-4954e51458f4@gmail.com
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/dp/dp_display.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/msm/dp/dp_display.c b/drivers/gpu/drm/msm/dp/dp_display.c
index ab8c1f19dcb42..c7503a7a6123f 100644
--- a/drivers/gpu/drm/msm/dp/dp_display.c
+++ b/drivers/gpu/drm/msm/dp/dp_display.c
@@ -127,6 +127,11 @@ static const struct msm_dp_desc msm_dp_desc_sa8775p[] = {
 	{}
 };
 
+static const struct msm_dp_desc msm_dp_desc_sdm845[] = {
+	{ .io_start = 0x0ae90000, .id = MSM_DP_CONTROLLER_0 },
+	{}
+};
+
 static const struct msm_dp_desc msm_dp_desc_sc7180[] = {
 	{ .io_start = 0x0ae90000, .id = MSM_DP_CONTROLLER_0, .wide_bus_supported = true },
 	{}
@@ -179,7 +184,7 @@ static const struct of_device_id msm_dp_dt_match[] = {
 	{ .compatible = "qcom,sc8180x-edp", .data = &msm_dp_desc_sc8180x },
 	{ .compatible = "qcom,sc8280xp-dp", .data = &msm_dp_desc_sc8280xp },
 	{ .compatible = "qcom,sc8280xp-edp", .data = &msm_dp_desc_sc8280xp },
-	{ .compatible = "qcom,sdm845-dp", .data = &msm_dp_desc_sc7180 },
+	{ .compatible = "qcom,sdm845-dp", .data = &msm_dp_desc_sdm845 },
 	{ .compatible = "qcom,sm8350-dp", .data = &msm_dp_desc_sc7180 },
 	{ .compatible = "qcom,sm8650-dp", .data = &msm_dp_desc_sm8650 },
 	{ .compatible = "qcom,x1e80100-dp", .data = &msm_dp_desc_x1e80100 },
-- 
2.39.5



