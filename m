Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCF7F19D
	for <patches@lists.linux.dev>; Thu, 12 May 2022 01:39:24 +0000 (UTC)
Received: by mail-pj1-f49.google.com with SMTP id iq10so3847958pjb.0
        for <patches@lists.linux.dev>; Wed, 11 May 2022 18:39:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7JY5OzjYLJW7Rr2xhfmPsDoAWZorsrA3jl8llvrg60E=;
        b=CkbH1Acr8lJ87fJOrQbgEx6SXYUoJXQllKefeIvEIVc9ckF4mlXxwIg7sw5ZIFZlSe
         KPJjJIAqpwQbuH7l4JyD2iVzLh5bvZm9hjLt26yPw3vUAfgk2aLAZbY8wpy01RPQ/lEc
         F8tgykp8v+d9SqCWc7+78bNTntl3w3Fp5AdDE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7JY5OzjYLJW7Rr2xhfmPsDoAWZorsrA3jl8llvrg60E=;
        b=LAqULr/9dakfj9Bm8Zn+qTzkpb/A6YZQT77G9330fvmxa1Nh/Z1XEkEtIGPKdV0G8y
         u9RuscsNu4FS2sjNyNwE5vT1wAQ4b+bMeBAoi2F5v5+l2r7kI/P95uJC2vh19lmZUPRn
         1B+bEHZsuI5ZzrU2sXKIIIEwKpk3ZoV9fT0sXnUK+AjwF13r7exd2Vnj4rTSexOJbHtG
         9+WFXKZvxGZzCCBOQVkPZOlR4xqPgwlRYfDrs2T0angcv5fSxvNGU5Bm8rGOTg5bQGLD
         /9CUtDpyWZctS5NGDSuEXwMKgeeQ7dFKEDX9iy4joAeNEjiKgu8IPv+sKaPBYDulCBPE
         fBHA==
X-Gm-Message-State: AOAM530ohULGeanH4W0GMwZMNZ1mPKf+4qYdplUieRguwJPhwwxWUrIJ
	kkbAIjIcVWeyL8xgPgBXz8Iv+Q==
X-Google-Smtp-Source: ABdhPJyMdRve7kEm91mSg9IVhIAWNGEF5IkkT0N0gEDCWsFRkKDNGC0YEfyDiZM6EpOoVX3qLxOpTA==
X-Received: by 2002:a17:902:f68a:b0:15e:b12d:f4a1 with SMTP id l10-20020a170902f68a00b0015eb12df4a1mr27586276plg.166.1652319564440;
        Wed, 11 May 2022 18:39:24 -0700 (PDT)
Received: from smtp.gmail.com ([2620:15c:202:201:193f:f17a:ab0d:1f83])
        by smtp.gmail.com with ESMTPSA id b7-20020a170902d50700b0015e8d4eb2cfsm2614766plg.281.2022.05.11.18.39.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 May 2022 18:39:24 -0700 (PDT)
From: Stephen Boyd <swboyd@chromium.org>
To: Rob Herring <robh+dt@kernel.org>
Cc: linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	devicetree@vger.kernel.org,
	Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
	chrome-platform@lists.linux.dev,
	Guenter Roeck <groeck@chromium.org>,
	Douglas Anderson <dianders@chromium.org>,
	Craig Hesling <hesling@chromium.org>,
	Tom Hughes <tomhughes@chromium.org>,
	Alexandru M Stan <amstan@chromium.org>,
	Tzung-Bi Shih <tzungbi@kernel.org>,
	Matthias Kaehlcke <mka@chromium.org>,
	Benson Leung <bleung@chromium.org>,
	Lee Jones <lee.jones@linaro.org>
Subject: [PATCH v5 1/3] dt-bindings: cros-ec: Fix a typo in description
Date: Wed, 11 May 2022 18:39:19 -0700
Message-Id: <20220512013921.164637-2-swboyd@chromium.org>
X-Mailer: git-send-email 2.36.0.512.ge40c2bad7a-goog
In-Reply-To: <20220512013921.164637-1-swboyd@chromium.org>
References: <20220512013921.164637-1-swboyd@chromium.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A 's/pf/of/' on rpmsg-name description.

Cc: Rob Herring <robh+dt@kernel.org>
Cc: Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>
Cc: <devicetree@vger.kernel.org>
Cc: <chrome-platform@lists.linux.dev>
Cc: Guenter Roeck <groeck@chromium.org>
Cc: Douglas Anderson <dianders@chromium.org>
Cc: Craig Hesling <hesling@chromium.org>
Cc: Tom Hughes <tomhughes@chromium.org>
Cc: Alexandru M Stan <amstan@chromium.org>
Cc: Tzung-Bi Shih <tzungbi@kernel.org>
Cc: Matthias Kaehlcke <mka@chromium.org>
Cc: Benson Leung <bleung@chromium.org>
Cc: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Stephen Boyd <swboyd@chromium.org>
---
 Documentation/devicetree/bindings/mfd/google,cros-ec.yaml | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/mfd/google,cros-ec.yaml b/Documentation/devicetree/bindings/mfd/google,cros-ec.yaml
index d1f53bd449f7..99eda9ab0651 100644
--- a/Documentation/devicetree/bindings/mfd/google,cros-ec.yaml
+++ b/Documentation/devicetree/bindings/mfd/google,cros-ec.yaml
@@ -61,7 +61,7 @@ properties:
   mediatek,rpmsg-name:
     description:
       Must be defined if the cros-ec is a rpmsg device for a Mediatek
-      ARM Cortex M4 Co-processor. Contains the name pf the rpmsg
+      ARM Cortex M4 Co-processor. Contains the name of the rpmsg
       device. Used to match the subnode to the rpmsg device announced by
       the SCP.
     $ref: "/schemas/types.yaml#/definitions/string"
-- 
https://chromeos.dev

