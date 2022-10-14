Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 012E24680
	for <patches@lists.linux.dev>; Fri, 14 Oct 2022 21:53:04 +0000 (UTC)
Received: by mail-pj1-f45.google.com with SMTP id pq16so6113105pjb.2
        for <patches@lists.linux.dev>; Fri, 14 Oct 2022 14:53:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=o1t17x5zzSpdCuf+jFEyQQCtGA/0x7inpYCOmKSTCbI=;
        b=Uo/GHpK8vU+smItb6OkYUg4Tbd+055hEHZN7hanO/jiPIWezUApYxsQMXMB6pYaNHW
         YN66dB0oETBKwriK4Nmb5J9TkN89fw0Z1ls/fLsECw/qHWGQjTN79WOUuwSOTqI8vUme
         ycK4KPHzIMv/LQwAtM1LH0zOkn9dBCsMmfJoY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=o1t17x5zzSpdCuf+jFEyQQCtGA/0x7inpYCOmKSTCbI=;
        b=0D+S6ZnC/bi+Bh1zexDiofHg5tzpjrxxMoEee7yraAOMNctCK9NkJhwN04r45WZCcO
         QPkPSRr+FnaUDK6bTxEH5/L/QXwZtjuZw4wzzQyn9M8oWK/JaQ1EGSKwImg6PlvtULXw
         k6sH+KCMTqqbQ3KF3d1+v2veO/d8EPWu6qYjLxU3LxHPCMqP2aAnjNOwk44K4/DdujoT
         M7Nyw5jBPjymrYpefp+XhEfDpI5sqxPofN5oBzu7oY6lXFAavTAgFuldCW4cbRr1qN1h
         rZpdf3p968u49bEQQE4MOPXjXmdRU7/iule69EcVgFo7if0o1MaO7evEzIBCUmCeRWFo
         JSbA==
X-Gm-Message-State: ACrzQf1s3XfUeXDYYORga8uMa3OahhvO/vSbLMk+/GehM+dU5igkSWin
	onJEI14mYF0z010DubQKUxa4HQ==
X-Google-Smtp-Source: AMsMyM68dam+bk2zRi9fPwq4foTUHTm41a5WwL7uUAIKb98CVmZlEOlpn3mQ8qWzIX9UqFFtGO8dCQ==
X-Received: by 2002:a17:90b:380b:b0:20d:7364:796f with SMTP id mq11-20020a17090b380b00b0020d7364796fmr30737pjb.13.1665784384453;
        Fri, 14 Oct 2022 14:53:04 -0700 (PDT)
Received: from smtp.gmail.com ([2620:15c:9d:2:9f6e:fc87:d13f:1fa6])
        by smtp.gmail.com with ESMTPSA id p184-20020a625bc1000000b005618189b0ffsm2197437pfb.104.2022.10.14.14.53.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Oct 2022 14:53:03 -0700 (PDT)
From: Stephen Boyd <swboyd@chromium.org>
To: stable@vger.kernel.org
Cc: Sibi Sankar <sibis@codeaurora.org>,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Alex Elder <elder@linaro.org>,
	Evan Green <evgreen@chromium.org>,
	Bjorn Andersson <bjorn.andersson@linaro.org>
Subject: [PATCH 5.10] arm64: dts: qcom: sc7180-trogdor: Fixup modem memory region
Date: Fri, 14 Oct 2022 14:53:02 -0700
Message-Id: <20221014215302.3905135-1-swboyd@chromium.org>
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

