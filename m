Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1377621
	for <patches@lists.linux.dev>; Wed, 27 Apr 2022 02:03:46 +0000 (UTC)
Received: by mail-pf1-f181.google.com with SMTP id b15so379577pfm.5
        for <patches@lists.linux.dev>; Tue, 26 Apr 2022 19:03:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=D4jnht1c5Kgw5e3GXlYF8fsD8xe9LBqpiwIiKCgR7SQ=;
        b=IUgrYQrhOP0dako0NPfxiJu5zzUHUwRrwNfWXw5uqrRgi71KlHL981Ak+LSyfpwjc8
         Ta/4SSH/QEHSlur9Z8VxrSVXWPE78Ik84bvNX4616IU1q+BiFCJTCS3lykbYA+MqRUw2
         IZVm8kQwyj6bztTqCpI2JEMl/c97yj0mJl0Ig=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=D4jnht1c5Kgw5e3GXlYF8fsD8xe9LBqpiwIiKCgR7SQ=;
        b=jvVZ4YbfZNtJNuppdNrxr6v3P2P7Ui4KZuHH0NRUpovU2soJC9GDSoYSUWyrrOcddQ
         Z7ArFcqPa7JH74JlhtmDGbLZH1yoGmugQPult+LkTSxc8I/6mRzs13RALnnks3EmWWqN
         Cjk/Q92LBcSngrqzwwseqKS/jWamu+PopddSOfEarc94rl5P4CbLirXfUpp9o2kjv669
         4UwQIIzDjrYiD87ZqALbVyyDQS4IAgtxXYWkl9OJm/wfmvpp9eTJazd+rwGjKy5PArtZ
         jZK4NIH58hJlJnXIU4xG2lQ6tKziUMitezVFKa/wllbfD4Zk8y4uIaYIMaf2O3DLv06n
         3euw==
X-Gm-Message-State: AOAM532+kMvbiOnTcgALaFIQWMKTeiLuJnp/XmaMOf/23sCYnOeq5UeZ
	a0+ZtHgY2+rNm1dj4/SNt1bXmA==
X-Google-Smtp-Source: ABdhPJytHxFAohQo92hRvg2LG2Wl7JyrqpSqlwvhAu43tYRp6CaqKZl0+iJhldAycfZ4JjEu7yGhVg==
X-Received: by 2002:a05:6a00:1494:b0:50d:4b12:8dfa with SMTP id v20-20020a056a00149400b0050d4b128dfamr9953075pfu.43.1651025026172;
        Tue, 26 Apr 2022 19:03:46 -0700 (PDT)
Received: from smtp.gmail.com ([2620:15c:202:201:482e:60bc:84d1:bf5c])
        by smtp.gmail.com with ESMTPSA id g15-20020a056a0023cf00b004e17e11cb17sm18324197pfc.111.2022.04.26.19.03.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Apr 2022 19:03:45 -0700 (PDT)
From: Stephen Boyd <swboyd@chromium.org>
To: Andy Gross <agross@kernel.org>,
	Bjorn Andersson <bjorn.andersson@linaro.org>
Cc: linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	linux-arm-msm@vger.kernel.org,
	"Joseph S. Barrera III" <joebar@chromium.org>,
	Douglas Anderson <dianders@chromium.org>
Subject: [PATCH v2 3/3] arm64: dts: qcom: Only include sc7180.dtsi in sc7180-trogdor.dtsi
Date: Tue, 26 Apr 2022 19:03:39 -0700
Message-Id: <20220427020339.360855-4-swboyd@chromium.org>
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

The SoC is always present on sc7180-trogdor.dtsi and thus we should
include it in the "generic" dtsi file for trogdor. Previously we had
removed it from there because we had to do the spi6/spi0 swizzle, so
each trogdor variant board had to include sc7180.dtsi and then
sc7180-trogdor.dtsi so that the latter dtsi file could modify the right
spi bus for EC and H1 properties that are common to all trogdor boards.

Now that we're done with that we can replace sc7180.dtsi includes with
sc7180-trogdor.dtsi and include sc7180.dtsi in sc7180-trogdor.dtsi as
was originally intended. We still need to include sc7180-trogdor.dtsi
before the bridge dtsi files though because those rely on the panel
label.

