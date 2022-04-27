Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE63B64C
	for <patches@lists.linux.dev>; Wed, 27 Apr 2022 02:03:45 +0000 (UTC)
Received: by mail-pl1-f180.google.com with SMTP id h12so343649plf.12
        for <patches@lists.linux.dev>; Tue, 26 Apr 2022 19:03:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=IsZlbQsLWz0QOpEE8Q49QKK/xrVS19U6wy6L3ZRioo0=;
        b=PR6vJ1BFrsbzEIyCBU+Yaei+DFk23SdPZaWHZUdskP4Nn0HqSyd+uEDGScjf8Y174C
         mBrvEjdb1W9Pm/2uiqPF07JxuyxUI4ZnToANMUpW/aUioT3iIpHx0eLws4Z6pBq9Vvwf
         Al7gYm9GHmVyzvg66ZqFUxofNo0UsM/CmIvbY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=IsZlbQsLWz0QOpEE8Q49QKK/xrVS19U6wy6L3ZRioo0=;
        b=xF09BqXTQ+grVg2ljNjnSb76bN0GpSHJXkO1Vlkrc9fG70UNLZt0KRh8LVlUc2WAF/
         Orj+FZEQzJ+Fy+s5cL6K4mblclo5rnP8is0TLNs4/GP8t4OZdmBckTv7X5ykjl2cvOHt
         qGm0tPPFkko+Z3mSm8uJTd70ownN6+jMV5YcR/vEdjyZ0ck+3Ty4c0hAejoKTaIG7Mmt
         jhZ075PYVugm3ULhBxVIMYZNIdGxu7CxuYZLWFMiojukwnhjgv2vR3fN++XGyO1APtSr
         PLR0F6aoZCLewMKTwO1o2owuxkVwEBfjVb2bvG4TdrQPEkmgsRgOIWdWTKqQser+oekv
         +l9Q==
X-Gm-Message-State: AOAM532oiChPXlWJr1NTMTdeJWZT4k2refZS6vR6ZJTqeKgtEnYIba33
	vuNHuSzDnzvOuTS7sO3235j/PA==
X-Google-Smtp-Source: ABdhPJz0d+vYS+RNgyPxW7emSuqX0TIM5P7LtPrQRlY01RTKs1I5onV9ABIJ7MIl6S35/NISjwVBKg==
X-Received: by 2002:a17:90b:4f43:b0:1da:3cba:bd51 with SMTP id pj3-20020a17090b4f4300b001da3cbabd51mr201502pjb.246.1651025025217;
        Tue, 26 Apr 2022 19:03:45 -0700 (PDT)
Received: from smtp.gmail.com ([2620:15c:202:201:482e:60bc:84d1:bf5c])
        by smtp.gmail.com with ESMTPSA id g15-20020a056a0023cf00b004e17e11cb17sm18324197pfc.111.2022.04.26.19.03.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Apr 2022 19:03:44 -0700 (PDT)
From: Stephen Boyd <swboyd@chromium.org>
To: Andy Gross <agross@kernel.org>,
	Bjorn Andersson <bjorn.andersson@linaro.org>
Cc: linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	linux-arm-msm@vger.kernel.org,
	"Joseph S. Barrera III" <joebar@chromium.org>,
	Douglas Anderson <dianders@chromium.org>
Subject: [PATCH v2 2/3] arm64: dts: qcom: sc7180-trogdor: Simplify spi0/spi6 labeling
Date: Tue, 26 Apr 2022 19:03:38 -0700
Message-Id: <20220427020339.360855-3-swboyd@chromium.org>
X-Mailer: git-send-email 2.36.0.rc2.479.g8af0fa9b8e-goog
In-Reply-To: <20220427020339.360855-1-swboyd@chromium.org>
References: <20220427020339.360855-1-swboyd@chromium.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

We had to do this spi0/spi6 flip-flop on trogdor-r0 because the spi
buses got swizzled between r0 and r1. The swizzle stopped after r1, but
we kept this around to support either hardware possibility and to keep
trogdor-r0 working.

trogdor-r0 isn't supported upstream, so this swizzle is not doing
anything besides making a pattern that others tryt  to copy for the EC and
H1 nodes. Let's remove it and simplify the dts files.

Cc: "Joseph S. Barrera III" <joebar@chromium.org>
Cc: Douglas Anderson <dianders@chromium.org>
Signed-off-by: Stephen Boyd <swboyd@chromium.org>
---
 arch/arm64/boot/dts/qcom/sc7180-trogdor-coachz.dtsi   | 6 +-----
 arch/arm64/boot/dts/qcom/sc7180-trogdor-homestar.dtsi | 3 ---
 arch/arm64/boot/dts/qcom/sc7180-trogdor-lazor.dtsi    | 3 ---
 arch/arm64/boot/dts/qcom/sc7180-trogdor-pompom.dtsi   | 4 ----
 arch/arm64/boot/dts/qcom/sc7180-trogdor-r1.dts        | 4 ----
 arch/arm64/boot/dts/qcom/sc7180-trogdor.dtsi          | 4 ++--
 6 files changed, 3 insertions(+), 21 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sc7180-trogdor-coachz.dtsi b/arch/arm64/boot/dts/qcom/sc7180-trogdor-coachz.dtsi
