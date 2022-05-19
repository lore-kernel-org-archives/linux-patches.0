Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D370033C3
	for <patches@lists.linux.dev>; Thu, 19 May 2022 23:51:31 +0000 (UTC)
Received: by mail-pj1-f42.google.com with SMTP id v5-20020a17090a7c0500b001df84fa82f8so6516728pjf.5
        for <patches@lists.linux.dev>; Thu, 19 May 2022 16:51:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=F2j8gBiRNl2VaOq43M0rn2Ao2XR/GvcvBpoHrX5f89k=;
        b=mZ9xWcJPGJCLwrQNju9yrBuEuoKSQwUkwLIZnq2Z6nDS5vOkDGMOSfsKQ2m5wbrJGS
         im9eLAUujU9NdwzEiNvDe08dbGQFiBgqdKNUfakDj3mF9zmQpV/sMgYT8f+3D+/YSZYq
         x1mgKgyJM6AaxFa5ZJM8fwIirKWFbnctjc8M0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=F2j8gBiRNl2VaOq43M0rn2Ao2XR/GvcvBpoHrX5f89k=;
        b=2YFoVy5XUaAkJZRoX+LQdQrKzLUsKFfSJYLb5IeG0XxuNwV2V3/8cz4ba4aAfdqstu
         vOjRiPb3+E3qPrD56fgQWkc2M3hMpM1WJgqHHEVPFYl6Uel814LkXiNvP7gyR+luUYG5
         6lkZwHEGbe70sZ6iDv10zUgDGC8AL/CJg9KmwSxeeBVRQh6RFy47U5tQO2xsYS92HFrK
         L3PKaxSfMSW0DLLYrIrW05D+2qqr5Fi33cMxfyqoHBxO5DM+2jWJkRgZ+w1J+Iu1+nhy
         9EZYnNlsGXobJi/HZLVPZXXuhiCWtALU1E8JuFB6jWVU7R1zGajsg90hzumKUTxQ0/Sj
         q+2w==
X-Gm-Message-State: AOAM531zSNI02dSd+TV4YUi3BMcgUp8Bhw75bQ+NZu6QpMh82Md8kIBO
	HRI8pfDvqI2jB7D3GChRE+cz8A==
X-Google-Smtp-Source: ABdhPJxUwcFTBnCpm03bJuEKOfdkbdElV+yux9xGU1D+TTegkYpeTprFQkCozMA/Qs7+oaUQIP0DXg==
X-Received: by 2002:a17:902:c752:b0:161:7cb4:78b8 with SMTP id q18-20020a170902c75200b001617cb478b8mr6940375plq.39.1653004291348;
        Thu, 19 May 2022 16:51:31 -0700 (PDT)
Received: from tictac2.mtv.corp.google.com ([2620:15c:202:201:e45f:1f3c:299b:4d86])
        by smtp.gmail.com with ESMTPSA id m2-20020a6545c2000000b003c18ab7389asm4128992pgr.36.2022.05.19.16.51.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 May 2022 16:51:31 -0700 (PDT)
From: Douglas Anderson <dianders@chromium.org>
To: Rob Herring <robh+dt@kernel.org>,
	Bjorn Andersson <bjorn.andersson@linaro.org>
Cc: Stephen Boyd <swboyd@chromium.org>,
	linux-arm-msm@vger.kernel.org,
	Matthias Kaehlcke <mka@chromium.org>,
	Andy Gross <agross@kernel.org>,
	Alexandru M Stan <amstan@chromium.org>,
	"Joseph S . Barrera III" <joebar@chromium.org>,
	patches@lists.linux.dev,
	devicetree@vger.kernel.org,
	Rajendra Nayak <quic_rjendra@quicinc.com>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Julius Werner <jwerner@chromium.org>,
	Douglas Anderson <dianders@chromium.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Stephen Boyd <sboyd@codeaurora.org>,
	linux-kernel@vger.kernel.org
Subject: [PATCH v3 4/5] dt-bindings: arm: qcom: Add / fix sc7280 board bindings
Date: Thu, 19 May 2022 16:51:08 -0700
Message-Id: <20220519164914.v3.4.I1318c1ae2ce55ade1d092fc21df846360b15c560@changeid>
X-Mailer: git-send-email 2.36.1.124.g0e6072fb45-goog
In-Reply-To: <20220519164914.v3.1.I71e42c6174f1cec17da3024c9f73ba373263b9b6@changeid>
References: <20220519164914.v3.1.I71e42c6174f1cec17da3024c9f73ba373263b9b6@changeid>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This copy-pastes compatibles from sc7280-based boards from the device
trees to the yaml file. It also fixes the CRD/IDP bindings which had
gotten stale.

Signed-off-by: Douglas Anderson <dianders@chromium.org>
Reviewed-by: Matthias Kaehlcke <mka@chromium.org>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
---
It should be noted that these match the sc7280 boards as of the top of
the "for-next" branch of the tree
git.kernel.org/pub/scm/linux/kernel/git/qcom/linux.git

(no changes since v2)

Changes in v2:
- Use a "description" instead of a comment for each item.

 .../devicetree/bindings/arm/qcom.yaml         | 42 +++++++++++++++----
 1 file changed, 34 insertions(+), 8 deletions(-)

diff --git a/Documentation/devicetree/bindings/arm/qcom.yaml b/Documentation/devicetree/bindings/arm/qcom.yaml
index 2269493a1b48..f8caf4b920c8 100644
--- a/Documentation/devicetree/bindings/arm/qcom.yaml
+++ b/Documentation/devicetree/bindings/arm/qcom.yaml
@@ -404,14 +404,40 @@ properties:
           - const: google,trogdor-sku0
           - const: qcom,sc7180
 
-      - items:
-          - enum:
-              - qcom,sc7280-crd
-              - qcom,sc7280-idp
-              - qcom,sc7280-idp2
-              - google,hoglin
-              - google,piglin
-              - google,senor
+      - description: Qualcomm Technologies, Inc. sc7280 CRD platform (rev3 - 4)
+        items:
+          - const: qcom,sc7280-crd
+          - const: google,hoglin-rev3
+          - const: google,hoglin-rev4
+          - const: google,piglin-rev3
+          - const: google,piglin-rev4
+          - const: qcom,sc7280
+
+      - description: Qualcomm Technologies, Inc. sc7280 CRD platform (newest rev)
+        items:
+          - const: google,hoglin
+          - const: qcom,sc7280
+
+      - description: Qualcomm Technologies, Inc. sc7280 IDP SKU1 platform
+        items:
+          - const: qcom,sc7280-idp
+          - const: google,senor
+          - const: qcom,sc7280
+
+      - description: Qualcomm Technologies, Inc. sc7280 IDP SKU2 platform
+        items:
+          - const: qcom,sc7280-idp2
+          - const: google,piglin
+          - const: qcom,sc7280
+
+      - description: Google Herobrine (newest rev)
+        items:
+          - const: google,herobrine
+          - const: qcom,sc7280
+
+      - description: Google Villager (newest rev)
+        items:
+          - const: google,villager
           - const: qcom,sc7280
 
       - items:
-- 
2.36.1.124.g0e6072fb45-goog

