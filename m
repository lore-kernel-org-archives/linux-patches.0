Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06F4223C2;
	Tue, 23 Jan 2024 00:24:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969491; cv=none; b=sBjmHTvzohHMlKBIkVvjTpz25OreuBAoOte7jPaw0XKNEI/xku61E1R2Ixz7pbT/4shp6UtCnenguWoY4BeFqeNN6YRxmqSvHouev5rIdvo8yWJ0Q/5PQFrl+khmKgNp92cJkaoR3ABe4G6RtRJr3VnAL9ABJwZkeNOmnOTLV2Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969491; c=relaxed/simple;
	bh=BaigVRjzedoVCx0vlxWK+f5Lr4EaRUQTvcpNOHLdKhY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UAXJGWcoynustLrEgtsJzRTVSq34V5y+LI/eMGCtNZjls2NC5s9NRKwQhyMkGOGYvkXkKovkK5vAcC7//OE1sCjoUFONccmFmWmSotDJIMzy01M8g0R+kSGjpMnrRtLHZNE5WQ9rOLQCNE/Y3SaPs6Tqb0WyDEoJtgXqfPFLO/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YGAmejgy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YGAmejgy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3F17C43390;
	Tue, 23 Jan 2024 00:24:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969490;
	bh=BaigVRjzedoVCx0vlxWK+f5Lr4EaRUQTvcpNOHLdKhY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YGAmejgytDMYI4Ird3J3Uxt7UFwrLT8I+pNjn55asnNes0vNM7pP2VW9EGo2wnnsY
	 /DxbybHIGwVi+nZw5OK3K7uWrFGQCZIGGZLTi8L4+nhPTAw9aHbeUsGHCssNKOzkwa
	 H67HZrSIs0V6C2cXVrtwEMq90TbGUDYOS63n1DRw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bjorn Andersson <quic_bjorande@quicinc.com>,
	Anton Bambura <jenneron@postmarketos.org>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 280/641] drm/msm/dpu: Add missing safe_lut_tbl in sc8180x catalog
Date: Mon, 22 Jan 2024 15:53:04 -0800
Message-ID: <20240122235826.675606485@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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
index e07f4c8c25b9..9ffc8804a6fc 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/catalog/dpu_5_1_sc8180x.h
+++ b/drivers/gpu/drm/msm/disp/dpu1/catalog/dpu_5_1_sc8180x.h
@@ -367,6 +367,7 @@ static const struct dpu_perf_cfg sc8180x_perf_data = {
 	.min_llcc_ib = 800000,
 	.min_dram_ib = 800000,
 	.danger_lut_tbl = {0xf, 0xffff, 0x0},
+	.safe_lut_tbl = {0xfff0, 0xf000, 0xffff},
 	.qos_lut_tbl = {
 		{.nentry = ARRAY_SIZE(sc7180_qos_linear),
 		.entries = sc7180_qos_linear
-- 
2.43.0



