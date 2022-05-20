Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1099633C7
	for <patches@lists.linux.dev>; Fri, 20 May 2022 21:38:57 +0000 (UTC)
Received: by mail-pf1-f180.google.com with SMTP id p8so8745491pfh.8
        for <patches@lists.linux.dev>; Fri, 20 May 2022 14:38:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=X4AidQKqaOJBFkrFEoep38RZCtLNXvYdQVM6qUP1lGs=;
        b=mE1f5wQSYigKQ1+H9MOgTi3vyMSNM+UUuZ6gAvnXPS4r7gkjPfSajdqQnW2kzB4LbF
         b4XGc0fgAfGkt4mtIQ7Ze0qMx7ivhMLbaKUJ4m/09oBjy5KlDy8zUIjACsakUDHhjHvd
         Ey9MpmoJk5KIGRbcZpp1Pm+40kKvMZKbcFU+k=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=X4AidQKqaOJBFkrFEoep38RZCtLNXvYdQVM6qUP1lGs=;
        b=rfnhx/oe+4v6SmKV7pyzVjNs4GZPnkotn085JOJoa3sdiyn8NDk7Q1uSu44elrFbz2
         D/RrzEi3AtwMIMGTrMsCVoEWbnp9rnjyJS5qVYg9L4aSPkXbZu7QYd61/uZeakitJ58m
         jWigtaQR+A94sfy6gOC4O2VRapWN7w73zqFfliXN1GzDsA1c8YSSocFZKSQJvBK5kVNH
         o0K9zo7qa0193grh2lQHHPAR5nGkdy9EGKO/Pl+LTQtc9YKyaRzEFW1umpyKRVSKoKZ0
         GMUQzY68Z5NqPet5Xdw1dKWQ+K7aUtPI9ynq3vmBJS2xDqKeiGAA/SW9MsV3ynetj4tp
         XbEA==
X-Gm-Message-State: AOAM532uwSu2CBKwGXxoklP2D1ZfR7QMywO2cCrYT8De0KbWnqqWw9XY
	aNj4Mtt+RV+EZ89E+MHeapV1VQ==
X-Google-Smtp-Source: ABdhPJxvhnEW+lCzuypQCqtWqhSrOFBqIvNm7dwoni+Rciqpfz0M8J51+7nSht53Vabi6hhC8rlW1g==
X-Received: by 2002:a63:1953:0:b0:3c6:e5e:9190 with SMTP id 19-20020a631953000000b003c60e5e9190mr10075599pgz.286.1653082737518;
        Fri, 20 May 2022 14:38:57 -0700 (PDT)
Received: from tictac2.mtv.corp.google.com ([2620:15c:202:201:b090:3896:c312:c4df])
        by smtp.gmail.com with ESMTPSA id u13-20020a17090a450d00b001df955c28f6sm2070864pjg.37.2022.05.20.14.38.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 May 2022 14:38:56 -0700 (PDT)
From: Douglas Anderson <dianders@chromium.org>
To: Rob Herring <robh+dt@kernel.org>,
	Bjorn Andersson <bjorn.andersson@linaro.org>
Cc: Matthias Kaehlcke <mka@chromium.org>,
	Alexandru M Stan <amstan@chromium.org>,
	patches@lists.linux.dev,
	linux-arm-msm@vger.kernel.org,
	Julius Werner <jwerner@chromium.org>,
	Andy Gross <agross@kernel.org>,
	Stephen Boyd <swboyd@chromium.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Rajendra Nayak <quic_rjendra@quicinc.com>,
	"Joseph S . Barrera III" <joebar@chromium.org>,
	devicetree@vger.kernel.org,
	Douglas Anderson <dianders@chromium.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Stephen Boyd <sboyd@codeaurora.org>,
	linux-kernel@vger.kernel.org
Subject: [PATCH v4 4/5] dt-bindings: arm: qcom: Add / fix sc7280 board bindings
Date: Fri, 20 May 2022 14:38:44 -0700
Message-Id: <20220520143502.v4.4.I1318c1ae2ce55ade1d092fc21df846360b15c560@changeid>
X-Mailer: git-send-email 2.36.1.124.g0e6072fb45-goog
In-Reply-To: <20220520143502.v4.1.I71e42c6174f1cec17da3024c9f73ba373263b9b6@changeid>
References: <20220520143502.v4.1.I71e42c6174f1cec17da3024c9f73ba373263b9b6@changeid>
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
index 01e40ea40724..3d150d1a93cd 100644
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

