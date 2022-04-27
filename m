Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AC03A3B
	for <patches@lists.linux.dev>; Wed, 27 Apr 2022 20:30:29 +0000 (UTC)
Received: by mail-pj1-f52.google.com with SMTP id u6-20020a17090a1f0600b001d86bd69427so2611266pja.5
        for <patches@lists.linux.dev>; Wed, 27 Apr 2022 13:30:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0An4PsvfV0601Q48LoUPqvVr8Bqsk0vm3xIqSwfj0Xo=;
        b=C1jLISe/eHjTAY7Yp96I7k+1AB2QekHwbYrjOoF6fNLDKBX394wxFdxk7wumcpQIo0
         zDRxwZnw9o9TOxnsypU1mn4zAd1Bni+SjNoxpVt2QxvYm56wioHwufVYBrnlt3aGc6tN
         mdVln6h2XLZ3Fjf4UMvmUnzxgWVXhzRHDpYu4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0An4PsvfV0601Q48LoUPqvVr8Bqsk0vm3xIqSwfj0Xo=;
        b=jJNFKm2Wfk3d8LZyjKUOrp2dWBQ+OU3VtjzVBXNNJ5x5gJqIpNSW9N27VqsXo+t404
         EoYnVfYdt3h88rtlMWaDs/0bP3ExqESurjTIvVArcHWQfEi3BoNgCjWpKGMHf/k+xe/k
         fJPXwucpN9G4yQn7r4YF2Ku3DwehkHoQjerMI/MHUJ7LP4RMMbJRZnghdHKYUqDsG9Ks
         Q+CJ7+Jjvw37bgE4MfrgJqr+Dbfc9GHNUvHoHZ6TnzAu/+hncZkK8FVB+/qaCDuFM2+Q
         Y7m9aIs1DMSucz0HONfuyyW2h6vhz0BdoMTrmIAzQot2RbnBv6PSPJILu0akv8pMwf22
         MQrA==
X-Gm-Message-State: AOAM530XQC7quNW+iT466cIKvkgYJOsYmKmgf5ccB6ndTxgdKrdzbWxK
	VnkC2U1guZzr1IlpnHaUJtWmfg==
X-Google-Smtp-Source: ABdhPJzZNWd2rOVEB4rsikOmKbzoJwM/16jcMtIJTw1nlAHLR+EFFNGpmmgtG99tnrf4SY15QyBCZQ==
X-Received: by 2002:a17:902:edc5:b0:158:4065:a5ce with SMTP id q5-20020a170902edc500b001584065a5cemr30951557plk.55.1651091428570;
        Wed, 27 Apr 2022 13:30:28 -0700 (PDT)
Received: from smtp.gmail.com ([2620:15c:202:201:482e:60bc:84d1:bf5c])
        by smtp.gmail.com with ESMTPSA id 7-20020a17090a000700b001da3920d985sm3858552pja.12.2022.04.27.13.30.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Apr 2022 13:30:28 -0700 (PDT)
From: Stephen Boyd <swboyd@chromium.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzk@kernel.org>,
	Rob Herring <robh+dt@kernel.org>,
	devicetree@vger.kernel.org,
	Benson Leung <bleung@chromium.org>,
	Guenter Roeck <groeck@chromium.org>,
	Douglas Anderson <dianders@chromium.org>,
	Hsin-Yi Wang <hsinyi@chromium.org>,
	"Joseph S. Barrera III" <joebar@chromium.org>
Subject: [PATCH 0/2] Input: cros-ec-keyb: Better matrixless support
Date: Wed, 27 Apr 2022 13:30:24 -0700
Message-Id: <20220427203026.828183-1-swboyd@chromium.org>
X-Mailer: git-send-email 2.36.0.rc2.479.g8af0fa9b8e-goog
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This is a followup to my previous patch[1] that skips keyboard registration
when the matrix properties aren't present. This adds a compatible string
for this scenario so we can ease existing DTBs over to the new design.

Stephen Boyd (2):
  dt-bindings: google,cros-ec-keyb: Introduce switches only compatible
  Input: cros-ec-keyb - skip keyboard registration for switches
    compatible

 .../bindings/input/google,cros-ec-keyb.yaml          | 12 +++++++++---
 drivers/input/keyboard/cros_ec_keyb.c                |  8 ++++++++
 2 files changed, 17 insertions(+), 3 deletions(-)

Cc: Krzysztof Kozlowski <krzk@kernel.org>
Cc: Rob Herring <robh+dt@kernel.org>
Cc: <devicetree@vger.kernel.org>
Cc: Benson Leung <bleung@chromium.org>
Cc: Guenter Roeck <groeck@chromium.org>
Cc: Douglas Anderson <dianders@chromium.org>
Cc: Hsin-Yi Wang <hsinyi@chromium.org>
Cc: "Joseph S. Barrera III" <joebar@chromium.org>

[1] https://lore.kernel.org/all/20220425210726.3813477-1-swboyd@chromium.org/

base-commit: 4352e23a7ff2f8a4ff229dd1283ed2f2b708ec51
-- 
https://chromeos.dev

