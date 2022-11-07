Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6493D122AE
	for <patches@lists.linux.dev>; Mon,  7 Nov 2022 19:15:40 +0000 (UTC)
Received: by mail-pf1-f177.google.com with SMTP id 130so11536278pfu.8
        for <patches@lists.linux.dev>; Mon, 07 Nov 2022 11:15:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Et5rcDaKTeSODyH0ma6yTSI3d3kE/5OPATF9JyW6zgI=;
        b=HCojWqdbpZ0XdltA7pCayQz4VWGZ0DOeCtn7O5AQ0AQk45wxFNUvbpn1hSIXT2u2kg
         bjE9wyYHwl2TUWdx85D99f0I+NpFteFqIFsrXqLJ8lGrD4bbNlEDJBMyXTIJkVv+ecJG
         D6zU/DDwQjCFIMEUDtSL8PJMewHbpqlh61JDA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Et5rcDaKTeSODyH0ma6yTSI3d3kE/5OPATF9JyW6zgI=;
        b=b1AQ9QBxm9TbQ8/iMy//1jACeFdBZhJkLh54RkU8D1zzPtwN4rbXl+zaWmxPTk9kjf
         Gk/Nk/UXjTWizamHtwwzejMtXSpnYFjThH6V3M/x5dMNiyU+ysSvDRNyb6AMZd/X0ESz
         MfYMP8rmT86JBgngPnbw9aDbXkiRlgqCO7NhZ9i2PfiDw/2FRjp+vrBk14bKT5e1+c0J
         d4uZeei6vZa+LM6ecbcPHUu/GSe5zIF2+5kGwkjsMFInhoMWGXgnyfUsjuoGTfKYAWnm
         FRIRDmD1d5OSPSgu8FuCiJSRF52l3iRWEUHytayJ/8e5G+SrIXdZaMSLaL6qLzVmm7GC
         KFjQ==
X-Gm-Message-State: ACrzQf1vAAUJ94Qp2j7dz5HujVydf3u9xVnjXqqqAN/OsR5lB2yTUBDd
	jkizmdmlQP6aA9x4MyPC8VJ4xVqdPdHS3Q==
X-Google-Smtp-Source: AMsMyM4L7+dkQnukIPAZh2+7nIU9HyGulwudMVcJ3m+1z8C7HKjcfsj8uXP8uUPhYfLMilrCeJMiVw==
X-Received: by 2002:a63:b59:0:b0:434:2374:6d12 with SMTP id a25-20020a630b59000000b0043423746d12mr44379966pgl.311.1667848539848;
        Mon, 07 Nov 2022 11:15:39 -0800 (PST)
Received: from smtp.gmail.com ([2620:15c:11a:201:4652:3752:b9b7:29f9])
        by smtp.gmail.com with ESMTPSA id r11-20020a170902c60b00b001830ed575c3sm5306627plr.117.2022.11.07.11.15.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Nov 2022 11:15:39 -0800 (PST)
From: Stephen Boyd <swboyd@chromium.org>
To: Andy Gross <agross@kernel.org>,
	Bjorn Andersson <andersson@kernel.org>
Cc: linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	linux-arm-msm@vger.kernel.org,
	Douglas Anderson <dianders@chromium.org>,
	Matthias Kaehlcke <mka@chromium.org>,
	Alexandru M Stan <amstan@chromium.org>
Subject: [PATCH v2 1/2] arm64: dts: qcom: Fully describe fingerprint node on Herobrine
Date: Mon,  7 Nov 2022 11:15:34 -0800
Message-Id: <20221107191535.624371-2-swboyd@chromium.org>
X-Mailer: git-send-email 2.38.1.431.g37b22c650d-goog
In-Reply-To: <20221107191535.624371-1-swboyd@chromium.org>
References: <20221107191535.624371-1-swboyd@chromium.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Update the fingerprint node on Herobrine to match the fingerprint DT
binding. This will allow us to drive the reset and boot gpios from the
driver when it is re-attached after flashing. We'll also be able to boot
the fingerprint processor if the BIOS isn't doing it for us.

Cc: Douglas Anderson <dianders@chromium.org>
Cc: Matthias Kaehlcke <mka@chromium.org>
Cc: Alexandru M Stan <amstan@chromium.org>
Signed-off-by: Stephen Boyd <swboyd@chromium.org>
---
 arch/arm64/boot/dts/qcom/sc7280-herobrine.dtsi | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/sc7280-herobrine.dtsi b/arch/arm64/boot/dts/qcom/sc7280-herobrine.dtsi
index ca02ef26f161..448da9794722 100644
--- a/arch/arm64/boot/dts/qcom/sc7280-herobrine.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc7280-herobrine.dtsi
@@ -503,13 +503,16 @@ ap_spi_fp: &spi9 {
 	cs-gpios = <&tlmm 39 GPIO_ACTIVE_LOW>;
 
 	cros_ec_fp: ec@0 {
-		compatible = "google,cros-ec-spi";
+		compatible = "google,cros-ec-fp", "google,cros-ec-spi";
 		reg = <0>;
 		interrupt-parent = <&tlmm>;
 		interrupts = <61 IRQ_TYPE_LEVEL_LOW>;
 		pinctrl-names = "default";
 		pinctrl-0 = <&fp_to_ap_irq_l>, <&fp_rst_l>, <&fpmcu_boot0>;
+		boot0-gpios = <&tlmm 68 GPIO_ACTIVE_HIGH>;
+		reset-gpios = <&tlmm 78 GPIO_ACTIVE_LOW>;
 		spi-max-frequency = <3000000>;
+		vdd-supply = <&pp3300_fp_mcu>;
 	};
 };
 
-- 
https://chromeos.dev

