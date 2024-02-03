Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B477179BD;
	Sat,  3 Feb 2024 04:13:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933607; cv=none; b=cI76slFa42IQSUEG9YezUjwOQnh51U3bwBjsHIMqYuQh6/b9SQ+idihmfbRSfQy1P7m/v6EQzNkqomToRLv4d9mNrNsbNHvo32e76NkFX/xMFc5PCuqQdcpIYwkHTMGK3t5tm8/f1iIjvejyhllOIoH0sN/d8bVAIIia+kXbjq8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933607; c=relaxed/simple;
	bh=AKdH0KDnI9LpUTDGwbMHISsZuuH5Sm4li85S/3H/hAY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a2hf6OaHKnHQb4PxYBGQpF2orYAmGRXGQz2SaWog4HsRzIDY58gm8dFlN1Y5fXwb1/RAK7vGih5YFQQ8myCZHOWZJM98H2Zh+TppiFMtDa3LwqEAF9JlQ68PHaB3oY82JP8iu5pzCMBjWioE/lhOHKtivgx5VIPbVW3KQYWOpac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z1eChTyc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z1eChTyc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37863C43390;
	Sat,  3 Feb 2024 04:13:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933607;
	bh=AKdH0KDnI9LpUTDGwbMHISsZuuH5Sm4li85S/3H/hAY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z1eChTyc9Wy2f226E3ydAH6xeksXgyyRF6MfxFleny60/vBoXKPFjIfhsAzMgPPoQ
	 lapuZNdwZIeZCexBzRd20t0DWcaxoRSJuhiGOkLchlP5QLLIqxBDfv+yUnzq7E7VJh
	 l5GU4XN+3f6SbrYFg4I9aIlFRBfGafZtp5FhvEYo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 177/322] drm/msm/dp: Add DisplayPort controller for SM8650
Date: Fri,  2 Feb 2024 20:04:34 -0800
Message-ID: <20240203035404.974794418@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035359.041730947@linuxfoundation.org>
References: <20240203035359.041730947@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 76f13954015b..eec5768aac72 100644
--- a/drivers/gpu/drm/msm/dp/dp_display.c
+++ b/drivers/gpu/drm/msm/dp/dp_display.c
@@ -171,6 +171,11 @@ static const struct msm_dp_desc sm8350_dp_descs[] = {
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
@@ -181,6 +186,7 @@ static const struct of_device_id dp_dt_match[] = {
 	{ .compatible = "qcom,sc8280xp-edp", .data = &sc8280xp_edp_descs },
 	{ .compatible = "qcom,sdm845-dp", .data = &sc7180_dp_descs },
 	{ .compatible = "qcom,sm8350-dp", .data = &sm8350_dp_descs },
+	{ .compatible = "qcom,sm8650-dp", .data = &sm8650_dp_descs },
 	{}
 };
 
-- 
2.43.0



