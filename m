Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26C0733C3
	for <patches@lists.linux.dev>; Thu, 19 May 2022 23:51:33 +0000 (UTC)
Received: by mail-pl1-f181.google.com with SMTP id i1so6056881plg.7
        for <patches@lists.linux.dev>; Thu, 19 May 2022 16:51:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=VL7aIwZLpyrGDABa3dlA4nbQrEjgDT3j5OG51Wkr0cs=;
        b=DcFRazy5AS+leW4zapdXdURseTHi8jGS6Grlld8aafeb+yIROHu++Xcka/bBag2N+p
         ziu/FT5pheluYDxTPSE1BFyvJ/7878FZY/ryTtiQf6nPljNg/lO9+GhceTiMLDnLVmar
         0Yemt4SqBz2ac2O8Zf2vFxdPOCvwErHbvsBHs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=VL7aIwZLpyrGDABa3dlA4nbQrEjgDT3j5OG51Wkr0cs=;
        b=YdXCdLnn2dgCn/wRSOsTiT6qKJE+69xt/NGdHv3F5D8L+6HHDKdt8+sU8KUqtWxcF2
         vB3ZB9sPcNYMONOK9hYEojS/Wv+bXNFFMjIH04eevdrlJolBRedW8+XJo1DY1NuzJqTB
         I1RcxP/vfH/Uex/t8gARJNE89jcaSIuTAXtXzpJ0xzX9oUcxlPfkIonxKdeaR3+Gt93L
         bdbG+BNkEWKKbx/WAebVspuMxsVi5N6IjGqu3we1TVI0FnalxQ4FpcmnxUWqTbU7MHIa
         cPnQXSQVmMucl4KoTysyqAtYjW8KuSpMk/6IZDgotodAJzkfIBvouDPl0DdbgPGgJZEh
         0nJQ==
X-Gm-Message-State: AOAM533Uni3XZ4ANr271wF3qMR2Aawg3zACz91F0Xm+E0ToHh/YAE+OO
	xLKQITpQlk9a6863Ziugt+6PFA==
X-Google-Smtp-Source: ABdhPJxDCBjYQEFXMOhW/5hij1tJ4nYFm+rNW+jd6yuvkCW4cTwWZbXjZozQP/1fxI8WBq1SkoQC8g==
X-Received: by 2002:a17:902:7d89:b0:15e:e999:6b88 with SMTP id a9-20020a1709027d8900b0015ee9996b88mr7116055plm.98.1653004292678;
        Thu, 19 May 2022 16:51:32 -0700 (PDT)
Received: from tictac2.mtv.corp.google.com ([2620:15c:202:201:e45f:1f3c:299b:4d86])
        by smtp.gmail.com with ESMTPSA id m2-20020a6545c2000000b003c18ab7389asm4128992pgr.36.2022.05.19.16.51.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 May 2022 16:51:32 -0700 (PDT)
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
	Stephen Boyd <sboyd@codeaurora.org>,
	linux-kernel@vger.kernel.org
Subject: [PATCH v3 5/5] dt-bindings: arm: qcom: Add more sc7180 Chromebook board bindings
Date: Thu, 19 May 2022 16:51:09 -0700
Message-Id: <20220519164914.v3.5.Ie8713bc0377672ed8dd71189e66fc0b77226fb85@changeid>
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
index f8caf4b920c8..572a3677688e 100644
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

