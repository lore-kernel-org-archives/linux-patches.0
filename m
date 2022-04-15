Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com [209.85.215.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47949193
	for <patches@lists.linux.dev>; Fri, 15 Apr 2022 00:58:32 +0000 (UTC)
Received: by mail-pg1-f181.google.com with SMTP id 32so6186112pgl.4
        for <patches@lists.linux.dev>; Thu, 14 Apr 2022 17:58:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=hyPhXVFORyR7RHJurDudy51Y1BldxtR7Rr+Twqx8qq0=;
        b=UpGObQNJ7gxLnU45LjZFNpQNS19zh2dUmTNqqp7/RSYHnEnJJmqzaK/SFmjJkVcbMJ
         W8y4i2Ao0kZwQervAt6GTx7JNntpSbrJlTytQlb2tLhHP6BOAlATLy0QQoZNYWbZgLit
         yh71YPJ4APLS2/q9F6MaBZgCgGNc3J48TFOHo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=hyPhXVFORyR7RHJurDudy51Y1BldxtR7Rr+Twqx8qq0=;
        b=R3WV8BDwBKEFVtYJQ4dkySr4iW/O+BZn1uYeCpZ3wskW//7VuJWyLYh4ToGsI3XrLd
         vaJ2lZ30mj7hzaGmzWvWwN5MC06/Wi560KWfnlh0Ewxud7b8+aM/bANMq+hlU+D+p63H
         orgJT9U6laqOlf/LP7ecImtFMvFjIHN0EY7HmdKvse9PUp5s58usYDBHmDYup23H75ZG
         rEvHwq7kE71Dyzz1JlgjNRlC+v+IwH3U5MBvHC6u9Rgr4wcfceq4M+x1/6k8GIuCrwVy
         bx5Ss4BbWqa9UP3QRpDtBDODYRPgR7l/rDQki2earQwOVCCpL73JalAdNrUoEmSmfKKB
         bXEw==
X-Gm-Message-State: AOAM533yIO+Ey8O4PI2w90WcETDn7lcgUnGE9YDf0GYXAEy40H0B2wL2
	SdtRIOCg205lhJe/rYuG8vxqiQ==
X-Google-Smtp-Source: ABdhPJy8+lgOWC71xrEtCZKaYKOnrR2EXDQ6cNqAcqir/M+theLFdeFia3l5g/9/zMa7vy7Rxmj4BA==
X-Received: by 2002:a05:6a00:1a0a:b0:4fc:d6c5:f3f1 with SMTP id g10-20020a056a001a0a00b004fcd6c5f3f1mr6479101pfv.45.1649984311767;
        Thu, 14 Apr 2022 17:58:31 -0700 (PDT)
Received: from smtp.gmail.com ([2620:15c:202:201:e3e0:734:f81a:d2c1])
        by smtp.gmail.com with ESMTPSA id f4-20020aa79d84000000b00505f920ffb8sm996704pfq.179.2022.04.14.17.58.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Apr 2022 17:58:31 -0700 (PDT)
From: Stephen Boyd <swboyd@chromium.org>
To: Bjorn Andersson <bjorn.andersson@linaro.org>
Cc: linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	linux-arm-msm@vger.kernel.org,
	linux-pm@vger.kernel.org,
	Doug Anderson <dianders@chromium.org>,
	Alex Elder <elder@linaro.org>,
	Taniya Das <quic_tdas@quicinc.com>,
	Mike Tipton <quic_mdtipton@quicinc.com>,
	Georgi Djakov <djakov@kernel.org>
Subject: [PATCH 4/2] ARM: dts: qcom: sdx55: Remove ipa interconnect node
Date: Thu, 14 Apr 2022 17:58:27 -0700
Message-Id: <20220415005828.1980055-2-swboyd@chromium.org>
X-Mailer: git-send-email 2.36.0.rc0.470.gd361397f0d-goog
In-Reply-To: <20220415005828.1980055-1-swboyd@chromium.org>
References: <20220412220033.1273607-1-swboyd@chromium.org>
 <20220415005828.1980055-1-swboyd@chromium.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This device node is unused now that we've removed the driver that
consumed it in the kernel. Drop the unused node to save some space.

Cc: Alex Elder <elder@linaro.org>
Cc: Taniya Das <quic_tdas@quicinc.com>
Cc: Mike Tipton <quic_mdtipton@quicinc.com>
Cc: Georgi Djakov <djakov@kernel.org>
Signed-off-by: Stephen Boyd <swboyd@chromium.org>
---
 arch/arm/boot/dts/qcom-sdx55.dtsi | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/arch/arm/boot/dts/qcom-sdx55.dtsi b/arch/arm/boot/dts/qcom-sdx55.dtsi
index d455795da44c..f1e12a112cd0 100644
--- a/arch/arm/boot/dts/qcom-sdx55.dtsi
+++ b/arch/arm/boot/dts/qcom-sdx55.dtsi
@@ -275,13 +275,6 @@ system_noc: interconnect@162c000 {
 			qcom,bcm-voters = <&apps_bcm_voter>;
 		};
 
-		ipa_virt: interconnect@1e00000 {
-			compatible = "qcom,sdx55-ipa-virt";
-			reg = <0x01e00000 0x100000>;
-			#interconnect-cells = <1>;
-			qcom,bcm-voters = <&apps_bcm_voter>;
-		};
-
 		qpic_bam: dma-controller@1b04000 {
 			compatible = "qcom,bam-v1.7.0";
 			reg = <0x01b04000 0x1c000>;
-- 
https://chromeos.dev

