Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A599719F121
	for <patches@lists.linux.dev>; Wed,  8 Jan 2025 01:28:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736299734; cv=none; b=b4MXRrmK2mv5U/DN5dYO0AkhLhVvNqQ3JHipinAU8XVSbNXU4zlgQCmE0ASyoBN/JYhGqT/3QvmMIBD72zQP5oj/Kh+rhIPzN4IP+vjr5Sk5IbeTXOFLTR0Yvxnfre3LHn2osA0CjKhlDOCF5bBwqDTOCHXmdu/64S2RtstrNBY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736299734; c=relaxed/simple;
	bh=HLeXh7e3GjhFtwyj5udajVxpHq3OwLVCrig2Syvg2OQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mC3vdGptHNM4PIUmlHykA0L8cIU8UbZ0zv4RV42FtMjJvtkZigmRjhm3KwlPpomm/LMvVqZ89ACHMchlYHj+rAPt1tXwQlDioXIG+b82NOYpxc+pvSy40PjCUdwP8F+3RT/GI7KhW8xW6OCQH+VKARi2gWksda5mNUn3cFQetBM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=dmG5pajL; arc=none smtp.client-ip=209.85.216.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="dmG5pajL"
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-2f4409fc8fdso548624a91.1
        for <patches@lists.linux.dev>; Tue, 07 Jan 2025 17:28:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1736299732; x=1736904532; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+3OGnfMaF6ttidHVZW35hLDvix/z1ZneywWqGiGVTK0=;
        b=dmG5pajLcXBLdw0V1//4v1EAcp42tVLo1lptrB4AOh3lRRymrci7c95N2/H9Uld620
         JmBReYuQTcAZtH0EfJAGSW2WvGYw2ySJitQXtmjJ/inji3QqX01ZKdTGBF532e32MsWI
         Ba285SkzcrcK8iPA5lP5MAqOintV5NhOuHs2Q=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736299732; x=1736904532;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+3OGnfMaF6ttidHVZW35hLDvix/z1ZneywWqGiGVTK0=;
        b=ub4rtKwUKZK0VmBoD94bE8JIcqelgl1xE4kbAxxlqhYDwcVy7cRwOOM0vF09tPuamo
         VzkWThxLJbR97zT/kVeit1Qu7o1y5TFscsX4qv2sRdNI5N6PC+w1/bpgBN/P0aQGHBg3
         EyeFbJZ7Zp3X/4rgAc9X6KN8Vlnc15wb4MyOhR/eV1ic5WyhQmc0EYBsCvQdVm9FoPXU
         CAnKof4kMNaQMeVAf7zIysZZWVLJgNdMXkcIznJrgWs78L7ZpW2kyc7Fkb4Yopitt5b5
         T1QU7nyDKcL4aUhfDnky2mQV9LeuuLJqPfBSwHjeZh9UUbWtD1xJTNkFNQ1BIU1Chg9s
         GntQ==
X-Forwarded-Encrypted: i=1; AJvYcCWZrCMtfV+KPG9RYporDe1I/QdL1enVZ+t9jOdzdH80Lanfec5ECpoGB81p7GbCWx1iJvVMBzOr@lists.linux.dev
X-Gm-Message-State: AOJu0Ywvoqq25vykXNH8GcK1yYOdpVXezTrtleHsQ3qudlrRIb0ikWxm
	y1ikqRd6erv7RHna64y6xRZLLwG8YHNlp+/H4U5lkCWTx1kwtfeW5bpFuNLr6A==
X-Gm-Gg: ASbGncvsX0hJSKmfuH8hJWXKgzivAfGxPCLAL3Qd6y2rSbpl+ac9H/QvCaCUPCVdf1A
	RkJwtlMu0woln9STDVSgjc7HNra4df58LyST68W9e+xAvp3FryyYakjg8tzbBo0vRIfzJ6YxEVN
	mkM/PLEEP0zo0L8cJ4Ne0ghfaQ5AuGF8jFy+GfRKgHyBzl5VO2+PphcvJGTqmdpuXpZKUKpup9y
	tQtcLbk429ye2h4KePc1THC8rEX7uasSsJJzWukhPzM4hr1yGwy6qjaC4JYkN4yw5FLklDpWD7L
	OXmkjmFQTPqYzR54qDIT
X-Google-Smtp-Source: AGHT+IGRIU+NqXGlb71FFJypyGjyxuINnxFY9kBScDBRLLqASUBsZ/TtCxmB7qxtQamZfY7V7xiN8A==
X-Received: by 2002:a17:90b:2705:b0:2ef:949c:6f6b with SMTP id 98e67ed59e1d1-2f53cc6e0e4mr8060729a91.13.1736299732138;
        Tue, 07 Jan 2025 17:28:52 -0800 (PST)
Received: from localhost (129.135.125.34.bc.googleusercontent.com. [34.125.135.129])
        by smtp.gmail.com with UTF8SMTPSA id 98e67ed59e1d1-2f54a287254sm196478a91.20.2025.01.07.17.28.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Jan 2025 17:28:51 -0800 (PST)
