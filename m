Received: from mail-pg1-f182.google.com (mail-pg1-f182.google.com [209.85.215.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 156247E
	for <patches@lists.linux.dev>; Fri, 20 May 2022 23:13:57 +0000 (UTC)
Received: by mail-pg1-f182.google.com with SMTP id a38so6036746pgl.9
        for <patches@lists.linux.dev>; Fri, 20 May 2022 16:13:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=pRRzBzpTvPKL4ArnfdaUFW1cDfFNVquKut1ZEam2zu8=;
        b=Qn7a9XbSwUWVcls8bMgVqhGcd6+Uwun0qQOM4rQuyzDlHm+4/j7XV0G8dnCzhmutcD
         4ogENdLmRs9/m0jWAb5dgPeXelOheCwNpo2dqZTr/cpMqwyz/+7qy4JelCfRidWzdMeO
         uiA5o4DcC87pPoYpzsQDuH4KvqtDikBFd6dlQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=pRRzBzpTvPKL4ArnfdaUFW1cDfFNVquKut1ZEam2zu8=;
        b=dBJJVCmC0Ngzl/sNihUD2pGgJ4ZOsbfhOGE1oETA/5fEGpCxRVSrL5l/SoGm7iczcF
         JlTsVsKfJNnNSW2YLm/ul4TscqmiMGxGg1quinlyqf1L1Qdv/eiIZ5mQyDghVcFhEd7F
         l//H4ko8e/jHcU/CLfG+Y4RP7yWghqxHOpzcj+1R2hYkZaDc11V6liGBMfEod8rKrGaH
         PVLxLb/2Fe59JqqnTiyM2y/EEHA6c5tlzwI0tbGYVKi0D/IrpDZki6ZUX3gKu4dQNk3a
         eqs5vcQT/KJZoBtxyj783h91kgvOKxnn0s+7PYy3c81EsAcY4sPU4erB+n+fKP3cvOMi
         hIuw==
X-Gm-Message-State: AOAM530mGDa+bbIaaTwvpwCkONtQXCbto6DJYDrePBJvtUT4eQRqvEz3
	14EK67SDwyoOZDmTLgdMoAcgog==
X-Google-Smtp-Source: ABdhPJw94RKVYJtddL2x1+4L2GbIeueEMeZstosPkRJ/Wmtdl9kxiE1lO4z96eViqqe4F3Vs3PWpQA==
X-Received: by 2002:a62:3881:0:b0:4b0:b1c:6fd9 with SMTP id f123-20020a623881000000b004b00b1c6fd9mr12445491pfa.27.1653088437410;
        Fri, 20 May 2022 16:13:57 -0700 (PDT)
Received: from smtp.gmail.com ([2620:15c:202:201:72c1:e5e8:3ad8:f199])
        by smtp.gmail.com with ESMTPSA id o16-20020a17090ac09000b001d77f392280sm2420777pjs.30.2022.05.20.16.13.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 May 2022 16:13:56 -0700 (PDT)
From: Stephen Boyd <swboyd@chromium.org>
To: Andy Gross <agross@kernel.org>,
	Bjorn Andersson <bjorn.andersson@linaro.org>
Cc: linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	linux-arm-msm@vger.kernel.org,
	Douglas Anderson <dianders@chromium.org>,
	"Joseph S. Barrera III" <joebar@chromium.org>,
	Matthias Kaehlcke <mka@chromium.org>
Subject: [PATCH] arm64: dts: qcom: Remove duplicate sc7180-trogdor include on lazor
Date: Fri, 20 May 2022 16:13:55 -0700
Message-Id: <20220520231355.1559104-1-swboyd@chromium.org>
X-Mailer: git-send-email 2.36.1.124.g0e6072fb45-goog
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The sc7180-trogdor-lazor-*.dtsi files all include sc7180-trogdor.dtsi
and sc7180-trogdor-lazor.dtsi, so including it here in the
sc7180-trogdor-lazor.dtsi file means we have a duplicate include after
commit 19794489fa24 ("arm64: dts: qcom: Only include sc7180.dtsi in
sc7180-trogdor.dtsi"). We include the sc7180-trogdor.dtsi file in a
board like sc7180-trogdor-lazor-r1.dts so that we can include the
display bridge snippet (e.g. sc7180-trogdor-ti-sn65dsi86.dtsi) instead
of making ever increasing variants like
sc7180-trogdor-lazor-ti-sn65dsi86.dtsi.

Fix this by dropping the include and making a note that the
sc7180-trogdor-lazor.dtsi file must be included after
sc7180-trogdor.dtsi

Reported-by: Douglas Anderson <dianders@chromium.org>
Cc: "Joseph S. Barrera III" <joebar@chromium.org>
Cc: Matthias Kaehlcke <mka@chromium.org>
Fixes: 19794489fa24 ("arm64: dts: qcom: Only include sc7180.dtsi in sc7180-trogdor.dtsi")
Signed-off-by: Stephen Boyd <swboyd@chromium.org>
---
 arch/arm64/boot/dts/qcom/sc7180-trogdor-lazor.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/sc7180-trogdor-lazor.dtsi b/arch/arm64/boot/dts/qcom/sc7180-trogdor-lazor.dtsi
index fe2369c29aad..88f6a7d4d020 100644
--- a/arch/arm64/boot/dts/qcom/sc7180-trogdor-lazor.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc7180-trogdor-lazor.dtsi
@@ -5,7 +5,7 @@
  * Copyright 2020 Google LLC.
  */
 
-#include "sc7180-trogdor.dtsi"
+/* This file must be included after sc7180-trogdor.dtsi */
 
 &ap_sar_sensor {
 	semtech,cs0-ground;

base-commit: 19794489fa2474a55c00848e00ca3d15ea01d36c
-- 
https://chromeos.dev