Cc: "Joseph S. Barrera III" <joebar@chromium.org>
Cc: Douglas Anderson <dianders@chromium.org>
Signed-off-by: Stephen Boyd <swboyd@chromium.org>
---
 arch/arm64/boot/dts/qcom/sc7180-trogdor-coachz.dtsi            | 1 -
 arch/arm64/boot/dts/qcom/sc7180-trogdor-homestar-r2.dts        | 2 +-
 arch/arm64/boot/dts/qcom/sc7180-trogdor-homestar-r3.dts        | 2 +-
 arch/arm64/boot/dts/qcom/sc7180-trogdor-homestar-r4.dts        | 2 +-
 .../boot/dts/qcom/sc7180-trogdor-lazor-limozeen-nots-r5.dts    | 2 +-
 .../boot/dts/qcom/sc7180-trogdor-lazor-limozeen-nots-r9.dts    | 2 +-
 arch/arm64/boot/dts/qcom/sc7180-trogdor-lazor-limozeen-r4.dts  | 2 +-
 arch/arm64/boot/dts/qcom/sc7180-trogdor-lazor-limozeen-r9.dts  | 2 +-
 arch/arm64/boot/dts/qcom/sc7180-trogdor-lazor-r0.dts           | 2 +-
 arch/arm64/boot/dts/qcom/sc7180-trogdor-lazor-r1.dts           | 2 +-
 arch/arm64/boot/dts/qcom/sc7180-trogdor-lazor-r3-kb.dts        | 2 +-
 arch/arm64/boot/dts/qcom/sc7180-trogdor-lazor-r3-lte.dts       | 2 +-
 arch/arm64/boot/dts/qcom/sc7180-trogdor-lazor-r3.dts           | 2 +-
 arch/arm64/boot/dts/qcom/sc7180-trogdor-lazor-r9-kb.dts        | 2 +-
 arch/arm64/boot/dts/qcom/sc7180-trogdor-lazor-r9-lte.dts       | 2 +-
 arch/arm64/boot/dts/qcom/sc7180-trogdor-lazor-r9.dts           | 2 +-
 arch/arm64/boot/dts/qcom/sc7180-trogdor-pompom.dtsi            | 1 -
 arch/arm64/boot/dts/qcom/sc7180-trogdor-r1.dts                 | 1 -
 arch/arm64/boot/dts/qcom/sc7180-trogdor.dtsi                   | 3 ++-
 19 files changed, 17 insertions(+), 19 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sc7180-trogdor-coachz.dtsi b/arch/arm64/boot/dts/qcom/sc7180-trogdor-coachz.dtsi
index ac2279142a95..8ac1f1e61006 100644
--- a/arch/arm64/boot/dts/qcom/sc7180-trogdor-coachz.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc7180-trogdor-coachz.dtsi
@@ -5,7 +5,6 @@
  * Copyright 2020 Google LLC.
  */
 
-#include "sc7180.dtsi"
 #include "sc7180-trogdor.dtsi"
 #include "sc7180-trogdor-ti-sn65dsi86.dtsi"
 
diff --git a/arch/arm64/boot/dts/qcom/sc7180-trogdor-homestar-r2.dts b/arch/arm64/boot/dts/qcom/sc7180-trogdor-homestar-r2.dts
index 70032983fb65..d9e905ed4e62 100644
--- a/arch/arm64/boot/dts/qcom/sc7180-trogdor-homestar-r2.dts
+++ b/arch/arm64/boot/dts/qcom/sc7180-trogdor-homestar-r2.dts
@@ -7,7 +7,7 @@
 
 /dts-v1/;
 
-#include "sc7180.dtsi"
+#include "sc7180-trogdor.dtsi"
 #include "sc7180-trogdor-ti-sn65dsi86.dtsi"
 #include "sc7180-trogdor-homestar.dtsi"
 
diff --git a/arch/arm64/boot/dts/qcom/sc7180-trogdor-homestar-r3.dts b/arch/arm64/boot/dts/qcom/sc7180-trogdor-homestar-r3.dts
index e92e2e9e48ed..242c178fdc52 100644
--- a/arch/arm64/boot/dts/qcom/sc7180-trogdor-homestar-r3.dts
+++ b/arch/arm64/boot/dts/qcom/sc7180-trogdor-homestar-r3.dts
@@ -7,7 +7,7 @@
 
 /dts-v1/;
 
-#include "sc7180.dtsi"
+#include "sc7180-trogdor.dtsi"
 #include "sc7180-trogdor-ti-sn65dsi86.dtsi"
 #include "sc7180-trogdor-homestar.dtsi"
 
