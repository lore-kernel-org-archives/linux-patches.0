Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27A8267E67;
	Tue, 23 Jan 2024 02:01:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705975311; cv=none; b=sXPXPdsFtLqtNWU6NZ6CAVoy6abSRvQp6pVwqTVuwiTBEoNo0gxWnzQxTrn8Qx51yyprWnt317jphvWJR6W8qdE/oO+SYowhvI/8PO1Boiy8VO1WzolcoEHvxG9nWcVSDS/ZhW7kSfMqKUT0zCN0Pr/BSdzmi6h0NT9f0p6zmF4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705975311; c=relaxed/simple;
	bh=1mCmWSsuPNt7/GNcA0w1xWnu2PCFHndCpJYyNRGI+0M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=USHPa0m+q92JRTJGXxjRxq/eGJGG8tRVU5YAqsQOqnnlE31UYjwIbT4p1BtweuNguI6sJpI6C6U0AFNh+1jhpffZqDvM6giRj18MNl3pXbtP/RZvBodbnViF0K7oxB/Hc358Biex/CrqcWG4xWVxtzO/1fr5KfghJ+JWoKMGCtU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zSUy8Kl2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zSUy8Kl2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFDC5C43399;
	Tue, 23 Jan 2024 02:01:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705975311;
	bh=1mCmWSsuPNt7/GNcA0w1xWnu2PCFHndCpJYyNRGI+0M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zSUy8Kl2SX3tNvzlSdwsQugmHfChPRbHmYOAbNs6Zn6P/DiwJfnObJbFfkqOEAEOs
	 96QDmWnOpKRsXQLd0mYGyDYaLgzNiZdzolWxzhXYSTYNhI1XoZAf7PiW1enDRu35dI
	 8brsgfnU32XkyKiZtjj2GwVkkD9OSrAcveGlT52Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bjorn Andersson <quic_bjorande@quicinc.com>,
	Anton Bambura <jenneron@postmarketos.org>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 251/583] drm/msm/dpu: Add missing safe_lut_tbl in sc8180x catalog
Date: Mon, 22 Jan 2024 15:55:02 -0800
Message-ID: <20240122235819.685723606@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
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

From: Bjorn Andersson <quic_bjorande@quicinc.com>

[ Upstream commit 7cc2621f16b644bb7af37987cb471311641a9e56 ]

Similar to SC8280XP, the misconfigured SAFE logic causes rather
significant delays in __arm_smmu_tlb_sync(), resulting in poor
performance for things such as USB.

Introduce appropriate SAFE values for SC8180X to correct this.

Fixes: f3af2d6ee9ab ("drm/msm/dpu: Add SC8180x to hw catalog")
Signed-off-by: Bjorn Andersson <quic_bjorande@quicinc.com>
Reported-by: Anton Bambura <jenneron@postmarketos.org>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Patchwork: https://patchwork.freedesktop.org/patch/569840/
Link: https://lore.kernel.org/r/20231130-sc8180x-dpu-safe-lut-v1-1-a8a6bbac36b8@quicinc.com
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/disp/dpu1/catalog/dpu_5_1_sc8180x.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/msm/disp/dpu1/catalog/dpu_5_1_sc8180x.h b/drivers/gpu/drm/msm/disp/dpu1/catalog/dpu_5_1_sc8180x.h
index f3de21025ca7..c92fbf24fbac 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/catalog/dpu_5_1_sc8180x.h
+++ b/drivers/gpu/drm/msm/disp/dpu1/catalog/dpu_5_1_sc8180x.h
@@ -377,6 +377,7 @@ static const struct dpu_perf_cfg sc8180x_perf_data = {
 	.min_llcc_ib = 800000,
 	.min_dram_ib = 800000,
 	.danger_lut_tbl = {0xf, 0xffff, 0x0},
+	.safe_lut_tbl = {0xfff0, 0xf000, 0xffff},
 	.qos_lut_tbl = {
 		{.nentry = ARRAY_SIZE(sc7180_qos_linear),
 		.entries = sc7180_qos_linear
-- 
2.43.0



