Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9D2523C2
	for <patches@lists.linux.dev>; Wed, 13 Apr 2022 03:33:39 +0000 (UTC)
Received: by mail-pj1-f50.google.com with SMTP id 2so717411pjw.2
        for <patches@lists.linux.dev>; Tue, 12 Apr 2022 20:33:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=wWjcJ6txlWYmGPmWUa/lkqIm8X8YcOdSGrKx1dUT1Lo=;
        b=YgtAnaC55D0KkRpSdrIiP6T3P81urr5g/Wsyj5iqniK8Yo6uNqXmgNDQKU8guUyzhO
         jlSo+XbhOceULSlwk/0SCtnBuGDZkatovifAvcLcQayYQv1lEq7uY+F77RUJezmvxfNq
         FYphnBMKohDI4+o1T5n5ebz12m/dXUiLta+AQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wWjcJ6txlWYmGPmWUa/lkqIm8X8YcOdSGrKx1dUT1Lo=;
        b=Xzorx6vx88VTS4D3V79TP0UQV3NR2LMQBCya3BoR4mc2Ne3yr9d/uM8bDqOzCWL8EI
         AFgMyPy+h61Aq+wmhC7u6YV8Sebv2bPKsWtanbqjl7ogdE1kACw5ssPg9z7QtKrqGDfy
         KRGEtLQyxx8Au2uaYE4fNcGreqHbZ9zZEgxD3Eg8vsYZVLwJSZ5mP/t0jQFkO2nX0BHS
         1O4yc9drakhEpQFRpAhXBXqagBUyRyGhAWFMlnPoT8aTMBywT95j3WGhxDo6puzKQdZb
         Gv8eu1bye5YXe3LAT9VubOcaaPIdQGoFTPDQ6ZTHKOyW/xUoDVYmBnK5fr38Y8O0h5c0
         fNDg==
X-Gm-Message-State: AOAM532Un9hFeZkt1Jjx8aNsP1T5bSWXY2P+6ZEkjOqzKWWkjeP4yS/v
	Ic1PvWHHEUtAQtkHOGtmq3gYwA==
X-Google-Smtp-Source: ABdhPJygH42DZ5/k1O8K6z1nX5nC/7dmhOUdeF3Vfk0lEF1VmUGlNmFOQQytziHcSMNRDQiwjuoVuw==
X-Received: by 2002:a17:90a:aa96:b0:1cb:c57f:9218 with SMTP id l22-20020a17090aaa9600b001cbc57f9218mr7161259pjq.227.1649820819494;
        Tue, 12 Apr 2022 20:33:39 -0700 (PDT)
Received: from smtp.gmail.com ([2620:15c:202:201:87b3:e0ea:c924:6d1f])
        by smtp.gmail.com with ESMTPSA id h10-20020a056a00230a00b004faa0f67c3esm39788276pfh.23.2022.04.12.20.33.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Apr 2022 20:33:39 -0700 (PDT)
From: Stephen Boyd <swboyd@chromium.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	linux-input@vger.kernel.org,
	chrome-platform@lists.linux.dev,
	Benson Leung <bleung@chromium.org>,
	Guenter Roeck <groeck@chromium.org>,
	Douglas Anderson <dianders@chromium.org>,
	Hsin-Yi Wang <hsinyi@chromium.org>
Subject: [RFC/PATCH 2/2] arm64: dts: qcom: sc7180-trogdor: Remove cros-ec keyboard from detachables
Date: Tue, 12 Apr 2022 20:33:34 -0700
Message-Id: <20220413033334.1514008-3-swboyd@chromium.org>
X-Mailer: git-send-email 2.35.1.1178.g4f1659d476-goog
In-Reply-To: <20220413033334.1514008-1-swboyd@chromium.org>
References: <20220413033334.1514008-1-swboyd@chromium.org>
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
Signed-off-by: Stephen Boyd <swboyd@chromium.org>
---

This is mostly to show an example. The patch will be picked up by qcom
maintainer if the first patch is accepted.

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

