Received: from mail-pg1-f176.google.com (mail-pg1-f176.google.com [209.85.215.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EA647B
	for <patches@lists.linux.dev>; Fri, 15 Apr 2022 00:58:33 +0000 (UTC)
Received: by mail-pg1-f176.google.com with SMTP id u2so6165867pgq.10
        for <patches@lists.linux.dev>; Thu, 14 Apr 2022 17:58:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=6RfMGdKt6sT3pinBO9IrFwb5LdGvY5fx5UYNrjOQN9M=;
        b=QUiN9agZBCx+JMm2nV8wmIiDfq2R5CV9L/WWd5BOUKROTJsP+ECGlANoqFKYxztSPt
         Ufa5T3uTXygzI2EdQx07WtuFtCteR+GAXfmE7jwlZf6ewzHDEIvdv92ANG6/iIdU8/X7
         xuf791aM7WXod9YiZfpje2sxurBCWhuUj2YOs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6RfMGdKt6sT3pinBO9IrFwb5LdGvY5fx5UYNrjOQN9M=;
        b=J1/iy2kHf7KmaPxw0MhCdTU3Vdsd3bAexlnmv7D7eg4wkwIlM8xn73TnI3RQ0F/WYc
         o6ljB2W4H8fFXsvfItdquryQiO2F54awVa4DszxuzMAG0gEXDwu7Q3ekR6k/wk6SPbwh
         OZg9By6m3pTyD6LUGxcOWibjBoH1huEeSW/TWQA5LeMIMelA6VtMGDMpUYm5dKoD7J1v
         nrPj/0Ba/+KSzkLG52sg9BGOUpqqK71XeWSFQkuNqkdIIO5KQLkNoMPZFOsLQV9lQzXO
         Si8rzYvpewoCzpHWUaayYNR2giAJIN3tTdYmWmbWUtB7UD3kPVSn4uQLA4dFyQN04MaG
         dx/A==
X-Gm-Message-State: AOAM531xOEggdBYZZd9pV99yyzqIcvw8aABh1BuRtuJax23Onsp7Rbyk
	cH+8n7uQmtsOKgoOJxVu+ymiOA==
X-Google-Smtp-Source: ABdhPJwgCOw+24ZdVI9uQ3hL6YBLZPeoQOXYUcxZ5CfZ5gHXXZWp3SoY7w7t7knho8uZFaLhh7ExcQ==
X-Received: by 2002:a05:6a00:bd1:b0:4fa:a5d7:c082 with SMTP id x17-20020a056a000bd100b004faa5d7c082mr6372675pfu.85.1649984312895;
        Thu, 14 Apr 2022 17:58:32 -0700 (PDT)
Received: from smtp.gmail.com ([2620:15c:202:201:e3e0:734:f81a:d2c1])
        by smtp.gmail.com with ESMTPSA id f4-20020aa79d84000000b00505f920ffb8sm996704pfq.179.2022.04.14.17.58.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Apr 2022 17:58:32 -0700 (PDT)
From: Stephen Boyd <swboyd@chromium.org>
To: Georgi Djakov <djakov@kernel.org>,
	Bjorn Andersson <bjorn.andersson@linaro.org>
Cc: linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	linux-arm-msm@vger.kernel.org,
	linux-pm@vger.kernel.org,
	Doug Anderson <dianders@chromium.org>,
	Alex Elder <elder@linaro.org>,
	Taniya Das <quic_tdas@quicinc.com>,
	Mike Tipton <quic_mdtipton@quicinc.com>
Subject: [PATCH 5/2] dt-bindings: interconnect: Remove sc7180/sdx55 ipa compatibles
Date: Thu, 14 Apr 2022 17:58:28 -0700
Message-Id: <20220415005828.1980055-3-swboyd@chromium.org>
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

These interconnects are modeled as clks, not interconnects, therefore
remove the compatibles from the binding as they're unused.

Cc: Alex Elder <elder@linaro.org>
Cc: Taniya Das <quic_tdas@quicinc.com>
Cc: Mike Tipton <quic_mdtipton@quicinc.com>
Signed-off-by: Stephen Boyd <swboyd@chromium.org>
---

I don't know who should apply this. Probably whoever takes the dtsi
patches, Bjorn?, because otherwise dt_bindings_check will fail.

 Documentation/devicetree/bindings/interconnect/qcom,rpmh.yaml | 2 --
 1 file changed, 2 deletions(-)

diff --git a/Documentation/devicetree/bindings/interconnect/qcom,rpmh.yaml b/Documentation/devicetree/bindings/interconnect/qcom,rpmh.yaml
index 5a911be0c2ea..ab859150c7f7 100644
--- a/Documentation/devicetree/bindings/interconnect/qcom,rpmh.yaml
+++ b/Documentation/devicetree/bindings/interconnect/qcom,rpmh.yaml
@@ -31,7 +31,6 @@ properties:
       - qcom,sc7180-config-noc
       - qcom,sc7180-dc-noc
       - qcom,sc7180-gem-noc
-      - qcom,sc7180-ipa-virt
       - qcom,sc7180-mc-virt
       - qcom,sc7180-mmss-noc
       - qcom,sc7180-npu-noc
@@ -68,7 +67,6 @@ properties:
       - qcom,sdm845-mem-noc
       - qcom,sdm845-mmss-noc
       - qcom,sdm845-system-noc
-      - qcom,sdx55-ipa-virt
       - qcom,sdx55-mc-virt
       - qcom,sdx55-mem-noc
       - qcom,sdx55-system-noc
-- 
https://chromeos.dev

