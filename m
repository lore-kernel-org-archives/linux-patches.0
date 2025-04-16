Received: from mail-pg1-f172.google.com (mail-pg1-f172.google.com [209.85.215.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BA33CA6B
	for <patches@lists.linux.dev>; Wed, 16 Apr 2025 00:02:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744761741; cv=none; b=eHHMsB+PEQr7Brnl5/NEJ8dyialDMdJnu6zC6OlMHx0MFbiqvnIGW0KBDtQj0qdIQfJekMbgeibb6bY6efRn7IxGCS0pYuUIDY9XuF6EBMSsg4+uZdUj5EX6jlphkUly94pwmVaYAr/F+C4OYTg9/rJ/FS4xqrEFPbHMURHOrog=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744761741; c=relaxed/simple;
	bh=prSaVLEnAK+vncf8usI+ZxASfQG4nPOuCBOY+Y2RjLs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cKnyVW8lDSTi2L2RoW0/3axcu/KMJQF2utvkp2PoYk6SHzrxm52d1VJzyRJEfQYir5g/aAloPS5dTgQi6f2sRqxDKeaHj+O7balTBbhq5NGTVuLP0aQRGKHxlCHx5SrHJ7iWagZ0MZVJPVVqUoX8MtInlgvVg9Ms0vSkSu2Z4R8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=RXHMRVAE; arc=none smtp.client-ip=209.85.215.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="RXHMRVAE"
Received: by mail-pg1-f172.google.com with SMTP id 41be03b00d2f7-af908bb32fdso149078a12.1
        for <patches@lists.linux.dev>; Tue, 15 Apr 2025 17:02:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1744761738; x=1745366538; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KYGM0h7RhBS79sRo31i/Eh5uWT+nxNBuyvsqtZ/CclU=;
        b=RXHMRVAEVNdPXIwjaNdG1pySxdDHtgd2KiAYBbcDxrva9vyx+1LdQHcpVs0M1p3O2P
         sx0ICip8aZFK9fIisQNPFTroHeqDhyHHvVQpeotPtmHOK9zUbtjqeqTAkedScdL3OC5U
         /F/s0tVHQ1fJu733333UGyi6Wm+u5K9WgkUoo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744761738; x=1745366538;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KYGM0h7RhBS79sRo31i/Eh5uWT+nxNBuyvsqtZ/CclU=;
        b=A67FvdlAPkgIF51fKdphycOcVIKA9fipKlSFyicu9emIbxHSdcJCz89emphZ7xKaw/
         vUWQDvTe4rxXa6rQ9juoyq7+NU4rao3qHe8xrXCX2wHRv7SDcqG2zT+yRDV9sqlTmkdc
         gqMWJs/ObpRd7QbVdx0Xge4oga/TOWsm6WPZ2o7ynY6buUaxyB7oNdQlK4iZvgLaL4r9
         nDNyoZBiMhED8tv4k/vK8SQd/r7yyKvgLziQJRt7/9BFkUJqacMfC8AQsLlLHVw+tKeQ
         GRuo78oglnyYPWltu81iHZrHa5eeRkiYEDV/jWwUh2VuUqVQCPQyaH5AihrTzxaA7vEj
         6HKQ==
X-Forwarded-Encrypted: i=1; AJvYcCXMwd3SxurZUzjuAEJvqs2fl8yzV+qKAQXsbHgkx+6xUkN8mChzBxYG6WiT57hBUJmlF8rVx+pT@lists.linux.dev
X-Gm-Message-State: AOJu0Yx18YaRAXLo5efqPjjmDnbpDPCNiC/8PFdjSW1Q1532WGeTnfSG
	+fXZKHTaoTs8gVovIlOgek/+XjKoBNCA9xSGDwddGDNmjbWnjZQj/b5xOljNiQ==
X-Gm-Gg: ASbGncuF+5rY+K6KAMvaNOO9L/HQNFnBkcNYkmuRsXvrkAbxheUzQFD9CVLsFzL46p1
	OT7YpPJNdODSq0b/CFrRzi0XKafcq7H127x3i2ft4s55Afe0NFO36+wdX7pNCnMyrpaSllEzHTh
	WiNhlWPygDmLERevEbQsLcTQq7TxQc0Mto2QiloI7RF7kxzFCGfyKJsTFxBq9sA7nEMxtzDGlQe
	KGIGJEapzeOvG2xEYxa19rE67Nn3rNc0rzreyJtt9cybRId/hnJWoVK1AJ0Iv6SWnbCPBRY4CPt
	C7NX++ieCbBCVJAWquw35pCQIcHMpdPeCf6FpA0PpiJQfC1JRpEfsKtOGJCDnuTeLORTdzIsaks
	Cjg==
X-Google-Smtp-Source: AGHT+IEOM8kY/Swx09k+WNyJ/f38PKBMBA/O7hhf0bPsaN2iBD0xvwXHaD7iBXxxmNY494s22DK7cg==
X-Received: by 2002:a17:90b:2e41:b0:2ee:9661:eafb with SMTP id 98e67ed59e1d1-3085dfaceecmr2050851a91.12.1744761738388;
        Tue, 15 Apr 2025 17:02:18 -0700 (PDT)
Received: from localhost (199.24.125.34.bc.googleusercontent.com. [34.125.24.199])
        by smtp.gmail.com with UTF8SMTPSA id d9443c01a7336-22c33fe4de0sm1234335ad.212.2025.04.15.17.02.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Apr 2025 17:02:17 -0700 (PDT)
From: Stephen Boyd <swboyd@chromium.org>
To: Tzung-Bi Shih <tzungbi@kernel.org>
Cc: linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Bjorn Andersson <andersson@kernel.org>,
	Konrad Dybcio <konradybcio@kernel.org>,
	devicetree@vger.kernel.org,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Rob Herring <robh@kernel.org>,
	linux-arm-msm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Conor Dooley <conor+dt@kernel.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
	Lee Jones <lee@kernel.org>,
	Benson Leung <bleung@chromium.org>,
	Guenter Roeck <groeck@chromium.org>,
	chrome-platform@lists.linux.dev,
	Pin-yen Lin <treapking@chromium.org>,
	Abhishek Pandit-Subedi <abhishekpandit@chromium.org>,
	=?UTF-8?q?=C5=81ukasz=20Bartosik?= <ukaszb@chromium.org>,
	Jameson Thies <jthies@google.com>,
	Andrei Kuchynski <akuchynski@chromium.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Subject: [PATCH 4/7] dt-bindings: Move google,cros-ec-typec binding to usb
Date: Tue, 15 Apr 2025 17:02:04 -0700
Message-ID: <20250416000208.3568635-5-swboyd@chromium.org>
X-Mailer: git-send-email 2.49.0.604.gff1f9ca942-goog
In-Reply-To: <20250416000208.3568635-1-swboyd@chromium.org>
References: <20250416000208.3568635-1-swboyd@chromium.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This binding is about USB type-c control. Move the binding to the usb
directory as it's a better home than chrome.

Reviewed-by: Rob Herring (Arm) <robh@kernel.org>
Cc: Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>
Cc: Conor Dooley <conor+dt@kernel.org>
Cc: Lee Jones <lee@kernel.org>
Cc: Benson Leung <bleung@chromium.org>
Cc: Guenter Roeck <groeck@chromium.org>
Cc: Tzung-Bi Shih <tzungbi@kernel.org>
Cc: <devicetree@vger.kernel.org>
Cc: <chrome-platform@lists.linux.dev>
Cc: Pin-yen Lin <treapking@chromium.org>
Cc: Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
Cc: Łukasz Bartosik <ukaszb@chromium.org>
Cc: Jameson Thies <jthies@google.com>
Cc: Andrei Kuchynski <akuchynski@chromium.org>
Suggested-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Stephen Boyd <swboyd@chromium.org>
---
 .../devicetree/bindings/mfd/google,cros-ec.yaml      |  2 +-
 .../{chrome => usb}/google,cros-ec-typec.yaml        | 12 ++++++------
 2 files changed, 7 insertions(+), 7 deletions(-)
 rename Documentation/devicetree/bindings/{chrome => usb}/google,cros-ec-typec.yaml (72%)

diff --git a/Documentation/devicetree/bindings/mfd/google,cros-ec.yaml b/Documentation/devicetree/bindings/mfd/google,cros-ec.yaml
index 50f457090066..ac89696fa649 100644
--- a/Documentation/devicetree/bindings/mfd/google,cros-ec.yaml
+++ b/Documentation/devicetree/bindings/mfd/google,cros-ec.yaml
@@ -99,7 +99,7 @@ properties:
   gpio-controller: true
 
   typec:
-    $ref: /schemas/chrome/google,cros-ec-typec.yaml#
+    $ref: /schemas/usb/google,cros-ec-typec.yaml#
 
   ec-pwm:
     $ref: /schemas/pwm/google,cros-ec-pwm.yaml#
diff --git a/Documentation/devicetree/bindings/chrome/google,cros-ec-typec.yaml b/Documentation/devicetree/bindings/usb/google,cros-ec-typec.yaml
similarity index 72%
rename from Documentation/devicetree/bindings/chrome/google,cros-ec-typec.yaml
rename to Documentation/devicetree/bindings/usb/google,cros-ec-typec.yaml
index 9f9816fbecbc..3272d0e01f7e 100644
--- a/Documentation/devicetree/bindings/chrome/google,cros-ec-typec.yaml
+++ b/Documentation/devicetree/bindings/usb/google,cros-ec-typec.yaml
@@ -1,20 +1,20 @@
 # SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
 %YAML 1.2
 ---
-$id: http://devicetree.org/schemas/chrome/google,cros-ec-typec.yaml#
+$id: http://devicetree.org/schemas/usb/google,cros-ec-typec.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: Google Chrome OS EC(Embedded Controller) Type C port driver.
+title: Google ChromeOS EC (Embedded Controller) USB Type-C Port Manager
 
 maintainers:
   - Benson Leung <bleung@chromium.org>
   - Prashant Malani <pmalani@chromium.org>
 
 description:
-  Chrome OS devices have an Embedded Controller(EC) which has access to
-  Type C port state. This node is intended to allow the host to read and
-  control the Type C ports. The node for this device should be under a
-  cros-ec node like google,cros-ec-spi.
+  Chrome OS devices have an Embedded Controller (EC) which has access to
+  USB Type-C port state. This node is intended to allow the host to read and
+  control the Type-C ports. The node for this device should be under a
+  cros-ec node with a compatible like "google,cros-ec-spi".
 
 properties:
   compatible:
-- 
https://chromeos.dev