index 8da61a52f150..ac2279142a95 100644
--- a/arch/arm64/boot/dts/qcom/sc7180-trogdor-coachz.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc7180-trogdor-coachz.dtsi
@@ -6,14 +6,10 @@
  */
 
 #include "sc7180.dtsi"
-
-ap_ec_spi: &spi6 {};
-ap_h1_spi: &spi0 {};
-
 #include "sc7180-trogdor.dtsi"
 #include "sc7180-trogdor-ti-sn65dsi86.dtsi"
 
-/* Deleted nodes from trogdor.dtsi */
+/* Deleted nodes from sc7180-trogdor.dtsi */
 
 /delete-node/ &alc5682;
 /delete-node/ &pp3300_codec;
diff --git a/arch/arm64/boot/dts/qcom/sc7180-trogdor-homestar.dtsi b/arch/arm64/boot/dts/qcom/sc7180-trogdor-homestar.dtsi
index 532c7dcc3f73..9b3e3d13c165 100644
--- a/arch/arm64/boot/dts/qcom/sc7180-trogdor-homestar.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc7180-trogdor-homestar.dtsi
@@ -5,9 +5,6 @@
  * Copyright 2021 Google LLC.
  */
 
-ap_ec_spi: &spi6 {};
-ap_h1_spi: &spi0 {};
-
 #include "sc7180-trogdor.dtsi"
 
 / {
diff --git a/arch/arm64/boot/dts/qcom/sc7180-trogdor-lazor.dtsi b/arch/arm64/boot/dts/qcom/sc7180-trogdor-lazor.dtsi
index 75df5d1633b2..fe2369c29aad 100644
--- a/arch/arm64/boot/dts/qcom/sc7180-trogdor-lazor.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc7180-trogdor-lazor.dtsi
@@ -5,9 +5,6 @@
  * Copyright 2020 Google LLC.
  */
 
-ap_ec_spi: &spi6 {};
-ap_h1_spi: &spi0 {};
-
 #include "sc7180-trogdor.dtsi"
 
 &ap_sar_sensor {
diff --git a/arch/arm64/boot/dts/qcom/sc7180-trogdor-pompom.dtsi b/arch/arm64/boot/dts/qcom/sc7180-trogdor-pompom.dtsi
index 410ca2a76d81..3bca7545ffe5 100644
--- a/arch/arm64/boot/dts/qcom/sc7180-trogdor-pompom.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc7180-trogdor-pompom.dtsi
@@ -6,10 +6,6 @@
  */
 
 #include "sc7180.dtsi"
-
-ap_ec_spi: &spi6 {};
-ap_h1_spi: &spi0 {};
-
 #include "sc7180-trogdor.dtsi"
 #include "sc7180-trogdor-ti-sn65dsi86.dtsi"
 
diff --git a/arch/arm64/boot/dts/qcom/sc7180-trogdor-r1.dts b/arch/arm64/boot/dts/qcom/sc7180-trogdor-r1.dts
index 311c42a535ff..6c822c84112a 100644
--- a/arch/arm64/boot/dts/qcom/sc7180-trogdor-r1.dts
+++ b/arch/arm64/boot/dts/qcom/sc7180-trogdor-r1.dts
@@ -8,10 +8,6 @@
 /dts-v1/;
 
 #include "sc7180.dtsi"
-
-ap_ec_spi: &spi6 {};
-ap_h1_spi: &spi0 {};
-
 #include "sc7180-trogdor.dtsi"
 #include "sc7180-trogdor-ti-sn65dsi86.dtsi"
 
diff --git a/arch/arm64/boot/dts/qcom/sc7180-trogdor.dtsi b/arch/arm64/boot/dts/qcom/sc7180-trogdor.dtsi
index 7648be83f7e4..ea5bedc3d1cb 100644
--- a/arch/arm64/boot/dts/qcom/sc7180-trogdor.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc7180-trogdor.dtsi
@@ -626,7 +626,7 @@ src_vreg_bob: bob {
 	};
 };
 
-&ap_ec_spi {
+ap_ec_spi: &spi6 {
 	status = "okay";
 	cros_ec: ec@0 {
 		compatible = "google,cros-ec-spi";
@@ -675,7 +675,7 @@ usb_c1: connector@1 {
 	};
 };
 
-&ap_h1_spi {
+ap_h1_spi: &spi0 {
 	status = "okay";
 	cr50: tpm@0 {
 		compatible = "google,cr50";
-- 
https://chromeos.dev

