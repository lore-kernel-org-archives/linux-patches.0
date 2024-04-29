Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA347140E5E
	for <patches@lists.linux.dev>; Mon, 29 Apr 2024 20:00:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714420820; cv=none; b=Yjk6TUlNuv+i2NibEnQJ27D9me0kMwFIN35cIdeZOd+PMN72VBaxUNGFxxGEcnzh8svDeUCPDYIOHGbOOTbAauei506qneIt3cR8QbuvelFcUD0Lka2oJZu/pup3BINXyEGofAMKBx61kp3pNwOFDfbq/X59N6uPnazv7HmYPKA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714420820; c=relaxed/simple;
	bh=mcotd9NbVeWkgG22NKKI0lo1QJrij1pYaryZYmTYxmY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hMY/RD515d1gxkKlQBC95Cz03HNlhNztK71Iy2I5ho4ZvesE42yWJx5gLVJ9f1F6TN4JR+fs/wFMKhrkngSYNCEsq1O0YnhBUiRXXxHew/HcUl65cTYA5I0cOdanmeAnPz32cmO/CLNDyKwuSYRA3RAapGo95g4Fe56yTG8vZMQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=MyI0ilIa; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="MyI0ilIa"
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-1eb66b6953cso19755065ad.2
        for <patches@lists.linux.dev>; Mon, 29 Apr 2024 13:00:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1714420818; x=1715025618; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eWmqn49eFC/BkS9yD3r0ttTtLZEtxmHbf5T1oMc/M28=;
        b=MyI0ilIao3+m62wKu0Oe6ftbxwZ4ZGct1ZcMEOcaZr6hzsDWW8sOJ8ZOilDBx60xRJ
         aNOG8UVkgpYG+zqwQuL9A3ve0d+pwOTYNHkYoKOuvYDsJ76JeXp1ujp87tBoKeUUR00G
         8+bsJpYeFPJwjwGQ57gv3PcG56tlbJj2FayiM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714420818; x=1715025618;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=eWmqn49eFC/BkS9yD3r0ttTtLZEtxmHbf5T1oMc/M28=;
        b=c+v35yRhzzyfK5upAvrOkgSA9iM98zGuMxliL/v8Wv70hpA7NNk+LhaKKrANS2oJMi
         wQyqyqKvPlldNFUET8zw41oI4+gRrV+xzEoqcHLHXY+8jBi3tihxAte/9R/eSO7hN8Lg
         uoerz5Gz68BRDwD2Osk86TJI1xU+Ypztyq0VKeE066c4cl9m6XrqG8tBEg7TmNoAaHQp
         MJfi2esCQKof9++lCiw3noGLCMObwT8zXEEXdHaEY2TGlS7dvaPPFXxlyYZEk8ePMoim
         8rQWyWHe8TzcbJlrp7V5qd64wObhiAPeoKd7sZVTBVVRVEkq1N0JiplHvdAcJyBaqS1R
         TLjw==
X-Forwarded-Encrypted: i=1; AJvYcCXmfp0zt07AYu1bUSNVkR2R03EbcJSHW4yU+6gRoLjBteCZKVCKoSqk+GXY0qDkaigNDZguGPKNmzNvFTLXDkL98szckiDz2Q==
X-Gm-Message-State: AOJu0YxCVdLZUOIsDOXpsOpOaNkb9cyv0M87zBhpLU2m41EHiXYGEIl7
	f9DE4jOVjoFdRSvKNME5grmknQVqfsgrQQvBHh5CBHSMVrsx0NRfy7Imhy2M2Q==
X-Google-Smtp-Source: AGHT+IFOGMjnKO1WeszkOemOXgZRC4K/j70GXMxjESfhh2aV3SKMhi9+phdW8z27ivdQdfK41WIRAg==
X-Received: by 2002:a17:902:6b09:b0:1eb:2fb2:8ea8 with SMTP id o9-20020a1709026b0900b001eb2fb28ea8mr594981plk.50.1714420818183;
        Mon, 29 Apr 2024 13:00:18 -0700 (PDT)
Received: from localhost (4.198.125.34.bc.googleusercontent.com. [34.125.198.4])
        by smtp.gmail.com with UTF8SMTPSA id a4-20020a170902ecc400b001eac9aa55edsm8059703plh.250.2024.04.29.13.00.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 29 Apr 2024 13:00:17 -0700 (PDT)
From: Stephen Boyd <swboyd@chromium.org>
To: stable@vger.kernel.org
Cc: Johan Hovold <johan+linaro@kernel.org>,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Abhinav Kumar <quic_abhinavk@quicinc.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 6.6.y] phy: qcom: qmp-combo: fix VCO div offset on v5_5nm and v6
Date: Mon, 29 Apr 2024 13:00:16 -0700
Message-ID: <20240429200017.3751576-1-swboyd@chromium.org>
X-Mailer: git-send-email 2.45.0.rc0.197.gbae5840b3b-goog
In-Reply-To: <2024042919-enlisted-punch-79a5@gregkh>
References: <2024042919-enlisted-punch-79a5@gregkh>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Johan Hovold <johan+linaro@kernel.org>

