Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B46733C3
	for <patches@lists.linux.dev>; Fri, 20 May 2022 21:38:59 +0000 (UTC)
Received: by mail-pf1-f182.google.com with SMTP id u15so8723509pfi.3
        for <patches@lists.linux.dev>; Fri, 20 May 2022 14:38:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ZQ2KrWI0EiNa0ULNozZxqTb7Y+O6pRaYri0fx8T7At0=;
        b=cDmaqGWJnaY54HoWb9We1U4FTyE4HL0f4W2ybIrqmZ0iaJ1Dr+J5bZjHN/2jS4x9PZ
         IB6UsE7Sh9xodiNq215No0kds3elG/NYREsUFMzepFzbjwJn8RpfjMHKKGBhue3jstEP
         MGE9htG8t7/dZK/LHpMApUt7BhDa0qLVbDOfs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZQ2KrWI0EiNa0ULNozZxqTb7Y+O6pRaYri0fx8T7At0=;
        b=nPg1xWiWq3FOq8LbS/M2hNielaQqHEkiMc+FQeXORaQ8Iwt//J7TFNh//HeC0eF2fs
         9MNiRrpAWDDNspnHgwysQJpQxIe1Z3PsfmlZH9BrYadn0uJNXh1txgMl8Wj9a2xy5L5A
         X4uPl2JkZlgwlL600MI1eMEV4/j5KHYudCW/vhFuR90JghZ5M7jxtvUMC/RX0jnPS2JJ
         Zwu7m9EL30PUKz9yEfBuVtVYSsyTDxZpp0o4kbHJE2xRu2BLz04veRuLT/Dmr1F9VTfZ
         UI6pZB6e/KwtfurVgorCk41051ll02P3qKyegbBHPeCz+QDH/f4idlXGlFsZ4N+FX06v
         Siog==
X-Gm-Message-State: AOAM533Ne3W67fGS7+Dbwc0s1uOwdw3B6+Gi1JpLLv6qE+fJyQE/yRuX
	2UEc0l8BFWlELC0ltVas/FTp3g==
X-Google-Smtp-Source: ABdhPJwkc/kOX6OWoY2oHDcXjDVncpYxxgf9d8I0k5TNyam2VBWxLal/6cfcWgeYFMcUYfxtU1DQxQ==
X-Received: by 2002:a63:f50:0:b0:3db:48b1:a7e1 with SMTP id 16-20020a630f50000000b003db48b1a7e1mr10075824pgp.579.1653082738706;
        Fri, 20 May 2022 14:38:58 -0700 (PDT)
Received: from tictac2.mtv.corp.google.com ([2620:15c:202:201:b090:3896:c312:c4df])
        by smtp.gmail.com with ESMTPSA id u13-20020a17090a450d00b001df955c28f6sm2070864pjg.37.2022.05.20.14.38.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 May 2022 14:38:58 -0700 (PDT)
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
	Stephen Boyd <sboyd@codeaurora.org>,
	linux-kernel@vger.kernel.org
Subject: [PATCH v4 5/5] dt-bindings: arm: qcom: Add more sc7180 Chromebook board bindings
Date: Fri, 20 May 2022 14:38:45 -0700
Message-Id: <20220520143502.v4.5.Ie8713bc0377672ed8dd71189e66fc0b77226fb85@changeid>
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

This adds board bindings for boards that are downstream but not quite
upstream yet.

Signed-off-by: Douglas Anderson <dianders@chromium.org>
Reviewed-by: Matthias Kaehlcke <mka@chromium.org>
---
Normally this bindings doc would go together in the same series that
adds the device trees. In this case, Joe has been sending patches
supporting these Chromebooks. His most recent posting is:

https://lore.kernel.org/r/20220510154406.v5.1.Id769ddc5dbf570ccb511db96da59f97d08f75a9c@changeid/

If he were to add this patch to the end of his v6, however, it would
make things a bit more complicated simply becuase it would cause
conflicts with all the other patches in this series. ...so steady
state it would be correct to keep it in the series with the device
tree files, but for this one time I think it makes sense to keep all
the Chromebook board bindings patches together.

(no changes since v2)

Changes in v2:
- Use a "description" instead of a comment for each item.
- Use the marketing name instead of the code name where possible.

 .../devicetree/bindings/arm/qcom.yaml         | 92 +++++++++++++++++++
 1 file changed, 92 insertions(+)

