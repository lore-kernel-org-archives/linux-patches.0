Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com [209.85.215.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 415D37B
	for <patches@lists.linux.dev>; Fri, 15 Apr 2022 00:58:31 +0000 (UTC)
Received: by mail-pg1-f178.google.com with SMTP id 32so6186073pgl.4
        for <patches@lists.linux.dev>; Thu, 14 Apr 2022 17:58:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=nivLXuALlDwZeTeyTShIS0npp9UwNHyhe5LyhEGbsc0=;
        b=kFQYbYQs4nKlAoV4Qnt5y82rIon3SBCqqdy2FFOMcp5eA1+6CMzfmv17aqRfLeuqCd
         nHX9AYJtLzEWIpkncGyy7Fgsrr5YEu4Bh+ShPtYgQ4HXJXXcCjA9698rJAHeE0FYVkAF
         NFfRZv12a2o1qEDhG7Q+3kZaKME+8BbmEHsow=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=nivLXuALlDwZeTeyTShIS0npp9UwNHyhe5LyhEGbsc0=;
        b=ykiy7+6NicynoJPf+c/HNajsBdBAQDysDNjNgaJLbKod0NLm1bqn5MZv2fXQ8a7SBU
         ia82S4eYna7kqW5S1kZsRMImmrJJfTG53DQsCNpV2Qjmz/unV3o3TQ8CQN4hINW+0+6m
         LCM1Ce9/UdVKMhlQHvExkNvvyNd7zANfjruEz61puydZXVXdFneubS9tlkc0y7DK1LQ1
         bbtExriMeGo2y72Z41ERiwL4vq0H3fIox3co1y7pKn8O4gA5WNEnLgvBeXKVWuxJbzqO
         OJRy4YB4eqsDva0LctmobgPWu60owB+X6amP4hc78uv0WEb5NM53LxGgeruX7jbDBPQy
         B2kA==
X-Gm-Message-State: AOAM530wGexAvuO1gP1Ti/+5xqNt5MspxKDu+svSC9CSwwqp1toHSPtL
	cMdBEFlt1vzqEuY4MX9moZC1YQ==
X-Google-Smtp-Source: ABdhPJxMW6DDQ/+8KjI8q0QY302MBkgPITxHqt8bk7gZFm2Gnr9CY/LpE6g2GhkUvZxl7WwDmgXm/A==
X-Received: by 2002:a63:5c43:0:b0:39d:5e18:9d98 with SMTP id n3-20020a635c43000000b0039d5e189d98mr4386181pgm.145.1649984310604;
        Thu, 14 Apr 2022 17:58:30 -0700 (PDT)
Received: from smtp.gmail.com ([2620:15c:202:201:e3e0:734:f81a:d2c1])
        by smtp.gmail.com with ESMTPSA id f4-20020aa79d84000000b00505f920ffb8sm996704pfq.179.2022.04.14.17.58.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Apr 2022 17:58:30 -0700 (PDT)
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
Subject: [PATCH 3/2] arm64: dts: qcom: sc7180: Remove ipa interconnect node
Date: Thu, 14 Apr 2022 17:58:26 -0700
Message-Id: <20220415005828.1980055-1-swboyd@chromium.org>
X-Mailer: git-send-email 2.36.0.rc0.470.gd361397f0d-goog
In-Reply-To: <20220412220033.1273607-1-swboyd@chromium.org>
References: <20220412220033.1273607-1-swboyd@chromium.org>
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
 arch/arm64/boot/dts/qcom/sc7180.dtsi | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sc7180.dtsi b/arch/arm64/boot/dts/qcom/sc7180.dtsi
index e1c46b80f14a..1ff96ef30e3f 100644
--- a/arch/arm64/boot/dts/qcom/sc7180.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc7180.dtsi
@@ -1421,13 +1421,6 @@ mmss_noc: interconnect@1740000 {
 			qcom,bcm-voters = <&apps_bcm_voter>;
 		};
 
-		ipa_virt: interconnect@1e00000 {
-			compatible = "qcom,sc7180-ipa-virt";
-			reg = <0 0x01e00000 0 0x1000>;
-			#interconnect-cells = <2>;
-			qcom,bcm-voters = <&apps_bcm_voter>;
-		};
-
 		ipa: ipa@1e40000 {
 			compatible = "qcom,sc7180-ipa";
 
-- 
https://chromeos.dev

