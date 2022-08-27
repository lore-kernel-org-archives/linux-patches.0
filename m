Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com [209.85.215.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 302D715A6
	for <patches@lists.linux.dev>; Sat, 27 Aug 2022 00:49:04 +0000 (UTC)
Received: by mail-pg1-f178.google.com with SMTP id c24so2778493pgg.11
        for <patches@lists.linux.dev>; Fri, 26 Aug 2022 17:49:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc;
        bh=97zZ08Utl6HARnTvGZcj5Kpy48/dl3mZFonKGspCb6I=;
        b=HA9yAAoleCjowV5YLuTXR7dgCp/RWxiop4nJUvuJ12gtW6IHgIsQp+4AZT9z96nG9+
         Ot4q/4vAg0a5FughnQQ/mnp/8ipCGNhv64yUejNAwG7JJl87b6Oz+PWF7UP1Pub8pva0
         23I/W26sQG4N9k+fiVmoV3Im8gX5638Gwi21s=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc;
        bh=97zZ08Utl6HARnTvGZcj5Kpy48/dl3mZFonKGspCb6I=;
        b=PQFyRkA3JBvqOJADxGxVJ5hIdNUC07wVYDFfWUFb2NbApvM5SF92S9S7cG2gp7gb8M
         bbB/2x1KFevnAYN0iDmt3nwQf1u2TLInJf0dg8a660DAC49XNE7qFNmjkfVKHB+MNoFW
         F9cmIxHI7Bri4jGA0cY+svWBItTWKfnTNeXUfe8XI9M51tBocl+jXELFiznxevJmTmYw
         ZjfKKE97zkeuqgD7R4RNuD7VdI5tqD/d7RfY3uTCtqUbWlaDEAREmXW7EjR9lMFfb0x3
         KXe+JIFY8eO8FqgEl0CM501lOfXtQNHzo6YZgxYsCNRZH0aY7XEm/VkFztNAnwjDHhN/
         PGLg==
X-Gm-Message-State: ACgBeo3CJg60t5J69z+pQah2dJCROkYfbpI7DQ+jqMJfrfNA4W6hbigU
	0onKfIMHkQztXzZ/JqqVkFQQ5g==
X-Google-Smtp-Source: AA6agR49bSDIhKd84+MMDwGyg4jTeGcSAp1B7s/VdMYbgVRXKFMixBFV+Xhl1fa2VkE/f2ieM7yKng==
X-Received: by 2002:a05:6a00:22c8:b0:537:275e:e483 with SMTP id f8-20020a056a0022c800b00537275ee483mr6298686pfj.54.1661561343582;
        Fri, 26 Aug 2022 17:49:03 -0700 (PDT)
Received: from smtp.gmail.com ([2620:15c:202:201:4e6f:7e52:9ad5:809f])
        by smtp.gmail.com with ESMTPSA id z10-20020a62d10a000000b00537d0ed05ecsm1842969pfg.216.2022.08.26.17.49.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Aug 2022 17:49:02 -0700 (PDT)
From: Stephen Boyd <swboyd@chromium.org>
To: Andy Gross <agross@kernel.org>,
	Bjorn Andersson <bjorn.andersson@linaro.org>
Cc: linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	linux-arm-msm@vger.kernel.org,
	Matthias Kaehlcke <mka@chromium.org>
Subject: [PATCH] arm64: dts: qcom: sc7180-trogdor: Keep pm6150_adc enabled for TZ
Date: Fri, 26 Aug 2022 17:49:00 -0700
Message-Id: <20220827004901.511543-1-swboyd@chromium.org>
X-Mailer: git-send-email 2.37.2.672.g94769d06f0-goog
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

There's still a thermal zone using pm6150_adc in the pm6150.dtsi file,
pm6150_thermal. It's not super obvious because it indirectly uses the
adc through an iio channel in pm6150_temp. Let's keep this enabled on
lazor and coachz so that reading the temperature of the pm6150_thermal
zone continues to work. Otherwise we get -EINVAL when reading the zone,
and I suspect the PMIC temperature trip doesn't work properly so we
don't shutdown when the PMIC overheats.

Cc: Matthias Kaehlcke <mka@chromium.org>
Fixes: b8d1e3d33487 ("arm64: dts: qcom: sc7180-trogdor: Delete ADC config for unused thermistors")
Signed-off-by: Stephen Boyd <swboyd@chromium.org>
---
 arch/arm64/boot/dts/qcom/sc7180-trogdor-coachz-r1.dts | 2 --
 arch/arm64/boot/dts/qcom/sc7180-trogdor-lazor.dtsi    | 2 --
 2 files changed, 4 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sc7180-trogdor-coachz-r1.dts b/arch/arm64/boot/dts/qcom/sc7180-trogdor-coachz-r1.dts
index 8290d036044a..edfcd47e1a00 100644
--- a/arch/arm64/boot/dts/qcom/sc7180-trogdor-coachz-r1.dts
+++ b/arch/arm64/boot/dts/qcom/sc7180-trogdor-coachz-r1.dts
@@ -24,8 +24,6 @@ &charger_thermal {
 };
 
 &pm6150_adc {
-	status = "disabled";
-
 	/delete-node/ skin-temp-thermistor@4e;
 	/delete-node/ charger-thermistor@4f;
 };
diff --git a/arch/arm64/boot/dts/qcom/sc7180-trogdor-lazor.dtsi b/arch/arm64/boot/dts/qcom/sc7180-trogdor-lazor.dtsi
index 2cf7d5212c61..002663d752da 100644
--- a/arch/arm64/boot/dts/qcom/sc7180-trogdor-lazor.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc7180-trogdor-lazor.dtsi
@@ -55,8 +55,6 @@ &panel {
 };
 
 &pm6150_adc {
-	status = "disabled";
-
 	/delete-node/ charger-thermistor@4f;
 };
 

base-commit: 568035b01cfb107af8d2e4bd2fb9aea22cf5b868
-- 
https://chromeos.dev

