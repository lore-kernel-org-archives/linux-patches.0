Received: from mail-pg1-f180.google.com (mail-pg1-f180.google.com [209.85.215.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83FB7130E57
	for <patches@lists.linux.dev>; Thu,  4 Apr 2024 23:43:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712274231; cv=none; b=AOA3Ntv0VIEYC3YXWAI5exseHgFSg2mlgQ1k1dPsOuEUNHAhDgnRaLamNTxXS4MSWTHlWlyOAhGTCSkBAqUfBDoUxWb/0KRU0X3sJjit9Hh7gGUNvQYqZItscPs2XMEdS93+tZxY4vLvIT9h/QcKhgmIsk/4Y2Lbom/UGgbgWOs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712274231; c=relaxed/simple;
	bh=JJPz/P2CcR2ZufWiDJCZzZH/1OFiSj5m3Mdo8cC++Zw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=m8LYdILkIr3JX05PlNjayvyp/f221syOKKedEzF3kyH8rYk0DTYIVS8Zj40lhavrgx3RFgU6LdWaqA0nrUg+IqrSvNHhYw9pVILA9BWUi6yWgy36Qz8jTgPVn9HlTGeqKdRrAwc7fn138Vzof4EEis1xmkXF3k5XdiHfxvP6tWw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=myO9f9SF; arc=none smtp.client-ip=209.85.215.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="myO9f9SF"
Received: by mail-pg1-f180.google.com with SMTP id 41be03b00d2f7-5cdbc4334edso1140941a12.3
        for <patches@lists.linux.dev>; Thu, 04 Apr 2024 16:43:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1712274229; x=1712879029; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=RMI5yWOLAVIgIkbCc96VWxktkn/9P3095VY77NHNd1o=;
        b=myO9f9SFYGGb7SVxMXyzl0H9MXN9hsR66ghC0eYCzmNU3WyhfAeMFT78VQZAp7GHMf
         drZ/ym4dKJWOEzS/FCDp904UOMzm/wIg5o5PSrZ0YfwA+4lDhP6jSGSgT1AZfxcG7tHe
         U3De+/EWeCEVUTZpM8AGhrkR4C032Df+EIm+c=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712274229; x=1712879029;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=RMI5yWOLAVIgIkbCc96VWxktkn/9P3095VY77NHNd1o=;
        b=X2d/DERBdLNiFn3YK67c4DsH7dRbfViGmJESnENkjO3ZkWftK9F+whX1jraVNqzwL6
         PfsmvZwltUSqmzVsSVDS27edQ9QGtUKrWgQeFOqqKPjZoji02B0NhA6M3A7GqZ+ZqrNU
         crLgynDImoMzXU7CNpM6wZrWO9Oy4jS66nqyw5TrF6/A2MJTcnRKGZiYwvEyvvApl1RK
         KGMNHQ3HMcC76dIljHZzMRd6lstFUW8NHpHIeGPsovtSGZy0Vkbbc22EYKVRbTM9yNZ2
         wF7DXFYU7BW0NoC+7eacP3r8XkyYeI0NCPvp1CXSJnVLOGiXBMES3dbeeXOGdIzI9IQL
         wIRg==
X-Forwarded-Encrypted: i=1; AJvYcCUzCfwfPKgi2uhuf4SnQpHZUTDdQ1ttIPDGr1PH9AS+o7hxx6IkJKpQNai8JpUsHwV4upLex7efgKDFv8A1Std1sYwT6poUOA==
X-Gm-Message-State: AOJu0YyafDYhxhVCsIzEjnY/Z0zd6l51UhQjMz7GVKOG1Y54HOQNQw43
	HGA82oEv1BbsN37fEKjjadDV9qYvnas4H84n8aenc9sqHfQgVFn5Gt6qLY7YqA==
X-Google-Smtp-Source: AGHT+IEXZdsBDxClfnWn4V8ckwcGELQZihfoKdxkgEQZf2dDcxavcBDgDIZ9TfrbOn0Q57NFbPr69Q==
X-Received: by 2002:a05:6a20:1057:b0:1a3:6bb1:92fb with SMTP id gt23-20020a056a20105700b001a36bb192fbmr45166pzc.19.1712274228928;
        Thu, 04 Apr 2024 16:43:48 -0700 (PDT)
Received: from localhost (4.198.125.34.bc.googleusercontent.com. [34.125.198.4])
        by smtp.gmail.com with UTF8SMTPSA id ga16-20020a17090b039000b002a2b06cbe46sm269450pjb.22.2024.04.04.16.43.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Apr 2024 16:43:47 -0700 (PDT)
From: Stephen Boyd <swboyd@chromium.org>
To: Vinod Koul <vkoul@kernel.org>,
	Kishon Vijay Abraham I <kishon@kernel.org>
Cc: linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	linux-arm-msm@vger.kernel.org,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	linux-phy@lists.infradead.org,
	Neil Armstrong <neil.armstrong@linaro.org>,
	freedreno@lists.freedesktop.org,
	Douglas Anderson <dianders@chromium.org>,
	Abhinav Kumar <quic_abhinavk@quicinc.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Subject: [PATCH] phy: qcom: qmp-combo: Fix VCO div offset on v3
Date: Thu,  4 Apr 2024 16:43:44 -0700
Message-ID: <20240404234345.1446300-1-swboyd@chromium.org>
X-Mailer: git-send-email 2.44.0.478.gd926399ef9-goog
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Commit ec17373aebd0 ("phy: qcom: qmp-combo: extract common function to
setup clocks") changed the offset that is used to write to
DP_PHY_VCO_DIV from QSERDES_V3_DP_PHY_VCO_DIV to
QSERDES_V4_DP_PHY_VCO_DIV. Unfortunately, this offset is different
between v3 and v4 phys:

 #define QSERDES_V3_DP_PHY_VCO_DIV                 0x064
 #define QSERDES_V4_DP_PHY_VCO_DIV                 0x070

meaning that we write the wrong register on v3 phys now. Add another
generic register to 'regs' and use it here instead of a version specific
define to fix this.

This was discovered after Abhinav looked over register dumps with me
from sc7180 Trogdor devices that started failing to light up the
external display with v6.6 based kernels. It turns out that some
monitors are very specific about their link clk frequency and if the
default power on reset value is still there the monitor will show a
blank screen or a garbled display. Other monitors are perfectly happy to
get a bad clock signal.

Cc: Douglas Anderson <dianders@chromium.org>
Cc: Abhinav Kumar <quic_abhinavk@quicinc.com>
Cc: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Fixes: ec17373aebd0 ("phy: qcom: qmp-combo: extract common function to setup clocks")
Signed-off-by: Stephen Boyd <swboyd@chromium.org>
---
 drivers/phy/qualcomm/phy-qcom-qmp-combo.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/phy/qualcomm/phy-qcom-qmp-combo.c b/drivers/phy/qualcomm/phy-qcom-qmp-combo.c
index 7d585a4bbbba..3b19d8ebf467 100644
--- a/drivers/phy/qualcomm/phy-qcom-qmp-combo.c
+++ b/drivers/phy/qualcomm/phy-qcom-qmp-combo.c
@@ -77,6 +77,7 @@ enum qphy_reg_layout {
 	QPHY_COM_BIAS_EN_CLKBUFLR_EN,
 
 	QPHY_DP_PHY_STATUS,
+	QPHY_DP_PHY_VCO_DIV,
 
 	QPHY_TX_TX_POL_INV,
 	QPHY_TX_TX_DRV_LVL,
@@ -102,6 +103,7 @@ static const unsigned int qmp_v3_usb3phy_regs_layout[QPHY_LAYOUT_SIZE] = {
 	[QPHY_COM_BIAS_EN_CLKBUFLR_EN]	= QSERDES_V3_COM_BIAS_EN_CLKBUFLR_EN,
 
 	[QPHY_DP_PHY_STATUS]		= QSERDES_V3_DP_PHY_STATUS,
+	[QPHY_DP_PHY_VCO_DIV]		= QSERDES_V3_DP_PHY_VCO_DIV,
 
 	[QPHY_TX_TX_POL_INV]		= QSERDES_V3_TX_TX_POL_INV,
 	[QPHY_TX_TX_DRV_LVL]		= QSERDES_V3_TX_TX_DRV_LVL,
@@ -126,6 +128,7 @@ static const unsigned int qmp_v45_usb3phy_regs_layout[QPHY_LAYOUT_SIZE] = {
 	[QPHY_COM_BIAS_EN_CLKBUFLR_EN]	= QSERDES_V4_COM_BIAS_EN_CLKBUFLR_EN,
 
 	[QPHY_DP_PHY_STATUS]		= QSERDES_V4_DP_PHY_STATUS,
+	[QPHY_DP_PHY_VCO_DIV]		= QSERDES_V4_DP_PHY_VCO_DIV,
 
 	[QPHY_TX_TX_POL_INV]		= QSERDES_V4_TX_TX_POL_INV,
 	[QPHY_TX_TX_DRV_LVL]		= QSERDES_V4_TX_TX_DRV_LVL,
@@ -2162,6 +2165,7 @@ static int qmp_combo_configure_dp_clocks(struct qmp_combo *qmp)
 	const struct phy_configure_opts_dp *dp_opts = &qmp->dp_opts;
 	u32 phy_vco_div;
 	unsigned long pixel_freq;
+	const struct qmp_phy_cfg *cfg = qmp->cfg;
 
 	switch (dp_opts->link_rate) {
 	case 1620:
@@ -2184,7 +2188,7 @@ static int qmp_combo_configure_dp_clocks(struct qmp_combo *qmp)
 		/* Other link rates aren't supported */
 		return -EINVAL;
 	}
-	writel(phy_vco_div, qmp->dp_dp_phy + QSERDES_V4_DP_PHY_VCO_DIV);
+	writel(phy_vco_div, qmp->dp_dp_phy + cfg->regs[QPHY_DP_PHY_VCO_DIV]);
 
 	clk_set_rate(qmp->dp_link_hw.clk, dp_opts->link_rate * 100000);
 	clk_set_rate(qmp->dp_pixel_hw.clk, pixel_freq);

base-commit: 4cece764965020c22cff7665b18a012006359095
-- 
https://chromeos.dev

