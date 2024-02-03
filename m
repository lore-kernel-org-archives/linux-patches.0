Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74851FBF2;
	Sat,  3 Feb 2024 04:17:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933856; cv=none; b=d/BzeHq4rpeqwDmJbMVNd9GcRt1Y6JekFy7Hjc6qrTz13b+66OL70zb8cvJ2iQNSFTwWyT02y4FIXmTYWLVgW2AvB+XMhpYH47mEpl/z29Sl/W+Z09JkYdyX3JliouuvF4dueUiKAfEE4cFagjSKkNjsIauzaL9LAr1lE12xJUY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933856; c=relaxed/simple;
	bh=bB0blpQF0DaakYB00tod09BCWcxrDqbZLO7c/CIllQg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HkUnuNVqrm2YwuQEYpcIVLAPgf+mMFpz8JJpNbF8FitcmX/zlcuiIuuNfp4a3CZc89fR5Urc3sPO2hNur4THwR0rhFt927p4248TVyTX9BcF551D8ECtV5B4ZiDZuKC6cs/tzF4h4ErwnZUn+ZnP8mW69Z04cHJjuP+qyPouVUM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eIYshcmu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eIYshcmu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E988C433C7;
	Sat,  3 Feb 2024 04:17:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933856;
	bh=bB0blpQF0DaakYB00tod09BCWcxrDqbZLO7c/CIllQg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eIYshcmuQF46A2e3cXWe/UbTujNVp4/bb7bpr+DrJPCcAC1vOQ0ctXWN6A1QrTvgV
	 qOr01GqUm3EoQYdZSnNKk4zxwDzFsrAIeQWFjyAyUHpEHVx4rG8ChnxdczYNg5e5Qi
	 AHoAHj+BaxAItETOMb/35zyxkUes7HYXkBaBd3Do=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 187/353] drm/msm/dp: Add DisplayPort controller for SM8650
Date: Fri,  2 Feb 2024 20:05:05 -0800
Message-ID: <20240203035409.573825939@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035403.657508530@linuxfoundation.org>
References: <20240203035403.657508530@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Neil Armstrong <neil.armstrong@linaro.org>

[ Upstream commit 1b2d98bdd7b7c64265732f5f0dace4c52c9ba8a8 ]

The Qualcomm SM8650 platform comes with a DisplayPort controller
with a different base offset than the previous SM8550 SoC,
add support for this in the DisplayPort driver.

Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Patchwork: https://patchwork.freedesktop.org/patch/571132/
Link: https://lore.kernel.org/r/20231207-topic-sm8650-upstream-dp-v1-2-b762c06965bb@linaro.org
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/dp/dp_display.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/gpu/drm/msm/dp/dp_display.c b/drivers/gpu/drm/msm/dp/dp_display.c
index 1b88fb52726f..4f89c9939501 100644
--- a/drivers/gpu/drm/msm/dp/dp_display.c
+++ b/drivers/gpu/drm/msm/dp/dp_display.c
@@ -170,6 +170,11 @@ static const struct msm_dp_desc sm8350_dp_descs[] = {
 	{}
 };
 
+static const struct msm_dp_desc sm8650_dp_descs[] = {
+	{ .io_start = 0x0af54000, .id = MSM_DP_CONTROLLER_0, .connector_type = DRM_MODE_CONNECTOR_DisplayPort },
+	{}
+};
+
 static const struct of_device_id dp_dt_match[] = {
 	{ .compatible = "qcom,sc7180-dp", .data = &sc7180_dp_descs },
 	{ .compatible = "qcom,sc7280-dp", .data = &sc7280_dp_descs },
@@ -180,6 +185,7 @@ static const struct of_device_id dp_dt_match[] = {
 	{ .compatible = "qcom,sc8280xp-edp", .data = &sc8280xp_edp_descs },
 	{ .compatible = "qcom,sdm845-dp", .data = &sc7180_dp_descs },
 	{ .compatible = "qcom,sm8350-dp", .data = &sm8350_dp_descs },
+	{ .compatible = "qcom,sm8650-dp", .data = &sm8650_dp_descs },
 	{}
 };
 
-- 
2.43.0



