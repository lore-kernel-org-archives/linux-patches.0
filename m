Received: from mail-pg1-f180.google.com (mail-pg1-f180.google.com [209.85.215.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49A0D2FAE
	for <patches@lists.linux.dev>; Thu,  2 Jun 2022 19:06:24 +0000 (UTC)
Received: by mail-pg1-f180.google.com with SMTP id c14so5474169pgu.13
        for <patches@lists.linux.dev>; Thu, 02 Jun 2022 12:06:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=A+CJHPksJEyQ/br0kNUyJ2paAkEWbd02hKrM4zpgQyQ=;
        b=DftemrRpxgHU1PB1Zl247GpilafWiRfmuWeotJzMK1VZeLBmDqw1XVVJPA53kteARU
         XGS/yfyDrMHQslfTX7pA21vfF21sHFG2IfDmoRjE+eQqmxDRtPtj/UZEd+qxT++nSu4t
         82hhWgZnRfGVqVMT6G/+rQViZi921qzEPdObU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=A+CJHPksJEyQ/br0kNUyJ2paAkEWbd02hKrM4zpgQyQ=;
        b=aKP3d2gXI3+tAiYCyCOgVuPiRV8NnopbLF2gzfpVAVm3KWMYxjumER93PLXX5PQNuw
         rtQHcqmgGkwA3lst6HAoG+Ysf9PthNKSGRfW5t9iJHF6yGgujprunLoBeiTr2n5rJdUv
         dfit6wivny00+B9YfKotTB1BXlUXQt+j/q0qNn4zcPZSYmfcFg4YQfZZYvVZGPML/C+b
         OHtNGfBwsdfzomM3BqonF3+Cn6mvTQPSj4C4yqbm0vQkpnChZydwFnDZxJreXcQaqVui
         /RmxwtJ5ngTVf8RuZhy9V6Z7yzwZOeL/Oq1T1/LIUyXVop7Xzf8ahN3Ji33SJqUK6XyN
         Q4Kw==
X-Gm-Message-State: AOAM531fkG97tViy42X/OTKX/i8JAsEVZS4wxPYJ6Omm/ZtyP2B9N6q+
	VVkjKy/jD7wGSOyMqPvXZw3ugg==
X-Google-Smtp-Source: ABdhPJzTc/a6pzmNkyPjyl9vwfz3NHCs0ZPckhN2iQUoju04q2sVsqtxC4zMCL5PFu1/nbWvdqSF1Q==
X-Received: by 2002:a63:d446:0:b0:3fc:1370:798a with SMTP id i6-20020a63d446000000b003fc1370798amr5610931pgj.190.1654196783584;
        Thu, 02 Jun 2022 12:06:23 -0700 (PDT)
Received: from smtp.gmail.com ([2620:15c:202:201:6885:8b62:3875:9d55])
        by smtp.gmail.com with ESMTPSA id d20-20020a056a00199400b0051878e8cc13sm4197895pfl.116.2022.06.02.12.06.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Jun 2022 12:06:23 -0700 (PDT)
From: Stephen Boyd <swboyd@chromium.org>
To: Andy Gross <agross@kernel.org>,
	Bjorn Andersson <bjorn.andersson@linaro.org>
Cc: linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	linux-arm-msm@vger.kernel.org,
	Douglas Anderson <dianders@chromium.org>,
	"Joseph S. Barrera III" <joebar@chromium.org>,
	Matthias Kaehlcke <mka@chromium.org>
Subject: [PATCH v2] arm64: dts: qcom: Remove duplicate sc7180-trogdor include on lazor/homestar
Date: Thu,  2 Jun 2022 12:06:21 -0700
Message-Id: <20220602190621.1646679-1-swboyd@chromium.org>
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The sc7180-trogdor-{lazor,homestar}-*.dtsi files all include
sc7180-trogdor.dtsi and sc7180-trogdor-lazor.dtsi or
sc7180-trogdor-homestar.dtsi, so including it here in the
sc7180-trogdor-{lazor,homestar}.dtsi file means we have a duplicate
include after commit 19794489fa24 ("arm64: dts: qcom: Only include
sc7180.dtsi in sc7180-trogdor.dtsi"). We include the sc7180-trogdor.dtsi
file in a board like sc7180-trogdor-lazor-r1.dts so that we can include
the display bridge snippet (e.g. sc7180-trogdor-ti-sn65dsi86.dtsi)
instead of making ever increasing variants like
sc7180-trogdor-lazor-ti-sn65dsi86.dtsi.

Unfortunately, having the double include like this means the display
bridge's i2c bus is left disabled instead of enabled by the bridge
snippet. Any boards that use the i2c bus for the display bridge will
have the bus disabled when we include sc7180-trogdor.dtsi the second
time, which picks up the i2c status="disabled" line from sc7180.dtsi.
This leads to the display not turning on and black screens at boot on
lazor and homestar devices.

Fix this by dropping the include and making a note that the
sc7180-trogdor-{lazor,homestar}.dtsi file must be included after
sc7180-trogdor.dtsi

Reported-by: Douglas Anderson <dianders@chromium.org>
Cc: "Joseph S. Barrera III" <joebar@chromium.org>
Cc: Matthias Kaehlcke <mka@chromium.org>
Fixes: 19794489fa24 ("arm64: dts: qcom: Only include sc7180.dtsi in sc7180-trogdor.dtsi")
Signed-off-by: Stephen Boyd <swboyd@chromium.org>
---

It would be great to get this into -rc1 if possible to fix broken
display.

Changes from v1 (https://lore.kernel.org/r/20220520231355.1559104-1-swboyd@chromium.org):
 * Also do the same on homestar

I found that my script to check differences wasn't printing any
differences because of a typo, so I thought everything was fine when it
wasn't! Now I've checked and for boards using parade bridge chips quite
a few phandles are renumbered but they're the same logically as before
whereas as boards using the ti bridge chip only have a few lines
reordered.

 arch/arm64/boot/dts/qcom/sc7180-trogdor-homestar.dtsi | 2 +-
 arch/arm64/boot/dts/qcom/sc7180-trogdor-lazor.dtsi    | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sc7180-trogdor-homestar.dtsi b/arch/arm64/boot/dts/qcom/sc7180-trogdor-homestar.dtsi
index 9b3e3d13c165..d1e2df5164ea 100644
--- a/arch/arm64/boot/dts/qcom/sc7180-trogdor-homestar.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc7180-trogdor-homestar.dtsi
@@ -5,7 +5,7 @@
  * Copyright 2021 Google LLC.
  */
 
-#include "sc7180-trogdor.dtsi"
+/* This file must be included after sc7180-trogdor.dtsi */
 
 / {
 	/* BOARD-SPECIFIC TOP LEVEL NODES */
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

