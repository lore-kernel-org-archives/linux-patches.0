Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E92C83CB9
	for <patches@lists.linux.dev>; Mon, 29 Apr 2024 19:46:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714419976; cv=none; b=YYPFqwuZrt4Di4MlYGMx/uKzTZrriu+cAgDVf1+2U3FUtIGDQXmoEivP+p/0Ge6lLRgiTgzD2nvPCGivs6wobr3TpccNR5moMTBF6WMtUeWGzv12sI4QE8Tg3XUGlf3o5YAmy7MAE3f5pFwqEW6F09siQFv9WVFtpf+W2VBjRrY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714419976; c=relaxed/simple;
	bh=Fflv2happyBtuC7pAoLoJyMtZKZg3vbQFe9oCckEd2g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZRyI/wYd8U1ZmFKSS51KJ7lPhCGTXaaYncBujVJSVenjkqA0HuUfISgEOROK82StalYu+jynrj2juGJFXSbd8cCHVewJSTqSVy6yTUlsqHC/HY9U93zEri6ke0TXeql0glHBLR+CIQPrIljoxqWl2pNEFIs85jedQ67MDwjiJG0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=DPyfsvNs; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="DPyfsvNs"
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-1e5715a9ebdso40753305ad.2
        for <patches@lists.linux.dev>; Mon, 29 Apr 2024 12:46:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1714419975; x=1715024775; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4QjCg8SYenXS+XuIi5qqPpTiXsYXZeRvUkEwlZZQZlc=;
        b=DPyfsvNsmcLGNRMkMolIkgAUZReigfNuu7TPVKVmR0cBIzDxXECTxp2Ry0hsuNZK7h
         +Ug402VPM1pg5STVFLprqs9wrgZftZhDWdYMCR5Ktg4S/4GUOcBhHyEXCkJJmOcdSQzn
         piNq2a3oOgOlzvGep54uMGO0Uq6Rb2ES1QfNk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714419975; x=1715024775;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4QjCg8SYenXS+XuIi5qqPpTiXsYXZeRvUkEwlZZQZlc=;
        b=IZg5rra/HMrC9qfhBmlqJ7VQ5V/u8T5hhuzFcp7m5AB4+5I/nysEkOr4aBzDmKTD8f
         X1SBmPSzhAmuPbb+xNW9ss4snnIZEMaN2AfXGBqs+omxfNCZPO45IbOrhIf4toEZwjig
         mAtmXtamuxqymO7jrx2ivRbHBMPvPWt3dvkSRj5ZwyGQMP+3k7G/Tvy7O1qqcSyTCntX
         q0iP1RH3FAlPFSyNebf964iFFMhzYgVldsbA3wuaC5UZTwcssU457N6ZPgCBS5yGbGfy
         /PSYnKXAXVSpia8QRBN31FZoEYk69Rb71iD9ekLeLVqJE/BPmfHFTpal8G5WO2R4E4Jp
         Nmqw==
X-Forwarded-Encrypted: i=1; AJvYcCW4a9BFn4swXBoZsZaPWPosF0CVWXVIvxcbVSYDdl6HQB0KJxGEfRpqJONaUV7BjS6Kx7LSilnA7jx9wHsxRc9u+c+yXZWjYA==
X-Gm-Message-State: AOJu0Yz2GOgKHRuYKqDAwAWmX/4P9tiuofHmbmXAqaODeaC/k3mQZrV0
	YHUlC+7pPsCKr3ZyZyZGi0tptvF1r+JnbVildP06z1VSFDenMl4iOs+t+FylgA==
X-Google-Smtp-Source: AGHT+IFvxwrm+Nf34l1bmpd2F1KsT83NJku+4ZXZlMzkvoySXOfcschxgtys9x2RHfgzmnb0ut+qdA==
X-Received: by 2002:a17:903:40cc:b0:1e4:a667:550e with SMTP id t12-20020a17090340cc00b001e4a667550emr10072628pld.20.1714419974796;
        Mon, 29 Apr 2024 12:46:14 -0700 (PDT)
Received: from localhost (4.198.125.34.bc.googleusercontent.com. [34.125.198.4])
        by smtp.gmail.com with UTF8SMTPSA id o16-20020a170902d4d000b001eb3f4e96c2sm5236162plg.157.2024.04.29.12.46.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 29 Apr 2024 12:46:14 -0700 (PDT)
From: Stephen Boyd <swboyd@chromium.org>
To: stable@vger.kernel.org
Cc: Johan Hovold <johan+linaro@kernel.org>,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Abhinav Kumar <quic_abhinavk@quicinc.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 6.8.y] phy: qcom: qmp-combo: fix VCO div offset on v5_5nm and v6
Date: Mon, 29 Apr 2024 12:46:12 -0700
Message-ID: <20240429194612.3412821-1-swboyd@chromium.org>
X-Mailer: git-send-email 2.45.0.rc0.197.gbae5840b3b-goog
In-Reply-To: <2024042918-jet-harmonica-e767@gregkh>
References: <2024042918-jet-harmonica-e767@gregkh>
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
index d83859e955a8..dee666f8e29e 100644
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
index 6923496cbfee..49ceded9b3cb 100644
--- a/drivers/phy/qualcomm/phy-qcom-qmp.h
+++ b/drivers/phy/qualcomm/phy-qcom-qmp.h
@@ -132,9 +132,11 @@
 #define QSERDES_V4_DP_PHY_AUX_INTERRUPT_STATUS		0x0d8
 #define QSERDES_V4_DP_PHY_STATUS			0x0dc
 
+#define QSERDES_V5_DP_PHY_VCO_DIV			0x070
 #define QSERDES_V5_DP_PHY_STATUS			0x0dc
 
 /* Only for QMP V6 PHY - DP PHY registers */
+#define QSERDES_V6_DP_PHY_VCO_DIV			0x070
 #define QSERDES_V6_DP_PHY_AUX_INTERRUPT_STATUS		0x0e0
 #define QSERDES_V6_DP_PHY_STATUS			0x0e4
 
-- 
https://chromeos.dev