From: Stephen Boyd <swboyd@chromium.org>
To: Bjorn Andersson <andersson@kernel.org>,
	Konrad Dybcio <konradybcio@kernel.org>
Cc: linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	devicetree@vger.kernel.org,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
	Rob Herring <robh@kernel.org>,
	linux-arm-msm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Arnd Bergmann <arnd@arndb.de>,
	Conor Dooley <conor+dt@kernel.org>,
	Saravana Kannan <saravanak@google.com>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@baylibre.com>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>
Subject: [RFC PATCH 2/6] dt-bindings: bus: Add qcom,soc-sc7180 SoC
Date: Tue,  7 Jan 2025 17:28:39 -0800
Message-ID: <20250108012846.3275443-3-swboyd@chromium.org>
X-Mailer: git-send-email 2.47.1.613.gc27f4b7a9f-goog
In-Reply-To: <20250108012846.3275443-1-swboyd@chromium.org>
References: <20250108012846.3275443-1-swboyd@chromium.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Document the Qualcomm SC7180 System on a Chip (SoC). This SoC is made up
of multiple devices that have their own bindings, therefore this binding
is for a "bus" that is the SoC node.

TODO: Document all child nodes. This is woefully incomplete but at least
shows what is involved with describing an SoC node in dt schema.

Cc: Rob Herring <robh@kernel.org>
Cc: Krzysztof Kozlowski <krzk+dt@kernel.org>
Cc: Conor Dooley <conor+dt@kernel.org>
Cc: <devicetree@vger.kernel.org>
Cc: Bjorn Andersson <andersson@kernel.org>
Cc: Konrad Dybcio <konradybcio@kernel.org>
Cc: <linux-arm-msm@vger.kernel.org>
Signed-off-by: Stephen Boyd <swboyd@chromium.org>
---
 .../bindings/bus/qcom,soc-sc7180.yaml         | 76 +++++++++++++++++++
 1 file changed, 76 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/bus/qcom,soc-sc7180.yaml

diff --git a/Documentation/devicetree/bindings/bus/qcom,soc-sc7180.yaml b/Documentation/devicetree/bindings/bus/qcom,soc-sc7180.yaml
new file mode 100644
index 000000000000..56f8b75ecdab
--- /dev/null
+++ b/Documentation/devicetree/bindings/bus/qcom,soc-sc7180.yaml
@@ -0,0 +1,76 @@
+# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/bus/qcom,soc-sc7180.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: Qualcomm SC7180 SoC
+
+maintainers:
+  - Bjorn Andersson <andersson@kernel.org>
+  - Konrad Dybcio <konradybcio@kernel.org>
+
+description:
+  Qualcomm's SC7180 System on a Chip (SoC).
+
+properties:
+  compatible:
+    items:
+      - const: qcom,soc-sc7180
+      - const: simple-bus
+
+  '#address-cells':
+    const: 2
+
+  '#size-cells':
+    const: 2
+
+  clock-controller@100000:
+    $ref: /schemas/clock/qcom,gcc-sc7180.yaml#
+
+  watchdog@17c10000:
+    $ref: /schemas/watchdog/qcom-wdt.yaml#
+
+required:
+  - compatible
+  - '#address-cells'
+  - '#size-cells'
+  - clock-controller@100000
+  - watchdog@17c10000
+
+additionalProperties: false
+
+examples:
+  - |
+    #include <dt-bindings/gpio/gpio.h>
+    #include <dt-bindings/interrupt-controller/irq.h>
+    #include <dt-bindings/interrupt-controller/arm-gic.h>
+
+    soc {
+        #address-cells = <2>;
+        #size-cells = <2>;
+        compatible = "qcom,soc-sc7180", "simple-bus";
+
+        // TODO: Is it possible to ignore the details?
+        clock-controller@100000 {
+          compatible = "qcom,gcc-sc7180";
+          reg = <0 0x00100000 0 0x1f0000>;
+          clocks = <&rpmhcc_RPMH_CXO_CLK>,
+                   <&rpmhcc_RPMH_CXO_CLK_A>,
+                   <&sleep_clk>;
+          clock-names = "bi_tcxo", "bi_tcxo_ao", "sleep_clk";
+          #clock-cells = <1>;
+          #reset-cells = <1>;
+          #power-domain-cells = <1>;
+          power-domains = <&rpmhpd_SC7180_CX>;
+        };
+
+        watchdog@17c10000 {
+          compatible = "qcom,apss-wdt-sc7180", "qcom,kpss-wdt";
+          reg = <0 0x17c10000 0 0x1000>;
+          clocks = <&sleep_clk>;
+          interrupts = <GIC_SPI 0 IRQ_TYPE_EDGE_RISING>;
+        };
+    };
+
+...
-- 
https://chromeos.dev

