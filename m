Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3B151FC2
	for <patches@lists.linux.dev>; Wed, 29 Nov 2023 03:04:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="CA8+FK/E"
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-6c4eb5fda3cso6158016b3a.2
        for <patches@lists.linux.dev>; Tue, 28 Nov 2023 19:04:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1701227086; x=1701831886; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=tJGxAu392s/bORKdAjJBrcSJ8FzTjUlfAs3pgZbxfG8=;
        b=CA8+FK/EsoOmQM38CVDf5z0rwKYYp69mVx3UzB6LyxTdpjekgaAuj+FzL3Qm37zF/h
         Hilqg/CffS2E5dEEoB/f2MezgeJnwkmEegOWg+1t8QkHYUBAa1huGxINS4z5QuLCIrQO
         iBImsLFMLAzeKXlstUhcxyAxSnvTDgynZgwDI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701227086; x=1701831886;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tJGxAu392s/bORKdAjJBrcSJ8FzTjUlfAs3pgZbxfG8=;
        b=Wh1Glp9ygx2r9OXkHTjS+V4Pv/2+z/wJGZFv5S7EHNe5j2OeCowimjTpBaP/ASvMZH
         X4YO5NmAznM2ORBISm4MOpx1IKuyLIGo3iZ63pjrXjE7vOkmcV3EBEGm1eBoe65jH6Z3
         8QuCSRrEL2XU2VQbQ/oizInpFzTQIO9acyMd4PdKdjj15Lzl7pqeySNiksm6C91R9+YB
         T4jLlq6IXBHahzkYPhndmgerMaepeHtZT9sW2znnY9/F5FpYuPeG2qCUU+mVL3xMNk89
         pgtC4o4inI1SfH13Pmlm1QTi9NAdDvjLFmO8NRRh+9iMD3BGOfrAhEcObCaD5xxQgYWE
         +2qQ==
X-Gm-Message-State: AOJu0YzDyx7pq2eGHPd5IgxKZKcgH5OsUqRWRE5Tz1R6hIJDLd8NynC4
	b+zdXeiBBmLlV4sl7W4n9eruKA==
X-Google-Smtp-Source: AGHT+IGygOdS0FDYG0MeUfrKyvdo448ZeERsKbGVJU3tooOdVfsvGLB+9h5K3ZINX8K1tfa6iwgshw==
X-Received: by 2002:a05:6a00:10d2:b0:6cb:4bd5:a4c5 with SMTP id d18-20020a056a0010d200b006cb4bd5a4c5mr20961101pfu.9.1701227085930;
        Tue, 28 Nov 2023 19:04:45 -0800 (PST)
Received: from smtp.gmail.com ([2620:15c:11a:201:d7b2:b65d:af69:8a53])
        by smtp.gmail.com with ESMTPSA id u12-20020a056a00098c00b006cd88728572sm4847426pfg.211.2023.11.28.19.04.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Nov 2023 19:04:45 -0800 (PST)
From: Stephen Boyd <swboyd@chromium.org>
To: Andy Gross <agross@kernel.org>,
	Bjorn Andersson <andersson@kernel.org>
Cc: linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	linux-arm-msm@vger.kernel.org,
	Rob Herring <robh+dt@kernel.org>,
	devicetree@vger.kernel.org,
	Alexandre TORGUE <alexandre.torgue@foss.st.com>,
	Yanteng Si <siyanteng@loongson.cn>,
	Jonathan Corbet <corbet@lwn.net>,
	Douglas Anderson <dianders@chromium.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Subject: [PATCH v2] dt-bindings: arm: qcom: Fix html link
Date: Tue, 28 Nov 2023 19:04:41 -0800
Message-ID: <20231129030443.2753833-1-swboyd@chromium.org>
X-Mailer: git-send-email 2.43.0.rc1.413.gea7ed67945-goog
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This link got broken by commit e790a4ce5290 ("arm: docs: Move Arm
documentation to Documentation/arch/") when the doc moved from arm/ to
arch/arm/. Fix the link so that it can continue to be followed.

Fixes: e790a4ce5290 ("arm: docs: Move Arm documentation to Documentation/arch/")
Cc: Alexandre TORGUE <alexandre.torgue@foss.st.com>
Cc: Yanteng Si <siyanteng@loongson.cn>
Cc: Jonathan Corbet <corbet@lwn.net>
Reviewed-by: Douglas Anderson <dianders@chromium.org>
Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Stephen Boyd <swboyd@chromium.org>
---

Please land this through qcom tree.

Changes from v1 (https://lore.kernel.org/r/20231128002052.2520402-1-swboyd@chromium.org):
 * Pick up tags

 Documentation/devicetree/bindings/arm/qcom.yaml | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/arm/qcom.yaml b/Documentation/devicetree/bindings/arm/qcom.yaml
index 7f80f48a0954..8a6466d1fc4e 100644
--- a/Documentation/devicetree/bindings/arm/qcom.yaml
+++ b/Documentation/devicetree/bindings/arm/qcom.yaml
@@ -138,7 +138,7 @@ description: |
   There are many devices in the list below that run the standard ChromeOS
   bootloader setup and use the open source depthcharge bootloader to boot the
   OS. These devices do not use the scheme described above. For details, see:
-  https://docs.kernel.org/arm/google/chromebook-boot-flow.html
+  https://docs.kernel.org/arch/arm/google/chromebook-boot-flow.html
 
 properties:
   $nodename:

base-commit: b85ea95d086471afb4ad062012a4d73cd328fa86
-- 
https://chromeos.dev