Commit 5abed58a8bde ("phy: qcom: qmp-combo: Fix VCO div offset on v3")
fixed a regression introduced in 6.5 by making sure that the correct
offset is used for the DP_PHY_VCO_DIV register on v3 hardware.

Unfortunately, that fix instead broke DisplayPort on v5_5nm and v6
hardware as it failed to add the corresponding offsets also to those
register tables.

Fixes: 815891eee668 ("phy: qcom-qmp-combo: Introduce orientation variable")
Fixes: 5abed58a8bde ("phy: qcom: qmp-combo: Fix VCO div offset on v3")
Cc: stable@vger.kernel.org	# 6.5: 5abed58a8bde
Cc: Stephen Boyd <swboyd@chromium.org>
Cc: Abhinav Kumar <quic_abhinavk@quicinc.com>
Cc: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Reviewed-by: Stephen Boyd <swboyd@chromium.org>
Reviewed-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Link: https://lore.kernel.org/r/20240408093023.506-1-johan+linaro@kernel.org
Signed-off-by: Vinod Koul <vkoul@kernel.org>
(cherry picked from commit 025a6f7448f7bb5f4fceb62498ee33d89ae266bb)
Signed-off-by: Stephen Boyd <swboyd@chromium.org>
---
 drivers/phy/qualcomm/phy-qcom-qmp-combo.c | 2 ++
 drivers/phy/qualcomm/phy-qcom-qmp.h       | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/drivers/phy/qualcomm/phy-qcom-qmp-combo.c b/drivers/phy/qualcomm/phy-qcom-qmp-combo.c
index 27d7895a9b61..be837dee81f7 100644
--- a/drivers/phy/qualcomm/phy-qcom-qmp-combo.c
+++ b/drivers/phy/qualcomm/phy-qcom-qmp-combo.c
@@ -188,6 +188,7 @@ static const unsigned int qmp_v5_5nm_usb3phy_regs_layout[QPHY_LAYOUT_SIZE] = {
 	[QPHY_COM_BIAS_EN_CLKBUFLR_EN]	= QSERDES_V5_COM_BIAS_EN_CLKBUFLR_EN,
 
 	[QPHY_DP_PHY_STATUS]		= QSERDES_V5_DP_PHY_STATUS,
+	[QPHY_DP_PHY_VCO_DIV]		= QSERDES_V5_DP_PHY_VCO_DIV,
 
 	[QPHY_TX_TX_POL_INV]		= QSERDES_V5_5NM_TX_TX_POL_INV,
 	[QPHY_TX_TX_DRV_LVL]		= QSERDES_V5_5NM_TX_TX_DRV_LVL,
@@ -212,6 +213,7 @@ static const unsigned int qmp_v6_usb3phy_regs_layout[QPHY_LAYOUT_SIZE] = {
 	[QPHY_COM_BIAS_EN_CLKBUFLR_EN]	= QSERDES_V6_COM_PLL_BIAS_EN_CLK_BUFLR_EN,
 
 	[QPHY_DP_PHY_STATUS]		= QSERDES_V6_DP_PHY_STATUS,
+	[QPHY_DP_PHY_VCO_DIV]		= QSERDES_V6_DP_PHY_VCO_DIV,
 
 	[QPHY_TX_TX_POL_INV]		= QSERDES_V6_TX_TX_POL_INV,
 	[QPHY_TX_TX_DRV_LVL]		= QSERDES_V6_TX_TX_DRV_LVL,
diff --git a/drivers/phy/qualcomm/phy-qcom-qmp.h b/drivers/phy/qualcomm/phy-qcom-qmp.h
index 32d897684755..e2c22edfe653 100644
--- a/drivers/phy/qualcomm/phy-qcom-qmp.h
+++ b/drivers/phy/qualcomm/phy-qcom-qmp.h
@@ -134,9 +134,11 @@
 #define QPHY_V4_PCS_MISC_TYPEC_STATUS			0x10
 #define QPHY_V4_PCS_MISC_PLACEHOLDER_STATUS		0x14
 
+#define QSERDES_V5_DP_PHY_VCO_DIV			0x070
 #define QSERDES_V5_DP_PHY_STATUS			0x0dc
 
 /* Only for QMP V6 PHY - DP PHY registers */
+#define QSERDES_V6_DP_PHY_VCO_DIV			0x070
 #define QSERDES_V6_DP_PHY_AUX_INTERRUPT_STATUS		0x0e0
 #define QSERDES_V6_DP_PHY_STATUS			0x0e4
 
-- 
https://chromeos.dev