diff --git a/Documentation/devicetree/bindings/arm/qcom.yaml b/Documentation/devicetree/bindings/arm/qcom.yaml
index 3d150d1a93cd..277faf59db57 100644
--- a/Documentation/devicetree/bindings/arm/qcom.yaml
+++ b/Documentation/devicetree/bindings/arm/qcom.yaml
@@ -263,6 +263,16 @@ properties:
           - const: google,homestar
           - const: qcom,sc7180
 
+      - description: Google Kingoftown (rev0)
+        items:
+          - const: google,kingoftown-rev0
+          - const: qcom,sc7180
+
+      - description: Google Kingoftown (newest rev)
+        items:
+          - const: google,kingoftown
+          - const: qcom,sc7180
+
       - description: Acer Chromebook Spin 513 (rev0)
         items:
           - const: google,lazor-rev0
@@ -364,6 +374,48 @@ properties:
           - const: google,lazor-sku6
           - const: qcom,sc7180
 
+      - description: Google Mrbland with AUO panel (rev0)
+        items:
+          - const: google,mrbland-rev0-sku0
+          - const: qcom,sc7180
+
+      - description: Google Mrbland with AUO panel (newest rev)
+        items:
+          - const: google,mrbland-sku1536
+          - const: qcom,sc7180
+
+      - description: Google Mrbland with BOE panel (rev0)
+        items:
+          - const: google,mrbland-rev0-sku16
+          - const: qcom,sc7180
+
+      - description: Google Mrbland with BOE panel (newest rev)
+        items:
+          - const: google,mrbland-sku1024
+          - const: google,mrbland-sku768
+          - const: qcom,sc7180
+
+      - description: Google Pazquel with Parade (newest rev)
+        items:
+          - const: google,pazquel-sku5
+          - const: qcom,sc7180
+
+      - description: Google Pazquel with TI (newest rev)
+        items:
+          - const: google,pazquel-sku1
+          - const: qcom,sc7180
+
+      - description: Google Pazquel with LTE and Parade (newest rev)
+        items:
+          - const: google,pazquel-sku4
+          - const: qcom,sc7180
+
+      - description: Google Pazquel with LTE and TI (newest rev)
+        items:
+          - const: google,pazquel-sku0
+          - const: google,pazquel-sku2
+          - const: qcom,sc7180
+
       - description: Sharp Dynabook Chromebook C1 (rev1)
         items:
           - const: google,pompom-rev1
@@ -394,6 +446,16 @@ properties:
           - const: google,pompom-sku0
           - const: qcom,sc7180
 
+      - description: Google Quackingstick (newest rev)
+        items:
+          - const: google,quackingstick-sku1537
+          - const: qcom,sc7180
+
+      - description: Google Quackingstick with LTE (newest rev)
+        items:
+          - const: google,quackingstick-sku1536
+          - const: qcom,sc7180
+
       - description: Google Trogdor (newest rev)
         items:
           - const: google,trogdor
@@ -404,6 +466,36 @@ properties:
           - const: google,trogdor-sku0
           - const: qcom,sc7180
 
+      - description: Lenovo IdeaPad Chromebook Duet 3 with BOE panel (rev0)
+        items:
+          - const: google,wormdingler-rev0-sku16
+          - const: qcom,sc7180
+
+      - description: Lenovo IdeaPad Chromebook Duet 3 with BOE panel (newest rev)
+        items:
+          - const: google,wormdingler-sku1024
+          - const: qcom,sc7180
+
+      - description: Lenovo IdeaPad Chromebook Duet 3 with BOE panel and rt5682s (newest rev)
+        items:
+          - const: google,wormdingler-sku1025
+          - const: qcom,sc7180
+
+      - description: Lenovo IdeaPad Chromebook Duet 3 with INX panel (rev0)
+        items:
+          - const: google,wormdingler-rev0-sku0
+          - const: qcom,sc7180
+
+      - description: Lenovo IdeaPad Chromebook Duet 3 with INX panel (newest rev)
+        items:
+          - const: google,wormdingler-sku0
+          - const: qcom,sc7180
+
+      - description: Lenovo IdeaPad Chromebook Duet 3 with INX panel and rt5682s (newest rev)
+        items:
+          - const: google,wormdingler-sku1
+          - const: qcom,sc7180
+
       - description: Qualcomm Technologies, Inc. sc7280 CRD platform (rev3 - 4)
         items:
           - const: qcom,sc7280-crd
-- 
2.36.1.124.g0e6072fb45-goog