diff --git a/arch/arm64/boot/dts/qcom/sc7180-trogdor-homestar-r4.dts b/arch/arm64/boot/dts/qcom/sc7180-trogdor-homestar-r4.dts
index 0de0c97f5728..66dd87016201 100644
--- a/arch/arm64/boot/dts/qcom/sc7180-trogdor-homestar-r4.dts
+++ b/arch/arm64/boot/dts/qcom/sc7180-trogdor-homestar-r4.dts
@@ -7,7 +7,7 @@
 
 /dts-v1/;
 
-#include "sc7180.dtsi"
+#include "sc7180-trogdor.dtsi"
 #include "sc7180-trogdor-parade-ps8640.dtsi"
 #include "sc7180-trogdor-homestar.dtsi"
 
diff --git a/arch/arm64/boot/dts/qcom/sc7180-trogdor-lazor-limozeen-nots-r5.dts b/arch/arm64/boot/dts/qcom/sc7180-trogdor-lazor-limozeen-nots-r5.dts
index f360ff27226e..235cda2bba5e 100644
--- a/arch/arm64/boot/dts/qcom/sc7180-trogdor-lazor-limozeen-nots-r5.dts
+++ b/arch/arm64/boot/dts/qcom/sc7180-trogdor-lazor-limozeen-nots-r5.dts
@@ -7,7 +7,7 @@
 
 /dts-v1/;
 
-#include "sc7180.dtsi"
+#include "sc7180-trogdor.dtsi"
 #include "sc7180-trogdor-ti-sn65dsi86.dtsi"
 #include "sc7180-trogdor-lazor.dtsi"
 #include "sc7180-trogdor-lte-sku.dtsi"
diff --git a/arch/arm64/boot/dts/qcom/sc7180-trogdor-lazor-limozeen-nots-r9.dts b/arch/arm64/boot/dts/qcom/sc7180-trogdor-lazor-limozeen-nots-r9.dts
index c44ed54af690..913b5fc3ba76 100644
--- a/arch/arm64/boot/dts/qcom/sc7180-trogdor-lazor-limozeen-nots-r9.dts
+++ b/arch/arm64/boot/dts/qcom/sc7180-trogdor-lazor-limozeen-nots-r9.dts
@@ -7,7 +7,7 @@
 
 /dts-v1/;
 
-#include "sc7180.dtsi"
+#include "sc7180-trogdor.dtsi"
 #include "sc7180-trogdor-parade-ps8640.dtsi"
 #include "sc7180-trogdor-lazor.dtsi"
 #include "sc7180-trogdor-lte-sku.dtsi"
diff --git a/arch/arm64/boot/dts/qcom/sc7180-trogdor-lazor-limozeen-r4.dts b/arch/arm64/boot/dts/qcom/sc7180-trogdor-lazor-limozeen-r4.dts
index 42b4bbcc76f4..d42dcd421146 100644
--- a/arch/arm64/boot/dts/qcom/sc7180-trogdor-lazor-limozeen-r4.dts
+++ b/arch/arm64/boot/dts/qcom/sc7180-trogdor-lazor-limozeen-r4.dts
@@ -7,7 +7,7 @@
 
 /dts-v1/;
 
-#include "sc7180.dtsi"
+#include "sc7180-trogdor.dtsi"
 #include "sc7180-trogdor-ti-sn65dsi86.dtsi"
 #include "sc7180-trogdor-lazor.dtsi"
 #include "sc7180-trogdor-lte-sku.dtsi"
diff --git a/arch/arm64/boot/dts/qcom/sc7180-trogdor-lazor-limozeen-r9.dts b/arch/arm64/boot/dts/qcom/sc7180-trogdor-lazor-limozeen-r9.dts
index dc47842bc662..15d77dc5f956 100644
--- a/arch/arm64/boot/dts/qcom/sc7180-trogdor-lazor-limozeen-r9.dts
+++ b/arch/arm64/boot/dts/qcom/sc7180-trogdor-lazor-limozeen-r9.dts
@@ -7,7 +7,7 @@
 
 /dts-v1/;
 
-#include "sc7180.dtsi"
+#include "sc7180-trogdor.dtsi"
 #include "sc7180-trogdor-parade-ps8640.dtsi"
 #include "sc7180-trogdor-lazor.dtsi"
 #include "sc7180-trogdor-lte-sku.dtsi"
