Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30DE237B
	for <patches@lists.linux.dev>; Tue, 28 Nov 2023 00:20:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="OQ+d1Pak"
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-1ce28faa92dso37136405ad.2
        for <patches@lists.linux.dev>; Mon, 27 Nov 2023 16:20:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1701130854; x=1701735654; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=b9LcCMDmTSdehjuq3j0tEJnIQIb6+TDJYhvhvJwU+wo=;
        b=OQ+d1PakwY6Tx8o3qKhPKMVuLj4xGnhrsnDhM6UIoIwCo4UghrBBCU8DNfbvbiHpwc
         53FRXtd98DYRt/J6dCjX3GR1f20ymMG3AljS5VtO6EprPwUt++IgveB+GxsL0jIClXKB
         8efyYJps21GEGdtxZkxHFhOp1QDn6dQfizcnE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701130854; x=1701735654;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=b9LcCMDmTSdehjuq3j0tEJnIQIb6+TDJYhvhvJwU+wo=;
        b=VIRuvMB/n4xy4AZNGYQtfr6b/Xd25DBC5bMOMtDcySSDXwzhf+gDIGPUnoLoD1s4aj
         91nbZPR02XTlexZwXQPSmLmRIzuKrs+DUORZxxm3HYOaAKyda3HSOrCk7Psx83W0dyPn
         Dj6iNAZJwrGFBVhEBbYs0jI93yXbuOChw+2h+IS+7y7h0f4KuRdTomEHRB2g4v2yt3IU
         rPD9MZpgJK0U2Ick/T0iB05wGP8osXNVCUc+N8JGPF2DKuf9T4CjYuzP7jvyX/NKZ2ap
         zzUus5FOI9O/m88r4Yj9Kb7JV4JGbKDQGGIZmM4NZyiIOleLZob+hdUpZg68/32meuml
         8wQA==
X-Gm-Message-State: AOJu0Yx2yyriDKemus6/ht1qjJLO83/J+uqL6CWfPeDY8jUmSTklPoPM
	kfh+G2EGxlmYr1nta0HDBLTuPw==
X-Google-Smtp-Source: AGHT+IGFzSIOfg8sKm6Au/0ACHEqu0Oge23/jZd49oSPNDz1XcwfEzxfUkI9Gck94hxyHvZcKR6OQQ==
X-Received: by 2002:a17:902:d303:b0:1cc:2f70:4865 with SMTP id b3-20020a170902d30300b001cc2f704865mr12921138plc.26.1701130854419;
        Mon, 27 Nov 2023 16:20:54 -0800 (PST)
Received: from smtp.gmail.com ([2620:15c:11a:201:6438:b5d1:198e:8bb0])
        by smtp.gmail.com with ESMTPSA id c5-20020a170902d90500b001c60c3f9508sm8878786plz.230.2023.11.27.16.20.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Nov 2023 16:20:54 -0800 (PST)
From: Stephen Boyd <swboyd@chromium.org>
To: Rob Herring <robh+dt@kernel.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>
Cc: linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	devicetree@vger.kernel.org,
	Alexandre TORGUE <alexandre.torgue@foss.st.com>,
	Yanteng Si <siyanteng@loongson.cn>,
	Jonathan Corbet <corbet@lwn.net>,
	Bjorn Andersson <andersson@kernel.org>,
	Douglas Anderson <dianders@chromium.org>
Subject: [PATCH] dt-bindings: arm: qcom: Fix html link
Date: Mon, 27 Nov 2023 16:20:51 -0800
Message-ID: <20231128002052.2520402-1-swboyd@chromium.org>
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
Cc: Bjorn Andersson <andersson@kernel.org>
Cc: Douglas Anderson <dianders@chromium.org>
Signed-off-by: Stephen Boyd <swboyd@chromium.org>
---
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

