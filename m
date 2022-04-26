Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71D302C9D
	for <patches@lists.linux.dev>; Tue, 26 Apr 2022 22:57:50 +0000 (UTC)
Received: by mail-pj1-f48.google.com with SMTP id u6-20020a17090a1f0600b001d86bd69427so268514pja.5
        for <patches@lists.linux.dev>; Tue, 26 Apr 2022 15:57:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Z9pldSbABWlALe30nll+EqJHPLENAkssKS7uwEiOKks=;
        b=VtVIjWUvoftyfpavtyYQnP8Il2FpVnrZ6jfoy68vndksr7US7LwN29KqB+VoEMerqN
         Vrz3+YkOue35YVPShw9eN1AcFa9B63+jx3sIt+nIPfIwCWr2TydEZEkdT4BUeIyvV9Iq
         DDDde0ZsTmCaE905KYapsFMZIaGZYTlNEkxqA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Z9pldSbABWlALe30nll+EqJHPLENAkssKS7uwEiOKks=;
        b=5JTu2j7Fvdf7iktHlgZMQ1twoFKyfp1INflxYuUYuoixqtishpV4APEUhJi3ffIfQO
         m2PsVxfWjCUdTJS/ocLUgQ5fwiT1Muzl3HP+kfcJXZ7UlrS4u4APvjPwGsoWjsSbx9me
         NVHvtLcP5AS1X8RDFr7/cY0aq1n/M8rdRJnwqKcje/aidGruH+FGDySGzrzIdL156mGp
         RrQxImpmtyzz8hthzqladqqZj6oqJ9Z+lnSYTZ3ppXEnwsC9tpCyYIeI/Eqnw+V31ci3
         g5++9Hmc+SxEEytcRCdR5eEaa7Jh4xCoeKwLEv3+TzK8QQCi2EmAft4wu5R5+NANdkdI
         FRvg==
X-Gm-Message-State: AOAM532ngn2Ts7R80F4Bo91HhNAPRLqctNSjA7/SV8VjF5POp8WGNGxu
	bgFf5RRsEj2HKRiuaJSt5/toOQ==
X-Google-Smtp-Source: ABdhPJxRQWaWCgVT2ZIYdnD1s8zBw6rQYK2b3848WTPzlp5QMCboNsrd+HqF5c6T+VO+13AwAytvUw==
X-Received: by 2002:a17:902:8304:b0:155:d594:5c04 with SMTP id bd4-20020a170902830400b00155d5945c04mr25289971plb.105.1651013869766;
        Tue, 26 Apr 2022 15:57:49 -0700 (PDT)
Received: from smtp.gmail.com ([2620:15c:202:201:bb92:4a51:f085:243c])
        by smtp.gmail.com with ESMTPSA id j1-20020a17090adc8100b001d9424e49c1sm4201329pjv.44.2022.04.26.15.57.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Apr 2022 15:57:49 -0700 (PDT)
From: Stephen Boyd <swboyd@chromium.org>
To: Andy Gross <agross@kernel.org>,
	Bjorn Andersson <bjorn.andersson@linaro.org>
Cc: linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	linux-arm-msm@vger.kernel.org,
	Benson Leung <bleung@chromium.org>,
	Guenter Roeck <groeck@chromium.org>,
	Douglas Anderson <dianders@chromium.org>,
	Hsin-Yi Wang <hsinyi@chromium.org>,
	"Joseph S. Barrera III" <joebar@chromium.org>
Subject: [PATCH] arm64: dts: qcom: sc7180-trogdor: Remove cros-ec keyboard from detachables
Date: Tue, 26 Apr 2022 15:57:47 -0700
Message-Id: <20220426225748.324759-1-swboyd@chromium.org>
X-Mailer: git-send-email 2.36.0.rc2.479.g8af0fa9b8e-goog
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
detachable keyboard. Let's delete the rows/columns properties of the
device node to indicate that there isn't a matrix keyboard on these
boards.

Cc: Benson Leung <bleung@chromium.org>
Cc: Guenter Roeck <groeck@chromium.org>
Cc: Douglas Anderson <dianders@chromium.org>
Cc: Hsin-Yi Wang <hsinyi@chromium.org>
Cc: "Joseph S. Barrera III" <joebar@chromium.org>
Signed-off-by: Stephen Boyd <swboyd@chromium.org>
---
 arch/arm64/boot/dts/qcom/sc7180-trogdor-coachz.dtsi   | 5 +++++
 arch/arm64/boot/dts/qcom/sc7180-trogdor-homestar.dtsi | 5 +++++
 2 files changed, 10 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/sc7180-trogdor-coachz.dtsi b/arch/arm64/boot/dts/qcom/sc7180-trogdor-coachz.dtsi
index c81805ef2250..4173623cc241 100644
--- a/arch/arm64/boot/dts/qcom/sc7180-trogdor-coachz.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc7180-trogdor-coachz.dtsi
@@ -119,6 +119,11 @@ &i2c9 {
 	status = "disabled";
 };
 
+&keyboard_controller {
+	/delete-property/keypad,num-rows;
+	/delete-property/keypad,num-columns;
+};
+
 &panel {
 	compatible = "boe,nv110wtm-n61";
 };
diff --git a/arch/arm64/boot/dts/qcom/sc7180-trogdor-homestar.dtsi b/arch/arm64/boot/dts/qcom/sc7180-trogdor-homestar.dtsi
index bff2b556cc75..7205062e88b4 100644
--- a/arch/arm64/boot/dts/qcom/sc7180-trogdor-homestar.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc7180-trogdor-homestar.dtsi
@@ -121,6 +121,11 @@ &camcc {
 	status = "okay";
 };
 
+&keyboard_controller {
+	/delete-property/keypad,num-rows;
+	/delete-property/keypad,num-columns;
+};
+
 &panel {
 	compatible = "samsung,atna33xc20";
 	enable-gpios = <&tlmm 12 GPIO_ACTIVE_HIGH>;
-- 
https://chromeos.dev