diff --git a/arch/arm64/boot/dts/qcom/sc7180-trogdor-lazor-r0.dts b/arch/arm64/boot/dts/qcom/sc7180-trogdor-lazor-r0.dts
index b142006478ea..bfbf26fd2cd4 100644
--- a/arch/arm64/boot/dts/qcom/sc7180-trogdor-lazor-r0.dts
+++ b/arch/arm64/boot/dts/qcom/sc7180-trogdor-lazor-r0.dts
@@ -7,7 +7,7 @@
 
 /dts-v1/;
 
-#include "sc7180.dtsi"
+#include "sc7180-trogdor.dtsi"
 #include "sc7180-trogdor-ti-sn65dsi86.dtsi"
 #include "sc7180-trogdor-lazor.dtsi"
 
diff --git a/arch/arm64/boot/dts/qcom/sc7180-trogdor-lazor-r1.dts b/arch/arm64/boot/dts/qcom/sc7180-trogdor-lazor-r1.dts
index 59740799fa3a..d45a59afd7fc 100644
--- a/arch/arm64/boot/dts/qcom/sc7180-trogdor-lazor-r1.dts
+++ b/arch/arm64/boot/dts/qcom/sc7180-trogdor-lazor-r1.dts
@@ -7,7 +7,7 @@
 
 /dts-v1/;
 
-#include "sc7180.dtsi"
+#include "sc7180-trogdor.dtsi"
 #include "sc7180-trogdor-ti-sn65dsi86.dtsi"
 #include "sc7180-trogdor-lazor.dtsi"
 
diff --git a/arch/arm64/boot/dts/qcom/sc7180-trogdor-lazor-r3-kb.dts b/arch/arm64/boot/dts/qcom/sc7180-trogdor-lazor-r3-kb.dts
index 18ef9da71998..6ff81c1f7c44 100644
--- a/arch/arm64/boot/dts/qcom/sc7180-trogdor-lazor-r3-kb.dts
+++ b/arch/arm64/boot/dts/qcom/sc7180-trogdor-lazor-r3-kb.dts
@@ -7,7 +7,7 @@
 
 /dts-v1/;
 
-#include "sc7180.dtsi"
+#include "sc7180-trogdor.dtsi"
 #include "sc7180-trogdor-ti-sn65dsi86.dtsi"
 #include "sc7180-trogdor-lazor.dtsi"
 #include "sc7180-lite.dtsi"
diff --git a/arch/arm64/boot/dts/qcom/sc7180-trogdor-lazor-r3-lte.dts b/arch/arm64/boot/dts/qcom/sc7180-trogdor-lazor-r3-lte.dts
index 8913592b2d82..e58e36e35950 100644
--- a/arch/arm64/boot/dts/qcom/sc7180-trogdor-lazor-r3-lte.dts
+++ b/arch/arm64/boot/dts/qcom/sc7180-trogdor-lazor-r3-lte.dts
@@ -7,7 +7,7 @@
 
 /dts-v1/;
 
-#include "sc7180.dtsi"
+#include "sc7180-trogdor.dtsi"
 #include "sc7180-trogdor-ti-sn65dsi86.dtsi"
 #include "sc7180-trogdor-lazor.dtsi"
 #include "sc7180-trogdor-lte-sku.dtsi"
diff --git a/arch/arm64/boot/dts/qcom/sc7180-trogdor-lazor-r3.dts b/arch/arm64/boot/dts/qcom/sc7180-trogdor-lazor-r3.dts
index 7adcedbf080d..76c83f88cb41 100644
--- a/arch/arm64/boot/dts/qcom/sc7180-trogdor-lazor-r3.dts
+++ b/arch/arm64/boot/dts/qcom/sc7180-trogdor-lazor-r3.dts
@@ -7,7 +7,7 @@
 
 /dts-v1/;
 
-#include "sc7180.dtsi"
+#include "sc7180-trogdor.dtsi"
 #include "sc7180-trogdor-ti-sn65dsi86.dtsi"
 #include "sc7180-trogdor-lazor.dtsi"
 #include "sc7180-lite.dtsi"
diff --git a/arch/arm64/boot/dts/qcom/sc7180-trogdor-lazor-r9-kb.dts b/arch/arm64/boot/dts/qcom/sc7180-trogdor-lazor-r9-kb.dts
index 7f5c015e1ecb..960f7b7ce094 100644
--- a/arch/arm64/boot/dts/qcom/sc7180-trogdor-lazor-r9-kb.dts
+++ b/arch/arm64/boot/dts/qcom/sc7180-trogdor-lazor-r9-kb.dts
@@ -7,7 +7,7 @@
 
 /dts-v1/;
 
