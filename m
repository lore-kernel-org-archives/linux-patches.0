Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 132CC3FC2
	for <patches@lists.linux.dev>; Mon, 17 Oct 2022 18:22:43 +0000 (UTC)
Received: by mail-pj1-f49.google.com with SMTP id o17-20020a17090aac1100b0020d98b0c0f4so13655350pjq.4
        for <patches@lists.linux.dev>; Mon, 17 Oct 2022 11:22:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Q6K0fLEBttx8lrk4TTwV2hs18H4QMB+rkLX1+fm4Wis=;
        b=nxqUGdizsCANm/EpHpz5hqb4AimuiKiL4vxSxSv4+4wYsCrg3ZX2r+R0nalfLws+lo
         hkpfcpbWLzwK3FjxPPyjYWRoo2eJlZVFqFfN1ttObKYlxV3X/0770D3G8e0NtmrnyM2h
         NRRQp2E9X5Q+TL0/EC7JOM6GGtX+WIi/eFLLU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Q6K0fLEBttx8lrk4TTwV2hs18H4QMB+rkLX1+fm4Wis=;
        b=hFO7qcVFmG7HSMacV7RaS3pZrK5F1CXp+ecq7r1lAYUZPWpVGFbJdrhQLERbOhRSJX
         bIOJMg0M5RphzaO7jMazHAD9g4NlEbhq189+GzIyRrJzUMyu+ZoSp0q2FWU5Ytwi63wS
         j1eR8OhOYmDl5CNC2UFNtukdAvw5DiAST58y22G0IN3LxV4GfJ0y9PIpSwT67scCOe7J
         8lVrtbHtmZVkci7VUAvuh+ZVwVhQ4DFUFVfJrlrfVTV40wpYtvQUyy13uaCN/27rFdAi
         UHg3/N+BMoNx9DzL2nrKhDarOPygdU3qIkfmXjTEMYahs/SgkHwwrK8+SaWAc/Tnrk31
         1Tmw==
X-Gm-Message-State: ACrzQf0ROl337TaZJbhxGPs4vI2OeVZH0RxOxcQrjXPUBtBxGkTrPeGN
	SwmqUpPtCb5gWKFMcm+fNVeRIg==
X-Google-Smtp-Source: AMsMyM7GLm+6wFeWIABSOhA4Ga3nzDh8hX5DBawB8jbrqm0QCqI77NSN0GrmXH8LNM2NUdHzY7+V7A==
X-Received: by 2002:a17:903:2342:b0:181:bc30:b02f with SMTP id c2-20020a170903234200b00181bc30b02fmr12928368plh.30.1666030963439;
        Mon, 17 Oct 2022 11:22:43 -0700 (PDT)
Received: from smtp.gmail.com ([2620:15c:9d:2:f043:fb90:4576:538b])
        by smtp.gmail.com with ESMTPSA id n18-20020a170903111200b001782a0d3eeasm7014597plh.115.2022.10.17.11.22.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Oct 2022 11:22:42 -0700 (PDT)
From: Stephen Boyd <swboyd@chromium.org>
To: stable@vger.kernel.org
Cc: Sibi Sankar <sibis@codeaurora.org>,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Evan Green <evgreen@chromium.org>,
	Bjorn Andersson <bjorn.andersson@linaro.org>,
	Alex Elder <elder@linaro.org>
Subject: [PATCH] arm64: dts: qcom: sc7180-trogdor: Fixup modem memory region
Date: Mon, 17 Oct 2022 11:22:41 -0700
Message-Id: <20221017182241.1086545-1-swboyd@chromium.org>
X-Mailer: git-send-email 2.38.0.413.g74048e4d9e-goog
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Sibi Sankar <sibis@codeaurora.org>

commit ef9a5d188d663753e73a3c8e8910ceab8e9305c4 upstream.

The modem firmware memory requirements vary between 32M/140M on
no-lte/lte skus respectively, so fixup the modem memory region
to reflect the requirements.

Reviewed-by: Evan Green <evgreen@chromium.org>
Signed-off-by: Sibi Sankar <sibis@codeaurora.org>
Link: https://lore.kernel.org/r/1602786476-27833-1-git-send-email-sibis@codeaurora.org
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Acked-by: Alex Elder <elder@linaro.org>
Signed-off-by: Stephen Boyd <swboyd@chromium.org>
---

This fixes boot of the modem on trogdor boards with the DTS from 5.10.y
stable tree. Without this patch I run into memory assignment errors and
then the modem fails to boot.

 arch/arm64/boot/dts/qcom/sc7180-trogdor-lte-sku.dtsi | 4 ++++
 arch/arm64/boot/dts/qcom/sc7180-trogdor.dtsi         | 2 +-
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/sc7180-trogdor-lte-sku.dtsi b/arch/arm64/boot/dts/qcom/sc7180-trogdor-lte-sku.dtsi
index 44956e3165a1..469aad4e5948 100644
--- a/arch/arm64/boot/dts/qcom/sc7180-trogdor-lte-sku.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc7180-trogdor-lte-sku.dtsi
@@ -9,6 +9,10 @@ &ap_sar_sensor {
 	label = "proximity-wifi-lte";
 };
 
+&mpss_mem {
+	reg = <0x0 0x86000000 0x0 0x8c00000>;
+};
+
 &remoteproc_mpss {
 	firmware-name = "qcom/sc7180-trogdor/modem/mba.mbn",
 			"qcom/sc7180-trogdor/modem/qdsp6sw.mbn";
diff --git a/arch/arm64/boot/dts/qcom/sc7180-trogdor.dtsi b/arch/arm64/boot/dts/qcom/sc7180-trogdor.dtsi
index 5b2a616c6257..cb2c47f13a8a 100644
--- a/arch/arm64/boot/dts/qcom/sc7180-trogdor.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc7180-trogdor.dtsi
@@ -39,7 +39,7 @@ atf_mem: memory@80b00000 {
 		};
 
 		mpss_mem: memory@86000000 {
-			reg = <0x0 0x86000000 0x0 0x8c00000>;
+			reg = <0x0 0x86000000 0x0 0x2000000>;
 			no-map;
 		};
 

base-commit: 014862eecf03f58066a957027dde73cbecdf4395
-- 
https://chromeos.dev

