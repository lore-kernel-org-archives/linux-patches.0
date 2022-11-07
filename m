Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0260B122AE
	for <patches@lists.linux.dev>; Mon,  7 Nov 2022 19:15:41 +0000 (UTC)
Received: by mail-pf1-f173.google.com with SMTP id y13so11532730pfp.7
        for <patches@lists.linux.dev>; Mon, 07 Nov 2022 11:15:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MAGGpX4Ay77YkRb+5QXDL/dau2EPpYwvMkCbBNog/BI=;
        b=TjqUSgqnII0G0WZTI6p6Gd/CyWQFWrHl1hMxQohEpc1bkF0MU6XGVc3OOjReGoaOms
         PRI20021zPm29apZ1ts3/q7kxLscRoXetQPBWCKZKHNHcoMxTSw1MSgBcMv0Cc69/6/z
         KLL99x85K3owtxshucfwd+CAs/vbJVeg3ndzk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MAGGpX4Ay77YkRb+5QXDL/dau2EPpYwvMkCbBNog/BI=;
        b=xxPKznm87l6a70YhsicWKd+WMbgKWxVZUCPqQok3ZvUaqWeqzxHvRQ/adf5cJ02B68
         EnFVVjhPSUfJhlm/zjUKLO3eBysZo3FeyfsfHiy3YXYWOfCC7c/+Lg2eAulSo9CU4B4h
         iDZ7xqc8Jeu8CIsjk8qeyakFpFuruoOd3WqpDu0FkwczIJk2Hzdi9/uI2rSweXZrN/Pd
         C2SwqZm5F6M+fCLQyejtn2DF/73PaIpaQSEf2KNk5yWZNHqvhcvgRK7oZFEolR70994p
         DE0kXN+pSc+asmb2hhSVlHIwJ4w/3SoFWdrVrg7NeH/6n2CaezKSMU9/Wxlj8qmwEKN/
         A6Gg==
X-Gm-Message-State: ANoB5plITpA2P350XKYTsTYb2exmzdWUIm3QhENntoLe+4/zFnBAxNjI
	M8Eyud7djpwCkFaVzBOJhUa0gIuyZz2IHg==
X-Google-Smtp-Source: AA0mqf6DAWhYHCQXdGe8W8GD7+Ltdyot8QuSvT65ONDzi3yi0qOK21KX1BPtL78HniLAO08zYVjNAw==
X-Received: by 2002:a63:f353:0:b0:470:814c:f4ee with SMTP id t19-20020a63f353000000b00470814cf4eemr3188280pgj.8.1667848541273;
        Mon, 07 Nov 2022 11:15:41 -0800 (PST)
Received: from smtp.gmail.com ([2620:15c:11a:201:4652:3752:b9b7:29f9])
        by smtp.gmail.com with ESMTPSA id r11-20020a170902c60b00b001830ed575c3sm5306627plr.117.2022.11.07.11.15.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Nov 2022 11:15:40 -0800 (PST)
From: Stephen Boyd <swboyd@chromium.org>
To: Andy Gross <agross@kernel.org>,
	Bjorn Andersson <andersson@kernel.org>
Cc: linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	linux-arm-msm@vger.kernel.org,
	Douglas Anderson <dianders@chromium.org>,
	Matthias Kaehlcke <mka@chromium.org>,
	Alexandru M Stan <amstan@chromium.org>
Subject: [PATCH v2 2/2] arm64: dts: qcom: Fully describe fingerprint node on Trogdor
Date: Mon,  7 Nov 2022 11:15:35 -0800
Message-Id: <20221107191535.624371-3-swboyd@chromium.org>
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

Update the fingerprint node on Trogdor to match the fingerprint DT
binding. This will allow us to drive the reset and boot gpios from the
driver when it is re-attached after flashing. We'll also be able to boot
the fingerprint processor if the BIOS isn't doing it for us.

Cc: Douglas Anderson <dianders@chromium.org>
Cc: Matthias Kaehlcke <mka@chromium.org>
Cc: Alexandru M Stan <amstan@chromium.org>
Signed-off-by: Stephen Boyd <swboyd@chromium.org>
---
 arch/arm64/boot/dts/qcom/sc7180-trogdor.dtsi | 20 ++++++++++++++++++--
 1 file changed, 18 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sc7180-trogdor.dtsi b/arch/arm64/boot/dts/qcom/sc7180-trogdor.dtsi
index 4a5ea17a15ba..65601bea0797 100644
--- a/arch/arm64/boot/dts/qcom/sc7180-trogdor.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc7180-trogdor.dtsi
@@ -894,13 +894,16 @@ ap_spi_fp: &spi10 {
 	cs-gpios = <&tlmm 89 GPIO_ACTIVE_LOW>;
 
 	cros_ec_fp: ec@0 {
-		compatible = "google,cros-ec-spi";
+		compatible = "google,cros-ec-fp", "google,cros-ec-spi";
 		reg = <0>;
 		interrupt-parent = <&tlmm>;
 		interrupts = <4 IRQ_TYPE_LEVEL_LOW>;
 		pinctrl-names = "default";
-		pinctrl-0 = <&fp_to_ap_irq_l>;
+		pinctrl-0 = <&fp_to_ap_irq_l>, <&fp_rst_l>, <&fpmcu_boot0>;
+		boot0-gpios = <&tlmm 10 GPIO_ACTIVE_HIGH>;
+		reset-gpios = <&tlmm 22 GPIO_ACTIVE_LOW>;
 		spi-max-frequency = <3000000>;
+		vdd-supply = <&pp3300_fp_tp>;
 	};
 };
 
@@ -1226,6 +1229,13 @@ en_pp3300_hub: en-pp3300-hub-state {
 		bias-disable;
 	};
 
+	fp_rst_l: fp-rst-l-state {
+		pins = "gpio22";
+		function = "gpio";
+		bias-disable;
+		drive-strength = <2>;
+	};
+
 	fp_to_ap_irq_l: fp-to-ap-irq-l-state {
 		pins = "gpio4";
 		function = "gpio";
@@ -1235,6 +1245,12 @@ fp_to_ap_irq_l: fp-to-ap-irq-l-state {
 		bias-disable;
 	};
 
+	fpmcu_boot0: fpmcu-boot0-state {
+		pins = "gpio10";
+		function = "gpio";
+		bias-disable;
+	};
+
 	h1_ap_int_odl: h1-ap-int-odl-state {
 		pins = "gpio42";
 		function = "gpio";
-- 
https://chromeos.dev