-#include "sc7180.dtsi"
+#include "sc7180-trogdor.dtsi"
 #include "sc7180-trogdor-parade-ps8640.dtsi"
 #include "sc7180-trogdor-lazor.dtsi"
 #include "sc7180-lite.dtsi"
diff --git a/arch/arm64/boot/dts/qcom/sc7180-trogdor-lazor-r9-lte.dts b/arch/arm64/boot/dts/qcom/sc7180-trogdor-lazor-r9-lte.dts
index 8107f3d932eb..38027f13b9d0 100644
--- a/arch/arm64/boot/dts/qcom/sc7180-trogdor-lazor-r9-lte.dts
+++ b/arch/arm64/boot/dts/qcom/sc7180-trogdor-lazor-r9-lte.dts
@@ -7,7 +7,7 @@
 
 /dts-v1/;
 
-#include "sc7180.dtsi"
+#include "sc7180-trogdor.dtsi"
 #include "sc7180-trogdor-parade-ps8640.dtsi"
 #include "sc7180-trogdor-lazor.dtsi"
 #include "sc7180-trogdor-lte-sku.dtsi"
diff --git a/arch/arm64/boot/dts/qcom/sc7180-trogdor-lazor-r9.dts b/arch/arm64/boot/dts/qcom/sc7180-trogdor-lazor-r9.dts
index 83f6a4eb5ae5..56dd222650d3 100644
--- a/arch/arm64/boot/dts/qcom/sc7180-trogdor-lazor-r9.dts
+++ b/arch/arm64/boot/dts/qcom/sc7180-trogdor-lazor-r9.dts
@@ -7,7 +7,7 @@
 
 /dts-v1/;
 
-#include "sc7180.dtsi"
+#include "sc7180-trogdor.dtsi"
 #include "sc7180-trogdor-parade-ps8640.dtsi"
 #include "sc7180-trogdor-lazor.dtsi"
 #include "sc7180-lite.dtsi"
diff --git a/arch/arm64/boot/dts/qcom/sc7180-trogdor-pompom.dtsi b/arch/arm64/boot/dts/qcom/sc7180-trogdor-pompom.dtsi
index 3bca7545ffe5..4841d42c8c62 100644
--- a/arch/arm64/boot/dts/qcom/sc7180-trogdor-pompom.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc7180-trogdor-pompom.dtsi
@@ -5,7 +5,6 @@
  * Copyright 2020 Google LLC.
  */
 
-#include "sc7180.dtsi"
 #include "sc7180-trogdor.dtsi"
 #include "sc7180-trogdor-ti-sn65dsi86.dtsi"
 
diff --git a/arch/arm64/boot/dts/qcom/sc7180-trogdor-r1.dts b/arch/arm64/boot/dts/qcom/sc7180-trogdor-r1.dts
index 6c822c84112a..352827e5740a 100644
--- a/arch/arm64/boot/dts/qcom/sc7180-trogdor-r1.dts
+++ b/arch/arm64/boot/dts/qcom/sc7180-trogdor-r1.dts
@@ -7,7 +7,6 @@
 
 /dts-v1/;
 
-#include "sc7180.dtsi"
 #include "sc7180-trogdor.dtsi"
 #include "sc7180-trogdor-ti-sn65dsi86.dtsi"
 
diff --git a/arch/arm64/boot/dts/qcom/sc7180-trogdor.dtsi b/arch/arm64/boot/dts/qcom/sc7180-trogdor.dtsi
index ea5bedc3d1cb..e55dbaa6dc12 100644
--- a/arch/arm64/boot/dts/qcom/sc7180-trogdor.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc7180-trogdor.dtsi
@@ -11,7 +11,8 @@
 #include <dt-bindings/regulator/qcom,rpmh-regulator.h>
 #include <dt-bindings/sound/sc7180-lpass.h>
 
-/* PMICs depend on spmi_bus label and so must come after SoC */
+#include "sc7180.dtsi"
+/* PMICs depend on spmi_bus label and so must come after sc7180.dtsi */
 #include "pm6150.dtsi"
 #include "pm6150l.dtsi"
 
-- 
https://chromeos.dev

