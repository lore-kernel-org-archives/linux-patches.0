Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C97C1C07
	for <patches@lists.linux.dev>; Tue, 23 Aug 2022 12:02:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28BFCC433C1
	for <patches@lists.linux.dev>; Tue, 23 Aug 2022 12:02:45 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="NJzMF0wK"
Resent-From: Mark Brown <broonie@kernel.org>
Resent-Date: Tue, 23 Aug 2022 13:02:42 +0100
Resent-Message-ID: <YwTB4lMxmgmNUiaC@sirena.org.uk>
Resent-To: patches@lists.linux.dev
Envelope-to: broonie@sirena.co.uk
Delivery-date: Tue, 23 Aug 2022 11:09:47 +0100
Received: from dfw.source.kernel.org ([139.178.84.217])
	by cassiel.sirena.org.uk with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <SRS0=50JJ=Y3=linaro.org=krzysztof.kozlowski@kernel.org>)
	id 1oQQqv-00A03F-9R
	for broonie@sirena.co.uk; Tue, 23 Aug 2022 11:09:47 +0100
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.source.kernel.org (Postfix) with ESMTPS id 432AE60FDA
	for <broonie@sirena.co.uk>; Tue, 23 Aug 2022 10:09:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix)
	id 27856C433B5; Tue, 23 Aug 2022 10:09:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4B228C433D6
	for <broonie@kernel.org>; Tue, 23 Aug 2022 10:09:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.kernel.org 4B228C433D6
Authentication-Results: smtp.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-lj1-f180.google.com with SMTP id by6so13021184ljb.11
        for <broonie@kernel.org>; Tue, 23 Aug 2022 03:09:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc;
        bh=ErvpQRBWkC02/y/WgiYae39JxDxYSGXzZJYCfCsFztw=;
        b=NJzMF0wK36YJI4Y5/nPYhPDEgd/lSMiBsUKJA/yftcv8bqHtHAe1vQ5durqBZtwhOP
         QGavVPDQPOl9xx4SvJd2tSM6TX6ZsoPjUba5PJfhzBQ5IaXO+IhDahlYCPt6CtOk7miI
         TR7jro59NXQ4J5Cn24tsqH2op0dWRMHdGgePZsu/IbRIBzeCMXXqbNLmMw29XAXOnXvC
         Dlmimhnhp8c4DthEkMiYWstqhm3oaJPiHja+RBJAML4cwwGfAhRezNnOewq5+vt/tONa
         hSiIrrG5NctxKxbQmWT97e5Zc8vTeGc7734VD8iqsUTLe/S/b0kvN+TDiQ5A+JeJ3jYY
         CHFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc;
        bh=ErvpQRBWkC02/y/WgiYae39JxDxYSGXzZJYCfCsFztw=;
        b=X8IdqnNBcpjMj0KfdbraDSll6tXkcvExldxOONHrS62X/udHaU32plw2sNXYjj4pfM
         Y2Q9gXkotSLp4nT4NG+92tUVHQsh/PSPSJEh0mYZj4uPNFN9t170S6nyScqJzYX3pTtb
         nBG5o8UOPHCnjuGOlH/QWi655VaNw2jTIxQpLU2tmC1QI3t5UmJ8gyGUySCQUyNmRvXS
         QEo3T9ffEvB8dXErXF0QD6II/Dvkg5kyJN6O3yL0UGv2NR0Qe1IsA2rhWbSNMKDLBtjI
         WbaIjFFQWtep77760wJ/LS1p6GqeU2otYWzI6yzWnpk2bYEIYbfKBwAQ6/gKIOuDxBJe
         kfyQ==
X-Gm-Message-State: ACgBeo29+vdqHPAtsJCYM+I9qKSJWoKRPcRAa9vYBhFb36KShPEsDidW
	GYKBvxUDXlcC5G2SNzjQ6NTrog==
X-Google-Smtp-Source: AA6agR50Az9/QXs8LIC8w+QkyNn58UqGMVOi0cVByjnt+xxhy/Eyr9XKoNj1PCwgTvUqPphA/x6d8Q==
X-Received: by 2002:a2e:3817:0:b0:261:cfba:ee4c with SMTP id f23-20020a2e3817000000b00261cfbaee4cmr2019651lja.443.1661249381299;
        Tue, 23 Aug 2022 03:09:41 -0700 (PDT)
Received: from krzk-bin.. (89-27-92-210.bb.dnainternet.fi. [89.27.92.210])
        by smtp.gmail.com with ESMTPSA id v11-20020a2ea44b000000b0025e42174f0csm2282737ljn.70.2022.08.23.03.09.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Aug 2022 03:09:40 -0700 (PDT)
From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
To: Serge Semin <fancer.lancer@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Rob Herring <robh+dt@kernel.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
	linux-spi@vger.kernel.org,
	devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Date: Tue, 23 Aug 2022 13:09:37 +0300
Message-Id: <20220823100937.386880-1-krzysztof.kozlowski@linaro.org>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 139.178.84.217
X-SA-Exim-Mail-From: SRS0=50JJ=Y3=linaro.org=krzysztof.kozlowski@kernel.org
Subject: [PATCH] spi: dt-bindings: snps,dw-apb-ssi: drop ref from reg-io-width
X-SA-Exim-Version: 4.2.1 (built Sat, 13 Feb 2021 17:57:42 +0000)
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); Unknown failure
X-TUID: gQsIq/40xdEX

reg-io-width is a standard property, so no need for defining its type

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
---
 Documentation/devicetree/bindings/spi/snps,dw-apb-ssi.yaml | 1 -
 1 file changed, 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/spi/snps,dw-apb-ssi.yaml b/Documentation/devicetree/bindings/spi/snps,dw-apb-ssi.yaml
index 37c3c272407d..d33b72fabc5d 100644
--- a/Documentation/devicetree/bindings/spi/snps,dw-apb-ssi.yaml
+++ b/Documentation/devicetree/bindings/spi/snps,dw-apb-ssi.yaml
@@ -104,7 +104,6 @@ properties:
     const: spi
 
   reg-io-width:
-    $ref: /schemas/types.yaml#/definitions/uint32
     description: I/O register width (in bytes) implemented by this device
     default: 4
     enum: [ 2, 4 ]
-- 
2.34.1

