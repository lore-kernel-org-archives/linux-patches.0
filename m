Received: from mail-pg1-f169.google.com (mail-pg1-f169.google.com [209.85.215.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BCD17E
	for <patches@lists.linux.dev>; Wed, 18 May 2022 17:25:29 +0000 (UTC)
Received: by mail-pg1-f169.google.com with SMTP id w8so581305pga.9
        for <patches@lists.linux.dev>; Wed, 18 May 2022 10:25:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=a/hm/0DNCK0jpPaqRZJ6wCDNmj3bKnRbo0tmJyWDhWA=;
        b=mm6VSvd5fmrTvbi0I41d9konzeY5nqQ0O6ikrVIofls/Mo3zRJ2kjD9Rf5F16exBQ8
         E0ocjXV8Uy1m6DwQ/GuSHrPjfzi17/i/YdsbUXR3965ObftMu2tc2Zuxf85YVxDmHz59
         0mkuTVrIBwx6XfpB9Bh4xUjsIgWdcR4DQg+fw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=a/hm/0DNCK0jpPaqRZJ6wCDNmj3bKnRbo0tmJyWDhWA=;
        b=T8HxPwZFqdRCEYF5HOpXuNJOYVHMNG0ypXeQNPiRL2TGV08xPT7SA6tDu/XLM7AZUA
         aaF0QNbW8TK3FRx2p1UWnwAwBjgS6EX2qN4o8jmY/kwTaa75Dpxhwdlg2r6BqRFOsbhL
         H/5aaTQDC2PA2kls9SF42q/TqnlPSnQNhT9SWUY/1D6o3mzOsKx+QsMDBk/aAA5gWmI2
         69tZyUIOlZ2hg3CaEVwINZNlfcIrvdulDJY6JtVFZ0tvPyCQPWrJmEphGLKM3VBWlq+X
         eXyodZjhkHKOcWV0NYQCByhq6xFfbyK1rPXqxDt6XBAB2edM2OavCxmP5xve66PHI5Vt
         QRBA==
X-Gm-Message-State: AOAM532F5d04WY5DmqF3WYs+KN7YHXYZM4/I3SRWztrRdrprLakPWV4S
	lmid+ujAIquxLiSVHwZHmyHJ4Q==
X-Google-Smtp-Source: ABdhPJySiYRHw99L3toHyq5zhFKK3s5g3M7EVRhTh9xOVIbIYa3+Qhb5eagJYb3bwjHl/XmcZSLaxw==
X-Received: by 2002:a05:6a00:4099:b0:518:2529:3b8d with SMTP id bw25-20020a056a00409900b0051825293b8dmr437666pfb.60.1652894728449;
        Wed, 18 May 2022 10:25:28 -0700 (PDT)
Received: from smtp.gmail.com ([2620:15c:202:201:be81:6c26:5643:b3d9])
        by smtp.gmail.com with ESMTPSA id b34-20020a630c22000000b003e4580cf645sm1770750pgl.17.2022.05.18.10.25.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 May 2022 10:25:26 -0700 (PDT)
From: Stephen Boyd <swboyd@chromium.org>
To: Andy Gross <agross@kernel.org>,
	Bjorn Andersson <bjorn.andersson@linaro.org>
Cc: linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	linux-arm-msm@vger.kernel.org,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Benson Leung <bleung@chromium.org>,
	Guenter Roeck <groeck@chromium.org>,
	Douglas Anderson <dianders@chromium.org>,
	Hsin-Yi Wang <hsinyi@chromium.org>,
	"Joseph S. Barrera III" <joebar@chromium.org>
Subject: [PATCH] arm64: dts: qcom: sc7180-trogdor: Split out keyboard node and describe detachables
Date: Wed, 18 May 2022 10:25:25 -0700
Message-Id: <20220518172525.3319993-1-swboyd@chromium.org>
X-Mailer: git-send-email 2.36.1.124.g0e6072fb45-goog
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Trogdor devices that have a detachable keyboard still have a
non-detachable keyboard input device present because we include the
cros-ec-keyboard.dtsi snippet in the top-level sc7180-trogdor.dtsi file
that every variant board includes. We do this because the
keyboard-controller node also provides some buttons like the power
button and volume buttons. Unfortunately, this means we register a
keyboard input device that doesn't do anything on boards with a
detachable keyboard.

Change the node's compatible on detachables to the newly introduced
"google,cros-ec-keyb-switches" compatible to indicate that there are
only switches and no keyboard to register. Similarly, move the keyboard
include that defines the keyboard-controller node out of
sc7180-trogdor.dtsi to boards that actually have a keyboard so that the
matrix properties are not defined on boards with the switches
compatible. Future boards can either use the include approach or the
node definition approach to describe a keyboard with possible switches
or just some switches.

Cc: Benson Leung <bleung@chromium.org>
Cc: Guenter Roeck <groeck@chromium.org>
Cc: Douglas Anderson <dianders@chromium.org>
Cc: Hsin-Yi Wang <hsinyi@chromium.org>
Cc: "Joseph S. Barrera III" <joebar@chromium.org>
Signed-off-by: Stephen Boyd <swboyd@chromium.org>
---

This is based on an immutable branch from Dmitry (on Cc)

	git://git.kernel.org/pub/scm/linux/kernel/git/dtor/input.git ib/5.17-cros-ec-keyb

where this patch should be applied on top of so that a bisect doesn't
break. The driver side change only supports one compatible or the other,
so we can't apply this patch unless the driver side change is present.

 arch/arm64/boot/dts/qcom/sc7180-trogdor-coachz.dtsi   | 4 ++++
 arch/arm64/boot/dts/qcom/sc7180-trogdor-homestar.dtsi | 6 ++++++
 arch/arm64/boot/dts/qcom/sc7180-trogdor-lazor.dtsi    | 2 ++
 arch/arm64/boot/dts/qcom/sc7180-trogdor-pompom.dtsi   | 2 ++
 arch/arm64/boot/dts/qcom/sc7180-trogdor-r1.dts        | 2 ++
 arch/arm64/boot/dts/qcom/sc7180-trogdor.dtsi          | 1 -
 6 files changed, 16 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/sc7180-trogdor-coachz.dtsi b/arch/arm64/boot/dts/qcom/sc7180-trogdor-coachz.dtsi
index 14ed09f30a73..a131dba4bf97 100644
--- a/arch/arm64/boot/dts/qcom/sc7180-trogdor-coachz.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc7180-trogdor-coachz.dtsi
@@ -86,6 +86,10 @@ &camcc {
 };
 
 &cros_ec {
+	keyboard-controller {
+		compatible = "google,cros-ec-keyb-switches";
+	};
+
 	cros_ec_proximity: proximity {
 		compatible = "google,cros-ec-mkbp-proximity";
 		label = "proximity-wifi";
diff --git a/arch/arm64/boot/dts/qcom/sc7180-trogdor-homestar.dtsi b/arch/arm64/boot/dts/qcom/sc7180-trogdor-homestar.dtsi
index f32369af1351..5d7ca89f7862 100644
--- a/arch/arm64/boot/dts/qcom/sc7180-trogdor-homestar.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc7180-trogdor-homestar.dtsi
@@ -121,6 +121,12 @@ &camcc {
 	status = "okay";
 };
 
+&cros_ec {
+	keyboard-controller {
+		compatible = "google,cros-ec-keyb-switches";
+	};
+};
+
 &panel {
 	compatible = "samsung,atna33xc20";
 	enable-gpios = <&tlmm 12 GPIO_ACTIVE_HIGH>;
diff --git a/arch/arm64/boot/dts/qcom/sc7180-trogdor-lazor.dtsi b/arch/arm64/boot/dts/qcom/sc7180-trogdor-lazor.dtsi
index 69666f92176a..4601f5afe255 100644
--- a/arch/arm64/boot/dts/qcom/sc7180-trogdor-lazor.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc7180-trogdor-lazor.dtsi
@@ -9,6 +9,8 @@
 ap_h1_spi: &spi0 {};
 
 #include "sc7180-trogdor.dtsi"
+/* Must come after sc7180-trogdor.dtsi to modify cros_ec */
+#include <arm/cros-ec-keyboard.dtsi>
 
 &ap_sar_sensor {
 	semtech,cs0-ground;
diff --git a/arch/arm64/boot/dts/qcom/sc7180-trogdor-pompom.dtsi b/arch/arm64/boot/dts/qcom/sc7180-trogdor-pompom.dtsi
index e90f99ef5323..64535bd03db9 100644
--- a/arch/arm64/boot/dts/qcom/sc7180-trogdor-pompom.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc7180-trogdor-pompom.dtsi
@@ -11,6 +11,8 @@
 ap_h1_spi: &spi0 {};
 
 #include "sc7180-trogdor.dtsi"
+/* Must come after sc7180-trogdor.dtsi to modify cros_ec */
+#include <arm/cros-ec-keyboard.dtsi>
 #include "sc7180-trogdor-ti-sn65dsi86.dtsi"
 
 / {
diff --git a/arch/arm64/boot/dts/qcom/sc7180-trogdor-r1.dts b/arch/arm64/boot/dts/qcom/sc7180-trogdor-r1.dts
index 457c25499863..9a424a96c003 100644
--- a/arch/arm64/boot/dts/qcom/sc7180-trogdor-r1.dts
+++ b/arch/arm64/boot/dts/qcom/sc7180-trogdor-r1.dts
@@ -13,6 +13,8 @@
 ap_h1_spi: &spi0 {};
 
 #include "sc7180-trogdor.dtsi"
+/* Must come after sc7180-trogdor.dtsi to modify cros_ec */
+#include <arm/cros-ec-keyboard.dtsi>
 #include "sc7180-trogdor-ti-sn65dsi86.dtsi"
 
 / {
diff --git a/arch/arm64/boot/dts/qcom/sc7180-trogdor.dtsi b/arch/arm64/boot/dts/qcom/sc7180-trogdor.dtsi
index bd5909ffb3dc..a09b2e452712 100644
--- a/arch/arm64/boot/dts/qcom/sc7180-trogdor.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc7180-trogdor.dtsi
@@ -810,7 +810,6 @@ cros_ec_fp: ec@0 {
 	};
 };
 
-#include <arm/cros-ec-keyboard.dtsi>
 #include <arm/cros-ec-sbs.dtsi>
 
 &uart3 {

base-commit: ca1eadbfcd36bec73f2a2111c28e8c7e9e8ae6c0
-- 
https://chromeos.dev

